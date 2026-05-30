---
title: "详尽地带你从零开始设计实现一个AI Agent框架"
type: source
date: 2026-05-30
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/YAGaXOWh2GBPSNsQt5SlJg"
author: "yabohe / 腾讯技术工程"
published_at: "2026-05-30"
ingested_at: 2026-05-30
tags:
  - ai-agent
  - agent-framework
  - react
  - context-engineering
  - deepseek
  - tutorial
related_entities:
  - "[[LangChain]]"
  - "[[LlamaIndex]]"
  - "[[AutoGen]]"
  - "[[CrewAI]]"
  - "[[LangGraph]]"
  - "[[Semantic-Kernel]]"
  - "[[DeepSeek]]"
  - "[[Manus]]"
  - "[[OpenClaw]]"
related_topics:
  - "[[AI-Agent框架设计]]"
  - "[[ReAct模式]]"
  - "[[Context-Engineering]]"
  - "[[Agent-Loop]]"
---

# 详尽地带你从零开始设计实现一个AI Agent框架

## 一句话概括

腾讯技术工程团队 yabohe 撰写的 AI Agent 框架设计实战指南，从 ReAct/Plan-and-Execute/Reflection 三大理论模式讲起，对比主流框架选型，提炼出"Agent = LLM Call + Tools Call + Context Engineering"三要素模型，并用 DeepSeek + Python 实现一个极简 Agent Loop 框架，是理解 Agent 工程化落地的系统性入门读物。

## 实践内容

### Agent 框架架构图

```
┌─────────────────────────────────────────────────────────────────────┐
│                User Interface（CLI REPL Layer ）                     │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────────────┐ │
│  │  User Input  │   │    Exit/     │   │   Message History        │ │
│  │   Handler    │   │   Clear Cmd  │   │   Management             │ │
│  └──────┬───────┘   └──────────────┘   └──────────────────────────┘ │
│         │                                                           │
│         ▼                                                           │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                      Agent Loop Core                         │   │
│  │  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │   │
│  │  │   LLM Call   │───▶│ Tool Call    │───▶│   Tool Exec  │   │   │
│  │  │   (DeepSeek) │    │   Parser     │    │   Engine     │   │   │
│  │  └──────────────┘    └──────────────┘    └──────────────┘   │   │
│  │         │                                              │     │   │
│  │         │◀─────────────────────────────────────────────┘     │   │
│  │         │ (Tool Results Feedback)                            │   │
│  │         ▼                                                    │   │
│  │  ┌──────────────┐    ┌──────────────┐                       │   │
│  │  │   Response   │───▶│   Context    │                       │   │
│  │  │   Formatter  │    │   Manager    │                       │   │
│  │  └──────────────┘    └──────────────┘                       │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                    Tools Registry (TOOLS)                    │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐            │   │
│  │  │ shell_  │ │ file_   │ │ file_   │ │ python_ │            │   │
│  │  │ exec    │ │ read    │ │ write   │ │ exec    │            │   │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘            │   │
│  │      │            │            │            │                │   │
│  │      ▼            ▼            ▼            ▼                │   │
│  │  [Function]   [Function]   [Function]   [Function]          │   │
│  │  [Schema]     [Schema]     [Schema]     [Schema]            │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

### Agent Loop 工作流

```
初始上下文（系统提示词+用户请求）
    ↓
[agent loop开始]
    ↓
agent读取上下文 → 思考 → 决定行动
    ↓
执行工具/行动 → 获得结果
    ↓
结果追加到上下文
    ↓
[循环继续或结束]
```

### Agent Loop 每次迭代（Turn）细节

```
初始化上下文（用户请求）
  ↓
┌─────────────────────────────────┐
│  Agent Loop                     │
│                                 │
│  ┌─────────────────────┐        │
│  │  Turn 1              │        │
│  │  LLM Call 推理 #1            │
│  │  → 解析LLM响应        │        │
│  │  → 执行工具1          │        │
│  │  → 返回结果，更新上下文 │        │
│  └─────────────────────┘        │
│           ↓                     │
│  ┌─────────────────────┐        │
│  │  Turn 2              │        │
│  │  LLM Call 推理 #2    │        │
│  │  → 执行工具2          │        │
│  │  → 返回结果，更新上下文 │        │
│  └─────────────────────┘        │
│           ....                  │
└─────────────────────────────────┘
  ↓
