# Tasks — add-output-language-flag

## Phase 1 — Spec + 契约导航

- [x] T1.1 新建 [openspec/specs/output-language/spec.md](../../specs/output-language/spec.md)（Purpose/Behavior/Rationale/Verification 四段）
  - 验证：`test -f openspec/specs/output-language/spec.md && grep -c '^## ' openspec/specs/output-language/spec.md`（≥4）
  - 依赖：无
- [x] T1.2 复制 spec 到本 change 的 [specs/output-language/spec.md](specs/output-language/spec.md)
  - 验证：`diff -q openspec/specs/output-language/spec.md openspec/changes/add-output-language-flag/specs/output-language/spec.md`（空）
  - 依赖：T1.1
- [ ] T1.3 [CLAUDE.md](../../../CLAUDE.md) 横向能力契约表加一行：`输出语言 | output-language/spec.md | 改任何 skill 的 --lang 行为时`
  - 验证：`grep -n 'output-language/spec.md' CLAUDE.md`
  - 依赖：T1.1

## Phase 2 — 9 skill SKILL.md 加 `--lang`（canonical + mirror）

> 统一 pattern（沿用 insight-fuse flag 范式）：① argument-hint 追加 `[--lang zh-CN|en|ja|ko|fr|de|es|pt-BR|ru|tr|vi|auto]`；② help card 加 `--lang` 行；③ 行为/参数段加语义。无 hint 字段的 skill 新增 frontmatter `argument-hint`。

- [ ] T2.1 crucible 报告类：insight-fuse / council-fuse（canonical + mirror）
  - 验证：`grep -l -- '--lang' skills/insight-fuse/skills/insight-fuse/SKILL.md skills/council-fuse/skills/council-fuse/SKILL.md platforms/openclaw/insight-fuse/SKILL.md platforms/openclaw/council-fuse/SKILL.md | wc -l`（=4）
  - 依赖：T1.1
