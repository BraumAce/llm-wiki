---
title: "OpenHarness GitHub"
type: source
date: 2026-05-31
source_type: github
source_url: "https://github.com/HKUDS/OpenHarness"
author: "HKUDS"
ingested_at: 2026-05-31
tags:
  - agent
  - harness-engineering
  - open-source
  - infrastructure
related_entities:
  - "[[OpenHarness]]"
related_topics: []
---

# OpenHarness GitHub

## 一句话概括

香港大学 HKUDS 开源的轻量级 Agent 基础设施框架，提供 Agent Loop、43+ 工具、记忆持久化、多级权限和多智能体协调，附带可接入飞书/Slack/Telegram/Discord 的个人 AI 助手 ohmo。

## 实践内容

### 安装

```bash
# Linux / macOS / WSL 一键安装
curl -fsSL https://raw.githubusercontent.com/HKUDS/OpenHarness/main/scripts/install.sh | bash

# Windows PowerShell
iex (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/HKUDS/OpenHarness/main/scripts/install.ps1')

# pip 安装
pip install openharness-ai

# 从源码安装
git clone https://github.com/HKUDS/OpenHarness.git
cd OpenHarness
uv sync --extra dev
uv run oh
```

注意：Windows PowerShell 中使用 `openh` 代替 `oh`。

### 配置

```bash
# 引导式配置
oh setup

# 查看已有 workflow/profile
oh provider list

# 切换当前 workflow
oh provider use codex

# 查看认证状态
oh auth status

# 添加自定义兼容接口
oh provider add my-endpoint \
  --label "My Endpoint" \
  --provider anthropic \
  --api-format anthropic \
  --auth-source anthropic_api_key \
  --model my-model \
  --base-url https://example.com/anthropic
```

### 运行

```bash
# 交互模式（启动 React TUI）
oh

# 单次提示 → 标准输出
oh -p "Explain this codebase"

# JSON 输出，适合程序化使用
oh -p "List all functions in main.py" --output-format json

# 实时流式 JSON 事件
oh -p "Fix the bug" --output-format stream-json

# 干运行模式（不调用模型，预览配置）
oh --dry-run
oh --dry-run -p "Review this bug fix" --output-format json
```

### ohmo 个人 AI 助手

```bash
# 初始化（创建 soul.md、identity.md、user.md 等）
ohmo init

# 配置 gateway（支持 Telegram/Slack/Discord/飞书）
ohmo config

# 运行 gateway
ohmo gateway run

# 查看状态
ohmo gateway status
```

### 支持的 Provider

| Provider 类型 | 支持的模型 |
|--------------|-----------|
| Anthropic 兼容 | Claude、Moonshot/Kimi、智谱/GLM、MiniMax |
| Claude 订阅 | 复用本地 ~/.claude/.credentials.json |
| OpenAI 兼容 | OpenAI、OpenRouter、DashScope、DeepSeek、SiliconFlow、Groq、Ollama |
| Codex 订阅 | 复用本地 ~/.codex/auth.json |
| GitHub Copilot | OAuth 设备流 |

## 摘录

> OpenHarness 定义 Agent Harness 为「包裹 LLM 使其成为功能性 Agent 的完整基础设施」，提供工具、观察、记忆和安全控制。核心理念是：大模型提供智力，而 Harness（框架）则提供手、眼、记忆和安全边界。

> ohmo 是一个基于 OpenHarness 构建的个人 AI 助手，和其他聊天机器人不同，ohmo 是一个真正能帮你干活的助手。你可以把 ohmo 接入飞书、Slack、Telegram、Discord，它能帮你 fork 代码分支、编写代码、运行测试、打开 Pull Request。最棒的是，ohmo 直接利用你已有的 Claude Code 或 Codex 订阅，不需要额外的 API Key。

> OpenHarness 的核心是一个成熟的 Agent Loop，支持流式工具调用循环，工具执行、观察、循环一气呵成。内置指数退避重试机制，遇到 API 不稳定也能自动处理。支持 Token 计数和成本追踪，你可以清楚地知道每次调用花了多少钱。

## 涉及实体

- [[OpenHarness]] —— 港大 HKUDS 开源的 Agent 基础设施框架，本文的核心项目

## 涉及主题

（无）

## 我的评注（可选）

OpenHarness 在 Harness Engineering 语境下是 OpenClaw、Hermes Agent 之外的第三条路径。三者的核心差异：
- **OpenClaw**：上下文管理 + 双源记忆，侧重"记忆"
- **Hermes Agent**：Skill 自动生成 + RL 训练，侧重"学习"
- **OpenHarness**：工具生态 + 权限模型 + 多 Provider，侧重"基础设施"

ohmo 的设计理念值得关注——它不是一个独立产品，而是复用现有 Claude/Codex 订阅的"外壳"，降低了用户迁移成本。
