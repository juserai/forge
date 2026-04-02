# Ralph Boost -- Руководство пользователя

> Начни за 5 минут -- не давай автономному dev-циклу AI зависать

---

## Установка

### Claude Code (рекомендуется)

```bash
claude plugin add juserch/jskills
```

### Универсальная установка одной строкой

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/ralph-boost/SKILL.md
```

> **Ноль зависимостей** -- Ralph Boost не зависит от ralph-claude-code, block-break или каких-либо внешних сервисов. Основной путь (Agent loop) не имеет внешних зависимостей; запасной путь требует `jq` или `python` и CLI `claude`.

---

## Команды

| Команда | Что делает | Когда использовать |
|---------|-----------|-------------------|
| `/ralph-boost setup` | Инициализировать автономный цикл в проекте | Первоначальная настройка |
| `/ralph-boost run` | Запустить автономный цикл в текущей сессии | После инициализации |
| `/ralph-boost status` | Посмотреть текущее состояние цикла | Мониторинг прогресса |
| `/ralph-boost clean` | Удалить файлы цикла | Очистка |

---

## Быстрый старт

### 1. Инициализация проекта

```text
/ralph-boost setup
```

Claude проведёт тебя через:
- Определение имени проекта
- Генерацию списка задач (fix_plan.md)
- Создание директории `.ralph-boost/` и всех конфигурационных файлов

### 2. Запуск цикла

```text
/ralph-boost run
```

Claude управляет автономным циклом прямо в текущей сессии (режим Agent loop). Каждая итерация порождает sub-agent для выполнения задачи, а основная сессия выступает контроллером цикла, управляющим состоянием.

**Запасной вариант** (headless / автоматические среды):

```bash
# Передний план
bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project

# Фон
nohup bash ~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh --project-dir /your/project > /dev/null 2>&1 &
```

### 3. Мониторинг статуса

```text
/ralph-boost status
```

Пример вывода:

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

## Как это работает

### Автономный цикл

Ralph Boost предлагает два пути выполнения:

**Основной путь (Agent loop)**: Claude выступает контроллером цикла в текущей сессии, порождая sub-agent на каждой итерации для выполнения задач. Основная сессия управляет состоянием, circuit breaker'ом и эскалацией давления. Ноль внешних зависимостей.

**Запасной (bash-скрипт)**: `boost-loop.sh` выполняет вызовы `claude -p` в цикле в фоновом режиме. Поддерживает jq и python как JSON-движки, автоопределение при запуске. Пауза между итерациями по умолчанию -- 1 час (настраивается).

Оба пути используют одно и то же управление состоянием (state.json), логику эскалации давления и протокол BOOST_STATUS.

```
Read task → Execute → Detect progress → Adjust strategy → Report → Next iteration
```

### Улучшенный Circuit Breaker (vs ralph-claude-code)

Circuit breaker ralph-claude-code: сдаётся после 3 последовательных циклов без прогресса.

Circuit breaker ralph-boost: **прогрессивно наращивает давление** при застревании, до 6-7 циклов самовосстановления перед остановкой.

```
Progress detected → L0 (сброс, продолжение обычной работы)

No progress:
  1 loop  → L1 Disappointment (принудительная смена подхода)
  2 loops → L2 Interrogation (чтение ошибки слово за словом + поиск в исходниках + 3 гипотезы)
  3 loops → L3 Performance Review (пройти чек-лист из 7 пунктов)
  4 loops → L4 Graduation (минимальный PoC + отчёт о передаче)
  5+ loops → Graceful shutdown (со структурированным отчётом о передаче)
```

---

## Примеры вывода

### L0 -- Обычное выполнение

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

### L1 -- Смена подхода

```
[boost-loop.sh] Circuit breaker: CLOSED | L1 Disappointment | 1 loop without progress

Context injected:
"Loop #3. Pressure: L1 Disappointment. The team next door got it on the first try.
 Tried approaches: 1. MANDATORY: Switch to a fundamentally different approach."
```

Claude вынужден отказаться от предыдущего подхода и попробовать нечто **принципиально другое**. Подкрутка параметров не считается.

### L2 -- Поиск и гипотезы

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L2 Interrogation | 2 loops without progress

Context injected:
"Loop #4. Pressure: L2 Interrogation. What is the underlying logic? Where is the leverage point?
 Tried approaches: 2. MANDATORY: Read the error word-by-word. Search 50+ lines of context.
 List 3 fundamentally different hypotheses."
```

Claude обязан: прочитать ошибку слово за словом -> найти 50+ строк контекста -> перечислить 3 разные гипотезы.

### L3 -- Чек-лист

```
[boost-loop.sh] Circuit breaker: HALF_OPEN | L3 Performance Review | 3 loops without progress
```

Claude обязан пройти чек-лист из 7 пунктов (прочитать сигналы ошибки, искать суть проблемы, прочитать исходники, проверить допущения, перевернуть гипотезу, минимальное воспроизведение, сменить инструменты/методы). Каждый выполненный пункт записывается в state.json.

### L4 -- Graceful Handoff

```
[boost-loop.sh] Circuit breaker: CLOSED | L4 Graduation | L4 active, waiting for handoff report
```

Claude создаёт минимальный PoC, затем генерирует отчёт о передаче:

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

После завершения передачи цикл корректно останавливается. Это не "я не могу" -- это "вот где проходит граница."

---

## Конфигурация

