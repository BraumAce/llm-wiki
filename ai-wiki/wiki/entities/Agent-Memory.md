---
title: "Agent Memory"
type: entity
date: 2026-05-29
also_known_as:
  - "AI Agent 记忆系统"
  - "Agent 记忆"
  - "LLM Memory"
tags:
  - memory
  - ai-agent
  - context-management
  - architecture
sources:
  - "[[腾讯云Agent-Memory节省61-Percent-Token提升52-Percent成功率]]"
  - "[[深度解析腾讯云Agent-Memory-4层渐进式记忆管道]]"
  - "[[AI记忆的Git版本控制-Memoir-分层路径替代向量数据库]]"
  - "[[Spring-AI-Session-API-大多数人用ChatMemory用错了场景]]"
  - "[[从架构到代码-深入理解OpenClaw的双源记忆系统]]"
related_entities:
  - "[[OpenClaw-双源记忆系统]]"
  - "[[OpenClaw]]"
  - "[[RAG]]"
---

# Agent Memory

## 一句话定义

Agent Memory 是 AI 智能体的记忆管理系统——负责在多轮对话和长期运行中持久化、组织、检索和压缩上下文信息，让 Agent 拥有跨越会话的连续性和学习能力。

## 摘要

Agent Memory 是 2026 年 AI 工程领域最活跃的研究方向之一。核心矛盾是：**大模型的 context window 有限 vs Agent 需要无限的长期记忆**。不同团队从不同角度切入：腾讯云 Agent Memory 用 4 层渐进式管道 + Mermaid 图编码实现 61% 的 Token 节省；Memoir 把记忆当版本控制问题，用 ProllyTree + 层级路径替代向量检索；Spring AI 用 Session API + AutoMemoryTools 构建双层记忆架构；OpenClaw 用动态 JSONL + 静态 Markdown + SQLite 双索引实现"文件即真相"的记忆哲学。

## 详情

### 核心机制 / 工作原理

**4 层渐进式记忆管道（腾讯云方案）**：

| 层级 | 名称 | 内容 | 生命周期 |
|------|------|------|----------|
| L0 | 对话捕获 | 原始对话历史 | 短期 |
| L1 | 原子事实 | 从对话中提取的离散事实 | 中期 |
| L2 | 场景归纳 | 跨对话的模式识别与总结 | 长期 |
| L3 | 用户画像 | 用户偏好、习惯、需求模型 | 持久 |

配合符号化上下文卸载：完整原文卸载到外部文件，工具调用压成 JSONL，任务状态写入 Mermaid 无限画布。效果：WideSearch 最高节省 61.38% Token、通过率相对提升 51.52%。

**Memoir：记忆即版本控制**：

用 ProllyTree + 层级化语义路径替代 UUID 与向量近似检索，做到 O(log n) 前缀查找。Git 的 branch / commit / merge / rollback / blame 全部搬进记忆层。单次记忆更新 Token 成本降 90%。

**Spring AI 双层架构**：

- 短期记忆：Session API + 四种压缩策略（SlidingWindow / TurnWindow / TokenCount / RecursiveSummarization）
- 长期记忆：AutoMemoryTools（仿 Claude Code 的 6 个沙箱化文件工具 + MEMORY.md 索引）

### 应用 / 使用场景

- **个人助手**：跨会话记住用户偏好、习惯、项目上下文
- **代码 Agent**：记住代码库结构、之前的修改决策、调试经验
- **客服系统**：记住用户的历史问题和解决方案

### 局限与争议

- **检索精度**：记忆越多，精准检索越困难
- **遗忘策略**：什么该忘、什么该留？
- **隐私风险**：长期记忆可能包含敏感信息
- **上下文污染**：过时或错误的记忆会误导模型

## 与其他实体的关系

- [[OpenClaw-双源记忆系统]] —— OpenClaw 的记忆系统是"文件即真相"哲学的典型实现
- [[OpenClaw]] —— OpenClaw 将记忆系统作为核心模块之一
- [[RAG]] —— RAG 可以看作 Agent Memory 的检索层

## 参考来源

- [[腾讯云Agent-Memory节省61-Percent-Token提升52-Percent成功率]] —— 腾讯云短期记忆压缩实践
- [[深度解析腾讯云Agent-Memory-4层渐进式记忆管道]] —— 4层管道深度解析
- [[AI记忆的Git版本控制-Memoir-分层路径替代向量数据库]] —— Memoir 版本控制记忆
- [[Spring-AI-Session-API-大多数人用ChatMemory用错了场景]] —— Spring AI 双层架构
- [[从架构到代码-深入理解OpenClaw的双源记忆系统]] —— OpenClaw 记忆系统
