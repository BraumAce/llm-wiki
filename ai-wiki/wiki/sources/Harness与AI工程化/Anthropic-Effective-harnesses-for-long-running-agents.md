---
title: "Anthropic: Effective harnesses for long-running agents"
type: source
date: 2025-11-26
source_type: webpage
source_url: "https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents"
author: "Justin Young"
ingested_at: 2026-05-30
tags: [harness-engineering, long-running-agent, multi-context-window, claude-agent-sdk, ai-coding, browser-automation]
related_entities: [Harness-Engineering]
related_topics: [Harness-Engineering-主题, Agent架构演进-主题]
---

# Anthropic: Effective harnesses for long-running agents

## 一句话概括
Anthropic 分享了 Claude Agent SDK 跨多个 context window 执行长时间任务的 Harness 设计方案：通过 initializer agent 搭建初始环境（JSON feature list + progress file + init script），再由 coding agent 逐个 feature 增量推进并在每次 session 结束时留下结构化进度，解决了 agent 一次性堆砌代码和过早宣布完成两大失败模式。

## 实践内容

### Feature List（JSON 格式）

Initializer agent 将高层 prompt 展开为结构化 JSON feature list，所有 feature 初始标记为 `passes: false`。Coding agent 只能修改 `passes` 字段，不得删除或编辑测试。

```json
{
    "category": "functional",
    "description": "New chat button creates a fresh conversation",
    "steps": [
      "Navigate to main interface",
      "Click the 'New Chat' button",
      "Verify a new conversation is created",
      "Check that chat area shows welcome state",
      "Verify conversation appears in sidebar"
    ],
    "passes": false
}
```

### 选择 JSON 而非 Markdown 的原因

> JSON was chosen over Markdown because "the model is less likely to inappropriately change or overwrite JSON files compared to Markdown files."

### Initializer Agent 创建的文件

- `init.sh` —— 启动开发服务器的脚本
- `claude-progress.txt` —— 记录每个 agent session 做了什么的进度文件
- `feature_list.json` —— 包含 200+ feature 的结构化测试列表
- 初始 git commit —— 记录新增了哪些文件

### Session Startup Protocol（Coding Agent 每次启动流程）

1. Run `pwd` to confirm working directory
2. Read `claude-progress.txt` and git logs to get up to speed
3. Read `feature_list.json` and choose the highest-priority uncompleted feature
4. Run `init.sh` to start the dev server
5. Run a basic end-to-end test (e.g., start new chat, send message, receive response) before implementing anything new

```
[Assistant] I'll start by getting my bearings and understanding the current state of the project.
[Tool Use] <bash - pwd>
[Tool Use] <read - claude-progress.txt>
[Tool Use] <read - feature_list.json>
[Assistant] Let me check the git log to see recent work.
[Tool Use] <bash - git log --oneline -20>
[Assistant] Now let me check if there's an init.sh script to restart the servers.
<Starts the development server>
[Assistant] Excellent! Now let me navigate to the application and verify that some fundamental features are still working.
<Tests basic functionality>
[Assistant] Based on my verification testing, I can see that the fundamental functionality is working well...
<Starts work on a new feature>
```

### Failure Modes and Solutions

| Problem | Initializer Agent | Coding Agent |
|---|---|---|
| Declares victory too early | Creates structured JSON feature list from input spec | Reads feature list at session start; picks one feature to work on |
| Leaves bugs/undocumented progress | Creates initial git repo and progress notes file | Reads progress notes and git logs at start; runs basic tests; writes git commit and progress update at end |
| Marks features done prematurely | Sets up feature list file | Self-verifies all features; only marks "passing" after careful testing |
| Wastes time figuring out how to run the app | Writes `init.sh` script for dev server | Reads `init.sh` at session start |

### Testing with Browser Automation

Claude 需要使用 Puppeteer MCP server 等浏览器自动化工具，以人类用户的方式进行端到端测试，而非仅依赖单元测试或 curl 命令。

Known limitation: "Claude can't see browser-native alert modals through the Puppeteer MCP," making features relying on those modals buggier.

### 关键设计决策

- Initializer agent 和 coding agent 的区别仅在于初始 user prompt，system prompt、tools、agent harness 完全相同
- Coding agent 每次 session 只做一个 feature（增量推进）
- 每次 session 结束时必须 git commit + 更新 progress file
- Feature list 用 JSON 而非 Markdown，因为模型更不容易篡改 JSON

## 摘录

> The core challenge of long-running agents is that they must work in discrete sessions, and each new session begins with no memory of what came from before. Imagine a software project staffed by engineers working in shifts, where each new engineer arrives with no memory of what happened on the previous shift. Because context windows are limited, and because most complex projects cannot be completed within a single window, agents need a way to bridge the gap between coding sessions.

> Claude's failures manifested in two patterns. First, the agent tended to try to do too much at once -- essentially to attempt to one-shot the app. Often, this led to the model running out of context in the middle of its implementation, leaving the next session to start with a feature half-implemented and undocumented. The agent would then have to guess at what had happened, and spend substantial time trying to get the basic app working again.

> A second failure mode would often occur later in a project. After some features had already been built, a later agent instance would look around, see that progress had been made, and declare the job done.

> The key insight here was finding a way for agents to quickly understand the state of work when starting with a fresh context window, which is accomplished with the `claude-progress.txt` file alongside the git history. Inspiration for these practices came from knowing what effective software engineers do every day.

> We prompt coding agents to edit this file only by changing the status of a `passes` field, and we use strongly-worded instructions like "It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality."

> Providing Claude with these kinds of testing tools dramatically improved performance, as the agent was able to identify and fix bugs that weren't obvious from the code alone.

## 涉及实体
- [[Harness-Engineering]] —— Anthropic 官方的 agent harness 设计方案，initializer + coding agent 两阶段架构

## 涉及主题
- [[Harness-Engineering-主题]] —— agent 层面的 harness 设计：feature list、progress file、session startup protocol
- [[Agent架构演进-主题]] —— 长时间运行 agent 跨 context window 的架构挑战与解决方案
