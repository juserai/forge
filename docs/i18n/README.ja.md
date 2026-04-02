# J Skills

> 全力で取り組み、ひと休みする。Claude Code との開発リズムを整える 4 つの skill。

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-4-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

## インストール

```bash
# Claude Code（コマンド一発）
claude plugin add juserch/jskills

# OpenClaw
git clone https://github.com/juserch/jskills.git
cp -r jskills/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### 全力で取り組む

| Skill | 機能 | 試してみる |
|-------|------|------------|
| **block-break** | あらゆるアプローチを尽くすまで諦めさせない | `/block-break` |
| **ralph-boost** | 収束を保証する自律型開発ループ | `/ralph-boost setup` |
| **skill-lint** | Claude Code skill プラグインを検証 | `/skill-lint .` |

### ひと休み

| Skill | 機能 | 試してみる |
|-------|------|------------|
| **news-fetch** | コーディングの合間にサッとニュースチェック | `/news-fetch AI today` |

---

## Block Break — 行動制約エンジン

AI がまた諦めた？ `/block-break` であらゆる手段を尽くさせましょう。

Claude が行き詰まると、Block Break はプレッシャー段階的エスカレーションを発動し、早期の投降を阻止します。「もうできません」という回答を許す前に、段階的に厳しくなる問題解決プロセスを強制的に実行させます。

| 仕組み | 説明 |
|--------|------|
| **3 つのレッドライン** | 閉ループ検証 / 事実駆動 / 全選択肢の網羅 |
| **プレッシャーエスカレーション** | L0 信頼 → L1 失望 → L2 尋問 → L3 業績評価 → L4 卒業 |
| **5 ステップメソッド** | 嗅ぎ取る → 髪をかきむしる → 鏡を見る → 新アプローチ → 振り返り |
| **7 項目チェックリスト** | L3 以上で必須の診断チェックリスト |
| **言い訳ブロック** | よくある 14 パターンの言い訳を検知・遮断 |
| **Hooks** | フラストレーション自動検知 + 失敗カウント + 状態永続化 |

```text
/block-break              # Block Break モードを起動
/block-break L2           # 指定のプレッシャーレベルから開始
/block-break fix the bug  # 起動してすぐにタスクを実行
```

自然言語でもトリガーできます：`try harder`、`stop spinning`、`figure it out`、`you keep failing` など（hooks が自動検知）。

> [PUA](https://github.com/tanweai/pua) の核心メカニズムを参考に、ゼロ依存の skill として再構築。

## Ralph Boost — 自律型開発ループエンジン

本当に収束する自律型開発ループ。セットアップは 30 秒。

ralph-claude-code の自律ループ機能を skill として再現し、Block Break L0-L4 プレッシャーエスカレーションを内蔵して収束を保証します。自律ループで「堂々巡り」になる問題を解決します。

| 特徴 | 説明 |
|------|------|
| **デュアルパスループ** | Agent ループ（メイン、外部依存ゼロ）+ bash スクリプトフォールバック（jq/python エンジン） |
| **強化サーキットブレーカー** | L0-L4 プレッシャーエスカレーション内蔵：「3 ラウンドで諦め」から「6-7 ラウンドの段階的自己救済」へ |
| **状態追跡** | サーキットブレーカー + プレッシャー + 戦略 + セッションを統一 state.json で管理 |
| **グレースフルハンドオフ** | L4 到達時、クラッシュではなく構造化されたハンドオフレポートを生成 |
| **独立動作** | `.ralph-boost/` ディレクトリを使用、ralph-claude-code への依存なし |

```text
/ralph-boost setup        # プロジェクトを初期化
/ralph-boost run          # 自律ループを開始
/ralph-boost status       # 現在の状態を確認
/ralph-boost clean        # クリーンアップ
```

> [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) の自律ループ機能を参考に、ゼロ依存の skill として収束保証付きで再構築。

## Skill Lint — Skill プラグインバリデーター

コマンド一発で Claude Code プラグインを検証。

Claude Code plugin プロジェクトの skill ファイルについて、構造の整合性と意味的な品質をチェックします。Bash スクリプトが構造チェックを、AI が意味チェックを担当し、相互に補完します。

| チェック種別 | 説明 |
|-------------|------|
| **構造チェック** | frontmatter 必須フィールド / ファイル存在確認 / references 参照 / marketplace エントリ |
| **意味チェック** | description の品質 / name の一貫性 / command ルーティング / eval カバレッジ |

```text
/skill-lint              # 使い方を表示
/skill-lint .            # 現在のプロジェクトを検証
/skill-lint /path/to/plugin  # 指定パスを検証
```

## News Fetch — スプリントの合間のリフレッシュ

デバッグ疲れしていませんか？ `/news-fetch` で 2 分間の気分転換を。

他の 3 つの skill はあなたを追い込みます。この skill は深呼吸を思い出させてくれます。ターミナルから直接、好きなトピックの最新ニュースを取得できます。コンテキストスイッチ不要、ブラウザの沼にハマる心配もなし。サッと目を通して、リフレッシュしたら仕事に戻りましょう。

| 特徴 | 説明 |
|------|------|
| **3 段フォールバック** | L1 WebSearch → L2 WebFetch（地域ソース）→ L3 curl |
| **重複排除・統合** | 同一イベントの複数ソースを自動統合、最高スコアを保持 |
| **関連性スコアリング** | AI がトピックとの一致度でスコア付け・ソート |
| **自動要約** | 要約がない場合、記事本文から自動生成 |

```text
/news-fetch AI                    # 今週の AI ニュース
/news-fetch AI today              # 今日の AI ニュース
/news-fetch robotics month        # 今月のロボティクスニュース
/news-fetch climate 2026-03-01~2026-03-31  # 期間を指定
```

## 品質保証

- skill ごとに 10 以上の評価シナリオと自動トリガーテスト
- 自前の skill-lint でセルフ検証済み
- 外部依存ゼロ — リスクゼロ
- MIT ライセンス、完全オープンソース

## プロジェクト構成

```text
jskills/
├── skills/                        # Claude Code プラットフォーム
│   └── <skill>/
│       ├── SKILL.md               # Skill 定義
│       ├── references/            # オンデマンドで読み込む詳細コンテンツ
│       ├── scripts/               # ヘルパースクリプト
│       └── agents/                # Sub-agent 定義
├── platforms/                     # 他プラットフォーム対応
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw 向け適応版
│           ├── references/        # プラットフォーム固有コンテンツ
│           └── scripts/           # プラットフォーム固有スクリプト
├── .claude-plugin/                # Claude Code marketplace メタデータ
├── hooks/                         # Claude Code プラットフォーム hooks
├── evals/                         # クロスプラットフォーム評価シナリオ
├── docs/                          # クロスプラットフォームドキュメント
└── plugin.json                    # コレクションメタデータ
```

## コントリビュート

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw 向け適応版 + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — 評価シナリオ
4. `.claude-plugin/marketplace.json` — `plugins` 配列にエントリを追加
5. hooks が必要な場合は `hooks/hooks.json` に追加

開発ガイドラインの詳細は [CLAUDE.md](../../CLAUDE.md) を参照してください。

## License

[MIT](../../LICENSE) - [juserch](https://github.com/juserch)
