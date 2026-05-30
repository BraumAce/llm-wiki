---
title: "Agentic Engineering 主题"
type: topic
date: 2026-05-30
tags:
  - agentic-engineering
  - vibe-coding
  - software-engineering
  - agent-architecture
  - context-engineering
  - harness-engineering
  - sdlc
related_entities:
  - "[[Agentic-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[Claude-Code]]"
  - "[[OpenClaw]]"
  - "[[Hermes-Agent]]"
sources:
  - "[[从第一性原理思考Agentic-Engineering]]"
  - "[[从Vibe-Coding到Agentic-Engineering-重构后台开发全流程]]"
  - "[[Agent核心技术概念与范式发生了哪些演变]]"
  - "[[从0开发大模型的17种Agent架构演进详细拆解]]"
  - "[[Anthropic-Effective-Context-Engineering-for-AI-Agents]]"
  - "[[Anthropic-Effective-harnesses-for-long-running-agents]]"
  - "[[从零设计生产级Multi-Agent-Harness]]"
  - "[[从语言涌现到协作涌现-如何让AI产生高质量决策]]"
---

# Agentic Engineering 主题

## 主题定义

Agentic Engineering 涵盖从"Vibe Coding"（借助 AI 快速生成代码片段）到"Agentic Engineering"（由 AI Agent 端到端驱动开发流程）的范式转移。这一主题关注工程师角色的根本重构——从"直接编写全部代码"转变为"设计让 Agent 可靠运行的工程框架"，包括上下文质量、控制流拓扑、验证机制和记忆系统四个核心维度。

## 核心要点

1. **从 Vibe Coding 到 Agentic Engineering 的三阶段演进**：Vibe Coding（2024）是"借助 AI 大模型快速生成代码片段"，工程师仍主导编码过程，AI 只是辅助工具；Agentic Workflow（2025）是"用工程化约束弥补模型不确定性"，通过 Workflow 编排、状态机和预定义流程将 Agent 行为纳入可控框架；Agentic Engineering（2026）是"由 AI Agent 端到端驱动开发流程"，工程师的核心价值从写代码转变为设计让 Agent 可靠运行的工程框架。这三个阶段不是替代关系，而是层层递进的超集

2. **三条公理推导出系统性方法论**：davidYichengWei 从第一性原理出发提出三条公理——SDLC 信息损耗（从人类意图到可执行程序的每一步转化都存在信息损耗）、LLM 本质特征（输出由上下文决定、概率性输出、有限工作记忆）、人类认知稀缺（工程师的注意力和判断力应集中在高价值决策上）。基于这三条公理推导出：上下文的质量和结构化程度直接决定 AI 输出上限，验证能力而非生成能力才是核心瓶颈

3. **三层价值模型定义工程师新角色**：L1 加速（Accelerate）——同样的事做得更快，如写脚本、生成样板代码；L2 增强（Augment）——同样的事做得更好，如提升代码质量、更全面的测试覆盖；L3 解锁（Unlock）——做以前做不到的事，如系统性知识沉淀与复用、跨模块架构分析。工程师应将精力集中在 L3 层的高价值决策上

4. **六个维度的工程演进**：Prompt 从单体到解耦（System Prompt 只保留最底层通用指令，动态内容通过 CLAUDE.md 渐进式加载）、Planning 从思维链到长程任务拆解（生成结构化 Todo List 并动态调整）、Memory 从向量检索到文件系统化（混合架构）、Tools 从 Function Call 到 CLI/Script（充分利用模型预训练的 CLI 知识）、Workflow 从刚性编排到动态混合（成熟子任务封装为 Skills）、Environment 从无状态到运行时（Agent 需要专属 Workspace）

5. **Agent Room 协作涌现超越单 Agent 能力上限**：阿里团队构建的 Agent Room 将产品、架构、开发、QA、运维等多个角色 Agent 放入同一上下文场，通过共享上下文、任务账本、DAG 系统和 Memory 系统实现协作涌现——整体判断质量高于任何单个 Agent 的局部判断。这代表了从"上下文编排 vs 任务编排"的范式选择

6. **生成能力与验证能力的张力是核心矛盾**：2025 至 2026 年间，AI 生成代码的速度远快于人类审查的速度，验证代码正确性的成本并未同步降低。这一矛盾是 Agentic Engineering 诞生的根本驱动力——Harness Engineering 提供了验证闭环（lint / 自动测试 / 数据比对 / 四道门禁），Spec-Driven Development 提供了需求阶段的结构化规格约束

7. **Agent 架构的本质是控制流设计而非 prompt engineering**：从单次生成到反思闭环，再到工具交互、观察-行动循环、显式规划、验证驱动重规划、多 Agent 编排、长期记忆系统，直至搜索与涌现计算——每一次架构升级都在回答同一组问题：什么时候该停？什么时候该继续？什么时候该重试？什么时候该换角色？

## 涉及实体

- [[Agentic-Engineering]] —— 核心概念实体，定义了"人与 AI Agent 协作"的范式框架
- [[Harness-Engineering]] —— Agentic Engineering 在工程落地层面的核心方法论
- [[Spec-Driven-Development]] —— SDD 是 Agentic Engineering 在需求阶段的具体实践
- [[Claude-Code]] —— Agentic Engineering 理念的标杆工程实现
- [[OpenClaw]] —— Agentic Engineering 理念的开源实践载体
- [[Hermes-Agent]] —— 代表了 Agentic Engineering 的自进化方向

## 对比矩阵

| 维度 | Vibe Coding | Agentic Workflow | Agentic Engineering |
|------|---|---|---|
| 时间 | 2024 | 2025 | 2026 |
| AI 角色 | 辅助工具 | 执行引擎 | 自主 Agent |
| 工程师角色 | 主导编码 | 设计流程 | 设计框架 |
| 控制方式 | 人工审查 | Workflow 编排 | Harness + 验证闭环 |
| 适用场景 | 代码片段生成 | 流程自动化 | 端到端开发 |

## 关键来源

- [[从第一性原理思考Agentic-Engineering]] —— 三条公理推导、三层价值模型、意图转化链、SDLC 信息损耗分析
- [[从Vibe-Coding到Agentic-Engineering-重构后台开发全流程]] —— 从 Vibe Coding 到 Agentic Engineering 的演进路径和后台开发全流程重构
- [[Agent核心技术概念与范式发生了哪些演变]] —— Agent 发展四阶段（被动式 ReAct → 工作流 Agent → 自主 Agent → 自进化 Agent）
- [[从0开发大模型的17种Agent架构演进详细拆解]] —— 17 种 Agent 架构的控制流设计分析
- [[从语言涌现到协作涌现-如何让AI产生高质量决策]] —— Agent Room 协作涌现模型
