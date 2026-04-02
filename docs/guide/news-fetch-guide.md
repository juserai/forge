# News Fetch User Guide

> Get started in 3 minutes — let AI fetch your news briefing

Burned out from debugging? Take 2 minutes, catch up on what's happening in the world, and come back refreshed.

---

## Install

### Claude Code (recommended)

```bash
claude plugin add juserch/jskills
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Zero dependencies** — News Fetch requires no external services or API keys. Install and go.

---

## Commands

| Command | What it does | When to use |
|---------|-------------|-------------|
| `/news-fetch AI` | Fetch this week's AI news | Quick industry update |
| `/news-fetch AI today` | Fetch today's AI news | Daily briefing |
| `/news-fetch robotics month` | Fetch this month's robotics news | Monthly review |
| `/news-fetch climate 2026-03-01~2026-03-31` | Fetch news for a specific date range | Targeted research |

---

## Use Cases

### Daily tech briefing

```
/news-fetch AI today
```

Get the latest AI news for today, ranked by relevance. Scan headlines and summaries in seconds.

### Industry research

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Pull news for a specific time period to support market analysis and competitive research.

### Cross-language news

Chinese topics automatically get supplementary English searches for broader coverage, and vice versa. You get the best of both worlds without extra effort.

---

## Expected Output Example

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

## 3-Tier Network Fallback

News Fetch has a built-in fallback strategy to ensure news retrieval works across different network conditions:

| Tier | Tool | Data Source | Trigger |
|------|------|-------------|---------|
| **L1** | WebSearch | Google/Bing | Default (preferred) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 fails |
| **L3** | Bash curl | Same as L2 sources | L2 also fails |

When all tiers fail, a structured failure report is produced listing the failure reason for each source.

---

## Output Features

| Feature | Description |
|---------|-------------|
| **Deduplication** | When multiple sources cover the same event, the highest-scoring entry is kept; others are collapsed into "Related coverage" |
| **Summary completion** | If search results lack a summary, the article body is fetched and a summary is generated |
| **Relevance scoring** | AI scores each result by topic relevance — higher means more relevant |
| **Clickable links** | Markdown link format — clickable in IDEs and terminals |

---

## FAQ

### Do I need an API key?

No. News Fetch relies entirely on WebSearch and public web scraping. Zero configuration required.

### Can it fetch English-language news?

Absolutely. Chinese topics automatically include supplementary English searches, and English topics work natively. Coverage spans both languages.

### What if my network is restricted?

The 3-tier fallback strategy handles this automatically. Even if WebSearch is unavailable, News Fetch falls back to domestic news sources.

### How many articles does it return?

Up to 20 (after deduplication). The actual count depends on what the data sources return.

---

## License

[MIT](../../LICENSE) - [juserch](https://github.com/juserch)
