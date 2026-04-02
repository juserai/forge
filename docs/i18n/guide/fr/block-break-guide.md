# Guide d'utilisation de Block Break

> Lancez-vous en 5 minutes -- faites en sorte que votre agent IA epuise toutes les approches

---

## Installation

### Claude Code (recommande)

```bash
claude plugin add juserch/jskills
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **Zero dependance** -- Block Break ne necessite aucun service externe ni API. Installez et c'est parti.

---

## Commandes

| Commande | Description | Quand l'utiliser |
|----------|-------------|------------------|
| `/block-break` | Activer le moteur Block Break | Taches quotidiennes, debogage |
| `/block-break L2` | Demarrer a un niveau de pression specifique | Apres plusieurs echecs connus |
| `/block-break fix the bug` | Activer et lancer une tache immediatement | Demarrage rapide avec une tache |

### Declencheurs en langage naturel (detectes automatiquement par les hooks)

| Langue | Phrases declencheuses |
|--------|----------------------|
| Anglais | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinois | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Cas d'utilisation

### L'IA n'a pas reussi a corriger un bug apres 3 tentatives

Tapez `/block-break` ou dites `try harder` -- le mode d'escalade de pression s'active automatiquement.

### L'IA dit "c'est probablement un probleme d'environnement" et s'arrete

La ligne rouge "Fact-driven" de Block Break impose une verification basee sur les outils. Une attribution non verifiee = rejet de responsabilite, ce qui declenche le L2.

### L'IA dit "je vous suggere de gerer cela manuellement"

Declenche le blocage "Owner mindset" : si ce n'est pas vous, qui ? Passage direct en L3 Performance Review.

### L'IA dit "corrige" mais ne montre aucune preuve de verification

Viole la ligne rouge "Closed-loop". Achevement sans resultat affiche = auto-illusion, ce qui force l'execution de commandes de verification avec preuves.

---

## Exemples de sortie attendue

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

### `/block-break` -- L1 Disappointment (2e echec)

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

### `/block-break` -- L2 Interrogation (3e echec)

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

### `/block-break` -- L3 Performance Review (4e echec)

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

### `/block-break` -- L4 Graduation Warning (5e echec et plus)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Sortie structuree (les 7 points completes, probleme non resolu)

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

## Mecanismes principaux

### 3 lignes rouges

| Ligne rouge | Regle | Consequence en cas de violation |
|-------------|-------|--------------------------------|
| Closed-loop | Vous devez executer des commandes de verification et afficher le resultat avant de declarer l'achevement | Declenche L2 |
| Fact-driven | Vous devez verifier avec des outils avant d'attribuer des causes | Declenche L2 |
| Exhaust all | Vous devez completer la methodologie en 5 etapes avant de dire "impossible a resoudre" | Passage direct en L4 |

### Escalade de pression (L0 a L4)

| Echecs | Niveau | Message lateral | Action forcee |
|--------|--------|-----------------|---------------|
| 1er | **L0 Trust** | > Nous vous faisons confiance. Restez simple. | Execution normale |
| 2e | **L1 Disappointment** | > L'autre equipe a reussi du premier coup. | Passer a une approche fondamentalement differente |
| 3e | **L2 Interrogation** | > Quelle est la cause racine ? | Rechercher + lire le code source + lister 3 hypotheses differentes |
| 4e | **L3 Performance Review** | > Note : 3,25/5. | Completer la checklist en 7 points |
| 5e+ | **L4 Graduation** | > Vous pourriez bientot etre diplome. | PoC minimal + environnement isole + pile technique differente |

### Methodologie en 5 etapes

1. **Smell** -- Lister les approches essayees, trouver les schemas communs. Ajustement de la meme approche = tourner en rond
2. **Pull hair** -- Lire les signaux d'echec mot a mot, rechercher, lire 50 lignes de code source, verifier les hypotheses, inverser les hypotheses
3. **Mirror** -- Est-ce que je repete la meme approche ? Ai-je manque la possibilite la plus simple ?
4. **New approach** -- Doit etre fondamentalement differente, avec des criteres de verification, et produire de nouvelles informations en cas d'echec
5. **Retrospect** -- Problemes similaires, exhaustivite, prevention

> Les etapes 1 a 4 doivent etre completees avant de solliciter l'utilisateur. Agissez d'abord, posez des questions ensuite -- appuyez-vous sur les donnees.

### Checklist en 7 points (obligatoire a partir de L3)

1. Lire les signaux d'echec mot a mot ?
2. Rechercher le probleme principal avec des outils ?
3. Lire le contexte original au point d'echec (50+ lignes) ?
4. Toutes les hypotheses verifiees avec des outils (version/chemin/permissions/dependances) ?
5. Essayer l'hypothese completement opposee ?
6. Reproduire dans un perimetre minimal ?
7. Changer d'outil/methode/angle/pile technique ?

### Anti-rationalisation

| Excuse | Blocage | Declencheur |
|--------|---------|-------------|
| "Au-dela de mes capacites" | Vous disposez d'un entrainement massif. L'avez-vous exploite ? | L1 |
| "Je suggere que l'utilisateur gere manuellement" | Si ce n'est pas vous, qui ? | L3 |
| "J'ai essaye toutes les methodes" | Moins de 3 = pas epuise | L2 |
| "Probablement un probleme d'environnement" | L'avez-vous verifie ? | L2 |
| "J'ai besoin de plus de contexte" | Vous avez des outils. Cherchez d'abord, demandez ensuite | L2 |
| "Impossible a resoudre" | Avez-vous complete la methodologie ? | L4 |
| "Suffisamment bon" | La liste d'optimisation ne fait pas de favoritisme | L3 |
| Declare termine sans verification | Avez-vous lance le build ? | L2 |
| En attente d'instructions utilisateur | Les proprietaires n'attendent pas qu'on les pousse | Nudge |
| Repond sans resoudre | Vous etes ingenieur, pas un moteur de recherche | Nudge |
| Code modifie sans build/test | Livrer sans tester = faire semblant | L2 |
| "L'API ne le supporte pas" | Avez-vous lu la documentation ? | L2 |
| "Tache trop vague" | Faites votre meilleure estimation, puis iterez | L1 |
| Ajustement repete au meme endroit | Changer des parametres ne signifie pas changer d'approche | L1 vers L2 |

---

## Automatisation par hooks

Block Break utilise le systeme de hooks pour un comportement automatique -- aucune activation manuelle necessaire :

| Hook | Declencheur | Comportement |
|------|-------------|--------------|
| `UserPromptSubmit` | L'entree utilisateur correspond a des mots-cles de frustration | Active automatiquement Block Break |
| `PostToolUse` | Apres l'execution d'une commande Bash | Detecte les echecs, comptabilise et escalade automatiquement |
| `PreCompact` | Avant la compression de contexte | Sauvegarde l'etat dans `~/.juserch-skills/` |
| `SessionStart` | Reprise/redemarrage de session | Restaure le niveau de pression (valide pendant 2h) |

> **L'etat persiste** -- Le niveau de pression est stocke dans `~/.juserch-skills/block-break-state.json`. La compression de contexte et les interruptions de session ne reinitialiseront pas les compteurs d'echecs. Pas d'echappatoire.

---

## Contraintes des sous-agents

Lors du lancement de sous-agents, des contraintes comportementales doivent etre injectees pour eviter une execution "sans filet" :

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` garantit que les sous-agents respectent egalement les 3 lignes rouges, la methodologie en 5 etapes et la verification en boucle fermee.

