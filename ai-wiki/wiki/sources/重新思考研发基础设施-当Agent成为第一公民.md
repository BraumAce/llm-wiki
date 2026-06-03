---
title: "重新思考研发基础设施-当Agent成为第一公民"
type: source
date: 2026-06-03
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/fOONHtYDAJ39BojQxJ2-qg"
author: "晓斌（阿里巴巴研发基础设施负责人）"
ingested_at: 2026-06-03
tags: [infra, agent-oriented, harness, credential-brokering, dry-run, dx]
related_entities: [Harness-Engineering, Agent-Oriented-Infra, Credential-Brokering, Agent-DX, Agentic-Engineering]
related_topics: [Harness-Engineering-主题, Agentic-Engineering-主题]
---

# 重新思考研发基础设施：当 Agent 成为第一公民

## 一句话概括
作者从一个周报系统出发，提出"意图驱动 + 代码沉淀"的统一框架，指出 Agent 没有改变软件进化的基本结构但把循环速度从月级压缩到分钟级，原有 infra 因此系统性失配，需要从 People-Oriented 重建为 Agent-Oriented 的四层设计原则。

## 摘录

> 无论是传统研发还是 agent 研发，软件系统一直都是由"意图（不确定性）驱动 + 代码（确定性）沉淀"的进化体。这个模式从未改变，改变的只是驱动和沉淀的速度与机制。

> Agent 的自主程度是 infra 安全能力的函数。传统 infra 的设计是 People-Oriented 的：安全靠人的自我约束加事后审计。面向 agent 的 infra 设计是 Agent-Oriented 的：安全靠机制化保证——资源归属、权限管控、dry-run、分级策略、自动回滚。给 infra 补能力，而非给 agent 加限制。

> 阻碍 agent 自主操作的瓶颈不在 agent 侧——agent 的能力足够完成这个操作。瓶颈在 infra 侧——没有资源归属治理，没有 dry-run，没有分级策略，回滚能力不足。Agent 能不能自主操作，不取决于 agent 有多聪明，而取决于 infra 提供了多强的安全护栏。

> 人的角色分工是一种天然的关注点分离，把身份碎片化的复杂度屏蔽在了各自的工作边界内。Agent 打破了角色边界——一个 delivery agent 要 git clone（SSH）、研发 CLI 提 MR（统一鉴权）、操作中间件配置（中间件身份）、查监控（监控平台身份）——它一个"角色"横跨了原来多个人类角色的身份体系。

## 实践内容

### "意图驱动 + 代码沉淀"的三个推论

1. **Agent 不是革命，是加速** — 没有改变软件进化的基本结构，只是把"意图 → 代码"的循环速度提高了几个数量级
2. **静态沉淀不会消失** — 用一个巨大的概率模型去逼近一个已经确定的函数，在信息论意义上是荒谬的浪费。Agent 占比呈锯齿形
3. **模式对基础设施的要求彻底变了** — Git 假设每次变更都值得 commit；CI/CD 假设构建和部署是离散事件；Code Review 假设有人来看每一行代码

### 三个关键变量（乘法效应）

| 变量 | 传统 | Agent 时代 |
|------|------|-----------|
| 桥梁带宽 | 人（周/月级） | Agent（分钟级） |
| 沉淀粒度 | 持久化代码 | 瞬态代码 + 沉淀代码分化 |
| 循环频率 | 离散发布 | 连续演化 |

### 四层设计原则（Agent-Oriented Infra）

1. **可理解（Comprehensible）** — 概念自洽、完整、不依赖口口相传。复杂度不是问题，不一致才是。运行环境自描述（manifest / devcontainer）
2. **可操作（Operable）** — dry-run/preview、幂等重试、隔离执行（sandbox）、凭证不进 sandbox（vault/egress proxy）、渐进信任、回滚能力
3. **可感知（Observable）** — 沉默和含糊是 agent 的敌人。状态 API 可查、结构化、实时。每次响应提供足够语义信息
4. **可追溯（Traceable）** — 状态可恢复（snapshot/checkpoint）、过程可回放。Agent 的失败模式是 infra 设计缺陷的放大器

### Harness 概念

Agent 需要的"完整工作环境"包括：
- 本次任务的 workspace 和目标 repo
- 前序环节已产出的 artifact 和上下文
- 本任务允许的工具和外部副作用范围
- 隔离的凭证和身份配置
- 对应的 skill 和 prompt
- 沟通和 handoff 通道

### Credential Brokering 范式

Agent 发出请求时携带占位符（如 `__github_token__`）而非真实凭证，broker 认证 agent 身份后将占位符替换为真实凭证转发请求，agent 全程未见到真实凭证。

趋同实现：Anthropic（Managed Agent Infrastructure）、Vercel（Sandbox 凭证注入）、Cloudflare（Outbound Workers）、LangChain（Sandbox Auth Proxy）

### Agent 行为驱动的 Infra 质量度量

- Agent 反复重试某个 API → 反馈语义不足
- 调用顺序混乱 → 前置条件没有显式化
- 频繁格式转换 → 接口不可组合
- 用错身份 → 身份体系碎片化

## 涉及实体

- [[Harness-Engineering]] —— Harness 概念与平台化
- [[Agent-Oriented-Infra]] —— 面向 Agent 的基础设施设计原则
- [[Credential-Brokering]] —— Agent 凭证代理模式
- [[Agent-DX]] —— Agent 开发者体验
- [[Agentic-Engineering]] —— Agent 工程化
