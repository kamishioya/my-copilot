---
name: docs-sync
description: '既存ドキュメントを実装差分に合わせて最小更新する。バグ修正、仕様差分、識別子生成、sourceItemId/itemId、checkpoint、dedup、idempotency、screening、分類ルールの変更時に使用する。'
---

# ドキュメント差分同期スキル

既存ドキュメントを、実装差分に合わせて最小限の修正で同期する。

## 目的

- 新規ドキュメントを作るのではなく、既存の `docs/requirements/`、`docs/basic-design/`、`docs/spec/`、`docs/plan/`、`README.md` を stale な記述だけ更新する
- コード修正後に残りやすい「古い説明」「古い契約」「古い業務ルール」を取り除く
- MemoryBank の `activeContext.md` と `progress.md` に、更新内容または未更新理由を残す

## このスキルを使う場面

- バグ修正で外部挙動や内部契約が変わった
- 識別子生成、正規化、選択ルールが変わった
- `sourceItemId`、`itemId`、キー項目、URL 正規化などの扱いが変わった
- 重複判定、照合、dedup ルールが変わった
- checkpoint、resume、retry、idempotency の挙動が変わった
- screening、分類、業務ルールの判定条件が変わった
- API、設定、DB、運用フローの説明が stale になった

## 手順

1. 実装差分とテスト差分を確認し、挙動の変化点を箇条書きにする
2. 関連する `docs/requirements/`、`docs/basic-design/`、`docs/spec/`、`docs/plan/`、`README.md`、`memory-bank/` を特定する
3. 各ドキュメントについて、更新する / しない / 理由 を決める
4. stale な記述だけを最小差分で更新し、未変更部分の構成や文体は保つ
5. 用語、フィールド名、状態名、受入基準をコードと一致させる
6. `memory-bank/activeContext.md` と `memory-bank/progress.md` に、更新内容または未更新理由を残す

## 出力フォーマット

```markdown
## ドキュメント同期計画

### 実装差分の要約
- 変更点1
- 変更点2

### 更新対象ドキュメント
| ファイル | 判定 | 理由 | 予定する最小変更 |
|---------|------|------|------------------|
| docs/requirements/... | 更新する / しない | 判断理由 | 変更点 |
| docs/basic-design/... | 更新する / しない | 判断理由 | 変更点 |
| docs/spec/screens/... or docs/spec/business-logic/... | 更新する / しない | 判断理由 | 変更点 |
| docs/plan/... | 更新する / しない | 判断理由 | 変更点 |
| README.md | 更新する / しない | 判断理由 | 変更点 |

### MemoryBank 反映
| ファイル | 更新内容 |
|---------|----------|
| memory-bank/activeContext.md | 何を更新するか |
| memory-bank/progress.md | 何を更新するか |
```

## 境界

- 新しい基本設計書群を作る場合は `create-basic-design` スキルを使う
- Mermaid 図やアーキテクチャ判断が重い場合は `architect` エージェントを使う
- 変更前の影響範囲が未整理なら、先に `context-map` スキルで候補を洗い出す
- docs を更新しない場合でも、未更新理由を final answer に明記する