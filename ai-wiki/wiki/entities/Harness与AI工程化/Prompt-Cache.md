---
title: "Prompt-Cache"
type: entity
date: 2026-06-15
also_known_as:
  - "Prompt Caching"
  - "提示词缓存"
  - "前缀缓存"
tags:
  - ai-engineering
  - cost-optimization
  - inference
  - context-engineering
sources:
  - "[[一篇搞懂-AI-Coding-Agent的Token成本控制]]"
related_entities:
  - "[[Token成本控制]]"
  - "[[Context-Engineering]]"
  - "[[Anthropic]]"
---

# Prompt-Cache

## 一句话定义

Prompt Cache（提示词缓存）缓存的不是"答案"，而是**稳定前缀的处理结果**——如果两次请求前半段几乎一样，服务端就不必每次都从头处理那一大段相同内容，从而显著降低重复请求的输入成本和延迟。

## 摘要

Prompt Cache 是 AI Coding Agent 一切上下文优化的基础（见 [[Token成本控制]]）。很多人第一次听到缓存会以为它缓存的是回答，其实更接近的理解是：缓存稳定前缀的处理结果。最容易被缓存的内容通常是 System Prompt、Tool/MCP 定义、Skill 定义、长文档背景、稳定的 few-shot 前缀。这也是为什么官方文档总强调"静态内容放前面，动态内容放后面"——缓存命中的对象通常是**前缀**，而不是整段任意位置的拼图。[[Anthropic]] 与 OpenAI 都提到，长前缀命中缓存后，输入成本和延迟都可能显著下降。

## 详情

### 核心机制 / 工作原理

原理可以粗略理解成：

```
固定前缀 → 缓存命中 → 不用每次都从头处理
```

请求结构上把内容分三层：固定前缀（System Prompt、Skill 定义、Tool/MCP 定义、稳定背景文档）、半固定上下文（项目说明、Repo Map、Memory、长期约束）、动态上下文（聊天历史、代码片段、检索结果、工具返回、本轮新问题）。把静态内容前置、变化内容后置，本质都在提升"可复用比例"。

### 三个关键推论

1. **省的不是首次成本，而是重复成本**：第一次发送长前缀通常仍要正常付费，价值在第二次、第三次及后续多次复用时才体现。
2. **不是"写短"，而是"写稳"**：天天改 System Prompt、天天调 Skill Prompt，缓存理论上存在、实践里很难命中。
3. **缓存优化和上下文治理是一回事**：减少前缀抖动、把稳定内容前置、把变化内容后置，都在提升可复用比例。

工程实践层面，headroom 这类工具内部专门有 CacheAligner 组件来"稳定前缀、帮助 Prompt Cache 命中"。

### 应用 / 使用场景

- AI Coding Agent 的长前缀（系统提示词 + 工具定义 + 项目背景）复用
- 多轮、长会话场景下压低每轮重复输入成本
- 与上下文压缩工具配合：先稳前缀（命中缓存）再压动态内容

### 局限与争议

- 前缀频繁变动会让缓存形同虚设——稳定性是命中的前提。
- 缓存只降低重复成本，不降低首次成本，也不会让模型"更聪明"；本质是"别为同一段前缀反复买单"。
- 不同厂商的缓存粒度、命中条件、计费规则不一，需以各家官方文档为准。

## 与其他实体的关系

- [[Token成本控制]] —— Prompt Cache 是其五层优化路径中 Context 工程一层的底层依据
- [[Context-Engineering]] —— "把稳定内容前置"既是缓存命中条件，也是上下文工程实践
- [[Anthropic]] —— 官方《Prompt caching》《Token-saving updates》文档说明长前缀命中后成本与延迟下降

## 参考来源

- [[一篇搞懂-AI-Coding-Agent的Token成本控制]] —— 腾讯技术工程 devinyzeng，§1.4 Prompt Cache