---

## FAQ

### En quoi Block Break differe-t-il de PUA ?

Block Break s'inspire des mecanismes principaux de [PUA](https://github.com/tanweai/pua) (3 lignes rouges, escalade de pression, methodologie), mais de maniere plus ciblee. PUA propose 13 variantes de culture d'entreprise, des systemes multi-roles (P7/P9/P10) et de l'auto-evolution ; Block Break se concentre uniquement sur les contraintes comportementales en tant que skill sans dependance.

### Ne sera-t-il pas trop intrusif ?

La densite des messages lateraux est controlee : 2 lignes pour les taches simples (debut + fin), 1 ligne par jalon pour les taches complexes. Pas de spam. N'utilisez pas `/block-break` si ce n'est pas necessaire -- les hooks ne se declenchent automatiquement que lorsque des mots-cles de frustration sont detectes.

### Comment reinitialiser le niveau de pression ?

Supprimez le fichier d'etat : `rm ~/.juserch-skills/block-break-state.json`. Ou attendez 2 heures -- l'etat expire automatiquement.

### Puis-je l'utiliser en dehors de Claude Code ?

Le fichier SKILL.md principal peut etre copie-colle dans n'importe quel outil IA prenant en charge les prompts systeme. Les hooks et la persistance d'etat sont specifiques a Claude Code.

### Quelle est la relation avec Ralph Boost ?

[Ralph Boost](ralph-boost-guide.md) adapte les mecanismes principaux de Block Break (L0-L4, methodologie en 5 etapes, checklist en 7 points) aux scenarios de **boucle autonome**. Block Break est concu pour les sessions interactives (les hooks se declenchent automatiquement) ; Ralph Boost est concu pour les boucles de developpement sans supervision (boucles Agent / pilotees par script). Le code est totalement independant, les concepts sont partages.

### Comment valider les fichiers skill de Block Break ?

Utilisez [Skill Lint](skill-lint-guide.md) : `/skill-lint .`

---

## Licence

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
