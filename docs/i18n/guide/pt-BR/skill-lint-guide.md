# Guia do Usuario do Skill Lint

> Comece em 3 minutos — valide a qualidade do seu skill de Claude Code

---

## Instalacao

### Claude Code (recomendado)

```bash
claude plugin add juserch/jskills
```

### Instalacao universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Zero dependencias** — Skill Lint nao requer servicos externos nem APIs. Instale e use.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/skill-lint` | Mostrar informacoes de uso | Ver verificacoes disponiveis |
| `/skill-lint .` | Verificar o projeto atual | Auto-verificacao durante o desenvolvimento |
| `/skill-lint /path/to/plugin` | Verificar um caminho especifico | Revisar outro plugin |

---

## Casos de uso

### Auto-verificacao apos criar um novo skill

Apos criar `skills/<name>/SKILL.md`, `commands/<name>.md` e arquivos relacionados, execute `/skill-lint .` para confirmar que a estrutura esta completa, o frontmatter esta correto e a entrada no marketplace foi adicionada.

### Revisar o plugin de outra pessoa

Ao revisar um PR ou auditar outro plugin, use `/skill-lint /path/to/plugin` para uma verificacao rapida de completude de arquivos e consistencia.

### Integracao com CI

`scripts/skill-lint.sh` pode ser executado diretamente em um pipeline de CI, produzindo JSON para analise automatizada:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Itens de verificacao

### Verificacoes estruturais (executadas por script Bash)

| Regra | O que verifica | Severidade |
|-------|---------------|-----------|
| S01 | `plugin.json` existe tanto na raiz quanto em `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` existe | error |
| S03 | Cada `skills/<name>/` contem um `SKILL.md` | error |
| S04 | O frontmatter do SKILL.md inclui `name` e `description` | error |
| S05 | Cada skill tem um `commands/<name>.md` correspondente | warning |
| S06 | Cada skill esta listado no array `plugins` do marketplace.json | warning |
| S07 | Os arquivos de references citados no SKILL.md realmente existem | error |
| S08 | `evals/<name>/scenarios.md` existe | warning |

### Verificacoes semanticas (executadas por IA)

| Regra | O que verifica | Severidade |
|-------|---------------|-----------|
| M01 | A descricao indica claramente o proposito e as condicoes de ativacao | warning |
| M02 | O nome coincide com o nome do diretorio; a descricao e consistente entre arquivos | warning |
| M03 | A logica de roteamento de comandos referencia corretamente o nome do skill | warning |
| M04 | O conteudo de references e logicamente consistente com o SKILL.md | warning |
| M05 | Os cenarios de avaliacao cobrem os caminhos de funcionalidade principal (pelo menos 5) | warning |

---

## Exemplos de saida esperada

### Todas as verificacoes passaram

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────────┤
│ Structural checks│ ✓ 19 passed · ✗ 0 errors     │
├──────────────────┼───────────────────────────────────┤
│ Semantic checks  │ ✓ 5 passed · ⚠ 0 warnings    │
└──────────────────┴───────────────────────────────────┘
```

### Problemas encontrados

```
Skill Lint Complete
┌──────────────────┬───────────────────────────────────┐
│ Target path      │ /path/to/plugin               │
├──────────────────┼───────────────────────────────────┤
│ Structural checks│ ✓ 5 passed · ✗ 2 errors      │
├──────────────────┼───────────────────────────────────┤
│ Semantic checks  │ ✓ 3 passed · ⚠ 1 warning     │
└──────────────────┴───────────────────────────────────┘

Errors:
  1. skills/foo/SKILL.md: missing required field 'description'
  2. .claude-plugin/marketplace.json: skill 'foo' not listed

Warnings:
  1. skills/foo/SKILL.md: description does not match marketplace.json
```

---

## Fluxo de trabalho

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

## Perguntas frequentes

### Posso executar apenas as verificacoes estruturais, sem as semanticas?

Sim — execute o script bash diretamente:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Isso produz JSON puro sem analise semantica de IA.

### Funciona em projetos que nao sao jskills?

Sim. Qualquer diretorio que siga a estrutura padrao de plugin do Claude Code (`skills/`, `commands/`, `.claude-plugin/`) pode ser validado.

### Qual a diferenca entre erros e avisos?

- **error**: Problemas estruturais que impedirao o skill de carregar ou ser publicado corretamente
- **warning**: Problemas de qualidade que nao quebrarao a funcionalidade mas afetam a manutenibilidade e a descobribilidade

### Outras ferramentas do jskills

Skill Lint faz parte da colecao jskills e funciona bem junto a estes skills:

- [Block Break](block-break-guide.md) — Motor de restricoes de comportamento de alta agencia que forca a IA a esgotar cada abordagem
- [Ralph Boost](ralph-boost-guide.md) — Motor de loop de desenvolvimento autonomo com garantias de convergencia Block Break integradas

Apos desenvolver um novo skill, execute `/skill-lint .` para verificar a completude estrutural e confirmar que o frontmatter, marketplace.json e os links de referencia estao corretos.

---

## Licenca

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
