---
title: "串讲LLM和Agent的核心原理以及各种术语"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/i3yKCZCUtDkTrk4hFZz7NQ"
author: "labuladong"
ingested_at: 2026-05-29
tags: [llm, agent, tutorial, terminology]
related_entities: [OpenClaw]
related_topics: [Agent架构演进-主题]
---

# 串讲LLM和Agent的核心原理以及各种术语

## 一句话概括
本文从零串讲 LLM 和 Agent 的核心原理，涵盖概率预测、Instruct 模型、思维链、Function Calling、MCP、Agent 循环、Skills 等关键概念，帮助读者建立对 AI 编程工具生态的完整认知框架。

## 摘录
> AI 写代码的效果同时取决于两件事：LLM 模型本身的能力，以及围绕模型的 Agent 工程实现。两者都够强，才能有最好的效果，任何一方拉胯，最终效果都不尽如人意。我们说的 Qwen、Claude、DeepSeek 等模型属于 LLM，Cursor、Antigravity、Claude Code 等 AI 编程工具属于 Agent。

> Agent 的核心思路很简单：把 LLM + Tool Use 放进一个循环里。模型在循环中不断地"思考 → 行动 → 观察结果 → 再思考"，这个模式在学术上叫 ReAct（Reasoning + Acting）。它和人类解决问题的方式其实很像：你不会一上来就知道怎么做，而是先看看情况，试一下，看看结果，再决定下一步。

> 回头看我们讲的所有内容，你会发现一个贯穿始终的事实：不管是思维链、Tool Use、Agent 循环、MCP 工具描述还是 Skills 文档，最终都要塞进上下文窗口里，交给同一个概率模型去一个字一个字地往外蹦。没有任何魔法，全部都是文本，全部都靠那个"预测下一个 token"的概率模型在驱动。

> Skills 就是把一套完整的操作流程写成文档，Agent 按文档一步一步执行。Anthropic 在 Skills 的加载上有一个巧妙的设计叫渐进式披露（Progressive Disclosure）。启动时只告诉模型每个 Skill 的名字和一句话简介，等模型发现当前任务和某个 Skill 相关了，再加载更多的内容。

## 涉及实体
- [[OpenClaw]] —— 文中提及 OpenClaw 作为 Agent 框架示例

## 涉及主题
- [[Agent架构演进-主题]]
