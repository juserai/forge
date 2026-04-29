# Capability: category-decision

## Purpose

定义 forge 的 4 大分类（hammer / crucible / anvil / quench），并给出
**OUTPUT 形态判据** + **三元组决策**这套锋利判据，避免新增 skill 时
按"感觉相似"乱归类。本 spec 与 `skill-lifecycle` 场景 C 互锁——任何
分类调整必须重跑本 spec 的判据并写入 design 文档。

## Behavior

### 4 大分类定义

| 分类 | 锻造隐喻 | 定位 | OUTPUT 形态判据 |
|------|---------|------|---------------|
| `hammer` | 锤——施力塑形 | 主动施压、驱动执行 | **行为指令**（"必须/不许做 X"） |
| `crucible` | 坩埚——熔炼提纯 | 多源融合、知识沉淀 | **融合产出**（比输入更精炼） |
| `anvil` | 砧——承托定型 | 验证、校验、质量保证 | 对工件的 **pass/fail 判定** |
| `quench` | 淬火——冷却定性 | 休息、信息补给 | **辅助信息**或节奏调节 |

### 必填 frontmatter

每个 skill 的 SKILL.md MUST 在 frontmatter `metadata.category` 字段
声明其分类，取值 MUST 为 `hammer` / `crucible` / `anvil` / `quench`
四者之一。`metadata` 不是 Claude Code 原生字段，须放在 `metadata:` 下。

```yaml
---
name: <skill-name>
description: ...
metadata:
  category: hammer  # 或 crucible / anvil / quench
  permissions:
    network: ...
    filesystem: ...
---
```

### 三元组决策（新增或调整分类时 MUST 在 design 文档中给出）

新增 skill 或调整分类时，`docs/design/<name>-design.md` 的"设计决策"
表格里 `分类` 行 MUST 同时写明：

- **(a) 选了什么**
- **(b) 为什么不是其他三类**——逐类排除，不是泛泛"感觉不像"
- **(c) 现有同类 skill 中的兄弟是谁**——family resemblance 检查

如果找不到兄弟（c 项空），那么 SHOULD 在 README 对应分类章节专门说明
为什么开新支线；MUST NOT 默认归入空分类。

### 反例：claim-ground 早期误判

claim-ground 早期被分到 anvil（"验证事实证据"听起来像 anvil 的"验证"），
但 anvil 的成品是**被校验的工件**（skill-lint 校验 skill 文件，输出
error/warning/passed）。claim-ground **没有工件**，输出的是**行为指令**
（"必须引用 runtime 证据"）。

家族对照：claim-ground 与 block-break 都是 auto-trigger + hook + 行为约束
→ 同属 hammer。

新增/调整 skill 时 MUST 用此反例自检：先写出 OUTPUT 是什么，再用 OUTPUT
形态判据反查应归哪一类。

### 分类调整时的同步要求

参见 `skill-lifecycle` spec 场景 C 的 24 处同步点；本 spec 额外要求：

- [ ] `docs/design/<name>-design.md` 的"设计决策"表格 `分类` 行 MUST
      增加修订日期 + 新理由（保留旧理由作为历史）
- [ ] design 文档 MUST 包含三元组的更新版本（新选择的兄弟 skill 可能不同）

## Rationale

- **OUTPUT 形态判据是锋利的**：定位描述（"主动施压"/"多源融合"）容易
  套用、容易绕开；OUTPUT 形态是技术性的、可观测的，没法狡辩
- **三元组的(b)项强制逐类排除**：避免"我感觉它像 hammer"这种省略型
  论证；逐类排除强迫枚举与每一类的差异
- **三元组的(c)项 family resemblance**：哲学上的家族相似性概念，避免
  孤立分类；如果没兄弟就需要解释为什么是支线
- **claim-ground 反例必读**：上次误判已经造成 24 处修改，反例是显式
  的不应忘的教训

## Verification

### 自动化

```bash
bash skills/skill-lint/scripts/skill-lint.sh .
# 预期：cross-skill-category-claim 防线通过
#   - 所有跨 skill 分类声明在 11 种语言版本中一致
#   - 没有 skill 在某语言版本声明分类 X、在另一语言版本声明分类 Y
```

### 人工核对（新增/调整 skill 必跑）

- [ ] design 文档的"设计决策"表格 `分类` 行三元组完整（a/b/c 三项不缺）
- [ ] 三元组的(c)项给出的兄弟 skill 真的存在且 metadata.category 一致
- [ ] OUTPUT 形态自检：先写 OUTPUT 是什么，再反查应归哪一类

### 调整分类时

- [ ] 重读 claim-ground 反例
- [ ] 在 PR 描述里贴新旧分类对比 + (a)/(b)/(c) 三元组完整答复
