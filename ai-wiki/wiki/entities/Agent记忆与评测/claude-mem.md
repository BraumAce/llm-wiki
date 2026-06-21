---
title: "claude-mem"
type: entity
date: 2026-06-21
also_known_as: [Claude-Mem, claude mem]
tags: [agent-memory, claude-code, mcp, context-engineering, progressive-disclosure, hook]
sources:
  - "[[Progressive-Disclosure-Claude-Mem]]"
  - "[[Context-Engineering-for-AI-Agents]]"
related_entities:
  - "[[Progressive-Disclosure]]"
  - "[[Context-Engineering]]"
  - "[[Agent-Memory]]"
  - "[[Claude-Code]]"
  - "[[MCP]]"
  - "[[Hook-机制]]"
  - "[[Headroom]]"
related_topics: []
---

# claude-mem

## 一句话定义

claude-mem 是一个面向 [[Claude-Code]] 的记忆系统（插件），把每次编码会话沉淀为带类型、带 token 成本的「观察（observation）」，并通过 [[Progressive-Disclosure|渐进式披露]] 的索引 + [[MCP]] 检索工具，让 Agent 在新会话里按需取回历史决策与陷阱，而不是开局就被历史灌满。

## 摘要

claude-mem 的定位是「给 Claude Code 装一套低污染的长期记忆」。它不把过去的会话全量塞进新会话的上下文，而是在每次 SessionStart hook 注入一份紧凑索引：每条观察只暴露 ID、时间、类型图标、标题与 token 估算，Agent 扫描后用 MCP 工具（`search` → `timeline` → `get_observations`）三层按需取回细节。这套设计是 [[Progressive-Disclosure]] 模式的参考实现，也是 [[Context-Engineering]] 中「Just-In-Time 检索 / 上下文即货币」原则的落地。

它解决的核心问题是 Agent 记忆系统普遍的「上下文污染」：传统 RAG 式记忆在会话开始就注入几万 token 历史，真正相关的可能只占 6%。claude-mem 把开局成本压到约 1000 token 的索引，Agent 自行决定是否花约 200 token 取回单条观察，使「相关 token / 总 token」逼近 100%，把省下的注意力预算留给真正的任务。它属于与 [[Headroom]] 同类的「上下文治理工具」，但侧重点不同：Headroom 偏运行时可逆压缩，claude-mem 偏会话记忆的结构化沉淀与渐进式取回。

## 详情

### 起源与背景

claude-mem 诞生于「Claude Code 跨会话失忆」的真实痛点：编码 Agent 在一次会话里学到的设计决策、踩过的坑、放弃的方案，到了下一次会话就丢失，开发者不得不反复重述项目背景。直接的解法是把历史灌回上下文，但这又带来污染与成本问题。claude-mem 的回答是「用渐进式披露的方式做记忆」——文档原话：先展示「存在什么」及其「取回成本」，让 Agent 自己决定取回什么。据其文档，这套哲学来自数百次真实编码会话的打磨，之所以有效是因为它同时契合人类认知与 LLM 注意力机制。

### 核心机制 / 工作原理

**观察（Observation）模型**：记忆的基本单元，带 ID、时间、类型（9 类图例）、标题、token 估算、叙事正文（Narrative）、事实清单（Facts）、修改文件（Files Modified）、概念标签（Concepts）。`get_observations` 取回的完整结构示例：

```
#2543 🔴 Hook timeout: 60s too short for npm install
─────────────────────────────────────────────────
Date: Oct 26, 2025 2:14 PM
Type: gotcha
Project: claude-mem

Narrative:
Discovered that the default 60-second hook timeout is insufficient
for npm install operations ...

Facts:
- Default timeout: 60 seconds
- npm install with cold cache: ~90 seconds
- Configured timeout: 120 seconds in plugin/hooks/hooks.json:25

Files Modified:
- plugin/hooks/hooks.json

Concepts: hooks, timeout, npm, configuration
```

**SessionStart 注入 + 渐进式索引**：每次会话启动，[[Hook-机制|hook]] 注入一张按日期 / 文件路径 / 项目分组的索引表，并附带「渐进式披露使用指引」，提示 Agent 优先用 MCP 检索而非重读代码，关键类型（🔴 gotcha、🟤 decision、⚖️ trade-off）通常值得立即取回。

**三层 MCP 检索工作流**：
- `search({query, limit})` —— Layer 1，拿索引和 ID（每条约 50-100 token）。
- `timeline({anchor, depth_before, depth_after})` —— Layer 2，看某条观察前后的时序叙事。
- `get_observations({ids})` —— Layer 3，取回选中观察的完整细节。

**自适应索引（文档列出的方向）**：按会话来源调整索引规模——`startup` 显示最近 10 个会话，`resume` 只显示当前会话（微索引），`compact` 显示最近 20 个会话；并规划用 embedding 做相关性预排序、成本预估（fetching all 🔴 gotchas ≈ 450 token）等增强。

### 应用 / 使用场景

- Claude Code 长期项目：跨会话保留架构决策、bug 修复经验与「为什么放弃某方案」的取舍记录。
- 据其文档导航，claude-mem 还覆盖多种集成与能力：OpenRouter / Gemini Provider、Memory Search、Knowledge Agents、Claude Desktop MCP、Private Tags、Memory Export/Import、Manual Recovery、Folder Context Files、Endless Mode（Beta）、Cursor 集成、Gemini CLI 集成等。
- 与 [[Cursor]] 等其他编码工具配合时，作为跨工具的记忆/上下文层。

### 局限与争议

- 记忆质量依赖「观察标题」的语义压缩——标题写不好，Agent 在索引层就扫不出相关性。
- 渐进式取回比预取慢（多一次 MCP 往返），对「每次都必读」的核心约束未必划算。
- token 数为估算值（~155），用于规模直觉而非精确预算。
- 与 [[Prompt-Cache]] 的关系需留意：注入动态索引若频繁变更系统前缀，可能影响缓存命中（与 [[Headroom]] 面临的同类问题）。

## 与其他实体的关系

- [[Progressive-Disclosure]] —— claude-mem 是该模式在 Agent 记忆系统中的参考实现。
- [[Context-Engineering]] —— claude-mem 把「Just-In-Time 检索、上下文即货币」落到记忆层。
- [[Agent-Memory]] —— claude-mem 是一种具体的 Agent 记忆产品形态，强调低污染、按需取回。
- [[Claude-Code]] —— claude-mem 以插件 / hook + MCP 形态接入 Claude Code。
- [[MCP]] —— search / timeline / get_observations 三层检索通过 MCP 工具暴露。
- [[Hook-机制]] —— SessionStart hook 负责注入紧凑索引。
- [[Headroom]] —— 同为上下文治理工具，Headroom 偏运行时可逆压缩，claude-mem 偏会话记忆沉淀与渐进取回。

## 参考来源

- [[Progressive-Disclosure-Claude-Mem]]
- [[Context-Engineering-for-AI-Agents]]
