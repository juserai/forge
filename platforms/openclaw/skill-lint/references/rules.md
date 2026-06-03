# Skill Lint 规则详情

规则分两层：Core（S01-S08）始终执行，Extended（S09-S16）需 `.skill-lint.json` 配置驱动。

## Core 结构检查规则（始终执行）

### S01: plugin.json 存在性

- **检查**: 根目录 `plugin.json` 和 `.claude-plugin/plugin.json` 是否都存在
- **级别**: error
- **说明**: 两个 plugin.json 是 Claude Code plugin 的基础元数据，缺失则无法发布

### S02: marketplace.json 存在性

- **检查**: `.claude-plugin/marketplace.json` 是否存在
- **级别**: error
- **说明**: marketplace.json 是 plugin 在 marketplace 中的入口文件

### S03: SKILL.md 存在性

- **检查**: `skills/` 下每个子目录是否包含 `SKILL.md`
- **级别**: error
- **说明**: SKILL.md 是 skill 的核心定义文件，缺失则 skill 无法被加载

### S04: Frontmatter 必填字段

- **检查**: 每个 SKILL.md 的 YAML frontmatter 中必须包含 `name` 和 `description`
- **级别**: error
- **说明**: name 用于 skill 路由，description 用于 marketplace 展示和触发匹配

### S05: Commands 对应（可选，仅在项目使用 commands routing 时检查）

- **检查**: 每个 `skills/<name>/` 是否有对应的 `skills/<name>/commands/<name>.md`
- **级别**: warning
- **说明**: 没有 command 入口的 skill 无法通过 `/name` 直接调用，但可作为被引用 skill。许多项目不使用 commands 目录，此规则跳过
- **脚本实现**: 未实现（AI 语义检查时按需判断）

### S05b: Per-skill plugin.json（可选）

- **检查**: 每个 `skills/<name>/` 是否有自己的 `plugin.json`
- **级别**: warning
- **说明**: 没有 plugin.json 的 skill 在 plugin 列表中会显示集合名而非 skill 名
- **脚本实现**: 未实现（AI 语义检查时按需判断）

### S06: marketplace.json 条目

- **检查**: 每个 skill 是否在 `.claude-plugin/marketplace.json` 的 `plugins` 数组中有对应条目
- **级别**: warning
- **说明**: 未列入 marketplace 的 skill 不会在安装时被发现

### S07: References 引用检查

- **检查**: SKILL.md 中通过 `references/` 路径引用的文件是否实际存在于 `skills/<name>/references/` 目录下
- **级别**: error
- **说明**: 断链引用会导致 AI 尝试读取不存在的文件

### S08: Evals 目录

- **检查**: `evals/<name>/scenarios.md` 是否存在
- **级别**: warning
- **说明**: 没有评估场景的 skill 难以验证质量，但不阻断使用

## Extended 结构检查规则（需 `.skill-lint.json` 配置）

以下规则仅在目标目录下存在 `.skill-lint.json` 且包含对应配置字段时执行。无配置文件的项目不会触发这些检查。

### S09: 命名规范

- **检查**: skill 目录名是否匹配配置中 `naming-pattern` 正则表达式
- **级别**: warning
- **配置**: `"naming-pattern": "^[a-z]+-[a-z]+$"`
- **说明**: 命名规范因项目而异，通过正则自定义

### S10: Category 字段

- **检查**: SKILL.md frontmatter 中 `category` 值是否在配置的 `category-values` 列表中
- **级别**: error
- **配置**: `"category-values": ["hammer", "crucible", "anvil", "quench"]`
- **说明**: category 值由项目自行定义，脚本仅校验值是否在允许列表内

### S11: 触发测试脚本

- **检查**: `evals/<name>/run-trigger-test.sh` 是否存在
- **级别**: warning
- **配置**: `"require-trigger-test": true`
- **说明**: 触发测试用于验证 skill 的注册完整性

### S12: 使用手册

- **检查**: `<user-guide-dir>/<name>-guide.md` (default `docs/user-guide/<name>-guide.md`) 是否存在
- **级别**: warning
- **配置**: `"require-guide": true`
- **说明**: 使用手册是用户了解 skill 的入口

