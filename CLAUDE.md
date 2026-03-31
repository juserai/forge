# J Skills 开发指南

## 项目概述

Claude Code skill 集合项目。每个 skill 是独立的行为约束/方法论模块，通过 SKILL.md 注入 AI 上下文。

## 目录约定

```text
commands/<skill>.md                # /command 入口
skills/<skill>/SKILL.md            # skill 核心定义（精简）
skills/<skill>/references/*.md     # 按需加载的详细内容
evals/<skill>/scenarios.md         # 评估场景
evals/<skill>/run-trigger-test.sh  # 自动化触发测试
hooks/hooks.json                   # Hook 配置
hooks/*.sh                         # Hook 脚本
agents/*.md                        # Sub-agent 定义
```

## 文件职责

- `plugin.json` — 项目级元数据（权威源，name=jskills）
- `.claude-plugin/plugin.json` — 发布用元数据（与根级保持一致）
- `.claude-plugin/marketplace.json` — Marketplace 入口，`plugins` 数组列出所有 skill
- `hooks/hooks.json` — 生命周期 hook 配置（UserPromptSubmit/PostToolUse/PreCompact/SessionStart）
- `agents/*.md` — Sub-agent 行为约束定义，确保子 agent 不裸奔
- `~/.jskills/` — 运行时状态目录（失败计数、压力等级、会话恢复）

## 新增 Skill 流程

1. `skills/<name>/SKILL.md` — 核心行为定义，frontmatter 含 name/description/license
2. `skills/<name>/references/*.md` — 详细内容（检查清单、方法论等），SKILL.md 中引用
3. `commands/<name>.md` — slash command 入口，加载对应 skill
4. `evals/<name>/scenarios.md` — 至少 5 个评估场景
5. `evals/<name>/run-trigger-test.sh` — 可执行的触发测试脚本
6. `.claude-plugin/marketplace.json` — 在 `plugins` 数组追加条目
7. `README.md` — 在 Skills 章节追加介绍
8. 如需自动触发，在 `hooks/hooks.json` 添加对应 matcher

## 开发规范

- `plugin.json` 变更时同步 `.claude-plugin/plugin.json`
- SKILL.md 保持精简，详细内容放 `references/` 按需加载，减少 token 消耗
- frontmatter 支持字段：name, description, license, argument-hint, user-invokable, metadata
- 每个 skill 保持零依赖，可独立使用
- skill 之间不应有硬依赖，可有可选组合关系
- Spawn sub-agent 时必须注入行为约束（使用 agents/ 下的定义）

## 状态持久化

运行时状态存储在 `~/.jskills/`：
- `block-break-state.json` — 失败计数、压力等级、最后更新时间
- 由 `hooks/failure-detector.sh` 写入，`hooks/session-restore.sh` 读取
- PreCompact hook 通过 prompt 指示 agent 保存上下文状态
- 状态在 2 小时内有效，超过则不恢复

## 命令路由器（规划中）

当 skill 数量 >= 2 时，添加 `/jskills` 统一路由器命令：
- `/jskills` — 列出可用 skill
- `/jskills block-break` — 等价于 `/block-break`
- `/jskills <name> [args]` — 路由到对应 skill

参考 pua 的 `commands/pua.md` 路由器模式实现。

## 测试

- 场景测试：`evals/<skill>/scenarios.md`
- 自动化触发测试：`bash evals/<skill>/run-trigger-test.sh`
