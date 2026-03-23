---
name: test-driven-development
description: '機能実装やバグ修正の前にテストを書く。RED-GREEN-REFACTORサイクルに従い、テストなしの本番コードを禁止する。.NET (xUnit/NUnit)、React (Vitest/Jest)、MAUI対応。'
---

# テスト駆動開発（TDD）

## 概要

テストを先に書く。失敗を確認する。最小限のコードで通す。

**核心原則:** テストが失敗するのを見ていなければ、正しいものをテストしているか分からない。

## 使用場面

**常に使用:**
- 新機能の実装
- バグ修正
- リファクタリング
- 動作変更

**例外（ユーザーに確認）:**
- 使い捨てプロトタイプ
- 自動生成コード
- 設定ファイル

## 鉄則（Iron Law）

```
テストなしの本番コードは禁止
```

テストより先にコードを書いた場合 → **削除して最初からやり直す**。

- 「参考」として残さない
- テストを書きながら「適応」しない
- 見ない
- 削除は削除

## RED-GREEN-REFACTOR サイクル

### RED — 失敗するテストを書く

一つの振る舞いを示す最小のテストを書く。

#### .NET (xUnit) の例

```csharp
// ✅ 良い例: 明確な名前、一つの振る舞い、実コードをテスト
[Fact]
public async Task RetryOperation_RetriesFailedOperations3Times()
{
    var attempts = 0;
    var operation = () =>
    {
        attempts++;
        if (attempts < 3) throw new InvalidOperationException("fail");
        return Task.FromResult("success");
    };

    var result = await RetryHelper.ExecuteAsync(operation);

    Assert.Equal("success", result);
    Assert.Equal(3, attempts);
}
```

```csharp
// ❌ 悪い例: 曖昧な名前、モックの動作をテスト
[Fact]
public async Task RetryWorks()
{
    var mock = new Mock<IOperation>();
    mock.SetupSequence(x => x.Execute())
        .ThrowsAsync(new Exception())
        .ThrowsAsync(new Exception())
        .ReturnsAsync("success");
    await RetryHelper.ExecuteAsync(mock.Object.Execute);
    mock.Verify(x => x.Execute(), Times.Exactly(3));
}
```

#### React (Vitest) の例

```typescript
// ✅ 良い例
test('空のメールを拒否する', async () => {
  const result = await submitForm({ email: '' });
  expect(result.error).toBe('メールアドレスは必須です');
});
```

**要件:**
- 一つの振る舞い
- 明確な名前（何をテストしているか説明的）
- 実コードを使用（モックは避けられない場合のみ）

### RED を検証 — 失敗を確認する

**必須。絶対にスキップしない。**

```bash
# .NET
dotnet test --filter "RetryOperation_RetriesFailedOperations3Times"

# React
npx vitest run path/to/test.test.ts
```

確認事項:
- テストが失敗する（エラーではなく）
- 失敗メッセージが期待通り
- 機能が未実装だから失敗する（タイポではなく）

**テストが通った場合** → 既存の動作をテストしている。テストを修正する。

### GREEN — 最小限のコードを書く

テストを通すための最もシンプルなコードを書く。

```csharp
// ✅ 良い例: テストを通すのに十分なだけ
public static async Task<T> ExecuteAsync<T>(Func<Task<T>> fn)
{
    for (int i = 0; i < 3; i++)
    {
        try { return await fn(); }
        catch when (i < 2) { }
    }
    throw new InvalidOperationException("到達不能");
}
```

```csharp
// ❌ 悪い例: 過剰設計（YAGNI）
public static async Task<T> ExecuteAsync<T>(
    Func<Task<T>> fn,
    RetryOptions? options = null)  // まだ不要
{
    // バックオフ戦略、リトライコールバック... 全部不要
}
```

機能を追加しない。他のコードをリファクタリングしない。テスト範囲を超えた「改善」をしない。

### GREEN を検証 — 成功を確認する

**必須。**

```bash
dotnet test  # 全テスト実行
```

確認事項:
- テストが通る
- 他のテストも通る
- 出力がクリーン（エラー・警告なし）

**テストが失敗** → コードを修正する（テストではない）。

