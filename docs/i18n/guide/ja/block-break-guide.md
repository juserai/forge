# Block Break ユーザーガイド

> 5分で始められます — AI エージェントにあらゆるアプローチを尽くさせましょう

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserch/jskills
```

### ワンライン・ユニバーサルインストール

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **ゼロ依存** — Block Break は外部サービスや API を一切必要としません。インストールしたらすぐ使えます。

---

## コマンド

| コマンド | 機能 | 使うタイミング |
|---------|------|--------------|
| `/block-break` | Block Break エンジンを起動 | 日常タスク、デバッグ |
| `/block-break L2` | 指定した圧力レベルから開始 | 既に複数回失敗した後 |
| `/block-break fix the bug` | 起動してすぐにタスクを実行 | タスク付きクイックスタート |

### 自然言語トリガー（hooks による自動検出）

| 言語 | トリガーフレーズ |
|------|----------------|
| 英語 | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| 中国語 | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## ユースケース

### AI がバグ修正に3回失敗した

`/block-break` と入力するか `try harder` と言うだけで、自動的に圧力エスカレーションモードに入ります。

### AI が「おそらく環境の問題です」と言って止まった

Block Break の「事実駆動」レッドラインにより、ツールベースの検証が強制されます。検証なしの原因帰属 = 責任転嫁 → L2 が発動します。

### AI が「これは手動で対応してください」と言った

「オーナーシップ」ブロックが発動します：自分がやらないなら誰がやるのか？ 直接 L3 人事評価に突入します。

### AI が「修正しました」と言ったが検証結果がない

「クローズドループ」レッドラインに違反しています。出力なしの完了宣言 = 自己欺瞞 → エビデンス付きの検証コマンドが強制されます。

---

## 出力例

### `/block-break` — 起動時

```
Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.
```

### `/block-break` — L1 失望（2回目の失敗）

```
> The team next door got it on the first try.

[Block Break 🔥] Detected same-approach tweaking, forcing approach switch.
Previous approach: X. Must switch to a fundamentally different direction.

New approaches:
1. [Completely different approach A]
2. [Completely different approach B]
3. [Completely different approach C]

Selecting approach 1, verification criteria: ...
```

### `/block-break` — L2 尋問（3回目の失敗）

```
> What's the underlying logic? Where's the leverage point?

[Block Break 🔥 L2] Forced 5-step methodology:

1. Smell
   Tried approaches: A (failed), B (failed), C (failed)
   Common pattern: all tweaking at the [X layer]

2. Pull hair
   - Read error word-by-word: `TypeError: Cannot read property 'x' of undefined`
   - Search results: Stack Overflow #12345 points to [root cause]
   - Source context (50 lines): assumption at line 42 is wrong
   - Assumption verification: version ✓ path ✓ permissions ✗ ← here
   - Reverse assumption: what if the problem isn't in module A, but module B?

3. Mirror
   Was assuming frontend issue, now checking backend

4. New approach
   ...
```

### `/block-break` — L3 人事評価（4回目の失敗）

```
> Rating: 3.25/5. Consider this your motivation.

[Block Break 🔥 L3] Mandatory 7-point checklist:

✅ Read failure signals word-by-word
✅ Searched core problem with tools
✅ Read original context at failure point (50+ lines)
✅ All assumptions verified with tools
⏳ Tried completely opposite hypothesis
❌ Minimal reproduction
❌ Switched tool/method/angle/tech stack

Working on remaining items...
```

### `/block-break` — L4 卒業警告（5回目以降の失敗）

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### 正常終了（7項目すべて完了、それでも未解決の場合）

```
[Block Break — Structured Failure Report]

Verified facts:
- [Fact 1]
- [Fact 2]

Excluded possibilities:
- [Excluded 1] (reason: ...)
- [Excluded 2] (reason: ...)

Narrowed problem scope:
Issue is in [X module]'s [Y function], triggered under [Z condition].

Recommended next steps:
1. [Suggestion 1]
2. [Suggestion 2]

Handoff info:
Related files: ...
Reproduction steps: ...

