# Tasks

## Task 1 — 重写 8 份过期 READMEs 的 Project Structure 代码块

**依赖**：无

**做什么**：

针对 de / es / fr / hi / pt-BR / ru / tr / vi 8 份 README，定位
line 254 - 280 的 `## Project Structure` 段（含开始的 ` ```text` 与结束的
` ``` `），整段替换为新布局，注释翻译成本地语言。

**验证命令**：

```bash
# 旧 stale token 应零残留
grep -rn "user-guide/i18n\|README\\.\\*\\.md\|translated guides moved" \
  docs/i18n/{de,es,fr,hi,pt-BR,ru,tr,vi}/README.md
# 预期：零结果

# 新结构 token 应存在
for lang in de es fr hi pt-BR ru tr vi; do
  grep -q "openspec/" "docs/i18n/$lang/README.md" || echo "FAIL: $lang missing openspec/"
  grep -q "i18n/<lang>" "docs/i18n/$lang/README.md" || echo "FAIL: $lang missing i18n/<lang>"
  grep -q "design/<category>" "docs/i18n/$lang/README.md" || echo "FAIL: $lang missing design/<category>"
done
# 预期：零 FAIL
```

---

## Task 2 — ja/ko/zh-CN 追加 openspec/ 一行

**依赖**：无

**做什么**：

在 ja / ko / zh-CN 三份 README 的 Project Structure 段，紧跟
`docs/ # ...` 一行后追加 `openspec/ # 演化元仓库`（注释用本地语言）。

**验证命令**：

```bash
for lang in ja ko zh-CN; do
  grep -q "openspec/" "docs/i18n/$lang/README.md" \
    || echo "FAIL: $lang missing openspec/ in structure"
done
# 预期：零 FAIL
```

---

## Task 3 — 11 份 READMEs 的 Contributing 第 2 项追加 platform-parity 引用

**依赖**：无（与 Task 1/2 可并行）

**做什么**：

在 11 份 i18n README 的 `## Contributing`（或本地化标题如 "## 贡献" /
"## コントリビュート" / "## Mitwirken" / "## Beitragen" 等）段第 2 项
（关于 `platforms/openclaw/<name>/SKILL.md` 那一行）末尾追加引用：

```
（平台广播契约见 [platform-parity](../../../openspec/specs/platform-parity/spec.md)）
```

注释括弧及"平台广播契约见"短语用本地语言。

**验证命令**：

```bash
# 11 份 README 都应包含 platform-parity 链接
grep -l "platform-parity" docs/i18n/*/README.md | wc -l
# 预期：11
```

---

## Task 4 — 全文一致性扫描

**依赖**：Task 1 / 2 / 3 完成

**做什么**：

```bash
# 不应有旧路径残留
grep -rn "user-guide/i18n\|docs/i18n/README\\.[a-z]" \
  docs/i18n/*/README.md
# 预期：零结果

# skill-lint 仍 0/0 全过
bash skills/skill-lint/scripts/skill-lint.sh .

# 主 README 与 i18n 翻译版数量对齐
grep -l "platform-parity" README.md docs/i18n/*/README.md | wc -l
# 预期：12（主 + 11 i18n）
```

---

## Task 5 — PR 描述质量分级

**依赖**：Task 1/2/3 完成

**做什么**：

PR description 必须包含以下表格，让 reviewer 知道哪些语言需重点核对：

```markdown
| Language | Confidence | Review priority |
|----------|-----------|----------------|
| zh-CN / ja / ko | High | Skim |
| de / es / fr / pt-BR / ru | Medium | Read |
| hi / tr / vi | Low | Native speaker review preferred |
```

非 verification 性 task，但作为 PR 提交前的检查项。
