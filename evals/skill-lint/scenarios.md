# Skill Lint 评估场景

验证 skill-lint 校验工具是否按预期工作的测试场景。

## 场景 1: 基础激活

**输入**: `/skill-lint`
**期望**: 输出激活表格，包含结构检查和语义检查两行

## 场景 2: 校验当前项目

**输入**: `/skill-lint .`
**期望**: 运行 bash 结构检查 + AI 语义检查，输出合并结果表格

## 场景 3: 校验指定路径

**输入**: `/skill-lint /path/to/other/plugin`
**期望**: 对指定路径执行完整校验流程

## 场景 4: 检测缺失 SKILL.md

**设置**: 存在 `skills/broken/` 目录但无 SKILL.md
**期望**: 结构检查报 error — `S03: skills/broken/SKILL.md missing`

## 场景 5: 检测 frontmatter 缺失字段

**设置**: SKILL.md 存在但 frontmatter 中缺少 `description`
**期望**: 结构检查报 error — `S04: missing required field 'description'`

## 场景 6: 检测断链 references

**设置**: SKILL.md 中引用了 `references/nonexistent.md` 但文件不存在
**期望**: 结构检查报 error — `S07: referenced but file missing`

## 场景 7: 检测 marketplace.json 缺失条目

**设置**: skill 目录存在但未在 marketplace.json 的 plugins 数组中
**期望**: 结构检查报 warning — `S06: not listed in marketplace.json`

## 场景 8: 语义检查 — name 与目录名不一致

**设置**: `skills/foo/SKILL.md` 的 frontmatter name 为 `bar`
**期望**: 语义检查报 warning — name 与目录名不一致

## 场景 9: 语义检查 — description 质量差

**设置**: SKILL.md 的 description 为 "A skill"（过于模糊）
**期望**: 语义检查报 warning — description 不够清晰

## 场景 10: 全部通过

**设置**: 完整合规的 skill 项目（含 .skill-lint.json）
**期望**: 结构检查和语义检查全部 passed，无 errors 和 warnings

## 场景 11: 无 .skill-lint.json — 通用模式

**设置**: 一个标准 Claude Code plugin 项目，无 .skill-lint.json
**期望**: 只执行 S01-S08 Core 规则，不报 S09-S15 相关的 errors 或 warnings

## 场景 12: 部分配置 — 只启用命名和分类

**设置**: .skill-lint.json 只含 `naming-pattern` 和 `category-values`，不含其他字段
**期望**: S09 和 S10 执行，S11-S15 不执行

## 场景 13: 自定义 category 值

**设置**: .skill-lint.json 中 `category-values` 为 `["core", "util", "experimental"]`
**期望**: S10 按自定义值校验，不报 Forge 的 hammer/crucible/anvil/quench

## 场景 14: 多平台配置

**设置**: .skill-lint.json 中 `platforms` 为 `["openclaw", "gemini"]`
**期望**: S14 分别检查 `platforms/openclaw/` 和 `platforms/gemini/` 下的适配文件
