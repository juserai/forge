# News Fetch ユーザーガイド

> 3分で始められます — AI にニュースブリーフィングを取得させましょう

デバッグに疲れましたか？ 2分だけひと休みして、世の中の動きをチェックし、リフレッシュして戻りましょう。

---

## インストール

### Claude Code（推奨）

```bash
claude plugin add juserch/jskills
```

### ワンライン・ユニバーサルインストール

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **ゼロ依存** — News Fetch は外部サービスや API キーを一切必要としません。インストールしたらすぐ使えます。

---

## コマンド

| コマンド | 機能 | 使うタイミング |
|---------|------|--------------|
| `/news-fetch AI` | 今週の AI ニュースを取得 | 業界の最新情報をすばやく確認 |
| `/news-fetch AI today` | 今日の AI ニュースを取得 | デイリーブリーフィング |
| `/news-fetch robotics month` | 今月のロボティクスニュースを取得 | 月次レビュー |
| `/news-fetch climate 2026-03-01~2026-03-31` | 特定の期間のニュースを取得 | ターゲットを絞ったリサーチ |

---

## ユースケース

### 日次テックブリーフィング

```
/news-fetch AI today
```

今日の最新 AI ニュースを関連性順で取得します。見出しと要約を数秒でスキャンできます。

### 業界リサーチ

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

特定の期間のニュースを取得し、市場分析や競合調査をサポートします。

### クロスランゲージニュース

中国語のトピックでは自動的に英語の補足検索が行われ、より幅広いカバレッジが得られます。逆もまた同様です。追加の手間なく、両言語のベストな情報が手に入ります。

---

## 出力例

```markdown
## AI News

Monday, March 30, 2026

TOP 5

### 1. OpenAI Releases GPT-5 Multimodal Edition

**Reuters** | Relevance score: 223.0

OpenAI officially released GPT-5 with native video comprehension
and real-time voice conversation. Pricing is 40% lower than the
previous generation. The model surpasses its predecessor across
multiple benchmarks...

[Read more](https://example.com/article1)
Related coverage: [TechCrunch](https://example.com/a2) | [The Verge](https://example.com/a3)

### 2. CIX Tech Closes ~$140M Series B

**TechNode** | Relevance score: 118.0

CIX Tech closed a near-$140M Series B round and unveiled its first
agent-class CPU — the CIX ClawCore series, spanning low-power to
high-performance use cases...

[Read more](https://example.com/article2)

---
5 items total | Source: L1 WebSearch
```

---

## 3階層ネットワークフォールバック

News Fetch には、さまざまなネットワーク環境でニュース取得を確実に行うためのフォールバック戦略が組み込まれています：

| 階層 | ツール | データソース | トリガー |
|------|--------|------------|---------|
| **L1** | WebSearch | Google/Bing | デフォルト（優先） |
| **L2** | WebFetch | Baidu News、Sina、NetEase | L1 が失敗した場合 |
| **L3** | Bash curl | L2 と同じソース | L2 も失敗した場合 |

すべての階層が失敗した場合、各ソースの失敗理由を記載した構造化レポートが生成されます。

---

## 出力機能

| 機能 | 説明 |
|------|------|
| **重複排除** | 複数のソースが同じ出来事を報じている場合、最高スコアのエントリを残し、他は「関連報道」に集約 |
| **要約補完** | 検索結果に要約がない場合、記事本文を取得して要約を生成 |
| **関連性スコアリング** | AI がトピックとの関連性を基に各結果をスコアリング — 高いほど関連性が高い |
| **クリック可能なリンク** | Markdown リンク形式 — IDE やターミナルでクリック可能 |

---

## よくある質問

### API キーは必要ですか？

いいえ。News Fetch は WebSearch とパブリックなウェブスクレイピングのみに依存しています。設定は一切不要です。

### 英語のニュースも取得できますか？

もちろんです。中国語のトピックには自動的に英語の補足検索が含まれ、英語のトピックはネイティブに動作します。両言語をカバーしています。

### ネットワークが制限されている場合は？

3階層フォールバック戦略が自動的に対応します。WebSearch が利用できなくても、News Fetch は国内のニュースソースにフォールバックします。

### 何件の記事が返されますか？

最大20件（重複排除後）。実際の件数はデータソースから返される結果によります。

---

## ライセンス

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
