---
title: "Tutti"
type: entity
date: 2026-07-06
also_known_as:
  - "tutti-os/tutti"
  - "Tutti · Local"
  - "Tutti · VM"
tags:
  - multi-agent
  - shared-workspace
  - local-first
  - desktop
sources:
  - "[[Tutti-GitHub]]"
related_entities:
  - "[[Multica]]"
  - "[[Agentic-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Claude-Code]]"
  - "[[OpenClaw]]"
---

# Tutti

## 一句话定义

Tutti 是一个本地优先的 Agent-Agent 实时共享工作空间，让多个 Agent、应用、文件、任务和运行状态在同一个桌面环境中可见、可引用、可接力。

## 摘要

Tutti 解决的是多 Agent 工作流里的“传话筒”问题：Claude Code 写完接口，Codex 接前端，设计工具生成视觉稿，文档或 PPT 工具产出材料，传统流程需要人不断复制文件、摘要进度、解释约束、上传下载产物。Tutti 的主张是把这些上下文和产物变成同一个工作空间里的对象，让 Codex 可以引用 Claude 的历史对话、文件、任务和应用输出，也让 Agent 可以调用生图、UI/UX、文档、PPT 等应用。

它不是替代 [[Claude-Code]]、Codex 或 [[OpenClaw]] 这类具体 coding agent，而是围绕它们构建共享工作台。开源版本强调本地运行：Agent 跑在本机，工作态在本地，多 Agent 共享上下文、应用、产物、任务和运行状态。Tutti · VM 则进一步把本地 Agent 的工作态虚拟化进云端 Room，支持多设备、多用户、跨团队共享同一工作空间。

## 详情

### 起源与背景

随着多个 AI Agent 同时参与真实工作流，瓶颈从“单个模型会不会写代码”转向“多个 Agent 如何共享状态”。如果每个 Agent 都有独立窗口、独立历史、独立文件入口和独立工具生态，人类就会承担隐性编排职责：把接口文档贴给下一个 Agent，把设计稿下载再上传，把前序决策重新讲一遍，把任务拆分、审批和冲突处理都手动维护。Tutti 把这个痛点定义为 Agent 之间缺少实时共享工作空间。

这个定位与 [[Multica]] 有相似之处，但焦点不同。Multica 更像 managed agents 平台，围绕 issue、squad、autopilot、runtime status 组织 Agent 团队；Tutti 更像本地桌面工作空间，强调文件、应用产物、历史对话、任务和运行状态在 Agent 间实时流动。二者都说明多 Agent 系统正在从“多开几个 CLI”演进到“有持久状态和可审查交接的工作台”。

### 核心机制 / 工作原理

Tutti README 把产品能力拆成三组：

1. **实时共享工作空间**：Agent 不再只交接摘要，而是共享上下文、文件、在跑任务和应用输出。Big `@` 允许在 Codex 中引用历史对话、文件、应用、任务，也可以引用 Claude Code 的历史产物并继续构建。`+` 引用则把本地文件或应用生成产物纳入本轮 Agent 输入。
2. **人和 Agent 共用的应用中心**：原型设计、生图、文档、PPT 等应用不是孤立工具，而是工作空间对象。人可以手动使用，Agent 也可以调用，产物留在同一空间供下一步引用。
3. **目标到任务与控制中心**：用户描述目标后，Tutti 可拆解为子任务并分配给合适 Agent；控制中心集中显示 Agent 对话、审批、运行任务和需要人处理的事项。

从仓库实现看，Tutti 是 local-first desktop monorepo：`apps/desktop` 负责 Electron 壳、preload、renderer UI 和桌面集成；`services/tuttid` 负责业务规则、持久本地状态和 daemon 工作流；`packages/*` 只承载真实共享接口；`config` 存机器可消费默认配置。根 AGENTS 文件明确要求业务逻辑留在 `services/tuttid`，不要让桌面 UI 变成第二业务核心，也不要创建 `shared/common/utils/client-sdk` 这类模糊包。

```text
services/tuttid -> business rules, durable local state, daemon workflows
apps/desktop    -> Electron shell, preload, renderer UI, desktop integration
packages/*      -> real shared seams with narrow names
config          -> machine-consumable runtime defaults
```

仓库内置的 `tutti-architecture-review` skill 进一步体现了 [[Harness-Engineering]] 思路：它把项目结构、分层、module ownership 和 event-center 复用规则变成可执行 review planner。主 Agent 可以基于 diff 或 scope file 生成 review task package，再编排子 Agent 检查各自范围。这意味着 Tutti 不只在产品层讲多 Agent 协作，也在自身仓库里用 skill 化方式约束 Agent 改代码。

### 应用 / 使用场景

- 一个人同时使用 Claude Code、Codex、设计/生图/文档应用，希望前序产物能被下一个 Agent 直接引用。
- 复杂项目中让一个 Agent 写 PRD、另一个 Agent 写前端、再由应用生成原型或 PPT，减少手动下载、上传和复述。
- 多设备或多人协作场景下，通过 Tutti · VM 的 Room 共享本地 Agent 工作态、localhost 预览、任务进展和应用产物。
- 对团队来说，把 Agent 对话、文件、任务和审批统一放入控制中心，降低跨工具切换和隐性编排成本。

### 局限与争议

- **共享边界**：Tutti · VM 以 Room 为共享边界，只有同一 Room 里的内容才共享。这个模型需要清晰权限、审计和隔离，否则“上下文全可见”会变成隐私风险。
- **不是替代 Agent 能力**：Tutti 的价值来自连接、引用、编排和产物流转；具体编码质量仍取决于 Claude Code、Codex、[[OpenClaw]] 等运行时。
- **工作台复杂度**：把任务、文件、应用、审批、Agent 状态都放在一个空间里，要求 UI、状态模型和冲突处理足够清晰，否则可能只是把多个工具的复杂度集中在一个界面。
- **本地优先与云端共享的张力**：开源本地版强调工作态在本地，VM 版强调云端 Room 协作；两者在安全、延迟、同步和可恢复性上会有不同工程约束。

## 与其他实体的关系

- [[Multica]] —— 两者都面向多 Agent 协作，Multica 偏 issue/squad/runtime 管理，Tutti 偏实时共享工作空间和应用产物流转。
- [[Agentic-Engineering]] —— Tutti 把 Agentic Engineering 的控制流问题扩展到跨 Agent 状态共享、任务拆解和产物引用。
- [[Harness-Engineering]] —— 仓库通过 AGENTS、架构文档、分层 reference 和 review skill 把 Agent 修改纳入可审查工程纪律。
- [[Claude-Code]] —— README 中的核心接入对象之一，Tutti 让 Codex 可引用 Claude Code 的上下文和产物。
- [[OpenClaw]] —— README 提到的规划接入 runtime，代表 Tutti 想支持跨 provider、跨本地 Agent 的协作。

## 参考来源

- [[Tutti-GitHub]]
