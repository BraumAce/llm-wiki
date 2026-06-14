---
title: "腾讯云：一文讲透从0构建AI Agent"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/SAXIAnJ3NtVWPeA-oHIsQA"
author: "腾讯云"
published_at: "2026-03-26"
ingested_at: 2026-05-31
tags:
  - agent
  - llm
  - function-calling
  - react
related_entities:
  - "[[Claude-Code]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# 腾讯云：一文讲透从0构建AI Agent

## 一句话概括

以 LLM→API→Context→Tool Calling→Agent Loop→MCP/Sub-Agent/Skill 概念全景图开篇，给出 Agent = LLM + Tools + Loop 公式，按四阶段递进上代码：单次对话、history 数组多轮维护、Function Calling 工具注册表、引入 ReAct 循环。

## 实践内容

### Agent 公式

```
Agent = LLM + Tools + Loop
```

### 四阶段递进

1. **单次对话** —— 最简单的 LLM 调用
2. **history 数组多轮维护** —— 维护对话历史实现多轮
3. **Function Calling 工具注册表** —— 注册工具让 LLM 调用
4. **ReAct 循环** —— 推理-行动-观察循环

### 无状态本质

LLM 本质是无状态的，每次调用都是独立的。上下文管理是 Agent 的核心挑战。

### 三种上下文管理策略

1. **滑窗** —— 保留最近 N 轮对话
2. **摘要** —— 对历史对话生成摘要
3. **RAG** —— 检索增强生成

## 摘录

> 以 LLM→API→Context→Tool Calling→Agent Loop→MCP/Sub-Agent/Skill 概念全景图开篇，给出 Agent = LLM + Tools + Loop 公式，按四阶段递进上代码：单次对话、history 数组多轮维护、Function Calling 工具注册表、引入 ReAct 循环。

> 点出无状态本质、上下文窗口、滑窗/摘要/RAG 三种上下文管理策略。

## 涉及实体

- [[Claude-Code]] —— Claude Code 的 Agent Loop 实现

## 涉及主题

- [[Agent架构演进-主题]]

## 我的评注

"Agent = LLM + Tools + Loop"这个公式简洁有力。四阶段递进的学习路径也很清晰——从最简单的单次对话开始，逐步增加多轮维护、工具调用和 ReAct 循环。
