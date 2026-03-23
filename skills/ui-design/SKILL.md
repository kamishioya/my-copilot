---
name: ui-design
description: 'UI/UXの設計・レビュー・改善時に使用する。アクセシビリティ、レスポンシブデザイン、コンポーネント設計、ビジュアルデザイン原則、インタラクションパターンを包括的にカバー。Web（React）とモバイル（.NET MAUI）の両方に対応。'
---

# UI/UX デザインガイドライン

## 概要

ユーザーインターフェースの品質を体系的に向上させるための設計原則とレビュー基準。
Webアプリケーション（React）とモバイルアプリ（.NET MAUI）の両方に適用可能。

**核心原則:** ユーザーが考えなくて済むインターフェースが最高のインターフェース。

## Web Interface Guidelines 参照

`skills/ui-design/reference/web-interface-guidelines.md` に Vercel の Web Interface Guidelines レビュースキルが格納されている。
UIレビュー時には、この参照元と本スキルの両方を適用すること。

ガイドラインの最新版は以下URLからもフェッチ可能:
```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

---

## 1. デザインの基本原則

### 1.1 視覚階層（Visual Hierarchy）
- **サイズ**: 重要な要素ほど大きく表示
- **コントラスト**: 重要な要素ほど高コントラスト
- **間隔**: 関連する要素はグループ化し、無関連要素は離す（近接の法則）
- **色彩**: アクションに一貫した色を使用（プライマリ/セカンダリ/デストラクティブ）
- **位置**: 重要な要素は視線の流れに沿って配置（Fパターン/Zパターン）

### 1.2 一貫性（Consistency）
- 同じアクションには同じUIパターンを使用
- 間隔・サイズは4px/8pxグリッドシステムに基づく
- アイコンスタイルの統一（線画/塗り/サイズ）
- フォントファミリーは最大2-3種類
- コンポーネントの振る舞いは予測可能であること

### 1.3 フィードバック（Feedback）
- **即時応答**: すべてのユーザー操作に対して即座のフィードバック
- **ローディング状態**: スケルトンスクリーンまたはスピナーを表示
- **成功/失敗**: トースト通知やインラインメッセージで明示
- **進行状況**: 時間がかかる操作にはプログレスバー
- **楽観的更新**: ネットワーク応答を待たずUIを即座に更新し、失敗時にロールバック

### 1.4 可逆性（Forgiveness）
- 重要な操作には確認ダイアログ
- 可能な限り「元に戻す」機能を提供
- 破壊的操作は赤色+確認ステップ
- フォームの自動保存

---

## 2. レスポンシブデザイン

### ブレークポイント標準
```css
/* モバイル(デフォルト) → タブレット → デスクトップ */
/* sm: 640px, md: 768px, lg: 1024px, xl: 1280px, 2xl: 1536px */
```

### 原則
- **モバイルファースト**: 最小画面からデザインし、拡大していく
- **コンテンツ優先**: レイアウトではなくコンテンツに基づいてブレークポイントを決定
- **タッチターゲット**: 最小44×44px（モバイル）、32×32px（デスクトップ）
- **流動的タイポグラフィ**: `clamp()` で画面サイズに応じたフォントサイズ
- **画像**: `srcset` と `sizes` でレスポンシブ画像を提供
- **テスト**: 実デバイスまたはエミュレータで確認

### レイアウトパターン
| パターン | 用途 |
|----------|------|
| スタック（縦積み） | モバイルのデフォルト |
| サイドバー + コンテンツ | ダッシュボード、管理画面 |
| グリッド（自動フィル） | カード一覧、ギャラリー |
| 分割ビュー | マスター/ディテール |

---

## 3. アクセシビリティ（WCAG 2.1 AA 準拠）

### 必須チェック項目
- [ ] **カラーコントラスト**: テキスト 4.5:1以上、大テキスト 3:1以上
- [ ] **キーボード操作**: すべての機能がキーボードだけで操作可能
- [ ] **フォーカス表示**: フォーカスリングが視認可能
- [ ] **代替テキスト**: すべての画像に適切な `alt` テキスト
- [ ] **セマンティックHTML**: `<nav>`, `<main>`, `<article>`, `<aside>` 等を適切に使用
- [ ] **ARIA属性**: セマンティックHTMLで不十分な場合のみ使用
- [ ] **スクリーンリーダー**: 動的コンテンツに `aria-live` を使用
- [ ] **フォームラベル**: すべてのフォーム要素に `<label>` を関連付け
- [ ] **エラー識別**: 色だけでなくテキストやアイコンでもエラーを伝達
- [ ] **ズーム対応**: 200%ズームでもレイアウトが崩れない

### アクセシブルなコンポーネントパターン
```tsx
// ✅ セマンティックHTMLを優先
<button onClick={handleClick}>送信</button>

