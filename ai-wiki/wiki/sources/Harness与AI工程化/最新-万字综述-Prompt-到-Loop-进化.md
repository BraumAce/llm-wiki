---
title: "最新！万字综述 Prompt 到 Loop 进化"
type: source
date: 2026-06-29
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/hcgKahtQRE2QqI6xplv2Rg"
author: "Datawhale"
published_at: "2026-06-28 22:09:24+08:00"
ingested_at: 2026-06-29
tags:
  - prompt-engineering
  - context-engineering
  - harness-engineering
  - loop-engineering
  - agentic-engineering
related_entities:
  - "[[Loop-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Context-Engineering]]"
  - "[[Generator-Evaluator]]"
  - "[[Token成本控制]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 最新！万字综述 Prompt 到 Loop 进化

## 一句话概括

这篇文章用 `Prompt -> Context -> Harness -> Loop` 的四阶段演进，把最近一轮 AI 工程范式变化压成一条清晰主线：prompt 负责表达，context 负责给资料，harness 负责约束单次执行，loop 则把触发、执行、验证、反馈和停止条件写成可自治的工程闭环。

## 实践内容

### 四阶段演进

| 阶段 | 核心问题 | 工程含义 |
|---|---|---|
| Prompt Engineering | 怎么和模型说清楚 | 从手感调词转向问题定义、示例集、候选 prompt、实测准确率和成本权衡 |
| Context Engineering | 模型该看到什么 | 用 RAG、GraphRAG、JIT 检索、记忆和 prompt caching 组织高信号上下文 |
| Harness Engineering | 单次运行如何可靠 | 给 AI 配工具、沙箱、规则、验证、可观测性和风险控制 |
| Loop Engineering | 如何让系统自己迭代 | 用调度器、决策器、状态机、多 Agent 编排、预算和停止条件构成外部闭环 |

文章把四层的关系讲得很清楚：Prompt 和 Context 优化的是模型输入，Harness 约束的是一次执行，Loop 则改变人机协作的位置。开发者不再只是“提示词操作者”，而是设计循环系统的 Loop Designer。

### Context 层的两类关键做法

1. **JIT 检索优先于一次性灌满**：只把路径、查询、任务边界等轻量线索放进当前上下文，需要时再动态拉取材料。
2. **缓存友好上下文**：稳定前缀、工具说明和规则尽量保持不变，让 prompt caching / prefix matching 命中，避免长任务中每轮都为重复上下文付费。

这补充了 [[Context-Engineering]] 实体里已有的 token 经济学视角：上下文不是越多越好，而是越稳定、越贴近当前决策越好。

### Harness 层的四个支柱

- **环境与资产**：仓库、依赖、数据库、沙箱、测试账号、历史案例。
- **控制与编排**：任务拆解、工具权限、执行顺序、回滚路径。
- **规则中间件**：hooks、lint、CI、权限闸门、风险动作审批。
- **运行时可观测性**：日志、trace、测试结果、成本、重试次数和失败原因。

文章用 DataTalks.Club 的 `terraform destroy` 事故提醒：没有沙箱、删除保护和强风险闸门时，AI Coding 不是“提效工具”，而会变成高权限自动事故放大器。

### Loop Contract

Loop 不是“让 agent 一直跑”，而是必须签一份循环协议：

| 维度 | 要回答的问题 |
|---|---|
| `TRIGGER` | 什么事件或周期触发循环 |
| `SCOPE` | 本轮允许影响哪些仓库、文件、系统和数据 |
| `ACTION` | 本轮允许采取哪些动作，哪些动作必须人工批准 |
| `BUDGET` | token、时长、重试次数、并发数和外部 API 成本上限 |
| `STOP` | 哪些客观条件满足后必须停止 |
| `REPORT` | 停止后向人类报告什么证据、diff、日志和残留风险 |

两道安全阀尤其重要：

- **Circuit Breaker**：连续失败、运行超时、风险动作异常时立即熔断，回滚或转人工。
- **Watchdog**：独立于主进程监控自旋、CPU 满载、无 I/O 等死循环迹象，必要时强制杀进程和回收资源。

### 典型闭环流水线

```text
AI 编码 -> 沙箱测试 -> 日志自动回灌 -> AI 修复 -> CI 绿标通过 -> 自动发起 PR
```

这条线的重点不是“AI 自动写完代码”，而是每一环都能把高信号反馈带回下一轮：测试失败要回传断言和日志，CI 失败要回传失败 job，PR 前要有独立 reviewer 或规则门禁。

### 七天落地路线

文章给的最小行动路线可以压缩为：

1. 把项目入口写成短 `AGENTS.md`，明确运行、测试、提交边界。
2. 把常用 prompt 收敛成 `SKILL.md`，减少口头流程债。
3. 用 hook 接上 typecheck、lint、unit test 等可自动验收器。
4. 先跑一个小循环，例如从 issue 到测试通过的修复闭环。
5. 拆出 maker / verifier 双角色，避免生成者自评。
6. 补齐 Loop Contract 的触发、范围、预算、停止和报告。
7. 再把循环挂到 cron、automation 或 `/loop 30m` 这类调度入口上。

## 摘录

> 为了帮助大家直观的了解本节内容，我们可以将AI范式的演进历程，看作是一条沿着“教 AI 说话（Prompt Engineering） → 给 AI 资料（Context Engineering） → 帮 AI 建办公室（Harness Engineering） → 让 AI 自己打工（Loop Engineering）”脉络不断演进的AI“进化史”。

> 如果说 Harness 工程是为大模型搭建安全的系统围栏，那么 Loop Engineering则赋予了系统自主迭代的能力。随着系统从静态的、由人类单次触发的工具，演进为具备独立运行周期的自主工程，大模型在系统中的定位开始转变为受控的“子程序”。

## 涉及实体

- [[Loop-Engineering]] —— 本文补强 Loop Contract、Circuit Breaker、Watchdog 和 Loop Designer 视角。
- [[Harness-Engineering]] —— Harness 是 Loop 的下层执行围栏，决定单次运行是否安全、可验收、可审计。
- [[Context-Engineering]] —— 本文把 JIT 检索、上下文缓存和 token 成本放进 Prompt 到 Loop 的演进链。
- [[Generator-Evaluator]] —— maker / verifier 分离是闭环停止和质量判断的关键结构。
- [[Token成本控制]] —— Loop 一旦自动化，预算、缓存命中和重试上限就从优化项变成生存条件。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这篇的价值不在于提出全新概念，而在于把近期分散的 Prompt、Context、Harness、Loop 讨论整理成一条统一工程栈。最值得回灌的是“Loop Contract”这组可操作约束：它让 Loop Engineering 从一句愿景变成可以审查、可以预算、可以熔断的系统设计。
