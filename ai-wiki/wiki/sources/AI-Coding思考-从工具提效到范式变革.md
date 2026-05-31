---
title: "AI Coding思考：从工具提效到范式变革，我们还缺什么？"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/4AXThfVLmhSXeRWK1gh4dA"
author: "淘天天猫·书牧"
published_at: "2026-03-02"
ingested_at: 2026-05-31
tags:
  - ai-coding
  - spec-driven-development
  - enterprise
related_entities:
  - "[[Spec-Driven-Development]]"
  - "[[Claude-Code]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# AI Coding思考：从工具提效到范式变革，我们还缺什么？

## 一句话概括

用「目标传达复杂度 × 执行复杂度」四象限指出企业级研发的 AI Coding 瓶颈不在 Agent 执行而在人向 AI 传达任务的信息熵过高，必须通过四层专家知识体系化沉淀实现系统性降熵。

## 实践内容

### 四象限分析

| 目标传达复杂度 | 执行复杂度 | 场景 | AI 适用性 |
|---------------|-----------|------|----------|
| 低 | 低 | 简单 CRUD | 高 |
| 低 | 高 | 技术实现 | 中 |
| 高 | 低 | 业务规则 | 中 |
| 高 | 高 | 企业级研发 | 低（瓶颈） |

### 四层专家知识体系

1. **基础技术** —— 编程语言、框架、工具
2. **业务架构** —— 领域模型、业务流程
3. **团队规范** —— 编码规范、架构约定
4. **代码仓库** —— 现有代码、历史决策

### 降熵路径

通过四层专家知识体系化沉淀，实现系统性降熵，最终打通需求-设计-编码-验收全链路 SDD。

### 终极目标

把程序员从打字员推向产品工程师与业务架构师。

## 摘录

> 淘天天猫书牧用「目标传达复杂度 × 执行复杂度」四象限指出，企业级研发的 AI Coding 瓶颈不在 Agent 执行而在人向 AI 传达任务的信息熵过高。

> 必须通过基础技术、业务架构、团队规范、代码仓库四层专家知识体系化沉淀实现系统性降熵，最终打通需求-设计-编码-验收全链路 SDD，把程序员从打字员推向产品工程师与业务架构师。

## 涉及实体

- [[Spec-Driven-Development]] —— SDD 是降熵的关键手段
- [[Claude-Code]] —— Claude Code 是 SDD 的执行层

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

"信息熵"这个概念很精准地描述了企业级 AI Coding 的瓶颈。问题不在于 AI 不够聪明，而在于人无法有效地把复杂的业务需求传达给 AI。四层专家知识体系化沉淀是一个系统性的解决方案。