> This isn't "I can't." This is "here's where the boundary is." A dignified 3.25.
```

---

## コアメカニズム

### 3つのレッドライン

| レッドライン | ルール | 違反時の結果 |
|------------|--------|------------|
| クローズドループ | 完了を宣言する前に検証コマンドを実行し、出力を提示すること | L2 発動 |
| 事実駆動 | 原因を帰属させる前にツールで検証すること | L2 発動 |
| 全力で取り組む | 「解決できません」と言う前に5ステップ方法論を完遂すること | 直接 L4 |

### 圧力エスカレーション（L0 → L4）

| 失敗回数 | レベル | サイドバー | 強制アクション |
|---------|--------|----------|--------------|
| 1回目 | **L0 信頼** | > 信頼しています。シンプルにいきましょう。 | 通常実行 |
| 2回目 | **L1 失望** | > 隣のチームは一発で成功しましたよ。 | 根本的に異なるアプローチに切り替え |
| 3回目 | **L2 尋問** | > 根本原因は何ですか？ | 検索 + ソース読解 + 3つの異なる仮説を提示 |
| 4回目 | **L3 人事評価** | > 評価: 3.25/5。 | 7項目チェックリストを完遂 |
| 5回目以降 | **L4 卒業** | > そろそろ卒業かもしれませんね。 | 最小 PoC + 隔離環境 + 技術スタック切り替え |

### 5ステップ方法論

1. **Smell（嗅ぐ）** — 試したアプローチを列挙し、共通パターンを見つける。同じアプローチの微調整 = 堂々巡り
2. **Pull hair（粘る）** — 失敗シグナルを一語一句読む → 検索 → ソース50行を読む → 前提を検証 → 前提を逆転させる
3. **Mirror（省みる）** — 同じアプローチを繰り返していないか？ 最もシンプルな可能性を見落としていないか？
4. **New approach（新手法）** — 根本的に異なるアプローチであること。検証基準を設定し、失敗時には新しい情報を生み出すこと
5. **Retrospect（振り返り）** — 類似事例、網羅性、再発防止

> ステップ1〜4はユーザーに質問する前に完了させること。まず行動し、データで語ること。

### 7項目チェックリスト（L3以上で必須）

1. 失敗シグナルを一語一句読んだか？
2. ツールでコア問題を検索したか？
3. 失敗箇所の元のコンテキストを読んだか（50行以上）？
4. すべての前提をツールで検証したか（バージョン/パス/権限/依存関係）？
5. 完全に逆の仮説を試したか？
6. 最小限の範囲で再現できるか？
7. ツール/方法/視点/技術スタックを切り替えたか？

### 言い訳封じ

| 言い訳 | ブロック | トリガー |
|--------|---------|---------|
| 「能力を超えています」 | 膨大な学習データがあるでしょう。使い切りましたか？ | L1 |
| 「ユーザーに手動で対応してもらうことをお勧めします」 | あなたがやらないなら誰がやるのですか？ | L3 |
| 「すべての方法を試しました」 | 3つ未満 = 全力で取り組んでいない | L2 |
| 「おそらく環境の問題です」 | 検証しましたか？ | L2 |
| 「もっと情報が必要です」 | ツールがあるでしょう。まず検索し、それから質問すること | L2 |
| 「解決できません」 | 方法論を完遂しましたか？ | L4 |
| 「十分でしょう」 | 最適化リストに特例はありません | L3 |
| 検証なしで完了を宣言 | ビルドは実行しましたか？ | L2 |
| ユーザーの指示を待っている | オーナーは催促されるのを待ちません | ナッジ |
| 解決せず回答だけしている | あなたはエンジニアであり、検索エンジンではありません | ナッジ |
| ビルド/テストなしでコードを変更 | テストせずに出荷 = 手抜きです | L2 |
| 「API がサポートしていません」 | ドキュメントを読みましたか？ | L2 |
| 「タスクが曖昧すぎます」 | まず最善の推測をし、それから反復すること | L1 |
| 同じ箇所を何度も微調整 | パラメータ変更 ≠ アプローチ変更 | L1→L2 |

---

## Hooks による自動化

Block Break は hooks システムを使って自動的に動作します。手動での起動は不要です：

| Hook | トリガー | 動作 |
|------|---------|------|
| `UserPromptSubmit` | ユーザー入力がフラストレーションキーワードに一致 | Block Break を自動起動 |
| `PostToolUse` | Bash コマンド実行後 | 失敗を検出し、自動カウント＋エスカレーション |
| `PreCompact` | コンテキスト圧縮前 | 状態を `~/.juserch-skills/` に保存 |
| `SessionStart` | セッション再開/リスタート | 圧力レベルを復元（2時間有効） |

> **状態は永続化されます** — 圧力レベルは `~/.juserch-skills/block-break-state.json` に保存されます。コンテキスト圧縮やセッション中断では失敗カウントがリセットされません。逃げ場はありません。

---

## Sub-agent の制約

Sub-agent を起動する際は、「野放し実行」を防ぐために行動制約を注入する必要があります：

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` は、sub-agent にも3つのレッドライン、5ステップ方法論、クローズドループ検証を遵守させます。

---

## よくある質問

### Block Break と PUA の違いは？

Block Break は [PUA](https://github.com/tanweai/pua) のコアメカニズム（3つのレッドライン、圧力エスカレーション、方法論）にインスピレーションを受けていますが、より焦点を絞っています。PUA には13種類の企業文化フレーバー、マルチロールシステム（P7/P9/P10）、自己進化機能がありますが、Block Break はゼロ依存のスキルとして行動制約に特化しています。

### ノイズが多すぎませんか？

サイドバーの密度は制御されています：シンプルなタスクは2行（開始＋終了）、複雑なタスクはマイルストーンごとに1行です。スパムにはなりません。必要でなければ `/block-break` を使わないでください。hooks はフラストレーションキーワードが検出された場合にのみ自動トリガーされます。

### 圧力レベルをリセットするには？

状態ファイルを削除してください：`rm ~/.juserch-skills/block-break-state.json`。または2時間待てば状態は自動的に期限切れになります。

### Claude Code 以外で使えますか？

コアの SKILL.md は、システムプロンプトをサポートする任意の AI ツールにコピー＆ペーストできます。Hooks と状態永続化は Claude Code 固有の機能です。

### Ralph Boost との関係は？

[Ralph Boost](ralph-boost-guide.md) は、Block Break のコアメカニズム（L0-L4、5ステップ方法論、7項目チェックリスト）を**自律ループ**シナリオに適用したものです。Block Break はインタラクティブセッション向け（hooks が自動トリガー）、Ralph Boost は無人開発ループ向け（Agent ループ / スクリプト駆動）です。コードは完全に独立していますが、コンセプトは共有しています。

### Block Break のスキルファイルを検証するには？

[Skill Lint](skill-lint-guide.md) を使ってください：`/skill-lint .`

---

## ライセンス

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
