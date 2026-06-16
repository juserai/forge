# Add `stall-break` skill — proactivity hammer (drive the next lever, don't stop reactively)

> 这次 change 解决的张力：forge 的两把 hammer 都是**反应式触发**——block-break 等用户挫败、claim-ground 等用户质疑。**没有任何 hammer 守"主动性"**：agent 做完一个单元后默认「报告 + 等指令」，而不是主动审视负责域、识别下一最高杠杆、驱动它。这个"反应式停"是 ownership-role agent 最常见的失效，且**现有 hook 全都抓不到**——它发生在 turn-end，而 forge 现有 hook 只挂 UserPromptSubmit / PostToolUse。

## Why

三类已观察到的缺口：

1. **主动性无 hook 守**：block-break/claim-ground 都要等一个**用户负面信号**才触发。但"做完任务就停下等"不产生任何用户信号——它静默发生，没有触发器，于是无人纠。一个真实案例：某 ownership-role agent 即使 always-on 工作准则里明写"工作主动性原则"，仍每个任务做完就停；证明**加载文档是 nudge 不是 enforcement**。
2. **失效发生在 turn-end，现有 hook 类型覆盖不到**：proactivity 不是在用户 prompt 时失效（那时还没开始），而是在 agent **准备结束这一轮**时失效。forge 现有 hook 全是 UserPromptSubmit / PostToolUse / PreCompact / SessionStart——**无 Stop 类型**。结构性补位 = 一个 Stop hook，在 agent 收尾时注入主动性自检。
3. **"软"准则与"硬"门之间缺一层**：把准则写进 always-on 文档是软 nudge；唯一能"硬"到机械触发的是 hook。stall-break 把"主动性"从一句口号变成 turn-end 的可触发自检。

根因同一：**主动性是唯一既缺 hook 触发器、又缺 hook 类型（Stop）支持的行为维度。**

## What Changes

**新增 skill**（forge skill-lifecycle 场景 A 全套工件，详见 tasks.md）：

- `skills/stall-break/{SKILL.md, hooks/{stall-break-trigger.sh, hooks.json}, references/*}`
- `platforms/openclaw/stall-break/`（结构对等克隆 + openclaw event mapping：Stop → 对应事件）
- `evals/stall-break/{scenarios.md (≥5), run-trigger-test.sh}`
- `docs/user-guide/stall-break-guide.md` + `docs/i18n/zh-CN/stall-break-guide.md`
- `docs/design/hammer/stall-break-design.md`
- `.claude-plugin/marketplace.json` 新增 plugin 条目（`version: "0.1.0"` + 重算 hash）+ README/CHANGELOG/badge 同步

**核心架构**：

- 4 分类 = **hammer**（OUTPUT 是行为指令；兄弟 = block-break / claim-ground）。
- forge **首个 Stop 类型 hook**：agent 收尾时触发，注入 `<STALL_BREAK_ACTIVATED>` 主动性自检——审视负责域 → 识别下一最高杠杆 → 驱动它 / 出带理由单一推荐 / 需授权先报 → **只在真决策点/卡点/需授权/单元全清处才停**。
- **防无限循环**：读 stdin 的 `stop_hook_active`——已注入过本轮则放行（exit 0），否则 block 一次。state 在 `~/.forge/stall-break-state.json`（冷却/计数）。
- 设计细节（触发条件调参、与 block-break 的边界、openclaw 事件映射）见 design.md。

## Non-goals

- **不替代 block-break**：block-break 治"卡住/被挫败"（reactive·stuck）；stall-break 治"没卡住却被动停"（proactive gap）。二者并存、触发条件互斥。
- **不每轮硬 block**：loop-guard + 触发条件调参（如刚问过用户/刚交付决策点则不触发），避免噪音。
- **不自动驱动破坏性/需授权动作**：push / 删除 / 装工具等仍按"先报先授权"停——stall-break 推的是"驱动下一杠杆"，不是"绕过授权门"。
- **不做新 hook 类型的平台兼容兜底**：仅 Claude Code（Stop hook 原生）+ openclaw（事件映射）；其它平台若无 Stop 等价事件，本 skill 在该平台降级为纯 SKILL.md 提醒（无 hook）。
