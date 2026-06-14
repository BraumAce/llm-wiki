---
title: "MCP"
type: entity
date: 2026-05-31
also_known_as:
  - "Model Context Protocol"
tags:
  - protocol
  - agent
  - tool
  - context-engineering
sources:
  - "[[你不知道的-Claude-Code-架构治理与工程实践]]"
  - "[[学习笔记-从-Agent-到-Skills-AI智能体架构的范式转变]]"
  - "[[如何让你的Agent更准确-MCP工具设计技巧]]"
related_entities:
  - "[[Claude-Code]]"
  - "[[OpenClaw-Skills]]"
  - "[[Harness-Engineering]]"
---

# MCP (Model Context Protocol)

## 一句话定义

MCP（Model Context Protocol）是 Anthropic 推出的开放标准协议，用于将外部工具、数据源和能力以标准化方式接入 AI Agent，让 LLM 能够访问 GitHub、数据库、文件系统等外部服务。

## 摘要

MCP 解决了 AI Agent 连接外部世界的标准协议问题。在 MCP 出现之前，每个 Agent 框架都有自己的工具注册方式，导致工具无法复用。MCP 定义了一套标准化的工具描述、调用和返回协议，使得同一个 MCP Server 可以被 Claude Code、OpenClaw 等多个 Agent 系统共用。

MCP 的核心设计原则是：工具是 Agent 的 UI，而非 REST API 封装。工具的名称、参数、返回值都应为 Agent 优化，而不是为人类开发者优化。单个 MCP 工具定义约 250-300 tokens，一个典型 MCP Server（如 GitHub）包含 20-30 个工具定义，合计 4,000-6,000 tokens。接 5 个 Server，光固定开销就到 25,000 tokens（占 200K 上下文的 12.5%）。

## 详情

### 起源与背景

MCP 由 Anthropic 于 2024 年 11 月开源推出，与 Skills（2025 年 10 月）和双开放标准（2025 年 12 月）共同构成 Anthropic 的 Agent 生态三步棋。MCP 的定位是解决"怎么连"的问题，而 Skills 解决"怎么用"的问题。

### 核心机制 / 工作原理

MCP 采用客户端-服务器架构：
- **MCP Client**：集成在 Agent 中，负责发现和调用 MCP Server
- **MCP Server**：暴露具体的工具能力，每个 Server 可包含多个工具

工具调用遵循 6 步多轮协议：
1. 用户发送消息
2. LLM 分析并决定调用工具
3. 生成工具调用参数
4. 执行工具
5. 返回工具结果
6. LLM 继续推理

### Token 开销问题

MCP 工具定义是上下文的最大隐形杀手：
- 单工具约 250-300 tokens
- OpenAI 建议工具总数 ≤20 个
- 超过 20 个会导致注意力稀释与选择困难

### defer_loading 机制

Claude Code 的解决方案是发送轻量级 stub（仅工具名），标记 `defer_loading: true`。模型通过 ToolSearch 发现工具，完整 schema 只在选择后才加载，避免全量工具定义占用上下文。

### 应用 / 使用场景

- **Claude Code**：通过 MCP 连接 GitHub、Sentry、数据库等外部服务
- **OpenClaw**：通过 MCP 扩展工具能力
- **企业级 Agent**：通过 MCP 标准化接入企业内部系统

### 局限与争议

- **Token 开销**：工具定义占 system prompt 影响 Prompt Caching
- **工具选择困难**：工具太多时模型容易选错
- **JSON 格式限制**：JSON 仅是中间格式，模型内部多用类 XML token
- **自定义格式**：自定义格式不如原生 function calling

## 与其他实体的关系

- [[Claude-Code]] —— Claude Code 内置 MCP 支持，通过 MCP 扩展外部工具能力
- [[OpenClaw-Skills]] —— MCP 与 Skills 分工：MCP 提供连接，Skills 提供工程直觉
- [[Harness-Engineering]] —— MCP 工具定义是 Harness 上下文管理的重要组成部分

## 参考来源

- [[你不知道的-Claude-Code-架构治理与工程实践]] —— MCP 工具定义 25K token 固定开销的详细分析
- [[学习笔记-从-Agent-到-Skills-AI智能体架构的范式转变]] —— MCP 与 Skills 的分工关系
- [[如何让你的Agent更准确-MCP工具设计技巧]] —— MCP 工具设计的最佳实践
