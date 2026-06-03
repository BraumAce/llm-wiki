---
title: "Credential-Brokering"
type: entity
date: 2026-06-03
also_known_as:
  - "凭证代理"
  - "Credential Broker"
  - "Agent 凭证管理"
tags:
  - security
  - infra
  - ai-agent
  - authentication
sources:
  - "[[重新思考研发基础设施-当Agent成为第一公民]]"
related_entities:
  - "[[Agent-Oriented-Infra]]"
  - "[[Harness-Engineering]]"
---

# Credential Brokering

## 一句话定义

Credential Brokering 是一种 Agent 安全范式：Agent 发出请求时携带占位符而非真实凭证，Broker 认证 Agent 身份后将占位符替换为真实凭证转发请求，Agent 全程不接触真实凭证。Anthropic、Vercel、Cloudflare、LangChain 各自从不同层独立趋同到这一范式。

## 摘要

Credential Brokering 解决了 Agent 时代的核心安全矛盾：Agent 需要凭证来访问外部服务，但 Agent 本身不能被信任持有这些凭证 — 因为 prompt injection 可能导致凭证泄露。解法是在 Agent 和凭证之间画一条信任边界，引入一个 Credential Broker 代理层。这代表了从"Agent 持有凭证"到"Agent 完全不接触凭证"的安全演进线。

## 详情

### 为什么需要 Credential Brokering

**人的时代的身份管理：**
- 人分为前端、后端、运维等角色
- 各系统为各自角色设计，各自有各自的身份体系
- 每个人实际只接触自己角色对应的 2-3 套系统
- **角色分工是一种天然的关注点分离，把身份碎片化的复杂度屏蔽在各自的工作边界内**

**Agent 时代的身份问题：**
- Agent 打破了角色边界 — 一个 delivery agent 要 git clone（SSH）、研发 CLI 提 MR（统一鉴权）、操作中间件配置（中间件身份）、查监控（监控平台身份）
- 身份体系数量从"每人 2-3 套"膨胀到"每 agent 5-8 套"
- 频率翻倍：人一天切换几次，Agent 一分钟内可能连续调用多个系统
- **两个乘法因子：角色融合 × 工作频率 = 身份管理复杂度爆炸**

**核心安全矛盾：**
- Agent 需要凭证来访问外部服务
- Agent 不能被信任持有凭证 — prompt injection 可能导致凭证泄露
- 传统的"给人一个 token"模式在 Agent 场景下不安全

### 工作原理

```
Agent                    Broker                    外部服务
  |                        |                          |
  |-- 请求 + 占位符 ------->|                          |
  |                        |-- 验证 Agent 身份 ------->|
  |                        |-- 替换为真实凭证 -------->|
  |                        |<-- 响应 ------------------|
  |<-- 响应 ----------------|                          |
```

**关键要素：**
1. Agent 携带占位符（如 `__github_token__`）而非真实凭证
2. Broker 认证 Agent 身份（基于 Agent 实例、角色、任务范围）
3. Broker 将占位符替换为真实凭证转发请求
4. Agent 全程未见到真实凭证

### 行业趋同实现

| 公司 | 实现层 | 名称 |
|------|--------|------|
| Anthropic | Managed Agent Infrastructure | — |
| Vercel | Sandbox 凭证注入 | — |
| Cloudflare | Outbound Workers | — |
| LangChain | Sandbox Auth Proxy | — |

多家公司独立趋同到同一范式，说明这是 Agent 安全模型的必然走向。

### 身份演进路径

```
短会话 Token（2-8 小时过期）
    ↓ 凌晨 3 点 token 过期，agent 卡死
长效 Private Token（一次生成、长期有效）
    ↓ Agent 仍持有明文凭证
Credential Brokering（Agent 完全不接触凭证）
```

### 应用 / 使用场景

- Agent 平台的统一凭证管理
- 多角色 Agent 系统的身份隔离
- 企业内部 Agent 的安全审计
- SaaS Agent 的多租户凭证管理

### 局限与争议

- Broker 本身成为单点故障和安全高价值目标
- 每种外部服务需要适配 Broker 的凭证替换逻辑
- 占位符的命名约定需要全局统一
- Broker 的延迟开销在高频调用场景中可能显著

## 与其他实体的关系

- [[Agent-Oriented-Infra]] —— Credential Brokering 是"可操作"层中"凭证不进 sandbox"的终极方案
- [[Harness-Engineering]] —— Harness 初始化时注入角色对应的凭证，与身份联动

## 参考来源

- [[重新思考研发基础设施-当Agent成为第一公民]] —— Credential Brokering 范式与行业趋同