### S13: 设计文档

- **检查**: `<design-dir>/**/<name>-design.md` 是否存在（递归查找）
- **级别**: warning
- **配置**: `"require-design-doc": true`
- **说明**: 设计文档记录 skill 的定位、机制和决策理由。典型布局是 `docs/design/<category>/<name>-design.md`（按 forge 4 分类组织，hammer/crucible/anvil/quench/cross），递归查找避免硬绑路径。

### S14: 平台适配

- **检查**: 配置中 `platforms` 数组指定的每个平台目录下，是否有对应的 `SKILL.md` 和 `references/*.md`
- **级别**: warning
- **配置**: `"platforms": ["openclaw"]`
- **说明**: 支持任意平台名称，不限于 OpenClaw

### S15: i18n README 覆盖

- **检查**: `<i18n-dir>/<lang>/README.md`（按目录扫描发现的每种语言）是否包含该 skill 名称
- **级别**: warning
- **配置**: `"i18n-dir": "docs/i18n"`
- **说明**: 单轨布局——每语言一目录，README 与 skill guide 同处。语言列表从 `<i18n-dir>/` 下的子目录自动推断

### S16: i18n 使用手册覆盖

- **检查**: 对于 `<i18n-dir>/` 下每个语言目录，`<i18n-dir>/<lang>/<name>-guide.md` 是否存在
- **级别**: warning
- **配置**: `"require-i18n-guide": true`（同时需要 `i18n-dir` 配置）
- **说明**: 单轨布局，i18n guide 与 README 同住 `<i18n-dir>/<lang>/`，文件名与英文版对齐（仅目录不同）

### S17: 旧 i18n 路径守卫

- **检查**: `<user-guide-dir>/i18n/` 目录是否存在且包含 .md 文件
- **级别**: error
- **配置**: `"require-i18n-guide": true`（复用 S16 配置）
- **说明**: 单轨迁移完成后 `<user-guide-dir>/i18n/` 应该不存在或为空。任何残留 .md 文件视为迁移未完成或被回退。i18n guide 的正确位置是 `<i18n-dir>/<lang>/<name>-guide.md`

### S26: `docs/design/cross-*` 命名空间保护

- **检查**: `<design-dir>/` 顶层下 `cross-<token>[-design].md` 文件的 `<token>`（去前缀、去 `-design` 后缀）不得与任何 `skills/*/` 目录名重名
- **级别**: error
- **配置**: `"protect-cross-namespace": true`
- **说明**: 横切设计文档放在 `docs/design/cross/` 子目录下（典型路径 `docs/design/cross/cross-kb-archival-design.md`）。本规则保护 `<design-dir>/` 顶层不被 `cross-<skill>-design.md` 污染——若有人把 `docs/design/cross-block-break-design.md` 放在顶层并与 `skills/block-break/` 并存，视为命名冲突。Skill 本身以 `cross-` 开头（例如 `cross-check` 作为合法的 noun-verb kebab-case skill 名）不会被误伤——只检查 `docs/design/` 顶层文件。

### S25: Help 段落要求

- **检查**: `skills/<name>/SKILL.md` 必须：
  1. 含 `## Help` 标题行（独占一行）
  2. 正文提及 `` `help` `` 和 `` `--help` `` 两个 token（加反引号，避免与叙述文本撞车）
- **级别**: 由配置值决定（`"error"` / `"warn"`；`"off"` 或缺省则跳过此规则）
- **配置**: `"require-help-section": "warn"`（灰度阶段）→ `"error"`（所有 skill 就位后切换）
- **说明**: 配合 [CLAUDE.md § Help 模式约定](../../../CLAUDE.md) 的统一 parsing 规则。对有默认行为的 skill（block-break / skill-lint），Help 段首段需显式声明"无参数 ≠ help"。本规则不检查 openclaw 镜像（openclaw 的 help 机制未定义，follow-up PR 处理）
- **兼容**: 配置值也接受 `true`（等价 `"error"`）/ `false`（等价 `"off"`），方便旧项目迁移

### S27: 术语引用密度（v1.2）

