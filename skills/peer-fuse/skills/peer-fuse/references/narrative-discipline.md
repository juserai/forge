# § Document Reading — Narrative Discipline (6 rules)

由 [templates/document-reading.md](../templates/document-reading.md) 引用。本文件把 narrative-reading 风格的 6 条隐式纪律编码为可执行规则 + lint regex + few-shot 锚点。能力来源：用户 14 份手工产出的 `wiki/notes/*-narrative.md` 解读，原本规划为独立 skill `prose-fuse / lectio`，自 peer-fuse v0.2.0 起融入 Stage 3.5。

> Stage 3.5 主线程在写完 § Document Reading 后，对照本文件 6 条 discipline 做自检。Discipline 1-2、4-6 违规 → **warn-only**（打印 violations 行号 + 规则号，不阻断 Stage 4）；Discipline 3 渲染禁用 (block quote / 「」 / 编号引用) → **fail-closed**（污染严重）；现行评审隔离禁词 (grade / score / flag / 字母 grade / `F-XXX-NN` / 评价节引用) 沿用现行 fail-closed。

---

## 1. Opening discipline — contextual 开场

### 禁起手 pattern（Para 1 不得以下列正则匹配的句式开头）

```
^这份报告(说|讲|提到|认为|声称)
^本(报告|文章|文档)(说|讲|是|为)
^In this report,?\s+we
^The report (states|argues|claims|finds)
^This report (discusses|examines|presents)
```

### 推荐句式锚点

```
^这份(?:N 行|YYYY-MM-DD 的)?(工件|报告|合并版|落盘版)本质上是…
^这份 YYYY-MM-DD 的工件是一份典型的 <type> 体例研究报告…
^This is a (overview|technology|market|academic|product|competitive) artifact compiled by …
```

### 必有要素

Para 1 必须含三件事：
1. **artifact 定位**——它是哪一类研究工件（overview / technology / market / academic / product / competitive）+ 由什么 engine / 在什么 depth 模式下编译
2. **核心 thesis 浓缩**——它在做什么 / 它**不是**在做什么
3. **报告自我边界**——退一步去做的那件"更有意义的事"是什么

### Few-shot 样本（来自 wiki/notes/）

> 这份报告本质上是一份"AI Native 全景总纲"的合并版——以 2026-04-17 全模式调研为底本，叠加 3 天后的刷新增量。它不是要给"AI Native"下一个权威定义，而是承认这个术语本身仍在收敛中，然后退一步去做更有意义的事：把判别标准、驱动力、范式切换、产业切面、代表玩家和未来开放问题全都摊在同一张图上，让读者自己去判断手里这个产品到底站在谱系的哪一格。

> 这份 2026-05-06 的工件是一份典型的 overview 体例研究报告——insight-fuse v3 在 depth=full 模式下编译，自评 B+ (7.8/10)、13/14 blocking checks pass。它处理的不是一个新问题——AI 幻觉自 2022 年起就被反复研究——而是要把过去三年这个领域里**已经收敛的部分**和**仍在分裂的部分**清晰分开。

---

## 2. Closing discipline — meta-reflective 收束

### 末段必含 meta-reflective 标志短语之一（regex）

```
整(份|体)读(下来|完)
读完整份(.+)会发现
把(.+)并起来读会发现
posture
epistemic stance
知识(姿态|承诺)
```

### 禁纯结论复读

末段**不得**只是把 §1-N 的论点重新列一遍。必须**对报告本身的姿态做 meta-评论**：
- 它的知识承诺是什么（"知道边界" / "拒绝合成" / "守住开放问题"）
- 相对其他姊妹报告的位置（"和 X / Y 共享同一种知识姿态"）
- 它选择**承认什么 / 守住什么 / 拒绝合成什么**

### Few-shot 样本

> 整体读下来，这份报告最值得保留的不是某个数字或某条结论，而是它的**态度**：它不急着把 AI Native 这个词钉死成定义，而是承认它正在演化，并用 Remove-it Test、四条曲线、五个切换、六个切面、七条 checklist、八个开放问题这样层层嵌套的脚手架，把这个仍在流动的概念暂时固定成一张可被验证、可被反驳、可被刷新的地图。

> 整份报告读完会发现，它和姊妹报告——AI Native overview 与 eval-fullstack——共享同一种知识姿态：**承认领域仍在流动，并把"已收敛"和"仍分歧"的边界画得尽量清晰**。

---

## 3. Verbatim quote discipline

| 维度 | 规则 |
|---|---|
| 全文上限 | ≤ 4 处 verbatim |
| 单段上限 | ≤ 1 处 verbatim |
| 渲染（中文） | `**verbatim phrase**`（bold 内嵌） |
| 渲染（英文） | `_verbatim phrase_`（italic 内嵌） |
| 单条长度 | ≤ 40 字 |
| 位置标记 | ≥ 1 处带 `§X.Y` / `p.X` / `slide.N` / `L<line>`（按 `target_format` 适配） |

### 禁用渲染（**fail-closed**）

```
^>\s             # block quote 起行
「[^」]*」      # CJK 「」 引号
"[^"]{20,}"     # 长 ASCII 双引号块（>20 字）
^\s*\d+\.\s+    # 编号引用列表
```

### Verbatim 选择策略（优先级从高到低）

