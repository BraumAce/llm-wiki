---
title: "几万字都讲不明白的Memory架构与思考"
type: source
date: 2026-05-30
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/bl77_Mb85C4AKe8h4__V6Q"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags:
  - memory
  - architecture
  - ai-agent
  - context-management
related_entities:
  - "[[Agent-Memory]]"
related_topics: []
---

# 几万字都讲不明白的Memory架构与思考

## 一句话概括

一篇试图用数万字系统梳理 AI Agent 记忆架构设计思路的深度长文，探讨 Memory 系统的核心挑战与架构思考——但因标题自嘲"几万字都讲不明白"，暗示记忆系统的复杂性远超单篇文章所能覆盖。

## 实践内容

### 核心架构：Raw Ledger + Views + Policy 三件套

作者提出 Memory 的最小闭包是 (Ledger, Views, Policy) 三件套：

1. **Raw Ledger（权威记录）**：追加式记录每次写入/更新/删除发生了什么（以及当时的输入、时间、scope 等）。类似"账本/黑匣子"。
2. **Derived Views（派生视图）**：面向检索/推理的派生状态（向量索引、keyword/hybrid、KG/TKG（时序知识图谱）、timeline、skill index 等）。views 可以多、可以 lossy，但必须可回指到 Raw Ledger。
3. **Policy（控制层）**：决定何时读、读多少、何时写、如何更新、如何遗忘；决策必须显式化为可记录/可回放的 Action 序列（ADD/UPDATE/DELETE/NONE…）。

### System 1 + System 2 分工

- **System 1（General Agent）**：LLM + tools + planner，负责通用推理、规划、工具调用
- **System 2（Agentic Memory / Slow Loop）**：独立的记忆系统，拥有主动控制回路
  - 流程：PreThink → Retrieve (loop) → Evidence Accumulate → Early Stop(conf >= tau)
  - Memory Infra：Raw Ledger + Derived Views (Vector/Hybrid, Keyword/BM25, KG/Timeline)
  - 保证：100% provenance (trace to Raw Ledger)
  - Sandbox：run N strategies in parallel

### 非参数化逼近参数化的三大瓶颈

1. **接口带宽**：Memory → System 1 的注入容量有限（token 预算、注意力容量、KV 长度）
2. **检索与聚合误差**：views 的近似误差（错检、漏检、时序冲突、语义漂移）
3. **Policy 的可学习性与可控性**：写多了污染、写少了学不到；召回多了噪声、召回少了信息不够

### 关键论文与方法

- **JitRL**：推理阶段利用外部经验库调制 logits 的形式化写法，维护动态非参数化经验库
- **UMEM**：通过余弦相似度构建语义邻域，利用 GRPO 针对邻域级别的边际效用进行奖励建模
- **AgeMem**：将记忆操作工具化，整合进 Agent 的动作空间，通过 RL 训练工具使用策略
  - LTM 构建阶段 → STM 控制阶段 → 综合推理阶段
- **InfMem**：PreThink-Retrieve-Write 协议，自适应早停机制将推理速度提升 3.9 倍
- **SimpleMem**：存储压缩后的"记忆单元"，递归固化（Recursive Consolidation）合并高亲和力记忆单元
- **Zep/Graphiti**：时序知识图谱（TKG），对边加入时间标注，区分"曾经为真"和"当前为真"

## 摘录

> Memory 不是"存储"，而是可被决策利用的外部状态（external state）。如果把 Agent 看成一个从输入到输出的函数，仅仅"存了很多历史"并不构成能力；能力来自：在当前状态下，历史能否以某种形式影响决策分布。记忆系统负责从历史中提取当前可用的信息（证据、摘要、子图、可执行技能等），并把它提供给推理层，共同产生决策。Memory 的价值不在于"存了多少历史"，而在于这条从历史到当前决策的通道是否有效。

> 非参数化 Memory 的真正"上限瓶颈"往往不是存储后端，而是 policy：写多了污染、写少了学不到；召回多了噪声、召回少了信息不够；UPDATE/DELETE 做错一次，长期就会滚雪球。所以 policy 必须既能学习（RL 训练范式），又能治理（protocol 的候选集合约束 + provenance 闭包 + sandbox 回放 A/B）。

> 把"学到的东西"抽象成一个对输出分布有影响的对象，它有两种经典承载方式：参数化记忆（经验被写进模型权重）和非参数化记忆（经验被写在外部状态里）。两者的差别不在"有没有存储"，而在适应算子写在哪里。参数化把"写入成本"前置在训练阶段；非参数化把"写入成本"分摊到在线（commit）与推理（retrieve + inject）阶段。

> 让 Agent 学会使用外部系统，要比直接把能力内化在 LLM 里更符合人类的认知规律和进化速度。毕竟，我们人类也是通过工具来大幅度地、迅速地扩展自己的能力的。记忆能力和 LLM 本身的其他 Agent 能力是「相对」正交的——在工程上可以把系统拆成两块"低耦合"的模块，分别优化时不会经常出现大规模的互相干扰与能力退化。

## 涉及实体

- [[Agent-Memory]] —— 本文是关于 Agent 记忆系统的架构思考，属于该实体的参考来源之一

## 涉及主题

（积累 ≥5 篇同议题来源后聚合）

## 我的评注（可选）

- 本文标题"几万字都讲不明白"本身就是一个有价值的洞察：Memory 系统是 AI Agent 工程中最复杂的问题之一，涉及短期/长期记忆、检索策略、遗忘机制、上下文压缩、隐私保护等多个维度，任何单一视角都无法穷尽
- 待获取原文后补充与 [[腾讯云Agent-Memory节省61-Percent-Token提升52-Percent成功率]]、[[从架构到代码-深入理解OpenClaw的双源记忆系统]] 等已有来源的对照分析
