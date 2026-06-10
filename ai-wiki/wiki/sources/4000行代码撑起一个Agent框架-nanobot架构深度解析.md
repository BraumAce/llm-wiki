---
title: "4000行代码撑起一个Agent框架？nanobot架构深度解析"
type: source
date: 2026-06-08
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/6m2ezyi119r8NLMBjsARDQ"
author: "俞孟凡"
ingested_at: 2026-06-10
tags: [nanobot, ai-agent, react-loop, skill-system, memory, subagent, mcp, lightweight-framework]
related_entities:
  - "[[Nanobot]]"
  - "[[OpenClaw]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# 4000行代码撑起一个Agent框架？nanobot架构深度解析

## 一句话概括
香港大学 HKUDS 团队的 nanobot 用 3,935 行 Python 代码实现完整 Agent 框架，核心设计是控制面集中化的 ReAct 循环 + Markdown Skill 系统 + grep 记忆，30 天获 28,500+ Star。

## 摘录

> 控制面完全集中在 AgentLoop。没有 LangChain 的 Chain/Runnable/LCEL 等编排层，没有 LangGraph 的节点/边/DAG，没有 AutoGPT 的显式 PLAN 步骤。所有决策路径都穿过同一个 while 循环。这是个极强的设计约束：可理解性最大化，但弹性空间也随之缩小。

> Skills 不是 Python 代码，而是 Markdown 文档，教 LLM 如何使用已有的 CLI 工具。系统不把所有 skill 内容塞进 system prompt，而是注入一个 XML 索引。LLM 自主决定何时需要加载哪个 skill，按需加载，不用的 skill 零 token 开销。

> "grep beats RAG for agent memory — deterministic, auditable, zero-cost, composable"

> Subagent 完成后，通过消息总线重新注入一条 InboundMessage。主 agent 像处理普通用户消息一样处理这条消息，自然地总结给用户。无需特殊的结果传递协议，无需主 agent 轮询子任务状态。

## 核心架构模式
- **ReAct 循环极简实现**：~20 行代码，错误响应不持久化（防 400 中毒循环），工具结果截断 500 字符
- **Skill-as-Markdown**：用文件系统做懒加载，XML 索引 + LLM 按需 read_file，确定性、可审计、零成本
- **虚拟工具（Virtual Tools）**：不注册到执行列表但发给 LLM 的工具定义，用 Function Calling 强制结构化输出
- **消息总线重注入**：子任务结果通过 MessageBus 注入，消除结果传递协议
- **MCP 标准桥接**：MCP 工具自动包装为原生 Tool，命名空间隔离

## 涉及实体
- [[Nanobot]] —— 3,935 行代码的极简 Agent 框架
- [[OpenClaw]] —— nanobot 的对标对象，43 万行代码
- [[Harness-Engineering]] —— nanobot 的 Skill 系统是 Harness 的极简实践

## 涉及主题
- [[Agent架构演进-主题]] —— 控制面集中化 vs 分布式编排
