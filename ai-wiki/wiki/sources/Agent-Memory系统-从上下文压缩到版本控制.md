---
title: "Agent Memory 系统：从上下文压缩到版本控制"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://blog.bytelighting.cn/program/reading/2026/2026.5.html"
author: "多作者综合"
ingested_at: 2026-05-29
tags:
  - memory
  - agent
  - context-management
related_entities:
  - "[[Agent-Memory]]"
  - "[[OpenClaw-双源记忆系统]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# Agent Memory 系统：从上下文压缩到版本控制

## 一句话概括

综合 3 篇 Agent Memory 文章，对比腾讯云 4 层渐进式管道、Memoir 版本控制记忆、Spring AI 双层架构三种方案，梳理 2026 年 Agent 记忆系统的前沿实践。

## 实践内容

### 腾讯云 4 层渐进式记忆管道

```
L0 对话捕获 → L1 原子事实 → L2 场景归纳 → L3 用户画像

L0: 原始对话历史（短期，完整保留）
L1: 从对话中提取的离散事实（中期，如"用户喜欢 Go 语言"）
L2: 跨对话的模式识别与总结（长期，如"用户偏好后端开发"）
L3: 用户偏好、习惯、需求模型（持久，如用户画像）

配合符号化上下文卸载：
- 完整原文卸载到外部文件
- 工具调用压成 JSONL
- 任务状态写入 Mermaid 无限画布

效果：WideSearch 最高节省 61.38% Token、通过率相对提升 51.52%
```

### Memoir：记忆即版本控制

```
传统方案：向量近似检索（可能不精确）
Memoir：ProllyTree + 层级化语义路径

路径示例：
/projects/llm-wiki/entities/OpenClaw
/meetings/2026-05-29/sprint-planning
/preferences/languages/go

Git 操作搬进记忆层：
- branch: 创建记忆分支
- commit: 记忆快照
- merge: 合并不同来源的记忆
- rollback: 回滚到历史状态
- blame: 追溯记忆来源

效果：单次记忆更新 Token 成本降 90%，O(log n) 前缀查找
```

### Spring AI 双层记忆架构

```
短期记忆（Session API）：
  四种压缩策略：
  1. SlidingWindow — 固定窗口滑动
  2. TurnWindow — 按对话轮次截断
  3. TokenCount — 按 Token 数截断
  4. RecursiveSummarization — 递归摘要压缩
  + Recall Storage 兜底（压缩前保存原文）

长期记忆（AutoMemoryTools）：
  仿 Claude Code 的 6 个沙箱化文件工具
  + MEMORY.md 索引
  + 四类记忆：fact / preference / skill / context
```

## 摘录

> 腾讯云 Agent Memory 的短期记忆压缩实践：完整原文卸载到外部文件，工具调用压成 JSONL，任务状态写入 Mermaid 无限画布。在连续长 Session 中同时降低 Token 与上下文噪音。WideSearch 最高节省 61.38% Token、通过率相对提升 51.52%。（腾讯云Agent Memory）

> 把 Agent 记忆当作版本控制问题而非向量搜索问题——Memoir 用 ProllyTree + 层级化语义路径替代 UUID 与向量近似检索，做到 O(log n) 前缀查找。单次记忆更新 Token 成本降 90%，并把 Git 的 branch / commit / merge / rollback / blame 搬进记忆层。（Memoir）

## 涉及实体

- [[Agent-Memory]] —— 本文是 Agent Memory 系统的综合对比
- [[OpenClaw-双源记忆系统]] —— OpenClaw 的记忆系统：动态 JSONL + 静态 Markdown + SQLite 双索引

## 我的评注

三种方案代表了三种哲学：腾讯云走"渐进式压缩"路线（信息逐步提炼）；Memoir 走"结构化组织"路线（用路径和版本管理记忆）；Spring AI 走"双层分离"路线（短期靠压缩，长期靠文件）。它们的共同趋势是：记忆不再是"把聊天记录塞进 prompt"，而是需要精心设计的工程子系统。Memoir 的"记忆即版本控制"是最有想象力的方向——如果记忆可以 branch/merge/rollback，Agent 的学习能力会质变。
