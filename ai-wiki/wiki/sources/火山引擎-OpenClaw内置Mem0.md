---
title: "火山引擎：OpenClaw内置Mem0"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/9gcyRO_k4dkWRqsszOCiWQ"
author: "火山引擎"
published_at: "2026-03-08"
ingested_at: 2026-05-31
tags:
  - openclaw
  - memory
  - mem0
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-双源记忆系统]]"
  - "[[Agent-Memory]]"
related_topics: []
---

# 火山引擎：OpenClaw内置Mem0

## 一句话概括

剖析 OpenClaw 原生 file-first 记忆体系的 token 浪费痛点，引入 openclaw-mem0-plugin 把后端替换为 Mem0 Cloud，暴露 memory_search/list/store/get/forget 工具与 CLI。

## 实践内容

### OpenClaw 原生记忆体系

- MEMORY.md 长期记忆
- `memory/YYYY-MM-DD.md` 日志
- `sessions/*.jsonl` + SQLite FTS5 与 sqlite-vec 混合检索
- 400 token 块、80 重叠

### Token 浪费痛点

原生记忆体系存在 token 浪费问题。

### Mem0 插件方案

**openclaw-mem0-plugin：**
- 后端替换为 Mem0 Cloud（platform 模式 + apiKey + userId）
- 暴露 `memory_search/list/store/get/forget` 工具
- `openclaw mem0 search --scope` CLI

### 核心优势

- 跨会话跨 Agent 共享
- 企业级审计删除

## 摘录

> 剖析 OpenClaw 原生 file-first 记忆体系（MEMORY.md 长期、`memory/YYYY-MM-DD.md` 日志、`sessions/*.jsonl` + SQLite FTS5 与 sqlite-vec 混合检索，400 token 块、80 重叠）的 token 浪费痛点。

> 引入 `openclaw-mem0-plugin` 把后端替换为 Mem0 Cloud（platform 模式 + apiKey + userId），暴露 `memory_search/list/store/get/forget` 工具与 `openclaw mem0 search --scope` CLI，支持跨会话跨 Agent 共享与企业级审计删除。

## 涉及实体

- [[OpenClaw]] —— OpenClaw 的记忆系统扩展
- [[OpenClaw-双源记忆系统]] —— 原生记忆体系的替代方案
- [[Agent-Memory]] —— Mem0 是 Agent Memory 的一种实现

## 涉及主题

- []
