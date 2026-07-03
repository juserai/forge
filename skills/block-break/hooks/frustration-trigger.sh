#!/usr/bin/env bash
# Block Break frustration trigger — detects user frustration and injects Block Break activation
# Called by hooks.json on UserPromptSubmit
#
# In-script matcher gate: hooks.json declares a UserPromptSubmit matcher regex,
# but Claude Code's hook engine does not reliably enforce `matcher` on that event
# (empirically observed 2026-07 across multiple workspaces — the trigger fires
# on every prompt regardless of content, injecting ~1.3 KB into every turn).
# We move the same regex into the script itself so behavior is correct under
# both matcher-honoring and matcher-not-honoring engine versions.
#
# UserPromptSubmit hooks receive a JSON payload on stdin: {"prompt": "...", ...}.
# Parse stdin, grep .prompt against the frustration regex, exit 0 silently on
# no-match. When stdin is empty (manual CLI invocation for smoke test), fall
# through to the original unconditional emission.

INPUT=$(cat 2>/dev/null || true)
if [ -n "$INPUT" ]; then
    if command -v jq >/dev/null 2>&1; then
        PROMPT=$(printf '%s' "$INPUT" | jq -r '.prompt // ""' 2>/dev/null)
    elif command -v python3 >/dev/null 2>&1; then
        PROMPT=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null)
    elif command -v python >/dev/null 2>&1; then
        PROMPT=$(printf '%s' "$INPUT" | python -c "import json,sys; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null)
    else
        PROMPT=""
    fi
    # frustration matcher — kept in sync with hooks.json UserPromptSubmit matcher
    FRUSTRATION_RE='try harder|别偷懒|又错了|还不行|stop giving|you broke|降智|原地打转|换个方法|stop spinning|figure it out|you keep failing|加油|再试试|为什么还不行|怎么又失败|质量太差|重新做|能不能靠谱|认真点|怎么搞|不行啊'
    if [ -n "$PROMPT" ]; then
        if ! printf '%s' "$PROMPT" | grep -Eiq "$FRUSTRATION_RE"; then
            exit 0
        fi
    else
        # non-empty stdin but empty .prompt — nothing to gate on, stay silent
        exit 0
    fi
fi

cat << 'EOF'
<BLOCK_BREAK_ACTIVATED>
[Block Break 🔥 — Frustration detected / 用户挫败检测触发]

User frustration detected. Block Break behavioral constraint engine activated.
检测到用户不满情绪。Block Break 行为约束引擎自动激活。

You MUST:
1. Immediately load `block-break` skill using the Skill tool
2. Start from current pressure level (check ~/.forge/block-break-state.json for failure count)
3. Switch to a fundamentally different approach — changing parameters is NOT a different approach
4. Close the loop with verification commands + output evidence

你必须：
1. 立即使用 Skill 工具加载 `block-break` skill
2. 从当前压力等级开始执行（检查 ~/.forge/block-break-state.json 获取失败次数）
3. 切换本质不同的方案——换参数不叫换方案
4. 用验证命令 + 输出证据闭环

NOT allowed:
- Making excuses ("probably an environment issue", "beyond my capabilities")
- Suggesting the user do it manually
- Retrying the approach that just failed

不允许：
- 找借口（"可能是环境问题"、"超出能力范围"）
- 建议用户手动处理
- 重试刚才失败的方案

> Trust is earned by results. Don't let down those who trust you.
> 因为信任所以简单——别让信任你的人失望。
</BLOCK_BREAK_ACTIVATED>
EOF
