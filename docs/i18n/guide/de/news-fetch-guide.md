# News Fetch Benutzerhandbuch

> In 3 Minuten loslegen -- lassen Sie die KI Ihr Nachrichtenbriefing erstellen

Vom Debuggen ausgebrannt? Nehmen Sie sich 2 Minuten, informieren Sie sich ueber das Weltgeschehen und kommen Sie erfrischt zurueck.

---

## Installation

### Claude Code (empfohlen)

```bash
claude plugin add juserch/jskills
```

### Universelle Einzeilige Installation

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Keine Abhaengigkeiten** -- News Fetch benoetigt keine externen Dienste oder API-Schluessel. Installieren und loslegen.

---

## Befehle

| Befehl | Beschreibung | Wann verwenden |
|--------|-------------|----------------|
| `/news-fetch AI` | KI-Nachrichten dieser Woche abrufen | Schnelles Branchen-Update |
| `/news-fetch AI today` | Heutige KI-Nachrichten abrufen | Taegliches Briefing |
| `/news-fetch robotics month` | Robotik-Nachrichten dieses Monats abrufen | Monatliche Uebersicht |
| `/news-fetch climate 2026-03-01~2026-03-31` | Nachrichten fuer einen bestimmten Zeitraum abrufen | Gezielte Recherche |

---

## Anwendungsfaelle

### Taegliches Tech-Briefing

```
/news-fetch AI today
```

Erhalten Sie die neuesten KI-Nachrichten des Tages, nach Relevanz sortiert. Scannen Sie Ueberschriften und Zusammenfassungen in Sekunden.

### Branchenrecherche

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Rufen Sie Nachrichten fuer einen bestimmten Zeitraum ab, um Ihre Marktanalyse und Wettbewerbsrecherche zu unterstuetzen.

### Mehrsprachige Nachrichten

Chinesische Themen erhalten automatisch ergaenzende englische Suchanfragen fuer eine breitere Abdeckung und umgekehrt. Sie erhalten das Beste aus beiden Welten ohne zusaetzlichen Aufwand.

---

## Beispiel der erwarteten Ausgabe

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

## 3-Stufen-Netzwerk-Fallback

News Fetch verfuegt ueber eine integrierte Fallback-Strategie, um den Nachrichtenabruf unter verschiedenen Netzwerkbedingungen sicherzustellen:

| Stufe | Werkzeug | Datenquelle | Ausloeser |
|-------|----------|-------------|-----------|
| **L1** | WebSearch | Google/Bing | Standard (bevorzugt) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 schlaegt fehl |
| **L3** | Bash curl | Gleiche Quellen wie L2 | L2 schlaegt ebenfalls fehl |

Wenn alle Stufen fehlschlagen, wird ein strukturierter Fehlerbericht erstellt, der den Fehlergrund fuer jede Quelle auflistet.

---

## Ausgabefunktionen

| Funktion | Beschreibung |
|----------|-------------|
| **Deduplizierung** | Wenn mehrere Quellen dasselbe Ereignis abdecken, wird der Eintrag mit der hoechsten Bewertung beibehalten; andere werden unter "Related coverage" zusammengefasst |
| **Zusammenfassungsvervollstaendigung** | Wenn Suchergebnisse keine Zusammenfassung enthalten, wird der Artikeltext abgerufen und eine Zusammenfassung generiert |
| **Relevanzbewertung** | Die KI bewertet jedes Ergebnis nach Themenrelevanz -- hoeher bedeutet relevanter |
| **Klickbare Links** | Markdown-Linkformat -- klickbar in IDEs und Terminals |

---

## FAQ

### Brauche ich einen API-Schluessel?

Nein. News Fetch stuetzt sich vollstaendig auf WebSearch und oeffentliches Web-Scraping. Keine Konfiguration erforderlich.

### Kann es englischsprachige Nachrichten abrufen?

Selbstverstaendlich. Chinesische Themen beinhalten automatisch ergaenzende englische Suchanfragen, und englische Themen funktionieren nativ. Die Abdeckung umfasst beide Sprachen.

### Was passiert, wenn mein Netzwerk eingeschraenkt ist?

Die 3-Stufen-Fallback-Strategie handhabt dies automatisch. Selbst wenn WebSearch nicht verfuegbar ist, greift News Fetch auf inlaendische Nachrichtenquellen zurueck.

### Wie viele Artikel werden zurueckgegeben?

Bis zu 20 (nach Deduplizierung). Die tatsaechliche Anzahl haengt davon ab, was die Datenquellen zurueckliefern.

---

## Lizenz

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
