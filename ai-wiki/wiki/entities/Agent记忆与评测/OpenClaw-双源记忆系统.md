---
title: "OpenClaw-双源记忆系统"
type: entity
date: 2026-05-10
also_known_as:
  - "OpenClaw 记忆管理"
  - "OpenClaw Memory"
tags:
  - memory
  - openclaw-module
  - sqlite
  - hybrid-search
sources:
  - "[[深入理解OpenClaw技术架构与实现原理-下]]"
  - "[[从架构到代码-深入理解OpenClaw的双源记忆系统]]"
  - "[[以OpenClaw为例介绍AI-Agent的运作原理]]"
related_entities:
  - "[[OpenClaw]]"
---

# OpenClaw-双源记忆系统

## 一句话定义

OpenClaw-双源记忆系统是 [[OpenClaw]] 的持久化记忆子系统，把"记忆"从"上下文窗口"里彻底剥离，分成 **动态记忆**（按会话 append-only 写到 JSONL 会话日志）+ **静态记忆**（提炼到人类可读的 Markdown 文件），用 SQLite 双索引（sqlite-vec + FTS5）做混合搜索，实现"上下文是工作台、记忆是知识库"的设计哲学。

## 摘要

记忆是当下 AI Agent 设计中最棘手的问题——大多数系统把"上下文窗口"当作记忆的全部，结果被 token 上限和成本压住喘不过气。OpenClaw 的双源记忆系统选了完全不同的路：把记忆视为**持久存储在磁盘上的结构化信息**，存储成本接近零、可无限增长、跨会话保留、按需检索。

它的两个"源"分别针对人类记忆的两种粒度：动态记忆是"流水账"（每一句话原样保留为 JSONL），静态记忆是"提炼后的事实"（Memory Flush 触发 LLM 自我筛选，写到日期归档的 Markdown）。两者都索引到同一个 SQLite 数据库，搜索时向量 + BM25 加权融合，再叠 MMR 去重和时间衰减。

## 详情

### 双源架构

| 记忆类型 | 存储格式 | 路径 | 产生方式 |
|---|---|---|---|
| 动态记忆 | JSONL | `~/.openclaw/agents/{agentId}/sessions/*.jsonl` | 自动记录每次对话/工具调用 |
| 静态记忆 | Markdown | `~/.openclaw/workspace/MEMORY.md` 与 `memory/YYYY-MM-DD.md` | 用户手动 + 自动生成 |

直觉上这种分层符合人类大脑——绝大多数对话是流水账，只有少数会被刻意"提炼"成长期记忆。

### 动态记忆的产生

每次用户与 Agent 交互时，系统自动把消息和工具调用追加到 JSONL 文件：

```jsonl
{"type":"message","message":{"role":"user","content":"帮我写一个 Python 爬虫"}}
{"type":"message","message":{"role":"assistant","content":"好的，我来帮你写..."}}
{"type":"tool_call","tool":"bash","input":{"command":"python crawler.py"}}
```

后续读取由 `buildSessionEntry()` 解析 JSONL，按 user / assistant 重组为人类可读文本。

### 静态记忆的三种产生途径

1. **用户手动**：直接编辑 `MEMORY.md`，写入"称呼我为老板"、"我喜欢简洁回复"等长期偏好
2. **session-memory Hook**：当用户执行 `/new` 重置会话时，hook 自动把上一段会话的关键内容转为 Markdown
3. **Memory Flush**：当上下文接近 token 限制、要触发压缩前，特殊 Agent 回合被指示"把需要持久保存的重要信息写入 `memory/YYYY-MM-DD.md`"

第三种是核心。它的 prompt 简短到只有三句话：

```
Pre-compaction memory flush.
Store durable memories now (use memory/YYYY-MM-DD.md; create memory/ if needed).
If nothing to store, reply with $SILENT_REPLY_TOKEN.
```

