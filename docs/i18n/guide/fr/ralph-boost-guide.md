# Guide d'utilisation de Ralph Boost

> Lancez-vous en 5 minutes -- empchez votre boucle de developpement IA autonome de caler

---

## Installation

### Claude Code (recommande)

```bash
claude plugin add juserch/jskills
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Zero dependance** -- Ralph Boost ne depend ni de ralph-claude-code, ni de block-break, ni d'aucun service externe. Le chemin principal (boucle Agent) n'a aucune dependance externe ; le chemin de secours necessite `jq` ou `python` et le CLI `claude`.

---

## Commandes

| Commande | Description | Quand l'utiliser |
|----------|-------------|------------------|
| `/ralph-boost setup` | Initialiser la boucle autonome dans votre projet | Premiere configuration |
| `/ralph-boost run` | Demarrer la boucle autonome dans la session en cours | Apres l'initialisation |
| `/ralph-boost status` | Afficher l'etat actuel de la boucle | Suivi de progression |
| `/ralph-boost clean` | Supprimer les fichiers de la boucle | Nettoyage |

---

## Demarrage rapide

### 1. Initialiser le projet

```text
/ralph-boost setup
```

Claude vous guidera a travers :
- La detection du nom du projet
- La generation d'une liste de taches (fix_plan.md)
- La creation du repertoire `.ralph-boost/` et de tous les fichiers de configuration

### 2. Demarrer la boucle

```text
/ralph-boost run
```

Claude pilote la boucle autonome directement dans la session en cours (mode boucle Agent). Chaque iteration lance un sous-agent pour executer une tache, tandis que la session principale agit comme controleur de boucle gerant l'etat.

**Mode de secours** (environnements headless / sans supervision) :

```bash
# Premier plan
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Arriere-plan
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Suivre l'etat

```text
/ralph-boost status
```

Exemple de sortie :

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

## Fonctionnement

### Boucle autonome

Ralph Boost propose deux chemins d'execution :

**Chemin principal (boucle Agent)** : Claude agit comme controleur de boucle dans la session en cours, lancant un sous-agent a chaque iteration pour executer les taches. La session principale gere l'etat, le circuit breaker et l'escalade de pression. Zero dependance externe.

**Mode de secours (script bash)** : `boost-loop.sh` execute des appels `claude -p` en boucle en arriere-plan. Supporte jq et python comme moteurs JSON, detection automatique a l'execution. Le delai entre les iterations est de 1 heure par defaut (configurable).

Les deux chemins partagent la meme gestion d'etat (state.json), la meme logique d'escalade de pression et le meme protocole BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker ameliore (vs ralph-claude-code)

Circuit breaker de ralph-claude-code : abandonne apres 3 boucles consecutives sans progression.

Circuit breaker de ralph-boost : **escalade la pression progressivement** en cas de blocage, jusqu'a 6-7 boucles d'auto-recuperation avant l'arret.

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

## Exemples de sortie attendue

### L0 -- Execution normale

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

### L1 -- Changement d'approche

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude est force d'abandonner l'approche precedente et d'essayer quelque chose de **fondamentalement different**. Ajuster des parametres ne compte pas.

### L2 -- Recherche et hypotheses

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude doit : lire l'erreur mot a mot, rechercher 50+ lignes de contexte, lister 3 hypotheses differentes.

