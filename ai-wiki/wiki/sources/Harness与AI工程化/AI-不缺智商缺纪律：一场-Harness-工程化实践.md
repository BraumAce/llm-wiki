---
title: "AI 不缺智商缺纪律：一场 Harness 工程化实践"
type: source
date: 2026-06-12
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/HoStCq53XElBlbLU6uPTJA"
author: "阿里技术"
ingested_at: 2026-06-12
tags: [Harness-Engineering, AI-Coding, Claude-Code, 多Agent]
related_entities: [Harness-Engineering, Claude-Code, OpenClaw, OpenSpec]
related_topics: [Harness-Engineering-主题, Skill开发最佳实践]
---

# AI 不缺智商缺纪律：一场 Harness 工程化实践

## 一句话概括

AI Coding 的瓶颈从模型能力转移到流程工程，通过 harness 分层结构、评测驱动迭代、职责隔离的多 Agent 架构，解决 AI 不守纪律、上下文溢出、流程不可控等问题。

## 实践内容

### Harness 分层结构

```
五层 harness 架构：
1. 常驻入口层：CLAUDE.md + CLAUDE.local.md
   - 全局规则、项目规范、角色定义
2. 触发规则层：rules/*.md
   - 按条件激活的规则文件
3. 状态外置层：state.json / phases/*.md / evidence.json
   - 流程状态持久化，不依赖上下文
4. 调度层：dispatcher + orchestrator
   - 主会话只听 dispatcher 指令
   - dispatcher 读 state.json 返回"下一步调谁"
5. 执行支撑层：skills/（22个）+ commands/（12个）+ evals/
   - 封装可复用的原子操作
```

### 多 Agent 职责隔离

```
核心约束：
1. 主会话只听 dispatcher：dispatcher 读 state.json 返回"下一步调谁"，主会话照做
2. 职责隔离：dispatcher 只管路由、orchestrator 只管合成、developer 只管编码、verifier 只管检查
3. 每个 agent 的可用工具严格受限
4. 上下文 ≤8K：主会话只加载 CLAUDE.md + 触发规则 + 最近一条 dispatcher 指令
```

### 踩坑教训

```
4 条核心教训：
1. prompt 约束是说服，不是强制——模型"理解"了规则不等于"遵守"了规则
2. 对付 AI 的不确定性，堆 prompt 是负债，做框架才是资产
3. 过度拆分 Agent 代价大——24 agent 精简到核心约束架构
4. 评测必须驱动迭代——3 次跑分完全一致才能判断变好还是变坏
```

### 评测平台设计

```
核心理念：评测平台是评估者，不是执行者
- 把 harness 本身当成被测软件
- 用 A/B 对比验证规范变更效果
- LLM 评委波动 ±5 分时，需要多次跑分取稳定值
- 评测的唯一目的是驱动迭代
```

## 摘录

> 本文核心观点：AI Coding 的瓶颈正从「模型能力」转移到「流程工程」——模型已经足够聪明，但不稳定，而稳定性必须由外部框架供给。读完你能带走：一套可抄的 harness 分层结构、一个「把流程当被测对象」的评测方法、4 条用代价换来的踩坑教训，以及一个能迁移到任何 AI 工作流的工程化模式。

> 对付 AI 的不确定性，堆 prompt 是负债，做框架才是资产。prompt 约束是说服，不是强制。模型"理解"了规则不等于"遵守"了规则——你无法用更多的字来对抗概率性的遗忘。

## 涉及实体

- [[Harness-Engineering]] —— 本文核心，把 AI 该怎么干活固化成可执行框架
- [[Claude-Code]] —— 逆向工程分析其记忆和上下文管理机制
- OpenSpec —— 社区规范，提供 CLAUDE.md 模板和最佳实践
- [[OpenClaw]] —— Agent 框架，支持 skill 和多 agent 架构

## 涉及主题

- [[Harness-Engineering-主题]]
- [[Skill开发最佳实践]]
