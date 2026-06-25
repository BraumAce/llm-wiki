---
title: "RMUX"
type: entity
date: 2026-06-26
also_known_as:
  - "Helvesec/rmux"
  - "Rust Multiplexer"
tags:
  - terminal
  - multiplexer
  - agent-runtime
  - cli
  - tui
sources:
  - "[[RMUX-GitHub]]"
related_entities:
  - "[[Claude-Code]]"
  - "[[Cua]]"
  - "[[MCP]]"
  - "[[Multica]]"
---

# RMUX

## 一句话定义

RMUX 是一个用 Rust 编写的跨平台终端复用引擎，提供 tmux 兼容命令、Rust/Python/TypeScript Typed SDK、Web Share 和 Claude teammate mode，让 Agent 可以通过代码驱动 CLI/TUI 会话。

## 摘要

RMUX 关注的是 Agent 运行时里常被低估的终端层。许多 coding agent 的真实工作并不是单次 `bash` 命令，而是长时间观察终端、等待输出、切窗格、保留 scrollback、和多个 CLI/TUI 应用协同。传统 tmux 在 Linux/macOS 很成熟，但跨 Windows、SDK 类型安全、Web 共享和 Agent 集成并不是它的核心目标。RMUX 的价值在于把这些能力变成一个跨 Linux、macOS、Windows 的本地 daemon：shell、pane、window、session 和 scrollback 留在本机，外部程序通过 typed SDK 控制。

## 详情

### 起源与背景

README 把 RMUX 定义为 “Universal Multiplexer Engine”，强调它实现 90+ tmux 命令，原生运行在 Linux、macOS、Windows，并且不需要 WSL。对 Agent 工程来说，这类 multiplexer 的意义在于把终端从“工具调用的一次性 stdout”升级为“可持续观察和控制的工作空间”。Claude Code 已经有 teammate mode 的 tmux 协议，RMUX 则试图提供兼容入口和更广的平台覆盖。

### 核心机制 / 工作原理

RMUX 有三个层次：第一层是独立 CLI，可以 `new-session`、`split-window`、`web-share`、`diagnose`；第二层是本地 daemon，维护 session、pane 和 scrollback；第三层是 SDK，给 Rust、Python 和 TypeScript 暴露 sessions、panes、streams、waits、snapshots 等能力。Web Share 则把某个 pane/session 共享到浏览器，但终端执行仍在本地，并使用混合后量子端到端加密。

```bash
rmux list-commands
rmux new-session --help
rmux split-window --help
rmux web-share --help
rmux diagnose --human

rmux claude --dangerously-skip-permissions
```

### 应用 / 使用场景

- 让 Claude Code 运行在本地 RMUX workspace 中，并自动传入 `--teammate-mode tmux`。
- 用 SDK 驱动 CLI/TUI 程序，捕获输出、等待状态、切换 pane，构建更稳定的终端自动化。
- 把一个终端会话 Web Share 给远端审阅者，同时执行仍在本机。
- 在 Windows 上获得类 tmux 的跨 pane/session 管理，避免 WSL 依赖。

### 局限与争议

RMUX 的强项是终端会话，不是 GUI 桌面；它和 [[Cua]] 是互补关系。它还需要团队在 agent harness 里定义“何时读取 scrollback、何时判定命令完成、如何处理交互式 TUI 卡住”等策略。若只是把一次性 shell 替换成长期 pane，而没有收敛等待条件与失败恢复，可能会把隐性状态复杂度转移到终端层。

## 与其他实体的关系

- [[Claude-Code]] —— RMUX 支持 Claude teammate mode，是 Claude Code 多 agent/teammate 工作流的运行基座候选。
- [[Cua]] —— Cua 偏桌面/GUI，RMUX 偏终端/TUI；两者都在为 Agent 补运行环境可控性。
- [[MCP]] —— RMUX 自身不是 MCP 项目，但它解决的是 MCP 工具常见的执行会话持久化问题。
- [[Multica]] —— Multica 管理 agent 生命周期，RMUX 可以作为单个 runtime 内的终端工作区能力。

## 参考来源

- [[RMUX-GitHub]]
