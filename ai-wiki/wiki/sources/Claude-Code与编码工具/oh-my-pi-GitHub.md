---
title: "oh-my-pi GitHub"
type: source
date: 2026-07-05
source_type: webpage
source_url: "https://github.com/can1357/oh-my-pi"
author: "can1357"
ingested_at: 2026-07-05
tags:
  - ai-coding-agent
  - terminal-agent
  - lsp
  - dap
  - hashline
  - subagents
related_entities:
  - "[[oh-my-pi]]"
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
  - "[[Agentic-Engineering]]"
  - "[[MCP]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[Agentic-Engineering-主题]]"
---

# oh-my-pi GitHub

## 一句话概括

oh-my-pi 是一个终端 AI Coding Agent，把多 provider、文件/搜索/编辑、LSP、DAP、浏览器、子代理、协作和内容哈希编辑收敛到同一套 agent harness。

## 实践内容

```sh
curl -fsSL https://omp.sh/install | sh
brew install can1357/tap/omp
bun install -g @oh-my-pi/pi-coding-agent
mise use -g github:can1357/oh-my-pi
```

```powershell
irm https://omp.sh/install.ps1 | iex
```

```sh
# zsh
eval "$(omp completions zsh)"

# bash
eval "$(omp completions bash)"

# fish
omp completions fish > ~/.config/fish/completions/omp.fish
```

```json
{
  "package": "@oh-my-pi/pi-coding-agent",
  "version": "16.3.6",
  "bin": { "omp": "src/cli.ts" },
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

## 摘录

> The most capable agent surface that ships. Continuously tuned by real-world use — complete out of the box, open all the way down. 40+ providers, 32 built-in tools, 14 lsp ops, 28 dap ops, and roughly 55k lines of Rust core. The README frames the project as a Pi fork that adds the missing batteries: code execution with tool-calling, LSP-aware writes, debugger integration, time-traveling stream rules, first-class subagents, advisor model, collaboration, browser, hashline edits, internal schemes, and conflict resolution.

> LSP wired into every write means a rename goes through workspace/willRenameFiles, so re-exports, barrel files, and aliased imports update before the file moves. Hashline makes the model point at anchors instead of retyping all changed lines; stale anchors are rejected before corrupting files. The source describes this as perfect edits with fewer tokens, because whitespace battles and string-not-found retry loops stop being the main failure mode.

## 涉及实体

- [[oh-my-pi]] —— 本项目实体，终端 AI Coding Agent 和工具 harness。
- [[Claude-Code]] —— 处在同一类 AI Coding Agent 生态中，可作为 Claude Code 外部对照。
- [[Harness-Engineering]] —— README 的重点是把工具、编辑、调试、浏览器、协作和规则注入工程化。
- [[Agentic-Engineering]] —— 体现从单次代码生成走向可验证、可分工、可持久运行的工程范式。
- [[MCP]] —— 项目 topics 标注 multi-provider 与 MCP，且 README 强调统一工具面。

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[Agentic-Engineering-主题]]

## 我的评注

oh-my-pi 的价值不是“又一个聊天式编码 CLI”，而是把 IDE 知识、调试器、子代理、协作链接、GitHub/PR 文件系统化和 hash-anchor 编辑都纳入同一 agent 表面。它和 Claude Code 的差异值得后续重点观察：Claude Code 的优势来自官方模型与产品闭环，oh-my-pi 的优势则更偏开放工具面、编辑格式实验和本地 harness 可塑性。