### L3 -- Checklist

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude doit completer la checklist en 7 points (lire les signaux d'echec, rechercher le probleme principal, lire le code source, verifier les hypotheses, inverser l'hypothese, reproduction minimale, changer d'outil/methode). Chaque element complete est ecrit dans state.json.

### L4 -- Transfert structure

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude construit un PoC minimal, puis genere un rapport de transfert :

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

Apres le transfert, la boucle s'arrete proprement. Ce n'est pas "je ne peux pas" -- c'est "voici ou se situe la limite."

---

## Configuration

`.ralph-boost/config.json` :

| Champ | Valeur par defaut | Description |
|-------|-------------------|-------------|
| `max_calls_per_hour` | 100 | Nombre maximum d'appels API Claude par heure |
| `claude_timeout_minutes` | 15 | Delai d'expiration par appel individuel |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Outils disponibles pour Claude |
| `claude_model` | "" | Modele specifique (vide = par defaut) |
| `session_expiry_hours` | 24 | Duree d'expiration de session |
| `no_progress_threshold` | 7 | Seuil d'absence de progression avant arret |
| `same_error_threshold` | 8 | Seuil d'erreur identique avant arret |
| `sleep_seconds` | 3600 | Temps d'attente entre les iterations (secondes) |

### Ajustements de configuration courants

**Accelerer la boucle** (pour les tests) :

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Restreindre les permissions d'outils** :

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Utiliser un modele specifique** :

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Structure du repertoire projet

```
.ralph-boost/
├── PROMPT.md           # Instructions de developpement (inclut le protocole block-break)
├── fix_plan.md         # Liste de taches (mise a jour automatique par Claude)
├── config.json         # Configuration
├── state.json          # Etat unifie (circuit breaker + pression + session)
├── handoff-report.md   # Rapport de transfert L4 (genere a la sortie)
├── logs/
│   ├── boost.log       # Journal de la boucle
│   └── claude_output_*.log  # Sortie par iteration
└── .gitignore          # Ignore l'etat et les journaux
```

Tous les fichiers restent dans `.ralph-boost/` -- la racine de votre projet n'est jamais modifiee.

---

## Relation avec ralph-claude-code

Ralph Boost est un **remplacement independant** de [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), et non un plugin d'amelioration.

| Aspect | ralph-claude-code | ralph-boost |
|--------|-------------------|-------------|
| Forme | Outil Bash autonome | Skill Claude Code (boucle Agent) |
| Installation | `npm install` | Plugin Claude Code |
| Taille du code | 2000+ lignes | ~400 lignes |
| Dependances externes | jq (obligatoire) | Chemin principal : zero ; secours : jq ou python |
| Repertoire | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Passif (abandonne apres 3 boucles) | Actif (L0-L4, 6-7 boucles d'auto-recuperation) |
| Coexistence | Oui | Oui (zero conflit de fichiers) |

Les deux peuvent etre installes simultanement dans le meme projet -- ils utilisent des repertoires separes et n'interferent pas entre eux.

---

## Relation avec Block Break

Ralph Boost adapte les mecanismes principaux de Block Break (escalade de pression, methodologie en 5 etapes, checklist) aux scenarios de boucle autonome :

| Aspect | block-break | ralph-boost |
|--------|-------------|-------------|
| Scenario | Sessions interactives | Boucles autonomes |
| Activation | Declenchement automatique par hooks | Integre dans la boucle Agent / le script de boucle |
| Detection | Hook PostToolUse | Detection de progression de la boucle Agent / du script |
| Controle | Prompts injectes par hook | Injection de prompt Agent / --append-system-prompt |
| Etat | `~/.juserch-skills/` | `.ralph-boost/state.json` |

Le code est totalement independant ; les concepts sont partages.

> **Reference** : L'escalade de pression de Block Break (L0-L4), la methodologie en 5 etapes et la checklist en 7 points constituent le fondement conceptuel du circuit breaker de ralph-boost. Consultez le [Guide d'utilisation de Block Break](block-break-guide.md) pour plus de details.

---

## FAQ

### Comment choisir entre le chemin principal et le mode de secours ?

`/ralph-boost run` utilise la boucle Agent (chemin principal) par defaut, s'executant directement dans la session Claude Code en cours. Utilisez le script bash de secours lorsque vous avez besoin d'une execution headless ou sans supervision.

### Ou se trouve le script de boucle ?

Apres l'installation du plugin jskills, le script de secours se trouve dans `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh`. Vous pouvez egalement le copier n'importe ou et l'executer depuis la. Le script detecte automatiquement jq ou python comme moteur JSON.

### Comment consulter les journaux de la boucle ?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Comment reinitialiser manuellement le niveau de pression ?

Modifiez `.ralph-boost/state.json` : definissez `pressure.level` a 0 et `circuit_breaker.consecutive_no_progress` a 0. Ou supprimez simplement state.json et reinitialisez.

### Comment modifier la liste de taches ?

Modifiez `.ralph-boost/fix_plan.md` directement, en utilisant le format `- [ ] task`. Claude le lit au debut de chaque iteration.

### Comment reprendre apres l'ouverture du circuit breaker ?

Modifiez `state.json`, definissez `circuit_breaker.state` a `"CLOSED"`, reintialisez les compteurs concernes, puis relancez le script.

### Ai-je besoin de ralph-claude-code ?

Non. Ralph Boost est totalement independant et ne depend d'aucun fichier Ralph.

### Quelles plateformes sont supportees ?

Actuellement, Claude Code est supporte (chemin principal via boucle Agent). Le script bash de secours necessite bash 4+, jq ou python, et le CLI claude.

### Comment valider les fichiers skill de ralph-boost ?

Utilisez [Skill Lint](skill-lint-guide.md) : `/skill-lint .`

---

## Licence

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
