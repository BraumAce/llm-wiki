---
title: "Context Engineering for AI Agents (Claude-Mem)"
type: source
date: 2026-06-22
source_type: webpage
source_url: "https://docs.claude-mem.ai/context-engineering"
author: "Claude-Mem Documentation"
ingested_at: 2026-06-22
tags: [context-engineering, prompt-engineering, rag, agent-memory, sub-agent]
related_entities:
  - "[[Context-Engineering]]"
  - "[[Progressive-Disclosure]]"
  - "[[claude-mem]]"
  - "[[RAG]]"
  - "[[Agent-Memory]]"
related_topics:
  - "[[Agentic-Engineering-主题]]"
---

# Context Engineering for AI Agents (Claude-Mem)

## 一句话概括

claude-mem 文档对 Anthropic《Effective context engineering for AI agents》（2025-09）的结构化复述：把「找到能最大化目标达成概率的最小高信号 token 集合」拆成系统提示、工具、示例、检索策略与长程任务五个可操作维度，并给出场景→策略的速查表。

## 实践内容

**核心原则**：Find the smallest possible set of high-signal tokens that maximize the likelihood of your desired outcome.

**Context Engineering vs Prompt Engineering**：
- Prompt Engineering：为最优结果编写、组织 LLM 指令（一次性任务）。
- Context Engineering：在多轮推理中持续策展、维护最优 token 集合（迭代过程），管理对象 = 系统指令 + 工具 + MCP + 外部数据 + 消息历史 + 运行时检索。

**问题：Context Rot**——LLM 有「注意力预算」随上下文增长被耗尽；每个 token 与其他所有 token 建立 n² 关系；上下文越长准确率越低；模型对长序列训练经验更少；须把上下文当作边际收益递减的有限资源。

**系统提示找「正确海拔」（Goldilocks Zone）**：

```
Too Prescriptive ❌  - 硬编码 if-else；脆弱；维护复杂
Too Vague        ❌  - 高层指引无具体信号；假设共享上下文；缺可操作方向
Just Right       ✅  - 足够具体以引导行为；足够灵活以提供强启发；最小信息集完整勾勒预期行为
```
最佳实践：简单直接语言；用 `<background_information>`、`<instructions>`、`## Tool guidance` 分节；XML 标签或 Markdown 标题；从最小提示起步、按失败模式增补；Minimal ≠ short。

**工具设计原则**：Self-contained（单一职责）、Robust to error、Extremely clear、Token-efficient、Descriptive parameters（`user_id` 而非 `user`）。**关键准则**：If a human engineer can't definitively say which tool to use in a given situation, an AI agent can't be expected to do better. 要避免：臃肿工具集、职责重叠、模糊的工具选择点。

**示例多样而非穷举**：精选多样、典型范例（pictures worth a thousand words）✅；不要堆边界情况清单、试图穷举每条规则 ❌。

**三种检索策略**：
- Just-In-Time（推荐给 Agent）：只维护轻量标识符（文件路径/查询/链接），运行时动态加载。优点=避免污染、支持渐进式披露、贴近人类认知、利用元数据、增量发现；代价=比预取慢、需良好工具指引防死胡同。
- Pre-Inference（传统 RAG）：推理前 embedding 召回；用于交互期间不变的静态内容。
- Hybrid（最佳）：部分预取 + 必要时自主探索。例：Claude Code 预加载 CLAUDE.md，再用 glob/grep 做 JIT。Rule of Thumb：Do the simplest thing that works.

**长程任务三技术**：
1. Compaction（压缩）：接近上限时摘要后重启；调优顺序「先最大化召回、再提升精度」；low-hanging fruit = 清理旧工具调用与结果；保留架构决策/bug/实现。
2. Structured Note-Taking（Agentic Memory）：写到窗口外再取回（to-do、NOTES.md、游戏状态、进度日志）；例 Pokémon 追踪 1,234 步训练；支撑多小时连贯策略。
3. Sub-Agent Architectures：主 Agent 定计划，子 Agent 干净上下文里深入探索（数万 token），只回传 1,000-2,000 token 浓缩摘要。

**场景→策略速查表**：

| Scenario | Recommended Approach |
|----------|----------------------|
| Static content | Pre-inference retrieval or hybrid |
| Dynamic exploration needed | Just-in-time context |
| Extended back-and-forth | Compaction |
| Iterative development | Structured note-taking |
| Complex research | Sub-agent architectures |
| Rapid model improvement | "Do the simplest thing that works" |

**反模式（❌）**：把一切塞进 prompt；脆弱 if-else 逻辑；臃肿工具集；穷举边界情况当示例；以为更大窗口能解决一切；忽视长交互的上下文污染。

## 摘录

> Prompt Engineering: Writing and organizing LLM instructions for optimal outcomes (one-time task). Context Engineering: Curating and maintaining the optimal set of tokens during inference across multiple turns (iterative process). Context engineering manages: System instructions; Tools; Model Context Protocol (MCP); External data; Message history; Runtime data retrieval. —— 这是全文对两者最凝练的边界划分。

> Just-In-Time Context (Recommended for Agents). Approach: Maintain lightweight identifiers (file paths, queries, links) and dynamically load data at runtime. Benefits: Avoids context pollution; Enables progressive disclosure; Mirrors human cognition; Leverages metadata; Agents discover context incrementally. Trade-offs: Slower than pre-computed retrieval; Requires proper tool guidance to avoid dead-ends.

> Sub-Agent Architectures ... Main agent coordinates high-level plan; Sub-agents perform deep technical work; Sub-agents explore extensively (tens of thousands of tokens); Return condensed summaries (1,000-2,000 tokens). Benefits: Clear separation of concerns; Parallel exploration; Detailed context remains isolated. Best For: Complex research and analysis tasks.

## 涉及实体

- [[Context-Engineering]] —— 本文是该实体的方法论骨架（Anthropic 框架复述）
- [[Progressive-Disclosure]] —— JIT 策略「enables progressive disclosure」的直接出处
- [[claude-mem]] —— 把 JIT + 结构化笔记落到 Claude Code 记忆层
- [[RAG]] —— 预检索策略即传统 RAG，文中与 JIT 做对照
- [[Agent-Memory]] —— 结构化笔记即 agentic memory 的一种实现

## 涉及主题

- [[Agentic-Engineering-主题]]

## 我的评注（可选）

这篇是 Anthropic 官方上下文工程文章的「文档化复述」，比原文更条目化、便于查表。它和 [[Progressive-Disclosure-Claude-Mem]] 是一对：本文给「为什么要 JIT/最小化」，那篇给「JIT 的信息架构怎么落地」。三种长程技术（压缩/笔记/子 Agent）与本库已有的 [[横向拆解六大Agent上下文压缩策略后我们做了第7个]] 形成互补——后者讲压缩的工程细节，本文讲压缩在整体策略中的位置。结尾点题值得记：optimize signal-to-noise ratio in your token budget。
