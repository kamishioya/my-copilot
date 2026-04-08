#  汎用 Code as Doc テンプレート

AI駆動開発のための `.github` フォルダテンプレートです。

## フォルダ構成

```
my-copilot/
├── copilot-instructions.md          # 🎯 汎用AI指示書（プロジェクト全体のルール）
│
├── docs/                            # 📄 プログラム仕様書・設計書
│   ├── spec/                        #    仕様書（AI最適化フォーマット）
│   ├── design/                      #    設計書・アーキテクチャ決定記録
│   └── plan/                        #    実装計画書
│
├── db/                              # 🗄️ データベース関連
│   ├── tables/                      #    テーブル定義（CREATE TABLE文）
│   ├── stored-procedures/           #    ストアドプロシージャ
│   ├── views/                       #    ビュー定義
│   └── migrations/                  #    マイグレーションスクリプト
│
├── skills/                          # 🛠️ AIスキル定義
│   ├── commenting/SKILL.md          #    コメント運用（WHY重視・日本語コメント）
│   ├── create-spec/SKILL.md         #    仕様書作成
│   ├── create-plan/SKILL.md         #    実装計画作成
│   ├── context-map/SKILL.md         #    コンテキストマップ（影響範囲分析）
│   ├── design-sync/SKILL.md         #    既存仕様書・設計書の差分同期
│   ├── code-review/SKILL.md         #    コードレビュー
│   ├── sql-review/SKILL.md          #    SQLレビュー
│   ├── refactor/SKILL.md            #    リファクタリング
│   ├── git-commit/SKILL.md          #    Gitコミット（Conventional Commits）
│   └── doc-writer/SKILL.md          #    ドキュメント作成（Diátaxisフレームワーク）
│
├── instructions/                    # 📏 自動適用されるコーディング規約
│   ├── security.instructions.md     #    OWASP準拠セキュリティガイドライン
│   ├── commenting.instructions.md   #    コメント運用ルール
│   ├── code-review.instructions.md  #    コードレビュー基準
│   └── update-docs.instructions.md  #    ドキュメント同期更新ルール
│
├── hooks/                           # 🪝 実行時フック
│   ├── closeout-guard.json          #    終了前の closeout 検査
│   └── scripts/
│       └── closeout-guard.ps1       #    MemoryBank / docs 更新のガード
│
├── agents/                          # 🤖 カスタムエージェント
│   ├── debug.agent.md               #    デバッグモード（体系的バグ解決）
│   ├── architect.agent.md           #    アーキテクト（設計・図面のみ、コード生成なし）
│   └── critical-thinking.agent.md   #    クリティカルシンキング（前提検証）
│
├── memory-bank/                     # 🧠 プロジェクト記憶（セッション間持続）
│   ├── projectbrief.md              #    プロジェクト概要
│   ├── activeContext.md             #    現在の作業コンテキスト
│   ├── systemPatterns.md            #    アーキテクチャ・設計パターン
│   ├── techContext.md               #    技術スタック・環境情報
│   ├── progress.md                  #    進捗状況・既知の問題
│   └── tasks/                       #    タスク管理
│       └── _index.md                #    タスクインデックス
```

## 使い方

### 1. プロジェクトにコピー
この `MyCopilot` フォルダの内容を、対象プロジェクトの `.github` フォルダとしてコピーします。

### 2. memory-bank を初期化
`memory-bank/projectbrief.md` にプロジェクトの概要を記入します。  
`memory-bank/techContext.md` に技術スタック情報を記入します。

### 3. 開発ワークフロー

| やること | 使うもの |
|---------|---------|
| 新機能の仕様作成 | `create-spec` スキル → `docs/spec/` |
| 実装計画の作成 | `create-plan` スキル → `docs/plan/` |
| 実装前の影響範囲分析 | `context-map` スキル |
| 既存仕様書・設計書の差分同期 | `design-sync` スキル |
| アーキテクチャ設計 | `architect` エージェント → `docs/design/` |
| コード実装時のコメント品質統一 | `commenting` スキル |
| コードレビュー | `code-review` スキル |
| SQLレビュー | `sql-review` スキル |
| リファクタリング | `refactor` スキル |
| Gitコミット | `git-commit` スキル |
| ドキュメント作成 | `doc-writer` スキル |
| デバッグ | `debug` エージェント |
| アプローチ検証 | `critical-thinking` エージェント |

## hooks について

- このテンプレートは、対象プロジェクトの `.github/` としてコピーして使う前提です
- `hooks/closeout-guard.json` は、コピー後に `.github/hooks/closeout-guard.json` として読み込まれます
- Stop hook は、重要な変更があるのに MemoryBank の `activeContext.md` と `progress.md` が未更新なら終了をブロックします
- docs を更新しない場合は hook だけでは完全判定できないため、instructions と skills で更新要否を判定し、final answer に未更新理由を残します
