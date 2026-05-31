---
title: "Claude Code 最佳实践：可验证、可治理、可分层的工程现实"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/RBpKqgDmf_S8l4DmaTJTSw"
author: "未知"
published_at: "2026-03-19"
ingested_at: 2026-05-31
tags:
  - claude-code
  - harness-engineering
  - context-engineering
related_entities:
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[Harness-Engineering-主题]]"
---

# Claude Code 最佳实践：可验证、可治理、可分层的工程现实

## 一句话概括

把 Claude Code 当作代理系统而非 ChatBot，按六层拆分治理——任务循环、CLAUDE.md 常驻契约、Skills 工作流、Tools/MCP 动作层、Hooks 控制层、Subagents 隔离层，强调验证前置和 Prompt Caching 决定上层设计。

## 实践内容

### 六层治理架构

1. **任务循环** —— 主循环是「收集上下文 → 采取行动 → 验证结果」
2. **CLAUDE.md 常驻契约** —— 建议 2-3K tokens 内，只放每次会话都成立的约束
3. **Skills 工作流** —— 按需加载的方法包
4. **Tools/MCP 动作层** —— 工具定义占 system prompt，MCP 5 个 server 可吃掉 2 万+ tokens 固定开销
5. **Hooks 控制层** —— 确定性执行的校验和自动化
6. **Subagents 隔离层** —— 隔离上下文和权限

### 验证前置原则

给测试样例 / 截图 / 可复现失败用例，让 Claude 在执行前就知道"什么叫做完"。

### 上下文管理策略

- Prompt Caching 决定上层设计
- 用 `/clear` / `/compact` / `HANDOFF.md` 主动管理上下文漂移
- MCP 5 个 server 可吃掉 2 万+ tokens 固定开销

### CLAUDE.md 最佳实践

- 保持 2-3K tokens 内
- 只放每次会话都成立的命令、约束、架构边界
- 不要写成团队知识库

## 摘录

> 把 Claude Code 当作代理系统而非 ChatBot，主循环是「收集上下文 → 采取行动 → 验证结果」，并按六层拆分治理——任务循环、CLAUDE.md 常驻契约（建议 2-3K tokens 内）、Skills 工作流、Tools/MCP 动作层、Hooks 控制层、Subagents 隔离层。

> 强调「验证前置」（给测试样例 / 截图 / 可复现失败用例）、MCP 5 个 server 可吃掉 2 万+ tokens 固定开销，Prompt Caching 决定上层设计，用 /clear /compact /HANDOFF.md 主动管理上下文漂移。

## 涉及实体

- [[Claude-Code]] —— Claude Code 的六层治理架构和最佳实践
- [[Harness-Engineering]] —— 六层治理是 Harness Engineering 的具体实现

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[Harness-Engineering-主题]]

## 我的评注

这篇文章的核心洞察是"Prompt Caching 决定上层设计"——Claude Code 的整个架构都是围绕缓存构建的。MCP 工具定义的固定开销（2 万+ tokens）是一个容易被忽视的问题，实际项目中需要认真评估 MCP server 的数量。
