# effect・イベント・入力処理

## 優先度

HIGH

## 基本方針

`useEffect` は外部システム同期のために使う。状態計算やユーザー操作の本体を入れない。

## ルール

### 1. ユーザー操作起点の処理はイベントハンドラへ置く

- 送信、選択、開閉、追跡開始などを `effect` に入れない
- interaction由来の処理を `effect` にすると再実行条件が増える

### 2. `effect` の依存は必要最小限に絞る

- オブジェクト全体よりプリミティブ値を渡す
- 前のstateだけ見ればよい更新は関数型 `setState` へ寄せる

### 3. 最新値参照のためだけに `effect` を再実行しない

- 長寿命の購読やタイマーでは `useRef` や `useEffectEvent` を検討する
- ただし、描画結果に関わる値までrefへ逃がさない

### 4. グローバルリスナーは重複登録しない

- `scroll` `resize` `pointermove` は特に重い
- スクロール系で `preventDefault` が不要なら `passive: true` を付ける

### 5. 入力に紐づく重い更新は遅らせる

- 検索一覧の再計算や非表示領域の更新は `startTransition` や `useDeferredValue` の対象

## 指摘してよい条件

- `effect` が state から別stateを作っている
- `effect` がクリック後の処理本体を担当している
- グローバルイベントをコンポーネントごとに重複登録している

## 指摘してはいけない条件

- 外部システム同期そのものが目的の `effect`
- `preventDefault` が必要な操作で passive を付ける提案
- ref化するとUIの整合性が壊れるケース