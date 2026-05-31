---
title: "如何让你的 Agent 更准确：MCP 工具设计技巧"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/wpiROVdoJAHvolkEpYo20w"
author: "TRAE 团队"
published_at: "2026-03-18"
ingested_at: 2026-05-31
tags:
  - mcp
  - agent
  - tool-design
  - context-engineering
related_entities:
  - "[[Claude-Code]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 如何让你的 Agent 更准确：MCP 工具设计技巧

## 一句话概括

TRAE 团队从 LLM Tool Calling 完整链路（6 步多轮协议）切入，强调 MCP 工具是 Agent 的 UI 而非 REST API 封装，揭示工具定义占 system prompt 影响 Prompt Caching，单工具约 250-300 tokens，OpenAI 建议 ≤20 个。

## 实践内容

### Tool Calling 完整链路（6 步）

1. 用户发送消息
2. LLM 分析并决定调用工具
3. 生成工具调用参数
4. 执行工具
5. 返回工具结果
6. LLM 继续推理

### MCP 工具设计原则

**工具是 Agent 的 UI，不是 REST API 封装：**
- 工具的名称、参数、返回值都要为 Agent 优化
- 错误信息要包含修正建议
- 返回值要与下一步决策直接相关

### JSON 格式注意事项

- JSON 仅是中间格式
- 模型内部多用类 XML token
- 自定义格式不如原生 function calling

### Token 开销

- 单工具约 250-300 tokens
- OpenAI 建议 ≤20 个工具
- 工具定义影响 Prompt Caching

## 摘录

> TRAE 团队从 LLM Tool Calling 完整链路（6 步多轮协议）切入，强调 MCP 工具是 Agent 的 UI 而非 REST API 封装。

> 揭示 JSON 仅是中间格式、模型内部多用类 XML token、自定义格式不如原生 function calling；工具定义占 system prompt 影响 Prompt Caching，单工具约 250-300 tokens，OpenAI 建议 ≤20 个以避免注意力稀释与选择困难。

## 涉及实体

- [[Claude-Code]] —— Claude Code 的工具设计遵循这些原则

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

"工具是 Agent 的 UI"这个比喻很精准。单工具 250-300 tokens 的开销数据很有用——如果接 20 个工具，光工具定义就占 5000-6000 tokens。这解释了为什么 MCP server 数量需要控制。
