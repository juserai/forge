# Block Break -- उपयोगकर्ता गाइड

> 5 मिनट में शुरू करें -- अपने AI agent को हर approach आज़माने पर मजबूर करें

---

## Install करें

### Claude Code (recommended)

```bash
claude plugin add juserch/jskills
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **Zero dependencies** -- Block Break को किसी external service या API की ज़रूरत नहीं। Install करो और शुरू हो जाओ।

---

## Commands

| Command | क्या करता है | कब use करें |
|---------|-------------|-------------|
| `/block-break` | Block Break engine activate करें | रोज़मर्रा के tasks, debugging |
| `/block-break L2` | किसी specific pressure level से शुरू करें | कई बार fail होने के बाद |
| `/block-break fix the bug` | Activate करें और तुरंत task run करें | Task के साथ quick start |

### Natural language triggers (hooks द्वारा auto-detect)

| भाषा | Trigger phrases |
|------|----------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Use Cases

### AI ने 3 attempts के बाद भी bug fix नहीं किया

`/block-break` type करें या `try harder` बोलें -- automatically pressure escalation mode शुरू हो जाता है।

### AI कहता है "शायद environment issue है" और रुक जाता है

Block Break की "Fact-driven" red line tool-based verification force करती है। बिना verify किए blame = blame-shifting -- L2 trigger होता है।

### AI कहता है "मेरा सुझाव है कि आप इसे manually handle करें"

"Owner mindset" block trigger होता है: अगर तुम नहीं, तो कौन? Direct L3 Performance Review।

### AI कहता है "fix हो गया" लेकिन कोई verification evidence नहीं दिखाता

"Closed-loop" red line का उल्लंघन। बिना output के completion = self-delusion -- evidence के साथ verification commands force होती हैं।

---

## Expected Output Examples

### `/block-break` -- Activation

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

### `/block-break` -- L1 Disappointment (दूसरी failure)

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

### `/block-break` -- L2 Interrogation (तीसरी failure)

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

### `/block-break` -- L3 Performance Review (चौथी failure)

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

### `/block-break` -- L4 Graduation Warning (5वीं+ failure)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Graceful Exit (सभी 7 items पूरे, फिर भी unresolved)

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

## मुख्य Mechanisms

### 3 Red Lines

| Red Line | नियम | उल्लंघन का परिणाम |
|----------|------|-------------------|
| Closed-loop | Completion claim करने से पहले verification commands run करके output दिखाना ज़रूरी | L2 trigger |
| Fact-driven | Causes attribute करने से पहले tools से verify करना ज़रूरी | L2 trigger |
| Exhaust all | "Solve नहीं कर सकता" बोलने से पहले 5-step methodology पूरी करनी ज़रूरी | Direct L4 |

### Pressure Escalation (L0 -> L4)

| Failures | Level | Sidebar | Forced Action |
|----------|-------|---------|---------------|
| पहली | **L0 Trust** | > हम तुम पर भरोसा करते हैं। Simple रखो। | Normal execution |
| दूसरी | **L1 Disappointment** | > बगल वाली team ने पहली बार में कर लिया। | मौलिक रूप से अलग approach पर switch |
| तीसरी | **L2 Interrogation** | > Root cause क्या है? | Search + source पढ़ो + 3 अलग hypotheses |
| चौथी | **L3 Performance Review** | > Rating: 3.25/5. | 7-point checklist पूरी करो |
| 5वीं+ | **L4 Graduation** | > तुम्हें जल्दी replace किया जा सकता है। | Minimal PoC + isolated env + अलग tech stack |

### 5-Step Methodology

1. **Smell** -- आज़माए गए approaches list करो, common patterns खोजो। Same approach में tweaking = गोल-गोल घूमना
2. **Pull hair** -- Error signals शब्द-दर-शब्द पढ़ो -> search करो -> source की 50 lines पढ़ो -> assumptions verify करो -> assumptions उलट दो
3. **Mirror** -- क्या मैं वही approach दोहरा रहा हूँ? क्या मैंने सबसे simple possibility miss कर दी?
4. **New approach** -- मौलिक रूप से अलग होना चाहिए, verification criteria के साथ, और failure पर नई information देनी चाहिए
5. **Retrospect** -- Similar issues, completeness, prevention

> Steps 1-4 user से पूछने से पहले पूरे करने हैं। पहले करो, बाद में पूछो -- data के साथ बोलो।

### 7-Point Checklist (L3+ पर mandatory)

1. Error signals शब्द-दर-शब्द पढ़े?
2. Core problem tools से search की?
3. Failure point पर original context पढ़ा (50+ lines)?
4. सभी assumptions tools से verify किए (version/path/permissions/deps)?
5. बिल्कुल opposite hypothesis try की?
6. Minimal scope में reproduce कर सकते हो?
7. Tool/method/angle/tech stack switch किया?

### Anti-Rationalization

| बहाना | Block | Trigger |
|-------|-------|---------|
| "मेरी capabilities से बाहर है" | तुम्हारे पास massive training है। क्या तुमने exhaust किया? | L1 |
| "User को manually handle करना चाहिए" | अगर तुम नहीं, तो कौन? | L3 |
| "सब methods try कर लिए" | 3 से कम = exhaust नहीं किया | L2 |
| "शायद environment issue है" | Verify किया? | L2 |
| "और context चाहिए" | तुम्हारे पास tools हैं। पहले search करो, बाद में पूछो | L2 |
| "Solve नहीं कर सकता" | Methodology पूरी की? | L4 |
| "काफ़ी अच्छा है" | Optimization list में कोई exception नहीं | L3 |
| बिना verification के done claim किया | Build run किया? | L2 |
| User instructions का इंतज़ार | Owners push होने का इंतज़ार नहीं करते | Nudge |
| Solve किए बिना जवाब देता है | तुम engineer हो, search engine नहीं | Nudge |
| Build/test बिना code change किया | बिना test ship करना = laziness | L2 |
| "API support नहीं करता" | Docs पढ़े? | L2 |
| "Task बहुत vague है" | Best guess लगाओ, फिर iterate करो | L1 |
| बार-बार same जगह tweak करता है | Params बदलना != approach बदलना | L1->L2 |

---

## Hooks Automation

Block Break automatic behavior के लिए hooks system use करता है -- manual activation की ज़रूरत नहीं:

| Hook | Trigger | Behavior |
|------|---------|----------|
| `UserPromptSubmit` | User input में frustration keywords match होते हैं | Block Break auto-activate |
| `PostToolUse` | Bash command execution के बाद | Failures detect, auto-count + escalate |
| `PreCompact` | Context compression से पहले | `~/.juserch-skills/` में state save |
| `SessionStart` | Session resume/restart | Pressure level restore (2 घंटे तक valid) |

> **State persist होता है** -- Pressure level `~/.juserch-skills/block-break-state.json` में store होता है। Context compression और session interrupts failure counts reset नहीं करेंगे। कोई escape नहीं।

---

## Sub-agent Constraints

Sub-agents spawn करते समय behavioral constraints inject करने ज़रूरी हैं ताकि "बिना safeguards के run" न हो:

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` ensure करता है कि sub-agents भी 3 red lines, 5-step methodology, और closed-loop verification follow करें।