- **检查**: 每个 SKILL.md 出现的专有术语（环境名 / 工具名 / 路径片段，启发式 = hyphenated 英文词如 `openclaw` 或带 `-` 的 kebab-case，加上前缀 `~/.X` 形式的路径片段）必须在 repo 内有 ≥1 处定义引用（grep 命中其他文件）
- **级别**: warning（不阻断）
- **配置**: 始终执行，无开关
- **白名单**: `git`/`ls`/`bash`/`jq`/`sed`/`awk`/`grep`/`find`/`curl`/`python`/`python3`/`node`/`npm`/`cd`/`echo`/`cat`/`diff`/`rsync`/`cp`/`mv`/`rm`/`mkdir`/`tee`/`xargs`/`sort`/`uniq`/`wc`/`head`/`tail`/`md`/`json`/`yaml`/`txt`/`sh` 等通用 token 豁免
- **说明**: SKILL.md 出现 "openclaw 环境" 这类术语，若 repo 内（除该 SKILL.md 自身外）无任何文件提及 `openclaw` —— 视为孤立术语，可能产生歧义指代，需 reference 段补定义引用（如 [scope-boundaries.md] 链接）。本规则启发性强，false positive 率非零，因此为 warn 级别仅提示
- **真实案例**: openclaw 失败 — 用户说 "更新到 openclaw 环境" 时 LLM 误锚定到 Claude Code cache，因为 `platforms/openclaw/` 目录在 SKILL.md 没有被明确链接定义

### S28: 平台 hook 镜像（v1.2）

- **检查**: 若某 skill 有 `skills/<s>/hooks/` 目录（owner skill），且 `.skill-lint.json` 的 `platforms` 数组含 `<p>`，则 `platforms/<p>/<s>/hooks/<p>/` 必须存在；且该目录下每个子目录的 `HOOK.md` frontmatter 中 `events` 字段（数组形态）必须非空
- **级别**: error
- **配置**: 始终执行（条件性触发，不需开关）
- **说明**: per [platform-parity spec ADDED Requirement](../../../openspec/specs/platform-parity/spec.md) — hook 等价镜像从 advisory 升 mandatory 的强制点。若平台真无等价 hook 系统，需在 SKILL.md `## 平台 hook 等价位置` 段明示"无等价机制可用"，本规则需配合此段做豁免（实施时检测段内文本）
- **真实案例**: claim-ground 在 `platforms/openclaw/claim-ground/` 下原本无 `hooks/openclaw/`，导致 epistemic-pushback / frustration / evidence-reminder 等 hook 在 openclaw 上完全失效

### S29-S33: 版本治理 + 文档漂移 + 归档归并完整性（v1.1）

S29-S33 在 commit `cf79b1d`（version-governance change）与 `f0a91e9`（version-governance archival）静默引入，本文档迟于实现。详见各自的 archived openspec change：

- **S29 version-lockstep**：marketplace.json `plugins[].version` MUST 是 SemVer 2.0.0；SKILL.md frontmatter MUST NOT 含 `version:` 字段（Claude Code schema 拒绝）。canonical + platform mirror 同等约束。**级别**: error
- **S30 help-card-version-line**：SKILL.md `## Help` 段第一行字面量 MUST 匹配 `<Name> v<X.Y.Z> — <tagline>`；`X.Y.Z` 等于 marketplace SSOT。**级别**: error
- **S31 changelog-entry**：marketplace.json `plugins[].version` MUST 等于根 [/CHANGELOG.md](../../../CHANGELOG.md) `## <skill-name>` 段下 top-most `### [X.Y.Z]` 条目。**级别**: error
- **S32 docs-version-drift**：扫 `docs/user-guide/<skill>-guide.md` + `docs/i18n/<lang>/<skill>-guide.md` 首行 H1 提取 `v<X.Y.Z>`；与 marketplace SSOT 做 prefix-match。**级别**: warn（观察期）
- **S33 archived-spec-merge**：扫 `openspec/changes/archive/<id>/specs/<capability>/spec.md`；若主 spec 没有 `合并自 archive/<id>` 引用 → 报。**级别**: warn（观察期）

