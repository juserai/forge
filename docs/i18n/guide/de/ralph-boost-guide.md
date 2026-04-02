# Ralph Boost Benutzerhandbuch

> In 5 Minuten loslegen -- verhindern Sie, dass Ihre autonome KI-Entwicklungsschleife ins Stocken geraet

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserch/jskills
```

### Universelle Einzeilige Installation

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Keine Abhaengigkeiten** -- Ralph Boost haengt weder von ralph-claude-code, noch von block-break, noch von einem externen Dienst ab. Der primaere Pfad (Agent-Schleife) hat keine externen Abhaengigkeiten; der Fallback-Pfad erfordert `jq` oder `python` und das `claude` CLI.

---

## Befehle

| Befehl | Beschreibung | Wann verwenden |
|--------|-------------|----------------|
| `/ralph-boost setup` | Autonome Schleife in Ihrem Projekt initialisieren | Ersteinrichtung |
| `/ralph-boost run` | Autonome Schleife in der aktuellen Sitzung starten | Nach der Initialisierung |
| `/ralph-boost status` | Aktuellen Schleifenstatus anzeigen | Fortschritt ueberwachen |
| `/ralph-boost clean` | Schleifendateien entfernen | Aufraumen |

---

## Schnellstart

### 1. Projekt initialisieren

```text
/ralph-boost setup
```

Claude fuehrt Sie durch:
- Erkennung des Projektnamens
- Generierung einer Aufgabenliste (fix_plan.md)
- Erstellung des `.ralph-boost/`-Verzeichnisses und aller Konfigurationsdateien

### 2. Schleife starten

```text
/ralph-boost run
```

Claude steuert die autonome Schleife direkt innerhalb der aktuellen Sitzung (Agent-Schleifenmodus). Jede Iteration startet einen Sub-Agent zur Aufgabenausfuehrung, waehrend die Hauptsitzung als Schleifencontroller den Zustand verwaltet.

**Fallback** (Headless- / unbeaufsichtigte Umgebungen):

```bash
# Vordergrund
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Hintergrund
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Status ueberwachen

```text
/ralph-boost status
```

Beispielausgabe:

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

## Funktionsweise

### Autonome Schleife

Ralph Boost bietet zwei Ausfuehrungspfade:

**Primaerer Pfad (Agent-Schleife)**: Claude agiert als Schleifencontroller innerhalb der aktuellen Sitzung und startet bei jeder Iteration einen Sub-Agent zur Aufgabenausfuehrung. Die Hauptsitzung verwaltet den Zustand, den Circuit Breaker und die Druckeskalation. Keine externen Abhaengigkeiten.

**Fallback (Bash-Skript)**: `boost-loop.sh` fuehrt `claude -p`-Aufrufe in einer Schleife im Hintergrund aus. Unterstuetzt sowohl jq als auch python als JSON-Engine, automatische Erkennung zur Laufzeit. Standard-Wartezeit zwischen Iterationen ist 1 Stunde (konfigurierbar).

Beide Pfade teilen dieselbe Zustandsverwaltung (state.json), Druckeskalationslogik und das BOOST_STATUS-Protokoll.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Verbesserter Circuit Breaker (vs ralph-claude-code)

Circuit Breaker von ralph-claude-code: Gibt nach 3 aufeinanderfolgenden Schleifen ohne Fortschritt auf.

Circuit Breaker von ralph-boost: **Eskaliert den Druck progressiv** bei Blockaden, mit bis zu 6-7 Schleifen Selbsterholung vor dem Stopp.

```
Progress detected → L0 (reset, continue normal work)

No progress:
  1 loop  → L1 Disappointment (force approach switch)
  2 loops → L2 Interrogation (read error word-by-word + search source + list 3 hypotheses)
  3 loops → L3 Performance Review (complete 7-point checklist)
  4 loops → L4 Graduation (minimal PoC + write handoff report)
  5+ loops → Graceful shutdown (with structured handoff report)
```

---

## Erwartete Ausgabebeispiele

### L0 -- Normale Ausfuehrung

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

### L1 -- Ansatzwechsel

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude wird gezwungen, den vorherigen Ansatz aufzugeben und etwas **grundlegend Anderes** zu versuchen. Parameteranpassungen zaehlen nicht.

### L2 -- Suche und Hypothesenbildung

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude muss: den Fehler Wort fuer Wort lesen, 50+ Zeilen Kontext durchsuchen, 3 verschiedene Hypothesen auflisten.

### L3 -- Checkliste

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude muss die 7-Punkte-Checkliste abschliessen (Fehlersignale lesen, Kernproblem suchen, Quellcode lesen, Annahmen verifizieren, Hypothese umkehren, minimale Reproduktion, Werkzeuge/Methoden wechseln). Jedes abgeschlossene Element wird in state.json geschrieben.

### L4 -- Strukturierte Uebergabe

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude erstellt einen minimalen PoC und generiert dann einen Uebergabebericht:

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

Nach Abschluss der Uebergabe faehrt die Schleife ordnungsgemaess herunter. Dies ist kein "Ich kann nicht" -- es ist "hier liegt die Grenze."

---

## Konfiguration

`.ralph-boost/config.json`:

| Feld | Standardwert | Beschreibung |
|------|-------------|-------------|
| `max_calls_per_hour` | 100 | Maximale Claude-API-Aufrufe pro Stunde |
| `claude_timeout_minutes` | 15 | Timeout pro einzelnem Aufruf |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Fuer Claude verfuegbare Werkzeuge |
| `claude_model` | "" | Modell-Override (leer = Standard) |
| `session_expiry_hours` | 24 | Sitzungsablaufzeit |
| `no_progress_threshold` | 7 | Schwellenwert fuer fehlenden Fortschritt vor Abschaltung |
| `same_error_threshold` | 8 | Schwellenwert fuer gleichen Fehler vor Abschaltung |
| `sleep_seconds` | 3600 | Wartezeit zwischen Iterationen (Sekunden) |

