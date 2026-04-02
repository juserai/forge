# Skill Lint ユーザーガイド

> 3分で始められます — Claude Code スキルの品質を検証しましょう

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserch/jskills
```

### ワンライン・ユニバーサルインストール

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **ゼロ依存** — Skill Lint は外部サービスや API を一切必要としません。インストールしたらすぐ使えます。

---

## コマンド

| コマンド | 機能 | 使うタイミング |
|---------|------|--------------|
| `/skill-lint` | 使い方を表示 | 利用可能なチェック項目を確認 |
| `/skill-lint .` | 現在のプロジェクトを検証 | 開発中のセルフチェック |
| `/skill-lint /path/to/plugin` | 指定パスを検証 | 他のプラグインのレビュー |

---

## ユースケース

### 新しいスキル作成後のセルフチェック

`skills/<name>/SKILL.md`、`commands/<name>.md`、および関連ファイルを作成した後、`/skill-lint .` を実行して、構造が完全であること、frontmatter が正しいこと、marketplace エントリが追加されていることを確認します。

### 他の人のプラグインをレビュー

PR のレビューや他のプラグインの監査時に、`/skill-lint /path/to/plugin` を使えばファイルの完全性と一貫性をすばやくチェックできます。

### CI への統合

`scripts/skill-lint.sh` は CI パイプラインで直接実行でき、自動解析用の JSON を出力します：

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## チェック項目

### 構造チェック（Bash スクリプトで実行）

| ルール | チェック内容 | 重大度 |
|--------|-----------|--------|
| S01 | `plugin.json` がルートと `.claude-plugin/` の両方に存在する | error |
| S02 | `.claude-plugin/marketplace.json` が存在する | error |
| S03 | 各 `skills/<name>/` に `SKILL.md` が含まれている | error |
| S04 | SKILL.md の frontmatter に `name` と `description` が含まれている | error |
| S05 | 各スキルに対応する `commands/<name>.md` がある | warning |
| S06 | 各スキルが marketplace.json の `plugins` 配列に登録されている | warning |
| S07 | SKILL.md で参照されている references ファイルが実在する | error |
| S08 | `evals/<name>/scenarios.md` が存在する | warning |

### セマンティックチェック（AI で実行）

| ルール | チェック内容 | 重大度 |
|--------|-----------|--------|
| M01 | description が目的とトリガー条件を明確に記述している | warning |
| M02 | name がディレクトリ名と一致し、description がファイル間で一貫している | warning |
| M03 | コマンドルーティングロジックがスキル名を正しく参照している | warning |
| M04 | references の内容が SKILL.md と論理的に一貫している | warning |
| M05 | 評価シナリオがコア機能パスをカバーしている（最低5つ） | warning |

---

## 出力例

### すべてのチェックに合格

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### 問題が検出された場合

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## ワークフロー

```
/skill-lint [path]
      │
      ▼
  skill-lint.sh を実行 ──→ JSON 構造チェック結果
      │
      ▼
  AI がスキルファイルを読解 ──→ セマンティックチェック
      │
      ▼
  統合出力（error > warning > passed）
```

---

## よくある質問

### セマンティックチェックなしで構造チェックだけ実行できますか？

はい。bash スクリプトを直接実行してください：

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

AI によるセマンティック分析なしの純粋な JSON が出力されます。

### jskills 以外のプロジェクトでも使えますか？

はい。標準的な Claude Code プラグイン構造（`skills/`、`commands/`、`.claude-plugin/`）に従っている任意のディレクトリを検証できます。

### error と warning の違いは？

- **error**: スキルの読み込みや公開を妨げる構造上の問題
- **warning**: 機能には影響しないが、保守性や発見性に影響する品質上の問題

### その他の jskills ツール

Skill Lint は jskills コレクションの一部であり、以下のスキルと組み合わせて使うと効果的です：

- [Block Break](block-break-guide.md) — AI にあらゆるアプローチを尽くさせる高エネルギー行動制約エンジン
- [Ralph Boost](ralph-boost-guide.md) — Block Break の収束保証を内蔵した自律開発ループエンジン

新しいスキルの開発後、`/skill-lint .` を実行して構造の完全性を検証し、frontmatter、marketplace.json、reference リンクがすべて正しいことを確認してください。

---

## ライセンス

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
