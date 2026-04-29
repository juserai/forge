# Capability: repo-invariants

## Purpose

定义 forge 仓库层面的不变量——这些不变量违反会破坏整个仓库的一致性，
而不仅仅是单个 skill。本 spec 聚合"零依赖""SKILL.md 与 marketplace hash
锁步""hook 归属""文件同步"等横向约定。

## Behavior

### 零依赖原则

- 每个 skill MUST 保持**零运行时依赖**——只用 bash / sed / awk / grep / jq
  这类 POSIX 标准工具
- skill 之间 MUST NOT 有**硬依赖**（A 调用 B 才能工作）；MAY 有可选的组合
  关系（A 检测到 B 存在时增强行为）
- 引入新的运行时依赖（如 python / node）需要在 design 文档显式论证
  必要性，并在 `metadata.permissions.execution` 字段声明

### 各平台自包含

- `skills/<name>/`（Claude Code 规范版）与 `platforms/<plat>/<name>/`
  （其他平台适配版）MUST 各自持有完整文件，互不依赖
- 修改通用内容时 MUST 同步各平台（详见 `platform-parity` spec）

### Spawn sub-agent

skill 在 spawn sub-agent 时 MUST 注入行为约束，使用同目录 `agents/` 下的
agent 定义文件。MUST NOT 内联拼接 prompt 字符串。

### SKILL.md 精简原则

- SKILL.md 是 AI 运行时上下文的入口，每次 skill 激活都被注入
- SKILL.md MUST 保持精简，详细内容 MUST 放在 `references/` 下按需加载，
  减少 token 消耗
- SKILL.md frontmatter 支持的字段：
  - `name`（必填，与目录名一致）
  - `description`（必填）
  - `license`（推荐，默认 MIT）
  - `argument-hint`（可选）
  - `user-invokable`（可选，默认 true）
  - `metadata`（包含 `category` 与 `permissions`）

### Marketplace integrity 锁步

- `.claude-plugin/marketplace.json` 中每个 skill 条目 MUST 包含
  `integrity.skill-md-sha256`，值 MUST 等于对应 SKILL.md 的 SHA-256 hash
- **修改 SKILL.md 后 MUST 重新计算 hash 并更新 marketplace.json**
  （不限制顺序，但提交前两者必须一致）
- 可执行 `bash scripts/recalc-all-hashes.sh` 批量重算

### Plugin metadata 双份一致

- 根 `plugin.json` 与 `.claude-plugin/plugin.json` 是集合级元数据，
  两处 MUST 保持一致（version / description / name）

### Hook 归属

- 仅"hook owner"skill 才有 `skills/<name>/hooks/` 目录
- 当前 hook owner：`block-break` 与 `claim-ground`
- Hook 配置 MUST 住在 `skills/<name>/hooks/hooks.json`，脚本住在
  `skills/<name>/hooks/*.sh`
- marketplace.json 中对应 plugin 的 `source` MUST 指向 `./skills/<name>`
  （Claude Code 会自动发现 `${source}/hooks/hooks.json`）
- 其他 skill 不应有 hooks/ 目录；新 skill 引入 hook 需要在 design 文档
  论证为什么必须用 hook 而不是命令式调用

### Permissions 声明

每个 skill 的 SKILL.md frontmatter 的 `metadata.permissions` MUST 显式声明
最小权限集，至少包含 `network` / `filesystem` / `execution` / `tools` 字段。
详见 `docs/dev-guide/security-guidelines.md`。

## Rationale

- **零依赖是 forge 的卖点**：与"装一堆 npm/pip 包才能用"的工具区分开；
  零依赖意味着零供应链风险、零版本冲突、跨平台稳定
- **平台自包含 vs DRY 的取舍**：选择适度重复（每平台一份 SKILL.md）
  而不是抽象继承，保证修改单平台不会意外影响其他平台
- **Hash 锁步**：marketplace 的 integrity.sha 是用户信任 plugin 没被篡改
  的依据；不锁步则等于无效签名
- **Hook 归属于 skill 而非全局**：避免 hook 配置膨胀成"全局魔法"，
  每个 hook 都跟着拥有它的 skill 一起卸载

## Verification

### 自动化

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：以下检查全过
#   - hash-integrity（marketplace SHA 与 SKILL.md 一致）
#   - require-permissions-declaration
#   - no-dangerous-patterns
#   - require-agent-model
#   - protect-cross-namespace

bash scripts/recalc-all-hashes.sh
git diff .claude-plugin/marketplace.json
# 预期：零差异（hash 已最新）
```

### 人工核对

- [ ] 引入新依赖时在 design 文档论证
- [ ] 引入新 hook owner 时论证为什么需要 hook
- [ ] 双份 plugin.json 一致
