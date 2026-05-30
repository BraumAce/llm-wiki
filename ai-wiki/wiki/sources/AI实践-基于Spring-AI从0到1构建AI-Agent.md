---
title: "AI实践：基于 Spring AI 从0到1构建 AI Agent"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/SWVnXUpnf1eig_jBOpNsvw"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags: [spring-ai, agent, ai-agent, java, spring-boot, tool-calling]
related_entities: []
related_topics: [Agent构建与开发]
---

# AI实践：基于 Spring AI 从0到1构建 AI Agent

## 一句话概括
本文介绍如何基于 Spring AI 框架从零开始搭建一个具备工具调用能力的 AI Agent，涵盖项目初始化、模型接入、Tool 定义与 Agent 编排等完整实践流程。

## 实践内容

本文基于一个完整的 Spring AI Agent Demo 项目（github.com/q644266189/aiagentdemo），从六个核心模块剖析 AI Agent 的架构设计与实现细节。项目代码几乎由 AI 生成，作者角色为"指挥家与验收员"。

**环境要求**：Java 21+、Maven 3.9+。配置 `spring.ai.openai.base-url` / `api-key` / `chat.options.model` / `embedding.options.model` 即可启动。

### 一、AgentCore — 核心编排器

AgentCore 负责编排对话完整流程：意图识别 → RAG 注入 → 记忆管理 → 模型调用 → 工具执行。核心 `chat()` 方法先通过 `IntentRecognizer` 判断意图（RAG 或 GENERAL），若为 RAG 则检索知识库并注入上下文，再通过 `ChatMemory.getMessages()` 构建消息列表，最后调用 `ChatClient` 并传入 `ToolCallbacks`。Spring AI 的 `ToolCallAdvisor#adviseCall` 已实现 ReAct 循环：LLM 可连续调用多个工具，直到信息充足后给出最终回复。

### 二、ChatMemory — 三层上下文压缩

每个 sessionId 对应独立 ChatMemory 实例（`ConcurrentHashMap`），支持多客户端并发。三层递进压缩策略：
- **摘要压缩**：历史消息超过 16 条时，自动通过 LLM 将较早消息总结为 300 字摘要注入 system prompt，支持增量压缩并保护 TOOL 消息边界
- **Assistant 裁剪**：只保留最近 3 条 Assistant 回复，减少 token 消耗
- **滑动窗口**：消息总数超过 maxRounds×4 时丢弃最早消息，兜底保护

### 三、Tool 机制（Function Calling）

所有工具实现统一 `InnerTool` 接口（`loadToolCallbacks()`），启动时 Spring 自动扫描注册。LLM 本身不调工具，只返回"要去调哪些工具"，真实调用在 Agent 服务端完成。内置工具包括：`knowledge_search`（知识库检索）、`create_sub_agent` / `chat_with_sub_agent` / `destroy_sub_agent`（子代理管理）、`get_weather` / `get_stock_price`（示例工具）、以及动态注册的 Skill 和 MCP 工具。

### 四、RAG 模块

完整流水线：文档加载 → 分块 → 向量化 → 向量存储 → 多路召回（语义 + BM25 + 查询改写，共 9 个候选）→ RRF 融合 → Rerank 重排（取 Top 3）→ LLM 生成。分块策略支持 TextSplitter（递归语义分块，默认 500 字符 / 50 重叠）、FixedSizeSplitter、ParagraphSplitter、SentenceSplitter、SlidingWindowSplitter，以及 SemanticChunkSplitter、PropositionSplitter、AgenticSplitter 等智能分块。

### 五、Command 与 Skill

- **Skill**：YAML Front Matter + Prompt 模板，注册为 ToolCallback，LLM 根据 description 自主决策调用
- **Command**：纯 Prompt 模板，文件名即命令名，用户通过 REST API 主动指定执行

核心区别：Command 是"用户告诉 Agent 做什么"，Skill 是"Agent 自己判断该做什么"。

### 六、SubAgent — 独立记忆的子代理

每个 SubAgent 拥有独立 ChatMemory 实例（`ChatMemory.forSubAgent()`），与主 Agent 记忆完全隔离。通过 3 个工具暴露生命周期：`create_sub_agent` → `chat_with_sub_agent` → `destroy_sub_agent`，由主 LLM 通过工具调用驱动。

### 七、MCP — 连接外部服务

- **MCP Server**：通过 `SimpleMcpServer` 对外暴露知识库检索工具 `knowledge_query`
- **MCP Client**：`McpClient.connect()` 优先尝试 Streamable HTTP，失败回退 SSE，自动发现远程工具并注册。URL 持久化到 `mcp-servers.json`，重启自动重连。支持运行时通过 REST API 动态管理连接。

## 摘录

> LLM就像一个问答黑箱，不管内部支持多丰富的能力，对使用者本质只有一个能力："你问，我答"。使用者做的事情几乎是一致的：调整输入给LLM的内容，尽量让其输出预期内的内容。而对于"调整输入内容"这一块看似轻巧，实际上正是工程化发展的源泉，从Prompt Engineering到Context Engineering到Harness Engineering本质解决的就是"有限的上下文窗口中该放什么内容"。

> LLM本身不会调工具，工具调用都是Harness做的；实际上Function Calling是大地基，很多复杂能力都是作为tool的形式包装给LLM的，例如Skill与SubAgent调用。

> Command是"用户告诉Agent做什么"，Skill是"Agent自己判断该做什么"。两者互补——Command提供确定性的快捷入口，Skill提供智能化的能力扩展。

> 最好的学习资料是代码，既然我要学AI Agent开发，那就让AI Agent本身帮我生成学习资料。

> 脑暴枚举目前上下文窗口可能放的内容有：系统提示词、工具定义、历史对话、参考文档等。目前AI Agent正高速发展，最终浪淘沙到尽头什么会是最终答案不由而知，但是其中工具定义可能会走到最后。至少目前而言Function Calling是Harness的大地基，实际上很多能力的实现都是基于Function Calling，比如Skill本质就是一种Tool，而RAG、SubAgent与外部MCP服务等能力在工程实践中也大量被做成一种Tool由LLM决策调用。

## 涉及实体
- [[Spring-AI]] —— 本文基于 Spring AI 框架构建 AI Agent 的实践指南

## 涉及主题
- [[Agent构建与开发]]
