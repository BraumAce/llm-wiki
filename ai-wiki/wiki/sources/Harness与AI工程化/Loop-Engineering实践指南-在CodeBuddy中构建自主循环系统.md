---
title: "Loop Engineering 实践指南：在 Code Buddy 中构建自主循环系统"
type: source
date: 2026-06-22
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/YqIyL7uW4EV2r5HLDW7wcA"
author: "腾讯程序员（腾讯技术工程）/ eliqiao"
published_at: "2026-06-22"
ingested_at: 2026-06-22
tags:
  - loop-engineering
  - ai-engineering
  - agent-orchestration
  - CodeBuddy
related_entities:
  - "[[Loop-Engineering]]"
  - "[[CodeBuddy]]"
  - "[[ReAct]]"
  - "[[Addy-Osmani]]"
  - "[[MCP]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# Loop Engineering 实践指南：在 Code Buddy 中构建自主循环系统

## 一句话概括

腾讯技术工程把 Addy Osmani 提出的 Loop Engineering 落到腾讯自家编程工具 [[CodeBuddy]] 上：先讲清 Loop Engineering 与 [[ReAct]] 是「Outer Loop 套 Inner Loop」的关系，再给出 `/goal`（条件驱动）、`/loop`（时间驱动）、Automations（跨会话定时）三种循环驱动模式，以及 Team 模式、Skills、MCP、Rules+Memory 如何一一对应 Loop Engineering 的六要素，并配 6 个可复制的实践片段。

## 实践内容

### Loop Engineering vs ReAct：Inner Loop / Outer Loop 的关系

```
Loop Engineering（Outer Loop）
┌─────────────────────────────────────────────────────┐
│  目标拆解 → 任务分配 → 结果汇总 → 再计划              │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │  ReAct（Inner Loop）                             │ │
│  │  思考 → 行动 → 观察 → 思考 → 行动 → 观察 ...     │ │
│  └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘

ReAct 解决「单次任务内怎么一步步做」
Loop Engineering 解决「跨任务做什么、谁来做、何时停、怎么续」
```

ReAct 与 Loop Engineering 的核心差异对比：

| 维度 | ReAct | Loop Engineering |
|------|-------|------------------|
| 关注层次 | 单次任务的执行过程 | 跨任务的编排与调度 |
| 循环粒度 | 细粒度（单步工具调用） | 粗粒度（整个任务周期） |
| 状态管理 | 依赖上下文窗口内记忆 | 状态外置到文件/数据库，每次迭代全新上下文 |
| 停止条件 | 模型自己判断"做完了" | 独立评估器验证可度量条件 |
| 验证机制 | 自我检查（同一模型） | 对抗验证（不同模型/独立评估器） |
| 错误恢复 | 在同一上下文内重试 | 断点续跑，可跨会话恢复 |
| 并行能力 | 单 Agent 串行 | 多 Agent 并行 + 工作树隔离 |
| 运行周期 | 单次对话 | 可持续数小时甚至数天 |

四层栈的演进关系：`Prompt Engineering（怎么问）→ ReAct（怎么做，单任务内推理-行动循环）→ Loop Engineering（怎么管，跨任务的编排、验证、状态管理）`。

### `/goal` —— 条件驱动的持续工作

```bash
# 基本语法
/goal <完成条件>

# 实际示例
/goal all tests in test/auth pass and the lint step is clean

# 加兜底上限防止无限循环
/goal all tests pass or stop after 20 turns

# 非交互模式（headless 运行）
codebuddy -p "/goal CHANGELOG.md has an entry for every PR merged this week"
```

写好条件的三个关键要素：可度量的终态（`all tests in test/auth pass`）、可证明方式（`npm test` exits 0 / `git status` is clean）、不可破坏的约束（`no other test file is modified`）。

评估机制：每轮结束后由独立小模型评估器判断条件，三态结果：

- ✅ `ok: true` —— 条件已满足，清除 goal，UI 显示 ✔ Goal achieved
- 🔄 `ok: false` —— 条件未满足，reason 注入 history，继续下一轮
- ❌ `ok: false, impossible: true` —— 目标不可达，立即清除 goal

> 关键设计：评估器使用小模型（如 gemini-2.5-flash），快速且便宜，只看 transcript 不调用工具。评估器与执行 Agent 使用不同模型，天然形成对抗验证。条件不超过 4000 字符（`/goal` 硬性限制）。

### `/loop` —— 时间驱动的循环任务

```bash
# 语法
/loop [时间间隔] <指令>

# 检查 CI/CD 流水线状态
/loop 3m 检查一下流水线是否跑完，把结果告诉我

# 定时运行单元测试
/loop 30m 帮我运行一次单元测试，如果有失败的用例告诉我

# 每小时汇总代码审查待办
/loop 1h 看一下有没有新的 PR 需要我审查
```

`/loop` 约束：最小间隔 1 分钟；每会话上限 50 个任务；3 天后自动过期；生命周期为会话级（退出后消失）；只在会话空闲时触发。

### Automations —— 跨会话的定时任务

持久化的定时任务，不随会话消失。`Recurring`：按 cron 规则重复（如 `FREQ=HOURLY;INTERVAL=1`）；`Once`：指定时间点一次性触发。

三种驱动方式对比：

