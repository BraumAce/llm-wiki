---
title: "OpenClaw"
type: entity
date: 2026-05-10
also_known_as: ["OpenClaw AI Agent"]
tags:
  - ai-agent
  - personal-assistant
  - local-first
  - open-source
  - agentic
sources:
  - "[[深入理解OpenClaw技术架构与实现原理-上]]"
  - "[[深入理解OpenClaw技术架构与实现原理-下]]"
related_entities:
  - "[[OpenClaw-SandBox]]"
---

# OpenClaw

## 一句话定义

OpenClaw 是一个开源的、本地优先（Local-First）的个人 AI 助手系统，以 Gateway 网关为统一控制平面，通过 WhatsApp/Telegram/Discord 等已有通讯应用与用户交互，并具备主动任务、持久记忆、浏览器/系统操控、自我修改等能力。官方 slogan："The AI that actually does things."

## 摘要

OpenClaw 与"在专有 Web 界面里被动应答"的同代工具走在两条不同的路线上。它把 AI 注入用户**已有的社交生态**，运行在用户**自己的设备**上，强调**主动性**与**自进化**——可以编写自己的 Skills、修改自己的提示词、定时执行任务、跨多个设备节点协作。

阅读两篇官方深度技术解析后可以把它定位为：**"以 Gateway 为心脏的分布式个人 Agent 框架，强调本地优先 + 多通道接入 + AI-Coding 自演化"**。其设计哲学最让作者震撼的一点是——**几乎所有能力都是通过 AI-Coding 实现的**，原文称之为"开启新的软件构建范式的开山之作"。

## 详情

### 起源与背景

OpenClaw 诞生于 2025-2026 年个人 AI 助手赛道急剧分化的窗口：一边是 ChatGPT/Claude 这类云端封闭产品，另一边是 Claude Code / OpenCode / Aider 这类聚焦"AI Coding"的开发者工具。OpenClaw 的位置在更"日常"的一侧——目标用户不仅是开发者，也包括以 IM 为主要工作面的非技术用户。它的两个关键差异化是：**部署在用户自己的设备上**（数据不离开本机）、**接入用户已经在用的通讯软件**（不强迫切换平台）。

### 整体架构

OpenClaw 采用以 **Gateway（网关）为单一控制平面**的分布式架构。Gateway 是一个常驻 WebSocket 服务器（默认端口 18789），负责消息路由、会话管理、工具调用协调、节点通信、HTTP API（OpenAI 兼容）。客户端、工具、事件全部经由 Gateway 流转。

```
┌─────────────────────────────────────────────────────┐
│                   Gateway 进程                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │WebSocket │  │ HTTP API │  │ Control  │          │
│  │  Server  │  │ (OpenAI) │  │   UI     │          │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘          │
│       └─────────────┴─────────────┘                 │
│                     │                               │
│              ┌──────┴──────┐                        │
│              │  RPC Router │                        │
│              └──────┬──────┘                        │
│       ┌─────────────┼─────────────┐                 │
│  ┌────┴────┐  ┌─────┴─────┐  ┌────┴────┐          │
│  │Channels │  │  Agents   │  │  Nodes  │          │
│  └─────────┘  └───────────┘  └─────────┘          │
└─────────────────────────────────────────────────────┘
```

Gateway 之上挂了三类执行单元：
- **Channels**：消息接入层。原生支持 WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams、Matrix、Zalo 等十几种 IM 通道
- **Agents**：智能体运行时（Pi Agent），以 RPC + 工具流模式运行，支持多智能体路由（不同频道/账户拥有相互隔离的工作空间与会话）
- **Nodes**：把 macOS / iOS / Android 等设备定义为节点，通过 `node.invoke` 协议远程调用硬件能力（摄像头、屏幕录制、地理位置、`system.run` 等）

### 16 大模块清单

按文章原文目录，OpenClaw 的核心模块是：

