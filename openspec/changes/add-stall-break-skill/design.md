# Design — stall-break

## 1. 触发机制：Stop hook（forge 首例）

Proactivity 在 **turn-end** 失效，所以触发点必须是 agent 收尾时。Claude Code 原生支持 `Stop` hook：agent 准备结束响应时触发，hook 可输出 `{"decision":"block","reason":"..."}` 强制 agent 继续（reason 注入其上下文），或 exit 0 放行。

### hooks.json（草案）

```json
{
  "description": "Stall Break: turn-end proactivity self-check — drive the next lever instead of stopping reactively",
  "hooks": {
    "Stop": [
      { "matcher": "*", "hooks": [
        { "type": "command", "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/stall-break-trigger.sh", "timeout": 5 }
      ] }
    ]
  }
}
```

### stall-break-trigger.sh（草案 · 含 loop-guard）

```bash
#!/usr/bin/env bash
# Stall Break Stop hook — inject a proactivity self-check before a reactive stop.
# Loop-guard: Claude Code sets stop_hook_active=true once a Stop hook already fired this
# turn-cluster; if so we MUST allow the stop (exit 0) or we'd loop forever.
input=$(cat)
if echo "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi
state=~/.forge/stall-break-state.json
# Cooldown: don't re-nudge within N seconds (tunable) — avoids firing on rapid genuine stops.
# (state read/update elided in draft; see references/state.md)
cat 1>&2 << 'EOF'
<STALL_BREAK_ACTIVATED>
[Stall Break ⚙ — turn-end proactivity self-check / 收尾主动性自检]

You are about to STOP. Before you do, run the proactivity loop — do NOT default to
"report + wait":
  ① 审视 your ownership-scope progress + gaps (roadmap / todo / readiness gate).
  ② Identify the next highest-leverage work in scope.
  ③ DRIVE it — do it & verify / give a single reasoned recommendation for a decision /
     report-first for an authorization-gated action (push, destructive, install).
  ④ Stop ONLY at: a genuine decision point · a blocker · an authorization-needed action ·
     ownership units all-clear. Even then, end with "next I suggest X", not an open
     "what do you want?".

Test: done→report→wait = reactive (STOP is wrong here). done→review→drive-next = proactive.
If this IS a genuine stop point, state in one line WHY (which of the four ④ conditions)
and proceed.
EOF
echo '{"decision":"block","reason":"Stall Break: run the turn-end proactivity loop above before stopping; confirm a genuine ④ stop condition or drive the next lever."}'
```

设计点：单次 block（loop-guard 保证最多注入一次/轮），所以最坏成本是 agent **多想一步**——要么驱动下一杠杆，要么用一句话确认这是真停点。不是每轮卡死。

## 2. 触发条件调参（降噪 · 开放问题）

每个 turn-end 都 block 一次会吵。候选收敛条件（实现期定，evals 验证假阳率）：
- **跳过**：上一条 assistant 消息以问句结尾（刚问用户=合法等待）/ 含 ExitPlanMode / 刚触发 block-break 或 claim-ground（已在纠偏中）。
- **冷却**：`~/.forge/stall-break-state.json` 记 last_fired，N 秒内不复触发。
- **会话级开关**：用户可 `/stall-break off` 临时静音（如纯对话轮）。

## 3. 与 block-break / claim-ground 的边界

| skill | 触发 | 失效态 | 类型 |
|---|---|---|---|
| block-break | UserPromptSubmit（挫败词） | 卡住/被挫败仍原地打转 | reactive |
| claim-ground | UserPromptSubmit（质疑词） | 被质疑仍重申不重验 | reactive |
| **stall-break** | **Stop** | **没卡住却被动停、不驱动下一杠杆** | **proactive** |

三者触发互斥（前两者要用户负面信号，stall-break 在无信号的 turn-end）。stall-break 明确**不**在 block-break/claim-ground 刚触发的同轮再触发（避免叠加噪音）。

## 4. openclaw 平台映射

Claude Code 有原生 `Stop`；openclaw 需把"agent 收尾"映射到其事件模型（参考 claim-ground 的 `platforms/openclaw/.../openclaw-event-mapping.md` 范式）。若 openclaw 无 turn-end 等价事件，stall-break 在 openclaw 降级为纯 SKILL.md 行为提醒（无 hook 强制），与 Non-goals 一致。

## 5. 风险 / 反例

- **R1（噪音/疲劳）**：每轮自检会让人/agent 疲劳。缓解=§2 收敛条件 + loop-guard + 会话开关；evals 必须量假阳率（在"合法停点"上不应触发）。
- **R2（与授权门冲突）**：stall-break 推"驱动"，但破坏性/push/装工具必须停下先授权。design 已在注入文案 ③ 显式排除——"驱动"不等于"绕过授权"。
- **Counterexample 自检**："加了 hook 就主动了"——证伪：hook 只能让 agent 在 turn-end **多想一步**，仍可能形式化走过场。真正起效要靠注入文案足够具体（给出④判据）+ evals 守住假阳率。hook 是把 nudge 升级成"每轮强制自检"，不是保证质量。
