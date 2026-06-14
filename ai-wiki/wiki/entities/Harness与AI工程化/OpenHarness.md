---
title: "OpenHarness"
type: entity
date: 2026-05-31
also_known_as:
  - "oh"
  - "openh"
  - "OpenHarness CLI"
tags:
  - agent
  - open-source
  - harness-engineering
  - infrastructure
  - cli-tool
  - multi-agent
  - context-engineering
sources:
  - "[[OpenHarness-GitHub]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Claude-Code]]"
  - "[[OpenClaw]]"
---

# OpenHarness

## 一句话定义

OpenHarness 是香港大学数据科学学院（HKUDS）开源的轻量级 Agent 基础设施框架，提供 Agent Loop、43+ 工具、记忆持久化、多级权限和多智能体协调能力，附带可接入飞书/Slack/Telegram/Discord 的个人 AI 助手 ohmo。

## 摘要

OpenHarness 是 2026 年由香港大学数据科学学院（HKUDS）团队开源的 Python Agent 基础设施框架，以 `oh` 命令行工具形式发布。其核心理念是"大模型提供智力，Harness 提供手、眼、记忆和安全边界"——将 Agent Harness 定义为"包裹 LLM 使其成为功能性 Agent 的完整基础设施"。框架内置成熟的 Agent Loop（支持流式工具调用、指数退避重试、Token 计数和成本追踪）、43+ 个工具（文件操作、Shell、搜索、网页、MCP）、Markdown 技能按需加载、CLAUDE.md 自动注入、MEMORY.md 持久记忆、多级权限模式（Default/Auto/Plan）和子智能体协调机制。配套的 ohmo 个人 AI 助手可接入飞书、Slack、Telegram、Discord，直接复用现有 Claude Code 或 Codex 订阅，无需额外 API Key。支持 Claude、OpenAI、Codex、GitHub Copilot、Moonshot、智谱、MiniMax、OpenRouter、DeepSeek、Ollama 等 15+ 模型提供商。项目以 MIT 许可证开源，在 Harness Engineering 语境下是 OpenClaw、Hermes Agent 之外的又一重要实现路径。

## 详情

### 起源与背景

OpenHarness 由香港大学数据科学学院（HKUDS）团队开发维护。HKUDS 是香港大学在数据科学和人工智能领域的重要研究机构，在 Agent 基础设施和多智能体系统方面有深厚积累。

项目的出发点是解决 AI Agent 开发中的一个普遍痛点：开发者想要构建真正能干活的 Agent，但从工具调用到权限管理、从记忆持久化到多智能体协作，每一步都是坑。OpenHarness 不是另一个聊天机器人 demo，而是一套可以在生产环境使用的 Agent 基础设施。

在 Harness Engineering 的语境下，OpenHarness 与 OpenClaw、Hermes Agent 并列为三种典型的 Harness 实现路径。OpenClaw 侧重上下文管理和双源记忆，Hermes 侧重 Skill 自动生成和 RL 训练闭环，而 OpenHarness 则侧重工具生态、权限模型和多智能体协调。

### 核心机制 / 工作原理

**代码架构**

OpenHarness 的代码库组织为 10+ 个子系统：

| 子系统 | 职责 |
|--------|------|
| `engine/` | Agent Loop：流式处理、工具调用、重试逻辑、并行执行 |
| `tools/` | 43+ 工具，Pydantic 验证 + JSON Schema + 权限集成 |
| `skills/` | Markdown 技能按需加载，兼容 anthropics/skills |
| `plugins/` | 扩展系统，兼容 claude-code 插件，已测试 12 个官方插件 |
| `permissions/` | 多级权限模式（Default/Auto/Plan），路径级规则，命令黑名单 |
| `hooks/` | PreToolUse / PostToolUse 生命周期事件 |
| `commands/` | 54 个内置斜杠命令 |
| `mcp/` | Model Context Protocol 客户端 |
| `memory/` | 跨会话持久记忆存储 |
| `coordinator/` | 子智能体生成和团队协调 |
| `ui/` | React/Ink 终端 UI，完整交互式界面 |

**Agent Loop 核心流程**

