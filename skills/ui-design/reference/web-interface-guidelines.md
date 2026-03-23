---
name: web-design-guidelines
description: 日本語UIレビューで使う Web Interface Guidelines 参照資料
metadata:
  author: vercel
  version: "1.1.0-ja"
  source: https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
  last_verified: "2026-03-23"
---

# Web Interface Guidelines 日本語運用版

Vercel の Web Interface Guidelines をベースに、日本語UIレビューで使いやすい形へ整理した参照資料。
React、Next.js、一般的なHTML/CSS実装のレビューに使うことを想定する。

## この文書の目的

- UIレビュー時の確認観点を日本語で素早く参照できるようにする
- 英語UI前提の表現ルールを、日本語プロダクトでも判断しやすい基準へ置き換える
- スキル実行時に、レビュー観点と出力形式を分けて再利用しやすくする

## 使い方

1. 正式レビュー前に原文最新版を取得し、この文書との差分がないか確認する
2. 対象ファイルを読み、カテゴリごとにルール違反を確認する
3. 指摘はファイル単位でまとめ、`file:line` 形式で出力する
4. 修正方針が自明でない場合だけ、短く補足する

## 優先して検出する項目

次の項目は、見つけたら優先度高で指摘する。

- キーボード操作できない操作要素
- ラベルのない入力欄、`aria-label` のないアイコンボタン
- `outline: none` や `outline-none` のみで代替フォーカスがない実装
- `div` や `span` をボタン代わりに使う実装
- 画像サイズ未指定によるCLSリスク
- `transition: all`
- 日付、数値、通貨のハードコード表示
- `user-scalable=no` や `maximum-scale=1` によるズーム禁止

## レビュー観点

### 1. アクセシビリティ

- アイコンのみのボタンには `aria-label` を付ける
- フォーム部品には `<label>` または `aria-label` を付ける
- クリック可能要素がキーボードでも操作できるようにする
- 操作は `<button>`、画面遷移は `<a>` または `<Link>` を使う
- 画像には `alt` を付け、装飾画像は `alt=""` にする
- 装飾アイコンには `aria-hidden="true"` を付ける
- トースト、バリデーション結果、非同期更新には `aria-live="polite"` を検討する
- ARIAより先にセマンティックHTMLを優先する
- 見出しは `<h1>` から `<h6>` を階層順に使う
- メインコンテンツへ飛ぶスキップリンクを用意する
- 見出しアンカーや固定ヘッダー考慮で `scroll-margin-top` を設定する

### 2. フォーカス表示

- すべての操作要素に視認可能なフォーカス表示を用意する
- `outline: none` や `outline-none` を使う場合は同等以上の代替フォーカスを必ず実装する
- クリック時の不要なリングを避けるため、可能なら `:focus-visible` を優先する
- 複合入力では `:focus-within` によるグループ強調を使う

### 3. フォーム

- 入力欄には適切な `autocomplete` と意味のある `name` を付ける
- `email`、`tel`、`url`、`number` など適切な `type` と `inputmode` を使う
- `onPaste` と `preventDefault()` による貼り付け禁止は避ける
- ラベルは `htmlFor` またはラップ構造でクリック可能にする
- メールアドレス、認証コード、ユーザー名では `spellCheck={false}` を検討する
- チェックボックスやラジオは、ラベルを含めて一つの押下領域にする
- 送信ボタンはリクエスト開始までは有効に保ち、開始後にローディング表示へ切り替える
- エラーは入力欄の近くに表示し、送信時は最初のエラーへフォーカスを移す
- プレースホルダーは補助情報として使い、例示が必要なら `…` を使って自然に終える
- 認証以外の項目でパスワードマネージャー誤検知が起きる場合は `autocomplete="off"` を検討する
- 未保存変更がある画面では、離脱前警告やルーターガードを検討する

### 4. アニメーション

- `prefers-reduced-motion` を尊重し、軽減版または無効化を用意する
- アニメーション対象は原則 `transform` と `opacity` に限定する
- `transition: all` は使わず、対象プロパティを明示する
- `transform-origin` を意図どおりに設定する
- SVGの変形は必要に応じて `<g>` ラッパーと `transform-box: fill-box` を使う
- アニメーション中でもユーザー操作で中断できるようにする

### 5. タイポグラフィと文言

- 省略記号は `...` ではなく `…` を使う
- 日本語UIの引用符は `「」` を基本とし、英語引用符の混在を避ける
- ローディング文言は `読み込み中…`、`保存中…` のように状態が即座に分かる形にする
- 数値列の比較や桁揃えが必要な箇所では `font-variant-numeric: tabular-nums` を使う
- 長い見出しは `text-wrap: balance` や同等手段で改行崩れを抑える
- ボタンや見出しは英語のTitle Caseではなく、簡潔で一貫した日本語表現に統一する
- 件数、金額、日付、時間は算用数字を優先し、視認性を上げる
- ボタン文言は `続行` より `APIキーを保存` のように具体化する
- エラーメッセージは問題だけでなく、次に何をすべきかも示す
- 日本語UIでは一人称や過度な主語を避け、短く直接的な表現を優先する
- 横幅が厳しい箇所では `と`、`・`、`/` など短く誤解の少ない区切りを使う