| 方式 | 下一轮何时开始 | 何时停止 | 适用场景 |
|------|---------------|---------|----------|
| `/goal` | 上一轮结束后立即 | 评估器确认条件满足 | 有明确终态的实质性工作 |
| `/loop` | 时间间隔触发 | 主动停或模型判定结束 | 监控、巡检、定期检查 |
| Automations | 按 cron 规则 | 永久或设有效期 | 跨会话的长期监控 |

### Loop Engineering 六要素 → CodeBuddy 映射

| Loop Engineering 要素 | CodeBuddy 实现 | 说明 |
|------|------|------|
| 自动化（循环心跳） | `/goal`、`/loop`、Automations | 三种驱动模式覆盖不同场景 |
| 工作树（并行隔离） | Git worktree + Team 模式 | 多 Agent 并行开发互不干扰 |
| 技能（SKILL.md） | Skills 机制 | 固化项目知识，避免冷启动 |
| 连接器（MCP） | [[MCP]] 协议 | 打通 issue、CI、数据库等工具链 |
| 子智能体（对抗验证） | Task 工具 + Team 模式 | 规划者/执行者/评审者三角分工 |
| 状态文件 | Memory、CODEBUDDY.md、Rules | 跨会话知识持久化 |

### 实践片段：Skills 固化项目知识

```markdown
---
name: project-conventions
description: 项目编码规范和架构约定
---

## 架构约定
- 所有 API 调用必须经过 service 层，controller 不直接调用 repository
- 数据库查询必须使用参数绑定，禁止字符串拼接 SQL
- 错误处理遵循统一异常体系...

## 命名规范
- Service 类以 Service 结尾
- Repository 类以 Repository 结尾
```

### 实践片段：MCP 连接器打通工具链

```json
{
  "mcpServers": {
    "jira": {
      "command": "mcp-jira",
      "args": ["--project", "MYPROJ"]
    },
    "jenkins": {
      "command": "mcp-jenkins",
      "args": ["--url", "https://ci.example.com"]
    }
  }
}
```

接入后可在 `/goal` 循环中直接读取 Jira issue、运行验证：`/goal all issues labeled "bug" in current sprint have a corresponding test that passes, or stop after 50 turns`。

### 实践片段：模块迁移的 /goal 条件写法

```bash
/goal all tests in test/auth pass, `npm run build` exits 0, no file in auth/legacy is imported anywhere, or stop after 30 turns
```

四个子句分别对应：可度量终态（auth 测试通过）、可证明方式（build exits 0）、不可破坏约束（旧目录不再被引用）、兜底上限（30 轮停止）。CodeBuddy 据此自动跑 Discover → Plan → Execute → Verify → Iterate 闭环。

## 摘录

> Loop Engineering 的解法是：让人从循环内部的操作者，转变为循环之上的监督者和目标设定者。你定义"做什么"和"何时算完成"，AI 自己决定"怎么做"和"下一步是什么"，直到目标达成或确认不可达。当模型能力足够强时，循环设计成为决定 AI 自主性与可靠性的关键瓶颈——一个设计良好的循环可以让 AI 连续工作数十轮完成复杂重构，而一个设计糟糕的循环可能在第三轮就失控。

> Loop Engineering 不是要替代 ReAct，而是在 ReAct 之上增加编排层。在 CodeBuddy 中，当你用 `/goal` 设置一个条件时，每一轮内部 AI 仍然使用 ReAct 模式来思考和行动，但 `/goal` 的评估器在 Outer Loop 层面判断整体进度——这就是两层循环的协作。Loop Engineering 的一个关键设计原则：所有状态存储在外部系统，而非模型的上下文窗口。每次循环迭代从一个全新的上下文窗口开始，基于实际持久化内容工作，这彻底解决了模型遗忘、信息漂移与上下文压缩问题。

> 避免常见陷阱：验证责任不可转移（无人值守的循环也是无人值守地犯错，关键变更仍需人工 Code Review）；理解债务加速累积（代码库真实状态与开发者理解之间的鸿沟随循环加速扩大）；认知投降风险（开发者极易停止独立判断，系统给什么就接受什么）；Token 成本约束（设置 stop after N turns、用小模型评估器）。

## 涉及实体

- [[Loop-Engineering]] —— 本文主题，给出在 CodeBuddy 上的具体落地映射
- [[CodeBuddy]] —— 承载 Loop Engineering 的腾讯 AI 编程工具，提供 `/goal`、`/loop`、Automations、Team 模式
- [[ReAct]] —— 被定位为 Loop Engineering 的 Inner Loop（单任务内推理-行动循环）
- [[Addy-Osmani]] —— Loop Engineering 概念的提出者
- [[MCP]] —— 作为「连接器」要素打通 issue/CI/数据库工具链

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这是目前看到的把 Loop Engineering 从「理念/橙皮书」直接落到某个具体工具命令面（`/goal` `/loop` Automations）的少数实践文之一，价值在于把抽象的「五动作/六要素」翻译成可复制的命令与条件写法。其中「`/goal` 评估器用小模型（gemini-2.5-flash）、与执行 Agent 不同模型形成对抗验证」与 [[Generator-Evaluator]] 结构呼应；「Inner/Outer Loop」框架则补齐了 [[ReAct]] 与 [[Loop-Engineering]] 长期被混谈的边界。
