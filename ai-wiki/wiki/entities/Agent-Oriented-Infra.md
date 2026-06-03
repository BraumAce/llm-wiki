---
title: "Agent-Oriented-Infra"
type: entity
date: 2026-06-03
also_known_as:
  - "面向 Agent 的基础设施"
  - "Agent-Oriented Infrastructure"
  - "Agent-First Infra"
tags:
  - infra
  - ai-engineering
  - architecture
  - design-principle
sources:
  - "[[重新思考研发基础设施-当Agent成为第一公民]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Credential-Brokering]]"
  - "[[Agent-DX]]"
  - "[[Agentic-Engineering]]"
  - "[[AI-Friendly架构]]"
---

# Agent-Oriented Infra

## 一句话定义

Agent-Oriented Infra 是面向 Agent 设计的基础设施范式，核心理念是"Agent 的自主程度是 infra 安全能力的函数"，通过四层设计原则（可理解、可操作、可感知、可追溯）将安全模型从"依赖人的自我约束"重建为"依赖 infra 的机制保证"。

## 摘要

Agent-Oriented Infra 的提出源于一个根本性观察：现有基础设施都是为人设计的，设计假设包括操作者有常识、有责任心、操作频率低、能从隐性知识中填补概念裂缝——Agent 不符合这些假设中的任何一条。因此需要从 People-Oriented 重建为 Agent-Oriented。核心范式转变是：给 infra 补能力，而非给 agent 加限制。Infra 的能力边界，就是 agent 的自主边界。

## 详情

### 为什么需要 Agent-Oriented Infra

**传统 infra 的设计假设（People-Oriented）：**
- 操作者有常识（不会手贱推别人业务的配置）
- 操作者有责任心（出错后能人工修复）
- 操作频率低（一天切换几次身份不是问题）
- 能从口口相传的隐性知识中填补系统概念的裂缝

**Agent 不符合这些假设：**
- 无常识（会 hallucinate）
- 操作频率极高
- 出错后需要自动恢复
- 面对概念裂缝会卡住或猜错还不自知

### 四层设计原则

**第一层：可理解（Comprehensible）**

Agent 能建立正确的心智模型。这是所有后续层的前提。

- 系统的概念体系必须自洽、完整、不依赖口口相传的隐性知识
- **复杂度不是问题，不一致才是** — 一个概念自包含的 CLI，即使有 200 个子命令，agent 也能通过多轮试探快速学会
- 运行环境自描述 — 用 manifest / devcontainer 声明依赖、输入、输出、允许工具

**第二层：可操作（Operable）**

Agent 能安全可靠地行动。

- **可试探**：dry-run / preview、幂等重试
- **操作原子可组合**：输入输出类型化（MR id 和 iid 混用是反例）
- **隔离执行**：每个任务一个 sandbox，试错代价可控
- **凭证不进 sandbox**：通过 vault / egress proxy 注入能力，agent 不持有明文凭证
- **渐进信任**：低风险 agent 自主执行，高风险 agent 准备好变更计划和 dry-run 结果、人来审批
- **回滚能力**：把不可逆操作变成可逆操作，等于降低风险等级

**第三层：可感知（Observable）**

Infra 把状态和结果清晰地交回 agent。

- **沉默和含糊是 agent 的敌人** — Unix 的 "Silence is golden" 对 agent 有害
- 状态必须 API 可查、结构化、实时
- 每次响应 — 成功或失败 — 都要提供足够的语义信息让 agent 决定下一步
- 结果要可判定 — 把 agent 的产出转成 CI 能识别的 pass/fail

**第四层：可追溯（Traceable）**

过程不丢失、可恢复、可回放。

- **状态可恢复**：snapshot / checkpoint，避免长任务因容器故障从零开始
- **过程可回放**：至少保存 artifact，更进一步保存 execution trace
- **Agent 的失败模式是 infra 设计缺陷的放大器**：
  - 反复重试某个 API → 反馈语义不足
  - 调用顺序混乱 → 前置条件没有显式化
  - 频繁格式转换 → 接口不可组合
  - 用错身份 → 身份体系碎片化

### 递进关系

```
可理解 → 可操作 → 可感知 → 可追溯
（建立心智模型）→（安全行动）→（感知反馈）→（全程可追溯）
```

每一层同时覆盖 API 接口设计和运行时环境两个维度。

### 行业趋同

多家公司独立得出了高度一致的结论：
- **Superset（Vercel）**：并行 agent 需要并行 infra，3 人团队每天 600 个 preview deployment
- **Google Workspace CLI**：从第一天按 agent-first 设计，Human DX 优化可发现性，Agent DX 优化可预测性
- **Credential Brokering**：Anthropic、Vercel、Cloudflare、LangChain 各自在不同层实现了同一范式

### 应用 / 使用场景

- 研发基础设施的 Agent 化改造
- 企业内部 CLI/SDK 的 Agent-Friendly 重构
- Agent 平台的架构设计

### 局限与争议

- 改造存量系统的成本高
- 四层原则的实施优先级因场景而异
- "渐进信任"机制的落地需要组织层面的配合

## 与其他实体的关系

- [[Harness-Engineering]] —— Harness 是 Agent-Oriented Infra 的运行时环境层
- [[Credential-Brokering]] —— 是"可操作"层中"凭证不进 sandbox"的终极方案
- [[Agent-DX]] —— Agent DX 是 Agent-Oriented Infra 在开发者体验维度的体现
- [[Agentic-Engineering]] —— Agentic Engineering 是上层方法论，Agent-Oriented Infra 是底层支撑
- [[AI-Friendly架构]] —— AI-Friendly 架构是 Agent-Oriented Infra 在接口设计维度的子集

## 参考来源

- [[重新思考研发基础设施-当Agent成为第一公民]] —— 四层设计原则与行业趋势