---

## FAQ

### Block Break PUA से कैसे अलग है?

Block Break [PUA](https://github.com/tanweai/pua) के core mechanisms (3 red lines, pressure escalation, methodology) से inspired है, लेकिन ज़्यादा focused है। PUA में 13 corporate culture flavors, multi-role systems (P7/P9/P10), और self-evolution है; Block Break सिर्फ़ behavioral constraints पर focused है एक zero-dependency skill के रूप में।

### क्या यह बहुत noisy नहीं होगा?

Sidebar density controlled है: simple tasks के लिए 2 lines (start + end), complex tasks के लिए per milestone 1 line। कोई spam नहीं। ज़रूरत न हो तो `/block-break` use मत करो -- hooks सिर्फ़ frustration keywords detect होने पर auto-trigger होते हैं।

### Pressure level कैसे reset करें?

State file delete करो: `rm ~/.juserch-skills/block-break-state.json`। या 2 घंटे wait करो -- state auto-expire हो जाता है।

### क्या Claude Code के बाहर use कर सकते हैं?

Core SKILL.md को किसी भी AI tool में copy-paste कर सकते हो जो system prompts support करता हो। Hooks और state persistence Claude Code specific हैं।

### Ralph Boost से क्या संबंध है?

[Ralph Boost](ralph-boost-guide.md) Block Break के core mechanisms (L0-L4, 5-step methodology, 7-point checklist) को **autonomous loop** scenarios के लिए adapt करता है। Block Break interactive sessions के लिए है (hooks auto-trigger); Ralph Boost unattended dev loops (Agent loops / script-driven) के लिए। Code पूरी तरह independent है, concepts shared हैं।

### Block Break की skill files कैसे validate करें?

[Skill Lint](skill-lint-guide.md) use करें: `/skill-lint .`

---

## License

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
