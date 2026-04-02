# Guia do Usuario do Ralph Boost

> Comece em 5 minutos — impeca que seu loop de desenvolvimento autonomo de IA trave

---

## Instalacao

### Claude Code (recomendado)

```bash
claude plugin add juserch/jskills
```

### Instalacao universal em uma linha

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Zero dependencias** — Ralph Boost nao depende de ralph-claude-code, block-break nem de nenhum servico externo. O caminho principal (Agent loop) tem zero dependencias externas; o caminho alternativo requer `jq` ou `python` e a CLI `claude`.

---

## Comandos

| Comando | O que faz | Quando usar |
|---------|-----------|-------------|
| `/ralph-boost setup` | Inicializa o loop autonomo no seu projeto | Configuracao inicial |
| `/ralph-boost run` | Inicia o loop autonomo na sessao atual | Apos a inicializacao |
| `/ralph-boost status` | Ver o estado atual do loop | Monitorar progresso |
| `/ralph-boost clean` | Remover arquivos do loop | Limpeza |

---

## Inicio rapido

### 1. Inicializar o projeto

```text
/ralph-boost setup
```

Claude vai te guiar por:
- Detectar o nome do projeto
- Gerar uma lista de tarefas (fix_plan.md)
- Criar o diretorio `.ralph-boost/` e todos os arquivos de configuracao

### 2. Iniciar o loop

```text
/ralph-boost run
```

Claude controla o loop autonomo diretamente dentro da sessao atual (modo Agent loop). Cada iteracao gera um sub-agente para executar uma tarefa, enquanto a sessao principal atua como controlador do loop gerenciando o estado.

**Alternativa** (ambientes headless / nao assistidos):

