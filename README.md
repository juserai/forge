# J Skills

> Claude Code skill 集合 — 提升 AI agent 的能动性与交付质量

J Skills 是一组 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 插件 skill，通过行为约束和方法论让 AI agent 更可靠、更高效。

## 安装

```bash
claude plugin add juserch/jskills
```

## Skills

### Delve — 高能动性行为约束引擎

强制 AI 穷尽一切方案，不轻言放弃。参考 [PUA](https://github.com/tanweai/pua) 设计。

| 机制 | 说明 |
|------|------|
| **三条红线** | 闭环验证 / 事实驱动 / 穷尽一切 |
| **压力升级** | L0 信任 → L1 失望 → L2 拷问 → L3 绩效 → L4 毕业 |
| **五步方法论** | 闻味道 → 揪头发 → 照镜子 → 新方案 → 复盘 |
| **7项检查清单** | L3+ 强制完成的诊断清单 |
| **抗合理化表** | 14 种常见借口的识别与封堵 |
| **Hooks** | 自动挫败检测 + 失败计数 + 状态持久化 |

**使用**：

```text
/delve              # 激活 Delve 模式
/delve L2           # 从指定压力等级启动
/delve fix the bug  # 激活后立即执行任务
```

也可通过自然语言触发：`try harder`、`别偷懒`、`又错了`、`stop spinning` 等（由 hooks 自动检测）。

*更多 skill 持续添加中...*

## 项目结构

```text
jskills/
├── plugin.json                    # 项目元数据
├── .claude-plugin/
│   ├── plugin.json                # 发布元数据
│   └── marketplace.json           # Marketplace 入口
├── hooks/
│   ├── hooks.json                 # Hook 配置（挫败检测/失败计数/状态管理）
│   ├── frustration-trigger.sh     # 用户挫败情绪检测
│   ├── failure-detector.sh        # Bash 失败自动计数 + 压力升级
│   └── session-restore.sh         # 会话恢复状态
├── agents/
│   └── delve-worker.md            # Sub-agent 行为约束定义
├── commands/
│   └── <skill>.md                 # 各 skill 的 /command 入口
├── skills/
│   └── <skill>/
│       ├── SKILL.md               # 核心定义
│       └── references/            # 按需加载的详细内容
├── evals/
│   └── <skill>/
│       ├── scenarios.md           # 评估场景
│       └── run-trigger-test.sh    # 自动化触发测试
└── CLAUDE.md                      # 开发指南
```

## 贡献新 Skill

1. `skills/<name>/SKILL.md` — 核心定义（精简），详细内容放 `references/`
2. `commands/<name>.md` — `/name` 命令入口
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — 评估场景 + 自动测试
4. `.claude-plugin/marketplace.json` — `plugins` 数组追加条目
5. 如需 hooks，在 `hooks/hooks.json` 中添加对应规则

详见 [CLAUDE.md](CLAUDE.md) 开发规范。

## License

[MIT](LICENSE) - [juserch](https://github.com/juserch)