实现位置：[scripts/skill-lint.sh](../scripts/skill-lint.sh) 各自独立 Python 子进程。详细配置与 fail 模式参考 archived [openspec/changes/archive/version-governance/](../../../openspec/changes/archive/version-governance/) 与 [openclaw-drift-fix/](../../../openspec/changes/archive/openclaw-drift-fix/)。

### S34: Help-card flag 覆盖率（v1.1）

- **检查**: SKILL.md frontmatter `argument-hint` 中所有以 `--` 开头的 flag MUST 在 `## Help` 段的第一个 fenced code block 内至少出现一次。canonical + platform mirror 同等约束（mirror 含 Help 段时一并扫）
- **级别**: warn（初期观察期；现有 4 个 skill 漏列待 follow-up RFC `fix-help-card-flag-coverage` 修完后升 error）
- **配置**: `.skill-lint.json` 中 `verify-help-card-flag-coverage` 三态 (`off` / `warn` / `error`)
- **豁免**:
  - argument-hint 字段缺失 → 跳过（claim-ground / skill-lint / block-break 等无字段 skill）
  - argument-hint 仅含子命令枚举（`[setup|run|...]`）无 `--flag` → 跳过（ralph-boost / tome-forge subcommand-only skill）
  - Help 段缺失或无 fenced code block → 跳过（S25 已报，避免重复）
- **真实案例**:
  - council-fuse: `argument-hint: "[question or task] [--no-save]"`，help card 没列 `--no-save` → S34 warn
  - news-fetch: 同上，`--no-save` 漏列
  - insight-fuse: argument-hint 含 11 flag，help "Key flags" 仅列 4 → S34 warn 列出漏的 7 个
- **检测方式**: 正则 `--[a-z][a-z0-9-]+` 提取两侧 flag 集合，用集合差返回缺失项

### S35: 输出语言 flag 必填（v1.2）

- **检查**: 每个 user-invokable skill 的 SKILL.md frontmatter `argument-hint` MUST 含 `--lang`（output-language 契约）。canonical（nested 优先，flat 兜底）+ platform mirror 同等约束
- **级别**: error
- **配置**: `.skill-lint.json` 中 `verify-lang-flag-required` 三态 (`off` / `warn` / `error`)
- **不通过**: argument-hint 缺失 → `S35: <path> missing argument-hint with --lang`；存在但不含 `--lang` → `S35: <path> argument-hint missing --lang`
- **契约**: openspec/specs/output-language/spec.md
- **与 S34 协作**: S35 保证 `--lang` 进入 argument-hint；S34 保证它出现在 help card

## 语义检查规则（AI 执行）

### M01: Description 质量

- **检查**: SKILL.md frontmatter 中的 description 是否清晰描述了 skill 的用途和触发条件
- **级别**: warning
- **不通过**: description 只是重复 name、过于模糊（如 "A useful skill"）、或缺少触发场景描述
- **通过**: 能让读者一眼明白 skill 做什么、何时触发

### M02: Frontmatter 一致性

- **检查**:
  - `name` 字段值与 `skills/<name>/` 目录名是否一致
  - `description` 在 SKILL.md 和 marketplace.json 的对应条目间是否语义对齐（不要求完全相同，但不能矛盾）
- **级别**: warning

### M03: Command 路由逻辑（可选，仅在项目使用 commands routing 时检查）

- **检查**: `commands/<name>.md` 中是否正确引用了对应 skill 名称（如 "使用 Skill 工具加载 `<name>` skill"）
- **级别**: warning
- **说明**: 错误的路由会导致 `/name` 加载错误的 skill。许多项目不使用 commands 目录，此规则跳过

### M04: References 内容连贯性

- **检查**:
  - SKILL.md 引用的 references 文件内容是否与主文件的逻辑一致
  - references 目录下是否有未被 SKILL.md 引用的孤立文件
- **级别**: warning
- **说明**: 需要 AI 读取并理解文件内容，纯结构检查无法覆盖

### M05: Eval 场景覆盖度

- **检查**: `scenarios.md` 是否覆盖 skill 的核心功能路径
- **要求**: 至少 5 个场景，覆盖正常路径、边界情况、错误处理
- **级别**: warning
