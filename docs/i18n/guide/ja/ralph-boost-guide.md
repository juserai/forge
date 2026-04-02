# Ralph Boost ユーザーガイド

> 5分で始められます — AI の自律開発ループが停滞するのを防ぎましょう

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserch/jskills
```

### ワンライン・ユニバーサルインストール

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **ゼロ依存** — Ralph Boost は ralph-claude-code、block-break、その他の外部サービスに依存しません。プライマリパス（Agent ループ）は外部依存ゼロです。フォールバックパスには `jq` または `python` と `claude` CLI が必要です。

---

## コマンド

| コマンド | 機能 | 使うタイミング |
|---------|------|--------------|
| `/ralph-boost setup` | プロジェクトに自律ループを初期化 | 初回セットアップ |
| `/ralph-boost run` | 現在のセッションで自律ループを開始 | 初期化後 |
| `/ralph-boost status` | 現在のループ状態を表示 | 進捗の確認 |
| `/ralph-boost clean` | ループファイルを削除 | クリーンアップ |

---

## クイックスタート

### 1. プロジェクトを初期化

```text
/ralph-boost setup
```

Claude が以下の手順を案内します：
- プロジェクト名の検出
- タスクリストの生成（fix_plan.md）
- `.ralph-boost/` ディレクトリと全設定ファイルの作成

### 2. ループを開始

```text
/ralph-boost run
```

Claude が現在のセッション内で直接自律ループを駆動します（Agent ループモード）。各イテレーションではタスクを実行する sub-agent が起動され、メインセッションが状態を管理するループコントローラーとして機能します。

**フォールバック**（ヘッドレス / 無人環境向け）：

```bash
# フォアグラウンド
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# バックグラウンド
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. 状態を確認

```text
/ralph-boost status
```

出力例：

```
Ralph Boost Status
==================
Circuit Breaker:  HALF_OPEN
Pressure Level:   L2 Interrogation
Loop Count:       5
Tried Approaches: 3
Checklist:        2/7 completed
Last Updated:     2026-04-01T10:30:00Z

Tried Approaches:
  1. Fix JSON escape logic → Problem is not in escaping (loop 2)
  2. Upgrade jq version → Already latest (loop 3)
  3. Check upstream encoding → Found non-UTF-8 data (loop 4)

Checklist Progress:
  [x] read_error_signals
  [x] searched_core_problem
  [ ] read_source_context
  [ ] verified_assumptions
  [ ] tried_opposite_hypothesis
  [ ] minimal_reproduction
  [ ] switched_tool_or_method
```

---

## 仕組み

### 自律ループ

Ralph Boost は2つの実行パスを提供します：

**プライマリパス（Agent ループ）**：Claude が現在のセッション内でループコントローラーとして機能し、各イテレーションで sub-agent を起動してタスクを実行します。メインセッションが状態管理、サーキットブレーカー、圧力エスカレーションを担当します。外部依存はゼロです。

**フォールバック（bash スクリプト）**：`boost-loop.sh` がバックグラウンドで `claude -p` 呼び出しをループ実行します。JSON エンジンとして jq と python の両方に対応し、実行時に自動検出されます。デフォルトのイテレーション間隔は1時間（設定変更可能）です。

両パスとも同じ状態管理（state.json）、圧力エスカレーションロジック、BOOST_STATUS プロトコルを共有しています。

```
タスク読込 → 実行 → 進捗検出 → 戦略調整 → レポート → 次のイテレーション
```

### 強化版サーキットブレーカー（ralph-claude-code との比較）

ralph-claude-code のサーキットブレーカー：進捗なしのループが3回連続すると諦めます。

ralph-boost のサーキットブレーカー：行き詰まった際に**段階的に圧力をエスカレーション**し、停止するまでに6〜7回の自己回復ループを実行します。

