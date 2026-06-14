---
title: "Cross-Encoder"
type: entity
date: 2026-06-12
also_known_as:
  - "交叉编码器"
  - "Reranker 模型"
tags: [RAG, reranking, NLP]
sources: [如何构建一个更好的知识库]
related_entities: [RAG, RAGAS, HyDE]
---

# Cross-Encoder

## 一句话定义

Cross-Encoder 是一种用于文档重排序（Reranking）的模型架构，将查询和文档拼接后同时编码，通过交叉注意力机制捕捉更细粒度的语义相关性，精度高于 Bi-Encoder 但计算成本更高，是 RAG 系统 Reranker 阶段的核心模型。

## 摘要

在 RAG 系统中，向量检索（基于 Bi-Encoder）速度快但精度有限，因为查询和文档是独立编码的。Cross-Encoder 将查询和文档拼接成一个序列输入 Transformer，通过交叉注意力让查询和文档的每个 token 都能相互关注，从而捕捉更精细的语义匹配信号。

实践中，Cross-Encoder 通常用作 Reranker：先用向量检索从海量文档中快速召回 Top-K 候选（如 K=100），再用 Cross-Encoder 对这 K 个候选精排，取 Top-5 送入 LLM。这种两阶段架构兼顾了效率和精度。主流的 Cross-Encoder 模型包括 BAAI 的 bge-reranker-v2-m3、Cohere Rerank API、cross-encoder/ms-marco-MiniLM-L-12-v2 等。

## 详情

### 起源与背景

Cross-Encoder 架构源于信息检索领域的研究，最早在 BERT 时代被广泛应用于文本相似度和自然语言推理任务。随着 RAG 的兴起，Cross-Encoder 被引入作为 Reranker 的核心模型。与 Bi-Encoder 相比，Cross-Encoder 的精度更高但速度更慢，因此通常用于精排阶段而非召回阶段。这种两阶段架构（召回+精排）已成为现代 RAG 系统的标准配置。

### 核心机制 / 工作原理

```
Bi-Encoder vs Cross-Encoder 架构对比：

Bi-Encoder（向量检索）：
- 查询和文档独立编码为向量
- 通过余弦相似度/内积计算相关性
- 速度快（可预计算文档向量，检索时只编码查询）
- 精度有限（无法捕捉细粒度的 token 级别交互）
- 适合大规模召回（百万级文档）

Cross-Encoder（重排序）：
- 查询和文档拼接为 [CLS] query [SEP] doc [SEP]
- 通过交叉注意力同时编码，每个 token 都能关注对方
- 精度高（能捕捉 token 级别的匹配信号）
- 速度慢（无法预计算，每次都要重新编码）
- 适合精排（Top-K 候选，K 通常 50-100）

RAG 两阶段架构：
向量检索召回 Top-100 → Cross-Encoder 精排 → 取 Top-5 送入 LLM
```

### 应用 / 使用场景

- RAG 系统的 Reranker 阶段，提升检索精度
- 搜索引擎的结果重排序
- 问答系统的答案筛选
- 语义相似度计算
- 推荐系统的候选排序

### 主流模型选型

```
推荐 Reranker 模型：
- bge-reranker-v2-m3（BAAI）：中文效果好，开源可私有部署
- Cohere Rerank API：英文效果好，API 调用方便
- cross-encoder/ms-marco-MiniLM-L-12-v2：轻量级，适合资源受限场景
- jina-reranker-v2-base-multilingual：多语言支持好
```

### 局限与争议

- 计算成本高，不适合直接用于海量文档检索（比 Bi-Encoder 慢 100-1000 倍）
- 需要标注数据进行微调，零样本效果可能不如预期
- 推理速度比 Bi-Encoder 慢很多，增加 RAG 系统延迟
- 模型大小与精度的权衡：更大的模型精度更高但延迟更大
- 对于长文档，需要先截断或分段处理

## 与其他实体的关系

- [[RAG]] —— Cross-Encoder 是 RAG 系统 Reranker 的核心模型
- [[RAGAS]] —— Reranker 的效果可通过 RAGAS 指标量化评估
- [[HyDE]] —— HyDE 与 Cross-Encoder 可组合使用，先 HyDE 召回再 Reranker 精排

## 参考来源

- [[如何构建一个更好的知识库]]
