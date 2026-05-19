---
name: create-basic-design
description: '基本設計書を作成する。要件定義を入力に、画面一覧、DB定義、項目定義、インターフェース定義などを docs/basic-design 配下へ分割して保存する。'
---

# 基本設計書作成スキル

## 目的
`${input:BasicDesignPurpose}` に関する基本設計書を作成します。

このスキルは、要件定義で確定した内容をもとに、実装前に必要な構成・責務・データ・連携を整理するために使います。

## 基本原則

- 1ファイル1テーマで管理する
- 画面一覧、DB定義、項目定義、インターフェース定義は別ファイルに分ける
- 要件定義は `.github/docs/requirements/` を参照元として明記する
- 実装レベルの詳細手順や画面ごとの細かい挙動は `docs/spec/` に分離する
- 単一の巨大な基本設計書は作らない

## 保存先

基本設計書は `.github/docs/basic-design/` に保存する。

推奨ファイル構成:
- `index.md`: 基本設計の目次、参照関係、対象範囲
- `system-overview.md`: システム概要、主要構成、責務分割
- `screen-list.md`: 画面一覧、画面ID、利用者、遷移概要
- `database-definition.md`: エンティティ、テーブル、ER の要約
- `field-definitions.md`: 項目定義、属性、バリデーション方針
- `interface-definitions.md`: 外部・内部インターフェース、入出力、エラー方針
- `data-flow.md`: データフロー、処理順序、整合性ルール
- `architecture-decisions.md`: 設計判断、トレードオフ、リスク

対象に不要なファイルは作成しなくてよいが、必要な情報を1ファイルに詰め込まないこと。

## 作成手順

1. `docs/requirements/` を読み、根拠になる要件ID、業務ルール、制約を抜き出す
2. 基本設計で分けるべきテーマを決め、作成対象ファイルを列挙する
3. 各ファイルに要件との対応関係を明記する
4. 共通項目、共通IF、共通ルールは基本設計に寄せる
5. 画面個別仕様やロジック個別仕様は `docs/spec/` に委譲する

## 各ファイルに含める内容

### index.md
- 作成した基本設計書の一覧
- 各ファイルの目的
- 参照元の要件定義

### system-overview.md
- システム概要
- 主要コンポーネント
- 責務分割
- 必要なら Mermaid 図

### screen-list.md
- 画面ID
- 画面名
- 主利用者
- 遷移概要
- 関連する詳細設計へのリンク方針

### database-definition.md
- エンティティ一覧
- テーブル方針
- 主キー・外部キーの考え方
- 必要なら ER 図

### field-definitions.md
- 項目ID
- 項目名
- 型
- 必須/任意
- 共通バリデーション

### interface-definitions.md
- IF ID
- 連携先
- 入力
- 出力
- エラー方針

## 補助ルール

- Mermaid 図やアーキテクチャ判断が重い場合は `architect` エージェントを併用してよい
- 基本設計の保存先やファイル名は `docs/basic-design/README.md` の方針と合わせる
- 詳細設計へ落とすべき内容まで書き込みすぎない