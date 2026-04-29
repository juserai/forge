# Bootstrap OpenSpec 接入 + 目录结构调整

> 这次 change 解决的张力：openspec/ 目录刚初始化但没用法约定；CLAUDE.md
> 在 8 个 skill 之后开始臃肿；i18n 双轨布局没有显式契约；docs/design/
> 平铺扩张；平台扩张缺一个广播契约。

## Why

forge 仓库到 8 个 skill 后，五个结构性张力同时浮现：

1. **`openspec/` 是空架子**：刚 init，`config.yaml` 是 stub，`changes/`
   `specs/` 都为空，没人知道这个目录在 forge 上下文里要装什么。
2. **CLAUDE.md ~447 行**：单文件混合"路径职责""命名分类""生命周期审计"
   "Help 模式契约""运行时约定"五件事，新规则只能往里塞。
3. **i18n 双轨没契约**：`docs/i18n/README.*.md` 和
   `docs/user-guide/i18n/*-guide.<lang>.md` 是两套布局，没文档说明分工。
4. **`docs/design/` 已 9 文件平铺**：cross-* 前缀已经在勉强区分横向/纵向。
5. **平台扩张广播契约缺失**：skill-lint 的 `verify-platform-subdirs`
   是隐式实现，没有显式 spec 描述"加 skill 必须广播到所有平台"。

本次迭代不是"代码改不改"，而是 **"把 openspec 工作流接入 forge，并以
本次自身作为第一个 RFC 来验证流程"**。

## What Changes

**第一步（本 change 范围）**：仅产出 RFC 文档，零文件移动。

- 改写 `openspec/config.yaml`：项目级 context + proposal/design/tasks/spec
  四类 artifact 的格式约束
- 新增 7 份横向能力 spec（`openspec/specs/<capability>/spec.md`）：
  - `help-mode/` — Help 入口的 L1/L2 解析规则
  - `skill-lifecycle/` — 4 场景审计清单（A 新增 / B 修改 / C 调整分类 / D 删除·重命名）
  - `category-decision/` — 4 分类 OUTPUT 形态判据 + 三元组决策
  - `runtime-state/` — `~/.forge/<skill>-state.json` 约定
  - `repo-invariants/` — 零依赖 / SKILL.md 锁步 marketplace hash 等不变量
  - `i18n-layout/` — 描述目标布局 `docs/i18n/<lang>/<file>` 单轨
  - `platform-parity/` — 平台 × skill 笛卡尔积广播契约
- 写 `tasks.md` 列出第二步落地的全部步骤（CLAUDE.md 拆分 / docs/design
  分类化 / i18n 单轨迁移 / skill-lint 适配）

**第二步（不在本 change 范围）**：执行 `tasks.md`，分独立提交。

## Non-goals

- 不改任何 skill 自身（SKILL.md / references / hooks 全部不动）
- 不动 `platforms/openclaw/` 任何文件
- 不改 `marketplace.json` 任何 hash
- 不动 CLAUDE.md / README.md / 任何 docs/ 现有文件
- 不引入新工具或运行时依赖（依然零依赖）
- 不为单个 skill 写 capability spec（单 skill 契约已由 SKILL.md frontmatter +
  `docs/design/<skill>-design.md` + `docs/user-guide/<skill>-guide.md` 三处覆盖）