完成(当某次Turn不再执行工具即表示完成)
```

### Tools 实现（4个工具函数）

- `shell_exec`：执行shell命令并返回输出
- `file_read`：读取文件内容
- `file_write`：写入文件内容（自动创建目录）
- `python_exec`：在子进程中执行Python代码并返回输出

### Tools 注册方式

手动维护字典映射 name → (function, OpenAI function schema)，以便解析 LLM call 的 response 时根据 name 匹配执行对应 tool。Tools 定义遵循 OpenAI Function Calling 标准格式。

### 框架选型建议

| 场景 | 推荐框架 |
|------|----------|
| 快速出 Agent 原型 | LangChain |
| 构建 RAG 应用 | LlamaIndex |
| 多 Agent 协作 | AutoGen 或 CrewAI |
| 复杂流程控制 | LangGraph |
| .NET 生态 | Semantic Kernel |

## 摘录

> AI智能体是使用AI来实现目标并代表用户完成任务的软件系统，具备推理、规划和记忆能力，并具有一定的自主性。ReAct模式是当前AI Agent理论中最具基础性与代表性的模式，由Yao等人于2022年在论文中提出，核心思想是将推理（Reasoning）和行动（Acting）相结合。CoT提升LLM推理能力，但缺少与外部世界的交互，ReAct弥补了这一缺陷。

> 工程层面来说，推理本质就是LLM Call，执行本质则是Tools Call（代码可认为是Tools的一种），连接二者的上下文工程（Context Engineering）是Agent框架的核心。从Manus可得出Agent工程两大业内共识：使用文件系统作为上下文（如使用文件保存Agent长期记忆）；编程是解决通用问题的普适方法（问题→生成代码→执行代码→Again→直到问题解决）。

> Agent Loop是上下文工程的核心引擎。本质是一个While循环，每次迭代是一次LLM推理外加工具调用和上下文处理，所有Agent行为都发生在这个While循环里，直到任务完成退出。简单总结：Agent应用中上下文工程大有可为。Agent框架设计的核心就是在Agent Loop这个While循环中设计如何管理上下文。

## 涉及实体

- [[LangChain]] —— 最成熟和流行的 Agent 框架，提供丰富的工具链和集成，适合快速出 Agent 原型
- [[LlamaIndex]] —— 专注于数据索引和检索，擅长 RAG 场景
- [[AutoGen]] —— 微软推出的多 Agent 协作框架，支持多 Agent 间对话和协作
- [[CrewAI]] —— 专注角色扮演型 Agent 协作框架，每个 Agent 有明确角色和目标
- [[LangGraph]] —— LangChain 团队开发的状态图框架，提供更精细的流程控制
- [[Semantic-Kernel]] —— 微软轻量级框架，与 Azure 集成良好，支持多种编程语言
- [[DeepSeek]] —— 文章实践篇使用的 LLM 提供商，采用 deepseek-chat 模型
- [[Manus]] —— Monica 发布的 Agent 产品，其首席科学家明确表示不使用 MCP，转而深耕上下文工程
- [[OpenClaw]] —— 年初火爆的 AI Agent 产品，为 Agent 带来新的想象空间

## 涉及主题

- [[AI-Agent框架设计]] —— 本文核心主题，从理论到实践系统讲解 Agent 框架设计
- [[ReAct模式]] —— 当前 AI Agent 理论中最具基础性与代表性的模式，推理+执行+观察循环
- [[Context-Engineering]] —— Agent 框架的核心变量，上下文工程管理是 Agent 智能的关键
- [[Agent-Loop]] —— 上下文工程的核心引擎，本质是 While 循环中的 LLM 推理+工具调用+上下文处理

## 我的评注

- 这篇是"工程师视角"的 Agent 框架设计指南，比纯理论文章更具实操性，但代码部分被截断，实践篇不完整
- "Agent = LLM Call + Tools Call + Context Engineering"这个三要素模型是文章的核心洞察，把复杂的 Agent 系统拆解为三个可工程化的模块
- 文章对 Manus 的引用很有价值：Manus 不用 MCP、使用文件系统作为上下文、深耕上下文工程，这些实践经验对框架选型有直接指导意义
- 框架选型建议部分简洁实用，适合架构师快速决策
