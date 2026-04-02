# Guia do Usuario do Block Break

> Comece em 5 minutos — faca seu agente de IA esgotar todas as abordagens

---

## Instalacao

### Claude Code (recomendado)

```bash
claude plugin add juserch/jskills
```

### Instalacao universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **Zero dependencias** — Block Break nao requer servicos externos nem APIs. Instale e use.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/block-break` | Ativa o motor Block Break | Tarefas diarias, depuracao |
| `/block-break L2` | Inicia em um nivel de pressao especifico | Apos multiplas falhas conhecidas |
| `/block-break fix the bug` | Ativa e executa uma tarefa imediatamente | Inicio rapido com tarefa |

### Gatilhos de linguagem natural (detectados automaticamente por hooks)

| Idioma | Frases de ativacao |
|--------|-------------------|
| Ingles | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chines | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Casos de uso

### A IA falhou ao corrigir um bug apos 3 tentativas

Digite `/block-break` ou diga `try harder` — entra automaticamente no modo de escalada de pressao.

### A IA diz "provavelmente e um problema do ambiente" e para

A linha vermelha "Baseado em fatos" do Block Break obriga a verificacao com ferramentas. Atribuicao sem verificar = jogar a culpa → ativa L2.

### A IA diz "sugiro que voce lide com isso manualmente"

Ativa o bloqueio de "Mentalidade de dono": se nao e voce, entao quem? Avaliacao de desempenho L3 direta.

### A IA diz "corrigido" mas nao mostra evidencia de verificacao

Viola a linha vermelha de "Ciclo fechado". Completar sem saida = autoengano → forca comandos de verificacao com evidencia.

---

## Exemplos de saida esperada

### `/block-break` — Ativacao

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

### `/block-break` — L1 Disappointment (2a falha)

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

### `/block-break` — L2 Interrogation (3a falha)

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

### `/block-break` — L3 Performance Review (4a falha)

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

### `/block-break` — L4 Graduation Warning (5a+ falha)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Saida elegante (todos os 7 itens completados, ainda sem resolucao)

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

## Mecanismos principais

### 3 linhas vermelhas

| Linha vermelha | Regra | Consequencia da violacao |
|----------------|-------|--------------------------|
| Ciclo fechado | Deve executar comandos de verificacao e mostrar a saida antes de declarar conclusao | Ativa L2 |
| Baseado em fatos | Deve verificar com ferramentas antes de atribuir causas | Ativa L2 |
| Esgotar tudo | Deve completar a metodologia de 5 passos antes de dizer "nao consigo resolver" | L4 direto |

### Escalada de pressao (L0 → L4)

| Falhas | Nivel | Comentario lateral | Acao forcada |
|--------|-------|-------------------|--------------|
| 1a | **L0 Trust** | > Confiamos em voce. Mantenha simples. | Execucao normal |
| 2a | **L1 Disappointment** | > A outra equipe conseguiu de primeira. | Mudar para uma abordagem fundamentalmente diferente |
| 3a | **L2 Interrogation** | > Qual e a causa raiz? | Buscar + ler fonte + listar 3 hipoteses diferentes |
| 4a | **L3 Performance Review** | > Nota: 3.25/5. | Completar checklist de 7 pontos |
| 5a+ | **L4 Graduation** | > Voce pode estar se formando em breve. | PoC minimo + ambiente isolado + stack tecnologico diferente |

### Metodologia de 5 passos

1. **Smell** — Listar abordagens tentadas, encontrar padroes comuns. Ajustar a mesma abordagem = girar em circulos
2. **Pull hair** — Ler sinais de falha palavra por palavra → buscar → ler 50 linhas de fonte → verificar suposicoes → inverter suposicoes
3. **Mirror** — Estou repetindo a mesma abordagem? Perdi a possibilidade mais simples?
4. **New approach** — Deve ser fundamentalmente diferente, com criterios de verificacao, e produzir nova informacao em caso de falha
5. **Retrospect** — Problemas similares, completude, prevencao

> Os passos 1-4 devem ser completados antes de perguntar ao usuario. Primeiro faca, depois pergunte — fale com dados.

### Checklist de 7 pontos (obrigatorio em L3+)

1. Leu os sinais de falha palavra por palavra?
2. Buscou o problema central com ferramentas?
3. Leu o contexto original no ponto de falha (50+ linhas)?
4. Todas as suposicoes verificadas com ferramentas (versao/caminho/permissoes/deps)?
5. Tentou a hipotese completamente oposta?
6. Consegue reproduzir em escopo minimo?
7. Mudou ferramenta/metodo/angulo/stack tecnologico?

