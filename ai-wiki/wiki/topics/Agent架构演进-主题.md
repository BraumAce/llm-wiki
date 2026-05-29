---
title: "Agent 架构演进主题"
type: topic
date: 2026-05-29
tags:
  - agent
  - architecture
  - evolution
  - multi-agent
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
  - "[[OpenClaw-SandBox]]"
  - "[[Agent-Memory]]"
  - "[[Harness-Engineering]]"
sources:
  - "[[Agent核心技术概念与范式发生了哪些演变]]"
  - "[[从0开发大模型的17种Agent架构演进详细拆解]]"
  - "[[从0到1搭建Agent-原理分析及个人助手实践]]"
  - "[[Agent从一问一答到自主执行面临哪些挑战]]"
  - "[[从语言涌现到协作涌现-如何让AI产生高质量决策]]"
  - "[[大模型Agent-Skill功能在LLM-HTTP底层交互流中怎么承载]]"
  - "[[让Skill自己训练自己-8阶段Loop-3层评测-5维AND门控]]"
  - "[[当我把AI变成一个算法-Skill工程化设计的心路历程]]"
  - "[[平平无奇的源码竟藏着Agent的核心秘密]]"
  - "[[深度解析LLM-Wiki-Obsidian-Wiki-GBrain]]"
  - "[[从零设计生产级Multi-Agent-Harness]]"
---

# Agent 架构演进主题

## 主题定义

Agent 架构演进涵盖 AI 智能体从简单的"一问一答"到复杂的"自主执行"的技术演进路径。包括控制流设计、知识管理、记忆系统三大维度的递进。

## 核心要点

1. **控制流是本质**：Agent 演进的本质是控制流设计而非 prompt engineering。从 Reflection、Tool Use、ReAct、Planning 到多 Agent 编排——每种架构新增的是 State 字段、路由逻辑和失败模式
2. **Skill 成为知识封装的基本单位**：无论是 OpenClaw 的 SKILL.md 还是各种框架的 Plugin/Tool/Action，本质上都是把领域知识打包成可热插拔的单元
3. **Skill 不是协议层概念**：从 LLM HTTP 底层视角看，Skill 最终被编译为 System/Developer Message + Tools Definition + Multi-turn Tool Calling Loop
4 **记忆从"存对话"到"版本控制"**：Agent Memory 的演进方向是分层、压缩、可检索、可遗忘
5. **从一问一答到自主执行的鸿沟**：定时任务、高可用、统一管理、权限、可观测——这些"无聊的工程问题"才是 Agent 走向生产的关键瓶颈
6. **上下文编排 vs 流程编排**：Agent Room 协作模式让多个角色在同一上下文场中交互，形成涌现式集体判断
7. **OpenClaw 的 16 大模块是完整的工程参考**：覆盖了 Agent 工程的所有关键维度

## 涉及实体

- [[OpenClaw]] —— Agent 架构的典型实现
- [[OpenClaw-Skills]] —— Skill 机制的具体实现
- [[OpenClaw-SandBox]] —— 安全隔离子系统
- [[Agent-Memory]] —— Agent 记忆系统
- [[Harness-Engineering]] —— Agent 从"能跑"到"可靠"的框架

## 对比矩阵

| 维度 | 单 Agent | Multi-Agent | Agent + Harness |
|------|---|---|---|
| 复杂度 | 低 | 中 | 高 |
| 可靠性 | 低 | 中 | 高 |
| 适用场景 | 简单任务 | 复杂任务分解 | 生产级系统 |

## 关键来源

- [[从0开发大模型的17种Agent架构演进详细拆解]] —— 17种架构完整拆解
- [[Agent核心技术概念与范式发生了哪些演变]] —— 范式演变梳理
- [[从0到1搭建Agent-原理分析及个人助手实践]] —— 从零搭建指南
