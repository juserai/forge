# Design — add-output-language-flag

影响分类：**cross**（横切全部 4 分类——crucible / quench / hammer / anvil 的
user-facing 输出语言）。新增 spec [output-language](../../specs/output-language/spec.md)。

## 设计决策

### 1. Hard zh-CN default（不是 flag-wins-else-keep）

- **选了什么**：不带 `--lang` → 一律 `zh-CN`，覆盖任何 skill 原生检测；原生检测降级为 `--lang auto` 显式 opt-in。
- **为什么不是 flag-wins-else-keep**：后者下 peer-fuse 评审英文文档默认仍出英文（[narrative-discipline.md:160](../../../skills/peer-fuse/skills/peer-fuse/references/narrative-discipline.md#L160) fallback 才是中文），与"默认中文"诉求直接冲突。
- **反例验证**：用户跑 `/peer-fuse <英文 paper>` 不带 flag，hard default 下得到中文评审（符合预期）；flag-wins 下得到英文（违背）。代价：这是 peer-fuse / news-fetch 的**默认行为变更**，CHANGELOG 需显式标注。

### 2. 宽枚举 12 + auto（不是最小集 zh-CN/en/auto）

- **选了什么**：复用仓库 11 个历史语言（zh-CN + en + 9 归档）+ auto。
- **为什么不是最小集**：报告输出语言 ≠ docs 翻译。docs 收敛到 zh-CN 单轨是因翻译文件有维护成本（[i18n-layout](../../specs/i18n-layout/spec.md)）；LLM 即时输出某语言**无翻译文件可维护**，宽枚举边际成本为零。
- **反例验证**：最小集下"输出日语报告"无法表达，但 LLM 完全有能力——人为设限无收益。

### 3. 复用 locale 码（不是 ISO-639-1 两字母）

- **选了什么**：`zh-CN` / `pt-BR` 带 region，与 `docs/i18n/` + `docs/i18n-archived/` 目录名一致。
- **为什么不是 `zh`/`pt`**：避免全仓出现 `zh` 与 `zh-CN` 双标准。
- **反例验证**：若用 `zh`，则 docs 用 `zh-CN`、flag 用 `zh`，grep/认知都要做映射。

### 4. 全 skill 覆盖（含无 argument-hint 的 3 个）

- **选了什么**：block-break / claim-ground / skill-lint **新增** `argument-hint` 字段以承载 `--lang`；ralph-boost / tome-forge 在 subcommand 式 hint 后追加 `[--lang ...]`。
- **为什么不是只报告类**：用户明确要求"所有 skill"。非报告类的 `--lang` 控制其指导文本 / 诊断信息语言，语义自洽。
- **反例验证**：若漏掉 3 个无 hint skill，S35（见决策 6）会报 error，契约不闭合。

### 5. `auto` 作为哨兵恢复原生检测

- **选了什么**：`--lang auto` 不是某语言，而是"恢复 skill 既有检测"。
- **为什么需要**：hard zh-CN 默认会"埋掉" peer-fuse 按源 / news-fetch 按输入的有用能力；auto 让这些能力可显式找回，不删代码。

### 6. skill-lint S35 使契约可执行（不是只靠纪律）

- **选了什么**：S35 对每个 `user-invokable: true` skill 断言 argument-hint 含 `--lang`，缺失 error。三态配置 `verify-lang-flag-required`（off/warn/error），上线即 error（本 change 同步把所有 skill 改齐，无遗留问题，可直接刚性）。
- **为什么不是 warn 过渡**：与 S34 不同——S34 上线时有 4 个已知未修问题故先 warn；本 change 把 9 skill 一次改齐，无遗留，直接 error 不会误红。
- **反例验证**：未来新增 skill 忘加 `--lang` → 自检三命令第一条直接 fail，挡在 PR 前。

## 受影响清单

- **新增**：
  - [openspec/specs/output-language/spec.md](../../specs/output-language/spec.md)
  - [openspec/changes/add-output-language-flag/](.)（本 change 三件套 + spec 副本）
- **修改**：
  - 9 canonical `skills/<n>/skills/<n>/SKILL.md`：argument-hint + help card + 行为段 + help 版本行
  - 9 mirror `platforms/openclaw/<n>/SKILL.md`：同步（语义一致）
  - `skills/peer-fuse/.../references/narrative-discipline.md`：Rule 6 改写
  - `skills/news-fetch/.../SKILL.md`：检测规则改写
  - `skills/skill-lint/.../scripts/skill-lint.sh` + `references/rules.md`：S35 实现 + 文档（+ mirror）
  - `.skill-lint.json`：`verify-lang-flag-required: "error"`
  - `.claude-plugin/marketplace.json`：9 skill version MINOR bump + hash 重算
  - `CHANGELOG.md`：9 skill 各加 entry
  - `CLAUDE.md`：横向契约表加 output-language 行
  - `docs/user-guide/<n>-guide.md` + `docs/i18n/zh-CN/<n>-guide.md`：`--lang` 说明
- **不动**：hook 脚本；KB 归档逻辑；docs/i18n 其它语言

## Verification

```bash
grep -L -- '--lang' skills/*/skills/*/SKILL.md platforms/openclaw/*/SKILL.md   # 期望空
bash skills/skill-lint/scripts/skill-lint.sh .                                  # 期望全绿
bash scripts/recalc-all-hashes.sh && git diff --stat .claude-plugin/marketplace.json
```
