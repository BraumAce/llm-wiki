---
title: "Agentic Engineering"
type: entity
date: 2026-05-30
also_known_as:
  - "Agent 工程"
  - "Agentic 软件工程"
  - "智能体工程"
tags:
  - agentic-engineering
  - ai-engineering
  - agent-architecture
  - software-engineering
  - context-engineering
  - multi-agent
  - sdlc
sources:
  - "[[从第一性原理思考Agentic-Engineering]]"
  - "[[从Vibe-Coding到Agentic-Engineering-重构后台开发全流程]]"
  - "[[Agent核心技术概念与范式发生了哪些演变]]"
  - "[[从0开发大模型的17种Agent架构演进详细拆解]]"
  - "[[Anthropic-Effective-Context-Engineering-for-AI-Agents]]"
  - "[[Anthropic-Effective-harnesses-for-long-running-agents]]"
  - "[[从零设计生产级Multi-Agent-Harness]]"
  - "[[从语言涌现到协作涌现-如何让AI产生高质量决策]]"
  - "[[Agent从一问一答到自主执行面临哪些挑战]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Context-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[OpenClaw]]"
  - "[[Hermes-Agent]]"
---

# Agentic Engineering

## 一句话定义

Agentic Engineering 是一种以 AI Agent 为核心执行单元的软件工程范式——工程师不再直接编写全部代码，而是通过设计上下文、控制流、验证回路和记忆系统，让 Agent 在工程约束下自主完成从意图到可执行程序的转化。

## 摘要

Agentic Engineering 的核心洞察来自三条公理：第一，软件开发生命周期（SDLC）中存在固有的信息损耗，从人类意图到自然语言需求、结构化设计、形式化代码、可执行程序，每一步转化都会丢失信息；第二，LLM 作为 Agent 的核心引擎，具有上下文决定性、概率性输出和有限工作记忆三个本质特征；第三，人类工程师的认知能力是稀缺资源，不应浪费在重复性劳动上。基于这三条公理，Agentic Engineering 提出：工程师的核心价值不是写代码，而是设计让 Agent 可靠运行的工程框架——包括上下文质量、控制流拓扑、验证机制和记忆系统。2025 至 2026 年间，从 Anthropic 的 Claude Code、阿里的 Qoder、腾讯的 Multi-Agent Harness 实践到开源社区的 OpenClaw、Hermes Agent，业界已形成广泛共识：**生成能力的爆炸式增长与验证能力的相对停滞之间的张力，是 AI 时代软件工程的核心矛盾**。Agentic Engineering 正是为解决这一矛盾而生的系统性方法论。

## 详情

### 起源与背景

Agentic Engineering 的思想萌芽可以追溯到 2023 年 LLM 爆发初期。当时 Lilian Weng 提出了经典 Agent 架构公式：LLM + Planning + Tools + Memory，定义了基于大模型的 Agent 基本框架。但早期 Agent 本质上是"被动式响应"，受限于 ReAct 架构的单步推理能力，只能完成短链路的小任务。

2024 年，随着企业级应用对稳定性的要求提升，Agentic Workflow 成为主流——用工程化约束弥补模型不确定性。这一阶段可以视为 Agentic Engineering 的雏形：通过 Workflow 编排、状态机和预定义流程，将 Agent 的行为纳入可控框架。

2025 年是关键转折点。Claude Code、Codex 等 AI Coding Agent 的出现标志着 Agent 从"辅助者"向"执行者"角色的根本转变。Agent 具备了复杂 Planning 能力，可以连续运行很长时间，自主处理企业级项目代码。2026 年初，OpenClaw、Hermes Agent 等框架进一步推动了自进化 Agent 的发展——Agent 不仅能完成任务，还能在过程中沉淀经验、自我优化。

在这一背景下，davidYichengWei 从第一性原理出发，系统性地提出了 Agentic Engineering 的理论框架。他指出：传统软件工程关注"人怎么写代码"，而 Agentic Engineering 关注"人怎么设计让 AI 写代码的系统"。这不是简单的工具升级，而是工程师角色的根本重构。

### 核心机制 / 工作原理

Agentic Engineering 建立在三条公理之上：