1. 源报告**用粗体或加引号**的短语
2. 单独成立的 thesis 句
3. 反直觉数字组合（如"33% reasoning 模型反向 scaling"）
4. 第三方权威评语（如 "InfoQ 定性为 'protocol hardening'"）

### 禁选

- ❌ 整段引用（>2 行）
- ❌ 长度 >40 字 verbatim
- ❌ 无信息密度的客气话（"这份报告很全面" / "this report is comprehensive"）
- ❌ 已 paraphrase 但仍标 verbatim 的伪引

---

## 4. Number-density discipline

| 段类型 | numeric anchor 密度（每段） |
|---|---|
| 技术 / 证据 / 数据段 | 8-15 个 |
| Framing / posture / 元解读段 | ≤ 5 个 |

### 抽样验证

Stage 3.5 末尾随机抽 30%-70% 段落计 numeric anchor 数（含百分比 / 日期 / 金额 / 倍数 / 模型名带数字如 GPT-5.4）。期望分布**双峰**：
- 30%-50% 段落 ≥ 8 个 → 数据段
- 30%-50% 段落 ≤ 5 个 → framing 段
- 单峰（全 ≥ 8 或全 ≤ 5）→ warn

### Why

连贯散文需要**呼吸感**：纯数据段密集落数字让读者有"重量感"，framing 段抽离数字让叙事松开。读者在浓缩段—数据段—posture 段间切换节奏。

---

## 5. Limitation-as-strength rule

### 限制条款必须前缀归因短语

报告里的 OOS / coverage gap / hypothesis 未证实状态 / partial confirmation 等限制信息，必须**显式标记是源报告自承**：

| 允许前缀 | 例 |
|---|---|
| `报告自承` | "报告自承的四项 coverage gap…" |
| `§N 自承的` | "§5 自承的'缺少 2026 年的 2×2×2 控制实验'…" |
| `the report explicitly flags` | (英文) |
| `报告标 X 为 …` | "报告把 H1 标为'未推翻但需重表述'…" |
| `self-reported as …` | (英文) |

### 外部反驳必须显式声明

reviewer 自己引入的批评或外部反驳必须前缀：
- ✅ `这是外部观察，非报告主张` / `这是 reviewer 注` / `[external observation, not the report's claim]`
- ❌ 不加声明地引入外部反驳 → 污染评审-描述隔离

### Why

limitation-as-strength 是 narrative-reading 的核心姿态——把"自承空白"读成"知道边界"，而不是评审者自己加的批评。这是 Stage 3.5 与 Stage 5.5 § Holistic Assessment（评价性）保持隔离的关键纪律。reviewer 在 § Document Reading 写"§5 自承的 coverage gap"是描述事实；在 § Holistic Assessment 写"the coverage gap is a serious concern"是评价——只有后者才属 § Holistic Assessment。

---

## 6. Output language — `--lang` 决定（默认 zh-CN）

评审报告（含 § Document Reading）的输出语言由 `--lang` 决定，契约见
[openspec/specs/output-language/spec.md](../../../../../openspec/specs/output-language/spec.md)。

### 判定优先级

1. **显式 `--lang <code>`**（`code ≠ auto`）→ 强制该语言
2. **不带 `--lang`** → **`zh-CN`**（hard default；**覆盖**源文档语言）
3. **`--lang auto`** → 恢复"按源"检测：
   1. 源报告 frontmatter `lang` / `language` 字段（若有）
   2. 正文段落主导语言：中文字符 (Unicode `一-鿿`) 比例 ≥ 50% → 中文；否则英文
   3. fallback 中文

### 一致性

- 目标中文 → § Document Reading 全中文叙事（允许 inline 英文术语 / arXiv 论文标题保留原文）
- 目标英文 → § Document Reading 全英文叙事
- 其它语言（ja/ko/fr/…）→ 全目标语言叙事，inline 术语 / 论文标题保留原文
- **禁混合**：不要多语穿插长句，会破坏 narrative 连贯性

---

## Lint 模式总表

| Discipline | 规则示例 | 模式 |
|---|---|---|
| 1 Opening | `^这份报告说` | warn-only |
| 1 Opening | Para 1 缺 artifact 定位 | warn-only |
| 2 Closing | 末段无 meta-reflective 短语 | warn-only |
| 2 Closing | 末段纯结论复读 | warn-only（人工抽查） |
| 3 Verbatim 上限 | 全文 verbatim > 4 | warn-only |
| 3 Verbatim 渲染 | block quote `>` / 「」 / 编号引用 | **fail-closed** |
| 3 Verbatim 长度 | 单条 > 40 字 | warn-only |
| 4 Number-density | 单峰分布 | warn-only |
| 5 Limitation | 限制条款无 `自承` 前缀 | warn-only |
| 5 Limitation | 未声明的外部反驳 | warn-only（人工抽查） |
| 6 Language | 输出语言不匹配源 | warn-only |
| 评审隔离禁词 | grade / score / flag / 字母 grade / `F-XXX-NN` / 评价节引用 | **fail-closed**（沿用 v0.1.0） |

**初版策略**：Discipline 1-2、4-6 + Discipline 3 数量上限 = warn-only，便于收集 false-positive；Discipline 3 渲染禁用 + 评审隔离禁词 = fail-closed，因为这两类违规直接污染评审-描述隔离与文档可读性，无可妥协。

收集 1-2 个版本周期的 false-positive 数据后，再决定哪些 warn-only 升级到 fail-closed。
