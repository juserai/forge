# Capability: output-language

## Purpose

为所有 user-invokable skill 提供统一的**输出语言**控制入口 `--lang`，使
用户可见输出（报告正文 / 控制台诊断 / 叙事 / 指导文本）的自然语言**可控、
可预测、跨 skill 一致**。默认中文（`zh-CN`），消除"各 skill 各自隐式决定
输出语言"的发散现状。

本 spec 横切 forge 4 分类（cross）：crucible（insight-fuse / council-fuse /
peer-fuse）、quench（news-fetch）、hammer（block-break / claim-ground）、
anvil（skill-lint）以及其余 skill 同等适用。

## Behavior

### 枚举值（所有 skill MUST 一致）

`--lang` 的合法取值 MUST 为以下集合（复用仓库 `docs/i18n/` +
`docs/i18n-archived/` 的 locale 码，不引入第二套命名）：

```text
zh-CN | en | ja | ko | fr | de | es | pt-BR | ru | tr | vi | auto
```

- `zh-CN` — 简体中文，**默认值**
- `en` — English（docs base 语言）
- `ja ko fr de es pt-BR ru tr vi` — 仓库 9 个归档语言
- `auto` — 哨兵值（非语言）：恢复该 skill 的原生语言检测逻辑

### 解析与默认（所有 user-invokable skill MUST 实现）

```text
lang = parse_flag(args, "--lang")        # 缺省 → None

if lang is None:
    lang = "zh-CN"                        # Hard default — 覆盖任何原生检测
elif lang == "auto":
    lang = skill_native_detection()       # 恢复 skill 原有检测
elif lang not in ENUM:
    render_help_card(); return            # 非法值 → help + 停止，不跑主路径

run_main_path(args, output_language=lang)
```

- 不带 `--lang` 时，输出 **MUST** 为 `zh-CN`，**MUST** 覆盖该 skill 任何
  既有的"按源 / 按输入"自动检测（hard zh-CN default）。
- 显式 `--lang <code>`（`code ≠ auto`）**MUST** 强制该语言贯穿全部
  user-facing 输出。inline 技术术语 / arXiv 论文标题 / 代码标识符 / 文件路径
  **MAY** 保留原文。
- `--lang auto` **MUST** 恢复 skill 原生检测：
  - peer-fuse → 按源文档语言（frontmatter `lang` → 字符比例 → fallback 中文）
  - news-fetch → 按用户输入 CJK 检测
  - 其余 skill → 按用户消息主导语言
- 非法 `code` **MUST** 输出 help card 并停止，**MUST NOT** 跑主路径。

### 声明位置（所有 user-invokable skill MUST 满足）

- `--lang` **MUST** 出现在 SKILL.md frontmatter `argument-hint`（无该字段的
  skill MUST 新增）。
- `--lang` **MUST** 出现在 `## Help` 段 help card 第一个 code block
  （满足 skill-lint S34 flag coverage）。
- 平台镜像 `platforms/<p>/<name>/SKILL.md` **MUST** 语义一致（可精简，
  不得新增能力，不得引入 `version` 字段）。

### 不变量

- `--lang` **MUST NOT** 改变 KB 归档路径 / 文件命名 / 任何运行时状态结构；
  仅影响输出**内容**的语言。

## Rationale

- **Hard zh-CN default vs flag-wins-else-keep**：选 hard default。维护者主用
  中文，"不带 flag 即中文"是最低记忆成本；既有的智能检测（peer-fuse 按源、
  news-fetch 按输入）通过 `--lang auto` 显式 opt-in 保留，不丢能力。反例验证：
  若选 flag-wins-else-keep，则 peer-fuse 评审英文文档默认仍出英文——与"默认
  中文"的诉求直接冲突。
- **宽枚举（12+auto）vs 最小集（zh-CN/en/auto）**：选宽枚举。报告输出语言 ≠
  docs 翻译——docs 翻译有维护成本（故 [i18n-layout](../i18n-layout/spec.md)
  收敛到 zh-CN 单轨），但 LLM 即时用某语言输出**无需维护翻译文件**，宽枚举
  边际成本为零。反例验证：最小集会让"输出日语报告"这类合理诉求无法表达。
- **复用 locale 码 vs ISO-639-1**：选复用 `docs/i18n*` 目录名（`zh-CN` /
  `pt-BR` 带 region）。全仓单一语言命名体系，避免 `zh` 与 `zh-CN` 双标。
- **覆盖现状的具体出处**：peer-fuse
  [references/narrative-discipline.md §6](../../../skills/peer-fuse/skills/peer-fuse/references/narrative-discipline.md)、
  news-fetch [SKILL.md 语言检测规则](../../../skills/news-fetch/skills/news-fetch/SKILL.md)。

## Verification

### 自动化

```bash
# 1. 全部 canonical + mirror 的 argument-hint 必须含 --lang（skill-lint S35）
grep -L -- '--lang' skills/*/skills/*/SKILL.md            # 期望无输出
grep -L -- '--lang' platforms/openclaw/*/SKILL.md          # 期望无输出

# 2. skill-lint 通过（S34 flag coverage + S35 --lang 必填 + 版本治理）
bash skills/skill-lint/scripts/skill-lint.sh .
```

### 人工核对

- [ ] 报告类（insight-fuse）不带 `--lang` 输出中文；`--lang en` 输出英文
- [ ] 检测类（news-fetch）不带 `--lang` 强制中文；`--lang auto` 恢复 CJK 检测
- [ ] 非报告类（skill-lint）`--lang en` 诊断信息英文
- [ ] 非法值（如 `--lang zz`）输出 help card 不跑主路径

### 增补新 skill

- 新 user-invokable skill MUST 在 argument-hint + help card 声明 `--lang`，
  否则 skill-lint S35 报 error。