### REFACTOR — クリーンアップ

GREEN の後のみ:
- 重複を除去
- 命名を改善
- ヘルパーを抽出

テストはグリーンを維持する。振る舞いを追加しない。

### 繰り返す

次の機能のための次の失敗するテスト。

## テスト品質基準

| 品質 | 良い | 悪い |
|------|------|------|
| **最小限** | 一つのこと。名前に「と」があれば分割 | `Test_メールとドメインとスペースを検証` |
| **明確** | 名前が振る舞いを説明 | `Test1` |
| **意図を示す** | 望ましいAPIを示す | コードの動作を隠す |

## テスト後に書くことが間違いである理由

- テスト後のテストは即座に通る。即座に通ることは何も証明しない
- 実装に偏ったテストになる（要求をテストしない）
- エッジケースを見落とす
- 「手動でテストした」≠ 体系的テスト

## よくある言い訳と現実

| 言い訳 | 現実 |
|--------|------|
| 「シンプルすぎてテスト不要」 | シンプルなコードも壊れる。テストは30秒で書ける |
| 「後でテストする」 | 即座に通るテストは何も証明しない |
| 「先に動くか確認したい」 | 使い捨てOK。ただし捨てた後にTDDで再実装 |
| 「テストが難しい＝設計が不明確」 | テストしにくい＝使いにくい。設計を改善するシグナル |
| 「TDDは遅い」 | TDDはデバッグより速い |
| 「既存コードにテストがない」 | 改善中。既存コードにもテストを追加する |

## 危険信号 — 停止してやり直す

- テスト前にコードを書いた
- 実装後にテストを書いた
- テストが即座に通った
- テストがなぜ失敗したか説明できない
- 「後で」テストを追加する予定
- 「今回だけ」と合理化している

**上記すべて → コードを削除。TDDでやり直す。**

## テストアンチパターン

### 1. モックの動作をテストする

```csharp
// ❌ モックの存在を検証している
Assert.NotNull(mockSidebar);

// ✅ 実際のコンポーネントの振る舞いをテスト
Assert.Contains("ナビゲーション", renderedOutput);
```

### 2. 本番クラスにテスト専用メソッドを追加する

```csharp
// ❌ テストでしか使わないメソッド
public class Session
{
    public async Task DestroyAsync() { /* テスト用クリーンアップ */ }
}

// ✅ テストユーティリティに移動
public static class TestHelper
{
    public static async Task CleanupSession(Session session) { /* ... */ }
}
```

### 3. 理解せずにモックする

- モック対象の副作用を理解してからモックする
- テストが依存する副作用をモックで消さない
- 「安全のため」にモックしない

### 4. 不完全なモック

- 実際のAPIレスポンスの全フィールドをモックに含める
- 部分的なモックは暗黙の失敗を生む

## .NET / React / MAUI 固有のガイドライン

### .NET (xUnit)
- `[Fact]` で単一テスト、`[Theory]` でパラメータ化テスト
- Arrange-Act-Assert パターンを厳守
- `FluentAssertions` の使用を推奨
- 非同期テストは `async Task` を返す

### React (Vitest / Jest)
- `@testing-library/react` でコンポーネントテスト
- ユーザーの視点でテスト（`getByRole`, `getByText`）
- `userEvent` でユーザーインタラクションをシミュレート
- スナップショットテストよりも振る舞いテストを優先

### .NET MAUI
- ビューモデルの単体テストを優先
- UI ロジックはビューモデルに分離してテスト可能にする
- プラットフォーム依存コードはインターフェースで抽象化

## 検証チェックリスト

作業完了前に確認:

- [ ] 新しい関数/メソッドすべてにテストがある
- [ ] 各テストの失敗を実装前に確認した
- [ ] 各テストが期待通りの理由で失敗した（機能未実装であること）
- [ ] テストを通すための最小限のコードを書いた
- [ ] 全テストが通る
- [ ] 出力がクリーン（エラー・警告なし）
- [ ] 実コードを使用（モックは避けられない場合のみ）
- [ ] エッジケースとエラーケースをカバー

すべてチェックできない場合 → TDDをスキップしている。やり直す。
