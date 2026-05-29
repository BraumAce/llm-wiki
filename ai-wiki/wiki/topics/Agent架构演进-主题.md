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
  - "[[Agent架构演进-从ReAct到Multi-Agent-Harness]]"
  - "[[Agent-Memory系统-从上下文压缩到版本控制]]"
  - "[[Skill自进化与工程化设计]]"
  - "[[ByteLighting-2026年5月技术阅读合集]]"
  - "[[以OpenClaw为例介绍AI-Agent的运作原理]]"
  - "[[深入理解OpenClaw技术架构与实现原理-上]]"
  - "[[深入理解OpenClaw技术架构与实现原理-下]]"
---

# Agent 架构演进主题

## 主题定义

Agent 架构演进涵盖 AI 智能体从简单的"一问一答"到复杂的"自主执行"的技术演进路径。包括控制流设计（ReAct → Planning → Multi-Agent）、知识管理（Prompt → Skill → Harness）、记忆系统（无状态 → 短期 → 长期持久化）三大维度的递进。不包括单纯的 LLM 推理优化或基础 NLP 技术。

## 核心要点

1. **控制流是本质**：Agent 演进的本质是控制流设计而非 prompt engineering。从 Reflection、Tool Use、ReAct、Planning、多 Agent 编排到 Blackboard 共享黑板——每种架构新增的是 State 字段、路由逻辑和失败模式
2. **Skill 成为知识封装的基本单位**：无论是 OpenClaw 的 SKILL.md、Claude Code 的 slash command、还是各种框架的 Plugin/Tool/Action，本质上都是在做同一件事——把领域知识打包成可热插拔的单元
3. **Skill 不是协议层概念**：从 LLM HTTP 底层视角看，Skill 最终被编译为三种协议原语的组合：System/Developer Message、Tools Definition、Multi-turn Tool Calling Loop
4. **记忆从"存对话"到"版本控制"**：Agent Memory 的演进方向是分层、压缩、可检索、可遗忘。Memoir 把 Git 的 branch/commit/merge/rollback 搬进记忆层，是最大胆的探索
5. **从一问一答到自主执行的鸿沟**：定时任务、高可用、统一管理、权限、可观测——这些"无聊的工程问题"才是 Agent 走向生产的关键瓶颈
6. **上下文编排 vs 流程编排**：传统 DAG/Planner-Executor 是预定义流程；Agent Room 协作模式让多个角色在同一上下文场中交互，形成涌现式集体判断
7. **OpenClaw 的 16 大模块是完整的工程参考**：Gateway 网关、Agentic Loop、工具系统、Channels、记忆管理、Skills、SandBox、自进化机制——覆盖了 Agent 工程的所有关键维度

## 涉及实体

- [[OpenClaw]] —— Agent 架构的典型实现，16 大模块的完整工程案例
- [[OpenClaw-Skills]] —— Skill 机制：6 源加载 + 优先级覆盖 + 菜单注入 + 自主选择
- [[OpenClaw-SandBox]] —— 安全隔离子系统，决定"什么工具能在哪里跑"
- [[Agent-Memory]] —— Agent 记忆系统：从上下文压缩到版本控制
- [[Harness-Engineering]] —— Agent 从"能跑"到"可靠"的关键框架

## 演进时间线

- 2023：ReAct（推理+行动）成为 Agent 基础范式
- 2024：Tool Use + Function Calling 标准化，MCP 协议出现
- 2025：Skill 封装 + 多 Agent 编排成为主流，OpenClaw 等框架成熟
- 2026-Q1：Harness Engineering 概念兴起，Agent 从"能跑"到"可靠"
- 2026-05：记忆系统成为新前沿（腾讯云 4 层管道、Memoir 版本控制）

## 对比矩阵

| 维度 | 单 Agent | Multi-Agent | Agent + Harness |
|------|---|---|---|
| 复杂度 | 低 | 中 | 高 |
| 可靠性 | 低（单点故障） | 中（需协调） | 高（可审计、可回滚） |
| 适用场景 | 简单任务 | 复杂任务分解 | 生产级系统 |
| 记忆需求 | 短期 | 中期（跨 Agent 共享） | 长期持久化 |
| 典型实现 | ChatGPT | CrewAI / AutoGen | OpenClaw / Claude Code + Harness |

## 关键来源

- [[Agent架构演进-从ReAct到Multi-Agent-Harness]] —— 5+ 篇文章的综合演进梳理
- [[Agent-Memory系统-从上下文压缩到版本控制]] —— 3 种记忆方案对比
- [[Skill自进化与工程化设计]] —— Skill 从静态到自进化
- [[以OpenClaw为例介绍AI-Agent的运作原理]] —— OpenClaw 入门教程
- [[深入理解OpenClaw技术架构与实现原理-上]] / [[深入理解OpenClaw技术架构与实现原理-下]] —— OpenClaw 源码级总览
