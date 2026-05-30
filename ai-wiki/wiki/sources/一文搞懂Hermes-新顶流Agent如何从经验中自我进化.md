---
title: "一文搞懂Hermes：新顶流Agent如何从经验中自我进化"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/yHva-zLaRTxe8b4HSUr86Q"
author: ""
ingested_at: 2026-05-30
tags: [hermes-agent, self-improving, learning-loop, skill-creation, agent-memory, multi-platform]
related_entities: [Hermes-Agent, Nous-Research, OpenClaw]
related_topics: [Agent架构演进-主题]
---

# 一文搞懂Hermes：新顶流Agent如何从经验中自我进化

## 一句话概括
Hermes Agent 是 Nous Research 开源的自进化 AI Agent，其核心创新在于内置学习闭环——任务完成后自主创建 Skill、在后续使用中持续改进、跨会话持久化知识并构建用户画像，实现从"每次对话归零"到"越用越聪明"的跨越。

## 实践内容

### 安装

Linux / macOS / WSL2 / Termux:
```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

Windows (PowerShell) — Early Beta:
```powershell
iex (irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1)
```

### 常用命令

| Command | Purpose |
|---------|---------|
| `hermes` | Interactive CLI conversation |
| `hermes model` | Choose LLM provider and model |
| `hermes tools` | Configure enabled tools |
| `hermes config set` | Set individual config values |
| `hermes gateway` | Start messaging gateway |
| `hermes setup` | Full setup wizard |
| `hermes claw migrate` | Migrate from OpenClaw |
| `hermes update` | Update to latest version |
| `hermes doctor` | Diagnose issues |

### 从 OpenClaw 迁移

```bash
hermes claw migrate              # Interactive migration
hermes claw migrate --dry-run    # Preview only
hermes claw migrate --preset user-data   # Migrate without secrets
hermes claw migrate --overwrite  # Overwrite conflicts
```

Imported items: SOUL.md persona file, memories (MEMORY.md and USER.md), user-created skills, command allowlist, messaging settings, API keys, TTS assets, and workspace instructions (AGENTS.md).

### Nous Portal 集成

```bash
hermes setup --portal
```

Nous Portal 提供统一订阅覆盖 300+ 模型，Tool Gateway 包含 web search (Firecrawl)、image generation (FAL)、TTS (OpenAI)、cloud browser (Browser Use)。

### 从源码构建

```bash
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
./setup-hermes.sh     # installs uv, creates venv, installs .[all], symlinks ~/.local/bin/hermes
./hermes              # auto-detects the venv
```

## 摘录
> Hermes Agent 是一个自进化 AI Agent，内置学习闭环：任务完成后自主创建 Skill，在后续使用中持续改进 Skill，跨会话持久化知识，搜索历史对话，并构建跨会话的用户画像。不同于大多数每次对话从零开始的无状态 Agent，Hermes 持久化知识并随时间优化。

> 六种运行时后端——local、Docker、SSH、Singularity、Modal 和 Daytona。Daytona 和 Modal 提供无服务器持久化，环境空闲时休眠，按需唤醒。

> Hermes 支持 Nous Portal、OpenRouter (200+ models)、NovitaAI、NVIDIA NIM、Xiaomi MiMo、z.ai/GLM、Kimi/Moonshot、MiniMax、Hugging Face、OpenAI 或自定义端点。通过 `hermes model` 切换——无需代码改动，无供应商锁定。

## 涉及实体
- [[Hermes-Agent]] —— 本文主角，Nous Research 开源的自进化 AI Agent，具备学习闭环、Skill 自主创建与跨会话记忆
- [[Nous-Research]] —— Hermes Agent 的开发团队，同时维护 Nous Portal 统一模型订阅平台
- [[OpenClaw]] —— Hermes 的前身/竞品，Hermes 提供一键迁移工具 `hermes claw migrate`

## 涉及主题
- [[Agent架构演进-主题]]
