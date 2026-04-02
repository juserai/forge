# News Fetch -- उपयोगकर्ता गाइड

> 3 मिनट में शुरू करें -- AI से अपनी news briefing लाएँ

Debugging से थक गए? 2 मिनट लो, दुनिया में क्या हो रहा है जान लो, और तरोताज़ा होकर वापस आओ।

---

## Install करें

### Claude Code (recommended)

```bash
claude plugin add juserch/jskills
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Zero dependencies** -- News Fetch को किसी external service या API key की ज़रूरत नहीं। Install करो और शुरू हो जाओ।

---

## Commands

| Command | क्या करता है | कब use करें |
|---------|-------------|-------------|
| `/news-fetch AI` | इस हफ़्ते की AI news लाएँ | Quick industry update |
| `/news-fetch AI today` | आज की AI news लाएँ | Daily briefing |
| `/news-fetch robotics month` | इस महीने की robotics news | Monthly review |
| `/news-fetch climate 2026-03-01~2026-03-31` | Specific date range की news | Targeted research |

---

## Use Cases

### Daily tech briefing

```
/news-fetch AI today
```

आज की latest AI news पाएँ, relevance के अनुसार ranked। Headlines और summaries सेकंडों में scan करें।

### Industry research

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Market analysis और competitive research के लिए specific time period की news pull करें।

### Cross-language news

Chinese topics को automatically supplementary English searches मिलते हैं broader coverage के लिए, और vice versa। बिना extra effort के दोनों दुनिया का best मिलता है।

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

News Fetch में built-in fallback strategy है ताकि अलग-अलग network conditions में news retrieval काम करे:

| Tier | Tool | Data Source | Trigger |
|------|------|-------------|---------|
| **L1** | WebSearch | Google/Bing | Default (preferred) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 fail होता है |
| **L3** | Bash curl | L2 जैसे ही sources | L2 भी fail होता है |

जब सभी tiers fail होते हैं, तो एक structured failure report बनता है जिसमें हर source की failure reason listed होती है।

---

## Output Features

| Feature | विवरण |
|---------|-------|
| **Deduplication** | जब multiple sources same event cover करते हैं, highest-scoring entry रखी जाती है; बाकी "Related coverage" में collapse हो जाते हैं |
| **Summary completion** | अगर search results में summary नहीं है, तो article body fetch होता है और summary generate होता है |
| **Relevance scoring** | AI हर result को topic relevance से score करता है -- ज़्यादा score = ज़्यादा relevant |
| **Clickable links** | Markdown link format -- IDEs और terminals में clickable |

---

## FAQ

### क्या API key चाहिए?

नहीं। News Fetch पूरी तरह WebSearch और public web scraping पर rely करता है। Zero configuration ज़रूरी है।

### क्या English-language news fetch कर सकता है?

बिल्कुल। Chinese topics में automatically supplementary English searches शामिल होते हैं, और English topics natively काम करते हैं। दोनों languages में coverage मिलती है।

### अगर मेरा network restricted है तो?

3-tier fallback strategy इसे automatically handle करती है। अगर WebSearch unavailable भी हो, तो News Fetch domestic news sources पर fall back करता है।

### कितने articles return होते हैं?

20 तक (deduplication के बाद)। Actual count इस पर depend करता है कि data sources क्या return करते हैं।

---

## License

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
