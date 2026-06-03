---
title: "LOCOMO"
type: entity
date: 2026-06-03
also_known_as:
  - "Long-Term Conversational Memory"
  - "LOCOMO Benchmark"
tags:
  - benchmark
  - memory
  - evaluation
  - long-context
sources:
  - "[[Agent-Memory评测全景-基准评估与记忆系统]]"
related_entities:
  - "[[Agent-Memory]]"
  - "[[Mem0]]"
  - "[[MemoryAgentBench]]"
---

# LOCOMO

## 一句话定义

LOCOMO（Evaluating Very Long-Term Conversational Memory of LLM Agents）是一个评估 LLM Agent 长程对话记忆能力的基准数据集，由 UNC 提出，在 ACL 2024 发表，截至 2026 年 2 月已被引用 274 次。

## 摘要

LOCOMO 是 Agent Memory 评测领域引用量最高的基准之一。它基于个性化角色和时间事件图构建了 50 个长对话，每个对话平均 300 轮、9000 个 token，覆盖多个会话。评估三类任务：问答、事件总结和多模态对话生成。关键发现：GPT-4-turbo 在 QA 任务上仅得 32.4 分（人类基准 87.9），长上下文 LLM 能理解更长叙述但容易产生幻觉，RAG 在存储为观察内容时有效但收益递减。五类主要错误包括信息缺失、幻觉、对话线索误解、说话者归属错误和不重要对话被误判。

## 详情

### 数据集构建

**人物设定与时间事件图：**
- 获取初始人物设定，利用 LLM 扩展设定
- 每个 agent 构建的时间事件图包含多个事件，通过因果关系相互连接
- 事件之间有明确的时间顺序和因果依赖

**反思与回应机制：**
- 每次会话结束，生成总结，存储为短期记忆
- 每次对话的单个回合，作为观察内容，存储为长期记忆
- 在未来的对话中可以回忆这些内容

**人工验证与编辑：**
- 人工对 15% 的对话回合进行了编辑
- 对 19% 的图像进行了替换或移除
- 确保对话内容与事件图对齐

### 评估任务

**1. 问答任务（Question Answering）**

评估三种模型类型：
- 基础 LLM（受限上下文）：Mistral-7B、LLaMa-70B-chat、gpt-3.5-turbo、gpt-4-turbo
- 长上下文 LLM：gpt-3.5-turbo-16k
- RAG：使用 DRAGON 作为检索器，gpt-3.5-turbo-16k 作为阅读器

关键发现：
- gpt-4-turbo 表现最佳（32.4），但显著低于人类基准（87.9）
- RAG 将对话存储为观察内容时有效
- 随着检索观察数量增加，性能改善减弱

**2. 事件总结任务（Event Summarization）**

- 要求模型理解多次会话中事件的时间和因果关系
- gpt-3.5-turbo 召回率和 F1 分数最高
- 长上下文模型对上下文的利用不足

五类主要错误：
1. 信息缺失
2. 幻觉
3. 对话线索误解
4. 说话者归属错误
5. 不重要对话被错误视为重要事件

**3. 多模态对话生成任务**

- 包含上下文的训练提升了生成性能
- 将观察内容作为上下文时，结果更显著
- 观察内容包含说话者的经历信息，导致生成的对话和图像更符合说话者个性

### 总体结论

LLMs 在理解长时间叙述和提取时间及因果关系方面存在困难。尽管长上下文 LLM 和 RAG 提供了缓解，但 LLM 仍显著落后于人类，尤其是在时间推理和开放领域知识问题上。

### 应用 / 使用场景

- 评估 Agent 的长期记忆检索和推理能力
- 测试跨会话信息整合能力
- 基准比较不同记忆系统的效果

### 局限与争议

- 数据集由 LLM 生成，可能不完全反映真实用户对话特征
- 50 个对话的规模相对较小
- 评估指标（BLEU、F1）可能无法完全捕捉记忆质量

## 与其他实体的关系

- [[Agent-Memory]] —— LOCOMO 是 Agent Memory 评测的核心基准
- [[Mem0]] —— Mem0 使用 LOCOMO 进行评估
- [[MemoryAgentBench]] —— 互补的评测框架，关注不同维度

## 参考来源

- [[Agent-Memory评测全景-基准评估与记忆系统]] —— LOCOMO 数据集构建与实验结果
