---
title: "AI 不缺智商缺纪律：一场 / 我的 Harness 工程化实践"
type: source
date: 2026-06-16
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/2kWi0Fld09fNMVIUg9ddKQ"
alternate_urls:
  - "https://mp.weixin.qq.com/s/HoStCq53XElBlbLU6uPTJA"
author: "杜学友（阿里云开发者）"
ingested_at: 2026-06-12
updated_at: 2026-06-16
tags: [Harness-Engineering, AI-Coding, Claude-Code, 多Agent, Agent-Eval]
related_entities: [Harness-Engineering, Claude-Code, Context-Engineering, Generator-Evaluator, Agentic-Engineering]
related_topics: [Harness-Engineering-主题, Agent评测方法论, Skill开发最佳实践]
---

# AI 不缺智商缺纪律：一场 / 我的 Harness 工程化实践

## 一句话概括

AI Coding 的瓶颈正在从模型智商转向流程纪律：通过常驻入口、原子规则、角色 Agent、按需上下文、Skills/Commands/Evals、门禁与 Hook，把 AI 的随机执行改造成可约束、可恢复、可评测的 Harness。

## 实践内容

### Harness 分层结构

```
常驻入口层：CLAUDE.md + CLAUDE.local.md
- 放角色、代码偏好、流程触发规则、G1-G8 门禁速查
- CLAUDE.local.md 自包含，不依赖全局 @import
- 主会话常驻上下文压到 <= 8K

原子规则层：rules/
- build.md：禁用 mvn -am，只编译单模块
- branch-hygiene.md：提预发前必须先合 master
- code-search.md：禁 Grep 搜 Java 结构，强制走 kbase

角色 Agent 层：agents/
- dispatcher：读 state.json + workflow.yaml，决定下一步调谁
- orchestrator：读 phases/*.md，合成多角色评审结论并让用户确认
- requirement-analyst / tech-architect / quality-guardian：业务、技术、质量独立评审
- plan-generator -> developer -> verifier -> deployer -> tester：从方案到验收一岗一责

按需上下文层：context/
- TDD 指南、Pre-Mortem 模板、对抗辩论规范、证据链规范
- 只在进入对应阶段时读取，用完释放

执行支撑层：skills/ + commands/ + evals/
- skills 封装内部 CLI 和研发工具链
- commands 暴露 slash 命令入口
- evals 把 harness 自身当被测对象
```

### 主会话退化为薄控制器

```
三条铁律：
1. 主会话只听 dispatcher：dispatcher 读 state.json 返回"下一步调谁"，主会话照做，禁止自己 Read phases/*.md / evidence.json
2. 职责隔离：dispatcher 只管路由，orchestrator 只管合成，developer 只管编码，verifier 只管检查，每个 agent 的可用工具严格受限
3. 上下文 <= 8K：主会话只加载 CLAUDE.md + 触发规则 + 最近一条 dispatcher 指令
```

### 门禁与 Hook

```
G1-G8 门禁墙：
- 每个门禁是确定性的 Python 函数
- 检查产物存不存在、编译过不过、单测通没通
- verifier 写 phases/verification.json
- 任一 gate FAIL 则流程退回 DEVELOPING

Hook 拦截：
- 状态文件写操作只允许编排层 agent 触发，其他写入 reject
- 危险操作（git push --force、rm -rf）弹确认
- Hook 是实时围栏，不是事后审计
```

### 真实链路

```
主会话
-> dispatcher(读 state.json，返回"下一步调谁")
-> intent-classifier 判定意图 x 风险
-> dispatcher
-> 三角色并行评审(业务/技术/质量)
-> orchestrator 合成
-> 用户确认方案
-> dispatcher
-> plan-generator 出实施计划
-> dispatcher
-> developer 按 TDD 编码
-> dispatcher
-> verifier 跑 G1-G8 门禁
-> dispatcher
-> deployer 部署预发
-> dispatcher
-> tester 接口测试
-> 验收报告
```

### 评测平台

```
核心定位：评测平台是评估者，不是执行者。

轨道：
- /eval：多版本 x 多 case 跑分对比，管理基线
- /dev：用当前基线 harness 真实跑一个需求全链路
- /query：问题排查

七维评分：
1. 流程完整性 22%：该走的流程节点是否都走了
2. 产物质量 15%：方案文档是否有实质内容
3. 代码正确性 22%：代码能否编译，单测能否通过
4. 效率 10%：时间与 token
5. 安全合规 8%：是否违反 harness 自身规则
6. 迭代能力 5%：编译失败后能否自修
7. 接口验收 18%：真跑 ATDD 测试 + 检查接口测试证据
```

作者强调评测使用 100% Python 确定性逻辑、零 LLM 调用、三次跑分 hash 完全一致。理由是评测的目的不是语义上看起来更聪明，而是能稳定回答"这次改规范到底变好还是变坏"。LLM 评委即使更懂语义，只要存在波动，就会污染 A/B 对比。

## 摘录

> 我曾经用一个不断膨胀的CLAUDE.md解决 AI "不守纪律"的问题——把所有规矩写进去：先写单测、部署前评审、提交前合 master。它确实管用了三天。然后问题以更严重的形式回来了：规则多到撑爆上下文，模型读完规则就没"脑容量"读代码，于是它开始遗忘、串味、自我矛盾。那一刻我意识到：对付 AI 的不确定性，堆 prompt 是负债，做框架才是资产。

> Agent "遗忘"不是 bug，是当前架构的必然代价。遗忘有三重根因——压缩丢失（Auto-Compact 省略"看似不重要"的流程步骤）、检索失败（记忆文件在但没被加载进上下文）、指令遵循失败（信息都在但模型仍然跳步）。harness 的三层设计（规则外置、状态持久化、门禁阻断）恰好对应这三个根因，逐一堵漏。

> 判断：主会话应该退化成一个"什么都不想、只执行 dispatcher 指令"的纯执行器。这反直觉——我们本能地想让主模型更全能；但全能恰恰是污染之源。主会话不是能力不足，而是职责收窄——像微服务里的 thin controller，不是它不行，是它不该管。

> 核心原则：流程强制执行必须从 LLM 推理中外置到确定性基础设施。不能依赖模型"记住"该执行哪个步骤——门禁必须是确定性代码，独立于上下文窗口，fail-closed（默认拒绝，只放行显式允许的操作）。

## 涉及实体

- [[Harness-Engineering]] —— 本文核心，把 AI 该怎么干活固化成可执行、可约束、可评测的工程框架。
- [[Claude-Code]] —— 文章把 Claude Code 的文件系统记忆、Auto-Compact、Hook 机制作为重要背景。
- [[Context-Engineering]] —— 本文把上下文当预算管理，常驻极小、深层按需加载。
- [[Generator-Evaluator]] —— verifier、评测平台、门禁墙共同承担"能说不"的评判角色。
- [[Agentic-Engineering]] —— 薄主会话、状态外置、多 Agent 文件交接，是 Agentic 工程控制流设计的具体落地。

## 涉及主题

- [[Harness-Engineering-主题]]
- [[Agent评测方法论]]
- [[Skill开发最佳实践]]

## 我的评注

这篇比已有很多 Harness 文章更具体：它不只讲"要有规则和流程"，而是把失败根因拆成压缩丢失、检索失败、指令遵循失败，再分别用规则外置、状态持久化、门禁阻断去封堵。最值得沉淀的是"评测平台是评估者，不是执行者"这一边界，它能避免评测系统为了让被测系统成功而替它干活，污染真实分数。
