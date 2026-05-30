---
title: "RAG"
type: entity
date: 2026-05-29
also_known_as:
  - "Retrieval-Augmented Generation"
  - "检索增强生成"
tags:
  - ai-engineering
  - retrieval
  - knowledge-management
  - llm
sources:
  - "[[RAG全链路技术详解]]"
  - "[[深度解析LLM-Wiki-Obsidian-Wiki-GBrain]]"
related_entities:
  - "[[vLLM]]"
  - "[[OpenClaw-双源记忆系统]]"
  - "[[Agent-Memory]]"
  - "[[LightRAG]]"
---

# RAG

## 一句话定义

RAG（Retrieval-Augmented Generation，检索增强生成）是一种将外部知识检索与大模型生成相结合的技术范式——先从知识库中检索相关信息，再将其注入模型上下文进行生成，从而让模型"知道"训练数据之外的知识。

## 摘要

RAG 是 2023-2025 年 LLM 应用中最核心的技术范式之一。它的基本思路是：大模型的参数化知识有截止日期且无法覆盖私域数据，通过在推理时动态检索外部知识并注入上下文，可以扩展模型的知识边界。RAG 的全链路包括文档加载、语义切分、向量索引构建、查询优化、检索排序、答案生成六大环节。

2026 年的 RAG 实践已经远超"简单向量检索"的阶段。Meta-Chunking 语义切分、HyDE 假设性文档嵌入、Graph RAG 多跳推理、Ragas 评估体系等技术构成了完整的工程化闭环。同时，以 LLM Wiki / GBrain 为代表的"知识编译"思路正在挑战传统 RAG 的"每次从头检索"模式。

## 详情

### 核心机制 / 工作原理

RAG 的全链路分为六个环节：

1. **文档加载与元数据提取**：支持 PDF、Markdown、HTML、代码等多种格式
2. **语义切分（Chunking）**：基于 PPL 困惑度的 Meta-Chunking 识别语义边界
3. **向量索引构建**：embedding 模型将 chunk 转为向量，存入向量数据库
4. **查询优化**：Query 改写、HyDE、Multi-Query
5. **检索与重排序**：向量召回 + BM25 稀疏召回 → 混合排序 → Cross-Encoder 精排
6. **答案生成**：将检索结果注入 prompt，模型基于上下文生成答案

**进阶：Graph RAG** — 在知识图谱上做多跳推理。

**Ragas 评估体系**：Faithfulness（忠实度）、Answer Relevancy（答案相关性）、Context Precision（上下文精度）、Context Recall（上下文召回）。

### 应用 / 使用场景

- **企业知识库**：内部文档、FAQ、产品手册的智能问答
- **客服系统**：基于产品文档的自动应答
- **代码助手**：基于代码库的上下文感知编程辅助

### 局限与争议

- **检索质量瓶颈**：如果检索不到正确文档，模型无法生成正确答案
- **上下文窗口限制**：检索到的文档受 context window 限制
- **知识编译的挑战**：LLM Wiki 等方案主张"一次编译、永久使用"，挑战 RAG 的"每次检索"模式

## 与其他实体的关系

- [[vLLM]] —— RAG 系统的底层推理通常由 vLLM 等推理框架提供
- [[OpenClaw-双源记忆系统]] —— OpenClaw 的记忆系统结合了 RAG 和结构化存储两种思路
- [[Agent-Memory]] —— RAG 可以看作 Agent Memory 的检索层
- [[LightRAG]] —— LightRAG 是 RAG 的图增强扩展，通过知识图谱解决传统 RAG 的碎片化检索问题

## 参考来源

- [[RAG全链路技术详解]] —— RAG 全链路工程实践
- [[深度解析LLM-Wiki-Obsidian-Wiki-GBrain]] —— LLM Wiki vs RAG 对比
