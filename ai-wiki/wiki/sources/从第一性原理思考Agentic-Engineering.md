---
title: "从第一性原理思考 Agentic Engineering"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/77OguM-HsX8V9WvNLWvlSw"
author: "davidYichengWei"
ingested_at: 2026-05-30
tags:
  - agentic-engineering
  - first-principles
  - software-engineering
  - llm
  - context-engineering
  - vibe-coding
  - sdlc
  - human-ai-collaboration
related_entities:
  - "[[Agentic-Engineering-Framework]]"
  - "[[LLM]]"
related_topics:
  - "[[Agentic-Engineering]]"
  - "[[Context-Engineering]]"
  - "[[Vibe-Coding]]"
---

# 从第一性原理思考 Agentic Engineering

## 一句话概括

从三条基本公理（SDLC 信息损耗、LLM 本质特征、人类认知稀缺）出发，用第一性原理推导出 Agentic Engineering 的系统性方法论——强调工程师保留决策权、上下文质量决定 AI 输出上限、验证能力而非生成能力才是核心瓶颈。

## 实践内容

### 开源框架

本文方法论已落地为开源项目：[agentic-engineering-framework](https://github.com/davidYichengWei/agentic-engineering-framework) — 基于 Skill 的模块化 Agentic Engineering 框架，包含完整的 SDLC Workflow、Best Practices、Self-Refinement 机制及项目定制指南。

### 三层价值模型

| 层次 | 名称 | 含义 | 典型场景 |
|------|------|------|----------|
| **L1** | **加速（Accelerate）** | 同样的事做得更快 | 写脚本、生成样板代码、格式转换、简单 CRUD |
| **L2** | **增强（Augment）** | 同样的事做得更好 | 提升代码质量、更全面的测试覆盖、更严谨的设计评审 |
| **L3** | **解锁（Unlock）** | 做以前做不到的事 | 系统性知识沉淀与复用、跨模块的架构级分析、新工程师快速达到团队水准 |

### 意图转化链

```
人类意图 → 自然语言需求 → 结构化设计 → 形式化代码 → 可执行程序
```

### SDLC 固有挑战与 AI 双面效应

| 维度 | 固有挑战 | AI 的改善 | AI 引入的新问题 |
|------|----------|-----------|----------------|
| 信息损耗 | 意图逐步失真 | 缩短反馈周期 | 概率性输出引入"似是而非"损耗 |
| 知识孤岛 | 隐性知识难以传承 | 通用知识即时可用 | 团队私有知识仍无法被 AI 利用 |
| 认知成本 | 理解复杂系统消耗大量认知 | 辅助代码解读 | 审查信息量暴增，释放与负担并存 |
| 重复性劳动 | 机械性工作占用大量时间 | 大幅自动化 | 生成成本骤降但验证成本未降 |

## 摘录

> **公理 2：LLM 的本质特征。** LLM 是一个基于上下文进行概率性推理的系统，具有三个并列的本质特征：（1）输出由上下文决定，（2）输出是概率性的，（3）工作记忆是有限且易失的。AI Agent 的核心引擎是 LLM——工具调用、工作流编排等都是围绕 LLM 构建的工程层。Agent 的能力上限和本质局限，最终都由 LLM 决定。因此，这条公理聚焦于 LLM 本身的特征。LLM 通过海量训练数据获得了广泛的通用知识，能够理解和遵循复杂指令，并进行跨领域的推理和知识迁移——这构成了它作为协作者的能力基础。

> **修正后的立场：上下文的价值取决于信噪比和知识结构化程度，而非代码的绝对量。** 最优策略不是"把代码喂给 AI"，而是提供高度相关、结构化的上下文——包括但不限于代码：设计文档、架构约束、编码规范、模块接口契约等。这是 Context Engineering 的核心命题。

> **生成能力的爆炸式增长与验证能力的相对停滞之间的张力，是 AI 时代软件工程的核心矛盾。** AI 的输出是概率性的——同样的输入可能产生不同的输出，生成的代码可能表面正确但语义偏差。这引入了一种新类型的损耗：不是人类的误解，而是 AI 的"似是而非"。验证代码正确性的成本并未同步降低——你仍然需要理解代码在做什么、判断它是否符合设计意图、审查边界条件。

## 涉及实体

- [[Agentic-Engineering-Framework]] —— 本文方法论的开源落地实现，基于 Skill 的模块化框架
- [[LLM]] —— 作为 Agentic Engineering 核心引擎的大型语言模型，其三个本质特征（上下文决定性、概率性、工作记忆有限性与易失性）构成公理 2

## 涉及主题

- [[Agentic-Engineering]] —— 本文的核心主题，从第一性原理推导的工程师与 AI Agent 深度协作范式
- [[Context-Engineering]] —— 上下文的质量和结构化程度决定 AI 输出上限，是 Agentic Engineering 的关键命题
- [[Vibe-Coding]] —— 本文对照的反面范式，"用速度换取理解和控制"的原型验证模式
