# Capability: runtime-state

## Purpose

定义 forge skill 在运行时持久化状态的统一约定。所有运行时状态住在
`~/.forge/`，跨 skill 不共享，避免隐式耦合带来的"一个 skill 改了状态文件
导致另一个 skill 行为变化"。

## Behavior

### 状态根目录

- 运行时状态根目录 MUST 是 `~/.forge/`
- 该目录由首个写入状态的 skill 负责创建（`mkdir -p ~/.forge`）
- 该目录 MUST 在 `.gitignore` 中显式排除（已生效）

### 状态文件命名

每个需要持久化状态的 skill MUST 使用以下命名约定：

```
~/.forge/<skill-name>-state.json
```

例如：

- `~/.forge/block-break-state.json`（Block Break 的失败计数 + 当前压力等级）
- `~/.forge/ralph-boost-state.json`（Ralph Boost 的 session + circuit breaker）

### 状态隔离

- 跨 skill **MUST NOT** 共享状态文件（不许 skill A 读 skill B 的 state）
- 若两个 skill 需要协调（如 ralph-boost 内嵌 block-break 行为），
  上层 skill MUST 通过子进程参数 / 环境变量传递必要信号，而非读对方
  状态文件
- skill **SHOULD NOT** 假设 `~/.forge/` 下其他 skill 的文件存在或缺失

### Schema 与生命周期

- 每个状态文件的 JSON schema 与生命周期（何时创建、何时清理）MUST 在
  对应 skill 的 `references/` 文档说明（例如
  `skills/block-break/references/state-schema.md`）
- 重大 schema 变更（删字段 / 改字段类型）MUST 提供迁移逻辑或显式 reset
  路径（如 `/block-break clean`）
- skill **MUST** 在解析状态文件时容忍多余字段（向前兼容）

### Hook 与状态

- 仅 `block-break` 与 `claim-ground` 拥有专属 hook，住在
  `skills/<name>/hooks/`（详见 `repo-invariants` spec）
- Hook 脚本读写状态文件 MUST 使用本 spec 的命名约定

### 清理路径

每个有状态的 skill **SHOULD** 提供清理子命令（如 `/ralph-boost clean`），
作用：删除该 skill 在 `~/.forge/` 下的状态文件。**MUST NOT** 提供
"删除整个 ~/.forge/"的命令——会破坏其他 skill 的状态。

## Rationale

- **统一根目录**：避免每个 skill 各自挑路径（`~/.config/`、`~/.cache/`、
  `/tmp/` 都见过），用户可一目了然地 `ls ~/.forge/` 知道有哪些 skill
  在保留状态
- **零共享**：状态共享是隐式耦合的最大来源；强制"不共享"让每个 skill
  保持自包含的可测试性，迁移到其他平台时只需迁该文件
- **JSON 格式**：人类可读、bash 可处理（`jq`）、跨平台、零依赖
- **schema 自管**：各 skill 自己最了解其状态结构，集中维护反而成为瓶颈；
  对应 `references/` 文档是 schema 的 single source of truth

## Verification

### 自动化

```bash
# 状态目录约定检查（如果有人写了 ~/.config/forge/ 这种）
grep -rn "\.forge\b\|~/\.forge\|HOME.*forge" skills/ platforms/ \
  --include="*.sh" --include="*.json" --include="*.md"
# 预期：所有匹配都指向 ~/.forge/<name>-state.json 形式

# 跨 skill 读状态检查（应为零）
for skill in skills/*/; do
  name=$(basename "$skill")
  grep -rn "\.forge/" "$skill" --include="*.sh" --include="*.md" \
    | grep -v "${name}-state.json" | grep -v "block-break-state.json.*shared" \
    || true
done
# 预期：每个 skill 仅引用自己的 state.json
```

### 人工核对（新增有状态 skill 时必跑）

- [ ] state 文件路径符合 `~/.forge/<skill-name>-state.json` 命名
- [ ] schema 文档存在于 `skills/<name>/references/`
- [ ] 提供 clean 路径，且 clean 命令只删自己的文件
- [ ] hook（如有）也走这套命名