`.ralph-boost/config.json`:

| Поле | По умолчанию | Описание |
|------|-------------|----------|
| `max_calls_per_hour` | 100 | Максимум вызовов Claude API в час |
| `claude_timeout_minutes` | 15 | Таймаут на один вызов |
| `allowed_tools` | Write, Read, Edit, Bash, Glob, Grep | Доступные инструменты Claude |
| `claude_model` | "" | Переопределение модели (пусто = по умолчанию) |
| `session_expiry_hours` | 24 | Время истечения сессии |
| `no_progress_threshold` | 7 | Порог отсутствия прогресса до остановки |
| `same_error_threshold` | 8 | Порог одинаковых ошибок до остановки |
| `sleep_seconds` | 3600 | Пауза между итерациями (секунды) |

### Частые настройки

**Ускорить цикл** (для тестирования):

```json
{
  "sleep_seconds": 60,
  "claude_timeout_minutes": 5
}
```

**Ограничить доступ к инструментам**:

```json
{
  "allowed_tools": ["Read", "Glob", "Grep"]
}
```

**Использовать конкретную модель**:

```json
{
  "claude_model": "claude-sonnet-4-6"
}
```

---

## Структура директории проекта

```
.ralph-boost/
├── PROMPT.md           # Инструкции для разработки (включает block-break протокол)
├── fix_plan.md         # Список задач (автообновляется Claude)
├── config.json         # Конфигурация
├── state.json          # Единое состояние (circuit breaker + давление + сессия)
├── handoff-report.md   # Отчёт о передаче L4 (генерируется при graceful exit)
├── logs/
│   ├── boost.log       # Лог цикла
│   └── claude_output_*.log  # Вывод каждой итерации
└── .gitignore          # Игнорирует состояние и логи
```

Все файлы остаются внутри `.ralph-boost/` -- корень проекта не затрагивается.

---

## Связь с ralph-claude-code

Ralph Boost -- это **независимая замена** [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), а не плагин-расширение.

| Аспект | ralph-claude-code | ralph-boost |
|--------|-------------------|-------------|
| Форма | Автономный Bash-инструмент | Claude Code skill (Agent loop) |
| Установка | `npm install` | Claude Code plugin |
| Объём кода | 2000+ строк | ~400 строк |
| Внешние зависимости | jq (обязательно) | Основной путь: ноль; Запасной: jq или python |
| Директория | `.ralph/` | `.ralph-boost/` |
| Circuit breaker | Пассивный (сдаётся после 3 циклов) | Активный (L0-L4, 6-7 циклов самовосстановления) |
| Сосуществование | Да | Да (ноль конфликтов файлов) |

Оба можно установить в одном проекте одновременно -- они используют разные директории и не мешают друг другу.

---

## Связь с Block Break

Ralph Boost адаптирует основные механизмы Block Break (эскалация давления, 5-шаговая методология, чек-лист) для сценариев автономного цикла:

| Аспект | block-break | ralph-boost |
|--------|-------------|-------------|
| Сценарий | Интерактивные сессии | Автономные циклы |
| Активация | Хуки автоматически срабатывают | Встроено в Agent loop / скрипт цикла |
| Детекция | Хук PostToolUse | Детекция прогресса Agent loop / скрипта |
| Управление | Промпты через хуки | Инъекция промптов Agent / --append-system-prompt |
| Состояние | `~/.juserch-skills/` | `.ralph-boost/state.json` |

Код полностью независим; концепции общие.

> **Справка**: Эскалация давления Block Break (L0-L4), 5-шаговая методология и чек-лист из 7 пунктов образуют концептуальную основу circuit breaker'а ralph-boost. Подробнее в [руководстве Block Break](block-break-guide.md).

---

## FAQ

### Как выбрать между основным путём и запасным?

`/ralph-boost run` по умолчанию использует Agent loop (основной путь), работающий прямо в текущей сессии Claude Code. Запасной bash-скрипт используй, когда нужно headless или автоматическое выполнение.

### Где находится скрипт цикла?

После установки плагина jskills запасной скрипт находится по пути `~/.claude/plugins/juserch_jskills/skills/ralph-boost/scripts/boost-loop.sh`. Можешь скопировать его куда угодно и запускать оттуда. Скрипт автоматически определяет jq или python как JSON-движок.

### Как смотреть логи цикла?

```bash
tail -f .ralph-boost/logs/boost.log
```

### Как вручную сбросить уровень давления?

Отредактируй `.ralph-boost/state.json`: установи `pressure.level` в 0 и `circuit_breaker.consecutive_no_progress` в 0. Или просто удали state.json и переинициализируй.

### Как изменить список задач?

Редактируй `.ralph-boost/fix_plan.md` напрямую, используя формат `- [ ] task`. Claude читает его в начале каждой итерации.

### Как восстановиться после срабатывания circuit breaker?

Отредактируй `state.json`, установи `circuit_breaker.state` в `"CLOSED"`, сбрось соответствующие счётчики и перезапусти скрипт.

### Нужен ли мне ralph-claude-code?

Нет. Ralph Boost полностью независим и не зависит от файлов Ralph.

### Какие платформы поддерживаются?

Сейчас поддерживается Claude Code (основной путь Agent loop). Запасной bash-скрипт требует bash 4+, jq или python и CLI claude.

### Как проверить файлы ralph-boost?

Используй [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Лицензия

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
