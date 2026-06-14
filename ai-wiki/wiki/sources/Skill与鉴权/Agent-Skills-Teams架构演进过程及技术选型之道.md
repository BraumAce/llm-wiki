---
title: "Agent/Skills/Teams 架构演进过程及技术选型之道"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/Z8JYgxUdHSLo4ywgyt4ljg"
author: "阿里云·小二 Aivis 作者"
published_at: "2026-03-17"
ingested_at: 2026-05-31
tags:
  - agent
  - skills
  - architecture
  - multi-agent
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# Agent/Skills/Teams 架构演进过程及技术选型之道

## 一句话概括

阿里云小二 Aivis 作者梳理 Single Agent → Multi-Agent → Agent Skills → Agent Teams 四阶段演化本质——补偿大模型领域知识与长期记忆缺失，Skills 通过 User Prompt 渐进式披露替代 System Prompt 替换避免认知冲突。

## 实践内容

### 四阶段演进

| 阶段 | 核心思想 | 解决的问题 | 带来的问题 |
|------|----------|-----------|-----------|
| Single Agent | 单一模型处理所有任务 | 简单场景 | Context Window 限制、Lost in the Middle |
| Multi-Agent | Planner/Reasoner/Executor 分工 | 复杂任务分解 | 路由错配、通信带宽损耗 |
| Agent Skills | 标准化能力包 | 领域知识复用 | Skill 间冲突 |
| Agent Teams | 面向未知问题协同探索 | 开放式问题 | 协调复杂度 |

### Skills 的核心优势

通过 User Prompt 渐进式披露替代 System Prompt 替换，避免认知冲突：
- System Prompt 替换会导致模型"失忆"
- User Prompt 渐进式披露保持上下文连续性

### 选型建议

- **Single Agent**：简单任务、上下文窗口足够
- **Multi-Agent**：任务可明确分解、各阶段独立
- **Agent Skills**：需要复用领域知识、标准化操作
- **Agent Teams**：开放式问题、需要探索和协同

## 摘录

> 阿里云小二 Aivis 作者梳理 Single Agent → Multi-Agent → Agent Skills → Agent Teams 四阶段演化本质——补偿大模型领域知识与长期记忆缺失；Single Agent 受 Context Window 与 Lost in the Middle 制约，Multi-Agent 用 Planner/Reasoner/Executor 分工却带来路由错配与通信带宽损耗。

> Agent Skills 通过 User Prompt 渐进式披露替代 System Prompt 替换避免认知冲突，Agent Teams 面向未知问题做协同探索。

## 涉及实体

- [[OpenClaw-Skills]] —— Skills 在架构演进中的定位
- [[Claude-Code]] —— Claude Code 中的 Skills 实现

## 涉及主题

- [[Agent架构演进-主题]]
- [[AI-Skill体系-主题]]

## 我的评注

四阶段演进的梳理很有价值。Skills 通过 User Prompt 渐进式披露替代 System Prompt 替换是一个关键设计决策——避免了切换 System Prompt 导致的"失忆"问题。这个洞察对实际的 Agent 架构设计很有指导意义。
