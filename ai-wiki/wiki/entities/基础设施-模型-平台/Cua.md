---
title: "Cua"
type: entity
date: 2026-06-26
also_known_as:
  - "trycua/cua"
  - "Cua Drivers"
  - "Cua Sandbox"
tags:
  - computer-use-agent
  - desktop-automation
  - sandbox
  - benchmark
  - mcp
sources:
  - "[[Cua-GitHub]]"
related_entities:
  - "[[MCP]]"
  - "[[OpenClaw]]"
  - "[[RMUX]]"
  - "[[OfficeCLI]]"
---

# Cua

## 一句话定义

Cua 是面向 Computer-Use Agent 的开源基础设施套件，把桌面驱动、跨系统沙箱、评测基准和 macOS/Linux 虚拟化工具组合成一套可给 Claude Code、Cursor、Codex、OpenClaw 等 Agent 使用的“电脑使用层”。

## 摘要

Cua 的核心价值不是再造一个聊天式 Agent，而是把“让 Agent 真正操作电脑”这件事拆成可复用的基础设施：后台桌面驱动负责在不抢鼠标焦点的情况下点击、输入、截图和验证；Sandbox SDK 提供 Linux、macOS、Windows、Android 等环境的一致 API；Cua-Bench 面向 OSWorld、ScreenSpot、Windows Arena 等任务做评测与轨迹导出；Lume 则把 Apple Silicon 上的 macOS/Linux VM 管理纳入同一工程体系。对 AI 工程来说，它补的是传统编码 Agent 很缺的一层：可隔离、可复现、可评测的完整桌面环境。

## 详情

### 起源与背景

Computer-use Agent 的难点在于模型并不只需要“会写命令”，还需要看屏幕、定位窗口、点击控件、确认结果，并且最好不要打断用户当前桌面。浏览器自动化可以覆盖网页，但无法覆盖原生应用、Office、终端、多窗口和跨操作系统任务。Cua 的 README 把项目分成四条路径：构建自己的电脑使用 Agent 用 Cua，给编码 Agent 一台电脑用 Cua Drivers，训练或评测模型用 Cua Bench，需要 macOS VM 则用 Lume。这种分层说明它更像 Agent OS 基础设施，而不是单一工具。

### 核心机制 / 工作原理

Cua Drivers 是后台 computer-use 驱动，支持 macOS 和 Windows，Linux 处于预发布后端；它通过 CLI 和 MCP server 接入 Claude Code、Cursor、Codex、OpenClaw 或自定义客户端。Cua Sandbox 则提供异步 API：创建临时沙箱、运行 shell、截图、鼠标点击、键盘输入和移动端手势。Cua Bench 把环境、任务和 Agent 跑分放在同一套 CLI 里，支持并行执行和轨迹导出。Lume 专注 Apple Silicon 上的 macOS/Linux VM，解决本地近原生性能和镜像管理问题。

```python
from cua import Sandbox, Image

async with Sandbox.ephemeral(Image.linux()) as sb:
    result = await sb.shell.run("echo hello")
    screenshot = await sb.screenshot()
    await sb.mouse.click(100, 200)
    await sb.keyboard.type("Hello from Cua!")
```

### 应用 / 使用场景

- 给 Claude Code、Codex、OpenClaw 这类编码 Agent 接一层后台桌面，不抢用户焦点也能操作原生应用。
- 在云端或本地启动 Linux/macOS/Windows/Android 环境，让 Agent 任务跑在隔离环境中。
- 对 computer-use 模型做 OSWorld、ScreenSpot、Windows Arena 或自定义任务评测。
- 用 Lume 管理 macOS VM，给需要真实 macOS 应用、Xcode、Safari 或桌面状态的任务提供运行基座。

### 局限与争议

Cua 仍然依赖底层虚拟化、操作系统权限和平台适配质量。对团队而言，真正难点不只是安装驱动，而是把截图、点击、验证和失败恢复做进 Harness；否则 Agent 只是多了一只能点屏幕的手。另一个边界是安全：一旦 Agent 可以操作完整桌面，凭证、文件、剪贴板和系统权限都需要更严格的隔离与审计。

## 与其他实体的关系

- [[MCP]] —— Cua Drivers 通过 MCP server 给 Agent 暴露桌面操作能力。
- [[OpenClaw]] —— README 明确把 OpenClaw 列为可接入 Cua Drivers 的客户端之一。
- [[RMUX]] —— 两者都在补 Agent 运行环境层：Cua 偏 GUI/桌面，RMUX 偏终端/TUI 会话。
- [[OfficeCLI]] —— OfficeCLI 解决 Office 文档的结构化编辑，Cua 解决更广的桌面控制，两者都让 Agent 从纯文本生成走向可观察可修复的工作循环。

## 参考来源

- [[Cua-GitHub]]
