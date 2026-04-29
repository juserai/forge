# i18n README Structure Section Refresh

> 这次 change 解决的张力：8 份非英语 README 的 Project Structure 段
> 仍展示旧 i18n 双轨布局，并含未翻译的英文 stale 注释
> `(translated guides moved to docs/user-guide/i18n/)`。

## Why

`bootstrap-openspec-and-restructure` change 完成了文件层面的迁移，但
i18n READMEs 内的 **Project Structure 代码块**是手工翻译产物，没有跟
随文件结构变更而更新。具体扫描结果（`grep -nE "user-guide/i18n|README\\.\\*\\.md"
docs/i18n/*/README.md`）：

- **8 份过期**（de / es / fr / hi / pt-BR / ru / tr / vi）：line 273-278
  仍写 `docs/i18n/README.*.md` + `(translated guides moved to docs/user-guide/i18n/)`
- **3 份精简**（ja / ko / zh-CN）：用一行 `docs/ # 跨平台文档` 替代了
  详细 docs 子树，未踩老路径但也未提及新结构（含 `openspec/`、
  `docs/design/<category>/`）
- **11 份共同遗漏**：Contributing 段未引用 `platform-parity` spec
  （主 README 已更新，i18n 还没跟上）

8 份过期版本对路径敏感的读者（链接跳转 / 复制路径）会产生误导；
英文 stale 注释嵌在翻译文件中也降低专业感。

## What Changes

**8 份过期 READMEs**：用各自语言重写 Project Structure 代码块，使其
反映当前布局：

```text
forge/
├── skills/<skill>/                    # Claude Code 规范版
├── platforms/<platform>/<skill>/      # 其他平台适配
├── .claude-plugin/                    # marketplace 元数据
├── evals/<skill>/                     # 跨平台 eval 场景
├── docs/
│   ├── user-guide/                    # 英文使用手册
│   ├── dev-guide/                     # 开发文档
│   ├── design/<category>/             # 按 4 分类组织的设计文档
│   └── i18n/<lang>/                   # 多语言（README + skill guide）
├── openspec/                          # 演化元仓库
│   ├── specs/<capability>/            # 横向能力契约
│   └── changes/<id>/                  # 在飞 RFC（archive 存档）
└── plugin.json                        # 集合元数据
```

注释（`# Claude Code 规范版` 等）必须翻译成本地语言，与既有翻译风格
保持一致。

**11 份 READMEs**：在 Contributing 段第 2 项追加 platform-parity spec
引用（与主 README 同步），用本地语言简短括注。

**ja/ko/zh-CN 的精简结构**：保留一行式（不强制展开），但把 docs/ 一行后
追加 `openspec/` 一行；Contributing 段补 platform-parity 引用。

## Non-goals

- 不改任何已翻译的 prose（Skills 表格、Skill 描述、Why 段等）
- 不增加新章节或新功能描述
- 不引入新的 spec 或新的 lint 规则
- 不 retranslate 全文，只改 Project Structure 代码块 + Contributing 第 2 项
- 不动主 README.md（已是新格式）
- 不动 docs/i18n/<lang>/<skill>-guide.md 翻译（guide 内部锚点已在 i18n
  迁移时处理过）
