---
title: "Orchestrator-Worker模式"
type: entity
date: 2026-06-15
also_known_as:
  - "Orchestrator-Worker"
  - "协调器-工作者模式"
  - "编排器-Worker"
tags:
  - multi-agent
  - agent-architecture
  - orchestration
  - cost-optimization
sources:
  - "[[一篇搞懂-AI-Coding-Agent的Token成本控制]]"
related_entities:
  - "[[Token成本控制]]"
  - "[[Loop-Engineering]]"
  - "[[Stripe-Minions]]"
  - "[[MCP]]"
---

# Orchestrator-Worker模式

## 一句话定义

Orchestrator-Worker（协调器-工作者）是一种多 Agent 协作模式：一个 Orchestrator 只负责规划、拆解、调度、汇总（不亲自读大量文件、不亲自跑命令），多个 Worker 按需派遣、每个只做一件事、只看自己需要的上下文，做完把结果交回——本质是让每个 Agent 只看与当前步骤相关的内容，而不是把整个任务的所有背景塞进每一次调用。

## 摘要

它是 [[Token成本控制]] 第五层（Agent 架构）的核心范式。单 Agent 处理复杂任务时，必须同时承载规划、代码阅读、工具调用、生成、验证的所有上下文——哪怕它当前只是"改一个函数"。把臃肿的长任务变成有分工的流水线后，每轮成本可压缩 5-10 倍。在 [[CodeBuddy]] 里这个模式可直接用内置的 Agent tool + worktree 隔离 + Skill 绑模型实现，不需要自己写 Orchestrator。

## 详情

### 核心机制 / 工作原理

```
Orchestrator（协调器，强模型）
  ├── 负责规划、拆解、调度、汇总
  ├── 不亲自读大量文件、不亲自跑命令
  └── 只负责决策

Worker（子 Agent，按需派遣，便宜模型）
  ├── 每个 Worker 只做一件事
  ├── 只看自己需要的上下文，完成即销毁
  └── 做完把结果写入共享文件
```

成本对比（"修复 API Bug + 补测试 + 写变更说明"）：单 Agent 全程跑可能 215K tokens × N 轮；拆成 Orchestrator(~10K) + 各 Worker(~10-14K) 后，端到端从约 800K-1.2M 降到约 100K-150K（省 70-85%）。

### 关键设计原则：上下文隔离后如何流转数据

会话历史是每个 Agent 私有的、互不相通，但**文件系统是共享的**——上下文隔离与信息共享可同时成立：Agent 间通过共享外置文件（如 `.agent/findings.json`）传递数据，不通过会话历史。四条原则：

1. **输出格式结构化**：用 JSON 而非自然语言，下游只读它关心的字段（含 `file/line/issue/severity/next_step/context_needed`）。
2. **用进度文件追踪状态**：`.agent/progress.json` 记录每个 step 的 `status/worker/output_file/depends_on`，Orchestrator 每次唤醒只读这一个文件即可知进展，无需回放历史会话。
3. **每个 Worker 的 context 包精心裁剪**：Orchestrator 明确告诉它"只读哪些东西"，指令本身很短（~150 tokens）却让上下文精准到最小必要集合。
4. **临时文件及时清理**：`.agent/` 是临时工作区，任务完成后归档或 `rm -rf`，不污染仓库、不把旧任务上下文带入新任务。

### 并行执行

独立子任务可同时启动。实际加速：2 个 Worker ~1.5-1.8×，3 个 ~2.2-2.6×，4 个 ~2.8-3.4×（低于理论 N 倍，因 Orchestrator 有启动/汇总开销 + Worker 间轻微 I/O 竞争）。适合并行：不同模块 Bug 修复、代码+测试+文档、无依赖的多文件重构；不适合：有顺序依赖、改同一文件、依赖上一步输出的任务。

### 应用 / 使用场景

- 中大型仓库的复杂任务（如 API 层统一错误处理重构 + 补测 + 报告）端到端编排
- 降本与提速并举：便宜模型干执行、强模型做规划，并行压缩时间成本
- 与 [[Loop-Engineering]] 的"自动调度"结合：[[Stripe-Minions]] 即用确定性 orchestrator 在 LLM 之前备齐上下文

### 局限与争议

- 拆分的前提是子任务**真的能拆开**；如果每个 Agent 都要重复读同一批背景，拆得越多反而越贵。
- 自然语言在 Agent 间传递易产生歧义，必须结构化输出 + 共享文件契约。

## 与其他实体的关系

- [[Token成本控制]] —— 本模式是其第五层 Agent 架构优化的核心手段
- [[Loop-Engineering]] —— 循环工程的"孵化小帮手/子 agent"在架构上常落为 Orchestrator-Worker
- [[Stripe-Minions]] —— 用确定性 orchestrator 编排上千 agent 的企业级实例
- [[MCP]] —— Worker 通过 MCP/工具访问外部系统，结果回写共享文件

## 参考来源

- [[一篇搞懂-AI-Coding-Agent的Token成本控制]] —— 腾讯技术工程 devinyzeng，§6 多 Agent 协作
