---
title: "Spring-AI-Session-API-大多数人用ChatMemory用错了场景"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/-Tbl6fph2i8AeRIv5dgRNw"
author: "码哥跳动"
ingested_at: 2026-05-29
tags: [memory, spring-ai, session-api]
related_entities: [Agent-Memory]
related_topics: [AI-Infra推理优化-主题]
---

# Spring-AI-Session-API-大多数人用ChatMemory用错了场景

## 一句话概括
本文系统梳理 Spring AI 的两层记忆架构——短期记忆（Session API / ChatMemory）与长期记忆（AutoMemoryTools），指出大多数人只接了一层导致跨会话记忆丢失，并给出完整的双层记忆接入方案与选型建议。

## 摘录
> 绝大多数人最先碰到的是 ChatMemory，用来保存对话历史，让 LLM 知道上下文。这是短期记忆，解决的是"这一次会话里说过什么"。但另一层——长期记忆——靠的是完全不同的机制：AutoMemoryTools。它解决的是"跨会话、跨重启，Agent 要记住的那些事"。两层各司其职，缺一不可。

> AutoMemoryTools 最大的创新点是把记忆管理的决策权交给 LLM 本身，而不是用代码规则决定"什么该存"，这在长期任务场景下效果明显更好——因为 LLM 能理解语义重要性，代码规则做不到。值得注意的是，LLM 自己决定写什么，不是框架强制写。这意味着记忆质量和你用的模型能力直接相关。

> Session API 的最大创新是把"一轮对话"定义为原子单位：一条 UserMessage + 之后所有 AssistantMessage、ToolCall、ToolResult，直到下一条 UserMessage 出现。压缩时保证完整轮次要么全保留要么全丢弃，不会出现"保留了工具调用但丢掉了对应的工具结果"的情况。

> AutoMemoryTools + Session API 这个组合是目前 Java 生态里 Agent 记忆最完整的开箱方案。短期记忆解决了"这次对话不乱"，长期记忆解决了"下次还记得你"，两层各司其职，不互相替代。

## 涉及实体
- [[Agent-Memory]] —— 本文讨论 Spring AI 的记忆体系设计

## 涉及主题
- [[AI-Infra推理优化-主题]]
