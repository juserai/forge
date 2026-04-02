# Guide d'utilisation de News Fetch

> Lancez-vous en 3 minutes -- laissez l'IA preparer votre briefing d'actualites

Epuise par le debogage ? Prenez 2 minutes, rattrapez l'actualite du monde, et revenez en forme.

---

## Installation

### Claude Code (recommande)

```bash
claude plugin add juserch/jskills
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/news-fetch/SKILL.md
```

> **Zero dependance** -- News Fetch ne necessite aucun service externe ni cle API. Installez et c'est parti.

---

## Commandes

| Commande | Description | Quand l'utiliser |
|----------|-------------|------------------|
| `/news-fetch AI` | Recuperer les actualites IA de la semaine | Mise a jour rapide du secteur |
| `/news-fetch AI today` | Recuperer les actualites IA du jour | Briefing quotidien |
| `/news-fetch robotics month` | Recuperer les actualites robotique du mois | Revue mensuelle |
| `/news-fetch climate 2026-03-01~2026-03-31` | Recuperer les actualites sur une plage de dates | Recherche ciblee |

---

## Cas d'utilisation

### Briefing technologique quotidien

```
/news-fetch AI today
```

Obtenez les dernieres actualites IA du jour, classees par pertinence. Parcourez les titres et les resumes en quelques secondes.

### Recherche sectorielle

```
/news-fetch electric vehicles 2026-03-01~2026-03-31
```

Recuperez les actualites sur une periode specifique pour alimenter votre analyse de marche et votre veille concurrentielle.

### Actualites multilingues

Les sujets en chinois incluent automatiquement des recherches complementaires en anglais pour une couverture plus large, et inversement. Vous obtenez le meilleur des deux mondes sans effort supplementaire.

---

## Exemple de sortie attendue

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

## Strategie de repli reseau a 3 niveaux

News Fetch dispose d'une strategie de repli integree pour garantir la recuperation d'actualites quelles que soient les conditions reseau :

| Niveau | Outil | Source de donnees | Declencheur |
|--------|-------|-------------------|-------------|
| **L1** | WebSearch | Google/Bing | Par defaut (privilegie) |
| **L2** | WebFetch | Baidu News, Sina, NetEase | L1 echoue |
| **L3** | Bash curl | Memes sources que L2 | L2 echoue egalement |

Lorsque tous les niveaux echouent, un rapport d'echec structure est produit, listant la raison de l'echec pour chaque source.

---

## Fonctionnalites de sortie

| Fonctionnalite | Description |
|----------------|-------------|
| **Deduplication** | Lorsque plusieurs sources couvrent le meme evenement, l'entree avec le score le plus eleve est conservee ; les autres sont regroupees sous "Related coverage" |
| **Completion des resumes** | Si les resultats de recherche ne contiennent pas de resume, le corps de l'article est recupere et un resume est genere |
| **Score de pertinence** | L'IA attribue a chaque resultat un score de pertinence par rapport au sujet -- plus le score est eleve, plus c'est pertinent |
| **Liens cliquables** | Format de lien Markdown -- cliquable dans les IDE et les terminaux |

---

## FAQ

### Ai-je besoin d'une cle API ?

Non. News Fetch s'appuie entierement sur WebSearch et le scraping web public. Aucune configuration necessaire.

### Peut-il recuperer des actualites en anglais ?

Absolument. Les sujets en chinois incluent automatiquement des recherches complementaires en anglais, et les sujets en anglais fonctionnent nativement. La couverture couvre les deux langues.

### Que se passe-t-il si mon reseau est restreint ?

La strategie de repli a 3 niveaux gere cela automatiquement. Meme si WebSearch n'est pas disponible, News Fetch se rabat sur les sources d'actualites domestiques.

### Combien d'articles sont retournes ?

Jusqu'a 20 (apres deduplication). Le nombre reel depend de ce que retournent les sources de donnees.

---

## Licence

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
