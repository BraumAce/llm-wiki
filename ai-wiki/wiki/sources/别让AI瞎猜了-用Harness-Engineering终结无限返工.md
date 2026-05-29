---
title: "别让AI瞎猜了-用Harness-Engineering终结无限返工"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/AFX_qsyAPBRYyqEV365O9Q"
author: "爱奇艺技术产品团队"
ingested_at: 2026-05-29
tags: [harness-engineering, database, rework]
related_entities: [Harness-Engineering]
related_topics: [Harness-Engineering-主题]
---

# 别让AI瞎猜了-用Harness-Engineering终结无限返工

## 一句话概括
本文从研发现场的实际问题出发，阐述了如何通过Harness Engineering将AI放进稳定、可协作、可验证的研发流程中，终结因信息缺失导致的无限返工。

## 摘录
> 很多返工并不是因为模型完全不会写代码，而是因为任务在交给agent之前，依据没有准备完整。页面结构还在变，状态没有补齐，接口边界没有说清，验证口径不统一，结果记录也没有固定落点。这样一来，agent只能靠上下文里零散的信息去猜。第一次也许能猜中，第二次、第三次就开始偏。代码看起来越来越多，协作成本也跟着上来了。

> Harness Engineering背后的第一性原理：当模型越来越会写代码后，瓶颈不再只是"谁来写"，而是任务有没有说清、边界有没有定住、验证能不能跑、结果有没有人接。agent能看到什么、能调用什么，决定了它实际能完成什么。无法访问的知识，基本等于不存在；无法执行的工具，基本等于没有；无法验证的目标，很难持续修正。

> 一套最小可用的harness，至少要组织起五类东西：任务约束与规则（目标、范围、非目标、验收口径）、工具执行与运行入口（Makefile、脚本、测试命令）、上下文和计划工件（AGENTS.md、docs、plan）、权限控制与失败恢复（停止条件、回滚策略）、验证评审与结果记录（runbook、review gate、PR/MR）。

> prompt解决的是这一轮怎么说清楚，harness解决的是项目里如何持续做对。从Prompt Engineering走向Harness Engineering，重点也就在这里：不只追求这一轮让模型回答得更好，而是让项目本身具备一套能支持agent反复接手、验证和回写的工作方式。

## 涉及实体
- [[Harness-Engineering]] —— 作为让AI稳定参与研发的工程安排

## 涉及主题
- [[Harness-Engineering-主题]] —— 最小可用harness与前端后端分层实践
