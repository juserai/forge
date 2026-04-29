# Capability: i18n-layout

## Purpose

定义 forge 仓库的多语言文档布局。本 spec 描述**目标布局**（单轨
`docs/i18n/<lang>/<file>`），同时记录**现状**（双轨过渡期）与
**迁移路径**，作为 i18n 单轨迁移 change 的契约源头。

## Migration Status

- **Current**（截至 2026-04-29）：单轨布局已落地
  - `docs/i18n/<lang>/README.md` × 11 份
  - `docs/i18n/<lang>/<skill>-guide.md` × 88 份
- **Migration**：由 `bootstrap-openspec-and-restructure` change 完成
  （脚本 `scripts/migrate-i18n.sh` apply 模式一次性迁移 99 文件 + 链接重写）
- **Legacy**：`docs/user-guide/i18n/` 目录已删除；`.skill-lint.json` 中
  `i18n-guide-dir` 字段已移除。skill-lint S17 现作为 guard 防止旧路径回归。

## Behavior

### 目标布局

```
docs/i18n/
├── de/
│   ├── README.md
│   ├── block-break-guide.md
│   ├── claim-ground-guide.md
│   ├── council-fuse-guide.md
│   ├── insight-fuse-guide.md
│   ├── news-fetch-guide.md
│   ├── ralph-boost-guide.md
│   ├── skill-lint-guide.md
│   └── tome-forge-guide.md
├── es/
│   └── ... (同上 9 文件)
├── fr/
├── hi/
├── ja/
├── ko/
├── pt-BR/
├── ru/
├── tr/
├── vi/
└── zh-CN/
```

### 支持语言（截至 2026-04-29）

11 种：`de` / `es` / `fr` / `hi` / `ja` / `ko` / `pt-BR` / `ru` / `tr` /
`vi` / `zh-CN`。

新增语言 MUST：

- 创建 `docs/i18n/<lang>/` 目录
- 翻译 README.md 与所有 8 个 skill 的 guide（即一次性创建 9 个文件）
- 在 README.md 顶部语言切换链表加入新语言
- 在 11 份现有语言的 README 顶部链表也加入新语言（MUST 保持顺序一致）
- 更新 `.skill-lint.json` 的 i18n 语言列表（如有）

### 文件命名

- `<lang>/README.md` — 该语言的项目级 README 翻译
- `<lang>/<skill-name>-guide.md` — 该语言的 skill 用户指南翻译
- 命名 MUST 与英文版 `docs/user-guide/<skill-name>-guide.md` 对齐
  （文件名相同，仅目录不同）

### 语言切换链表

每份 README 顶部 MUST 有语言切换链表，引用其他 10 种语言版本。链表
MUST：

- 使用相对路径 `../<lang>/README.md`（从 `docs/i18n/<lang>/` 出发）
- 顺序与主 README.md 保持一致（避免每个语言不同顺序）
- 主 README.md（仓库根 `README.md`）的链表使用 `docs/i18n/<lang>/README.md`

### 内部锚点

i18n 文件中引用其他文档时 MUST 使用相对路径：

- 引用主 README：`../../README.md`
- 引用英文 guide：`../../user-guide/<skill>-guide.md`
- 引用 design 文档：`../../design/<category>/<skill>-design.md`

### `.skill-lint.json` 配置（迁移完成后）

```json
{
  "rules": {
    "i18n-dir": "docs/i18n",
    "verify-i18n-structure-parity": true,
    "user-guide-dir": "docs/user-guide"
  }
}
```

迁移完成后 `i18n-guide-dir` 字段 MUST 移除（与 `i18n-dir` 合并）。

## Rationale

- **单轨 > 双轨的理由**：扫一种语言时所有文件聚在一起；新增 skill 时
  只需在 11 个语言目录各加一个文件，不再需要在两个 i18n 子树同时操作
- **不维持双轨的理由**：双轨需要在每次新增/修改时记住"项目级在 A 路径，
  skill 级在 B 路径"，这个区分在 forge 当前规模收益小于成本
- **目录而非文件名编码语言**：`docs/i18n/zh-CN/` vs
  `docs/i18n/README.zh-CN.md` —— 前者扩展性好，目录可以放任意数量的
  翻译文件而不污染顶层
- **过渡期兼容**：spec 显式承认双轨现状，避免 spec 与实际状态分裂；
  迁移 PR 落地后再去掉 Migration Status 段

## Verification

### 自动化

```bash
# 迁移完成后才适用
bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：verify-i18n-structure-parity 通过
#   - 每个语言目录下都有 README.md
#   - 每个语言目录下都有 8 份 *-guide.md（与 skills/ 下数量对齐）

# 单轨完整性
ls docs/i18n/*/README.md | wc -l
# 预期：11

ls docs/i18n/*/*-guide.md | wc -l
# 预期：88（11 语言 × 8 skill）

# 旧路径已清空
test ! -d docs/user-guide/i18n && echo "ok"
# 预期：ok
```

### 迁移期间

迁移 PR 必须在单次提交内同时完成所有文件移动 + 配置更新，避免半迁移
状态使 skill-lint 同时报旧路径不存在和新路径不完整。

### 人工核对

- [ ] 11 份 README 顶部语言切换链表顺序一致
- [ ] 至少抽查 1 种语言（推荐 zh-CN）所有内部锚点可正常跳转
- [ ] 迁移脚本 dry-run 输出在 PR 描述中可见
