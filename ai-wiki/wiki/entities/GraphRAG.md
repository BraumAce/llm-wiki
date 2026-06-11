---
title: "GraphRAG"
type: entity
date: 2026-06-09
also_known_as:
  - "Graph-based Retrieval-Augmented Generation"
  - "图谱增强检索"
tags:
  - ai-engineering
  - retrieval
  - knowledge-graph
  - RAG
sources:
  - "[[知识库分层编排-从RAG到Agent-native-Knowledge-Context-Layer]]"
  - "[[RAG全链路技术详解]]"
  - "[[从RAG到GraphRAG-货拉拉元数据检索应用实践]]"
related_entities:
  - "[[RAG]]"
  - "[[LightRAG]]"
  - "[[Pyramid-KB]]"
---

# GraphRAG

## 一句话定义

GraphRAG 是 Microsoft 提出的对 Naive RAG 的结构化升级——先构建知识图谱，再通过 Leiden 算法社区聚类生成分层社区摘要，查询时结合图结构和社区摘要回答，解决了传统 RAG "无法连点成线"和"无法全局理解"两大痛点。

## 摘要

GraphRAG 的核心流程：源文档 → 实体/关系提取 → 构建知识图谱 → Leiden 算法社区聚类 → 分层社区摘要 → 查询时通过 Global Search（社区摘要做全局推理）或 Local Search（从特定实体出发沿图谱边扩展）回答。

与 Naive RAG 相比，GraphRAG 通过图结构实现"连点成线"，通过社区摘要实现"全局理解"。但构建成本高（需要大量 LLM 调用做实体提取），增量更新困难，对源文档质量敏感。

## 核心机制

- **Global Search**：利用社区摘要做全局推理，如"整个代码库的设计模式有哪些？"
- **Local Search**：从特定实体出发，沿图谱边扩展到邻域，如"UserService 关联了哪些组件？"

## 与其他实体的关系

- [[RAG]] —— GraphRAG 是 RAG 的结构化升级
- [[LightRAG]] —— 轻量级图 RAG 实现
- [[Pyramid-KB]] —— 金字塔知识库在 GraphRAG 基础上增加了层次感知和角色适配
