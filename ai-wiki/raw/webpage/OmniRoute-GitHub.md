---
title: "OmniRoute GitHub"
source_url: "https://github.com/diegosouzapw/OmniRoute"
author: "diegosouzapw"
fetched_at: "2026-07-05T22:18:46+08:00"
fetcher: "github-api+git-clone"
---

# GitHub API metadata

- full_name: diegosouzapw/OmniRoute
- description: Free AI gateway: one endpoint, many providers, Claude Code / Codex / Cursor / Cline / Copilot compatibility, RTK+Caveman compression, fallback, MCP/A2A, multimodal APIs, Desktop/PWA.
- language: TypeScript
- license: MIT
- default_branch: main
- stars_at_fetch: 11566
- forks_at_fetch: 1672
- created_at: 2026-02-13T12:38:31Z
- pushed_at: 2026-07-05T14:15:28Z
- topics: a2a, ai-agents, ai-gateway, anthropic, claude, claude-code, cline, codex, copilot, cursor, deepseek, free-ai, gemini, gemini-cli, llm-gateway, mcp, openai, openai-proxy, qwen, token-saver

# README.md 摘录

OmniRoute — The Free AI Gateway.

Never stop coding. Connect every AI tool to 237 providers — 90+ free — through one endpoint.

Plug Claude Code, Codex, Cursor, Cline, Copilot & Antigravity into free Claude / GPT / Gemini. Auto-fallback.

RTK + Caveman compression saves 15–95% tokens. Never hit limits.

## Quick Start

```bash
npm install -g omniroute
omniroute
```

Dashboard at `http://localhost:20128` · API at `http://localhost:20128/v1`.

```bash
curl http://localhost:20128/v1/models -H "Authorization: Bearer YOUR_KEY"
```

## Routing / resilience excerpts

```text
Combo: "always-on"                         Strategy: priority
  1. cc/claude-opus-4-7   ← subscription (use it fully)
  2. cx/gpt-5.5           ← second subscription
  3. glm/glm-5.1          ← cheap backup ($0.5/1M)
  4. kr/claude-sonnet-4.5 ← FREE, unlimited (never fails)
Result: 4 layers of fallback = zero downtime
```

```bash
omniroute               # serve gateway + dashboard (port 20128)
omniroute chat          # interactive TUI chat client
omniroute setup         # guided first-run wizard
omniroute doctor        # diagnose providers, ports, native deps
omniroute connect 192.168.0.15
omniroute models list
omniroute configure codex
omniroute tokens create --name ci --scope read
```

## Implementation observation

- package name: `omniroute`, version at fetch: `3.8.44`
- bin: `omniroute`, `omniroute-reset-password`
- domain modules include `fallbackPolicy.ts`, `policyEngine.ts`, `comboResolver.ts`, `pipeline.ts`, `quotaCache.ts`, `degradation.ts`, `modelAvailability.ts`, `costRules.ts`
- `src/domain/pipeline.ts` defines task pipelines such as code: plan → execute → reflect → fix, with fitness tiers `best-reasoning`, `cheapest`, and `moderate`
- MCP/A2A and cloud-agent directories are present under `src/lib/`
