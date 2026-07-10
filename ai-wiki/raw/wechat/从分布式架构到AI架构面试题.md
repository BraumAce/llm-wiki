---
title: "从分布式架构到AI架构面试题"
source_url: "https://mp.weixin.qq.com/s/WEt8AL9DkCHH6wrOXZLGAA"
author: "SharkChili（写代码的SharkChili）"
published_at: "2026-07-07T14:19:00+08:00"
fetched_at: "2026-07-10T00:00:00+08:00"
fetcher: "in-app-browser"
---

# 从分布式架构到 AI 架构面试题

## 原文要点摘取

文章先以高并发、缓存、读写分离、分库分表、容量估算等传统后端面试题说明架构推导能力：指标和经验阈值不应机械套用，而要从业务 SLA、正常 RT、负载模型与可验证数据反推。随后将这一能力扩展到 AI 架构，认为面试不应只问“会不会使用某个 AI 工具”，而应考察如何把不确定的模型能力置入确定的工程约束。

作者把 Claude Code 概括成可扩展、可组合、可编程的 Agent 框架，并提出四层模型：记忆层以 CLAUDE.md、rules、memory 注入项目背景；扩展层用 commands、skills、subagent、hooks 承载行为；集成层以 headless 和 MCP 接入 CI/CD 与外部系统；编程层用 SDK 构造可无人值守的工作流。Harness 则是工具系统、权限控制、上下文管理、会话持久化和事件钩子的组合，而非模型本身。

文章给出组件选择的实务边界：固定且标准的流程可由人触发的 command/skill 承载；需要模型按任务语义决定的过程适合 Skill；支线与长任务委托给 Subagent；事件节点上的不可绕过约束使用 Hooks；无交互的流水线工作由 headless 驱动。它以提交行数限制为例说明 Hook 可以在 PreToolUse 阶段运行脚本，形成模型推理之外的硬门禁。