// ❌ div をボタンとして使わない
<div onClick={handleClick} className="button">送信</div>
```

```tsx
// ✅ モーダルのアクセシビリティ
<dialog
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
>
  <h2 id="dialog-title">確認</h2>
  {/* コンテンツ */}
</dialog>
```

---

## 4. コンポーネント設計パターン

### 4.1 Atomic Design
| レベル | 定義 | 例 |
|--------|------|-----|
| Atoms | 最小のUI要素 | Button, Input, Label, Icon |
| Molecules | Atomsの組み合わせ | SearchBar, FormField |
| Organisms | Moleculesの複合体 | Header, ProductCard, LoginForm |
| Templates | ページレイアウト | DashboardLayout, AuthLayout |
| Pages | 具体的なデータを持つ画面 | HomePage, SettingsPage |

### 4.2 コンポーネント設計原則
- **単一責任**: 1コンポーネント = 1つの明確な責務
- **Composition over Props**: 多数のpropsより合成パターンを優先
- **制御と非制御**: フォーム要素は制御コンポーネントをデフォルトに
- **バリアント**: サイズ・色・形状はバリアントpropsで管理
- **スロット**: 柔軟なレイアウトには children やスロットパターンを使用

```tsx
// ✅ Composition パターン
<Card>
  <Card.Header>タイトル</Card.Header>
  <Card.Body>コンテンツ</Card.Body>
  <Card.Footer>
    <Button variant="primary">保存</Button>
  </Card.Footer>
</Card>

// ❌ Props過多
<Card
  title="タイトル"
  body="コンテンツ"
  footerButtonText="保存"
  footerButtonVariant="primary"
  onFooterButtonClick={handleSave}
/>
```

### 4.3 状態とインタラクション
すべてのインタラクティブ要素は以下の状態を持つ:
```
Default → Hover → Active/Pressed → Focus → Disabled → Loading → Error → Success
```

---

## 5. タイポグラフィ

### スケール（推奨）
| 用途 | サイズ | 行間 | 太さ |
|------|--------|------|------|
| Hero | 48-72px | 1.1 | Bold |
| H1 | 32-40px | 1.2 | Bold |
| H2 | 24-28px | 1.3 | SemiBold |
| H3 | 20-24px | 1.4 | SemiBold |
| Body | 16px | 1.5-1.6 | Regular |
| Small | 14px | 1.5 | Regular |
| Caption | 12px | 1.4 | Regular |

### 原則
- **読みやすさ最優先**: 1行あたり45-75文字
- **コントラスト**: 本文テキストは背景に対して十分なコントラスト
- **一貫したスケール**: デザイントークンとしてサイズを定義
- **日本語フォント考慮**: Noto Sans JP、BIZ UDGothic 等を推奨

---

## 6. カラーシステム

### トークンベース設計
```css
/* セマンティックカラートークン */
--color-primary:     /* ブランドカラー、主要アクション */
--color-secondary:   /* 補助的なアクション */
--color-success:     /* 成功状態 #16a34a 系 */
--color-warning:     /* 警告状態 #f59e0b 系 */
--color-error:       /* エラー状態 #dc2626 系 */
--color-info:        /* 情報表示 #2563eb 系 */

--color-background:  /* ページ背景 */
--color-surface:     /* カード・パネル背景 */
--color-border:      /* 境界線 */

