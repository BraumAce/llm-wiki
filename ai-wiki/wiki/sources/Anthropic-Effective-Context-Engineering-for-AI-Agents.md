---
title: "Anthropic: Effective context engineering for AI agents"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents"
author: "Anthropic Applied AI (Prithvi Rajasekaran, Ethan Dixon, Carly Ryan, Jeremy Hadfield)"
published_at: "2025-09-29"
ingested_at: 2026-05-30
tags:
  - context-engineering
  - prompt-engineering
  - ai-agent
  - context-window
  - compaction
  - multi-agent
  - agentic-memory
related_entities:
  - "Anthropic"
  - "[[Claude-Code]]"
  - "Claude"
related_topics:
  - "Context-Engineering"
  - "Agent-Architecture"
  - "Context-Window-Management"
---

# Anthropic: Effective context engineering for AI agents

## 一句话概括

Anthropic 应用 AI 团队系统性阐述了从 prompt engineering 到 context engineering 的范式演进，提出"将上下文视为有限注意力预算"的核心模型，并给出四大实用策略——compaction、结构化笔记、子 agent 架构、JIT 检索——用于在长时任务中维持 agent 的连贯性和可靠性。

## 实践内容

### 系统 prompt 设计原则（"正确高度"）

系统 prompt 需要在两种失败模式之间找到 Goldilocks zone：

- **过窄端**：硬编码复杂的 if-else 逻辑 → 脆弱且难以维护
- **过宽端**：过于笼统或虚假假设共享上下文 → LLM 无法获得足够信号

最佳高度：足够具体以引导行为，又足够灵活以提供强启发式。

推荐用 XML 标签或 Markdown header 将 prompt 划分为独立区块（如 `<background_information>`、`<instructions>`、`## Tool guidance`、`## Output description`）。

### 工具设计原则

工具应满足：

- 自包含（self-contained）、容错、用途描述极其清晰
- 输入参数描述性且无歧义，发挥模型长处
- 返回 token 高效的信息
- 最小可行工具集：如果人类工程师无法明确判断该用哪个工具，AI agent 也做不到

> If a human engineer can't definitively say which tool should be used in a given situation, an AI agent can't be expected to do better.

### Few-shot 示例策略

不要把大量边界情况塞进 prompt。精选多样化的、有代表性的典型示例，有效展现预期行为即可。

### Compaction（上下文压缩）

当对话接近上下文窗口上限时，将消息历史传给模型进行摘要，然后用摘要重新初始化新的上下文窗口。

Claude Code 的实现方式：
- 将消息历史传给模型做摘要
- 保留架构决策、未解决 bug、实现细节
- 丢弃冗余的工具输出
- 压缩后携带最近访问的 5 个文件继续工作

关键调参建议：先最大化 recall，再迭代优化 precision。

最轻量级的 compaction 形式：清除深层历史中的工具调用及结果（tool result clearing）。

### 结构化笔记 / Agentic Memory

Agent 在上下文窗口之外写入持久化笔记，后续需要时再拉回。例如：

- Claude Code 创建 to-do list
- 自定义 agent 维护 NOTES.md 文件
- Claude Plays Pokemon 跨上千步精确追踪目标进度、地图、成就、战斗笔记

### 子 Agent 架构

专用子 agent 在独立的干净上下文窗口中处理聚焦任务，主 agent 协调高层计划。每个子 agent 可消耗数万 token 进行探索，但**只返回 1,000-2,000 token 的浓缩摘要**。

### JIT（Just-In-Time）上下文检索

Agent 维护轻量级标识符（文件路径、存储查询、web 链接），在运行时通过工具动态加载数据，而非预处理全部数据。

Claude Code 示例：写针对性查询、存储结果、用 `head` 和 `tail` 分析大数据而不把完整对象加载进上下文。

**Hybrid 策略**：预加载部分数据（如 CLAUDE.md）+ JIT 导航（glob、grep）→ 兼顾速度与新鲜度。

## 摘录

> Context refers to the tokens included when sampling from an LLM. The engineering problem involves optimizing token utility against LLM constraints to consistently achieve outcomes. This requires thinking in context — considering the holistic state available to the model at any given time and what behaviors that state might produce. In contrast to the discrete task of writing a prompt, context engineering is iterative and the curation phase happens each time we decide what to pass to the model.

> Despite their speed and data-handling capacity, LLMs — like humans — lose focus at a certain point. Studies on needle-in-a-haystack benchmarking have revealed context rot: as token count in the context window grows, the model's ability to accurately recall information from that context decreases. Context must therefore be treated as a finite resource with diminishing marginal returns. Like humans with limited working memory capacity, LLMs have an "attention budget" drawn upon when parsing large context volumes.

> Rather than pre-processing all data upfront, agents using the JIT approach maintain lightweight identifiers (file paths, stored queries, web links) and dynamically load data at runtime via tools. Claude Code exemplifies this — writing targeted queries, storing results, and using Bash commands like head and tail to analyze large data without loading full objects into context. This mirrors human cognition: we don't memorize entire corpuses but use external organization systems like file systems and bookmarks to retrieve information on demand.

## 涉及实体

- Anthropic —— 本文作者所属机构，发布于 Anthropic Engineering Blog
- [[Claude-Code]] —— 文中多次引用的 agent 产品，作为 JIT 检索、compaction、hybrid 策略的实践案例
- Claude —— Anthropic 的 LLM 产品线，文中提及 Sonnet 4.5 发布时配套的 memory tool public beta

## 涉及主题

- Context-Engineering —— 本文核心主题，系统定义了 context engineering 的内涵、与 prompt engineering 的关系、以及四大长时任务策略
- Agent-Architecture —— 涵盖 agent 定义（LLM autonomously using tools in a loop）、sub-agent 架构、hybrid 检索策略
- Context-Window-Management —— context rot、attention budget、compaction、tool result clearing 等上下文窗口管理技术
