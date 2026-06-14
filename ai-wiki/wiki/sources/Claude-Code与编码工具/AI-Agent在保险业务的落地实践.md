---
title: "AI Agent在保险业务的落地实践：技术实战分享"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/Q9TdK8F8UByCdJjSGAjqaQ"
author: "京东保险"
published_at: "2026-03-02"
ingested_at: "2026-05-31"
tags:
  - agent
  - enterprise
  - insurance
  - llm
related_entities:
  - "[[Claude-Code]]"
related_topics: []
---

# AI Agent在保险业务的落地实践：技术实战分享

## 一句话概括

京东保险给出经济收益公式 R=(Ch-Ca)×D×A×S 来挑选场景，落地 Eva Agent 四大亮点——保险领域小尺寸大模型、深度知识库、三档计划策略、可进化架构。

## 实践内容

### 经济收益公式

```
R = (Ch - Ca) × D × A × S
```
- Ch：人工成本
- Ca：AI 成本
- D：需求密度
- A：AI 准确率
- S：场景规模

### Eva Agent 四大亮点

**1. 保险领域小尺寸大模型**
- CPT（Continual Pre-Training）
- SHADOW-FT
- structTuning
- 8 维测评：IDK/IMI/IUC 等

**2. 深度知识库**
- 表格序列化
- Late Chunking
- Embedding/Rerank 微调
- DeepDoc 路由

**3. 三档计划策略**
- 提示词编排
- 搜索增强层级规划
- RL 自主编排

**4. 可进化架构**
- 记忆
- 策略库
- 经验池
- self-play RL

## 摘录

> 京东保险给出经济收益公式 R=(Ch-Ca)×D×A×S 来挑选场景，落地 Eva Agent 四大亮点——保险领域小尺寸大模型（CPT + SHADOW-FT + structTuning，IDK/IMI/IUC 等 8 维测评）。

> 深度知识库（表格序列化、Late Chunking、Embedding/Rerank 微调、DeepDoc 路由）、三档计划策略（提示词编排 / 搜索增强层级规划 / RL 自主编排），以及含记忆、策略库、经验池与 self-play RL 的可进化架构。

## 涉及实体

- [[Claude-Code]] —— Agent 在企业级场景的落地实践

## 涉及主题

- []

## 我的评注

经济收益公式 R=(Ch-Ca)×D×A×S 是一个很实用的场景选择框架。可进化架构（记忆、策略库、经验池、self-play RL）是 Agent 系统的高级形态。
