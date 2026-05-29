---
title: "Spec-Driven Development"
type: entity
date: 2026-05-29
also_known_as:
  - "SDD"
  - "规格驱动开发"
  - "规范驱动开发"
tags:
  - methodology
  - ai-engineering
  - software-engineering
  - spec-driven
sources:
  - "[[ByteLighting-2026年5月技术阅读合集]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[OpenClaw]]"
---

# Spec-Driven Development

## 一句话定义

Spec-Driven Development（SDD）是一种 AI 编程方法论——在写任何代码之前，先用结构化文档固化需求边界、接口契约和成功指标，让 AI 按规格实现而非凭直觉创造。

## 摘要

SDD 的核心论点是：**SDD 不让 AI 变聪明，而让 AI 变可控**。在 AI Coding 时代，模型的代码生成能力已经不是瓶颈，真正的瓶颈是"AI 不知道你要什么"。传统开发中，需求隐含在 PM 的脑子里、散落在聊天记录里、模糊在 PRD 的歧义里——AI 无法可靠地从这些噪声中提取正确意图。

SDD 通过四阶段流程（Specify → Plan → Implement → Validate）强制把需求显式化。阿里 Qoder 团队用这套方法论实现了 5 人 7 天交付一个完整产品的壮举——"DAY 0 不写一行代码，先固化需求边界与成功指标"。得物团队进一步将 SDD 与 Harness 结合，用双文档对齐前后端接口契约，多 Agent 并行开发，三阶段分离验证，实测提效 50%+。

## 详情

### 起源与背景

SDD 的思想来源于传统软件工程中的"规格先行"理念（如 TDD、BDD、Design by Contract），但在 AI 编程时代获得了新的意义。当 AI 可以在几秒内生成大量代码时，方向错误的代价远大于手写时代——因为 AI 生成代码的速度远快于人类审查的速度。

2026 年初，阿里 Qoder 团队在实践中发现：不加约束的 AI 编程会导致"氛围编程"（Vibe Coding）——出码率很高但质量不可控。SDD 就是为了解决这个问题而生的。

### 核心机制 / 工作原理

SDD 的四阶段流程：

1. **Specify（规格化）**：DAY 0 不写代码。固化需求边界、用户故事、验收标准、技术约束。产出是 Spec 文档 + constitution.md（项目宪法）
2. **Plan（规划）**：基于 Spec 拆解任务、设计架构、定义接口契约。产出是技术方案 + 任务分解
3. **Implement（实现）**：AI 按 Spec 和 Plan 生成代码。关键约束：AI 只能按规格实现，不能"发挥创意"
4. **Validate（验证）**：对照 Spec 中的验收标准自动验证。不是"代码能跑"而是"满足规格"

Spec Kit 三件套：
- **Spec 文档**：需求边界、用户故事、非功能需求
- **constitution.md**：项目级硬约束（不可违反的技术决策）
- **接口契约**：前后端/服务间的 API 定义，通常用 OpenAPI / Protobuf

```
SDD 工作流
DAY 0:  Spec 文档 + constitution.md（不写代码）
  ↓
DAY 1:  Plan — 架构设计 + 任务拆解
  ↓
DAY 2-5: Implement — AI 按 Spec 生成代码
  ↓
DAY 6-7: Validate — 对照验收标准测试
```

### 应用 / 使用场景

- **快速产品交付**：阿里 Qoder 5 人 7 天交付 QoderWork
- **多团队协作**：得物用 SDD 双文档对齐前后端接口契约，避免集成时的"接口对不上"
- **存量改造**：高德团队用 SDD + Harness 四支柱解决存量代码的 AI 改造问题
- **消除氛围编程**：把"AI 凭感觉写代码"变成"AI 按规格写代码"

### 局限与争议

- **前置成本高**：写好 Spec 需要时间和经验，小项目可能不值得
- **Spec 质量决定上限**：垃圾 Spec 进、垃圾代码出，AI 只是放大器
- **灵活性受限**：快速原型阶段，过度规格化可能拖慢探索速度
- **维护负担**：Spec 需要随代码同步更新，否则会过期失效

## 与其他实体的关系

- [[Harness-Engineering]] —— SDD 是 Harness 在需求阶段的具体实践。Harness 提供整体框架，SDD 负责"入口"的规格化
- [[OpenClaw]] —— OpenClaw 的 Skills 定义本身就是一种 Spec：SKILL.md 定义了 Agent 能力的边界和约束

## 参考来源

- [[ByteLighting-2026年5月技术阅读合集]] —— 涵盖 SDD 实战、Harness + SDD 组合实践等多篇文章
