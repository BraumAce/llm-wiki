---
title: "从架构到代码：深入理解 OpenClaw 的双源记忆系统"
type: source
date: 2026-05-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/Ok3VwXft5fvvNWLBL6r2AA"
author: "腾讯云开发者 / 刘学楷"
published_at: "2026-03-19"
ingested_at: 2026-05-10
tags:
  - openclaw
  - memory-system
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-双源记忆系统]]"
related_topics: []
---

# 从架构到代码：深入理解 OpenClaw 的双源记忆系统

## 一句话概括

腾讯云开发者公众号上由刘学楷撰写的 [[OpenClaw]] 记忆系统专题深度解析，提出"双源记忆架构"框架（动态 JSONL 会话日志 + 静态 Markdown 长期记忆），从存储格式、产生途径、Memory Flush 机制、SQLite 双索引（sqlite-vec + FTS5）、混合搜索、检索调用六个维度系统拆解了 OpenClaw 的"上下文 vs 记忆"分离设计。

## 实践内容

### 动态记忆 JSONL 格式（原文 3.1）

```jsonl
{"type":"message","message":{"role":"user","content":"帮我写一个 Python 爬虫"}}
{"type":"message","message":{"role":"assistant","content":"好的，我来帮你写..."}}
{"type":"tool_call","tool":"bash","input":{"command":"python crawler.py"}}
```

### Session 解析关键代码（原文 3.1）

```typescript
export async function buildSessionEntry(absPath: string): Promise<SessionFileEntry | null> {
  const raw = await fs.readFile(absPath, "utf-8");
  const lines = raw.split("\n");
  const collected: string[] = [];
  for (const line of lines) {
    const record = JSON.parse(line);
    if (message.role === "user" || message.role === "assistant") {
      const label = message.role === "user" ? "User" : "Assistant";
      collected.push(`${label}: ${text}`);
    }
  }
  return { path: sessionPathForFile(absPath), hash: hashText(content), content };
}
```

### Memory Flush Prompt（原文 3.2）

```typescript
export const DEFAULT_MEMORY_FLUSH_PROMPT = [
  "Pre-compaction memory flush.",
  "Store durable memories now (use memory/YYYY-MM-DD.md; create memory/ if needed).",
  `If nothing to store, reply with ${SILENT_REPLY_TOKEN}.`,
].join(" ");
```

### 摘要合并 Prompt（原文 3.2）

```typescript
const MERGE_SUMMARIES_INSTRUCTIONS =
  "Merge these partial summaries into a single cohesive summary. Preserve decisions," +
  " TODOs, open questions, and any constraints.";
```

### SQLite 双索引 schema（原文 4.1）

```sql
CREATE TABLE files (
  path TEXT PRIMARY KEY,
  source TEXT NOT NULL,        -- 'memory' | 'sessions'
  hash TEXT NOT NULL,          -- SHA256 增量
  mtime INTEGER NOT NULL,
  size INTEGER NOT NULL
);

CREATE TABLE chunks (
  id TEXT PRIMARY KEY,
  path TEXT NOT NULL,
  source TEXT NOT NULL,
  start_line INTEGER,
  end_line INTEGER,
  hash TEXT NOT NULL,
  model TEXT NOT NULL,         -- 'text-embedding-3-small'
  text TEXT NOT NULL,
  embedding TEXT NOT NULL,
  updated_at INTEGER
);

-- 向量索引（sqlite-vec 扩展）
CREATE VIRTUAL TABLE chunks_vec USING vec0(...);

-- 全文索引（FTS5）
CREATE VIRTUAL TABLE chunks_fts USING fts5(
  path, source, model, text,
  tokenize='porter unicode61'
);
```

## 摘录

> 当前 AI 类应用面临的核心困境在于：大多数系统只是简单的把"上下文窗口"当作作为的"记忆"。根据 Anthropic 最新的开发者调研，有 68% 的 AI 应用团队都在为"上下文丢失"的问题苦恼。但是，上下文的特点是临时的、有限的（Claude 200K tokens、GPT-4 128K tokens）、昂贵的——当对话超过限制，模型要么会遗忘早期信息，要么因为成本暴涨而不得不重置会话窗口。

> OpenClaw 所代表的应用，其对"记忆（Memory）"的定义是：持久存储在磁盘上的结构化信息。因此，只要有足够的存储空间，记忆就可以无限增长，能够跨会话保留，在使用时按需检索，且存储成本几乎为零。更为关键的是，这种记忆能够支持语音搜索，也就意味着不需要把所有历史信息都塞进上下文，只需要检索当前任务相关的片段。所以，可以将上下文理解成 AI 的"工作台"，决定当下能处理什么，而记忆则是 AI 的"知识库"，决定长期能积累什么。

> 这种对于记忆的架构创新，使得 OpenClaw 可以在多轮交互上始终保持上下文的轻量和聚焦，把长期的记忆信息放到可搜索的记忆层。在其 Github Issue #847 中有一份实验数据，有人测试了一个持续 72h 的自动化任务，传统的上下文方案因为 token 限制触发了 23 次会话重置，而基于记忆的方案仅仅触发了 3 次，而且每一次重置之后都能通过搜索恢复关键上下文信息。

## 涉及实体

- [[OpenClaw]] —— 父系统
- [[OpenClaw-双源记忆系统]] —— 本文是该子模块的最详细阐述

## 涉及主题

（积累 ≥5 篇同议题来源后聚合）

## 我的评注

- "上下文是工作台，记忆是知识库"是本文最有价值的概念隔离——一旦内化这个区分，就理解为什么 OpenClaw 默认不会让一切信息都塞进上下文窗口
- Memory Flush 的 prompt 简洁到只有三句话（Store durable memories now / If nothing to store, reply with $SILENT），可见 OpenClaw 并不依赖复杂的"记忆抽取算法"，而是直接相信 LLM 的判断力——这种"AI 编译器"式的偷懒是设计哲学一致性
- "为什么我用 OpenClaw 还是花了那么多 token"这个问题，作者诚实地回答"记忆层只解决了一部分问题，还有系统提示词、工具信息、会话历史"——这与 [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] 中的 23 个 Prompt 模块呼应
