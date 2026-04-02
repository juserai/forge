# Guide d'utilisation de Skill Lint

> Lancez-vous en 3 minutes -- validez la qualite de vos skills Claude Code

---

## Installation

### Claude Code (recommande)

```bash
claude plugin add juserch/jskills
```

### Installation universelle en une ligne

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Zero dependance** -- Skill Lint ne necessite aucun service externe ni API. Installez et c'est parti.

---

## Commandes

| Commande | Description | Quand l'utiliser |
|----------|-------------|------------------|
| `/skill-lint` | Afficher les informations d'utilisation | Voir les verifications disponibles |
| `/skill-lint .` | Valider le projet en cours | Auto-verification pendant le developpement |
| `/skill-lint /path/to/plugin` | Valider un chemin specifique | Revue d'un autre plugin |

---

## Cas d'utilisation

### Auto-verification apres la creation d'un nouveau skill

Apres avoir cree `skills/<name>/SKILL.md`, `commands/<name>.md` et les fichiers associes, executez `/skill-lint .` pour confirmer que la structure est complete, que le frontmatter est correct et que l'entree marketplace a ete ajoutee.

### Revue du plugin de quelqu'un d'autre

Lors de la revue d'une PR ou de l'audit d'un autre plugin, utilisez `/skill-lint /path/to/plugin` pour une verification rapide de la completude des fichiers et de la coherence.

### Integration CI

`scripts/skill-lint.sh` peut s'executer directement dans un pipeline CI, avec une sortie JSON pour l'analyse automatisee :

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Elements verifies

### Verifications structurelles (executees par le script Bash)

| Regle | Ce qui est verifie | Severite |
|-------|-------------------|----------|
| S01 | `plugin.json` existe a la racine et dans `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existe | error |
| S03 | Chaque `skills/<name>/` contient un `SKILL.md` | error |
| S04 | Le frontmatter de SKILL.md inclut `name` et `description` | error |
| S05 | Chaque skill a un `commands/<name>.md` correspondant | warning |
| S06 | Chaque skill est liste dans le tableau `plugins` de marketplace.json | warning |
| S07 | Les fichiers references cites dans SKILL.md existent reellement | error |
| S08 | `evals/<name>/scenarios.md` existe | warning |

### Verifications semantiques (executees par l'IA)

| Regle | Ce qui est verifie | Severite |
|-------|-------------------|----------|
| M01 | La description indique clairement l'objectif et les conditions de declenchement | warning |
| M02 | Le nom correspond au nom du repertoire ; la description est coherente entre les fichiers | warning |
| M03 | La logique de routage des commandes reference correctement le nom du skill | warning |
| M04 | Le contenu des references est logiquement coherent avec SKILL.md | warning |
| M05 | Les scenarios d'evaluation couvrent les chemins fonctionnels principaux (au moins 5) | warning |

---

## Exemples de sortie attendue

### Toutes les verifications reussies

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

### Problemes detectes

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

## Flux de travail

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

### Puis-je executer uniquement les verifications structurelles, sans les verifications semantiques ?

Oui -- executez le script bash directement :

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Cela produit du JSON pur sans analyse semantique par l'IA.

### Fonctionne-t-il sur des projets non-jskills ?

Oui. Tout repertoire qui suit la structure standard de plugin Claude Code (`skills/`, `commands/`, `.claude-plugin/`) peut etre valide.

### Quelle est la difference entre les erreurs et les avertissements ?

- **error** : Problemes structurels qui empecheront le skill de se charger ou de se publier correctement
- **warning** : Problemes de qualite qui ne casseront pas la fonctionnalite mais affecteront la maintenabilite et la decouverte

### Autres outils jskills

Skill Lint fait partie de la collection jskills et fonctionne bien avec ces autres skills :

- [Block Break](block-break-guide.md) -- Moteur de contraintes comportementales a haute energie qui force l'IA a epuiser toutes les approches
- [Ralph Boost](ralph-boost-guide.md) -- Moteur de boucle de developpement autonome avec garanties de convergence Block Break integrees

Apres avoir developpe un nouveau skill, executez `/skill-lint .` pour verifier la completude structurelle et confirmer que le frontmatter, marketplace.json et les liens de reference sont tous corrects.

---

## Licence

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
