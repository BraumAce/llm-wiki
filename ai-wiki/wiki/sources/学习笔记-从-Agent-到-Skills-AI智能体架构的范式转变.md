---
title: "学习笔记：从 Agent 到 Skills — AI 智能体架构的范式转变"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/RMh2JqHwkjonPTZlwVKxsw"
author: "未知"
published_at: "2026-03-30"
ingested_at: 2026-05-31
tags:
  - skills
  - agent
  - mcp
  - context-engineering
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
---

# 学习笔记：从 Agent 到 Skills — AI 智能体架构的范式转变

## 一句话概括

以 auto-twitter-campaign 项目串讲 Anthropic「2024.11 开源 MCP + 2025.10 推出 Skills + 2025.12 双开放标准」两步棋，详解 Skills 三层渐进式披露机制和 Director-Creator-Critic 同模型多 Prompt 编排模式。

## 实践内容

### Skills 三层渐进式披露

1. **元数据层**（约 30 字）—— 预加载，用于语义匹配判断是否需要加载完整 Skill
2. **Markdown 指令层** —— 按需加载，包含完整的 SKILL.md 指令内容
3. **脚本资源层** —— 执行时访问，包含 references 和 scripts 等辅助资源

### Director-Creator-Critic 编排模式

用同模型多 Prompt 编排替代多 Agent：
- **Director** —— 负责任务分解和决策
- **Creator** —— 负责内容生成
- **Critic** —— 负责质量审查

这种模式避免了多 Agent 之间的通信开销和上下文隔离问题。

### MCP 与 Skills 的分工

- **MCP**：提供 14 个 Filesystem Tools 标准化连接，解决"怎么连"的问题
- **Skills**：提供工程直觉和最佳实践，解决"怎么用"的问题

### 原生 Skill vs MCP 封装 Skill

- **原生 Skill**：代码即能力，直接扩展 Agent 的行为
- **MCP 封装 Skill**：工具使用说明书，指导 Agent 如何使用已有工具

## 摘录

> Skills 三层渐进式披露（30 字元数据预加载 / Markdown 指令按需加载 / 脚本资源执行时访问）、Director-Creator-Critic 同模型多 Prompt 编排替代多 Agent、MCP 14 个 Filesystem Tools 标准化连接，并区分「原生 Skill 是代码即能力、MCP 封装 Skill 是工具使用说明书」。

> 以 auto-twitter-campaign 项目串讲 Anthropic「2024.11 开源 MCP + 2025.10 推出 Skills + 2025.12 双开放标准」两步棋——Skills 的出现标志着从"给 Agent 更多工具"到"给 Agent 更好方法"的范式转变。

## 涉及实体

- [[OpenClaw-Skills]] —— Skills 三层渐进式披露机制的详细解析
- [[Claude-Code]] —— Skills 在 Claude Code 中的实现和应用
- [[MCP]] —— MCP 与 Skills 的分工关系

## 涉及主题

- [[AI-Skill体系-主题]]

## 我的评注

这篇文章很好地梳理了 Skills 的演进脉络。三层渐进式披露机制是理解 Skills 设计的关键——元数据层解决"要不要加载"，指令层解决"怎么执行"，资源层解决"用什么执行"。Director-Creator-Critic 编排模式也很有启发性。
