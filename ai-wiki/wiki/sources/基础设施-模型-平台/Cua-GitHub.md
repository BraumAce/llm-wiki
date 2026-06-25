---
title: "Cua GitHub"
type: source
date: 2026-06-26
source_type: webpage
source_url: "https://github.com/trycua/cua"
author: "trycua"
ingested_at: 2026-06-26
tags:
  - computer-use-agent
  - desktop-automation
  - sandbox
  - benchmark
related_entities:
  - "[[Cua]]"
  - "[[MCP]]"
  - "[[OpenClaw]]"
related_topics:
  - "[[Agent架构演进-主题]]"
  - "[[AI-Infra推理优化-主题]]"
---

# Cua GitHub

## 一句话概括

Cua 是一套把桌面驱动、跨 OS 沙箱、Computer-Use benchmark 和 macOS 虚拟化组合在一起的 Agent 基础设施，适合补齐 coding agent 的真实电脑操作能力。

## 实践内容

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/trycua/cua/main/libs/cua-driver/scripts/install.sh)"
claude mcp add --transport stdio cua-driver -- cua-driver mcp
claude mcp add --transport stdio cua-computer-use -- cua-driver mcp --claude-code-computer-use-compat

pip install cua

# benchmark
git clone https://github.com/trycua/cua && cd cua/cua-bench
uv tool install -e . && cb image create linux-docker
cb run dataset datasets/cua-bench-basic --agent cua-agent --max-parallel 4
```

```python
from cua import Sandbox, Image

async with Sandbox.ephemeral(Image.linux()) as sb:
    result = await sb.shell.run("echo hello")
    screenshot = await sb.screenshot()
    await sb.mouse.click(100, 200)
    await sb.keyboard.type("Hello from Cua!")
```

## 摘录

> Drive native desktop apps in the background. Agents click, type, and verify without stealing the cursor or focus. Use the same CLI and MCP server on macOS and Windows from Claude Code, Cursor, Codex, OpenClaw, and custom clients. Linux support is available as a pre-release backend while platform testing is still in progress.

> Build agents that see screens, click buttons, and complete tasks autonomously. One API for any VM or container image — cloud or local. Evaluate computer-use agents on OSWorld, ScreenSpot, Windows Arena, and custom tasks. Export trajectories for training.

## 涉及实体

- [[Cua]] —— 本项目实体，负责 computer-use 桌面、沙箱、bench 和 VM 能力。
- [[MCP]] —— Cua Driver 通过 MCP 接入 Claude Code 等宿主。
- [[OpenClaw]] —— README 明确列出 OpenClaw 为可接入客户端之一。

## 涉及主题

- [[Agent架构演进-主题]]
- [[AI-Infra推理优化-主题]]

## 我的评注

这类项目说明 Agent 基础设施正在从“工具调用”下沉到“电脑能力层”。对知识库现有的 Harness/Loop 主题来说，Cua 是执行环境的底座补丁：有了可隔离桌面，loop 才能更真实地跑 GUI 任务；但也必须配套权限、审计、截图验证和失败恢复。
