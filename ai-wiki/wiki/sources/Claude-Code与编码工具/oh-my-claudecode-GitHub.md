---
title: "oh-my-claudecode GitHub"
type: source
date: 2026-07-05
source_type: webpage
source_url: "https://github.com/Yeachan-Heo/oh-my-claudecode"
author: "Yeachan-Heo"
ingested_at: 2026-07-05
tags:
  - claude-code
  - multi-agent
  - teams
  - skills
  - tmux
  - orchestration
related_entities:
  - "[[oh-my-claudecode]]"
  - "[[Claude-Code]]"
  - "[[Agent-Skill]]"
  - "[[Harness-Engineering]]"
  - "[[Agentic-Engineering]]"
  - "[[Cursor]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[Agentic-Engineering-主题]]"
  - "[[AI-Skill体系-主题]]"
---

# oh-my-claudecode GitHub

## 一句话概括

oh-my-claudecode 是 Claude Code 的多代理编排与技能扩展层，把 Team、tmux CLI workers、skills、HUD、通知、记忆和持续验证工作流打包成 Claude Code 插件/CLI。

## 实践内容

```bash
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
```

```bash
npm i -g oh-my-claude-sisyphus@latest
omc setup
```

```bash
/setup
/omc-setup
/autopilot "build a REST API for managing tasks"
/deep-interview "I want to build a task management app"
/team 3:executor "fix all TypeScript errors"
```

```bash
omc team 2:codex "review auth module for security issues"
omc team 2:gemini "redesign UI components for accessibility"
omc team 2:antigravity "redesign UI components for accessibility"
omc team 1:claude "implement the payment flow"
omc team 1:cursor "implement the payment flow"
omc team status auth-review
omc team shutdown auth-review
```

```yaml
---
name: Fix Proxy Crash
description: aiohttp proxy crashes on ClientDisconnectedError
triggers: ["proxy", "aiohttp", "disconnected"]
source: extracted
---
Wrap handler at server.py:42 in try/except ClientDisconnectedError...
```

## 摘录

> OMC exposes two different surfaces: terminal CLI commands run from the shell after installing the npm/runtime path, and in-session skills run inside a Claude Code session after installing the plugin/setup flow. The README explicitly separates setup, provider asking, team orchestration, autopilot, Ralph, ultrawork, deep interview, autoresearch, and CI/headless automation, warning users not to rely on interactive slash commands for CI/CD and instead prefer deterministic terminal commands plus environment-provided authentication.

> Starting in v4.1.7, Team is described as the canonical orchestration surface. The staged pipeline is team-plan, team-prd, team-exec, team-verify, and team-fix. The CLI `omc team` runtime launches tmux worker panes for real Claude, Codex, Gemini, Antigravity, Grok, Cursor, or Claude processes, while in-session `/team` uses the native team workflow. Workers spawn on demand and die when the task completes, and external providers are optional rather than required.

## 涉及实体

- [[oh-my-claudecode]] —— 本项目实体，Claude Code 多代理/技能编排扩展。
- [[Claude-Code]] —— 直接运行在 Claude Code 插件和会话语境里。
- [[Agent-Skill]] —— 仓库包含大量 `skills/*/SKILL.md`，并支持项目级 skill 提取与自动注入。
- [[Harness-Engineering]] —— 通过 setup、teams、verify/fix、notifications、HUD 和 state 目录把执行过程工程化。
- [[Agentic-Engineering]] —— 代表把单 agent 执行升级为多角色、多阶段、可验证协作。
- [[Cursor]] —— `omc team` 支持 Cursor executor workers。

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[Agentic-Engineering-主题]]
- [[AI-Skill体系-主题]]

## 我的评注

oh-my-claudecode 的关键不是某个单点命令，而是把 Claude Code 周边操作系统化：哪些能力属于插件 slash command，哪些属于终端 CLI，哪些可以进 CI，哪些需要活跃会话，都被明确分层。它也说明 Claude Code 生态正在从“个人提示词集合”演进为可安装、可同步、可拆分执行和可观测的工程运行时。