--color-text-primary:   /* 主要テキスト */
--color-text-secondary: /* 補助テキスト */
--color-text-disabled:  /* 無効テキスト */
```

### 原則
- **60-30-10 ルール**: 背景60%、補助30%、アクセント10%
- **ダーク/ライトモード**: セマンティックトークンを使えば切替が容易
- **色覚多様性**: 色だけで情報を伝達しない（アイコン/テキストを併用）
- **ブランドカラーの一貫性**: プライマリカラーは全画面で統一

---

## 7. スペーシングとレイアウト

### 8pxグリッドシステム
```
4px  (0.25rem) — 微細な間隔
8px  (0.5rem)  — コンパクトな間隔
12px (0.75rem) — 小さな間隔
16px (1rem)    — 標準間隔
24px (1.5rem)  — 中間隔
32px (2rem)    — 大きな間隔
48px (3rem)    — セクション間隔
64px (4rem)    — ページセクション間隔
```

### 原則
- **一貫性**: 間隔値はグリッドシステムの倍数のみ使用
- **密度の調整**: 情報密度に応じてspacingバリアントを用意（compact/default/comfortable）
- **余白**: 十分なホワイトスペースで読みやすさを確保
- **グルーピング**: 関連要素は近接させ、無関連要素は離す

---

## 8. アニメーションとトランジション

### 原則
- **目的を持つ**: 装飾のためではなく、意味を伝えるために使用
- **速すぎず遅すぎず**: 100-500msの範囲（一般的に150-300ms）
- **イージング**: `ease-out`（要素の出現時）、 `ease-in`（要素の退場時）
- **ユーザー設定を尊重**: `prefers-reduced-motion` に対応

```css
/* アクセシビリティ対応 */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

### 標準トランジション
| 操作 | 推奨duration | 推奨easing |
|------|-------------|-----------|
| ホバー効果 | 150ms | ease |
| モーダル表示 | 200-300ms | ease-out |
| ページ遷移 | 300-500ms | ease-in-out |
| ドロップダウン | 150-200ms | ease-out |
| トースト表示 | 200ms | ease-out |

---

## 9. フォーム設計

### 原則
- **ラベルは常に表示**: placeholder をラベル代わりにしない
- **インラインバリデーション**: フィールドからフォーカスが外れた時に検証
- **エラーメッセージ**: フィールド直下に赤色テキストで表示
- **必須/任意の明示**: 必須フィールドには `*` マーク
- **適切な入力タイプ**: `type="email"`, `type="tel"`, `inputmode="numeric"` 等
- **オートコンプリート**: `autocomplete` 属性で入力補助
- **送信ボタン**: 無効化よりもエラー表示を優先

```tsx
// ✅ 良いフォームフィールド
<div className="form-field">
  <label htmlFor="email">
    メールアドレス <span aria-hidden="true">*</span>
  </label>
  <input
    id="email"
    type="email"
    autocomplete="email"
    aria-required="true"
    aria-invalid={!!error}
    aria-describedby={error ? 'email-error' : undefined}
  />
  {error && (
    <p id="email-error" role="alert" className="error">
      {error}
    </p>
  )}
</div>
```

---

## 10. モバイル固有の考慮事項（.NET MAUI）

### プラットフォームガイドライン
- **iOS**: Human Interface Guidelines に準拠
- **Android**: Material Design 3 に準拠
- **共通**: プラットフォーム固有のUI規約を尊重しつつ、ブランドの一貫性を保つ

### モバイルUI原則
- **親指ゾーン**: 重要なアクションは画面下部に配置
- **ジェスチャー**: スワイプ、長押し等のネイティブジェスチャーを活用
- **セーフエリア**: ノッチ、ステータスバー、ホームバーを考慮
- **テキストサイズ**: 最小14sp（Android）/ 17pt（iOS）
- **タッチターゲット**: 最小48×48dp

### .NET MAUI 固有のTips
- `Shell` を使ったナビゲーション構成
- プラットフォーム別のスタイル適用（`OnPlatform`）
- `CollectionView` のパフォーマンス最適化（`DataTemplate` のリサイクル）
- アクセシビリティ: `SemanticProperties` の適切な設定

---

## 11. レビューチェックリスト

### 🔴 CRITICAL
- [ ] インタラクティブ要素のタッチ/クリックターゲットが十分か
- [ ] カラーコントラストがWCAG AA基準を満たすか
- [ ] キーボードだけで全操作が可能か
- [ ] 破壊的操作に確認ステップがあるか

### 🟡 IMPORTANT
- [ ] ローディング状態が適切に表示されるか
- [ ] エラーメッセージがユーザーフレンドリーか
- [ ] レスポンシブデザインが適切に機能するか
- [ ] フォームのバリデーションが適切か
- [ ] 一貫したビジュアルパターンが使われているか

### 🟢 SUGGESTION
- [ ] アニメーションが目的を持っているか
- [ ] スペーシングがグリッドシステムに沿っているか
- [ ] タイポグラフィスケールが一貫しているか
- [ ] ダークモード対応（該当する場合）
