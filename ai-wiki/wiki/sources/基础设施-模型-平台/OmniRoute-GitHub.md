---
title: "OmniRoute GitHub"
type: source
date: 2026-07-05
source_type: webpage
source_url: "https://github.com/diegosouzapw/OmniRoute"
author: "diegosouzapw"
ingested_at: 2026-07-05
tags:
  - ai-gateway
  - model-routing
  - fallback
  - token-compression
  - mcp
  - a2a
related_entities:
  - "[[OmniRoute]]"
  - "[[Token成本控制]]"
  - "[[Prompt-Cache]]"
  - "[[MCP]]"
  - "[[Claude-Code]]"
  - "[[Cursor]]"
related_topics:
  - "[[AI-Infra推理优化-主题]]"
  - "[[Agentic-Engineering-主题]]"
---

# OmniRoute GitHub

## 一句话概括

OmniRoute 是一个本地优先的 AI gateway，把 Claude Code、Codex、Cursor、Cline、Copilot 等工具接到同一 OpenAI-compatible 端点，并在其中做 provider 聚合、fallback、quota、压缩、MCP/A2A 和成本治理。

## 实践内容

```bash
npm install -g omniroute
omniroute
```

```text
Dashboard at http://localhost:20128
API at http://localhost:20128/v1
```

```bash
curl http://localhost:20128/v1/models -H "Authorization: Bearer YOUR_KEY"

omniroute               # serve gateway + dashboard (port 20128)
omniroute chat          # interactive TUI chat client
omniroute setup         # guided first-run wizard
omniroute doctor        # diagnose providers, ports, native deps
omniroute connect 192.168.0.15
omniroute models list
omniroute configure codex
omniroute tokens create --name ci --scope read
omniroute contexts use default
```

```text
Combo: "always-on"                         Strategy: priority
  1. cc/claude-opus-4-7   ← subscription (use it fully)
  2. cx/gpt-5.5           ← second subscription
  3. glm/glm-5.1          ← cheap backup ($0.5/1M)
  4. kr/claude-sonnet-4.5 ← FREE, unlimited (never fails)
Result: 4 layers of fallback = zero downtime
```

```ts
const TASK_STAGES = {
  code: [
    { name: "plan", fitnessTier: "best-reasoning" },
    { name: "execute", fitnessTier: "cheapest" },
    { name: "reflect", fitnessTier: "moderate" },
    { name: "fix", fitnessTier: "cheapest" },
  ],
  simple: [{ name: "execute", fitnessTier: "cheapest" }],
};
```

## 摘录

> One endpoint, 237 providers, 90+ free, through a local gateway. The README states that users can plug Claude Code, Codex, Cursor, Cline, Copilot and Antigravity into free Claude, GPT, and Gemini options with auto-fallback. It also claims RTK plus Caveman compression can save 15 to 95 percent tokens, while the dashboard tracks free-tier pools, provider terms, live used/remaining quota, model breakdown, and provider pool deduplication rather than inflating headline limits.

> OmniRoute describes three independent resilience layers: a circuit breaker for whole providers, connection cooldown for one account or key, and model lockout for a provider plus model pair. The README's combo example routes from subscription providers to cheap backup and then free providers, while source code under `src/domain/pipeline.ts` models task pipelines as plan, execute, reflect, and fix stages with different provider fitness tiers. This places routing, quota, cost, and verification policy in the gateway rather than in each coding tool.

## 涉及实体

- [[OmniRoute]] —— 本项目实体，AI gateway 与多 provider 路由层。
- [[Token成本控制]] —— 其核心卖点之一是压缩、quota、成本和 fallback。
- [[Prompt-Cache]] —— README 多处提到 session stickiness 和 prompt-cache integrity。
- [[MCP]] —— OmniRoute 暴露 MCP 入口，让 agent 控制路由、provider、combo、cache、compression。
- [[Claude-Code]] —— README 明确支持 Claude Code 路由配置。
- [[Cursor]] —— README 明确支持 Cursor / Cursor Cloud Agent / coding tools。

## 涉及主题

- [[AI-Infra推理优化-主题]]
- [[Agentic-Engineering-主题]]

## 我的评注

OmniRoute 代表的是“Agent 工具前的代理层”路线：模型选择、账号 quota、限流熔断、压缩、MCP/A2A 和成本账本被集中治理。它的收益在多账号、多 provider、跨工具场景最明显；边界也同样清楚，路由层不能替代任务验收、代码测试和提示语质量，压缩链还必须有 fidelity gate，否则省 token 可能换来语义损失。