1. 统一控制平面 **Gateway** 网关（WebSocket + 协议版本化 + 角色分离 operator/node）
2. **Agentic Loop / Pi Loop**：事件驱动的推理循环，主循环→单次尝试→事件订阅→工具循环
3. **定时任务系统**：cron 调度、任务持久化、心跳集成、Webhook 通知
4. **工具系统**：分层架构（创建层 → 定义层 → schema 规范化 → 策略管道 → 执行层 → 插件 → HTTP API）
5. **Channels**：抽象的消息通道，统一的消息流转架构与适配器
6. **上下文管理**：上下文窗口管理、压缩、剪枝、工具结果守卫、运行时上下文注入
7. **SubAgent 子智能体**：会话键 + 注册表 + 派生逻辑 + 通告机制 + 独立工具系统
8. **SandBox 沙箱系统** —— 见 [[OpenClaw-SandBox]]
9. **记忆管理**：文件即真相（Markdown + SQLite + 向量），混合搜索（向量 + BM25），MMR 去重，时间衰减
10. **Skills 模块**：Skills 优先级加载、过滤逻辑、文件监听、安装支持类型（含 GitHub）
11. **Session 管理**：session key 设计、生命周期、存储、清理、投递路由、归档
12. **自进化机制**：动态系统提示、自我修改可写文件、自我更新指令、进化循环
13. **工作区与 Agent 路由**：多代理路由策略、会话键策略、性能优化
14. **Nodes**：配对流程、Node Host 架构、命令系统、唤醒机制、事件处理、安全机制
15. **安全策略**：信任模型、插件信任边界、执行沙箱默认行为、Web 接口安全、工具文件系统加固
16. **配置管理**：热重载（off / hot / restart / hybrid）、profile 轮换

### 核心设计哲学

- **Local-First**：Gateway 默认绑定回环地址，远程访问通过 SSH 隧道或 Tailscale serve/funnel；所有数据落到 `~/.openclaw/workspace/` 本地目录
- **文件即真相**：记忆不是数据库黑盒，是用户可直接打开编辑的 `MEMORY.md` + 按日期分文件的 `memory/YYYY-MM-DD.md`，索引（SQLite + 向量）只是辅助
- **协议优先**：客户端声明 `minProtocol/maxProtocol`，服务端拒绝不匹配连接；版本化避免分布式协议漂移
- **AI-Coding 优先**：多数能力由 AI 自己写出来，而不是人手写，这也是文章作者最看重的范式意义

### 应用 / 使用场景

- 个人效率：邮件/日程整理、跨 IM 自动应答、定时执行后台工作流
- 跨设备控制：在 macOS 上发起任务，调用 iOS 的摄像头、录屏，再把结果回到 IM
- 团队级 Agent：多人共用 Gateway，按 channel 路由到不同 Agent，互不串扰
- 离线/隐私敏感场景：数据不出本机，密钥不交给服务商

### 局限与争议

- **运维复杂度**：与"打开网页就用"的产品相比，需要 Node ≥22 + Gateway 守护进程 + Docker（启用沙箱时）+ 通道接入凭证；门槛偏高
- **公网暴露风险**：作者明确建议**不要直接把 Gateway 暴露到公网**，要走 Tailscale/SSH 隧道；任何把 bind 改成 `0.0.0.0` 的部署都需要谨慎
- **自进化的边界尚未充分讨论**：Self-modifying 在工程上很有想象力，但从安全/调试角度，何时回滚、如何审计仍是开放问题
- **国内通道支持有限**：原生支持的通道集中在海外 IM，微信/钉钉/飞书等需要自己写适配器

## 与其他实体的关系

- [[OpenClaw-SandBox]] —— 安全隔离子系统，决定 OpenClaw "什么工具能在哪里跑"

## 参考来源

- [[深入理解OpenClaw技术架构与实现原理-上]]
- [[深入理解OpenClaw技术架构与实现原理-下]]
- 官方网站：https://openclaw.ai/