### Haeufige Konfigurationsanpassungen

**Schleife beschleunigen** (fuer Tests):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Werkzeugberechtigungen einschraenken**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Ein bestimmtes Modell verwenden**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Projektverzeichnisstruktur

```
.ralph-boost/
├── PROMPT.md           # Entwicklungsanweisungen (enthaelt block-break Protokoll)
├── fix_plan.md         # Aufgabenliste (automatisch von Claude aktualisiert)
├── config.json         # Konfiguration
├── state.json          # Einheitlicher Zustand (Circuit Breaker + Druck + Sitzung)
├── handoff-report.md   # L4 Uebergabebericht (bei ordnungsgemaessem Beenden generiert)
├── logs/
│   ├── boost.log       # Schleifenprotokoll
│   └── claude_output_*.log  # Ausgabe pro Iteration
└── .gitignore          # Ignoriert Zustand und Protokolle
```

Alle Dateien bleiben innerhalb von `.ralph-boost/` -- Ihr Projektstammverzeichnis wird nie veraendert.

---

## Beziehung zu ralph-claude-code

Ralph Boost ist ein **unabhaengiger Ersatz** fuer [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), kein Erweiterungs-Plugin.

| Aspekt | ralph-claude-code | ralph-boost |
|--------|-------------------|-------------|
| Form | Eigenstaendiges Bash-Werkzeug | Claude Code Skill (Agent-Schleife) |
| Installation | `npm install` | Claude Code Plugin |
| Codegroesse | 2000+ Zeilen | ~400 Zeilen |
| Externe Abhaengigkeiten | jq (erforderlich) | Primaerer Pfad: keine; Fallback: jq oder python |
| Verzeichnis | `.ralph/` | `.ralph-boost/` |
| Circuit Breaker | Passiv (gibt nach 3 Schleifen auf) | Aktiv (L0-L4, 6-7 Schleifen Selbsterholung) |
| Koexistenz | Ja | Ja (keine Dateikonflikte) |

Beide koennen gleichzeitig im selben Projekt installiert werden -- sie verwenden separate Verzeichnisse und interferieren nicht miteinander.

---

## Beziehung zu Block Break

Ralph Boost adaptiert die Kernmechanismen von Block Break (Druckeskalation, 5-Schritte-Methodik, Checkliste) fuer autonome Schleifen-Szenarien:

| Aspekt | block-break | ralph-boost |
|--------|-------------|-------------|
| Szenario | Interaktive Sitzungen | Autonome Schleifen |
| Aktivierung | Automatische Ausloesung durch Hooks | In die Agent-Schleife / das Schleifenskript integriert |
| Erkennung | PostToolUse Hook | Fortschrittserkennung der Agent-Schleife / des Skripts |
| Steuerung | Hook-injizierte Prompts | Agent-Prompt-Injektion / --append-system-prompt |
| Zustand | `~/.juserch-skills/` | `.ralph-boost/state.json` |

Der Code ist vollstaendig unabhaengig; die Konzepte werden geteilt.

> **Referenz**: Die Druckeskalation von Block Break (L0-L4), die 5-Schritte-Methodik und die 7-Punkte-Checkliste bilden das konzeptionelle Fundament des Circuit Breakers von ralph-boost. Weitere Details finden Sie im [Block Break Benutzerhandbuch](block-break-guide.md).

---

## FAQ

### Wie waehle ich zwischen dem primaeren Pfad und dem Fallback?

`/ralph-boost run` verwendet standardmaessig die Agent-Schleife (primaerer Pfad), die direkt in der aktuellen Claude Code-Sitzung laeuft. Verwenden Sie das Fallback-Bash-Skript, wenn Sie eine headless oder unbeaufsichtigte Ausfuehrung benoetigen.

### Wo befindet sich das Schleifenskript?

Nach der Installation des jskills-Plugins befindet sich das Fallback-Skript unter `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh`. Sie koennen es auch an einen beliebigen Ort kopieren und von dort ausfuehren. Das Skript erkennt automatisch jq oder python als JSON-Engine.

### Wie kann ich die Schleifenprotokolle einsehen?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Wie setze ich die Druckstufe manuell zurueck?

Bearbeiten Sie `.ralph-boost/state.json`: Setzen Sie `pressure.level` auf 0 und `circuit_breaker.consecutive_no_progress` auf 0. Oder loeschen Sie einfach state.json und initialisieren Sie neu.

### Wie aendere ich die Aufgabenliste?

Bearbeiten Sie `.ralph-boost/fix_plan.md` direkt im Format `- [ ] task`. Claude liest sie zu Beginn jeder Iteration.

### Wie kann ich nach dem Oeffnen des Circuit Breakers fortfahren?

Bearbeiten Sie `state.json`, setzen Sie `circuit_breaker.state` auf `"CLOSED"`, setzen Sie die relevanten Zaehler zurueck und fuehren Sie das Skript erneut aus.

### Brauche ich ralph-claude-code?

Nein. Ralph Boost ist vollstaendig unabhaengig und haengt von keinen Ralph-Dateien ab.

### Welche Plattformen werden unterstuetzt?

Derzeit wird Claude Code unterstuetzt (primaerer Pfad ueber Agent-Schleife). Das Fallback-Bash-Skript erfordert bash 4+, jq oder python und das claude CLI.

### Wie validiere ich die Skill-Dateien von ralph-boost?

Verwenden Sie [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Lizenz

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
