---
name: react-performance
description: 'Reactコードの作成・レビュー・リファクタリング時に、再現性の高いパフォーマンス改善だけを優先順位付きで適用する。ウォーターフォール、初期バンドル、不要な再レンダリング、過剰なeffectを主対象とする。'
---

# React パフォーマンス

Reactコードの生成、レビュー、リファクタリングで使う実務向けの最小ルールセット。
目的は、AIが過剰最適化せず、効果が大きく再現しやすい改善だけを優先できるようにすること。

## 核心原則

1. まずウォーターフォールを疑う
2. 次に初期バンドルを疑う
3. その次に不要な再レンダリングとeffectを疑う
4. DOM/JavaScriptの細かい最適化は、ホットパスが確認できる場合だけ行う
5. `useMemo` `useCallback` `dynamic import` `cache` は、コストや再利用境界が明確なときだけ使う

## このスキルが扱う対象

- React + TypeScript のコンポーネント、hooks、画面ロジック
- API呼び出し、画面初期化、検索、フィルタ、一覧描画
- Next.js / SSR / RSC を使う場合の追加判断

## このスキルが優先して見るもの

- 独立処理を逐次 `await` していないか
- 初期表示に不要な重い依存を同期ロードしていないか
- 派生stateやイベント処理を `effect` に押し込んでいないか
- 親の更新で高コストな子が不要に再描画されていないか
- 計測なしに細かいマイクロ最適化をしていないか

## 参照ファイル

- `reference/01-priority-and-decision-flow.md`: どこから見るか、何を根拠に指摘するか
- `reference/02-waterfalls-and-data-fetching.md`: `await`、Promise開始タイミング、データ取得の並列化
- `reference/03-bundle-and-loading.md`: 初期バンドル、遅延ロード、第三者ライブラリ
- `reference/04-rerender-and-state.md`: 再レンダリング、派生state、メモ化の判断
- `reference/05-effects-events-and-input.md`: `useEffect`、イベント、入力、リスナー管理
- `reference/06-rendering-and-dom.md`: 長いリスト、条件描画、ハイドレーション、DOM負荷
- `reference/07-javascript-hot-paths.md`: 反復処理、検索、ソート、正規表現
- `reference/08-runtime-scope-and-non-goals.md`: SPA/SSRの適用範囲、やりすぎ防止

## 適用順

1. `01-priority-and-decision-flow` を先に見る
2. 問題が `await` / fetch / route handler にあるなら `02`
3. 問題が初期表示や重い依存なら `03`
4. 問題が入力遅延や不要な描画なら `04` と `05`
5. 問題が大量DOMや描画ちらつきなら `06`
6. 問題が純粋なループや探索コストなら `07`
7. フレームワーク依存の判断は `08` で絞る

## 出力ルール

- 指摘は必ず「症状」「原因」「最小修正」の順で書く
- 効果が高い順に並べる
- フレームワーク依存の提案は前提条件を明記する
- 計測がない場合は断定しすぎず、「可能性が高い」ではなく「この構造だと発生しやすい」と書く
- 不要な抽象化や新規依存追加は避ける
