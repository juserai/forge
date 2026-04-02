# Skill Lint -- उपयोगकर्ता गाइड

> 3 मिनट में शुरू करें -- अपने Claude Code skill की quality validate करें

---

## Install करें

### Claude Code (recommended)

```bash
claude plugin add juserch/jskills
```

### Universal one-line install

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Zero dependencies** -- Skill Lint को किसी external service या API की ज़रूरत नहीं। Install करो और शुरू हो जाओ।

---

## Commands

| Command | क्या करता है | कब use करें |
|---------|-------------|-------------|
| `/skill-lint` | Usage info दिखाएँ | Available checks देखें |
| `/skill-lint .` | Current project lint करें | Development के दौरान self-check |
| `/skill-lint /path/to/plugin` | Specific path lint करें | किसी और plugin का review |

---

## Use Cases

### नया skill बनाने के बाद self-check

`skills/<name>/SKILL.md`, `commands/<name>.md`, और related files बनाने के बाद `/skill-lint .` run करें ताकि confirm हो कि structure complete है, frontmatter correct है, और marketplace entry add हो गई है।

### किसी और का plugin review करें

PR review करते समय या किसी और plugin audit करते समय, file completeness और consistency की quick check के लिए `/skill-lint /path/to/plugin` use करें।

### CI integration

`scripts/skill-lint.sh` directly CI pipeline में run हो सकता है, automated parsing के लिए JSON output:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Check Items

### Structural Checks (Bash script द्वारा execute)

| Rule | क्या check करता है | Severity |
|------|-------------------|----------|
| S01 | `plugin.json` root और `.claude-plugin/` दोनों में exist करता है | error |
| S02 | `.claude-plugin/marketplace.json` exist करता है | error |
| S03 | हर `skills/<name>/` में `SKILL.md` है | error |
| S04 | SKILL.md frontmatter में `name` और `description` हैं | error |
| S05 | हर skill का corresponding `commands/<name>.md` है | warning |
| S06 | हर skill marketplace.json के `plugins` array में listed है | warning |
| S07 | SKILL.md में cited references files actually exist करती हैं | error |
| S08 | `evals/<name>/scenarios.md` exist करता है | warning |

### Semantic Checks (AI द्वारा execute)

| Rule | क्या check करता है | Severity |
|------|-------------------|----------|
| M01 | Description clearly purpose और trigger conditions state करता है | warning |
| M02 | Name directory name से match करता है; description सभी files में consistent है | warning |
| M03 | Command routing logic correctly skill name reference करती है | warning |
| M04 | References content logically SKILL.md से consistent है | warning |
| M05 | Eval scenarios core functionality paths cover करते हैं (कम से कम 5) | warning |

---

## Expected Output Examples

### सभी checks pass

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────┘
```

### Issues मिलीं

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Workflow

```
/skill-lint [path]
      │
      ▼
  Run skill-lint.sh ──→ JSON structural check results
      │
      ▼
  AI reads skill files ──→ Semantic checks
      │
      ▼
  Merged output (error > warning > passed)
```

---

## FAQ

### क्या सिर्फ़ structural checks run कर सकते हैं, semantic checks बिना?

हाँ -- bash script directly run करें:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

यह बिना AI semantic analysis के pure JSON output देता है।

### क्या non-jskills projects पर काम करता है?

हाँ। कोई भी directory जो standard Claude Code plugin structure (`skills/`, `commands/`, `.claude-plugin/`) follow करती है, validate हो सकती है।

### Errors और warnings में क्या फ़र्क है?

- **error**: Structural issues जो skill को correctly load या publish होने से रोकेंगी
- **warning**: Quality issues जो functionality नहीं तोड़ेंगी लेकिन maintainability और discoverability affect करती हैं

### अन्य jskills tools

Skill Lint jskills collection का हिस्सा है और इन skills के साथ अच्छे से काम करता है:

- [Block Break](block-break-guide.md) -- High-agency behavioral constraint engine जो AI को हर approach exhaust करने पर force करता है
- [Ralph Boost](ralph-boost-guide.md) -- Autonomous dev loop engine जिसमें built-in Block Break convergence guarantees हैं

नया skill develop करने के बाद, `/skill-lint .` run करें ताकि structural completeness verify हो और confirm हो कि frontmatter, marketplace.json, और reference links सब correct हैं।

---

## License

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
