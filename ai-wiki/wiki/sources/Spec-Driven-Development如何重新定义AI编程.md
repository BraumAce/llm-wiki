---
title: "Spec-Driven-Development如何重新定义AI编程"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/hVizUucsy8rwFOUR-VZ6wA"
author: "阿里云开发者"
ingested_at: 2026-05-29
tags: [sdd, spec-driven, ai-coding]
related_entities: [Spec-Driven-Development, Harness-Engineering]
related_topics: [Harness-Engineering-主题]
---

# Spec-Driven-Development如何重新定义AI编程

## 一句话概括
SDD（Spec-Driven Development）将规格说明作为唯一真实来源，代码作为其派生产物，通过在DAY 0投入一天写Spec，让5人团队在7天内完成了传统20人数周的工作量，为AI编程时代提供了从"让AI变聪明"到"让AI变可控"的工程方法论。

## 摘录
> DAY 0：不写一行代码，只写 Spec。团队没有急着打开 IDE，而是花了一整天做四件事——定义 MVP 边界、拆解模块、为每个模块撰写 Spec、将所有 Spec 汇入 Repo Wiki。这一天的产出是零行代码，但它决定了后面六天的一切。

> SDD 位于 Context Engineering 和 Harness Engineering 的交叉地带。从 Context Engineering 的角度看，Spec 就是一种高度结构化的上下文提供方式——它不是把所有代码丢给 AI（那太嘈杂），也不是只说一句话（那太模糊），而是提供了一个"恰到好处"的信息密度。

> Spec 写得好不好直接决定代码质量。因为 AI 不会追问你"这个边界情况怎么处理"，它只会按照你给的上下文尽力推断——推断对了是运气，推断错了是 Bug。

> 差异的本质：好 Spec 是可测试的，坏 Spec 是可解释的。"系统应该很快"给了 AI 无限的解释空间——它可能选择一个"对它来说够快"的实现。"P95 < 200ms"则是一个硬约束，AI 必须确保实现满足这个指标，否则就是 fail。

## 涉及实体
- [[Spec-Driven-Development]] —— 以规格说明为唯一真实来源的AI编程方法论
- [[Harness-Engineering]] —— SDD是HE的重要应用模式，constitution.md是约束层

## 涉及主题
- [[Harness-Engineering-主题]]
