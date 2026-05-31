---
title: "从RAG到GraphRAG：货拉拉元数据检索应用实践"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/AmbfOJJFypnsAkVTjC9eJQ"
author: "货拉拉"
published_at: "2026-03-18"
ingested_at: 2026-05-31
tags:
  - rag
  - graphrag
  - retrieval
  - knowledge-graph
related_entities:
  - "[[RAG]]"
  - "[[LightRAG]]"
related_topics:
  - "[[AI-Infra推理优化-主题]]"
---

# 从RAG到GraphRAG：货拉拉元数据检索应用实践

## 一句话概括

货拉拉元数据找数场景中，Naive RAG 准确率仅 55%、召回率 60%，切到 LightRAG 路线的 GraphRAG 后准确率提升至 78%、召回率 91%、TopK 命中率 90%、MRR 0.73。

## 实践内容

### Naive RAG 的问题

- 准确率仅 55%、召回率 60%
- 在同义词、多实体、关系召回上拉胯
- 单字段切块 + 向量检索的局限性

### GraphRAG 方案

**实体类型：**
- 表/字段
- 业务术语/缩写
- 同义词

**Query 处理：**
1. LLM 抽取高/低级关键词
2. 混合检索（向量 + BM25 + 重排）
3. 图关联形成 Local/Global Context

### 效果对比

| 指标 | Naive RAG | GraphRAG |
|------|-----------|----------|
| 准确率 | 55% | 78% |
| 召回率 | 60% | 91% |
| TopK 命中率 | - | 90% |
| MRR | - | 0.73 |
| 渗透率 | - | 30% |
| 数仓答疑省时 | - | 20% |

## 摘录

> 货拉拉元数据找数场景中，Naive RAG 单字段切块 + 向量检索准确率仅 55%、召回率 60%，在同义词、多实体、关系召回上拉胯。

> 2.0 切到 LightRAG 路线的 GraphRAG，把表/字段、业务术语/缩写、同义词三类实体建图，Query 经 LLM 抽高/低级关键词后混合检索（向量 + BM25 + 重排）+ 图关联形成 Local/Global Context；准确率提升至 78%、召回率 91%、TopK 命中率 90%、MRR 0.73。

## 涉及实体

- [[RAG]] —— Naive RAG 的局限性
- [[LightRAG]] —— GraphRAG 的实现方案

## 涉及主题

- [[AI-Infra推理优化-主题]]

## 我的评注

GraphRAG 在元数据检索场景的效果提升非常明显——准确率从 55% 到 78%，召回率从 60% 到 91%。关键是把实体关系建模为图结构，这样可以捕获同义词、多实体、关系等 Naive RAG 无法处理的场景。
