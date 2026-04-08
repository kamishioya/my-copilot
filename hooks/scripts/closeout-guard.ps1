param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('session-start', 'stop')]
    [string]$Mode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-JsonInput {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $null
    }

    return $raw | ConvertFrom-Json
}

function Write-JsonOutput {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Value
    )

    $Value | ConvertTo-Json -Depth 10 -Compress
}

function Get-PropertyValue {
    param(
        [object]$Object,
        [string]$Name
    )

    if ($null -eq $Object) {
        return $null
    }

    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }

    return $property.Value
}

function Normalize-RepoPath {
    param(
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $Path
    }

    return ($Path -replace '\\', '/').Trim()
}

function Resolve-CustomizationRoot {
    $candidates = @('.github', '.')

    foreach ($candidate in $candidates) {
        $activeContextPath = if ($candidate -eq '.') { 'memory-bank/activeContext.md' } else { '.github/memory-bank/activeContext.md' }
        $progressPath = if ($candidate -eq '.') { 'memory-bank/progress.md' } else { '.github/memory-bank/progress.md' }

        if ((Test-Path $activeContextPath) -and (Test-Path $progressPath)) {
            return $candidate
        }
    }

    return $null
}

function Get-GitChangedFiles {
    $insideWorkTree = & git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $insideWorkTree.Trim() -ne 'true') {
        return @()
    }

    $lines = & git status --porcelain=v1 --untracked-files=all
    $fileSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $pathText = if ($line.Length -gt 3) { $line.Substring(3).Trim() } else { '' }
        if ($pathText -match ' -> ') {
            $pathText = ($pathText -split ' -> ')[-1]
        }

        $normalized = Normalize-RepoPath -Path $pathText
        if (-not [string]::IsNullOrWhiteSpace($normalized)) {
            [void]$fileSet.Add($normalized)
        }
    }

    return @($fileSet)
}

function Test-AnyPathMatch {
    param(
        [string[]]$ChangedFiles,
        [string[]]$Prefixes,
        [string[]]$ExactPaths
    )

    foreach ($file in $ChangedFiles) {
        foreach ($exactPath in $ExactPaths) {
            if ($file -ieq $exactPath) {
                return $true
            }
        }

        foreach ($prefix in $Prefixes) {
            if ($file.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                return $true
            }
        }
    }

    return $false
}

function Get-CloseoutContext {
    $root = Resolve-CustomizationRoot
    $basePrefix = if ($root -eq '.github') { '.github/' } else { '' }

    $activeContextPath = "${basePrefix}memory-bank/activeContext.md"
    $progressPath = "${basePrefix}memory-bank/progress.md"

    return [pscustomobject]@{
        CustomizationRoot = $root
        BasePrefix = $basePrefix
        ActiveContextPath = $activeContextPath
        ProgressPath = $progressPath
        DocsPrefixes = @("${basePrefix}docs/")
        MemoryPrefixes = @("${basePrefix}memory-bank/")
        ReadmePaths = @('README.md', "${basePrefix}README.md")
    }
}

$payload = Get-JsonInput
$context = Get-CloseoutContext

if ($Mode -eq 'session-start') {
    if ($null -eq $context.CustomizationRoot) {
        Write-JsonOutput -Value @{ }
        exit 0
    }

    $additionalContext = @(
        'When MemoryBank files exist in this repo, treat activeContext.md and progress.md as the authoritative source.',
        'For code or behavior changes, decide whether docs/spec, docs/design, docs/plan, README, and MemoryBank must be updated.',
        'If no documents are updated, record the reason in MemoryBank and in the final answer.'
    ) -join ' '

    Write-JsonOutput -Value @{
        hookSpecificOutput = @{
            hookEventName = 'SessionStart'
            additionalContext = $additionalContext
        }
    }
    exit 0
}

$stopHookActive = Get-PropertyValue -Object $payload -Name 'stop_hook_active'
if ($stopHookActive -eq $true) {
    Write-JsonOutput -Value @{ }
    exit 0
}

$changedFiles = Get-GitChangedFiles
if ($changedFiles.Count -eq 0) {
    Write-JsonOutput -Value @{ }
    exit 0
}

if ($null -eq $context.CustomizationRoot) {
    Write-JsonOutput -Value @{
        systemMessage = 'closeout-guard: skipped because no MemoryBank files were found.'
    }
    exit 0
}

$docLikePrefixes = @($context.DocsPrefixes + $context.MemoryPrefixes)
$docLikeExactPaths = @($context.ReadmePaths)

$requiresCloseout = $false
foreach ($file in $changedFiles) {
    $isDocLike = $false

    foreach ($exactPath in $docLikeExactPaths) {
        if ($file -ieq $exactPath) {
            $isDocLike = $true
            break
        }
    }

    if (-not $isDocLike) {
        foreach ($prefix in $docLikePrefixes) {
            if ($file.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
                $isDocLike = $true
                break
            }
        }
    }

    if (-not $isDocLike) {
        $requiresCloseout = $true
        break
    }
}

if (-not $requiresCloseout) {
    Write-JsonOutput -Value @{ }
    exit 0
}

$activeContextChanged = $false
$progressChanged = $false
foreach ($file in $changedFiles) {
    if ($file -ieq $context.ActiveContextPath) {
        $activeContextChanged = $true
    }
    if ($file -ieq $context.ProgressPath) {
        $progressChanged = $true
    }
}

if (-not $activeContextChanged -or -not $progressChanged) {
    Write-JsonOutput -Value @{
        hookSpecificOutput = @{
            hookEventName = 'Stop'
            decision = 'block'
            reason = "Important changes are still pending. Update $($context.ActiveContextPath) and $($context.ProgressPath) before finishing."
        }
    }
    exit 0
}

$docsChanged = Test-AnyPathMatch -ChangedFiles $changedFiles -Prefixes $context.DocsPrefixes -ExactPaths $context.ReadmePaths

if (-not $docsChanged) {
    Write-JsonOutput -Value @{
        systemMessage = 'closeout-guard: if related documents were not updated, explain why in the final answer.'
    }
    exit 0
}

Write-JsonOutput -Value @{ }