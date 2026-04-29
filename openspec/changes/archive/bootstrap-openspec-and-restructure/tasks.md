# Tasks

> 第一步在本 change 内完成（task 1）；第二步（task 2-7）在本 change
> 被 archive 后开新 change `restructure-claude-md-and-i18n` 执行。

## Task 1 — 落地 RFC 文档（本 change 范围）

**依赖**：无

**做什么**：

- [ ] 改写 `openspec/config.yaml`（项目级 context + 4 类 artifact 规则）
- [ ] 写 `proposal.md` / `design.md` / `tasks.md`（本文件）
- [ ] 写 7 份 `specs/<capability>/spec.md`：
  - `help-mode/`
  - `skill-lifecycle/`
  - `category-decision/`
  - `runtime-state/`
  - `repo-invariants/`
  - `i18n-layout/`（描述目标单轨布局）
  - `platform-parity/`

**验证命令**：

```bash
find openspec/changes/bootstrap-openspec-and-restructure -type f | wc -l
# 预期：10（proposal + design + tasks + 7 specs）

bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：通过（本 change 没改 skill 自身）

grep -rn "## Purpose\|## Behavior\|## Rationale\|## Verification" \
  openspec/changes/bootstrap-openspec-and-restructure/specs/
# 预期：每份 spec 各 4 段，共 28 行匹配
```

---

## Task 2 — CLAUDE.md 瘦身到索引（第二个 change 起点）

**依赖**：Task 1 archive

**做什么**：

- [ ] `git mv` 5 节内容到 `openspec/specs/<cap>/spec.md`（本 change 的 7 份 spec
      从 changes/.../specs/ 提升到 openspec/specs/）
- [ ] CLAUDE.md 主体改写为：项目一句话 + 仓库布局图 + 5 个 spec 的 inline
      链接 + "改动 skill 必读 § skill-lifecycle"提醒
- [ ] 行数 ≤ 80

**验证命令**：

```bash
wc -l CLAUDE.md
# 预期：≤ 80

grep -c "openspec/specs/" CLAUDE.md
# 预期：≥ 5（5 个 spec 的链接）
```

---

## Task 3 — `docs/design/` 分类子目录化

**依赖**：Task 2 完成

**做什么**：

- [ ] `mkdir docs/design/{hammer,crucible,anvil,quench,cross}`
- [ ] `git mv` 9 个 `*-design.md` 到对应分类子目录
  - hammer: block-break / ralph-boost / claim-ground
  - crucible: council-fuse / insight-fuse / tome-forge
  - anvil: skill-lint
  - quench: news-fetch
  - cross: cross-kb-archival-design.md
- [ ] `grep -rn "docs/design/<skill>-design.md"` 修订所有引用锚点
  - README.md / docs/i18n/README.*.md / 各 SKILL.md 的引用

**验证命令**：

```bash
ls docs/design/{hammer,crucible,anvil,quench,cross}/ | wc -l
# 预期：≥ 9 文件 + 5 标题行

grep -rn "docs/design/[a-z-]*-design\.md" \
  README.md docs/i18n/ skills/ platforms/
# 预期：零结果（旧路径锚点全部已更新）
```

---

## Task 4 — i18n 单轨迁移脚本编写

**依赖**：Task 2 完成

**做什么**：

- [ ] 写 `scripts/migrate-i18n.sh`（一次性脚本，落地后归档或删除）
  - 参数：dry-run / apply
  - 逻辑：
    1. `mkdir -p docs/i18n/{de,es,fr,hi,ja,ko,pt-BR,ru,tr,vi,zh-CN}`
    2. `git mv docs/i18n/README.<lang>.md docs/i18n/<lang>/README.md`（11 次）
    3. `git mv docs/user-guide/i18n/<skill>-guide.<lang>.md docs/i18n/<lang>/<skill>-guide.md`（88 次）
    4. `sed` 批量改 11 份 README 顶部语言切换链表（相对路径从 `README.zh-CN.md` 改为 `zh-CN/README.md`）
    5. `sed` 批量改所有 i18n 文件内"返回上级"等内部锚点
    6. `rmdir docs/user-guide/i18n`（确认空）
- [ ] 在 PR 描述里贴 dry-run 输出供 review

**验证命令**：

```bash
bash scripts/migrate-i18n.sh dry-run
# 预期：列出 99 次 mv + N 次 sed，无错误

bash scripts/migrate-i18n.sh apply
find docs/i18n -name "*.md" | wc -l
# 预期：99（11 README + 88 guide）

[ ! -d docs/user-guide/i18n ] && echo "ok"
# 预期：ok
```

---

## Task 5 — skill-lint 适配新 i18n 布局

**依赖**：Task 4 完成

**做什么**：

- [ ] `.skill-lint.json` 合并 `i18n-dir` 与 `i18n-guide-dir` 为单一 `i18n-dir: docs/i18n`，
      移除 `i18n-guide-dir` 字段
- [ ] `skills/skill-lint/scripts/skill-lint.sh` 的 `verify-i18n-structure-parity`
      改为扫 `docs/i18n/<lang>/<skill>-guide.md`（而非旧的
      `docs/user-guide/i18n/<skill>-guide.<lang>.md`）
- [ ] `evals/skill-lint/scenarios.md` 增补 i18n 单轨布局的场景
- [ ] 同步 `platforms/openclaw/skill-lint/`（如有适配版脚本）
- [ ] **重算 marketplace.json 中 skill-lint 条目的 SHA-256 hash**

**验证命令**：

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：通过

bash scripts/recalc-all-hashes.sh
git diff .claude-plugin/marketplace.json
# 预期：仅 skill-lint 一行 hash 变化
```

---

## Task 6 — 平台契约落地

**依赖**：Task 1 完成（spec 已存在于 changes/，提升到 specs/）

**做什么**：

- [ ] 在 Task 2 提升 spec 时，连同 `platform-parity/spec.md` 一起提升
- [ ] 在 README.md 的"Contributing"段增加一行引用 `platform-parity` spec
- [ ] 不动任何文件，纯契约升级

**验证命令**：

```bash
grep -n "platform-parity" README.md
# 预期：≥ 1 行
```

---

## Task 7 — 收尾全文校验

**依赖**：Task 2 - 6 全部完成

**做什么**：

- [ ] `bash skills/skill-lint/scripts/skill-lint.sh .` 全绿
- [ ] `grep -rn "user-guide/i18n" .` 零结果（旧路径全部消失）
- [ ] `grep -rn "docs/i18n/README\.[a-z]*\.md" .` 零结果（旧 README 路径）
- [ ] 11 份 README 翻译头部语言切换链表手动核对一份（zh-CN）
- [ ] 提交 PR，标题 `refactor: openspec adoption + claude-md split + i18n unification`

**验证命令**：

```bash
bash skills/skill-lint/scripts/skill-lint.sh . \
  && grep -rln "user-guide/i18n" . | grep -v "openspec/changes/archive" \
  || echo "fail"
# 预期：第二个 grep 应该为空（archive 内的历史记录除外）
```
