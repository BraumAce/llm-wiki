---
title: "知识库分层编排：从 RAG 到 Agent-native Knowledge Context Layer"
type: source
date: 2026-06-09
author: 板牙
source_type: wechat
source_url: https://mp.weixin.qq.com/s/_IlrlfGpPa42VhTaKNAj6A
tags:
  - RAG
  - 知识库
  - GraphRAG
  - Agent
  - 知识工程
related_entities:
  - "[[RAG]]"
  - "[[GraphRAG]]"
  - "[[LightRAG]]"
  - "[[Pyramid-KB]]"
---

# 知识库分层编排：从 RAG 到 Agent-native Knowledge Context Layer

> 来源：阿里云开发者社区（板牙），2026-06-09

## 核心观点

知识库的四种范式各有局限，核心缺失是层次感知与角色适配。金字塔模型将知识分为五层，通过分层检索与图谱关联，让 AI 按角色、层级精准定位答案。知识库的终极形态不是"更大的向量库"，而是"更聪明的知识路由器"。

## RAG 的三个结构性缺陷

1. **每次从零推导** — LLM 在每个问题上都从头重新发现知识，没有任何积累（Karpathy: "the LLM is rediscovering knowledge from scratch on every question"）
2. **无法连点成线** — 平坦向量检索无法通过共享属性连接分散信息（Microsoft GraphRAG 指出的 baseline RAG 失败模式）
3. **粒度混乱** — 向量空间不区分抽象层次，"设计原则"和"代码实现"在语义上可能很近但服务于完全不同的认知需求

## 四大知识库范式

### 范式一：Naive RAG — 平铺向量检索

文档 → chunk → embedding → 向量数据库 → 相似度检索。实现简单但无积累、无关联、无层次、无角色区分。

### 范式二：LLM Wiki — 持续编译的知识工件

Karpathy 提出的模式。三层架构：Raw Sources（人类策展）→ Wiki（LLM 完全拥有）→ Schema（人类 + LLM 共同演进）。核心操作：Ingest、Query、Lint。

### 范式三：Graphify — 代码即图谱

双管道提取：AST 管道（tree-sitter 离线解析）+ 语义管道（LLM 语义提取）。产出物：graph.html、GRAPH_REPORT.md、graph.json。独有能力：God Nodes、Surprising Connections、Knowledge Gaps、置信度三档（EXTRACTED/INFERRED/AMBIGUOUS）。

### 范式四：GraphRAG — 图谱增强的检索

Microsoft GraphRAG：构建知识图谱 → Leiden 社区聚类 → 分层社区摘要 → Global Search / Local Search。

## 金字塔知识库（Pyramid KB）

### 五层分层

| 层 | 职责 | 稳定性 | 类比 |
|----|------|--------|------|
| L1 原则 | SOLID / KISS / YAGNI | 年级 | 宪法 |
| L2 架构 | 架构决策记录 ADR | 季度级 | 法律 |
| L3 规范 | 编码标准 ESLint 规则 | 月级 | 规章 |
| L4 实现 | 代码模板 SDK 文档 | 周级 | 手册 |
| L5 经验 | 故障复盘 运维日志 | 天级 | 判例 |

### 跨层关联（7 种有向边）

governs / defines / constrains / implements / validates / feedback / cross_ref

### 角色感知

- 架构师：L1 + L2
- 开发者：L2 + L3 + L4
- 运维/SRE：L4 + L5
- 新人：L1→L2→L3→L5 全链路导航

### 检索机制

金字塔分层检索 vs 向量检索：分层关键词打分 + 图谱扩展，0 API 调用（纯本地），角色可访问层子集。最优组合：金字塔做分层定位 → 向量检索补代码级深度。

## 知识保鲜

- 三种腐烂形式：静默过期、层级漂移、覆盖盲区
- 三大保鲜原则：每层不同审查周期、用审计发现问题、变更驱动更新
- 增量同步：审计 → 摄入 → 后审计，去重四策略（checksum + entry ID）

## 实战测评

831 篇源文档、14 个代码服务、5 个业务域，200 条 QA pair（RAGAS 框架）。Pyramid+RAG Hit@3=89% vs Naive RAG ~75%。

## 参考文献

- [1] Karpathy, LLM Wiki Pattern: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- [2] Graphify: https://github.com/safishamsi/graphify
- [3] Microsoft GraphRAG: https://microsoft.github.io/graphrag/
