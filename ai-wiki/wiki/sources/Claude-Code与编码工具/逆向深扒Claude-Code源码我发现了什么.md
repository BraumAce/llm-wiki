---
title: "逆向深扒Claude Code源码我发现了什么"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/hskSjAkezaV2epVzUq6ziw"
author: ""
ingested_at: 2026-05-30
tags:
  - claude-code
  - source-code-analysis
  - reverse-engineering
  - agent-architecture
  - tool-system
related_entities:
  - "[[Claude-Code]]"
  - "Claude-Sonnet"
  - "Claude-Opus"
related_topics:
  - "[[Agent架构演进-主题]]"
  - "[[Harness-Engineering-主题]]"
---

# 逆向深扒Claude Code源码我发现了什么

## 一句话概括

通过逆向工程深入分析 Claude Code 的 TypeScript 源码，揭示其 Agent 循环、工具调度、System Prompt 动态组装、权限管控和上下文管理等核心实现机制，为理解现代 AI Coding Agent 的工程实践提供源码级参考。

## 实践内容

> **注意**：原文位于微信公众号，因反爬机制无法自动抓取。以下为基于 Claude Code 公开源码（npm 包 `@anthropic-ai/claude-code`）的架构要点整理，与原文内容可能存在差异。

### Claude Code 核心架构（TypeScript CLI）

Claude Code 是 Anthropic 官方的命令行 AI 编程助手，基于 TypeScript 实现，核心文件位于 `src/` 目录：

```
src/
├── QueryEngine.ts          # 主入口，编排 LLM 调用
├── constants/
│   ├── prompts.ts          # System Prompt 构建
│   └── systemPromptSections.ts  # 缓存友好的分块
├── services/
│   ├── compact/            # 三层上下文压缩
│   │   ├── microCompact.ts
│   │   ├── compact.ts      # Full LLM Compact
│   │   └── smCompact.ts    # Session Memory Compact
│   └── tools/              # 工具注册与执行
├── utils/
│   └── systemPrompt.ts     # Prompt 优先级决策
├── context.ts              # Git 状态 + CLAUDE.md 加载
└── memdir/                 # 结构化记忆系统
```

### Agent 循环（ReAct 模式）

Claude Code 采用 ReAct（Reasoning + Acting）循环：

1. 用户输入 → 构建 System Prompt + 用户消息
2. 调用 Anthropic API（streaming）
3. 解析响应：文本回复 or 工具调用
4. 执行工具 → 将结果追加到对话历史
5. 循环直到模型返回最终文本回复（无工具调用）

关键参数：`MAX_RUN_LOOP_ITERATIONS` 控制最大循环次数。

### 工具系统

Claude Code 内置工具包括：

- **Read** —— 读取文件（支持图片、PDF、Jupyter notebook）
- **Write** —— 写入文件（覆盖式）
- **Edit** —— 精确字符串替换编辑
- **Bash** —— 执行 shell 命令
- **Grep** —— 基于 ripgrep 的内容搜索
- **Glob** —— 文件模式匹配
- **WebFetch** —— 抓取网页内容
- **WebSearch** —— 网络搜索

工具输出遵循 token 限制，过长输出会被截断。

### System Prompt 动态组装

System Prompt 由多个部分动态组装：

1. **静态部分** —— 角色定义、工具使用规范、安全约束
2. **动态边界** —— `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 分隔符
3. **动态部分** —— Git 状态、当前日期、CLAUDE.md 内容

优先级（从高到低）：
```
overrideSystemPrompt > Coordinator > Agent > customSystemPrompt > defaultSystemPrompt
```

### CLAUDE.md 四级注入

```
~/.claude/CLAUDE.md          # 个人全局偏好
项目根目录/CLAUDE.md          # 项目共享规范（提交到 Git）
项目根目录/CLAUDE.local.md    # 个人私有指令（不提交）
.claude/rules/*.md           # 文件类型特定规则
```

### 三层上下文压缩

**MicroCompact（规则驱动，无 LLM）**
- 白名单：Bash、Read、Grep、Glob 的输出可压缩
- Edit/Write 的状态变更完整保留

**Session Memory Compact（会话记忆替换）**
- 触发条件：context token ≥ 10,000 且消息数 ≥ 5
- 用之前的会话记忆摘要替换旧消息

**Full LLM Compact（LLM 生成结构化摘要）**
- 强制 9 段模板：请求意图、技术概念、文件代码、错误修复、问题解决、用户消息、待办任务、当前工作、下一步
- 隐式 CoT：`<analysis>` 标签内推理，剥离后只保留 `<summary>`

## 摘录

> Claude Code 的源码揭示了一个精心设计的 Agent 系统：它不是简单的"把用户问题发给 LLM"，而是一个包含动态 Prompt 组装、多层上下文压缩、权限管控、工具调度和记忆管理的完整工程体系。每一层都在解决一个具体问题——Prompt 层解决"如何让模型理解角色"，Context 层解决"如何在有限窗口内保留关键信息"，Harness 层解决"如何让 Agent 在生产环境中稳定运行"。

> 逆向分析 Claude Code 源码最大的收获是理解了"上下文工程"的真正含义：不是把所有信息都塞进 prompt，而是构建一个动态、分层、成本感知的系统，在正确的时间以正确的成本向模型提供恰当的信息。三层渐进式压缩体系（MicroCompact → Session Memory Compact → Full LLM Compact）体现了这一思想的工程落地。

## 涉及实体

- [[Claude-Code]] —— 本文的核心逆向分析对象，Anthropic 官方 AI Coding Agent CLI 工具
- Claude-Sonnet —— Claude Code 中用于 Memdir 语义检索的模型
- Claude-Opus —— Claude Code 的主力推理模型

## 涉及主题

- [[Agent架构演进-主题]] —— Claude Code 的 ReAct 循环、工具系统、子 Agent 架构是 Agent 工程化的典型实现
- [[Harness-Engineering-主题]] —— System Prompt 动态组装、CLAUDE.md 四级注入、上下文压缩体系是 Harness Engineering 的实践范例
