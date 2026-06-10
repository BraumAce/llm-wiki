---
title: "Nanobot"
type: entity
date: 2026-06-10
also_known_as:
  - "nanobot"
  - "HKUDS nanobot"
tags:
  - ai-agent
  - lightweight-framework
  - react-loop
  - open-source
sources:
  - "[[Nanobot-OpenClaw轻量实现的底层原理解析]]"
  - "[[4000行代码撑起一个Agent框架-nanobot架构深度解析]]"
related_entities:
  - "[[OpenClaw]]"
  - "[[Harness-Engineering]]"
  - "[[OpenClaw-Skills]]"
  - "[[MCP]]"
  - "[[ReAct]]"
---

# Nanobot

## 一句话定义

Nanobot 是香港大学数据科学实验室（HKUDS）开源的极简 AI Agent 框架，用不到 4,000 行 Python 代码重建 OpenClaw 的核心能力——Agent 循环、长期记忆、技能加载、多平台接入。

## 摘要

Nanobot 于 2026 年 2 月初开源，30 天内获得 28,500+ GitHub Stars。它的核心价值不在于替代 OpenClaw，而在于提供了一个可以被完全理解的 Agent 实现——43 万行代码的系统很难看清全貌，但 4,000 行的版本可以。

架构设计的核心特征是**控制面集中化**：所有决策路径穿过同一个 while 循环，没有 Chain/Runnable/LCEL、没有 DAG、没有显式 PLAN 步骤。这是极强的设计约束——可理解性最大化，弹性空间随之缩小。

最独特的设计是 **Skill-as-Markdown**：Skills 不是 Python 代码而是 Markdown 文档，通过文件系统做懒加载（XML 索引 + LLM 按需 read_file），不用的 skill 零 token 开销。记忆系统采用 "grep beats RAG" 策略，两个 Markdown 文件 + exec grep，不用向量库。

## 详情

### 核心架构
- **Agent Loop**：~20 行 ReAct 循环，错误响应不持久化（防 400 中毒循环），工具结果截断 500 字符
- **Message Bus**：45 行代码的 asyncio.Queue 解耦，支持 13 个聊天平台
- **Tool 系统**：Python 抽象类，execute 强制返回 str，JSON Schema 手写
- **Skill 系统**：Markdown 文档 + XML 索引 + Progressive Loading
- **记忆系统**：MEMORY.md（长期事实）+ HISTORY.md（对话摘要）+ grep 搜索
- **Subagent**：asyncio.Task 委托，结果通过消息总线重注入，无 message/spawn 工具（防递归）
- **MCP 集成**：自动包装为原生 Tool，命名空间隔离

### 设计取舍
| 优势 | 代价 |
|------|------|
| 可理解性极强 | 弹性空间有限 |
| Skill-as-Markdown 零成本扩展 | skill 数量大时 XML 索引占满 context |
| grep 记忆确定性可审计 | 企业规模时文件搜索力不从心 |
| 工具接口统一（全返回 str） | 结构化数据需内部序列化 |
| 错误恢复委托给 LLM | 弱模型上可能无效循环 |

### 适用场景
- 个人自托管 AI 助手
- 快速原型 / 学习 Agent 架构
- 不需要精确多 agent 协调的场景
