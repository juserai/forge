# Design — Block Break Flight Recorder

**影响分类**：`hammer`（行为指令：注入"自动续跑"约束）+ `cross`（动 hooks + state schema + SKILL.md + 平台镜像）。

## 事故台账（动机证据·2026-06-16）

| # | 中断形态 | 现有行为 | 缺口 |
|---|---|---|---|
| 1 | `API Error: Stream idle timeout - partial response received` | turn 死，无捕获 | 中断不触发任何 state 写入 |
| 2 | turn 在「先 Read worktree」处静默截断 | 下一 turn 无前序意图 | `active_task` 未在恢复侧重注 |
| 3 | 用户连发 `？`/`继续`/`中断了不能自动恢复吗` | agent 等用户重述才续 | 无 UserPromptSubmit resume 触发 → 用户当恢复触发器 |

三者同根：**捕获/恢复链断半边**（见下证据）。

## 现状证据（file:line·非泛指）

- `skills/block-break/hooks/hooks.json` → `PreCompact` 段已 dump `active_task`/`tried_approaches`/`excluded`/`next_hypothesis` 到 `~/.forge/block-break-state.json`。**捕获侧已存在，但只在 compaction 触发**。
- `skills/block-break/hooks/session-restore.sh` → 仅 `json_get '.failure_count'` + `'.pressure_level'`，注入 `<BLOCK_BREAK_STATE_RESTORED>` **只含压力等级**；`active_task` 读都没读 → **恢复侧丢弃了已捕获的任务**。
- `openspec/specs/runtime-state/spec.md` → schema 必须落 `skills/block-break/references/state-schema.md`；状态根 `~/.forge/`，跨 skill 不共享。

## 关键决策（选了什么 / 为什么不是其他 / 反例验证）

### D1 — 扩展 block-break，不新建 skill
- **选**：把 Flight Recorder 作为 block-break 子能力。
- **为什么不新建 `resume`/`flight-recorder` skill**：`openspec/specs/repo-invariants/spec.md` + `runtime-state/spec.md` 明定「仅 block-break 与 claim-ground 拥有专属 hook」。本能力**必须**靠 SessionStart + UserPromptSubmit hook，新 skill 无 hook 权 → 结构上不可行。且 block-break「闭环意识红线（声称完成前先验证）」与「owner 意识（别让用户当探测器）」正是"中断不弃活"的母题。
- **反例验证**：若强行新建带 hook 的 skill → 违反 repo-invariant、skill-lint 拦；若做成无 hook 的纯 SKILL.md skill → 无法在中断后自动触发，退化为"用户得手动 /resume"，没解决问题。

### D2 — 恢复触发点 = SessionStart + UserPromptSubmit，不追求自发恢复
- **选**：两个真实存在的事件挂钩。SessionStart（compact/startup/resume·复用现有 matcher）+ UserPromptSubmit（续跑信号词）。
- **为什么不做"中断即自动续"**：Claude Code 无"turn interrupted"事件（已核 `code.claude.com/docs/en/hooks.md` 事件集：UserPromptSubmit/PreToolUse/PostToolUse/SessionStart/PreCompact/Stop…无 interrupt 事件）。流超时杀 turn 后下一个触发点必是 SessionStart 或用户输入。
- **反例验证**：声称"零接触自发恢复"= 过度承诺，无事件可挂 → 必假。诚实边界写进 proposal Non-goals。`ralph-boost`/`/loop` 才是无人值守续跑的正确层。

### D3 — 捕获时机：开工即写 + PreCompact 兜底，不靠 hook 推断语义
- **选**：SKILL.md 行为协议——多步任务开工，agent 写 `active_task={title,steps[],current_step}`，逐步更新，完成清空。PreCompact 段继续兜底。
- **为什么不靠 PostToolUse hook 自动推断"在飞任务"**：hook 看得到 Bash 命令/退出码，看不到"任务语义边界"（哪几步算一个任务）。靠推断会误判（单条 ls 也像任务）。agent 自报语义最准，且 block-break 本就是行为约束 skill，加一条协议是同构。
- **反例验证**：纯 hook 推断 → 把"完成的任务"误判为"在飞"，恢复时注入已完成任务 → 噪音 + 误导。故语义由 agent 写、hook 只做新鲜度/完成度门控。

### D4 — 新鲜度 + 完成度双门控，防陈旧/已完成误触发
- **选**：复用 `session-restore.sh` 现有 2h 新鲜窗口；增 `active_task.current_step < len(steps)` 完成度判定；注入仅当"新鲜 ∧ 未完成"。
- **反例验证**：只看新鲜度 → 已完成任务（current_step==末）仍被重注，agent 重复已完成工作。双门控避免。清理路径：任务完成 / `/block-break clean` 清 `active_task`。

## 恢复注入参考实现（session-restore.sh 增量·feasibility 证据）

```bash
# 续在现有 pressure 恢复之后；沿用本文件已有的 json_get + 新鲜度(AGE<=7200) 机制
TASK_TITLE=$(json_get '.active_task.title' '')
CUR=$(json_get '.active_task.current_step' '0'); TOT=$(json_get '.active_task.total_steps' '0')
if [ -n "$TASK_TITLE" ] && [ "${CUR:-0}" -lt "${TOT:-0}" ]; then
  cat << EOF

<BLOCK_BREAK_RESUME>
[Flight Recorder] 上个 turn 被中断时你正在执行未完成任务：
  任务：$TASK_TITLE
  进度：步骤 $CUR/$TOT，下一步 = $(json_get '.active_task.next_step' '见 state')
立即从下一步自动续跑，**不要等用户重述**；续前先核 git/工作树状态确认未丢失。
EOF
fi
```

UserPromptSubmit resume 触发（`hooks.json` 增 matcher·指向小脚本 `resume-trigger.sh`，逻辑同上但门控加"用户消息为短续跑信号"）。

## State schema 增量（references/state-schema.md）

```json
"active_task": {
  "title": "string — 一句话任务意图",
  "steps": ["string", "..."],
  "current_step": 0,
  "total_steps": 0,
  "next_step": "string",
  "updated_at": "ISO-8601"
}
```
向前兼容：`session-restore.sh` 解析容忍字段缺失（`active_task` 不存在 → 跳过，旧 state 不报错）。

## Verification
- `bash skills/skill-lint/scripts/skill-lint.sh .` 全绿（含 S29/S30/S31 版本治理）。
- 注入 fixture state（new+unfinished）跑 `session-restore.sh` → 含 `<BLOCK_BREAK_RESUME>`；completed/stale → 不含。
- `platforms/openclaw/block-break/` 结构对等（`platform-parity`）。
