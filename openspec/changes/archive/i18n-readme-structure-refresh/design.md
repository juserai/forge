# Design

> 影响分类：cross（i18n-layout 的实例化执行，不归属任何单一 forge 4 分类）

## 决策 1 — 翻译详尽度：完整重写 vs 局部修补

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A. 局部修补**（采纳） | 只改 Project Structure 代码块 + Contributing 第 2 项 | 收益最高（功能性问题）；翻译劳动量可控（8 份 × ~15 行代码块） |
| B. 完整重写整段 docs/ 树 | 把所有 docs 子目录的注释都重新译 | 工作量大；超出本次目标（消除 stale）；风险增加（可能改动既有正确翻译） |
| C. 仅删除 stale 行 | 简单地删掉 line 278 的英文 stale | 治标不治本；line 277 的 `README.*.md` 仍是错的 |

**反例验证**：用户在 GitHub 阅读 zh-CN README 时复制 `docs/i18n/README.zh-CN.md`
路径——该路径已不存在。局部修补恰好覆盖这个真实场景。

## 决策 2 — ja/ko/zh-CN 的处理：精简 vs 展开

3 份 README 用了一行式 `docs/ # 跨平台文档`，没有踩老路径。

| 选项 | 描述 | 取舍 |
|------|------|------|
| **A. 保留一行 + 追加 openspec/**（采纳） | 一行式延续，加一行 `openspec/ # 演化元仓库` | 与既有翻译风格一致；新增一个语义信号（openspec 存在）；不强制扩展 |
| B. 展开为完整子树 | 与 8 份过期 READMEs 保持一致结构 | 风格反转，需要翻译劳动；ja/ko/zh-CN 当初做的精简决策可能是有意的 |

## 决策 3 — Contributing 第 2 项的 platform-parity 引用

主 README 写：

```markdown
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw adaptation + references/scripts
   (see [platform-parity](openspec/specs/platform-parity/spec.md) for the
   broadcast contract)
```

i18n 版本应该简短括注引用，例如 zh-CN:

```markdown
2. `platforms/openclaw/<name>/SKILL.md` — OpenClaw 适配版 + references/scripts
   （平台广播契约见 [platform-parity](../../../openspec/specs/platform-parity/spec.md)）
```

注意路径深度：从 `docs/i18n/<lang>/README.md` 出发，到 `openspec/specs/`
是 `../../../openspec/specs/`（三层 up）。

## 决策 4 — 翻译质量保证

11 份语言中有几种我（AI agent）翻译质量明显较低（如 hi、tr、vi 这些
低资源语言）。三档处理：

| 语言 | 信心度 | 处理 |
|------|-------|------|
| zh-CN / ja / ko | 高 | 直接重写 |
| de / es / fr / pt-BR / ru | 中 | 直接重写，附 sed-friendly 单 token 替换以便人工 review |
| hi / tr / vi | 低 | 重写但在 PR 描述里显式标注"AI-translated, please review" |

**反例验证**：claim-ground 误判事件的部分原因就是 11 份 i18n 同步翻译
质量参差。本次主动标注质量分级，让 reviewer 把注意力集中在高风险语言。

## 不采纳的方案

1. **批量删除 i18n READMEs 的 Project Structure 段**：让代码块只保留
   英文版，避免翻译漂移。**拒绝**——i18n READMEs 的存在意义就是
   单语自包含；删除结构段等于让该语言用户必须切回英文版才能看仓库
   形状。
2. **引入自动化 i18n parity 检查规则**：要求每份 i18n README 的
   structure 段必须包含特定 token。**拒绝**——结构是描述性内容，
   严格 token 匹配会绑死翻译；交给人工 review 即可。
