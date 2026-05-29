---
title: "腾讯云Agent-Memory节省61-Percent-Token提升52-Percent成功率"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/MSXKfefrqM31q-7WXIqCEg"
author: "腾讯技术工程"
ingested_at: 2026-05-29
tags: [memory, token-saving, mermaid]
related_entities: [Agent-Memory, OpenClaw-双源记忆系统]
related_topics: [AI-Infra推理优化-主题]
---

# 腾讯云Agent-Memory节省61-Percent-Token提升52-Percent成功率

## 一句话概括
本文提出基于上下文卸载与 Mermaid 结构化图表示的短期记忆压缩方案，通过将完整信息卸载至外部文件系统并利用 Mermaid 图语言将任务执行过程转化为可导航的结构化记忆，在超长 Session 实验中最高节省 61% Token，任务通过率相对提升 52%。

## 摘录
> 语言压缩可以理解为一个从"经验"到"符号"的映射过程：原始经验往往是连续、庞杂、充满噪音的；而语言会将其切分、筛选、抽象，并封装成较短的表达。好的表达不是信息更少，而是信息密度更高。它删除了不影响理解的枝节，却保留了能够支撑后续推理的核心语义。

> 真正可用的压缩，不应该依赖模型"记住了什么符号"，而应该依赖模型"能够从符号中推理出什么结构"。相比之下，结构化表示（如流程、关系、状态）具有更强的稳定性。它们不是把语义压缩进一个"标签"，而是把信息重组为一种可以被直接解析和推理的形式。

> 上下文卸载就是把 Agent 的工作记忆变轻：眼前只放当前要用的信息，细节放在外部，靠索引随时找回。Mermaid 无限画布改变的是 Agent 管理长任务的方式——它不要求所有信息都一直摊开放在上下文里，而是允许 Agent 把任务过程沉淀成一张外部白板。

> 压缩不是让 Agent 少知道，而是让 Agent 少背负；信息可以离开上下文窗口，但不能离开 Agent 的可达范围。

## 涉及实体
- [[Agent-Memory]] —— 本文核心介绍 TencentDB Agent Memory 产品
- [[OpenClaw-双源记忆系统]] —— Agent Memory 作为 OpenClaw 插件使用

## 涉及主题
- [[AI-Infra推理优化-主题]]
