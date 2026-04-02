# Ralph Boost -- उपयोगकर्ता गाइड

> 5 मिनट में शुरू करें -- अपने AI autonomous dev loop को रुकने न दें

---

## Install करें

### Claude Code (recommended)

```bash
claude plugin add juserch/jskills
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Zero dependencies** -- Ralph Boost ralph-claude-code, block-break, या किसी external service पर depend नहीं करता। Primary path (Agent loop) में zero external dependencies हैं; fallback path के लिए `jq` या `python` और `claude` CLI चाहिए।

---

## Commands

| Command | क्या करता है | कब use करें |
|---------|-------------|-------------|
| `/ralph-boost setup` | अपने project में autonomous loop initialize करें | पहली बार setup |
| `/ralph-boost run` | Current session में autonomous loop शुरू करें | Initialization के बाद |
| `/ralph-boost status` | Current loop state देखें | Progress monitor करें |
| `/ralph-boost clean` | Loop files remove करें | Cleanup |

---

## Quick Start

### 1. Project initialize करें

```text
/ralph-boost setup
```

Claude आपको guide करेगा:
- Project name detect करना
- Task list generate करना (fix_plan.md)
- `.ralph-boost/` directory और सभी configuration files create करना

### 2. Loop शुरू करें

```text
/ralph-boost run
```

Claude current session में directly autonomous loop drive करता है (Agent loop mode)। हर iteration में एक sub-agent spawn होता है task execute करने के लिए, जबकि main session loop controller की तरह state manage करता है।

**Fallback** (headless / unattended environments):

```bash
# Foreground
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Background
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Status monitor करें

```text
/ralph-boost status
```

Example output:

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

## कैसे काम करता है

### Autonomous Loop

Ralph Boost दो execution paths provide करता है:

**Primary path (Agent loop)**: Claude current session में loop controller की तरह काम करता है, हर iteration में task execute करने के लिए sub-agent spawn करता है। Main session state, circuit breaker, और pressure escalation manage करती है। Zero external dependencies।

**Fallback (bash script)**: `boost-loop.sh` background में loop में `claude -p` calls run करता है। jq और python दोनों JSON engines के रूप में support करता है, runtime पर auto-detect होता है। Iterations के बीच default sleep 1 घंटा है (configurable)।

दोनों paths same state management (state.json), pressure escalation logic, और BOOST_STATUS protocol share करते हैं।

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Enhanced Circuit Breaker (vs ralph-claude-code)

ralph-claude-code का circuit breaker: 3 consecutive loops बिना progress के बाद हार मान लेता है।

ralph-boost का circuit breaker: stuck होने पर **progressively pressure बढ़ाता है**, shutdown से पहले 6-7 loops तक self-recovery करता है।

```
Progress detected → L0 (reset, normal work continue)

No progress:
  1 loop  → L1 Disappointment (approach switch force)
  2 loops → L2 Interrogation (error शब्द-दर-शब्द पढ़ो + source search + 3 hypotheses)
  3 loops → L3 Performance Review (7-point checklist पूरी करो)
  4 loops → L4 Graduation (minimal PoC + handoff report लिखो)
  5+ loops → Graceful shutdown (structured handoff report के साथ)
```

---

## Expected Output Examples

### L0 -- Normal Execution

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

### L1 -- Approach Switch

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude को पिछला approach छोड़कर कुछ **मौलिक रूप से अलग** try करना पड़ता है। Parameters tweak करना count नहीं होता।

### L2 -- Search और Hypothesize

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude को ज़रूरी है: error शब्द-दर-शब्द पढ़ना -> 50+ lines context search करना -> 3 अलग hypotheses list करना।

### L3 -- Checklist

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude को 7-point checklist पूरी करनी होती है (error signals पढ़ो, core problem search करो, source पढ़ो, assumptions verify करो, hypothesis reverse करो, minimal reproduction, tools/methods switch करो)। हर completed item state.json में लिखा जाता है।

### L4 -- Graceful Handoff

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude minimal PoC build करता है, फिर handoff report generate करता है:

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

Handoff complete होने के बाद loop gracefully shut down हो जाता है। यह "मैं नहीं कर सकता" नहीं है -- यह "यहाँ boundary है" है।

---

## Configuration

`.ralph-boost/config.json`:

