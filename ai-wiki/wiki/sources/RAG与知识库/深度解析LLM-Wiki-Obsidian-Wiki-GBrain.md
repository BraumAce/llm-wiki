---
title: "深度解析LLM-Wiki-Obsidian-Wiki-GBrain"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/48XpgAMHeaKYj26PrJK-hw"
author: "阿里云开发者"
ingested_at: 2026-05-29
tags: [llm-wiki, knowledge-engineering, gbrain]
related_entities: [RAG]
related_topics: [AI-Infra推理优化-主题]
---

# 深度解析LLM-Wiki-Obsidian-Wiki-GBrain

## 一句话概括
本文从知识工程角度深度解析 Karpathy 的 LLM-Wiki、Obsidian-Wiki 和 GBrain 三个项目，探讨 Agent 时代知识的"自组织"与"自进化"机制，对比传统 RAG 提出"渐进式披露"的知识管理新范式。

## 摘录
> 如果说 Prompt Engineering 是在教模型"完成什么样的任务"，那么 Knowledge Engineering（知识工程）就是在教模型"应该知道什么"以及"如何运用已知信息"。Karpathy 的 LLM-Wiki 思路之所以具有突破性，是因为它突破了传统 RAG "每次查询从头检索"的局限。通过 Schema 文件指导 LLM 主动维护结构化的 Markdown Wiki，它将原始资料"编译"为带有交叉引用、矛盾标注的持久化知识体。

> 维护知识库的繁琐部分不是阅读或思考，其实是"记账"。更新交叉引用、保持摘要最新、注意新数据何时与旧声明矛盾、维护数十个页面的一致性。人类放弃 Wiki 是因为维护负担增长得比价值更快。但是 LLM 并不会觉得无聊，也不会忘记更新交叉引用，可以一次性处理 15 个文件。Wiki 保持维护的状态，是因为维护成本接近零。

> GBrain 的架构哲学还可以用一句话概括：Thin Harness, Fat Skills。也就是建议把 Harness 做的薄一些，主要精力在丰富 Skills 上。GBrain 认为最差的 Agent 系统总是会把错误的工作放在错误的一边，它的设计思路是：让 LLM 决定"做什么"，让代码保证"在哪里"和"如何做"。

> 简而言之，如果说 RAG 是让大模型"带着书本进考场"，那么 Skillify 则是让大模型"把书读透并记成整理后的笔记"。前者依赖临场发挥、现找资料，后者依赖深厚积累、精准定位。

## 涉及实体
- [[RAG]] —— 本文对比 RAG 与渐进式披露的知识管理范式

## 涉及主题
- [[AI-Infra推理优化-主题]]
