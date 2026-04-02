# J Skills

> Work harder, then take a break. 4 skills for a better coding rhythm with Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-4-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[中文](docs/i18n/README.zh-CN.md) | [日本語](docs/i18n/README.ja.md) | [한국어](docs/i18n/README.ko.md) | [Español](docs/i18n/README.es.md) | [Português](docs/i18n/README.pt-BR.md) | [Français](docs/i18n/README.fr.md) | [Deutsch](docs/i18n/README.de.md) | [Русский](docs/i18n/README.ru.md) | [हिन्दी](docs/i18n/README.hi.md) | [Türkçe](docs/i18n/README.tr.md) | [Tiếng Việt](docs/i18n/README.vi.md)

### Quick Demo

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

## Install

```bash
# Claude Code (one command)
claude plugin add juserch/jskills

# OpenClaw
git clone https://github.com/juserch/jskills.git
cp -r jskills/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Work harder

| Skill | What it does | Try it |
|-------|-------------|--------|
| **block-break** | Forces exhaustive problem-solving before giving up | `/block-break` |
| **ralph-boost** | Autonomous dev loops with convergence guarantee | `/ralph-boost setup` |
| **skill-lint** | Validate any Claude Code skill plugin | `/skill-lint .` |

### Take a break

| Skill | What it does | Try it |
|-------|-------------|--------|
| **news-fetch** | Quick news between coding sessions | `/news-fetch AI today` |

---

## Block Break — Behavioral Constraint Engine

Your AI gave up? `/block-break` forces it to exhaust every approach first.

When Claude gets stuck, Block Break activates a pressure escalation system that prevents premature surrender. It forces the agent through increasingly rigorous problem-solving stages before allowing any kind of "I can't do this" response.

| Mechanism | Description |
|-----------|-------------|
| **3 Red Lines** | Closed-loop verification / Fact-driven / Exhaust all options |
| **Pressure Escalation** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **5-Step Method** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **7-Point Checklist** | Mandatory diagnostic checklist at L3+ |
| **Anti-Rationalization** | Identifies and blocks 14 common excuse patterns |
| **Hooks** | Auto frustration detection + failure counting + state persistence |

```text
/block-break              # Activate Block Break mode
/block-break L2           # Start at a specific pressure level
/block-break fix the bug  # Activate and immediately start a task
```

Also triggers via natural language: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, etc. (auto-detected by hooks).

> Inspired by [PUA](https://github.com/tanweai/pua), distilled into a zero-dependency skill.

## Ralph Boost — Autonomous Dev Loop Engine

Autonomous dev loops that actually converge. Setup in 30 seconds.

Replicates ralph-claude-code's autonomous loop capability as a skill, with built-in Block Break L0-L4 pressure escalation to guarantee convergence. Solves the "spinning without progress" problem in autonomous loops.

| Feature | Description |
|---------|-------------|
| **Dual-Path Loop** | Agent loop (primary, zero external deps) + bash script fallback (jq/python engines) |
| **Enhanced Circuit Breaker** | L0-L4 pressure escalation built-in: from "give up after 3 rounds" to "6-7 rounds of progressive self-rescue" |
| **State Tracking** | Unified state.json for circuit breaker + pressure + strategy + session |
| **Graceful Handoff** | L4 generates structured handoff report instead of raw crash |
| **Independent** | Uses `.ralph-boost/` directory, no dependency on ralph-claude-code |

```text
/ralph-boost setup        # Initialize project
/ralph-boost run          # Start autonomous loop
/ralph-boost status       # Check current state
/ralph-boost clean        # Clean up
```

> Inspired by [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), reimagined as a zero-dependency skill with convergence guarantee.

## Skill Lint — Skill Plugin Validator

Validate your Claude Code plugins in one command.

Checks structural integrity and semantic quality of skill files in any Claude Code plugin project. Bash scripts handle structural checks, AI handles semantic checks — complementary coverage.

| Check Type | Description |
|------------|-------------|
| **Structural** | Frontmatter required fields / file existence / reference links / marketplace entries |
| **Semantic** | Description quality / name consistency / command routing / eval coverage |

```text
/skill-lint              # Show usage
/skill-lint .            # Validate current project
/skill-lint /path/to/plugin  # Validate a specific path
```

## News Fetch — Your Mental Break Between Sprints

Burned out from debugging? `/news-fetch` — your 2-minute mental break.

The other three skills push you to work harder. This one reminds you to take a breath. Grab the latest news on any topic, right from your terminal — no context switching, no browser rabbit holes. Just a quick scan and back to work, refreshed.

| Feature | Description |
|---------|-------------|
| **3-Tier Fallback** | L1 WebSearch → L2 WebFetch (regional sources) → L3 curl |
| **Dedup & Merge** | Same event from multiple sources auto-merged, highest-scoring kept |
| **Relevance Scoring** | AI scores and sorts by topic match |
| **Auto-Summary** | Missing abstracts auto-generated from article body |

```text
/news-fetch AI                    # This week's AI news
/news-fetch AI today              # Today's AI news
/news-fetch robotics month        # This month's robotics news
/news-fetch climate 2026-03-01~2026-03-31  # Custom date range
```

## Quality

- 10+ eval scenarios per skill with automated trigger tests
- Self-validated by its own skill-lint
- Zero external dependencies — zero risk
- MIT licensed, fully open source

## Project Structure

```text
jskills/
├── skills/                        # Claude Code platform
│   └── <skill>/
│       ├── SKILL.md               # Skill definition
│       ├── references/            # Detailed content (loaded on demand)
│       ├── scripts/               # Helper scripts
│       └── agents/                # Sub-agent definitions
├── platforms/                     # Other platform adaptations
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
│   └── i18n/                      # Translations (zh-CN, ja, ko)
│       ├── README.*.md            # Translated READMEs
│       └── guide/{zh-CN,ja,ko}/   # Translated guides
└── plugin.json                    # Collection metadata
```

## Contributing

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw adaptation + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Eval scenarios
4. `.claude-plugin/marketplace.json` — Add entry to `plugins` array
5. Hooks if needed in `hooks/hooks.json`

See [CLAUDE.md](CLAUDE.md) for full development guidelines.

## License

[MIT](LICENSE) - [juserch](https://github.com/juserch)