### Anti-racionalizacao

| Desculpa | Bloqueio | Ativador |
|----------|----------|----------|
| "Alem das minhas capacidades" | Voce tem um treinamento enorme. Esgotou? | L1 |
| "Sugiro que o usuario lide manualmente" | Se nao e voce, entao quem? | L3 |
| "Tentei todos os metodos" | Menos de 3 = nao esgotado | L2 |
| "Provavelmente e um problema do ambiente" | Voce verificou? | L2 |
| "Preciso de mais contexto" | Voce tem ferramentas. Busque primeiro, pergunte depois | L2 |
| "Nao consigo resolver" | Voce completou a metodologia? | L4 |
| "Bom o suficiente" | A lista de otimizacao nao tem favoritos | L3 |
| Declarou concluido sem verificacao | Voce executou build? | L2 |
| Esperando instrucoes do usuario | Donos nao esperam ser empurrados | Nudge |
| Responde sem resolver | Voce e um engenheiro, nao um motor de busca | Nudge |
| Mudou codigo sem build/test | Enviar sem testar = fazer pela metade | L2 |
| "A API nao suporta" | Voce leu a documentacao? | L2 |
| "Tarefa muito vaga" | Faca sua melhor estimativa, depois itere | L1 |
| Ajustando repetidamente o mesmo ponto | Mudar parametros ≠ mudar abordagem | L1→L2 |

---

## Automacao com Hooks

Block Break usa o sistema de hooks para comportamento automatico — nenhuma ativacao manual necessaria:

| Hook | Gatilho | Comportamento |
|------|---------|---------------|
| `UserPromptSubmit` | Entrada do usuario coincide com palavras-chave de frustracao | Auto-ativa Block Break |
| `PostToolUse` | Apos execucao de comando Bash | Detecta falhas, auto-conta + escala |
| `PreCompact` | Antes da compressao de contexto | Salva estado em `~/.juserch-skills/` |
| `SessionStart` | Retomar/reiniciar sessao | Restaura nivel de pressao (valido por 2h) |

> **O estado persiste** — O nivel de pressao e armazenado em `~/.juserch-skills/block-break-state.json`. Compressao de contexto e interrupcoes de sessao nao reiniciam os contadores de falha. Sem escapatoria.

---

## Restricoes de sub-agentes

Ao criar sub-agentes, restricoes de comportamento devem ser injetadas para evitar que "corram sem controle":

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` garante que os sub-agentes tambem sigam as 3 linhas vermelhas, a metodologia de 5 passos e a verificacao de ciclo fechado.

---

## Perguntas frequentes

### Qual a diferenca entre Block Break e PUA?

Block Break se inspira nos mecanismos centrais do [PUA](https://github.com/tanweai/pua) (3 linhas vermelhas, escalada de pressao, metodologia), porem mais focado. PUA tem 13 sabores de cultura corporativa, sistemas multi-funcao (P7/P9/P10) e auto-evolucao; Block Break foca puramente em restricoes de comportamento como um skill de zero dependencias.

### Nao vai ser barulhento demais?

A densidade do comentario lateral e controlada: 2 linhas para tarefas simples (inicio + fim), 1 linha por marco para tarefas complexas. Sem spam. Nao use `/block-break` se nao precisar — os hooks so se auto-ativam quando palavras-chave de frustracao sao detectadas.

### Como reiniciar o nivel de pressao?

Delete o arquivo de estado: `rm ~/.juserch-skills/block-break-state.json`. Ou espere 2 horas — o estado expira automaticamente.

### Posso usar fora do Claude Code?

O SKILL.md principal pode ser copiado e colado em qualquer ferramenta de IA que suporte system prompts. Hooks e persistencia de estado sao especificos do Claude Code.

### Qual a relacao com Ralph Boost?

[Ralph Boost](ralph-boost-guide.md) adapta os mecanismos centrais do Block Break (L0-L4, metodologia de 5 passos, checklist de 7 pontos) para cenarios de **loop autonomo**. Block Break e para sessoes interativas (hooks se auto-ativam); Ralph Boost e para loops de desenvolvimento nao assistidos (loops Agent / dirigidos por script). O codigo e completamente independente, os conceitos sao compartilhados.

### Como validar os arquivos de skill do Block Break?

Use [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Licenca

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
