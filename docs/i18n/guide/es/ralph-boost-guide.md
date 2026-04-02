# Guia de Usuario de Ralph Boost

> Empieza en 5 minutos — evita que tu bucle de desarrollo autonomo de IA se estanque

---

## Instalacion

### Claude Code (recomendado)

```bash
claude plugin add juserch/jskills
```

### Instalacion universal en una linea

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Cero dependencias** — Ralph Boost no depende de ralph-claude-code, block-break ni ningun servicio externo. La ruta principal (Agent loop) tiene cero dependencias externas; la ruta alternativa requiere `jq` o `python` y la CLI `claude`.

---

## Comandos

| Comando | Que hace | Cuando usarlo |
|---------|----------|---------------|
| `/ralph-boost setup` | Inicializa el bucle autonomo en tu proyecto | Configuracion inicial |
| `/ralph-boost run` | Inicia el bucle autonomo en la sesion actual | Despues de la inicializacion |
| `/ralph-boost status` | Ver el estado actual del bucle | Monitorear progreso |
| `/ralph-boost clean` | Eliminar archivos del bucle | Limpieza |

---

## Inicio rapido

### 1. Inicializar el proyecto

```text
/ralph-boost setup
```

Claude te guiara a traves de:
- Detectar el nombre del proyecto
- Generar una lista de tareas (fix_plan.md)
- Crear el directorio `.ralph-boost/` y todos los archivos de configuracion

### 2. Iniciar el bucle

```text
/ralph-boost run
```

Claude controla el bucle autonomo directamente dentro de la sesion actual (modo Agent loop). Cada iteracion genera un sub-agente para ejecutar una tarea, mientras la sesion principal actua como controlador del bucle gestionando el estado.

**Alternativa** (entornos headless / desatendidos):