### 6. コンテンツ処理

- 長文は `truncate`、`line-clamp-*`、`break-words` などで壊れないようにする
- Flex子要素で省略表示が必要なら `min-w-0` を忘れない
- 空文字、空配列、未設定値でUIが壊れないようにする
- ユーザー生成コンテンツは短文、平均、長文のすべてを想定する

### 7. 画像

- `<img>` には `width` と `height` を明示する
- ファーストビュー外の画像は `loading="lazy"` を使う
- ファーストビューで重要な画像は `priority` または `fetchpriority="high"` を検討する

### 8. パフォーマンス

- 50件を超える大きな一覧は仮想化や `content-visibility: auto` を検討する
- レンダリング中に `getBoundingClientRect`、`offsetHeight`、`offsetWidth`、`scrollTop` を読まない
- DOMの読み取りと書き込みを交互に挟まず、まとめて処理する
- 入力欄は可能なら非制御にし、制御コンポーネントは1打鍵ごとのコストを抑える
- CDNや外部アセットには `<link rel="preconnect">` を検討する
- 重要フォントには `<link rel="preload" as="font">` と `font-display: swap` を使う

### 9. ナビゲーションと状態

- フィルタ、タブ、ページ番号、展開状態などは可能な限りURLへ反映する
- リンクは `<a>` または `<Link>` を使い、CtrlまたはCmdクリックや中クリックを壊さない
- 状態を持つUIは、必要に応じてディープリンク可能にする
- 破壊的操作は即時実行せず、確認モーダルまたはUndo導線を用意する

### 10. タッチ操作

- タップ遅延を避けるため `touch-action: manipulation` を検討する
- `-webkit-tap-highlight-color` は意図を持って設定する
- モーダル、ドロワー、シートでは `overscroll-behavior: contain` を検討する
- ドラッグ中はテキスト選択抑止や `inert` を必要に応じて使う
- `autoFocus` は限定的に使い、モバイルでは原則避ける

### 11. レイアウトと安全領域

- 全幅レイアウトでは `env(safe-area-inset-*)` を使い、ノッチやOS UIを避ける
- 横スクロールが不要な画面で意図しないスクロールバーを出さない
- レイアウト計算はJS計測よりFlexやGridを優先する

### 12. ダークモードとテーマ

- ダークテーマでは `<html>` に `color-scheme: dark` を設定する
- `<meta name="theme-color">` は背景色と整合させる
- ネイティブの `<select>` は、Windowsを含め背景色と文字色を明示する

### 13. ロケールとi18n

- 日付と時刻は `Intl.DateTimeFormat` を使う
- 数値と通貨は `Intl.NumberFormat` を使う
- 言語判定はIPではなく `Accept-Language` や `navigator.languages` を使う
- 日本語UIでは改行位置、全角半角混在、禁則処理の破綻も確認する

### 14. ハイドレーション安全性

- `value` を使う入力欄には `onChange` を付ける。不要なら `defaultValue` を使う
- 日時表示はサーバーとクライアントで不一致を起こさないようにする
- `suppressHydrationWarning` は本当に必要な箇所だけに限定する

### 15. ホバーと操作状態

- ボタンやリンクにはホバー時の視覚フィードバックを用意する
- hover、active、focus は通常状態より判別しやすくする

## 日本語UIで追加確認する観点

- 日本語と英数字が混在しても字間や改行位置が不自然でないか
- 長い日本語ラベルがモバイル幅で折り返し崩れを起こさないか
- 漢字が多い見出しで視線誘導が弱くなっていないか
- 日付形式、通貨記号、単位表記が日本の利用者にとって自然か
- 敬語、常体、命令形が画面内で混在していないか

## アンチパターン

- `user-scalable=no` または `maximum-scale=1`
- `onPaste` と `preventDefault()` の併用
- `transition: all`
- 代替フォーカスなしの `outline-none`
- `<a>` なしの `onClick` ナビゲーション
- ボタン用途の `<div>` や `<span>`
- サイズ未指定画像
- 仮想化なしの巨大配列 `.map()`
- ラベルのないフォーム入力
- `aria-label` のないアイコンボタン
- `Intl.*` を使わない日付、数値、通貨の直書き
- 根拠の薄い `autoFocus`

## 出力形式

指摘はファイルごとにまとめ、`file:line` 形式で簡潔に記述する。

```text
## src/Button.tsx

src/Button.tsx:42 - アイコンボタンに aria-label がない
src/Button.tsx:18 - 入力欄にラベルがない
src/Button.tsx:55 - prefers-reduced-motion への配慮がない
src/Button.tsx:67 - transition: all を使っている

## src/Modal.tsx

src/Modal.tsx:12 - overscroll-behavior: contain がない
src/Modal.tsx:34 - ... ではなく … を使う

## src/Card.tsx

✓ pass
```

## 原文同期メモ

- 原文ソース: https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
- 正式なレビュー運用では、毎回原文最新版を取得して差分確認する
- この文書は翻訳ではなく、日本語UI向けの運用参照として整理したもの
