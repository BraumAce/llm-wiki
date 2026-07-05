---
title: "oh-my-claudecode GitHub"
source_url: "https://github.com/Yeachan-Heo/oh-my-claudecode"
author: "Yeachan-Heo"
fetched_at: "2026-07-05T22:18:46+08:00"
fetcher: "github-api+git-clone"
---

# GitHub API metadata

- full_name: Yeachan-Heo/oh-my-claudecode
- description: Teams-first Multi-agent orchestration for Claude Code
- language: TypeScript
- license: MIT
- default_branch: main
- stars_at_fetch: 37421
- forks_at_fetch: 3376
- created_at: 2026-01-09T03:36:29Z
- pushed_at: 2026-07-04T23:17:24Z
- topics: agentic-coding, ai-agents, automation, claude, claude-code, multi-agent-systems, oh-my-opencode, opencode, parallel-execution, vibe-coding

# README.md 摘录

oh-my-claudecode is multi-agent orchestration for Claude Code. Zero learning curve.

Marketplace/plugin install:

```bash
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
```

npm runtime path:

```bash
npm i -g oh-my-claude-sisyphus@latest
omc setup
```

Team Mode is the canonical orchestration surface:

```bash
/team 3:executor "fix all TypeScript errors"
omc team 2:codex "review auth module for security issues"
omc team 2:gemini "redesign UI components for accessibility"
omc team 1:claude "implement the payment flow"
omc team status auth-review
omc team shutdown auth-review
```

## Feature excerpts

- Team runs as a staged pipeline: `team-plan → team-prd → team-exec → team-verify → team-fix`.
- `omc team` launches tmux CLI workers: real `claude`, `codex`, `gemini`, `antigravity`, `grok`, or `cursor-agent` processes in split panes.
- `/ccg` routes via `/ask codex` and `/ask antigravity`, then Claude synthesizes.
- OMC exposes skills such as `autopilot`, `ralph`, `ultrawork`, `ultraqa`, `deep-interview`, `remember`, `skillify`, `wiki`, `hud`, and `configure-notifications`.
- Project-scoped skills live under `.omc/skills/`; OMC also reads Claude workspace skills from `.claude/skills/` and compatibility skills from `.agents/skills/`.

## package / repo observation

```json
{
  "name": "oh-my-claude-sisyphus",
  "version": "4.15.2",
  "description": "Multi-agent orchestration system for Claude Code - Inspired by oh-my-opencode",
  "bin": {
    "oh-my-claudecode": "bin/oh-my-claudecode.js",
    "omc": "bin/oh-my-claudecode.js",
    "omc-cli": "bridge/cli.cjs"
  }
}
```

Repository contains TypeScript runtime, installer, notifications, HUD, tools, LSP helpers, python repl bridge, autoresearch, ultragoal, and many bundled `skills/*/SKILL.md` packages.