**公理一：SDLC 信息损耗。** 意图转化链为：人类意图 → 自然语言需求 → 结构化设计 → 形式化代码 → 可执行程序。每一步转化都存在信息损耗。AI 的引入缩短了反馈周期，但概率性输出同时引入了新型损耗——"似是而非"的错误。

**公理二：LLM 本质特征。** LLM 是基于上下文进行概率性推理的系统，具有三个并列特征：输出由上下文决定、输出是概率性的工作记忆有限且易失。这意味着上下文的质量和结构化程度直接决定 AI 输出上限。

**公理三：人类认知稀缺。** 工程师的注意力和判断力是有限资源，应集中在高价值决策上，而非重复性劳动。

基于这三条公理，Agentic Engineering 定义了三层价值模型：

| 层次 | 名称 | 含义 | 典型场景 |
|------|------|------|----------|
| L1 | 加速（Accelerate） | 同样的事做得更快 | 写脚本、生成样板代码、格式转换 |
| L2 | 增强（Augment） | 同样的事做得更好 | 提升代码质量、更全面的测试覆盖 |
| L3 | 解锁（Unlock） | 做以前做不到的事 | 系统性知识沉淀与复用、跨模块架构分析 |

在工程实践中，Agentic Engineering 的核心机制包括六个维度的演进：

1. **Prompt 从单体到解耦**：System Prompt 只保留最底层通用指令，动态内容通过 CLAUDE.md、SKILL.md 等文件渐进式加载，实现"动静分离"
2. **Planning 从思维链到长程任务拆解**：Agent 能主动将宏大目标拆解为可执行子任务，生成结构化 Todo List，并在执行过程中动态调整计划
3. **Memory 从向量检索到文件系统化**：短期记忆引入压缩策略（阈值控制、结构化摘要、重点提取），长期记忆从纯向量数据库走向文件系统 + 向量检索的混合架构
4. **Tools 从 Function Call 到 CLI/Script**：充分利用模型预训练阶段积累的 CLI 知识和代码执行能力，构建更轻量、灵活的工具生态
5. **Workflow 从刚性编排到动态混合**：成熟子任务封装为 Skills，关键主干流程保留 Workflow 或封装为 Tool
6. **Environment 从无状态到运行时**：Agent 需要专属 Workspace，包括本地桌面和沙箱环境两种形态

在控制流设计层面，Agent 架构的本质不是 prompt engineering，而是控制流设计。从单次生成到反思闭环，再到工具交互、观察-行动循环、显式规划、验证驱动重规划、多 Agent 编排、长期记忆系统，直至搜索与涌现计算——每一次架构升级都在回答同一组问题：什么时候该停？什么时候该继续？什么时候该重试？什么时候该换角色？

### 应用 / 使用场景

- **AI Coding Agent**：Claude Code、Codex 等产品将 Agentic Engineering 理念落地为具体工具，通过 CLAUDE.md 持久化状态、hooks 强制规范、Skills 封装领域知识，实现工程师与 Agent 的深度协作
- **Multi-Agent 协作系统**：阿里团队构建 Agent Room，将产品、架构、开发、QA、运维等多个角色 Agent 放入同一上下文场，通过共享上下文、任务账本、DAG 系统和 Memory 系统实现协作涌现——整体判断质量高于任何单个 Agent 的局部判断
- **长时任务执行**：Anthropic 的 Claude Agent SDK 通过 initializer agent + coding agent 两阶段架构，配合 JSON feature list、progress file 和 session startup protocol，解决了 Agent 跨 context window 执行长时间任务的挑战
- **生产级 Agent 平台**：腾讯团队提出 Multi-Agent Harness 作为 Agent 的"操作系统"，包含架构编排、工具治理、状态与记忆、评估体系、成本控制五大模块，将 Agent 从 Demo 推进到生产
- **定时调度与自进化**：阿里云 MSE AI 任务调度将定时调度从 Agent 内部抽离，由统一平台管理，支持弹性伸缩、任务批处理，并通过历史信息动态调整 prompt 实现自进化
- **存量代码改造**：通过 Harness + SDD 组合，在 10 万行以上的企业级应用中搭建 Agentic 工程框架，AI 代码率从 24% 提升至 90%+

### 局限与争议

