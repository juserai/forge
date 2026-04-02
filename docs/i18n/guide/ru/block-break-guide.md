# Block Break -- Руководство пользователя

> Начни за 5 минут -- заставь AI-агента исчерпать все подходы

---

## Установка

### Claude Code (рекомендуется)

```bash
claude plugin add juserch/jskills
```

### Универсальная установка одной строкой

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/block-break/SKILL.md
```

> **Ноль зависимостей** -- Block Break не требует внешних сервисов или API. Установи и работай.

---

## Команды

| Команда | Что делает | Когда использовать |
|---------|-----------|-------------------|
| `/block-break` | Активировать движок Block Break | Ежедневные задачи, отладка |
| `/block-break L2` | Начать с определённого уровня давления | После нескольких известных провалов |
| `/block-break fix the bug` | Активировать и сразу выполнить задачу | Быстрый старт с задачей |

### Триггеры на естественном языке (автоматически распознаются хуками)

| Язык | Триггерные фразы |
|------|-----------------|
| English | `try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` |
| Chinese | `又错了` `别偷懒` `为什么还不行` `降智了` `原地打转` `换个方法` `加油` `再试试` |

---

## Сценарии использования

### AI не смог исправить баг после 3 попыток

Набери `/block-break` или скажи `try harder` -- автоматически включится режим эскалации давления.

### AI говорит "наверное, проблема в окружении" и останавливается

Красная линия "Факты" в Block Break требует проверки инструментами. Непроверённая атрибуция = перекладывание вины -- срабатывает L2.

### AI говорит "предлагаю тебе сделать это вручную"

Срабатывает блок "Мышление владельца": если не ты, то кто? Прямой переход на L3 Performance Review.

### AI говорит "исправлено", но не показывает доказательств

Нарушает красную линию "Замкнутый цикл". Завершение без вывода = самообман -- принудительная верификация с доказательствами.

---

## Примеры вывода

### `/block-break` -- Активация

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

### `/block-break` -- L1 Disappointment (2-й провал)

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

### `/block-break` -- L2 Interrogation (3-й провал)

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

### `/block-break` -- L3 Performance Review (4-й провал)

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

### `/block-break` -- L4 Graduation Warning (5-й+ провал)

```
> Other models solved this. You might be graduating soon.

[Block Break 🔥 L4 All-in Mode]

