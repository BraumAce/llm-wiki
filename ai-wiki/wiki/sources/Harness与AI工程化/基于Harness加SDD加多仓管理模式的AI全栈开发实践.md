---
title: "基于Harness加SDD加多仓管理模式的AI全栈开发实践"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/ygQGSH5c7GHYDvkqWoQTXQ"
author: "得物技术"
ingested_at: 2026-05-29
tags: [harness-engineering, sdd, full-stack]
related_entities: [Harness-Engineering, Spec-Driven-Development]
related_topics: [Harness-Engineering-主题]
---

# 基于Harness加SDD加多仓管理模式的AI全栈开发实践

## 一句话概括
本文介绍了得物技术团队基于Harness思维、SDD规范驱动开发和多仓管理模式的AI全栈开发实践，通过给AI提供模仿对象而非凭空创造来提升代码采纳率。

## 摘录
> 全栈 SDD 开发中，最常见也最致命的错误是：让 AI 从零开始写代码。AI 模型具备"通识能力"，给它一个需求描述，它确实能生成可运行的代码。但问题在于，这些代码往往是"外星代码"：风格不一致、复用率低、采纳率低。结果就是：AI 生成了代码，但 Review 成本和返工成本反而更高了。

> Harness（约束）思维的本质是：给 AI 一个已有的实现作为参照，让它照着复刻一份，而不是凭空创造。就像给一个新入职的工程师说"你照着这个模块的风格，写一个类似的"，而不是"你自由发挥"——前者往往能更快产出符合团队规范的代码。两者的差距不在于 AI 是否"聪明"，而在于你给了 AI 多少约束和上下文。约束越精准，生成代码的可用性越高。

> 前后端代码通常分布在两个独立仓库。如果分开打开，AI 生成后端接口时看不到前端的调用方式，生成前端代码时看不到后端的返回结构，接口字段对不上是家常便饭。将前后端代码放在同一个工作区下，有三个核心价值：Codebase Indexing 跨仓库理解代码关系、上下文完整保证接口字段自然对齐、SDD 文档集中管理便于接口契约对齐。

> 通过本文介绍的"Harness + SDD + 多 Agent"全栈开发方法论，原本前后端 2+4 人日需求，在这种模式下，算上环境准备、踩坑时间、联调自测时间，压缩至 3 人日，提效 50%+。AI 全栈学习成本骤降，只需掌握入门级别前后端知识，即可介入简单全栈需求开发。

## 涉及实体
- [[Harness-Engineering]] —— 作为给AI提供模仿对象的约束思维
- [[Spec-Driven-Development]] —— SDD驱动的全栈代码生成流程

## 涉及主题
- [[Harness-Engineering-主题]] —— Harness思维在全栈开发中的应用
