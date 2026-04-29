# Capability: help-mode

## Purpose

为所有 user-invokable skill 提供统一的 help 入口，降低发现成本并保证
解析行为可预测、可测试。Help 入口必须无副作用——只输出 help card，
不触发任何主路径行为。

## Behavior

### Parsing 规则（所有 skill MUST 一致实现）

```text
first = first_whitespace_token(user_input).strip().lower()

if first in {"help", "--help"}:
    render_help_card()
    return

if skill in {block-break, skill-lint} and args_are_empty:
    run_default_behavior()        # L2 不适用
    return

if args_are_empty:
    render_help_card()             # L2 隐式 no-args
    return

run_main_path(args)
```

### L1 显式 token（全员 MUST 实现）

- 第一个参数 token（trim + 小写比较）∈ `{"help", "--help"}` →
  必须输出 `## Help` 段内的 help card 并**停止执行**
- 第一个 token 之后的参数 MUST 被忽略
- 必须不调用主路径行为，必须不修改任何文件或运行时状态

### L2 隐式 no-args（仅"必填参数"skill MUST 实现）

下列 skill MUST 在无参数时输出 help card：

- `council-fuse`
- `insight-fuse`
- `news-fetch`
- `ralph-boost`
- `tome-forge`
- `claim-ground`

### L2 例外（"有默认行为"skill MUST NOT 把无参数当作 help）

下列 skill 必须在 SKILL.md `## Help` 段**首段显式声明"无参数 ≠ help"**：

- `block-break`（无参数 = 运行 Block Break 行为约束）
- `skill-lint`（无参数 = lint 当前目录）

### SKILL.md `## Help` 段落模板

每个 user-invokable skill 的 SKILL.md 必须包含 `## Help` 段，使用
**模板 A**（必填参数 skill）或**模板 B**（有默认行为 skill）：

**模板 A** — 必填参数 skill：

```markdown
## Help

当第一参数为 `help` / `--help`，**或无参数**时，输出以下 help card 并
停止执行（parsing 规则详见 openspec/specs/help-mode/spec.md）：

\`\`\`
<Skill Name> — <one-line purpose>

Usage:
  /<skill-name> <args>           <主路径>
  /<skill-name> help             Show this help

Examples:
  /<skill-name> <example 1>
  /<skill-name> <example 2>

Guide: docs/user-guide/<skill>-guide.md
\`\`\`
```

**模板 B** — 有默认行为 skill：

```markdown
## Help

**无参数 ≠ help**：无参数时执行默认行为（<该 skill 的默认行为一句话>）。
仅当第一参数为 `help` / `--help` 时输出以下 help card 并停止
（parsing 规则详见 openspec/specs/help-mode/spec.md）：

\`\`\`
<Skill Name> — <one-line purpose>

Usage:
  /<skill-name>                  <默认行为说明>
  /<skill-name> <args>           <主路径>
  /<skill-name> help             Show this help

Examples:
  /<skill-name>                  <默认行为典型用法>
  /<skill-name> <alt example>

Guide: docs/user-guide/<skill>-guide.md
\`\`\`
```

## Rationale

- **统一发现路径**：用户在不熟悉 skill 时，第一直觉是 `/<name> help`；
  保证每个 skill 都响应同一个字面量，降低记忆成本
- **L1 vs L2 区分**：有些 skill 真的接受无参数（block-break / skill-lint
  最常用形态就是不带参数），强行 L2 会破坏惯用法；用模板 B 显式声明
- **case-insensitive trim**：用户输入 `Help` / ` help ` / `--HELP` 都该工作；
  否则 user-friendly 度下降，且不同 skill 行为发散
- **无副作用**：help 入口在 plan mode、CI 干跑、自动化测试场景必须
  保证不写文件不调网络

## Verification

### 自动化

```bash
bash evals/_meta/help-parity-test.sh
# 预期：通过
# 检查：
#   - 每个 user-invokable skill 的 SKILL.md 都有 ## Help 段
#   - L1 token 测试（"help" / "--help" / "Help"）输出 help card
#   - L2 测试（无参数）—— 6 个必填参数 skill 输出 help，2 个例外 skill 走默认
```

### 人工核对

- [ ] 修改 SKILL.md 的 Help 段后必须跑上述脚本
- [ ] skill-lint 的 S24 规则会按 `.skill-lint.json` 中 `require-help-section`
      的灰度（off / warn / error）生效

### 增补新 skill

- 新 skill 默认走模板 A（L1 + L2）
- 仅当 skill 有"无参数也合法"的默认行为时（极少数）才走模板 B，
  且必须在 design 文档说明为什么不能用 L2