```bash
# Primeiro plano
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Segundo plano
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Monitorar status

```text
/ralph-boost status
```

Exemplo de saida:

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

## Como funciona

### Loop autonomo

Ralph Boost fornece dois caminhos de execucao:

**Caminho principal (Agent loop)**: Claude atua como controlador do loop dentro da sessao atual, gerando um sub-agente a cada iteracao para executar tarefas. A sessao principal gerencia o estado, o circuit breaker e a escalada de pressao. Zero dependencias externas.

**Alternativa (bash script)**: `boost-loop.sh` executa chamadas `claude -p` em um loop em segundo plano. Suporta tanto jq quanto python como motores JSON, auto-detectados em tempo de execucao. O tempo de espera padrao entre iteracoes e de 1 hora (configuravel).

Ambos os caminhos compartilham o mesmo gerenciamento de estado (state.json), logica de escalada de pressao e protocolo BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker aprimorado (vs ralph-claude-code)

O circuit breaker do ralph-claude-code: desiste apos 3 loops consecutivos sem progresso.

O circuit breaker do ralph-boost: **escala a pressao progressivamente** quando estagnado, ate 6-7 loops de auto-recuperacao antes de parar.

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

## Exemplos de saida esperada

### L0 — Execucao normal

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

### L1 — Troca de abordagem

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude e forcado a abandonar a abordagem anterior e tentar algo **fundamentalmente diferente**. Ajustar parametros nao conta.

### L2 — Buscar e formular hipoteses

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude deve: ler o erro palavra por palavra → buscar 50+ linhas de contexto → listar 3 hipoteses diferentes.

### L3 — Checklist

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude deve completar o checklist de 7 pontos (ler sinais de erro, buscar problema central, ler fonte, verificar suposicoes, hipotese inversa, reproducao minima, trocar ferramentas/metodos). Cada item completado e gravado em state.json.

### L4 — Transferencia elegante

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude constroi um PoC minimo e depois gera um relatorio de transferencia:

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

Apos a transferencia completa, o loop se encerra elegantemente. Isso nao e "nao consigo" — e "aqui esta onde esta o limite".

---

## Configuracao

`.ralph-boost/config.json`:

| Campo | Valor padrao | Descricao |
|-------|-------------|-----------|
| `max_calls_per_hour` | 100 | Maximo de chamadas a API do Claude por hora |
| `claude_timeout_minutes` | 15 | Timeout por chamada individual |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Ferramentas disponiveis para Claude |
| `claude_model` | "" | Override de modelo (vazio = padrao) |
| `session_expiry_hours` | 24 | Tempo de expiracao da sessao |
| `no_progress_threshold` | 7 | Limiar de sem progresso antes do desligamento |
| `same_error_threshold` | 8 | Limiar de mesmo erro antes do desligamento |
| `sleep_seconds` | 3600 | Tempo de espera entre iteracoes (segundos) |

### Ajustes comuns de configuracao

**Acelerar o loop** (para testes):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Restringir permissoes de ferramentas**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Usar um modelo especifico**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Estrutura do diretorio do projeto

```
.ralph-boost/
├── PROMPT.md           # Instrucoes de desenvolvimento (inclui protocolo block-break)
├── fix_plan.md         # Lista de tarefas (atualizada automaticamente pelo Claude)
├── config.json         # Configuracao
├── state.json          # Estado unificado (circuit breaker + pressao + sessao)
├── handoff-report.md   # Relatorio de transferencia L4 (gerado na saida elegante)
├── logs/
│   ├── boost.log       # Log do loop
│   └── claude_output_*.log  # Saida por iteracao
└── .gitignore          # Ignora estado e logs
```

Todos os arquivos ficam dentro de `.ralph-boost/` — a raiz do seu projeto nunca e tocada.

---

## Relacao com ralph-claude-code

Ralph Boost e um **substituto independente** do [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), nao um complemento.

| Aspecto | ralph-claude-code | ralph-boost |
|---------|-------------------|-------------|
| Formato | Ferramenta Bash independente | Skill de Claude Code (Agent loop) |
| Instalacao | `npm install` | Plugin de Claude Code |
| Tamanho do codigo | 2000+ linhas | ~400 linhas |
| Deps externas | jq (obrigatorio) | Caminho principal: zero; Alternativa: jq ou python |
| Diretorio | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Passivo (desiste apos 3 loops) | Ativo (L0-L4, 6-7 loops de auto-recuperacao) |
| Coexistencia | Sim | Sim (zero conflitos de arquivos) |

Ambos podem ser instalados no mesmo projeto simultaneamente — usam diretorios separados e nao interferem entre si.

---

## Relacao com Block Break

Ralph Boost adapta os mecanismos centrais do Block Break (escalada de pressao, metodologia de 5 passos, checklist) para cenarios de loop autonomo:

| Aspecto | block-break | ralph-boost |
|---------|-------------|-------------|
| Cenario | Sessoes interativas | Loops autonomos |
| Ativacao | Hooks se auto-ativam | Integrado no Agent loop / script do loop |
| Deteccao | Hook PostToolUse | Deteccao de progresso Agent loop / deteccao de progresso do script |
| Controle | Prompts injetados por hook | Injecao de prompt Agent / --append-system-prompt |
| Estado | `~/.juserch-skills/` | `.ralph-boost/state.json` |

O codigo e completamente independente; os conceitos sao compartilhados.

> **Referencia**: A escalada de pressao do Block Break (L0-L4), a metodologia de 5 passos e o checklist de 7 pontos formam a base conceitual do circuit breaker do ralph-boost. Veja o [Guia do Usuario do Block Break](block-break-guide.md) para detalhes.

---

## Perguntas frequentes

### Como escolho entre o caminho principal e a alternativa?

`/ralph-boost run` usa o Agent loop (caminho principal) por padrao, executando diretamente dentro da sessao atual do Claude Code. Use o script bash alternativo quando precisar de execucao headless ou nao assistida.

### Onde esta o script do loop?

Apos instalar o plugin jskills, o script alternativo esta em `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh`. Voce tambem pode copia-lo para qualquer lugar e executa-lo de la. O script auto-detecta jq ou python como seu motor JSON.

### Como vejo os logs do loop?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Como reinicio manualmente o nivel de pressao?

Edite `.ralph-boost/state.json`: defina `pressure.level` como 0 e `circuit_breaker.consecutive_no_progress` como 0. Ou simplesmente delete state.json e reinicialize.

### Como modifico a lista de tarefas?

Edite `.ralph-boost/fix_plan.md` diretamente, usando o formato `- [ ] task`. Claude o le no inicio de cada iteracao.

### Como recupero apos o circuit breaker abrir?

Edite `state.json`, defina `circuit_breaker.state` como `"CLOSED"`, reinicie os contadores relevantes e execute o script novamente.

### Preciso do ralph-claude-code?

Nao. Ralph Boost e completamente independente e nao depende de nenhum arquivo do Ralph.

### Quais plataformas sao suportadas?

Atualmente suporta Claude Code (caminho principal Agent loop). O script bash alternativo requer bash 4+, jq ou python, e a CLI claude.

### Como validar os arquivos de skill do ralph-boost?

Use [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Licenca

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