- [ ] T2.2 peer-fuse（canonical + mirror）+ 改写 [narrative-discipline.md §6](../../../skills/peer-fuse/skills/peer-fuse/references/narrative-discipline.md#L154)：默认 zh-CN，原优先级降为 `--lang auto`
  - 验证：`grep -- '--lang' skills/peer-fuse/skills/peer-fuse/SKILL.md && grep -- 'auto' skills/peer-fuse/skills/peer-fuse/references/narrative-discipline.md`
  - 依赖：T1.1
- [ ] T2.3 news-fetch（canonical + mirror）+ 改写检测规则：默认 zh-CN 模板，CJK 检测降为 `--lang auto`
  - 验证：`grep -- '--lang' skills/news-fetch/skills/news-fetch/SKILL.md platforms/openclaw/news-fetch/SKILL.md`
  - 依赖：T1.1
- [ ] T2.4 无 argument-hint 的 hammer/anvil：block-break / claim-ground / skill-lint（新增 argument-hint 字段，canonical + mirror）
  - 验证：`grep -- 'argument-hint' skills/block-break/skills/block-break/SKILL.md skills/claim-ground/skills/claim-ground/SKILL.md skills/skill-lint/skills/skill-lint/SKILL.md`（各 1 行且含 --lang）
  - 依赖：T1.1
- [ ] T2.5 subcommand 式：ralph-boost / tome-forge（hint 追加 `[--lang ...]`，canonical + mirror）
  - 验证：`grep -- '--lang' skills/ralph-boost/skills/ralph-boost/SKILL.md skills/tome-forge/skills/tome-forge/SKILL.md`
  - 依赖：T1.1
- [ ] T2.6 全量兜底：所有 canonical + mirror argument-hint 含 `--lang`
  - 命令：`grep -L -- '--lang' skills/*/skills/*/SKILL.md platforms/openclaw/*/SKILL.md`
  - 期望：无输出
  - 依赖：T2.1–T2.5

## Phase 3 — skill-lint S35（--lang 必填）

- [ ] T3.1 在 [skill-lint.sh](../../../skills/skill-lint/scripts/skill-lint.sh) S34 之后追加 S35：user-invokable skill 的 argument-hint 缺 `--lang` → error；读 `.skill-lint.json` 的 `verify-lang-flag-required`
  - 验证：`bash skills/skill-lint/scripts/skill-lint.sh . 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);print('S35' in str(d))"`（True）
  - 依赖：T2.6
- [ ] T3.2 [.skill-lint.json](../../../.skill-lint.json) 加 `"verify-lang-flag-required": "error"`
  - 验证：`grep verify-lang-flag-required .skill-lint.json`
  - 依赖：T3.1
- [ ] T3.3 [rules.md](../../../skills/skill-lint/references/rules.md) 加 S35 文档 + mirror 同步到 [platforms/openclaw/skill-lint/](../../../platforms/openclaw/skill-lint/)
  - 验证：`grep '^### S35' skills/skill-lint/references/rules.md platforms/openclaw/skill-lint/references/rules.md`
  - 依赖：T3.1

## Phase 4 — 版本锁步（9 skill MINOR bump）

> block-break 1.0.2→1.1.0 / ralph-boost 1.0.1→1.1.0 / skill-lint 1.1.2→1.2.0 / council-fuse 1.1.2→1.2.0 / news-fetch 1.1.2→1.2.0 / tome-forge 1.1.1→1.2.0 / insight-fuse 3.4.3→3.5.0 / claim-ground 1.2.2→1.3.0 / peer-fuse 0.2.1→0.3.0

- [ ] T4.1 [marketplace.json](../../../.claude-plugin/marketplace.json) 9 skill version 改 MINOR
  - 验证：`python3 -c "import json;d=json.load(open('.claude-plugin/marketplace.json'));print({p['name']:p['version'] for p in d['plugins']})"`
  - 依赖：T2.6
- [ ] T4.2 9 skill canonical + mirror help card 第一行 `v<X.Y.Z>` 同步新版本（S30）
  - 验证：`bash skills/skill-lint/scripts/skill-lint.sh . | python3 -c "import json,sys;d=json.load(sys.stdin);print([e for e in d.get('errors',[]) if 'S30' in e])"`（空）
  - 依赖：T4.1
- [ ] T4.3 [CHANGELOG.md](../../../CHANGELOG.md) 9 skill 各加 `### [X.Y.Z] — 2026-06-03` 顶条（peer-fuse / news-fetch 标注默认语言变更）
  - 验证：`bash skills/skill-lint/scripts/skill-lint.sh . | python3 -c "import json,sys;d=json.load(sys.stdin);print([e for e in d.get('errors',[]) if 'S31' in e])"`（空）
  - 依赖：T4.1

## Phase 5 — docs

- [ ] T5.1 9 个 [docs/user-guide/<n>-guide.md](../../../docs/user-guide/) 加 `--lang` 说明段
  - 验证：`grep -rl -- '--lang' docs/user-guide/ | wc -l`（≥9）
  - 依赖：T2.6
- [ ] T5.2 9 个 [docs/i18n/zh-CN/<n>-guide.md](../../../docs/i18n/zh-CN/) 加中文 `--lang` 说明段
  - 验证：`grep -rl -- '--lang' docs/i18n/zh-CN/ | wc -l`（≥9）
  - 依赖：T2.6

## Phase 6 — Verification + hash

- [ ] T6.1 重算 hash
  - 命令：`bash scripts/recalc-all-hashes.sh && git diff --stat .claude-plugin/marketplace.json`
  - 期望：第二次跑无更新
  - 依赖：T4.2
- [ ] T6.2 自检三命令全绿
  - 命令：`bash skills/skill-lint/scripts/skill-lint.sh . ; grep -rn 'output-language\|--lang' . --include='*.md' --include='*.json' | head`
  - 期望：skill-lint 无 error
  - 依赖：T6.1
- [ ] T6.3 漏网扫描：9 skill argument-hint + help card + CHANGELOG + marketplace 均含改动
  - 命令：`grep -L -- '--lang' skills/*/skills/*/SKILL.md platforms/openclaw/*/SKILL.md`
  - 期望：空
  - 依赖：T6.2

## Phase 7 — 提交 + Archive

- [ ] T7.1 commit（feat 前缀，含 spec + RFC + 18 SKILL.md + lint + marketplace + CHANGELOG + docs）
- [ ] T7.2 archive 本 change 到 [openspec/changes/archive/](../archive/)
