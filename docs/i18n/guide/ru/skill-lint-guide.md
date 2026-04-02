# Skill Lint -- Руководство пользователя

> Начни за 3 минуты -- проверь качество своего Claude Code skill

---

## Установка

### Claude Code (рекомендуется)

```bash
claude plugin add juserch/jskills
```

### Универсальная установка одной строкой

```
Fetch and follow https://raw.githubusercontent.com/juserch/jskills/main/skills/skill-lint/SKILL.md
```

> **Ноль зависимостей** -- Skill Lint не требует внешних сервисов или API. Установи и работай.

---

## Команды

| Команда | Что делает | Когда использовать |
|---------|-----------|-------------------|
| `/skill-lint` | Показать справку | Посмотреть доступные проверки |
| `/skill-lint .` | Проверить текущий проект | Самопроверка при разработке |
| `/skill-lint /path/to/plugin` | Проверить указанный путь | Ревью чужого плагина |

---

## Сценарии использования

### Самопроверка после создания нового skill

После создания `skills/<name>/SKILL.md`, `commands/<name>.md` и связанных файлов запусти `/skill-lint .`, чтобы убедиться, что структура полная, frontmatter корректный и запись в marketplace добавлена.

### Ревью чужого плагина

При ревью PR или аудите другого плагина используй `/skill-lint /path/to/plugin` для быстрой проверки полноты файлов и консистентности.

### Интеграция с CI

`scripts/skill-lint.sh` можно запускать напрямую в CI-пайплайне, вывод в формате JSON для автоматического парсинга:

```bash
bash skills/skill-lint/scripts/skill-lint.sh /path/to/plugin
```

---

## Проверки

### Структурные проверки (выполняются Bash-скриптом)

| Правило | Что проверяет | Серьёзность |
|---------|--------------|-------------|
| S01 | `plugin.json` существует в корне и в `.claude-plugin/` | error |
| S02 | `.claude-plugin/marketplace.json` существует | error |
| S03 | Каждая `skills/<name>/` содержит `SKILL.md` | error |
| S04 | Frontmatter в SKILL.md содержит `name` и `description` | error |
| S05 | Для каждого skill есть соответствующий `commands/<name>.md` | warning |
| S06 | Каждый skill указан в массиве `plugins` в marketplace.json | warning |
| S07 | Файлы references, упомянутые в SKILL.md, действительно существуют | error |
| S08 | `evals/<name>/scenarios.md` существует | warning |

### Семантические проверки (выполняются AI)

| Правило | Что проверяет | Серьёзность |
|---------|--------------|-------------|
| M01 | Описание чётко указывает назначение и условия срабатывания | warning |
| M02 | Имя совпадает с именем директории; описание консистентно во всех файлах | warning |
| M03 | Логика маршрутизации команд корректно ссылается на имя skill | warning |
| M04 | Содержимое references логически согласовано с SKILL.md | warning |
| M05 | Сценарии eval покрывают основные функциональные пути (минимум 5) | warning |

---

## Примеры вывода

### Все проверки пройдены

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

### Найдены проблемы

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

## Рабочий процесс

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

### Можно ли запустить только структурные проверки, без семантических?

Да -- запусти bash-скрипт напрямую:

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
```

Это выведет чистый JSON без AI-семантического анализа.

### Работает ли на проектах вне jskills?

Да. Любая директория, следующая стандартной структуре Claude Code plugin (`skills/`, `commands/`, `.claude-plugin/`), может быть проверена.

### В чём разница между errors и warnings?

- **error**: Структурные проблемы, которые помешают skill загрузиться или опубликоваться правильно
- **warning**: Проблемы качества, которые не сломают функциональность, но влияют на поддерживаемость и обнаруживаемость

### Другие инструменты jskills

Skill Lint -- часть коллекции jskills и отлично работает вместе с этими skills:

- [Block Break](block-break-guide.md) -- Высокоактивный движок поведенческих ограничений, заставляющий AI исчерпать все подходы
- [Ralph Boost](ralph-boost-guide.md) -- Движок автономного dev-цикла со встроенными гарантиями сходимости Block Break

После разработки нового skill запусти `/skill-lint .`, чтобы проверить структурную полноту и убедиться, что frontmatter, marketplace.json и ссылки на references корректны.

---

## Лицензия

[MIT](../../../../LICENSE) - [juserch](https://github.com/juserch)
