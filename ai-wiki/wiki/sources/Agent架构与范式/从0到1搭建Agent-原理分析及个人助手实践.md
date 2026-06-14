---
title: "从0到1搭建Agent-原理分析及个人助手实践"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/ILX8GGETM84-_rQssCZhwQ"
author: "阿里技术"
ingested_at: 2026-05-29
tags: [agent, tutorial, personal-assistant]
related_entities: [OpenClaw]
related_topics: [Agent架构演进-主题]
---

# 从0到1搭建Agent-原理分析及个人助手实践

## 一句话概括
从LLM出现到Harness的完整技术线梳理，结合个人助手项目的实战代码，覆盖记忆系统、RAG、Function Call/MCP、Agent Loop、Skill渐进式加载、Multi-Agent七种模式和Harness六大子系统，回答"LLM知道什么、能做什么、怎么做得好"三个递进问题。

## 摘录
> 回顾整条技术线，本质上是在解决三个递进的问题：1.LLM 知道什么（知识 → 记忆 + RAG 扩展）；2.LLM 能做什么（能力 → function call + MCP + skill）；3.LLM 怎么做得好（质量 → agent loop + multi agent + harness）。

> 记忆是被动的（遇到才回忆），而技能是主动的（匹配条件自动触发）。从记忆到技能的转化，就是从"被提醒才想起"变成"条件反射式执行"。Skill = SOP + 工具 + 资源。这种设计的价值在于，LLM 不是在"猜"怎么用工具，而是在"按手册操作"。

> Harness（直译"挽具/安全带"）在 Agent 领域特指：包裹在 Agent 核心循环外层的运行时保护框架。它不改变 Agent 的决策逻辑，但负责让 Agent 在真实世界中"活得够久、跑得够稳"。一个没有 Harness 的 Agent 就像没有操作系统的程序，能执行，但无法在真实环境中可靠运行。

## 涉及实体
- [[OpenClaw]] —— 文中引用OpenClaw作为Agent框架实践参考

## 涉及主题
- [[Agent架构演进-主题]]
