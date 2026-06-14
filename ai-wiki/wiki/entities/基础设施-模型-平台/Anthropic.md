---
title: "Anthropic"
type: entity
date: 2026-05-31
also_known_as:
  - "Anthropic PBC"
tags:
  - company
  - ai
  - llm
sources:
  - "[[你不知道的-Claude-Code-架构治理与工程实践]]"
  - "[[Claude-Code-源码拆解-从启动到多Agent扩展层]]"
related_entities:
  - "[[Claude-Code]]"
  - "[[MCP]]"
  - "[[OpenClaw-Skills]]"
  - "[[Harness-Engineering]]"
---

# Anthropic

## 一句话定义

Anthropic 是一家专注于 AI 安全的人工智能公司，由前 OpenAI 成员于 2021 年创立，开发了 Claude 系列大语言模型和 Claude Code、MCP 等 AI 工程工具。

## 摘要

Anthropic 由 Dario Amodei 和 Daniela Amodei（前 OpenAI 研究副总裁和安全政策副总裁）于 2021 年在旧金山创立。公司以"构建安全、可靠、可解释的 AI 系统"为核心使命，提出了 Constitutional AI（宪法 AI）等创新的安全对齐方法。

Anthropic 的产品线包括：
- **Claude 系列模型**：Claude Opus、Sonnet、Haiku 等不同能力层级的大语言模型
- **Claude Code**：命令行 AI 编程助手，是 Harness Engineering 的标杆实现
- **MCP（Model Context Protocol）**：开放标准协议，用于将外部工具和数据源接入 AI Agent
- **Skills**：标准化的能力封装机制，让 Agent 按需加载领域知识

在 AI 工程领域，Anthropic 推动了从 Prompt Engineering 到 Context Engineering 再到 Harness Engineering 的三次范式进化。Claude Code 的设计哲学（CLAUDE.md 四级注入、三层上下文压缩、Hooks 机制）深刻影响了 2026 年的 AI 工程实践。

## 详情

### 起源与背景

Anthropic 的创始团队来自 OpenAI，包括前研究副总裁 Dario Amodei 和前安全政策副总裁 Daniela Amodei。他们因对 AI 安全方向的分歧而离开 OpenAI，创立了 Anthropic。公司获得了 Google、Salesforce、Spark Capital 等机构的投资。

### 核心技术

- **Constitutional AI**：通过预定义的"宪法"原则指导 AI 行为，而非依赖人类反馈
- **Claude 系列模型**：从 Claude 1 到 Claude 4，持续提升能力和安全性
- **Prompt Caching**：通过前缀匹配机制优化 API 调用成本
- **Tool Use / Function Calling**：标准化的工具调用协议

### AI 工程生态

Anthropic 在 2024-2026 年间构建了完整的 AI 工程生态：
- 2024 年 11 月：开源 MCP（Model Context Protocol）
- 2025 年 10 月：推出 Skills 机制
- 2025 年 12 月：MCP + Skills 双开放标准
- 2026 年：Claude Code 成为 AI Coding Agent 领域的标杆产品

### 应用 / 使用场景

- **AI 编程**：Claude Code 用于日常编程、长任务执行、Harness 工程化
- **企业级 AI**：通过 MCP 和 Skills 标准化接入企业系统
- **AI 安全研究**：Constitutional AI、RLHF 等安全对齐方法

### 局限与争议

- **闭源模型**：Claude 系列模型不开源，与 Meta、Mistral 等的开源策略形成对比
- **API 依赖**：所有产品都依赖 Anthropic API，存在供应商锁定风险
- **成本问题**：Claude Opus 等高端模型的 API 成本较高

## 与其他实体的关系

- [[Claude-Code]] —— Anthropic 开发的命令行 AI 编程助手
- [[MCP]] —— Anthropic 推出的开放标准协议
- [[OpenClaw-Skills]] —— Anthropic 推出的 Skills 机制
- [[Harness-Engineering]] —— Anthropic 推动的 AI 工程范式

## 参考来源

- [[你不知道的-Claude-Code-架构治理与工程实践]] —— Claude Code 的六层架构拆解
- [[Claude-Code-源码拆解-从启动到多Agent扩展层]] —— Claude Code 源码分析
