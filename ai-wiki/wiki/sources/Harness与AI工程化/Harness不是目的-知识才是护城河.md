---
title: "Harness不是目的-知识才是护城河"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/JV4-oPP0jjsBCZ4tW3Gy1g"
author: "腾讯技术工程"
ingested_at: 2026-05-29
tags: [harness-engineering, knowledge-management]
related_entities: [Harness-Engineering]
related_topics: [Harness-Engineering-主题]
---

# Harness不是目的-知识才是护城河

## 一句话概括
本文提出Harness Engineering的核心不在工作流编排而在知识沉淀，分享了五层存储、五种类型、三级成熟度的知识分层架构设计与实践。

## 摘录
> 当 Harness Engineering 成为 2026 年最热门的 AI 工程话题，业界争论焦点集中在"该用多大的模型"还是"该搭多复杂的工作流"时，我们团队在落地实践中发现了一个被低估的事实——构建 Harness 工作流不是最终目的，私域和团队知识的沉淀才是真正的技术护城河。工作流只是管道，知识才是流过管道的活水。

> 知识分为三类：散点型知识（孤立的事实）、因果型知识（A 导致 B 的推理链）、时空型知识（特定场景和时间窗口下才成立的经验）。越是高阶的知识，越难以从模型中获得，越依赖团队的实践积累。当你的知识库有成百上千条 proven 的知识条目时，新来的成员、新启动的项目，都能"站在前人肩上"。这就是知识的复利效应。

> 我们设计了自动衰减机制——知识如果长期不被引用，会自动降级：proven 条目 12 个月未被引用降级为 verified；verified 条目 6 个月未被引用降级为 draft；draft 条目持续未引用归档移出活跃索引。知识也会过时。一条三年前的"最佳实践"，可能因为框架版本升级已经不再适用。与其让过时知识误导 Agent，不如让它自然衰减退出活跃库。

> Agent 不被动接收固定数量的知识推荐，而是通过三级渐进式索引主动按需查阅。Agent 可以用约 50 行的成本了解知识库全貌，用约 300 行的成本定位到相关条目，只在真正需要时才读取完整内容。对比"一次性推送 50 条完整知识"，上下文效率提升了一个数量级。

## 涉及实体
- [[Harness-Engineering]] —— 作为知识沉淀的载体而非目的

## 涉及主题
- [[Harness-Engineering-主题]] —— 知识分层架构与生命周期管理
