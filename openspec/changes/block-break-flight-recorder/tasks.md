# Tasks — Block Break Flight Recorder

> 每个任务 ≤2h。验证命令均可执行。基线分支 = `block-break-flight-recorder`（off main）。

## T1 — State schema 登记 `active_task`（无依赖）
- 改 `skills/block-break/references/state-schema.md`：加 `active_task` 子对象（`title/steps[]/current_step/total_steps/next_step/updated_at`）+ 生命周期（开工写 / 逐步更 / 完成清 / `/block-break clean` 清）。
- **验证**：`grep -q 'active_task' skills/block-break/references/state-schema.md && echo OK`

## T2 — `session-restore.sh` 增恢复注入（依赖 T1）
- 在现有 pressure 恢复块之后，加 design.md「恢复注入参考实现」：新鲜(≤7200s)∧未完成(`current_step<total_steps`) → 输出 `<BLOCK_BREAK_RESUME>`。沿用现有 `json_get`/`AGE`。
- **验证**（fixture 三态）：
  ```bash
  mkdir -p ~/.forge
  # a) 新鲜+未完成 → 必含 RESUME
  printf '{"last_updated":"%s","active_task":{"title":"T","current_step":1,"total_steps":3,"next_step":"X"}}' "$(date -Iseconds)" > ~/.forge/block-break-state.json
  bash skills/block-break/hooks/session-restore.sh | grep -q BLOCK_BREAK_RESUME && echo "a OK"
  # b) 已完成 → 不含
  printf '{"last_updated":"%s","active_task":{"title":"T","current_step":3,"total_steps":3}}' "$(date -Iseconds)" > ~/.forge/block-break-state.json
  bash skills/block-break/hooks/session-restore.sh | grep -q BLOCK_BREAK_RESUME && echo "b FAIL" || echo "b OK"
  # c) 陈旧(>2h) → 不含
  printf '{"last_updated":"2000-01-01T00:00:00","active_task":{"title":"T","current_step":1,"total_steps":3}}' > ~/.forge/block-break-state.json
  bash skills/block-break/hooks/session-restore.sh | grep -q BLOCK_BREAK_RESUME && echo "c FAIL" || echo "c OK"
  ```

## T3 — UserPromptSubmit resume 触发（依赖 T1·与 T2 并行可）
- 新增 `skills/block-break/hooks/resume-trigger.sh`（逻辑同 T2 注入，门控加"短续跑信号"由 matcher 已保证）。
- 改 `hooks.json` UserPromptSubmit 加一条 matcher：`继续|接着|go on|continue|why didn.t you continue|没续|怎么停了|接着干|\?` → `resume-trigger.sh`（与现有 frustration matcher 并列，互不吞）。
- **验证**：`python3 -c "import json;json.load(open('skills/block-break/hooks/hooks.json'))" && echo "json OK"` + 手测 resume-trigger.sh 同 T2 三态。

## T4 — SKILL.md Flight Recorder 协议段（依赖 T1）
- `skills/block-break/SKILL.md` 加「Flight Recorder」节：多步任务开工即写 `active_task`、逐步更新 `current_step`/`next_step`、完成清空；附「中断后：下个续跑信号到达自动接上，不等用户重述」。
- 复算版本：`.claude-plugin/marketplace.json` block-break `version` bump（patch→minor，S29/S30/S31 锁步）+ help-card 第一行 `v<X.Y.Z>` + `CHANGELOG.md` top entry。
- **验证**：`bash skills/skill-lint/scripts/skill-lint.sh .`（S30 help-card 版本 / S31 CHANGELOG 同步必过）

## T5 — OpenClaw 平台镜像（依赖 T2/T3/T4）
- `platforms/openclaw/block-break/` 同步 SKILL.md 协议段 + hook 等价（按 `platform-parity` spec；openclaw hook 映射见 block-break SKILL.md §平台 hook 等价位置——若无等价事件则记入"自我监控模式"表，move-not-delete）。
- **验证**：`bash skills/skill-lint/scripts/skill-lint.sh .` + `diff <(结构清单 canonical) <(结构清单 openclaw)` 对等。

## T6 — evals + 收尾自检（依赖全部）
- `evals/block-break/` 加中断恢复场景（new+unfinished state → 期望 RESUME 注入；completed/stale → 期望静默）+ 触发测试脚本。
- **收尾三命令**（forge CLAUDE.md MUST）：
  ```bash
  bash skills/skill-lint/scripts/skill-lint.sh .
  grep -rn "active_task\|flight.recorder\|BLOCK_BREAK_RESUME" . --include="*.md" --include="*.json" --include="*.sh"  # 漏网扫描
  bash scripts/recalc-all-hashes.sh
  ```
