---
title: "RMUX GitHub"
type: source
date: 2026-06-26
source_type: webpage
source_url: "https://github.com/Helvesec/rmux"
author: "Helvesec"
ingested_at: 2026-06-26
tags:
  - terminal
  - multiplexer
  - agent-runtime
  - tui
related_entities:
  - "[[RMUX]]"
  - "[[Claude-Code]]"
  - "[[Cua]]"
related_topics:
  - "[[Agentic-Engineering-主题]]"
  - "[[AI-Infra推理优化-主题]]"
---

# RMUX GitHub

## 一句话概括

RMUX 把 tmux 式终端复用做成跨平台 Rust daemon 和 Typed SDK，让 Agent 可以更稳定地驱动 CLI/TUI、保持 session、共享 pane 并接入 Claude teammate mode。

## 实践内容

```bash
rmux list-commands
rmux new-session --help
rmux split-window --help
rmux web-share --help
rmux diagnose --human

brew install rmux
cargo install rmux --locked
rmux claude --dangerously-skip-permissions

cargo add rmux-sdk
pip install librmux
npm install @rmux/sdk
```

```text
/etc/rmux.conf
~/.rmux.conf
$XDG_CONFIG_HOME/rmux/rmux.conf
~/.config/rmux/rmux.conf
%APPDATA%\rmux\rmux.conf
%RMUX_CONFIG_FILE%
```

## 摘录

> RMUX is an async, typed terminal multiplexer engine written in Rust. It implements 90+ `tmux` commands and runs natively on Linux, macOS, and Windows with no WSL required. Use it as a standalone CLI, embed it in Rust terminal apps, or drive it through typed SDKs for Rust, Python, and TypeScript.

> Run Claude Code inside a local RMUX workspace with tmux teammate mode enabled. RMUX opens an attached session and automatically passes `--teammate-mode tmux` along with your args straight to Claude. To route commands properly, RMUX prepends a private `tmux` shim to Claude's `PATH`.

## 涉及实体

- [[RMUX]] —— 本项目实体，终端/TUI 会话复用层。
- [[Claude-Code]] —— RMUX 明确支持 Claude teammate mode。
- [[Cua]] —— 两者分别补终端层和桌面层。

## 涉及主题

- [[Agentic-Engineering-主题]]
- [[AI-Infra推理优化-主题]]

## 我的评注

RMUX 的价值在于把“终端状态”从一次性 stdout 变成可编排对象。它适合和 coding agent 的长期任务、teammate mode、多 pane 审阅配合；但真正落地仍要定义等待条件、错误恢复和 scrollback 解析，否则只是把 shell 的复杂度藏进会话里。
