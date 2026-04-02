# J Skills

> Работай усерднее, потом сделай перерыв. 4 skill'а для правильного ритма разработки с Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-4-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

### Быстрая демонстрация

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## Установка

```bash
# Claude Code (одна команда)
claude plugin add juserch/jskills

# OpenClaw
git clone https://github.com/juserch/jskills.git
cp -r jskills/platforms/openclaw/* ~/.openclaw/skills/
```

## Skills

### Работай усерднее

| Skill | Что делает | Попробуй |
|-------|-----------|----------|
| **block-break** | Заставляет исчерпать все подходы перед тем, как сдаться | `/block-break` |
| **ralph-boost** | Автономные циклы разработки с гарантией сходимости | `/ralph-boost setup` |
| **skill-lint** | Валидация любого Claude Code skill-плагина | `/skill-lint .` |

### Сделай перерыв

| Skill | Что делает | Попробуй |
|-------|-----------|----------|
| **news-fetch** | Быстрые новости между сессиями кодинга | `/news-fetch AI today` |

---

## Block Break — Движок поведенческих ограничений

Твой AI сдался? `/block-break` заставит его сначала исчерпать все подходы.

Когда Claude застревает, Block Break активирует систему эскалации давления, которая не даёт сдаться преждевременно. Агент проходит через всё более жёсткие стадии решения проблемы, прежде чем ему будет позволено ответить «я не могу это сделать».

| Механизм | Описание |
|----------|----------|
| **3 Red Lines** | Замкнутый цикл верификации / Опора на факты / Исчерпать все варианты |
| **Эскалация давления** | L0 Trust → L1 Disappointment → L2 Interrogation → L3 Performance Review → L4 Graduation |
| **5-шаговый метод** | Smell → Pull hair → Mirror → New approach → Retrospect |
| **Чек-лист из 7 пунктов** | Обязательный диагностический чек-лист на уровне L3+ |
| **Анти-рационализация** | Распознаёт и блокирует 14 типичных шаблонов отговорок |
| **Hooks** | Автодетект фрустрации + подсчёт ошибок + сохранение состояния |

```text
/block-break              # Активировать режим Block Break
/block-break L2           # Начать с определённого уровня давления
/block-break fix the bug  # Активировать и сразу начать задачу
```

Также срабатывает на естественный язык: `try harder`, `stop spinning`, `figure it out`, `you keep failing` и т.д. (автодетект через hooks).

> Вдохновлено [PUA](https://github.com/tanweai/pua), переработано в skill с нулевыми зависимостями.

## Ralph Boost — Движок автономного цикла разработки

Автономные циклы разработки, которые действительно сходятся. Настройка за 30 секунд.

Воспроизводит возможности автономного цикла ralph-claude-code в формате skill, со встроенной эскалацией давления Block Break L0-L4 для гарантии сходимости. Решает проблему «крутится, но не продвигается» в автономных циклах.

| Возможность | Описание |
|------------|----------|
| **Dual-Path Loop** | Agent loop (основной, без внешних зависимостей) + bash-скрипт как fallback (движки jq/python) |
| **Улучшенный Circuit Breaker** | Встроенная эскалация давления L0-L4: от «сдаться после 3 раундов» к «6-7 раундов прогрессивного самоспасения» |
| **Отслеживание состояния** | Единый state.json для circuit breaker + давление + стратегия + сессия |
| **Graceful Handoff** | На L4 генерируется структурированный отчёт о передаче вместо сырого краша |
| **Независимость** | Использует директорию `.ralph-boost/`, не зависит от ralph-claude-code |

```text
/ralph-boost setup        # Инициализировать проект
/ralph-boost run          # Запустить автономный цикл
/ralph-boost status       # Проверить текущее состояние
/ralph-boost clean        # Очистить
```

> Вдохновлено [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), переосмыслено как skill с нулевыми зависимостями и гарантией сходимости.

## Skill Lint — Валидатор skill-плагинов

Проверь свои Claude Code плагины одной командой.

Проверяет структурную целостность и семантическое качество skill-файлов в любом проекте Claude Code плагина. Bash-скрипты выполняют структурные проверки, AI — семантические. Взаимодополняющее покрытие.

| Тип проверки | Описание |
|-------------|----------|
| **Структурная** | Обязательные поля frontmatter / существование файлов / ссылки references / записи в marketplace |
| **Семантическая** | Качество описаний / консистентность имён / маршрутизация команд / покрытие eval |

```text
/skill-lint              # Показать справку
/skill-lint .            # Проверить текущий проект
/skill-lint /path/to/plugin  # Проверить конкретный путь
```

## News Fetch — Ментальная перезагрузка между спринтами

Устал от дебага? `/news-fetch` — твои 2 минуты на перезагрузку.

Остальные три skill'а заставляют тебя работать усерднее. Этот напоминает перевести дух. Получи свежие новости по любой теме прямо в терминале — без переключения контекста, без кроличьих нор в браузере. Быстрый просмотр — и обратно к работе, с новыми силами.

| Возможность | Описание |
|------------|----------|
| **3-уровневый Fallback** | L1 WebSearch → L2 WebFetch (региональные источники) → L3 curl |
| **Дедупликация и слияние** | Одно событие из нескольких источников автоматически объединяется, остаётся с наивысшим рейтингом |
| **Оценка релевантности** | AI оценивает и сортирует по соответствию теме |
| **Автосаммари** | Отсутствующие аннотации генерируются автоматически из текста статьи |

```text
/news-fetch AI                    # Новости AI за неделю
/news-fetch AI today              # Новости AI за сегодня
/news-fetch robotics month        # Новости робототехники за месяц
/news-fetch climate 2026-03-01~2026-03-31  # Произвольный диапазон дат
```

## Качество

- 10+ сценариев оценки для каждого skill'а с автоматизированными тестами
- Самопроверка собственным skill-lint
- Ноль внешних зависимостей — ноль рисков
- Лицензия MIT, полностью открытый код

## Структура проекта

```text
jskills/
├── skills/                        # Платформа Claude Code
│   └── <skill>/
│       ├── SKILL.md               # Определение skill'а
│       ├── references/            # Детальный контент (загружается по запросу)
│       ├── scripts/               # Вспомогательные скрипты
│       └── agents/                # Определения sub-agent'ов
├── platforms/                     # Адаптации для других платформ
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Адаптация для OpenClaw
│           ├── references/        # Контент для платформы
│           └── scripts/           # Скрипты для платформы
├── .claude-plugin/                # Метаданные для Claude Code marketplace
├── hooks/                         # Hooks платформы Claude Code
├── evals/                         # Кроссплатформенные сценарии оценки
├── docs/
│   ├── guide/                     # Руководства пользователя (English)
│   ├── plans/                     # Проектная документация
│   └── i18n/                      # Переводы
│       ├── README.*.md            # Переведённые README
│       └── guide/{zh-CN,ja,ko}/   # Переведённые руководства
└── plugin.json                    # Метаданные коллекции
```

## Участие в разработке

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — адаптация для OpenClaw + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — сценарии оценки
4. `.claude-plugin/marketplace.json` — добавить запись в массив `plugins`
5. Hooks при необходимости в `hooks/hooks.json`

Подробности в [CLAUDE.md](../../CLAUDE.md).

## Лицензия

[MIT](../../LICENSE) - [juserch](https://github.com/juserch)
