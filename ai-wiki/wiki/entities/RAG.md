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
  - "[[ByteLighting-2026年5月技术阅读合集]]"
related_entities:
  - "[[vLLM]]"
  - "[[OpenClaw-双源记忆系统]]"
---

# RAG

## 一句话定义

RAG（Retrieval-Augmented Generation，检索增强生成）是一种将外部知识检索与大模型生成相结合的技术范式——先从知识库中检索相关信息，再将其注入模型上下文进行生成，从而让模型"知道"训练数据之外的知识。

## 摘要

RAG 是 2023-2025 年 LLM 应用中最核心的技术范式之一。它的基本思路是：大模型的参数化知识有截止日期且无法覆盖私域数据，通过在推理时动态检索外部知识并注入上下文，可以扩展模型的知识边界。RAG 的全链路包括文档加载、语义切分、向量索引构建、查询优化、检索排序、答案生成六大环节。

2026 年的 RAG 实践已经远超"简单向量检索"的阶段。Meta-Chunking 语义切分、HyDE 假设性文档嵌入、Graph RAG 多跳推理、Ragas 评估体系等技术构成了完整的工程化闭环。同时，以 LLM Wiki / GBrain 为代表的"知识编译"思路正在挑战传统 RAG 的"每次从头检索"模式——主张用 AI 一次性把素材编译成结构化 Wiki，后续查询直接翻阅而非重新检索。

## 详情

### 起源与背景

RAG 的概念最早由 Meta AI 在 2020 年的论文 "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" 中提出。原始动机是解决大模型的两个核心问题：知识截止（训练数据有时间边界）和幻觉（生成不存在的事实）。

2023-2024 年，随着 ChatGPT 和开源 LLM 的普及，RAG 成为企业级 LLM 应用的标准架构。LangChain、LlamaIndex 等框架推动了 RAG 的工程化。2025-2026 年，RAG 技术栈进一步成熟，围绕切分策略、检索优化、评估体系形成了完整的工程方法论。

### 核心机制 / 工作原理

RAG 的全链路分为六个环节：

1. **文档加载与元数据提取**：支持 PDF、Markdown、HTML、代码等多种格式，提取标题、作者、时间等元数据
2. **语义切分（Chunking）**：基于 PPL 困惑度的 Meta-Chunking 识别语义边界，避免固定窗口切在句子中间
3. **向量索引构建**：embedding 模型（如 BGE、E5）将 chunk 转为向量，存入 FAISS / Milvus / Qdrant 等向量数据库
4. **查询优化**：Query 改写（扩展同义词）、HyDE（先让模型生成假设答案再检索）、Multi-Query（多角度查询）
5. **检索与重排序**：向量召回 + BM25 稀疏召回 → 混合排序 → Cross-Encoder 精排
6. **答案生成**：将检索结果注入 prompt，模型基于上下文生成答案

```
RAG 流程图
用户问题
  ↓
查询优化（改写/HyDE/Multi-Query）
  ↓
向量检索 + BM25 混合召回
  ↓
重排序（Cross-Encoder）
  ↓
Top-K 文档注入 Prompt
  ↓
LLM 生成答案
```

**进阶：Graph RAG**

传统 RAG 只做单跳检索。Graph RAG 在知识图谱上做多跳推理：先识别问题中的实体，沿图谱关系追踪关联实体，再将多跳结果一起注入上下文。

**Ragas 评估体系**

RAG 的质量需要系统化评估。Ragas 提供四个维度：
- **Faithfulness**（忠实度）：答案是否基于检索到的文档
- **Answer Relevancy**（答案相关性）：答案是否回答了问题
- **Context Precision**（上下文精度）：检索结果中相关内容的比例
- **Context Recall**（上下文召回）：相关信息是否都被检索到

### 应用 / 使用场景

- **企业知识库**：内部文档、FAQ、产品手册的智能问答
- **客服系统**：基于产品文档的自动应答
- **代码助手**：基于代码库的上下文感知编程辅助
- **学术研究**：论文检索与综述生成
- **法律/医疗**：基于专业文献的决策支持

### 局限与争议

- **检索质量瓶颈**：如果检索不到正确文档，模型无法生成正确答案（Garbage In, Garbage Out）
- **上下文窗口限制**：检索到的文档受 context window 限制，无法注入无限知识
- **延迟开销**：检索 + 重排序 + 生成的链路增加了响应延迟
- **知识编译的挑战**：LLM Wiki 等方案主张"一次编译、永久使用"，挑战 RAG 的"每次检索"模式——但知识更新的及时性是知识编译的弱点
- **评估困难**：Ragas 等自动评估与人类判断仍有差距，生产环境需要人工抽样

## 与其他实体的关系

- [[vLLM]] —— RAG 系统的底层推理通常由 vLLM 等推理框架提供
- [[OpenClaw-双源记忆系统]] —— OpenClaw 的记忆系统结合了 RAG（动态检索）和结构化存储（静态知识）两种思路

## 参考来源

- [[ByteLighting-2026年5月技术阅读合集]] —— RAG 全链路技术详解、LLM Wiki vs RAG 对比等文章
