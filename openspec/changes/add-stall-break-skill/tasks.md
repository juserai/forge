# Tasks — add-stall-break-skill

> 前置（MUST 先跑）：`grep -rn "stall-break" . --include="*.md" --include="*.json" --include="*.sh" --exclude-dir=.git`（确认无碰撞）。
> 分类 = **hammer**；版本 `0.1.0`。skill-lifecycle 场景 A 全工件。

## Phase 1 — Skill 本体（canonical）

- [ ] T1.1 `skills/stall-break/SKILL.md`（frontmatter: `name: stall-break` / `description` / `license` / `metadata.category: hammer` / `metadata.permissions` + `## Help` 段含版本字面量 `0.1.0`）
  - 验证：`grep -E "^name: stall-break" skills/stall-break/SKILL.md && grep -E "category: hammer" skills/stall-break/SKILL.md`
- [ ] T1.2 `skills/stall-break/hooks/hooks.json`（**Stop** 类型·见 design.md §1）+ `skills/stall-break/hooks/stall-break-trigger.sh`（chmod +x·loop-guard via `stop_hook_active`）
  - 验证：`grep -E '"Stop"' skills/stall-break/hooks/hooks.json && bash -n skills/stall-break/hooks/stall-break-trigger.sh`
  - 验证 loop-guard：喂 `{"stop_hook_active":true}` → exit 0；喂 `{}` → 输出 `<STALL_BREAK_ACTIVATED>` + decision=block
- [ ] T1.3 `skills/stall-break/references/`：`state.md`（`~/.forge/stall-break-state.json` 结构 + 冷却逻辑·见 runtime-state spec）、`trigger-conditions.md`（§2 收敛条件）
  - 验证：`ls skills/stall-break/references/ | wc -l` ≥ 2

## Phase 2 — 平台镜像（openclaw）

- [ ] T2.1 `platforms/openclaw/stall-break/`（SKILL.md + references 结构对等·platform-parity）
- [ ] T2.2 `platforms/openclaw/stall-break/.../openclaw-event-mapping.md`：Stop → openclaw turn-end 等价事件（无等价则记录"降级为纯提醒"·见 proposal Non-goals）
  - 验证：skill-lint platform-parity 防线通过

## Phase 3 — Evals

- [ ] T3.1 `evals/stall-break/scenarios.md`（≥5 场景，MUST 含**假阳**场景：合法停点[刚问用户/ExitPlanMode/破坏性需授权]上**不应**触发）
- [ ] T3.2 `evals/stall-break/run-trigger-test.sh`（可执行·喂构造 Stop 输入断言 block/allow）
  - 验证：`test -x evals/stall-break/run-trigger-test.sh && bash evals/stall-break/run-trigger-test.sh`

## Phase 4 — 文档

- [ ] T4.1 `docs/user-guide/stall-break-guide.md`（EN）+ `docs/i18n/zh-CN/stall-break-guide.md`
- [ ] T4.2 `docs/design/hammer/stall-break-design.md`（含 category-decision 三元组：OUTPUT=行为指令 → hammer）
- [ ] T4.3 `README.md` Hammer 章节加行 + skills badge +1 + 首段 "N skills" +1；`docs/i18n/zh-CN/README.md` 同步

## Phase 5 — Marketplace / 锁步（repo-invariants）

- [ ] T5.1 `.claude-plugin/marketplace.json` 新增 plugin 条目（`source: ./skills/stall-break`·`version: 0.1.0`·`integrity.skill-md-sha256`）
- [ ] T5.2 `bash scripts/recalc-all-hashes.sh` 重算 hash（SKILL.md ↔ marketplace hash 锁步·S* 防线）
- [ ] T5.3 `/CHANGELOG.md` 新增 `## stall-break` 段·top entry `### [0.1.0]`
  - 验证：`bash scripts/<skill-lint> .`（4 防线全绿：hash-integrity / platform-parity / i18n-structure-parity / version-lockstep）

## Phase 6 — 收尾

- [ ] T6.1 全文扫描确认无悬挂引用；skill-lint 全绿；hooks 干跑两路（block / allow）证据贴 PR。
