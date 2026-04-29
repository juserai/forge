# Design

> 影响分类：cross（不归属任何单一 forge 4 分类，影响所有 skill 的元层契约）

## 决策 1 — `openspec/` 在 forge 里装"横向能力契约"，不是"per-skill 契约"

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A. 横向能力 spec**（采纳） | `openspec/specs/<capability>/spec.md` 装 help-mode / skill-lifecycle / runtime-state 等横向规则 | 捕捉当前没归宿的契约（CLAUDE.md 5 节内容），与现有 per-skill 文档不重复 |
| B. per-skill spec | 每个 skill 一份 `openspec/specs/<skill>/spec.md` | **拒绝**：单 skill 契约已经在 SKILL.md frontmatter / docs/design / docs/user-guide 三处表达，第四份是冗余 |
| C. 混合（横向 + per-skill） | 两类 spec 并存 | **拒绝**：增加判断成本，每加一个 skill 都要决定"放哪一档"，违反"单一职责" |

**反例验证**：试着为 block-break 写一份 `openspec/specs/block-break/spec.md`——
能写的所有内容（用途、行为、3 条红线、L0-L4 升级）都已经在
`skills/block-break/SKILL.md` 和 `docs/design/block-break-design.md` 里。
没有任何新信息，只是搬运。结论：B 方案不增量。

## 决策 2 — CLAUDE.md 瘦身到 ≤ 80 行索引

CLAUDE.md 当前 5 节按归属切分：

| CLAUDE.md 现章节 | 新归属 | 理由 |
|-----------------|-------|------|
| 命名与分类 | `specs/category-decision/` | 4 分类判据 + 三元组决策需要 RFC 2119 关键字精确化 |
| Skill 生命周期（场景 A-D） | `specs/skill-lifecycle/` | 4 张审计清单 ~80 行，是 CLAUDE.md 第二大块 |
| Help 模式约定 | `specs/help-mode/` | 已有 evals/_meta/help-parity-test.sh 可作 verification 入口 |
| 运行时约定 | `specs/runtime-state/` | 跨 skill 状态契约，需要显式 schema |
| 开发规范 | `specs/repo-invariants/` | 零依赖等不变量 |

CLAUDE.md 主体只剩：项目一句话 + 仓库布局图 + 5 spec 链接 + 一句"改 skill
必读 § skill-lifecycle 的清单"。

**反例验证**：曾经在 `claim-ground` 分类误判事件中，用户 push 了
"anvil sibling of skill-lint"的描述到 CLAUDE.md 与 11 份 i18n README，导致
后续修复要扫 24 处。如果当时 category-decision spec 已经独立，CLAUDE.md
那处误描述根本不会存在（spec 是 single source of truth）。

## 决策 3 — i18n 收敛到 `docs/i18n/<lang>/<file>` 单轨

### 当前布局

```
docs/i18n/README.<lang>.md            (11 份 README 翻译)
docs/user-guide/i18n/<skill>-guide.<lang>.md   (88 份 guide 翻译，8×11)
```

### 目标布局

```
docs/i18n/<lang>/README.md
docs/i18n/<lang>/<skill>-guide.md
```

### 取舍

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A. 收敛单轨**（采纳） | 每语言一目录，README 与所有 skill guide 共处 | 扫一种语言时连续直观；新增 skill 只动 11 个语言目录，单点扩张 |
| B. 维持双轨写契约 | 在 spec 里写明双轨分工 | **拒绝**：用户决策选了 A；维持双轨意味着每加一种文档类型都要决定挂哪一轨 |

### 反例（迁移代价）

- 99 文件 `git mv`（11 README + 88 guide）
- 11 份 README 顶部语言切换链表的相对路径全改
- 所有 i18n guide 内"返回上级"或"看英文版"的内部锚点
- `.skill-lint.json` 里 `i18n-dir` + `i18n-guide-dir` 合并为 `i18n-dir`
- `skills/skill-lint/scripts/skill-lint.sh` 的 `verify-i18n-structure-parity`
  从扫 `docs/user-guide/i18n/` 改为扫 `docs/i18n/<lang>/`
- `docs/design/<skill>-design.md` 中若有 i18n 路径引用要同步

第二步执行迁移时**强烈建议用一次性脚本** + 单 PR 完成，避免"半迁移"
状态使 skill-lint 同时报旧路径不存在和新路径不完整。

## 决策 4 — `docs/design/` 引入 4 分类子目录

```
docs/design/{hammer,crucible,anvil,quench,cross}/<skill>-design.md
```

文件名不变（`block-break-design.md`），只是路径加一层分类。

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A. 4 分类子目录 + cross/**（采纳） | 横向设计放 cross/ | 与 README 表格、forge 分类隐喻一致；扩到 12+ skill 仍可读 |
| B. 平铺 + 文件名前缀 | 用 `hammer-block-break-design.md` 这样的前缀 | **拒绝**：文件名变长，破坏与 SKILL.md 命名的对称 |
| C. 不动 | 9 文件继续平铺 | **拒绝**：未来扩到 12-15 时只能用 `Cmd+P` 模糊匹配 |

## 决策 5 — `platform-parity` 把隐式行为升级为显式契约

`skills/skill-lint/scripts/skill-lint.sh` 已有 `verify-platform-subdirs`
检查每个 skill 在每个 `platforms/<plat>/` 下都有对应目录。但**没人写过
"必须如此"的 spec**——只有实现，没有契约。

`platform-parity/spec.md` 显式规定：

- 每加一个 skill：必须在所有 `platforms/<plat>/` 下创建对应 `<skill>/`
- 每加一个 platform：必须为现有所有 skill 创建对应 `<plat>/<skill>/`
- skill-lint 的 `verify-platform-subdirs` 是这条契约的 enforcer

**反例验证**：如果未来加 codex / gemini / openai 三个平台，从 1×8 = 8
变成 4×8 = 32 个目录。没显式契约的话，新平台的引入者很可能只补一两个
"先跑起来看看"的 skill，造成参差不齐。

## 不采纳的方案

1. **引入 spec 间继承/版本化**：openspec 原生支持，但 forge 当前规模
   （7 份 spec）用不上；过早引入会增加心智负担。
2. **把 marketplace integrity 单独 spec 化**：合并到 `repo-invariants` 即可，
   不值得单立。
3. **为 hooks 单独 spec**：当前只有 block-break / claim-ground 两家有 hook，
   规则简单（hook 跟 skill 走，住在 `skills/<name>/hooks/`），写在
   `repo-invariants` 一段已足够；将来 hook 复杂度上升再独立。
