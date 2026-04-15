# Forge

> और मेहनत करो, फिर ब्रेक लो। Claude Code के साथ बेहतर कोडिंग रिदम के लिए 5 skills।

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-5-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

### क्विक डेमो

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## इंस्टॉल करें

```bash
# Claude Code (एक कमांड)
claude plugin add juserai/forge

# OpenClaw
git clone https://github.com/juserai/forge.git
cp -r forge/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Hammer

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **block-break** | हार मानने से पहले हर approach try करने पर मजबूर करता है | `/block-break` |
| **ralph-boost** | Convergence guarantee के साथ autonomous dev loops | `/ralph-boost setup` |

### Crucible

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **council-fuse** | बेहतर जवाबों के लिए बहु-दृष्टिकोण विचार-विमर्श | `/council-fuse <question>` |
| **tome-forge** | LLM-संकलित wiki के साथ व्यक्तिगत ज्ञान आधार | `/tome-forge init` |

### Anvil

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **skill-lint** | किसी भी Claude Code skill plugin को validate करें | `/skill-lint .` |

### Quench

| Skill | क्या करता है | आज़माएँ |
|-------|-------------|---------|
| **news-fetch** | कोडिंग sessions के बीच ताज़ा खबरें | `/news-fetch AI today` |

---

## Block Break — Behavioral Constraint Engine

आपका AI हार गया? `/block-break` उसे पहले हर approach exhaust करने पर मजबूर करेगा।

जब Claude अटक जाता है, Block Break एक pressure escalation system activate करता है जो समय से पहले हार मानने से रोकता है। Agent को increasingly rigorous problem-solving stages से गुज़रना पड़ता है, इससे पहले कि वो "मैं ये नहीं कर सकता" जैसा कोई response दे सके।

| मैकेनिज़्म | विवरण |
|-----------|--------|
| **3 Red Lines** | Closed-loop verification / Fact-driven / सभी options exhaust करो |
| **Pressure Escalation** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **5-Step Method** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **7-Point Checklist** | L3+ पर mandatory diagnostic checklist |
| **Anti-Rationalization** | 14 common excuse patterns को identify और block करता है |
| **Hooks** | Auto frustration detection + failure counting + state persistence |

```text
/block-break              # Block Break mode activate करें
/block-break L2           # किसी specific pressure level से शुरू करें
/block-break fix the bug  # Activate करें और तुरंत task शुरू करें
```

Natural language से भी trigger होता है: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, आदि (hooks द्वारा auto-detect)।

> [PUA](https://github.com/tanweai/pua) से प्रेरित, zero-dependency skill में distill किया गया।

## Ralph Boost — Autonomous Dev Loop Engine

Autonomous dev loops जो सच में converge होते हैं। 30 सेकंड में setup।

ralph-claude-code की autonomous loop capability को skill के रूप में replicate करता है, convergence guarantee के लिए built-in Block Break L0-L4 pressure escalation के साथ। Autonomous loops में "घूम रहा है पर आगे नहीं बढ़ रहा" की problem solve करता है।

| फ़ीचर | विवरण |
|-------|--------|
| **Dual-Path Loop** | Agent loop (primary, zero external deps) + bash script fallback (jq/python engines) |
| **Enhanced Circuit Breaker** | Built-in L0-L4 pressure escalation: "3 rounds बाद हार मान लो" से "6-7 rounds progressive self-rescue" तक |
| **State Tracking** | Circuit breaker + pressure + strategy + session के लिए unified state.json |
| **Graceful Handoff** | L4 पर raw crash की जगह structured handoff report generate होती है |
| **Independent** | `.ralph-boost/` directory use करता है, ralph-claude-code पर कोई dependency नहीं |

```text
/ralph-boost setup        # प्रोजेक्ट initialize करें
/ralph-boost run          # Autonomous loop शुरू करें
/ralph-boost status       # Current state check करें
/ralph-boost clean        # Clean up करें
```

> [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) से प्रेरित, convergence guarantee के साथ zero-dependency skill के रूप में reimagine किया गया।

## Skill Lint — Skill Plugin Validator

अपने Claude Code plugins को एक command में validate करें।

किसी भी Claude Code plugin project में skill files की structural integrity और semantic quality check करता है। Bash scripts structural checks handle करते हैं, AI semantic checks — complementary coverage।

| Check Type | विवरण |
|------------|--------|
| **Structural** | Frontmatter required fields / file existence / reference links / marketplace entries |
| **Semantic** | Description quality / name consistency / command routing / eval coverage |

```text
/skill-lint              # Usage दिखाएँ
/skill-lint .            # Current project validate करें
/skill-lint /path/to/plugin  # Specific path validate करें
```

## News Fetch — Sprints के बीच Mental Break

Debugging से थक गए? `/news-fetch` — आपका 2 मिनट का mental break।

बाकी तीन skills आपसे और मेहनत करवाते हैं। यह वाला याद दिलाता है कि साँस लो। किसी भी topic पर latest news सीधे अपने terminal में पाएँ — कोई context switching नहीं, कोई browser rabbit holes नहीं। बस quick scan और वापस काम पर, तरोताज़ा होकर।

| फ़ीचर | विवरण |
|-------|--------|
| **3-Tier Fallback** | L1 WebSearch → L2 WebFetch (regional sources) → L3 curl |
| **Dedup & Merge** | Multiple sources से same event auto-merge, highest-scoring रखा जाता है |
| **Relevance Scoring** | AI topic match के हिसाब से score और sort करता है |
| **Auto-Summary** | Missing abstracts article body से auto-generate होते हैं |

```text
/news-fetch AI                    # इस हफ़्ते की AI news
/news-fetch AI today              # आज की AI news
/news-fetch robotics month        # इस महीने की robotics news
/news-fetch climate 2026-03-01~2026-03-31  # Custom date range
```

## क्वालिटी

- हर skill के लिए 10+ eval scenarios, automated trigger tests के साथ
- खुद अपने skill-lint से self-validate किया हुआ
- Zero external dependencies — zero risk
- MIT licensed, पूरी तरह open source

## प्रोजेक्ट स्ट्रक्चर

```text
forge/
├── skills/                        # Claude Code प्लेटफ़ॉर्म
│   └── <skill>/
│       ├── SKILL.md               # Skill definition
│       ├── references/            # विस्तृत content (demand पर load)
│       ├── scripts/               # Helper scripts
│       └── agents/                # Sub-agent definitions
├── platforms/                     # अन्य platform adaptations
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # OpenClaw adaptation
│           ├── references/        # Platform-specific content
│           └── scripts/           # Platform-specific scripts
├── .claude-plugin/                # Claude Code marketplace metadata
├── hooks/                         # Claude Code platform hooks
├── evals/                         # Cross-platform eval scenarios
├── docs/
│   ├── guide/                     # User guides (English)
│   ├── plans/                     # Design documents
│   └── i18n/                      # Translations
│       ├── README.*.md            # Translated READMEs
│       └── guide/{zh-CN,ja,ko}/   # Translated guides
└── plugin.json                    # Collection metadata
```

## योगदान करें

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw adaptation + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Eval scenarios
4. `.claude-plugin/marketplace.json` — `plugins` array में entry add करें
5. ज़रूरत हो तो `hooks/hooks.json` में hooks

पूरी development guidelines के लिए [CLAUDE.md](../../CLAUDE.md) देखें।

## लाइसेंस

[MIT](../../LICENSE) - [Juneq Cheung](https://github.com/juserai)