```
用户输入 → 模型流式响应 → 检测工具调用请求
  → 权限检查 → PreToolUse 钩子 → 执行工具
  → PostToolUse 钩子 → 将结果反馈给模型
  → 循环直到模型完成
```

内置指数退避重试机制处理 API 不稳定情况，支持 Token 计数和成本追踪。

**多级权限模型**

- **Default 模式**：标准权限，工具调用需用户确认
- **Auto 模式**：自动执行，适合可信场景
- **Plan 模式**：先规划再执行，适合复杂任务

支持路径级别和命令级别的细粒度规则配置。

**上下文与记忆**

- **CLAUDE.md 自动注入**：自动发现并注入项目中的 CLAUDE.md 文件
- **自动上下文压缩**：多日会话中保持任务状态和通道日志
- **MEMORY.md 持久记忆**：跨会话的知识存储
- **会话恢复**：中断后可恢复之前的对话状态

**多 Provider 支持**

通过 workflow 和 profile 概念管理模型提供商：

| Provider 类型 | 支持的模型 |
|--------------|-----------|
| Anthropic 兼容 | Claude 官方、Moonshot/Kimi、智谱/GLM、MiniMax |
| Claude 订阅 | 复用本地 `~/.claude/.credentials.json` |
| OpenAI 兼容 | OpenAI、OpenRouter、DashScope、DeepSeek、SiliconFlow、Groq、Ollama |
| Codex 订阅 | 复用本地 `~/.codex/auth.json` |
| GitHub Copilot | OAuth 设备流，无需 API Key |

### 应用 / 使用场景

- **个人 AI 编程助手**：通过 ohmo 接入飞书/Slack/Telegram/Discord，让 AI 帮你 fork 分支、写代码、跑测试、开 PR，24 小时不休息的编程伙伴
- **Agent 开发框架**：提供完整的 Agent Loop、工具调用、权限管理基础设施，开发者可在此基础上构建自定义 Agent
- **多智能体协调**：子智能体生成和团队注册机制，适合构建复杂的多 Agent 工作流
- **安全敏感场景**：多级权限模式和 PreToolUse/PostToolUse 钩子，满足企业级安全合规需求
- **成本敏感场景**：内置 Token 计数和成本追踪，精确控制 API 调用开销
- **开发调试**：干运行模式（`oh --dry-run`）可在不调用模型的情况下预览配置、技能、工具和认证状态

### 局限与争议

- **项目成熟度**：作为较新的开源项目，社区生态和长期稳定性有待验证
- **Windows 兼容性**：Windows PowerShell 中需使用 `openh` 而非 `oh` 命令，因为 `oh` 与内置 `Out-Host` 别名冲突
- **依赖 Claude/Codex 订阅**：ohmo 的核心卖点是复用现有订阅，但这也意味着对 Anthropic/OpenAI 平台的依赖
- **ClawTeam 集成未完成**：Roadmap 中提到的 ClawTeam 多智能体协作功能尚未实现
- **文档语言**：主要面向中文社区，英文文档相对有限
- **与 OpenClaw 的差异化**：两者都属于 Harness 工程领域，功能有重叠，OpenHarness 需要更清晰地定义自己的差异化优势

## 与其他实体的关系

- [[Harness-Engineering]] —— OpenHarness 是 Harness 理念的直接实现，项目名称本身就包含 "Harness"；在 Agent = Model + Harness 的框架下，OpenHarness 提供了完整的 Harness 层
- [[Claude-Code]] —— OpenHarness 的技能系统兼容 anthropics/skills，插件系统兼容 claude-code 插件；ohmo 可复用 Claude Code 订阅
- [[OpenClaw]] —— 同为 Agent Harness 实现，功能有重叠但侧重不同：OpenClaw 侧重上下文管理和双源记忆，OpenHarness 侧重工具生态和权限模型
- [[Hermes-Agent]] —— 同为 Agent 基础设施，Hermes 侧重 Skill 自动生成和 RL 训练闭环，OpenHarness 侧重工具调用和多 Provider 兼容

## 参考来源

- [[OpenHarness-GitHub]] —— HKUDS 官方 GitHub 仓库，包含完整的架构设计、安装指南、Provider 配置、ohmo 助手设置和 API 文档
