# ウォーターフォールとデータ取得

## 優先度

CRITICAL

## 見る場所

- route handler
- loader
- server component
- `useEffect` 内の初期データ取得
- submit処理や保存処理

## ルール

### 1. 独立した非同期処理は同時に開始する

- 独立しているなら `Promise.all()` を使う
- 依存がある処理でも、先に開始できる Promise は早く作る

### 2. `await` は値が必要になる直前まで遅らせる

- 早期returnの可能性があるなら、不要な分岐で待たない
- 認可、設定、補助データなどは必要な分岐まで遅延できるか確認する

### 3. 部分依存でも全体を直列にしない

- `user` が必要なのは `profile` だけで、`config` は独立、という形は多い
- この場合は Promise を個別に開始して最後にまとめて待つ

### 4. クライアントの逐次フェッチ連鎖を減らす

- 親の取得完了後に子が取得を始める構造は遅い
- 可能なら上位でまとめて取得するか、並列に開始できる構造へ寄せる

## 最小修正パターン

```ts
const userPromise = fetchUser();
const configPromise = fetchConfig();

const user = await userPromise;
const [config, posts] = await Promise.all([
  configPromise,
  fetchPosts(user.id),
]);
```

## 指摘してよい条件

- 同じ関数内で独立した `await` が連続している
- Promise を先に開始できるのに、その場で待っている
- 分岐で使わない値を先に取得している

## 指摘してはいけない条件

- 順序保証が業務要件になっている
- 先行処理の副作用結果に次処理が依存する
- レート制限や排他制御のため意図的に直列化している

## 補足

- 追加ライブラリで並列化を表現するより、まず素直な Promise 生成で十分かを優先する
- React SPA + .NET API 構成でも最優先で効く