---
title: "OmniRoute"
type: entity
date: 2026-07-05
also_known_as:
  - "diegosouzapw/OmniRoute"
  - "omniroute"
tags:
  - ai-gateway
  - model-routing
  - fallback
  - token-compression
  - mcp
  - a2a
sources:
  - "[[OmniRoute-GitHub]]"
related_entities:
  - "[[Token成本控制]]"
  - "[[Prompt-Cache]]"
  - "[[MCP]]"
  - "[[Claude-Code]]"
  - "[[Cursor]]"
  - "[[whichllm]]"
---

# OmniRoute

## 一句话定义

OmniRoute 是一个本地优先的 AI gateway，把多个 AI 编码工具接入同一个 OpenAI-compatible / Anthropic-compatible 代理层，并在代理层集中处理 provider 路由、fallback、quota、压缩、MCP/A2A、成本和观测。

## 摘要

[[OmniRoute-GitHub]] 的核心定位是 “The Free AI Gateway”：用户把 Claude Code、Codex、Cursor、Cline、Copilot、Antigravity 等工具指向 `http://localhost:20128/v1` 或相应协议入口，由 OmniRoute 在本机代理请求，再根据 provider、账号、费用、健康度、上下文长度、quota、fallback 和压缩策略选择实际上游。它不是一个模型服务框架，而是一个位于开发工具与模型 provider 之间的控制面；它的目标也不是追求单模型最高质量，而是让开发过程不断流、成本可控、限额可绕开、工具配置统一。

该项目的重要性在于把 [[Token成本控制]] 从个人使用习惯上移到运行时治理层。README 强调 237 providers、90+ free providers、17 routing strategies、RTK + Caveman compression、MCP/A2A、memory、guardrails、TLS fingerprint stealth、Desktop/PWA 和多工具一键配置。仓库中的 `src/domain/fallbackPolicy.ts`、`comboResolver.ts`、`policyEngine.ts`、`quotaCache.ts`、`costRules.ts`、`pipeline.ts` 等模块也显示它把路由策略、fallback chain、任务 pipeline、成本估算和降级策略当作 domain layer 处理，而不只是简单反向代理。

## 详情

### 起源与背景

AI Coding Agent 的一大现实问题是上游碎片化：Claude Code、Codex、Cursor、Cline 等工具各自有认证方式、模型名、base URL、quota 和请求格式；开发者还可能同时持有订阅额度、API key、免费 provider、企业账号和本地模型。单个工具内部很难把所有上游组合好，OmniRoute 因此把自己放在工具前面，做统一端点、统一 dashboard、统一 provider catalog 和统一路由账本。

### 核心机制 / 工作原理

最小路径是安装后启动本地服务，dashboard 在 `http://localhost:20128`，API 在 `http://localhost:20128/v1`。工具侧只需要配置 base URL 和 key；OmniRoute 负责 provider 解析、combo 执行、fallback、quota-share、compression pipeline 和返回格式翻译。README 的 resilience 模型拆成三层：provider 级 circuit breaker、account/key 级 connection cooldown、provider+model 级 model lockout。这样一个模型限流不必拖垮整个 provider，一个 key 冷却不必拖垮整个账号池。

```bash
npm install -g omniroute
omniroute
curl http://localhost:20128/v1/models -H "Authorization: Bearer YOUR_KEY"
```

源码中的 pipeline 机制把不同任务映射到阶段。例如 code 任务可拆成 plan、execute、reflect、fix，并分别标注 `best-reasoning`、`cheapest`、`moderate` 等 fitness tier。这说明 OmniRoute 不只是选择“某个模型”，还把多阶段执行、低价执行与中等成本复核纳入路由计划。MCP/A2A 入口则让 agent 可以反向操作 gateway 自身，例如管理 provider、combo、cache、compression 和 tokens。

### 应用 / 使用场景

- 多个 coding CLI/IDE 共用一套模型账号、免费额度和成本策略。
- 订阅额度、API key、免费 provider、便宜 provider 需要按优先级 fallback。
- 团队希望把 quota、cost、cache、compression 和 provider health 放到 dashboard 中观察。
- 需要让 Claude Code、Codex、Cursor 等工具统一走 MCP/A2A 或 OpenAI-compatible 端点。

### 局限与争议

OmniRoute 的强项是“请求路由与成本治理”，不是替代模型推理质量、代码验证或业务验收。压缩链如果过度 aggressive，可能省 token 但损失上下文语义；fallback 如果只看可用性不看任务适配，也可能把复杂任务路由给便宜但不合适的模型。另一个风险是账号和密钥集中：虽然 README 强调本地优先、加密和零 telemetry，但实际部署仍需要明确 token scope、loopback 限制、审计日志和团队权限。

## 与其他实体的关系

- [[Token成本控制]] —— OmniRoute 把成本、quota、compression、routing 和 provider fallback 做成 gateway 层能力。
- [[Prompt-Cache]] —— session stickiness 与 prompt-cache integrity 是 quota-share 和 fallback 设计中的关键约束。
- [[MCP]] —— OmniRoute 暴露 MCP server，让 agent 可管理 gateway 自身。
- [[Claude-Code]] —— README 明确支持 Claude Code 配置和 launch 路径。
- [[Cursor]] —— README 与源码均覆盖 Cursor/Cloud Agent 场景。
- [[whichllm]] —— whichllm 解决本地模型选型，OmniRoute 解决多 provider 路由，两者都属于模型使用前的基础设施决策层。

## 参考来源

- [[OmniRoute-GitHub]]