```bash
# Primer plano
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Segundo plano
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Monitorear estado

```text
/ralph-boost status
```

Ejemplo de salida:

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

### Bucle autonomo

Ralph Boost proporciona dos rutas de ejecucion:

**Ruta principal (Agent loop)**: Claude actua como controlador del bucle dentro de la sesion actual, generando un sub-agente en cada iteracion para ejecutar tareas. La sesion principal gestiona el estado, el circuit breaker y el escalado de presion. Cero dependencias externas.

**Alternativa (bash script)**: `boost-loop.sh` ejecuta llamadas `claude -p` en un bucle en segundo plano. Soporta tanto jq como python como motores JSON, auto-detectados en tiempo de ejecucion. El tiempo de espera entre iteraciones es de 1 hora por defecto (configurable).

Ambas rutas comparten la misma gestion de estado (state.json), logica de escalado de presion y protocolo BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Circuit Breaker mejorado (vs ralph-claude-code)

El circuit breaker de ralph-claude-code: se rinde despues de 3 bucles consecutivos sin progreso.

El circuit breaker de ralph-boost: **escala la presion progresivamente** cuando se estanca, hasta 6-7 bucles de auto-recuperacion antes de detenerse.

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

## Ejemplos de salida esperada

### L0 — Ejecucion normal

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

### L1 — Cambio de enfoque

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude se ve obligado a abandonar el enfoque anterior y probar algo **fundamentalmente diferente**. Ajustar parametros no cuenta.

### L2 — Buscar y formular hipotesis

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude debe: leer el error palabra por palabra → buscar 50+ lineas de contexto → listar 3 hipotesis diferentes.

### L3 — Lista de verificacion

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude debe completar la lista de 7 puntos (leer senales de error, buscar problema central, leer fuente, verificar suposiciones, hipotesis inversa, reproduccion minima, cambiar herramientas/metodos). Cada elemento completado se escribe en state.json.

### L4 — Transferencia elegante

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude construye un PoC minimo y luego genera un informe de transferencia:

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

Despues de completar la transferencia, el bucle se cierra elegantemente. Esto no es "no puedo" — es "aqui esta donde esta el limite".

---

## Configuracion

`.ralph-boost/config.json`:

| Campo | Valor por defecto | Descripcion |
|-------|-------------------|-------------|
| `max_calls_per_hour` | 100 | Maximo de llamadas a la API de Claude por hora |
| `claude_timeout_minutes` | 15 | Timeout por llamada individual |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Herramientas disponibles para Claude |
| `claude_model` | "" | Override de modelo (vacio = predeterminado) |
| `session_expiry_hours` | 24 | Tiempo de expiracion de sesion |
| `no_progress_threshold` | 7 | Umbral de sin progreso antes de apagado |
| `same_error_threshold` | 8 | Umbral de mismo error antes de apagado |
| `sleep_seconds` | 3600 | Tiempo de espera entre iteraciones (segundos) |

### Ajustes comunes de configuracion

**Acelerar el bucle** (para pruebas):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Restringir permisos de herramientas**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Usar un modelo especifico**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Estructura del directorio del proyecto

```
.ralph-boost/
├── PROMPT.md           # Instrucciones de desarrollo (incluye protocolo block-break)
├── fix_plan.md         # Lista de tareas (actualizada automaticamente por Claude)
├── config.json         # Configuracion
├── state.json          # Estado unificado (circuit breaker + presion + sesion)
├── handoff-report.md   # Informe de transferencia L4 (generado en salida elegante)
├── logs/
│   ├── boost.log       # Log del bucle
│   └── claude_output_*.log  # Salida por iteracion
└── .gitignore          # Ignora estado y logs
```

Todos los archivos permanecen dentro de `.ralph-boost/` — la raiz de tu proyecto nunca se toca.

---

## Relacion con ralph-claude-code

Ralph Boost es un **reemplazo independiente** de [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), no un complemento.

| Aspecto | ralph-claude-code | ralph-boost |
|---------|-------------------|-------------|
| Formato | Herramienta Bash independiente | Skill de Claude Code (Agent loop) |
| Instalacion | `npm install` | Plugin de Claude Code |
| Tamano de codigo | 2000+ lineas | ~400 lineas |
| Deps externas | jq (requerido) | Ruta principal: cero; Alternativa: jq o python |
| Directorio | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Pasivo (se rinde despues de 3 bucles) | Activo (L0-L4, 6-7 bucles de auto-recuperacion) |
| Coexistencia | Si | Si (cero conflictos de archivos) |

Ambos pueden instalarse en el mismo proyecto simultaneamente — usan directorios separados y no interfieren entre si.

---

## Relacion con Block Break

Ralph Boost adapta los mecanismos centrales de Block Break (escalado de presion, metodologia de 5 pasos, lista de verificacion) a escenarios de bucle autonomo:

| Aspecto | block-break | ralph-boost |
|---------|-------------|-------------|
| Escenario | Sesiones interactivas | Bucles autonomos |
| Activacion | Los hooks se auto-activan | Integrado en Agent loop / script del bucle |
| Deteccion | Hook PostToolUse | Deteccion de progreso Agent loop / deteccion de progreso del script |
| Control | Prompts inyectados por hook | Inyeccion de prompt Agent / --append-system-prompt |
| Estado | `~/.juserch-skills/` | `.ralph-boost/state.json` |

El codigo es completamente independiente; los conceptos son compartidos.

> **Referencia**: El escalado de presion de Block Break (L0-L4), la metodologia de 5 pasos y la lista de 7 puntos forman la base conceptual del circuit breaker de ralph-boost. Consulta la [Guia de Usuario de Block Break](block-break-guide.md) para mas detalles.

---

## Preguntas frecuentes

### Como elijo entre la ruta principal y la alternativa?

`/ralph-boost run` usa el Agent loop (ruta principal) por defecto, ejecutandose directamente dentro de la sesion actual de Claude Code. Usa el script bash alternativo cuando necesites ejecucion headless o desatendida.

### Donde esta el script del bucle?

Despues de instalar el plugin jskills, el script alternativo esta en `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh`. Tambien puedes copiarlo a cualquier lugar y ejecutarlo desde alli. El script auto-detecta jq o python como su motor JSON.

### Como veo los logs del bucle?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Como reinicio manualmente el nivel de presion?

Edita `.ralph-boost/state.json`: establece `pressure.level` en 0 y `circuit_breaker.consecutive_no_progress` en 0. O simplemente elimina state.json y reinicializa.

### Como modifico la lista de tareas?

Edita `.ralph-boost/fix_plan.md` directamente, usando el formato `- [ ] task`. Claude lo lee al inicio de cada iteracion.

### Como recupero despues de que el circuit breaker se abra?

Edita `state.json`, establece `circuit_breaker.state` en `"CLOSED"`, reinicia los contadores relevantes y vuelve a ejecutar el script.

### Necesito ralph-claude-code?

No. Ralph Boost es completamente independiente y no depende de ningun archivo de Ralph.

### Que plataformas son compatibles?

Actualmente soporta Claude Code (ruta principal Agent loop). El script bash alternativo requiere bash 4+, jq o python, y la CLI claude.

### Como validar los archivos de skill de ralph-boost?

Usa [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Licencia

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