```
進捗あり → L0（リセットして通常作業を続行）

進捗なし：
  1ループ  → L1 失望（アプローチ切り替えを強制）
  2ループ → L2 尋問（エラーを一語一句読む + ソースを検索 + 3つの仮説を列挙）
  3ループ → L3 人事評価（7項目チェックリストを完遂）
  4ループ → L4 卒業（最小 PoC + 引き継ぎレポートを作成）
  5ループ以上 → 正常終了（構造化された引き継ぎレポート付き）
```

---

## 出力例

### L0 — 通常実行

```
---BOOST_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
PRESSURE_LEVEL: L0
TRIED_COUNT: 0
RECOMMENDATION:
  CURRENT_APPROACH: Implemented user authentication middleware
  RESULT: All tests passing, middleware integrated
  NEXT_APPROACH: Add rate limiting to auth endpoints
---END_BOOST_STATUS---
```

### L1 — アプローチ切り替え

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude は前のアプローチを放棄し、**根本的に異なる**方法を試すことを強制されます。パラメータの微調整ではカウントされません。

### L2 — 検索と仮説立て

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude は以下を実行する必要があります：エラーを一語一句読む → 50行以上のコンテキストを検索 → 3つの異なる仮説を列挙。

### L3 — チェックリスト

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude は7項目チェックリスト（エラーシグナルの読解、コア問題の検索、ソースの読解、前提の検証、逆仮説の試行、最小限の再現、ツール/方法の切り替え）を完遂する必要があります。完了した各項目は state.json に記録されます。

### L4 — 正常な引き継ぎ

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude は最小限の PoC を作成し、引き継ぎレポートを生成します：

```markdown
# Handoff Report

**Task**: Fix SSL handshake failure in production
**Loops attempted**: 6
**Final pressure**: L4

## Verified Facts
- OpenSSL 3.x incompatible with legacy TLS 1.0 endpoints
- Server certificate chain is valid (verified with openssl s_client)

## Excluded Possibilities
- Client-side TLS config: Verified correct (evidence: curl with same config works on OpenSSL 1.x)
- Certificate expiry: Verified not expired (evidence: openssl x509 -enddate)

## Narrowed Problem Scope
Issue is specifically in OpenSSL 3.x's removal of legacy TLS renegotiation support.
Requires system-level OpenSSL configuration change or server-side TLS upgrade.

## Recommended Next Steps
1. Contact server team to upgrade TLS to 1.2+
2. Or configure OpenSSL 3.x legacy provider: openssl.cnf [provider_sect]
```

引き継ぎが完了するとループは正常に終了します。これは「できません」ではなく、「ここが境界線です」という報告です。

---

## 設定

`.ralph-boost/config.json`：

| フィールド | デフォルト値 | 説明 |
|-----------|------------|------|
| `max_calls_per_hour` | 100 | 1時間あたりの最大 Claude API 呼び出し数 |
| `claude_timeout_minutes` | 15 | 個別呼び出しのタイムアウト |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude が使用可能なツール |
| `claude_model` | "" | モデルの上書き（空 = デフォルト） |
| `session_expiry_hours` | 24 | セッションの有効期限 |
| `no_progress_threshold` | 7 | 停止前の進捗なし閾値 |
| `same_error_threshold` | 8 | 停止前の同一エラー閾値 |
| `sleep_seconds` | 3600 | イテレーション間の待機時間（秒） |

### よくある設定変更

**ループを高速化する**（テスト用）：

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**ツール権限を制限する**：

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**特定のモデルを使用する**：

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## プロジェクトディレクトリ構成

```
.ralph-boost/
├── PROMPT.md           # 開発指示書（block-break プロトコル含む）
├── fix_plan.md         # タスクリスト（Claude が自動更新）
├── config.json         # 設定
├── state.json          # 統合状態（サーキットブレーカー + 圧力 + セッション）
├── handoff-report.md   # L4 引き継ぎレポート（正常終了時に生成）
├── logs/
│   ├── boost.log       # ループログ
│   └── claude_output_*.log  # イテレーションごとの出力
└── .gitignore          # 状態とログを除外
```

