---
title: "ReAct"
type: entity
date: 2026-06-02
also_known_as: [Reasoning+Acting, ReAct范式]
tags: [Agent, 推理, 范式]
sources: [面向LLM的架构设计-什么是真正的AI-Friendly架构]
related_entities: [AI-Friendly架构, Multi-Agent, Agentic-Engineering]
related_topics: [Agent架构演进-主题]
---

# ReAct

## 一句话定义

ReAct（Reasoning + Acting）是Single-Agent的重要构建范式，通过"思考(Thought)→行动(Action)→观察(Observation)"的循环让Agent能够自主推理并逐步调用工具解决问题。

## 摘要

ReAct范式由Yao等人在2022年提出，核心思想是让大模型在执行任务时交替进行推理和行动。与传统的单一推理或单一行动不同，ReAct将二者结合，使Agent能够"自言自语"地规划，一步步调用工具、补充上下文来解决问题。在大淘宝技术的实践中，ReAct被用于秒杀AI答疑系统的域Agent构建，与Plan范式结合形成更强大的计划-推理能力。

## 详情

### 起源与背景

ReAct范式由Shunyu Yao等人在2022年的论文《ReAct: Synergizing Reasoning and Acting in Language Models》中提出。其核心观察是：纯推理方法（如Chain-of-Thought）缺乏与外部世界的交互能力，纯行动方法（如Act-only）缺乏高层次的规划能力。ReAct将二者融合，让模型在推理的同时可以行动，在行动的同时可以推理。

### 核心机制 / 工作原理

#### ReAct循环

```
Thought: 我需要查询商品X的报名状态
Action: 调用query_product_status(product_id="X")
Observation: 商品X状态为"审核中"，报名时间为2026-05-28
Thought: 商品已在审核中，我需要检查审核进度
Action: 调用check_audit_progress(product_id="X")
Observation: 审核进度60%，预计还需2小时
Thought: 我已经获取了完整信息，可以回答用户
Action: 返回答案
```

#### 单步思考的局限

ReAct每次都是基于当前信息推理下一步的最佳行动，这种单步思考的方式决定了它更擅长解决**理性类问题**（如排查一个商品为什么不能报名），对于**主观类问题**效果有限。因此实践中通常会结合Plan范式：

- **Plan**：产出全局计划，沉淀优秀计划模版
- **ReAct**：执行细分领域推理，在垂直领域表现出更好的效果

### 应用场景

- 多步骤工具调用的任务
- 需要中间推理过程的复杂查询
- 与Plan结合形成PlanAgent的推理引擎
- Multi-Agent中各域Agent的核心推理机制

### 局限与注意事项

- 单步推理可能陷入局部最优，缺乏全局视角
- 对主观类问题效果不佳，需结合Plan范式
- 推理链过长时可能出现错误累积
- Token消耗较大，需要控制推理轮次

### 与其他范式的对比

| 范式 | 核心思想 | 优势 | 劣势 |
|------|---------|------|------|
| ReAct | 推理+行动交替 | 可解释性强、可调用工具 | 单步视角、Token消耗大 |
| Plan | 全局规划后执行 | 全局最优、可复用计划 | 计划质量依赖模型能力 |
| CoT | 纯推理链 | 简单高效 | 无法与外部交互 |
| Reflexion | 反思+自我修正 | 可从错误中学习 | 额外推理开销 |

### 在大淘宝技术中的实践

在秒杀AI答疑场景中，ReAct被用于各业务域Agent的核心推理引擎：

- **商品域Agent**：基于ReAct推理商品报名失败原因
- **订单域Agent**：排查订单状态异常
- **库存域Agent**：分析库存扣减问题
- **报名域Agent**：处理报名流程中的复杂问题

每个域Agent基于ReAct+Plan范式实现，由中心Agent统一做意图识别与任务分发，形成MOE（混合专家）形态的Multi-Agent系统。