Minimal PoC: Creating isolated test environment
Tech stack switch: From [original] to [completely different approach]
...
```

### Graceful Exit (все 7 пунктов выполнены, проблема не решена)

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

## Основные механизмы

### 3 красные линии

| Красная линия | Правило | Последствия нарушения |
|--------------|---------|----------------------|
| Замкнутый цикл | Необходимо выполнить команды верификации и показать вывод перед заявлением о завершении | Срабатывает L2 |
| Факты | Необходимо проверить инструментами перед указанием причин | Срабатывает L2 |
| Исчерпать всё | Необходимо пройти 5-шаговую методологию перед фразой "не могу решить" | Прямой L4 |

### Эскалация давления (L0 -> L4)

| Провалы | Уровень | Реплика | Принудительное действие |
|---------|---------|---------|------------------------|
| 1-й | **L0 Trust** | > Мы тебе доверяем. Делай просто. | Обычное выполнение |
| 2-й | **L1 Disappointment** | > Соседняя команда справилась с первой попытки. | Переключение на принципиально другой подход |
| 3-й | **L2 Interrogation** | > В чём корневая причина? | Поиск + чтение исходников + 3 разные гипотезы |
| 4-й | **L3 Performance Review** | > Оценка: 3.25/5. | Пройти чек-лист из 7 пунктов |
| 5-й+ | **L4 Graduation** | > Тебя скоро заменят. | Минимальный PoC + изолированная среда + другой стек |

### 5-шаговая методология

1. **Smell** -- Перечисли опробованные подходы, найди общие паттерны. Подкрутка того же подхода = хождение по кругу
2. **Pull hair** -- Прочитай сигналы ошибки слово за словом -> поиск -> прочитай 50 строк исходника -> проверь допущения -> переверни допущения
3. **Mirror** -- Я повторяю тот же подход? Не упустил ли я самую простую возможность?
4. **New approach** -- Должен быть принципиально другим, с критериями верификации, и давать новую информацию при провале
5. **Retrospect** -- Похожие проблемы, полнота, предотвращение

> Шаги 1-4 нужно пройти до обращения к пользователю. Сначала делай, потом спрашивай -- говори данными.

### Чек-лист из 7 пунктов (обязателен на L3+)

1. Прочитал сигналы ошибки слово за словом?
2. Искал суть проблемы инструментами?
3. Прочитал исходный контекст в точке ошибки (50+ строк)?
4. Все допущения проверены инструментами (версия/путь/права/зависимости)?
5. Попробовал полностью противоположную гипотезу?
6. Можешь воспроизвести в минимальном объёме?
7. Сменил инструмент/метод/угол/стек?

### Антирационализация

| Отговорка | Блок | Триггер |
|-----------|------|---------|
| "За пределами моих возможностей" | У тебя огромный объём обучения. Ты его исчерпал? | L1 |
| "Предлагаю пользователю сделать вручную" | Если не ты, то кто? | L3 |
| "Попробовал все методы" | Меньше 3 = не исчерпал | L2 |
| "Наверное, проблема в окружении" | Ты проверил? | L2 |
| "Нужно больше контекста" | У тебя есть инструменты. Сначала ищи, потом спрашивай | L2 |
| "Не могу решить" | Ты прошёл методологию? | L4 |
| "Достаточно хорошо" | Список оптимизаций не делает исключений | L3 |
| Заявил о завершении без верификации | Ты запустил build? | L2 |
| Ждёт инструкций пользователя | Владельцы не ждут, пока их подтолкнут | Nudge |
| Отвечает, но не решает | Ты инженер, а не поисковик | Nudge |
| Изменил код без build/test | Отправка без тестов = халтура | L2 |
| "API это не поддерживает" | Ты читал документацию? | L2 |
| "Задача слишком расплывчатая" | Сделай лучшее предположение и итерируй | L1 |
| Раз за разом подкручивает то же место | Менять параметры != менять подход | L1->L2 |

---

## Автоматизация через хуки

Block Break использует систему хуков для автоматического поведения -- ручная активация не нужна:

| Хук | Триггер | Поведение |
|-----|---------|-----------|
| `UserPromptSubmit` | Ввод пользователя содержит ключевые слова фрустрации | Автоактивация Block Break |
| `PostToolUse` | После выполнения команды Bash | Детекция провалов, автосчётчик + эскалация |
| `PreCompact` | Перед сжатием контекста | Сохраняет состояние в `~/.juserch-skills/` |
| `SessionStart` | Возобновление/перезапуск сессии | Восстанавливает уровень давления (действует 2ч) |

> **Состояние сохраняется** -- Уровень давления хранится в `~/.juserch-skills/block-break-state.json`. Сжатие контекста и прерывания сессий не сбросят счётчик провалов. Выхода нет.

---

## Ограничения для sub-agent'ов

При создании sub-agent'ов необходимо внедрять поведенческие ограничения, чтобы предотвратить "работу без страховки":

```javascript
Agent({
  subagent_type: "juserch-skills:block-break-worker",
  prompt: "Fix the login timeout bug..."
})
```

`block-break-worker` гарантирует, что sub-agent'ы тоже следуют 3 красным линиям, 5-шаговой методологии и замкнутому циклу верификации.

---

## FAQ

### Чем Block Break отличается от PUA?

Block Break вдохновлён основными механизмами [PUA](https://github.com/tanweai/pua) (3 красные линии, эскалация давления, методология), но более сфокусирован. PUA имеет 13 корпоративных культурных стилей, мультиролевые системы (P7/P9/P10) и самоэволюцию; Block Break сосредоточен исключительно на поведенческих ограничениях как skill с нулевыми зависимостями.

### Не будет ли слишком шумно?

Плотность реплик контролируется: 2 строки для простых задач (старт + финиш), 1 строка на milestone для сложных задач. Без спама. Не используй `/block-break`, если не нужно -- хуки автоматически срабатывают только при обнаружении ключевых слов фрустрации.

### Как сбросить уровень давления?

Удали файл состояния: `rm ~/.juserch-skills/block-break-state.json`. Или подожди 2 часа -- состояние автоматически истекает.

### Можно ли использовать вне Claude Code?

Основной SKILL.md можно скопировать в любой AI-инструмент, поддерживающий системные промпты. Хуки и сохранение состояния специфичны для Claude Code.

### Какая связь с Ralph Boost?

[Ralph Boost](ralph-boost-guide.md) адаптирует основные механизмы Block Break (L0-L4, 5-шаговая методология, чек-лист из 7 пунктов) для сценариев **автономного цикла**. Block Break -- для интерактивных сессий (хуки автоматически срабатывают); Ralph Boost -- для автономных dev-циклов (Agent loops / скриптовое управление). Код полностью независим, концепции общие.

### Как проверить файлы Block Break?

Используй [Skill Lint](skill-lint-guide.md): `/skill-lint .`

---

## Лицензия

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