- **验证瓶颈**：生成能力的爆炸式增长与验证能力的相对停滞之间的张力是核心矛盾。AI 生成代码的速度远快于人类审查的速度，验证代码正确性的成本并未同步降低
- **上下文窗口限制**：LLM 的工作记忆有限且易失，context rot 现象表明随着 token 数增长，模型准确召回信息的能力会下降。Compaction、JIT 检索等策略可以缓解但无法根本解决
- **控制流复杂度**：随着 Agent 架构从 ReAct 演进到 Multi-Agent、Blackboard、Ensemble 等模式，控制流复杂度急剧上升。过度工程化可能让系统变得难以理解和维护
- **成本问题**：Multi-Agent 系统中每个 Agent 都有 System Prompt 和上下文需求，工具结果被塞回模型，失败后还要重试，Token 消耗可能呈指数级增长
- **决策权归属**：Agent 负责局部智能、Harness 负责全局控制是生产级原则，但在实践中如何划分两者的边界仍需大量经验积累
- **从"会用工具"到"会形成判断"**：当前大多数 Agentic 系统仍停留在流程自动化层面，距离真正的"业务自迭代"——AI 围绕目标产出方案、拆解、执行、优化——还有显著差距

## 与其他实体的关系

- [[Harness-Engineering]] —— Harness Engineering 是 Agentic Engineering 在工程落地层面的核心方法论。Agentic Engineering 定义了"人与 AI Agent 协作"的范式框架，Harness Engineering 提供了具体的工程骨架（Rules、Skills、Wiki、Changes），两者在实践中高度融合
- [[Context-Engineering]] —— Context Engineering 是 Agentic Engineering 的关键子命题。上下文的质量和结构化程度决定 AI 输出上限，Compaction、JIT 检索、子 Agent 架构等策略是 Agentic Engineering 的核心技术手段
- [[Spec-Driven-Development]] —— SDD 是 Agentic Engineering 在需求阶段的具体实践。通过结构化文档固化需求边界、接口契约和成功指标，让 Agent 按规格实现而非凭直觉创造
- [[OpenClaw]] —— OpenClaw 是 Agentic Engineering 理念的开源实践载体，其 CLAUDE.md 持久化状态、hooks 强制规范、Skills 封装领域知识的设计哲学体现了 Agentic Engineering 的核心思想
- [[Hermes-Agent]] —— Hermes Agent 代表了 Agentic Engineering 的自进化方向，通过记忆模块、反馈循环和自我反思机制实现"越用越好用"

## 参考来源

- [[从第一性原理思考Agentic-Engineering]] —— 三条公理推导、三层价值模型、意图转化链、SDLC 信息损耗分析
- [[Agent核心技术概念与范式发生了哪些演变]] —— Agent 发展四阶段（被动式 ReAct → 工作流 Agent → 自主 Agent → 自进化 Agent）、六个核心概念演进
- [[从0开发大模型的17种Agent架构演进详细拆解]] —— 17 种 Agent 架构的控制流设计、状态拓扑、路由逻辑、失败模式分析
- [[Anthropic-Effective-Context-Engineering-for-AI-Agents]] —— 上下文工程四大策略：Compaction、结构化笔记、子 Agent 架构、JIT 检索
- [[Anthropic-Effective-harnesses-for-long-running-agents]] —— 长时任务 Harness 设计：initializer agent、feature list、progress file、session startup protocol
- [[从零设计生产级Multi-Agent-Harness]] —— 生产级 Multi-Agent Harness 五大模块：架构编排、工具治理、状态与记忆、评估体系、成本控制
- [[从语言涌现到协作涌现-如何让AI产生高质量决策]] —— Agent Room 协作涌现模型、上下文编排 vs 任务编排、Memory/DAG/产出物系统
- [[Agent从一问一答到自主执行面临哪些挑战]] —— Agent 定时调度痛点、高可用任务调度平台设计

<!-- 写作要点：
1. 字数 ≥ 1500（中文字符）
2. 不允许出现 "TODO" / "XXX" / "待补充" / "TBD"
3. 至少 1 个 [[related]]、≥ 1 个 sources，frontmatter sources 与正文一致
4. 多次 ingest 同一实体时合并扩展，不覆盖
-->