| Field | Default | विवरण |
|-------|---------|-------|
| `max_calls_per_hour` | 100 | प्रति घंटा maximum Claude API calls |
| `claude_timeout_minutes` | 15 | प्रति individual call timeout |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Claude के लिए available tools |
| `claude_model` | "" | Model override (खाली = default) |
| `session_expiry_hours` | 24 | Session expiration time |
| `no_progress_threshold` | 7 | Shutdown से पहले no-progress threshold |
| `same_error_threshold` | 8 | Shutdown से पहले same-error threshold |
| `sleep_seconds` | 3600 | Iterations के बीच wait time (seconds) |

### Common configuration tweaks

**Loop speed बढ़ाएँ** (testing के लिए):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Tool permissions restrict करें**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Specific model use करें**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Project Directory Structure

```
.ralph-boost/
├── PROMPT.md           # Dev instructions (block-break protocol included)
├── fix_plan.md         # Task list (Claude द्वारा auto-updated)
├── config.json         # Configuration
├── state.json          # Unified state (circuit breaker + pressure + session)
├── handoff-report.md   # L4 handoff report (graceful exit पर generated)
├── logs/
│   ├── boost.log       # Loop log
│   └── claude_output_*.log  # Per-iteration output
└── .gitignore          # State और logs ignore करता है
```

सभी files `.ralph-boost/` के अंदर रहती हैं -- आपका project root कभी touch नहीं होता।

---

## ralph-claude-code से संबंध

Ralph Boost [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) का एक **independent replacement** है, enhancement plugin नहीं।

| पहलू | ralph-claude-code | ralph-boost |
|------|-------------------|-------------|
| Form | Standalone Bash tool | Claude Code skill (Agent loop) |
| Install | `npm install` | Claude Code plugin |
| Code size | 2000+ lines | ~400 lines |
| External deps | jq (required) | Primary path: zero; Fallback: jq या python |
| Directory | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Passive (3 loops के बाद हार मानता है) | Active (L0-L4, 6-7 loops self-recovery) |
| Coexistence | हाँ | हाँ (zero file conflicts) |

दोनों एक ही project में simultaneously install हो सकते हैं -- अलग directories use करते हैं और एक-दूसरे को interfere नहीं करते।

---

## Block Break से संबंध

Ralph Boost Block Break के core mechanisms (pressure escalation, 5-step methodology, checklist) को autonomous loop scenarios के लिए adapt करता है:

| पहलू | block-break | ralph-boost |
|------|-------------|-------------|
| Scenario | Interactive sessions | Autonomous loops |
| Activation | Hooks auto-trigger | Agent loop / loop script में built-in |
| Detection | PostToolUse hook | Agent loop progress detection / script progress detection |
| Control | Hook-injected prompts | Agent prompt injection / --append-system-prompt |
| State | `~/.juserch-skills/` | `.ralph-boost/state.json` |

Code पूरी तरह independent है; concepts shared हैं।

> **Reference**: Block Break की pressure escalation (L0-L4), 5-step methodology, और 7-point checklist ralph-boost के circuit breaker की conceptual foundation बनाते हैं। Details के लिए [Block Break User Guide](block-break-guide.md) देखें।

---

## FAQ

### Primary path और fallback में कैसे choose करें?

`/ralph-boost run` default रूप से Agent loop (primary path) use करता है, जो current Claude Code session में directly run होता है। Headless या unattended execution के लिए fallback bash script use करें।

### Loop script कहाँ है?

jskills plugin install करने के बाद, fallback script `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh` पर है। आप इसे कहीं भी copy करके वहाँ से run कर सकते हैं। Script अपना JSON engine (jq या python) auto-detect करता है।

### Loop logs कैसे देखें?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Pressure level manually कैसे reset करें?

`.ralph-boost/state.json` edit करें: `pressure.level` को 0 और `circuit_breaker.consecutive_no_progress` को 0 set करें। या बस state.json delete करके re-initialize करें।

### Task list कैसे modify करें?

`.ralph-boost/fix_plan.md` directly edit करें, `- [ ] task` format use करके। Claude हर iteration की शुरुआत में इसे read करता है।

### Circuit breaker open होने के बाद कैसे recover करें?

`state.json` edit करें, `circuit_breaker.state` को `"CLOSED"` set करें, relevant counters reset करें, और script re-run करें।

### क्या ralph-claude-code चाहिए?

नहीं। Ralph Boost पूरी तरह independent है और किसी Ralph files पर depend नहीं करता।

### कौन से platforms supported हैं?

Currently Claude Code (Agent loop primary path) supported है। Fallback bash script के लिए bash 4+, jq या python, और claude CLI ज़रूरी है।

### ralph-boost की skill files कैसे validate करें?

[Skill Lint](skill-lint-guide.md) use करें: `/skill-lint .`

---

## License

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
