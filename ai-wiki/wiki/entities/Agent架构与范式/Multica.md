---
title: "Multica"
type: entity
date: 2026-06-26
also_known_as:
  - "multica-ai/multica"
  - "managed agents platform"
tags:
  - managed-agents
  - coding-agent
  - platform
  - squad
  - runtime
sources:
  - "[[multica-ai-GitHub]]"
related_entities:
  - "[[Agentic-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Tutti]]"
  - "[[OpenClaw]]"
  - "[[RMUX]]"
---

# Multica

## 一句话定义

Multica 是一个开源 managed agents 平台，把 coding agents 当作团队成员来管理：可分配 issue、跟踪进度、汇报阻塞、复用 skills，并通过本地 daemon 连接 Claude Code、Codex、OpenClaw、OpenCode、Hermes 等运行时。

## 摘要

Multica 的核心视角是组织管理，而不是单 Agent 能力。README 里反复强调“agents as teammates”：Agent 有 profile，会出现在 board 上，能接任务、发评论、报告 blocker、更新状态；Squads 则把多个 agent/human 组合成由 leader agent 路由的稳定工作组。它把人类项目管理中的 issue、assignment、status、runtime、workspace、autopilot、skill reuse 这些概念重新组织给 AI 团队使用。对 Agentic Engineering 来说，Multica 对应的是从“我在本地开一个 coding agent”到“团队里有一批可调度、可观察、可复用经验的 agent 同事”。

## 详情

### 起源与背景

随着 Claude Code、Codex、OpenClaw、OpenCode 等工具并行出现，团队开始面对一个新问题：Agent 很多，但任务、进度、权限、上下文、技能沉淀和运行时状态分散在各自 CLI 或聊天窗口里。Multica 借 Multics 的 time-sharing 隐喻，认为小团队可以通过多 Agent 多路复用获得更高吞吐。它不是替代具体 coding agent，而是把这些 agent 作为 runtime 接入自己的工作台。

### 核心机制 / 工作原理

Multica 由 Next.js 前端、Go 后端、PostgreSQL + pgvector、Agent Daemon 组成。本地 daemon 运行在用户机器上，自动检测 PATH 中可用的 agent CLI，并把 runtime 状态回报给平台。用户通过 board 或 CLI 创建 issue，分配给 agent 或 squad；agent pick up 任务后执行、流式汇报进度、失败时报告 blocker。Autopilots 支持定时/ webhook/手动触发 recurring work；Reusable Skills 则把已解决问题沉淀为团队能力。

```bash
brew install multica-ai/tap/multica
multica setup
multica daemon start
multica issue list
multica issue create
```

### 应用 / 使用场景

- 在团队看板里把 bug、feature、weekly report、code review 分给不同 Agent。
- 用 Squads 给前端、后端、测试或文档类任务设置稳定路由。
- 通过 Autopilots 让日报、审计、依赖升级、周期性检查自动创建 issue 并派发。
- 统一观察本地和云端 runtimes，知道哪些机器有 Claude Code、Codex、OpenClaw 等 CLI 可用。

### 局限与争议

Managed agents 的难点在于状态副作用：评论、mention、status change、assignment 都可能触发新的 agent run。Multica-cli skill 因此把“写操作需明确授权、评论用 `--content-file`、不要随便 mention agent、状态变化不是装饰”写成规则。另一个边界是团队信任：平台能分配任务，不代表 agent 产物可直接合并；仍需要代码 review、CI、权限隔离和人类验收。

## 与其他实体的关系

- [[Agentic-Engineering]] —— Multica 是 Agentic Engineering 从单机 agent 走向组织工作台的代表。
- [[Harness-Engineering]] —— 它把状态、权限、可观测、技能复用和运行时检测纳入平台 harness。
- [[Tutti]] —— 两者都试图解决多 Agent 协作中的状态和交接问题；Multica 更偏 issue/squad/runtime 管理，Tutti 更偏实时共享工作空间和应用产物流转。
- [[OpenClaw]] —— OpenClaw 是可接入的 agent runtime 之一。
- [[RMUX]] —— RMUX 可作为单个 runtime 内的终端会话层，Multica 则管理更上层的任务生命周期。

## 参考来源

- [[multica-ai-GitHub]]
