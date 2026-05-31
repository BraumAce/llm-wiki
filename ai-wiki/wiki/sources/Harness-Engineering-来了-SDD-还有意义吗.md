---
title: "Harness Engineering 来了，SDD 还有意义吗？"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/Laz4W0180y9yGW0b6EpUMQ"
author: "腾讯云·何艺萍"
published_at: "2026-03-31"
ingested_at: 2026-05-31
tags:
  - harness-engineering
  - spec-driven-development
  - agent
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[Mitchell-Hashimoto]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# Harness Engineering 来了，SDD 还有意义吗？

## 一句话概括

腾讯云何艺萍辨析 Mitchell Hashimoto「发现 Agent 出错就工程化消除复发可能」的个人视角与 OpenAI「5 个月 100 万行代码 1500 个 PR 全由 Agent 生成」的系统视角，论证 Harness 与 SDD 不竞争而是互补：引擎越强 Spec 越重要。

## 实践内容

### AGENTS.md 设计原则

AGENTS.md 应保持 100 行目录式，不当百科全书。Spec 漂移需主动检测机制。

### Harness 与 SDD 的关系模型

Harness 把 Agent 执行力放大，Spec 在 scaffolding 中担任三个角色：
1. **Agent 推理地图** —— 指导 Agent 的推理方向
2. **语义约束基础** —— 定义 Agent 的行为边界
3. **反馈回路判据** —— 作为验证 Agent 输出的标准

核心结论：引擎越强 Spec 越重要。Harness 放大了 Agent 的执行力，但执行力的方向和约束仍然需要 Spec 来定义。

### 两种视角的对比

| 维度 | Mitchell Hashimoto 个人视角 | OpenAI 系统视角 |
|------|---------------------------|----------------|
| 核心方法 | 发现出错 → 工程化消除复发 | 大规模 Agent 生成代码 |
| 规模 | 个人项目 | 5 个月 100 万行代码 1500 个 PR |
| 关注点 | Agent 可靠性 | 系统级生产效率 |
| SDD 定位 | Harness 的补充 | Harness 的基础 |

## 摘录

> Harness 与 SDD 不竞争：Harness 把 Agent 执行力放大，Spec 在 scaffolding 中担任「Agent 推理地图 / 语义约束基础 / 反馈回路判据」三角色，引擎越强 Spec 越重要，AGENTS.md 应保持 100 行目录式不当百科全书，Spec 漂移需主动检测机制。

> 从 Mitchell Hashimoto「发现 Agent 出错就工程化消除复发可能」的个人视角与 OpenAI「5 个月 100 万行代码 1500 个 PR 全由 Agent 生成」的系统视角来看，两者并不矛盾——前者关注个体可靠性，后者关注系统级生产效率。

## 涉及实体

- [[Harness-Engineering]] —— 本文论证 Harness 与 SDD 的互补关系
- [[Spec-Driven-Development]] —— SDD 在 Harness 体系中担任推理地图、语义约束和反馈判据三角色
- [[Mitchell-Hashimoto]] —— 代表个人视角的 Harness 实践者

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这篇文章解决了一个常见的认知误区：Harness 和 SDD 不是二选一的关系。Harness 放大执行力，SDD 定义方向和约束——两者是互补的。这个观点对实际项目决策很有指导意义。
