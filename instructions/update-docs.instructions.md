---
description: 'コード変更時にドキュメントと MemoryBank の同期更新を保証する。新機能、API変更、識別子生成、重複判定、checkpoint、idempotency、screening、分類ルール変更を含む。'
applyTo: '**'
---

# ドキュメント同期更新ルール

コード、設定、DB、業務ルール、識別子ルール、運用フローに変更を加えた際は、関連ドキュメントと MemoryBank の更新要否を必ず判定すること。

## 基本原則

- 変更の種類ではなく、挙動・契約・運用影響の有無で判断する
- repo に `memory-bank/activeContext.md` と `memory-bank/progress.md` がある場合、それらが authoritative source である
- ツール側メモリは補助であり、repo の MemoryBank の代替にしてはならない
- 更新対象がない場合でも、未更新理由を final answer に明記する

## 実装前後の必須チェック

### 実装前
- [ ] 影響する `docs/requirements/`、`docs/basic-design/`、`docs/spec/`、`docs/plan/`、`README.md`、`db/`、`memory-bank/` の候補を列挙する
- [ ] 各候補について「更新する / しない / 理由」を判断する

### 実装後
- [ ] 実際の変更内容に基づいて判定を見直す
- [ ] 必要なドキュメントを最小差分で同期する
- [ ] 重要な変更後は `memory-bank/activeContext.md` と `memory-bank/progress.md` を更新する

## 更新トリガーと対象

### 新機能追加時
- [ ] README.md の機能一覧を更新
- [ ] 該当する要件定義（`docs/requirements/`）を更新
- [ ] 該当する基本設計（`docs/basic-design/`）を更新
- [ ] 該当する詳細設計（`docs/spec/screens/` または `docs/spec/business-logic/`）を更新
- [ ] 実装計画書のステータスを更新
- [ ] memory-bank の progress.md を更新

### API変更時
- [ ] API仕様書を更新
- [ ] CHANGELOG.md にエントリ追加
- [ ] 関連する仕様書の受入基準を見直し

### 破壊的変更時
- [ ] CHANGELOG.md に BREAKING CHANGE を記載
- [ ] README.md のマイグレーションガイドを追加
- [ ] バージョン番号を更新

### 依存関係変更時
- [ ] techContext.md を更新
- [ ] README.md のセットアップ手順を確認

### 設定変更時
- [ ] README.md の設定セクションを更新
- [ ] 該当する環境変数のドキュメントを更新

### DB変更時
- [ ] `db/` 配下の該当ファイルを更新
- [ ] マイグレーションスクリプトを追加
- [ ] `docs/basic-design/database-definition.md` と `docs/basic-design/field-definitions.md` を更新
- [ ] 関連する詳細設計を更新

### 識別子生成・正規化・選択規則の変更時
- [ ] 必要に応じて `docs/requirements/04-business-rules.md` を更新
- [ ] `docs/basic-design/` のデータフロー、正規化ロジック、永続化ルールを更新
- [ ] `docs/spec/business-logic/` の識別子契約、キー定義、受入基準を更新

### 重複判定・照合・dedup 規則の変更時
- [ ] 必要に応じて `docs/requirements/04-business-rules.md` を更新
- [ ] `docs/basic-design/` の照合ロジックと副作用を更新
- [ ] `docs/spec/business-logic/` の判定条件、優先順位、例外ケースを更新

### checkpoint / resume / retry / idempotency ロジックの変更時
- [ ] `docs/basic-design/` の状態遷移、再開条件、冪等性保証を更新
- [ ] `docs/spec/business-logic/` の運用要件と失敗時挙動を更新

### screening・分類・業務ルールの変更時
- [ ] `docs/requirements/04-business-rules.md` のルール定義を更新
- [ ] `docs/basic-design/` の判定順序、入力、出力、監査ポイントを更新
- [ ] `docs/spec/business-logic/` の分類条件、受入基準を更新

### バグ修正でも外部挙動または内部契約が変わる時
- [ ] 関連する `docs/requirements/`、`docs/basic-design/`、`docs/spec/` を更新
- [ ] 変更が利用手順に影響する場合は README.md も更新

## 完了条件

- [ ] コード変更と関連ドキュメントの同期が完了している
- [ ] MemoryBank の authoritative files が更新されている、または更新不要の理由が説明されている
- [ ] final answer に「更新したドキュメント」または「未更新理由」が明記されている