すべてのファイルは `.ralph-boost/` 内に収まります。プロジェクトルートには一切変更を加えません。

---

## ralph-claude-code との関係

Ralph Boost は [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) の**独立した代替品**であり、拡張プラグインではありません。

| 観点 | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| 形態 | スタンドアロン Bash ツール | Claude Code スキル（Agent ループ） |
| インストール | `npm install` | Claude Code プラグイン |
| コードサイズ | 2000行以上 | 約400行 |
| 外部依存 | jq（必須） | プライマリパス：ゼロ、フォールバック：jq または python |
| ディレクトリ | `.ralph/` | `.ralph-boost/` |
| サーキットブレーカー | 受動的（3ループ後に諦める） | 能動的（L0-L4、6〜7ループの自己回復） |
| 共存 | 可能 | 可能（ファイル衝突ゼロ） |

両者は同じプロジェクトに同時にインストールできます。別々のディレクトリを使用するため、互いに干渉しません。

---

## Block Break との関係

Ralph Boost は Block Break のコアメカニズム（圧力エスカレーション、5ステップ方法論、チェックリスト）を自律ループシナリオに適用したものです：

| 観点 | block-break | ralph-boost |
|------|-------------|-------------|
| シナリオ | インタラクティブセッション | 自律ループ |
| 起動方法 | Hooks が自動トリガー | Agent ループ / ループスクリプトに内蔵 |
| 検出 | PostToolUse hook | Agent ループの進捗検出 / スクリプトの進捗検出 |
| 制御 | Hook 注入プロンプト | Agent プロンプト注入 / --append-system-prompt |
| 状態 | `~/.juserch-skills/` | `.ralph-boost/state.json` |

コードは完全に独立していますが、コンセプトは共有しています。

> **参考**: Block Break の圧力エスカレーション（L0-L4）、5ステップ方法論、7項目チェックリストは、ralph-boost のサーキットブレーカーの概念的基盤です。詳細は [Block Break ユーザーガイド](block-break-guide.md) を参照してください。

---

## よくある質問

### プライマリパスとフォールバックはどう選べばよいですか？

`/ralph-boost run` はデフォルトで Agent ループ（プライマリパス）を使用し、現在の Claude Code セッション内で直接実行されます。ヘッドレスまたは無人環境で実行する必要がある場合は、フォールバックの bash スクリプトを使用してください。

### ループスクリプトはどこにありますか？

jskills プラグインをインストールすると、フォールバックスクリプトは `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh` にあります。任意の場所にコピーして実行することもできます。スクリプトは jq または python を JSON エンジンとして自動検出します。

### ループログを確認するには？

```bash
tail -f .ralph-boost/logs/boost.log
```

### 圧力レベルを手動でリセットするには？

`.ralph-boost/state.json` を編集し、`pressure.level` を 0 に、`circuit_breaker.consecutive_no_progress` を 0 に設定してください。または state.json を削除して再初期化することもできます。

### タスクリストを変更するには？

`.ralph-boost/fix_plan.md` を直接編集し、`- [ ] task` 形式を使用してください。Claude は各イテレーションの開始時にこのファイルを読み込みます。

### サーキットブレーカーが開いた後に復旧するには？

`state.json` を編集し、`circuit_breaker.state` を `"CLOSED"` に設定、関連するカウンターをリセットして、スクリプトを再実行してください。

### ralph-claude-code は必要ですか？

いいえ。Ralph Boost は完全に独立しており、Ralph のファイルには一切依存しません。

### 対応プラットフォームは？

現在は Claude Code（Agent ループのプライマリパス）をサポートしています。フォールバックの bash スクリプトには bash 4+、jq または python、および claude CLI が必要です。

### ralph-boost のスキルファイルを検証するには？

[Skill Lint](skill-lint-guide.md) を使ってください：`/skill-lint .`

---

## ライセンス

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
