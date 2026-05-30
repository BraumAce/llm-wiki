---
title: "Nanobot（OpenClaw 轻量实现）的底层原理解析"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/O8dOafau9EGxMmLllLRq-A"
author: "vivo AI技术开发团队 - Lin Weiwei"
ingested_at: 2026-05-30
tags: [openclaw, nanobot, ai-agent, lightweight-implementation, prompt-engineering]
related_entities:
  - "[[OpenClaw]]"
  - Nanobot
related_topics:
  - AI Agent 架构
  - 轻量级 LLM 应用
---

# Nanobot（OpenClaw 轻量实现）的底层原理解析

## 一句话概括
本文以精简版 OpenClaw——Nanobot 为切入点，拆解其核心原理：基于循环执行的"提示词构建 + 调用大模型 + 工具操作"的本地 Agent 架构，通过消息处理、上下文构建、AgentLoop 循环决策与工具调用等流程揭示其运行机制。

## 实践内容

### Nanobot 核心架构

Nanobot 本质是运行在用户终端的 Agent，核心运转逻辑：循环调用大模型 API -> 解析输出 -> 本地执行系统命令 -> 结果回传。与服务端 Agent 无本质架构区别。

### 消息生命周期（六个阶段）

1. **消息接收** — ChannelManager 通过 MessageBus 接收外部平台消息（Telegram、Discord、飞书等），支持 WebSocket、长轮询、Webhook 等通信方式
2. **访问控制与路由** — 权限检查与会话路由
3. **提示词构建 (ContextBuilder)** — 拼接系统身份、历史对话、记忆、技能等为 LLM 可理解的格式
4. **AgentLoop 循环执行** — ReAct 模式，while 循环调用大模型 + 执行工具，上限 40 次迭代
5. **记忆存储** — 保存会话与内存合并
6. **发送回复** — 通过 MessageBus 分发到对应 Channel 发送

### ContextBuilder 提示词构建流程

`build_system_prompt()` 通过 5 个步骤拼接完整 system prompt：
1. `_get_identity()` — 本地设备信息、存储目录、行为准则
2. `_load_bootstrap_files()` — 加载 AGENTS.md、SOUL.md、USER.md、TOOLS.md 等预设文件
3. `memory.get_memory_context()` — 从 memory/MEMORY.md 读取长期记忆
4. `Skills.load_Skills_for_context()` — 常用技能内容
5. `Skills.build_Skills_summary()` — 可用技能摘要列表（渐进式加载，只给 LLM 看名称和描述）

### Skill 与 Tool 的区别

- **Skill** = prompt + Tools + Workflow，是 prompt 的组成部分，可在开始时或后续过程中传递
- **Tool** = 纯粹的代码逻辑/API 接口，通用性强，通过 Function Call 参数传递，不在 prompt 中

### AgentLoop 核心机制

- 实现 ReAct 模式（推理 + 行动）
- 通过 while 循环调用大模型 API，返回需执行的工具调用
- 最大迭代次数 `max_iterations = 40`
- 工具调用流程：LLM 返回 tool_calls -> ToolRegistry 校验参数 -> 执行工具 -> 结果添加到 messages 上下文
- 粗暴的 while 循环 + 快速增长的上下文导致 token 消耗巨大

### 工具系统 (Tools)

- 所有工具继承 Tool 抽象基类
- 内置工具：filesystem（文件操作）、shell（命令执行）、web（搜索/抓取）、spawn（子任务）、cron（定时任务）、mcp（MCP 连接）等
- ExecTool 核心：通过 `asyncio.create_subprocess_shell()` 调用系统默认 shell 执行命令

### 安全机制

- **危险命令拦截**：正则匹配 deny_patterns（rm -rf、format、shutdown 等）
- **白名单模式**（可选）：只允许匹配的命令执行
- **路径限制**（可选）：restrict_to_workspace 限制只能访问工作区
- **超时控制**：60 秒超时自动 kill
- **不足**：无真正沙箱环境，正则匹配可被绕过（命令替换、反引号等）

### 两层记忆系统 (MemoryStore)

- **Session（内存）**：当前会话消息
- **长期存储**：memory/MEMORY.md（长期记忆）+ memory/HISTORY.md（可 grep 搜索的历史日志）
- 触发条件：未合并消息数 >= memory_window（默认 100 条）或用户发送 /new 命令
- 合并流程：提取待合并消息 -> 构建 prompt 给 LLM -> LLM 调用 save_memory 工具抽取记忆 -> 写入 HISTORY.md 和 MEMORY.md

## 摘录

> OpenClaw 本质上是一个运行在用户终端的Agent。它的核心运转逻辑比较常规：循环环调用大模型 API -> 解析输出 -> 本地执行系统命令 -> 结果回传。它并没有引入颠覆性的 AI 新技术，在架构上，与过去运行在服务端的 Agent（智能体）没有本质区别。

> OpenClaw 极其大胆地开放了本地权限，允许大模型动态生成并执行 Python、Shell 等脚本。这种"放权"让大模型从"只能聊天的智囊"变成了"能敲键盘的双手"，直接操作本地文件和应用，能力边界得到了实质性的突破。

> Nanobot将prompt做了拆分，将各种来源的信息（系统身份、历史对话、记忆、技能等）组装成 LLM 能理解的格式。

> run_agent_loop实现 ReAct 模式（推理 + 行动），用于执行 AI 代理（Agent）的核心迭代循环。它的主要作用是不断与大语言模型（LLM）交互，直到模型给出最终回答或达到最大迭代次数。

> 在 AI 智能体的开发语境中，Skill（技能）和 Tool（工具）在很多框架中经常被混用，但从概念和设计逻辑上，它们有明显的层级和本质区别：Skill = prompt + Tools + Workflow。它是prompt中的一个组成部分；Tool 是纯粹的代码逻辑、API 或物理/软件接口，不具备智能，只负责"输入 A，输出 B"。

> 技术上没有魔法，只有工程的巧妙组合：Nanobot并非依赖某种颠覆性的 AI 新算法，而是通过"大模型 API + 循环控制 + 本地脚本执行"的经典架构，完成了从"动嘴"到"动手"的跨越。真正的突破在于"场景与体验"：它打破了云端沙盒的限制，将 AI 真正下放到了用户的个人电脑中。

## 涉及实体
- [[OpenClaw]] —— 开源 AI Agent 框架
- Nanobot —— OpenClaw 的轻量实现

## 涉及主题
- AI Agent 架构
- 轻量级 LLM 应用
