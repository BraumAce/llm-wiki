---
title: "Tutti-GitHub"
type: source
date: 2026-07-06
source_type: webpage
source_url: "https://github.com/tutti-os/tutti"
author: "tutti-os"
ingested_at: 2026-07-06
tags:
  - multi-agent
  - shared-workspace
  - local-first
  - desktop
related_entities:
  - "[[Tutti]]"
  - "[[Multica]]"
  - "[[Agentic-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Claude-Code]]"
  - "[[OpenClaw]]"
related_topics:
  - "[[Agent架构演进-主题]]"
  - "[[Agentic-Engineering-主题]]"
---

# Tutti-GitHub

## 一句话概括

Tutti 是一个本地优先的 Agent-Agent 共享工作空间项目，把 Claude Code、Codex 等本地 Agent、文件、任务、应用产物和运行状态放进同一个实时桌面工作台，核心价值是减少跨 Agent 交接时的人肉复制、复述和上下文丢失。

## 实践内容

Tutti 仓库最有价值的实践不是单一功能介绍，而是它把“多 Agent 协作”拆成产品形态、仓库分层和可执行检查三层。

```text
仓库形态：
- services/tuttid：business rules, durable local state, daemon workflows
- apps/desktop：Electron shell, preload, renderer UI, desktop integration
- packages/clients/*：generated and hand-written domain clients
- packages/configs/*：shared TypeScript and formatting config
- config：sources used to generate runtime defaults
```

```text
核心分层规则：
- Keep business logic in services/tuttid.
- Do not let apps/desktop become a second business core.
- Do not create vague packages such as shared, common, utils, or client-sdk.
- User-visible copy must go through the relevant i18n layer.
- Change services/tuttid/api/openapi/tuttid.v1.yaml before daemon HTTP request/response contracts.
- Business-code files should stay at or below 800 lines.
```

```bash
pnpm check:changed
pnpm lint:ts
pnpm typecheck
pnpm --filter @tutti-os/desktop build
pnpm check:ui-boundaries
pnpm check:renderer-boundaries
pnpm check:i18n
pnpm generate:defaults
pnpm lint:go
cd services/tuttid && go test ./... && go build ./...
```

仓库还内置了 `.codex/skills/tutti-architecture-review`，把架构审查变成 skill 化工作流。这个 skill 会先由 planner 根据 diff、scope file、preflight signals 生成 review task package，再由主 Agent 编排子 Agent 检查 project structure、layering、module ownership、event-center 复用等问题。

```bash
pnpm review:architecture
pnpm review:architecture:package
pnpm review:architecture:test
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --format markdown
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --scope-file /tmp/tutti-review-scope.json --scope-mode static-only --format summary
```

## 摘录

> Tutti 提供了一个实时共享的工作空间：上下文、文件、应用、任务，全部打通。Codex 能无缝使用 Claude 的产出，彼此不丢任何上下文，一致得像「共脑」。不仅如此，Tutti 还有自己的应用生态：生图、UI/UX 设计、写文档、做 PPT；你能用，Agent 也能用。一切在 Tutti 中彼此可见、互相依赖。

> `tutti` is a local-first desktop monorepo. `services/tuttid` owns business rules, durable local state, daemon workflows; `apps/desktop` owns Electron shell, preload, renderer UI, desktop integration. Keep business logic in `services/tuttid`. Do not let `apps/desktop` become a second business core. Do not create vague packages such as `shared`, `common`, `utils`, or `client-sdk`.

> Tutti Layering Reference 把 repository shape 压缩成一组可审查规则：`apps/desktop` owns Electron shell, renderer UI, preload bridge, OS integration, and daemon supervision；`services/tuttid` owns business rules, durable local state, domain workflows, and persistence；`packages/*` exists only for real shared seams with narrow names；`tools` contains repository support scripts, not permanent product behavior。

## 涉及实体

- [[Tutti]] —— 本 source 的主体项目，本地优先的 Agent-Agent 共享工作空间。
- [[Multica]] —— 同样试图管理多个 Agent，但 Multica 更像 managed agents / issue board，Tutti 更强调实时共享桌面工作态。
- [[Agentic-Engineering]] —— Tutti 把 Agentic Engineering 从单个 Agent 的控制流推进到多 Agent 共享状态和任务编排。
- [[Harness-Engineering]] —— 仓库用 AGENTS、架构文档、review skill 和检查脚本把 Agent 产出纳入可审查工程约束。
- [[Claude-Code]]、[[OpenClaw]] —— README 中明确提到的可接入或规划接入的 Agent runtime。

## 涉及主题

- [[Agent架构演进-主题]]
- [[Agentic-Engineering-主题]]

## 我的评注

Tutti 和 [[Multica]] 都在回应同一个问题：AI Agent 不是一个工具窗口，而是一组会产生状态、任务、文件、应用产物和冲突的运行时。二者的切入点不同，Multica 偏组织工作台与 issue/squad 管理，Tutti 偏实时桌面工作空间与 app 产物流转。对个人 AI 工作流来说，Tutti 的核心启发是：handoff 不应靠人写总结，而应把上下文、文件、任务和产物变成可引用、可共享、可审查的对象。
