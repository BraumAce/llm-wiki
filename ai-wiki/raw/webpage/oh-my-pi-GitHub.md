---
title: "oh-my-pi GitHub"
source_url: "https://github.com/can1357/oh-my-pi"
author: "can1357"
fetched_at: "2026-07-05T22:18:46+08:00"
fetcher: "github-api+git-clone"
---

# GitHub API metadata

- full_name: can1357/oh-my-pi
- description: AI Coding agent for the terminal — hash-anchored edits, optimized tool harness, LSP, Python, browser, subagents, and more
- language: TypeScript
- license: MIT
- default_branch: main
- stars_at_fetch: 16133
- forks_at_fetch: 1437
- created_at: 2025-12-31T14:01:28Z
- pushed_at: 2026-07-05T14:02:02Z
- topics: ai-agent, ai-coding-agent, anthropic, bun, claude, cli, coding-assistant, llm, mcp, multi-provider, openai, rust, terminal, tui, typescript

# README.md 摘录

<p align="center">
  <strong>A coding agent with the IDE wired in.</strong>
  <strong><a href="https://omp.sh">omp.sh</a></strong>
</p>

The most capable agent surface that ships. Continuously tuned by real-world use — complete out of the box, open all the way down.

**40+** providers · **32** built-in tools · **14** lsp ops · **28** dap ops · **~55k** lines of Rust core.

## Install

```sh
curl -fsSL https://omp.sh/install | sh
brew install can1357/tap/omp
bun install -g @oh-my-pi/pi-coding-agent
```

```powershell
irm https://omp.sh/install.ps1 | iex
```

```sh
mise use -g github:can1357/oh-my-pi
```

## README 功能段落

- Code execution w/ tool-calling: persistent Python and Bun workers can call the agent's own tools over a loopback bridge.
- LSP wired into every write: rename flows through `workspace/willRenameFiles` so re-exports, barrel files, and aliased imports update before the file moves.
- Drives a real debugger: lldb, dlv, debugpy, breakpoints, stepping, frames, variables.
- Time-traveling stream rules: regex match aborts a stream mid-token, injects a rule as system reminder, retries from the same point.
- First-class subagents: `task` fans out into isolated worktrees and returns schema-validated objects.
- Advisor model: a second model watches every turn and injects notes inline.
- Hashline: edit by content hash; stale anchors are rejected before corrupting files.
- Internal schemes: `pr://`, `issue://`, `agent://`, `skill://`, `rule://` resolve through filesystem-shaped tools.

## package / repo observation

```json
{
  "package": "@oh-my-pi/pi-coding-agent",
  "version": "16.3.6",
  "bin": { "omp": "src/cli.ts" },
  "runtime": "Bun",
  "core_packages": [
    "@oh-my-pi/pi-agent-core",
    "@oh-my-pi/pi-ai",
    "@oh-my-pi/pi-catalog",
    "@oh-my-pi/pi-natives",
    "@oh-my-pi/pi-tui",
    "@oh-my-pi/hashline",
    "@oh-my-pi/snapcompact"
  ]
}
```

Monorepo contains TypeScript packages, Rust crates under `crates/`, Python `robomp` automation service, native utilities, TUI/collab packages, benchmarks, and a coding-agent CLI package.