紧接着，最终压缩用另一段 prompt 做有损摘要（`Preserve decisions, TODOs, open questions, and any constraints`）——只保关键决策、未决任务、开放问题、硬约束，不保具体数字、时间点。这是有意的设计取舍：完整性 vs 效率。

### MEMORY.md vs memory/*.md 对比

| 特性 | `MEMORY.md` | `memory/*.md` |
|---|---|---|
| 用途 | 核心长期记忆 | 按时间组织的会话记忆 |
| 内容 | 用户偏好、重要信息、工作流程 | 具体会话的摘要和细节 |
| 更新方式 | 用户手动维护为主 | 系统自动生成为主 |
| 命名 | 固定 `MEMORY.md` | `YYYY-MM-DD(-{slug}).md` |
| 检索优先级 | 平等，由向量相似度决定 | 平等 |

### 索引构建

只对 Markdown 文件构建索引，JSONL 不索引（避免噪声）。流程：

1. 文件分块：默认 400 tokens / 块，相邻块重叠 80 tokens
2. 每个块同时生成：向量 Embedding（OpenAI / Gemini / 本地三选一）+ 文本 Token
3. 分别写入 sqlite-vec 和 FTS5 索引

SQLite schema 核心表：

```sql
CREATE TABLE files (path TEXT PRIMARY KEY, source TEXT, hash TEXT, mtime INTEGER, size INTEGER);
CREATE TABLE chunks (id TEXT PRIMARY KEY, path TEXT, source TEXT, start_line INTEGER, end_line INTEGER,
                     hash TEXT, model TEXT, text TEXT, embedding TEXT, updated_at INTEGER);
CREATE VIRTUAL TABLE chunks_vec USING vec0(...);
CREATE VIRTUAL TABLE chunks_fts USING fts5(path, source, model, text, tokenize='porter unicode61');
```

整个系统只依赖一个轻量级 SQLite 文件，不需要部署 ES 或 Milvus。

### 混合搜索

```
finalScore = vectorWeight * vectorScore + textWeight * textScore
```

默认 `vectorWeight=0.7`、`textWeight=0.3`。理由：

- **向量搜索**：理解语义、容错（"运行 gateway 的机器" ≈ "Mac Studio gateway host"），但对精确 token（ID / 错误字符串）弱
- **BM25 全文**：精确匹配（如 commit hash、错误字符串），高信号 token

后处理：
- **MMR 去重**：`score = λ × relevance - (1-λ) × max_similarity_to_selected`，默认 λ=0.7
- **时间衰减**：`decayedScore = score × e^(-λ × ageInDays)`，半衰期 30 天

### 实战印证

[[从架构到代码-深入理解OpenClaw的双源记忆系统]] 引用 GitHub Issue #847 的实验：72 小时自动化任务中，传统纯上下文方案因 token 限制触发了 23 次会话重置；双源记忆方案仅 3 次，且每次重置后都能通过搜索恢复关键上下文。

### 为什么用 OpenClaw 还是花了很多 token？

记忆层只解决了一部分问题。token 消耗还来自：
- 系统提示词（[[OpenClaw]] system prompt 多达 23 个模块，详见 [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]）
- 工具清单的 schema
- 会话历史的尚未压缩部分
- Skill 菜单注入

记忆系统只让"长尾历史信息"不再无限堆积——它不是省 token 的银弹。

## 与其他实体的关系

- [[OpenClaw]] —— 父系统；记忆系统是 [[OpenClaw]] 16 大模块之一
- [[OpenClaw-SandBox]] —— 平行的子系统；都属于 [[OpenClaw]] 的核心设施

## 参考来源

- [[深入理解OpenClaw技术架构与实现原理-下]]（章节 3.9，结构性介绍）
- [[从架构到代码-深入理解OpenClaw的双源记忆系统]]（专题深度，含源码与 prompt）
- [[以OpenClaw为例介绍AI-Agent的运作原理]]（用户视角的简化解释）

## 相关综合

- [[OpenClaw-digest-20260510]]
