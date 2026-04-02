# Skill Lint Benutzerhandbuch

> In 3 Minuten loslegen -- validieren Sie die Qualitaet Ihrer Claude Code Skills

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserch/jskills
```

### Universelle Einzeilige Installation

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Keine Abhaengigkeiten** -- Skill Lint benoetigt keine externen Dienste oder APIs. Installieren und loslegen.

---

## Befehle

| Befehl | Beschreibung | Wann verwenden |
|--------|-------------|----------------|
| `/skill-lint` | Nutzungsinformationen anzeigen | Verfuegbare Pruefungen ansehen |
| `/skill-lint .` | Aktuelles Projekt validieren | Selbstpruefung waehrend der Entwicklung |
| `/skill-lint /path/to/plugin` | Einen bestimmten Pfad validieren | Ueberpruefung eines anderen Plugins |

---

## Anwendungsfaelle

### Selbstpruefung nach der Erstellung eines neuen Skills

Nachdem Sie `skills/<name>/SKILL.md`, `commands/<name>.md` und zugehoerige Dateien erstellt haben, fuehren Sie `/skill-lint .` aus, um zu bestaaetigen, dass die Struktur vollstaendig ist, das Frontmatter korrekt ist und der Marketplace-Eintrag hinzugefuegt wurde.

### Ueberpruefung des Plugins einer anderen Person

Bei der Ueberpruefung einer PR oder dem Audit eines anderen Plugins verwenden Sie `/skill-lint /path/to/plugin` fuer eine schnelle Pruefung der Dateivollstaendigkeit und Konsistenz.

### CI-Integration

`scripts/skill-lint.sh` kann direkt in einer CI-Pipeline ausgefuehrt werden, mit JSON-Ausgabe fuer automatisiertes Parsing:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Pruefungselemente

### Strukturelle Pruefungen (ausgefuehrt durch Bash-Skript)

| Regel | Was geprueft wird | Schweregrad |
|-------|------------------|-------------|
| S01 | `plugin.json` existiert sowohl im Stammverzeichnis als auch in `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existiert | error |
| S03 | Jedes `skills/<name>/` enthaelt eine `SKILL.md` | error |
| S04 | SKILL.md-Frontmatter enthaelt `name` und `description` | error |
| S05 | Jeder Skill hat ein entsprechendes `commands/<name>.md` | warning |
| S06 | Jeder Skill ist im `plugins`-Array von marketplace.json aufgefuehrt | warning |
| S07 | In SKILL.md referenzierte Dateien existieren tatsaechlich | error |
| S08 | `evals/<name>/scenarios.md` existiert | warning |

### Semantische Pruefungen (ausgefuehrt durch KI)

| Regel | Was geprueft wird | Schweregrad |
|-------|------------------|-------------|
| M01 | Die Beschreibung nennt klar Zweck und Ausloesebedingungen | warning |
| M02 | Der Name stimmt mit dem Verzeichnisnamen ueberein; die Beschreibung ist dateiuebergreifend konsistent | warning |
| M03 | Die Befehlsrouting-Logik referenziert den Skill-Namen korrekt | warning |
| M04 | Der Referenzinhalt ist logisch konsistent mit SKILL.md | warning |
| M05 | Die Evaluierungsszenarien decken die Kernfunktionspfade ab (mindestens 5) | warning |

---

## Erwartete Ausgabebeispiele

### Alle Pruefungen bestanden

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

### Probleme gefunden

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

## Arbeitsablauf

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

### Kann ich nur die strukturellen Pruefungen ausfuehren, ohne die semantischen?

Ja -- fuehren Sie das Bash-Skript direkt aus:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Dies liefert reines JSON ohne semantische KI-Analyse.

### Funktioniert es bei Nicht-jskills-Projekten?

Ja. Jedes Verzeichnis, das der Standard-Claude-Code-Plugin-Struktur folgt (`skills/`, `commands/`, `.claude-plugin/`), kann validiert werden.

### Was ist der Unterschied zwischen Fehlern und Warnungen?

- **error**: Strukturelle Probleme, die das Laden oder Veroeffentlichen des Skills verhindern
- **warning**: Qualitaetsprobleme, die die Funktionalitaet nicht beeintraechtigen, aber die Wartbarkeit und Auffindbarkeit betreffen

### Weitere jskills-Werkzeuge

Skill Lint ist Teil der jskills-Sammlung und funktioniert gut zusammen mit diesen Skills:

- [Block Break](block-break-guide.md) -- Hochenergetischer Verhaltenseinschraenkungs-Engine, der die KI zwingt, jeden Ansatz auszuschoepfen
- [Ralph Boost](ralph-boost-guide.md) -- Autonomer Entwicklungsschleifen-Engine mit integrierten Block Break-Konvergenzgarantien

Nachdem Sie einen neuen Skill entwickelt haben, fuehren Sie `/skill-lint .` aus, um die strukturelle Vollstaendigkeit zu ueberpruefen und zu bestaaetigen, dass Frontmatter, marketplace.json und Referenzlinks alle korrekt sind.

---

## Lizenz

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
