# J Skills 开发指南

## 项目概述

Claude Code skill 集合项目。每个 skill 是独立的自包含 plugin 单元，通过 SKILL.md 注入 AI 上下文。

## 目录约定

```text
skills/<skill>/
├── plugin.json                    # skill 级元数据（name 用于 plugin 列表显示）
├── SKILL.md                       # skill 核心定义（精简）
├── references/*.md                # 按需加载的详细内容
├── scripts/*.sh                   # 辅助脚本（按需）
├── hooks/hooks.json + *.sh        # Hook 配置和脚本（按需）
└── agents/*.md                    # Sub-agent 定义（按需）

evals/<skill>/scenarios.md         # 评估场景
evals/<skill>/run-trigger-test.sh  # 自动化触发测试
docs/guide/<skill>.md              # 使用手册
docs/plans/<topic>-design.md       # 设计文档
```

## 文件职责

- `plugin.json`（根）— 集合级元数据（name=juserch-skills）
- `.claude-plugin/plugin.json` — 发布用元数据（与根级保持一致）
- `.claude-plugin/marketplace.json` — Marketplace 入口，`plugins` 数组列出所有 skill，``skills` 数组列出各 skill 路径
- `skills/<name>/plugin.json` — skill 级元数据，`name` 字段决定 plugin 列表中的显示名
- `skills/<name>/commands/` — 该 skill 的 slash command 入口
- `skills/<name>/hooks/` — 该 skill 的生命周期 hook（如有）
- `skills/<name>/agents/` — 该 skill 的 sub-agent 定义（如有）
- `~/.juserch-skills/` — 运行时状态目录（失败计数、压力等级、会话恢复）

## 新增 Skill 流程

1. `skills/<name>/plugin.json` — skill 级元数据（name/version/description）
2. `skills/<name>/SKILL.md` — 核心行为定义，frontmatter 含 name/description/license
3. `skills/<name>/references/*.md` — 详细内容（检查清单、方法论等），SKILL.md 中引用
4. `commands 已废弃，skill 通过 SKILL.md frontmatter` — slash command 入口，加载对应 skill
5. `evals/<name>/scenarios.md` — 至少 5 个评估场景
6. `evals/<name>/run-trigger-test.sh` — 可执行的触发测试脚本
7. `.claude-plugin/marketplace.json` — 在 `plugins` 数组追加条目，`source` 指向 `./skills/<name>/`
8. `README.md` — 在 Skills 章节追加介绍
9. 如需自动触发，在 `skills/<name>/hooks/hooks.json` 添加 hook 配置

## 开发规范

- 根 `plugin.json` 变更时同步 `.claude-plugin/plugin.json`
- 每个 skill 是自包含 plugin 单元：自带 plugin.json、commands/，hooks 和 agents 按需
- SKILL.md 保持精简，详细内容放 `references/` 按需加载，减少 token 消耗
- frontmatter 支持字段：name, description, license, argument-hint, user-invokable, metadata
- 每个 skill 保持零依赖，可独立使用
- skill 之间不应有硬依赖，可有可选组合关系
- Spawn sub-agent 时必须注入行为约束（使用 skill 目录下 agents/ 的定义）

## 状态持久化

运行时状态存储在 `~/.juserch-skills/`：
- `block-break-state.json` — 失败计数、压力等级、最后更新时间
- 由 `hooks/failure-detector.sh` 写入
- 由 `hooks/session-restore.sh` 读取
- PreCompact hook 通过 prompt 指示 agent 保存上下文状态
- 状态在 2 小时内有效，超过则不恢复

## 测试

- 场景测试：`evals/<skill>/scenarios.md`
- 自动化触发测试：`bash evals/<skill>/run-trigger-test.sh`
