---
title: "Agent核心技术概念与范式发生了哪些演变以及背后的思考"
type: source
date: 2026-06-01
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/ONYZFjxpIDgoRBSblLtGZg"
author: "飞樰 · 阿里技术"
ingested_at: 2026-06-02
tags: [Agent, 范式演进, Prompt, Memory, Tools, Workflow]
related_entities: [Agent范式演进, 自进化Agent, Prompt渐进式加载, Agent-Memory, Harness-Engineering]
related_topics: [Agent架构演进-主题]
---

# Agent核心技术概念与范式发生了哪些演变以及背后的思考

## 一句话概括

阿里技术飞樰系统梳理了 Agent 从2023到2026年的四个发展阶段（被动式ReAct→工作流Agent→自主Agent→自进化Agent），并深入分析了 Prompt、Planning、Memory、Tools、Workflow、Environment 六个核心技术概念的前后演变逻辑。

## 实践内容

### Agent 四阶段演进

```
阶段一：早期 Agent（2023，被动式 ReAct）
- 基于 ReAct 架构：Reasoning → Observe → Response
- 类似增强版 Chatbot，一问一答
- 依赖 CoT + 简单 Function Call
- 缺乏长期规划，超过3轮推理就容易偏离

阶段二：工作流 Agent（2024，结构化与可控性）
- 引入 Agentic Workflow，用工程约束弥补模型不确定性
- 固定 Workflow + 关键节点嵌入 LLM
- to B 场景性价比最高、落地最稳定
- 本质是早期的 Harness（约束工程）

阶段三：自主 Agent（2025，复杂规划与长程任务）
- Manus、Claude Code、Codex 等出现
- 具备复杂 Planning 能力，可拆解任务、多轮迭代
- 配合 Harness/自我校验机制，连续运行完成企业级任务
- 从"辅助者"向"执行者"角色转变

阶段四：自进化 Agent（2026，持续学习与自我升级）
- Hermes Agent、LLM-Wiki 等框架兴起
- Agent 自我沉淀 Skill、知识库，甚至 RL 训练
- 解决"静态模型"与"动态世界"的矛盾
- 从"一次性消耗品"变成"可积累资产"
```

### 六大技术概念演变

```
1. Prompt：深耦合 → 渐进式加载
   早期：一个任务一个 Agent，一段精心调试的 System Prompt
   现在：System Prompt 固化 + 动态内容通过 SKILL.md/USER.md 等渐进式加载
   核心：动静分离，降低维护成本

2. Planning：思维链 → 复杂长程任务
   早期：CoT 线性推理，"Let's think step by step"
   现在：结构化分解 + 多步协同 + 子 Agent 动态构建
   驱动力：底层基座模型推理能力升级

3. Memory：检索增强 → 文件系统化
   短期记忆：从简单堆砌 → 阈值控制 + 结构化摘要 + 重点提取
   长期记忆：从纯 RAG → 文件系统（MEMORY.md）+ 轻量向量检索混合
   趋势：事项型记忆用文件系统，知识型记忆用向量+文件混合

4. Tools：Function Call → CLI/Script
   早期：封装标准 API 注册为 Function Call，维护成本极高
   现在：CLI 命令行原生化（模型预训练已包含）+ Script 脚本化
   核心：利用模型原生能力，不再为每个操作写专用 API

5. Workflow：刚性编排 → 动态混合封装
   早期：硬编码状态机/流水线，强制按步骤执行
   现在：逻辑写入 SKILL.md + 执行脚本化
   最佳实践：Skill 为主，Workflow 为辅/兜底

6. Environment：无状态 → 运行时环境
   本地个人电脑：便利但缺乏隔离
   沙箱环境：Docker/K8s 容器化，安全边界
   核心：Agent 需要专属 Workspace 来持久化存储、读写文件
```

## 摘录

> Agent 相关的技术发展并非一蹴而就，很多技术概念前后之间也是有一定的相关、继承关系的。即使发生了演变前后的技术，也并非简单的替代关系，甚至还可以相互结合使用。因此，在 Agent 的技术理念已经发生较大的变化的时候，我觉得非常有必要对 Agent 演化前后的范式进行一次更深入对比。

> 这四个阶段并非完全的替代关系，而是并存且互补的。在实际落地中，我们需要根据业务的复杂度、对稳定性的要求以及成本预算，选择合适的 Agent 范式，或者将多种范式组合使用。

> 从早期的 Function Call 到如今的 CLI + Script 模式，Tools 的演进核心是从"人为适配模型"转向"利用模型原生能力"。我们不再试图为每一个操作编写专用的 API 接口，而是充分利用模型在预训练阶段积累的通用计算机操作知识（CLI）和代码执行能力（Script），构建更加轻量、灵活且易于扩展的工具生态。

> Memory 的演进本质上是开始从纯向量文本检索走向"文件系统化的沉淀+向量检索混合管理"。无论是短期的对话压缩，还是长期的事项记录与知识沉淀，都在追求更高的记忆效果、可读性和效率的均衡。
