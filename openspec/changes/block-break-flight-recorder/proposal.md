# Block Break Flight Recorder — 中断后自动恢复在飞任务

> 这次 change 解决的张力（来自 Context「hammer = 行为指令」+ block-break「闭环意识」红线）：block-break **已捕获** `active_task`（`hooks.json` PreCompact dump），但 **从不在恢复侧重注它**——`session-restore.sh` 只还原 `failure_count`/`pressure_level`。结果：一次中断（流超时 / turn 被截断 / compaction）后，agent 丢失"我正在做什么、做到哪一步"，**用户必须手动重述任务才能续上**。捕获与恢复半边对不齐，闭环红线在中断面失守。

## Why

真实事故（2026-06-16·一个多步治理任务执行中）：

1. **流超时截断**：`API Error: Stream idle timeout - partial response received` 杀掉一个执行到一半的 turn。无任何机制记录"做到哪"。
2. **turn 静默截断**：另一 turn 在「先 Read worktree」处结束、未完成编辑。下一 turn 不知前一 turn 的意图。
3. **每次都靠用户重新驱动**：用户连发 `？` / `继续` / `问题又出来了，中断了不能自动恢复执行吗` 才让 agent 接上——**用户被迫当"恢复触发器"**，正是 block-break「owner 意识 / 别让用户当探测器」要消除的反模式。

根因单一：**block-break 的状态持久化是"半条链"**——PreCompact 写 `active_task`（`skills/block-break/hooks/hooks.json` PreCompact 段），但 `session-restore.sh` 只读 `failure_count`+`pressure_level`，`active_task` 写了等于没写。且捕获只在 compaction 触发，**中断/截断不触发任何捕获**。

## What Changes

扩展 **block-break**（不新建 skill——`repo-invariants` 限定仅 block-break/claim-ground 拥有 hook，而本能力必须靠 hook；且"中断不弃活"= closure 红线，主题同源）：

- `skills/block-break/hooks/session-restore.sh`：`active_task` 新鲜且未完成 → 注入 `<BLOCK_BREAK_RESUME>`，指令 agent **自动从记录步骤续跑、不等用户重述**。
- `skills/block-break/hooks/hooks.json`：UserPromptSubmit 增 resume 匹配（`继续/接着/go on/why didn't you continue/?` 等短续跑信号）→ 有开放 `active_task` 时注入恢复上下文。
- `skills/block-break/SKILL.md`：新增 **Flight Recorder 协议**——多步任务开工即写 `active_task`+步骤清单到 state、逐步更新、完成即清。
- `skills/block-break/references/state-schema.md`：登记 `active_task` 子 schema（`title`/`steps[]`/`current_step`/`updated_at`）+ 生命周期（写/更/清）。
- `platforms/openclaw/block-break/`：结构对等镜像（`platform-parity`）。
- `evals/block-break/`：加中断恢复触发场景。

## Non-goals

- **不做无事件的"零接触"自发恢复**：hook 只在事件（SessionStart / UserPromptSubmit）上触发；没有"turn 被中断"事件可挂。本 change 实现的是**下一个续跑信号到达即自动接上（含 full 任务上下文）**，而非凭空自启。真无人值守续跑属 `ralph-boost` / 运行时 `/loop` 范畴，不在此。
- **不跨 skill 共享状态**：仍只用 `~/.forge/block-break-state.json`（`runtime-state` spec）。
- **不改压力升级 / 三红线语义**：仅补恢复链，不动既有行为约束。
