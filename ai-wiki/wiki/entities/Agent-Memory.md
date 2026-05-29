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
  - "[[ByteLighting-2026年5月技术阅读合集]]"
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

这些方案的共同趋势是：从简单的"对话历史保存"演进到**分层、压缩、可检索、可遗忘**的复杂记忆系统。记忆不再是"把聊天记录塞进 prompt"，而是需要精心设计的工程子系统。

## 详情

### 起源与背景

早期的 ChatBot 只有短期记忆——对话历史保存在内存中，会话结束即丢失。ChatGPT 的 "Memory" 功能（2024）首次让普通用户体验到跨会话记忆。但生产级 Agent 的记忆需求远比聊天机器人复杂：

- **容量**：Agent 可能运行数月，积累海量交互数据
- **精度**：不是所有历史都有用，需要精准检索相关信息
- **成本**：每轮对话的 Token 消耗直接影响 API 费用
- **遗忘**：过时信息需要被淘汰，否则会误导模型

2025-2026 年，随着 Agent 从"一问一答"演进到"自主执行"，记忆系统成为决定 Agent 能力上限的关键因素。

### 核心机制 / 工作原理

**4 层渐进式记忆管道（腾讯云方案）**：

| 层级 | 名称 | 内容 | 生命周期 |
|------|------|------|----------|
| L0 | 对话捕获 | 原始对话历史 | 短期 |
| L1 | 原子事实 | 从对话中提取的离散事实 | 中期 |
| L2 | 场景归纳 | 跨对话的模式识别与总结 | 长期 |
| L3 | 用户画像 | 用户偏好、习惯、需求模型 | 持久 |

**符号化上下文卸载**：

当对话变长时，把已完成的对话卸载到外部文件（如 Mermaid 图），只在 context 中保留引用。任务状态写入可视化图表，既节省 Token 又保持可追溯性。

**Memoir：记忆即版本控制**：

```
传统向量检索:
query → embedding → 近似最近邻 → 可能不精确

Memoir 分层路径:
query → ProllyTree 前缀查找 → O(log n) 精确命中
路径: /projects/llm-wiki/entities/OpenClaw
```

Memoir 把每条记忆组织为层级路径（类似文件系统），用 ProllyTree（一种概率数据结构）实现高效的前缀查找。关键创新：
- **Branch / Commit / Merge / Rollback / Blame**：Git 的版本控制操作全部搬进记忆层
- **Token 成本降 90%**：单次记忆更新不需要重新索引全部历史

**Spring AI 双层架构**：

- **短期记忆**：Session API + 四种压缩策略（SlidingWindow / TurnWindow / TokenCount / RecursiveSummarization）+ Recall Storage 兜底
- **长期记忆**：AutoMemoryTools（仿 Claude Code 的 6 个沙箱化文件工具 + MEMORY.md 索引）

### 应用 / 使用场景

- **个人助手**：跨会话记住用户偏好、习惯、项目上下文
- **代码 Agent**：记住代码库结构、之前的修改决策、调试经验
- **客服系统**：记住用户的历史问题和解决方案
- **协作 Agent**：在多 Agent 场景中共享和同步记忆

### 局限与争议

- **检索精度**：记忆越多，精准检索越困难，噪声会干扰模型判断
- **遗忘策略**：什么该忘、什么该留？错误的遗忘可能导致 Agent "失忆"
- **隐私风险**：长期记忆可能包含敏感信息，需要访问控制和审计
- **成本与延迟**：记忆的存储、索引、检索都有成本，需要在精度和效率间权衡
- **上下文污染**：过时或错误的记忆会误导模型，Memoir 的版本控制思路是解决方向之一

## 与其他实体的关系

- [[OpenClaw-双源记忆系统]] —— OpenClaw 的记忆系统是"文件即真相"哲学的典型实现：动态 JSONL + 静态 Markdown + SQLite 双索引
- [[OpenClaw]] —— OpenClaw 将记忆系统作为 16 大核心模块之一
- [[RAG]] —— RAG 可以看作 Agent Memory 的检索层——从外部知识库中检索相关信息注入上下文

## 参考来源

- [[ByteLighting-2026年5月技术阅读合集]] —— 腾讯云 Agent Memory、Memoir、Spring AI Session 等多篇记忆系统文章
- [[从架构到代码-深入理解OpenClaw的双源记忆系统]] —— OpenClaw 记忆系统深度解析
