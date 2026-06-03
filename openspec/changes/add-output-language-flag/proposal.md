# Add output-language flag `--lang` (default zh-CN, all skills)

> 这次 change 解决的张力（来自 Context "i18n 布局"的延伸）：各 skill 的
> **输出语言不统一、不可控**——insight-fuse / council-fuse 隐式，peer-fuse 按源
> 文档语言，news-fetch 按用户输入 CJK，block-break / claim-ground 注入双语。
> 用户无法显式指定"我要这份报告用什么语言"，且不同 skill 默认行为发散。

## Why

实勘证据：

1. **隐式无参数**：insight-fuse [SKILL.md:13](../../../skills/insight-fuse/skills/insight-fuse/SKILL.md#L13) 的 11 个 flag 无语言项；council-fuse 同样无。
2. **按源检测**：peer-fuse [references/narrative-discipline.md:154-167](../../../skills/peer-fuse/skills/peer-fuse/references/narrative-discipline.md#L154-L167) Rule 6 "Output language matches source"。
3. **按输入检测**：news-fetch [SKILL.md 语言检测规则](../../../skills/news-fetch/skills/news-fetch/SKILL.md) "CJK → 中文模板；否则英文"。

三者无统一入口，用户无法覆盖默认。需求：**所有 skill** 加统一 `--lang`，
**默认中文**，把"输出语言"从隐式发散升级为显式横向契约。

## What Changes

- **新增横向 spec** [output-language/spec.md](../../specs/output-language/spec.md)：定义 `--lang` 枚举（`zh-CN|en|ja|ko|fr|de|es|pt-BR|ru|tr|vi|auto`）、hard zh-CN 默认、`auto` 恢复原生检测、声明位置（argument-hint + help card）。
- **9 个 skill 全量加 `--lang`**：canonical + openclaw mirror 共 18 个 SKILL.md，统一三处声明（argument-hint / help card / 行为说明）。无 argument-hint 字段的 block-break / claim-ground / skill-lint **新增**该字段。
- **2 处特殊改写**：peer-fuse Rule 6 与 news-fetch 检测规则——默认改 zh-CN，原检测降级为 `--lang auto` opt-in。
- **skill-lint 新增 S35**：断言每个 user-invokable skill 的 argument-hint 含 `--lang`（缺失 error），使契约可执行。
- **9 个 skill MINOR bump**（新增非破坏性 feature）+ CHANGELOG + marketplace hash 锁步。
- **CLAUDE.md** 横向契约表加一行指向 output-language spec。

## Non-goals

- **不改 docs i18n 布局**：不新增 docs 语言、不动 `docs/i18n-archived/`；输出语言 ≠ docs 翻译。
- **不改 KB 归档结构**：`--lang` 只影响内容语言，不改归档路径 / 文件命名 / 运行时状态。
- **不改 hook 自动注入行为**：block-break / claim-ground 经 UserPromptSubmit hook 注入的双语提示保持现状；`--lang` 仅作用于**直接调用**路径。
- **不引入 free-form 语言**：枚举为闭集；`--lang Italian` 等非法值报 help。
