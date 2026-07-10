---
title: "从分布式架构到 AI 架构面试题"
type: source
date: 2026-07-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/WEt8AL9DkCHH6wrOXZLGAA"
author: "SharkChili（写代码的SharkChili）"
published_at: "2026-07-07"
ingested_at: 2026-07-10
tags:
  - claude-code
  - harness-engineering
  - system-design
  - hooks
  - agent-architecture
related_entities:
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
  - "[[Agent-Skill]]"
  - "[[MCP]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[Harness-Engineering-主题]]"
---

# 从分布式架构到 AI 架构面试题

## 一句话概括

这篇文章用传统系统设计的“从 SLA 和约束反推方案”思路解释 AI 架构面试：[[Claude-Code]] 不只是聊天式代码生成，而是由记忆、扩展、集成、编程四层构成的 [[Harness-Engineering]]；不同组件须按触发方式与风险边界选型。

## 实践内容

### 四层模型与组件选择

```text
记忆层：CLAUDE.md / rules / memory，提供项目背景
扩展层：commands / skills / subagent / hooks，承载可组合能力
集成层：headless + MCP，进入 CI/CD 与外部系统
编程层：SDK，构造可无人值守的业务工作流

固定且人主动触发 → command 或仅用户可触发的 Skill
需模型按语义判断 → Skill
支线或长任务 → Subagent
工具调用事件上的硬约束 → Hook
无交互流水线 → headless
```

### Hook 作为推理外门禁

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "sh \"$CLAUDE_PROJECT_DIR/.claude/gate.sh\"",
        "statusMessage": "commit 死规则闸门"
      }]
    }]
  }
}
```

文章示例以提交规模为门禁：脚本拒绝超过 400 行的单次提交。重要的是，Hook 不依赖模型是否“记得遵守”，用非零退出可确定性拦截。

## 摘录

> 分布式架构题训练的是把系统拆开、把流量扛住的推导能力；进入 AI 时代，问题上移为如何给模型套上缰绳、让它稳定完成工作。作者强调，同一模型在不同 Harness 下的表现差异往往比不同模型在同一 Harness 下更大，因此 AI 架构考察的核心不是背概念，而是能否将工具、权限、上下文、持久化和事件约束编排成可工作的系统。

> 文章把 Claude Code 的架构自底向上分为四层：记忆层用规则和文档减少无状态模型对项目的误解；扩展层把 command、Skill、Subagent、Hook 作为正交原语；集成层由 headless 和 MCP 将 Agent 接到 CI/CD 与外部数据；编程层通过 SDK 构造稳定工作流。四层不是功能罗列，而是解释“哪些信息常驻、什么能力按需、何时触发外部操作、何时由代码编排”的责任分工。

> commands 与 Skills 都属于模型需要解释执行的软约束，而 Hooks 在工具调用前后运行于推理之外。对于数据库写入、git push 等高风险动作，文章建议用 Hooks 形成硬拦截；打包、部署、代码审查等标准化流程可封装成 Skill 再由用户或模型触发。这个差异把“告诉 Agent 不要做”与“系统实际上不允许做”明确区分开来。

## 涉及实体

- [[Claude-Code]] —— 四层模型的主体，提供 Skill、Hook、headless 与 SDK 等工程原语。
- [[Harness-Engineering]] —— 把模型能力转换为可控执行链路的工程层。
- [[Agent-Skill]] —— 适合由语义命中、按需加载的过程性知识。
- [[MCP]] —— 集成层将外部工具与数据引入 Agent 的标准接口。

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[Harness-Engineering-主题]]

## 我的评注

传统架构题的关键价值在“可从约束反推且可验证”，这一点可直接迁移到 AI 工程：不要只问有没有 Skill 或 MCP，而应追问触发方、权限边界、可观测证据与失败后的停止条件。
