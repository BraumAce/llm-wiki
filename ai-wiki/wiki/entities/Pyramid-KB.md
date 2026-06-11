---
title: "Pyramid-KB"
type: entity
date: 2026-06-09
also_known_as:
  - "金字塔知识库"
  - "Pyramid Knowledge Base"
  - "Agent-native Knowledge Context Layer"
tags:
  - ai-engineering
  - knowledge-management
  - RAG
  - Agent
sources:
  - "[[知识库分层编排-从RAG到Agent-native-Knowledge-Context-Layer]]"
related_entities:
  - "[[RAG]]"
  - "[[GraphRAG]]"
  - "[[LightRAG]]"
  - "[[LLM-Wiki-Pattern]]"
---

# Pyramid-KB（金字塔知识库）

## 一句话定义

金字塔知识库是一种将知识按稳定性和抽象度分为五层（原则→架构→规范→实现→经验），并结合角色感知检索和图谱关联的知识工程范式，补上了传统 RAG 和 GraphRAG 缺失的"层次感知 + 角色适配"能力。

## 摘要

金字塔知识库是板牙在阿里云开发者社区提出的知识工程范式，核心创新在于五层分层设计 + 角色感知检索 + 跨层图谱关联。

五层分层：
- **L1 原则**（年稳定）：SOLID / KISS / YAGNI，类比宪法
- **L2 架构**（季度稳定）：架构决策记录 ADR，类比法律
- **L3 规范**（月稳定）：编码标准 ESLint 规则，类比规章
- **L4 实现**（周稳定）：代码模板 SDK 文档，类比手册
- **L5 经验**（天稳定）：故障复盘 运维日志，类比判例

角色感知：架构师看 L1+L2，开发者看 L2+L3+L4，运维看 L4+L5，新人走 L1→L2→L3→L5 全链路导航。每个角色有独立的 context_budget 和 priority_order。

检索机制：分层关键词打分 + 图谱扩展，0 API 调用（纯本地）。最优组合：金字塔做分层定位 → 向量检索补代码级深度。

知识保鲜：每层不同审查周期（L1 年度、L5 天级），用审计发现问题，变更驱动更新。

实战：831 篇文档、200 条 QA pair，Pyramid+RAG Hit@3=89% vs Naive RAG ~75%。

## 核心机制

跨层关联 7 种有向边：governs / defines / constrains / implements / validates / feedback / cross_ref

增量同步：审计 → 摄入 → 后审计，去重四策略（checksum + entry ID：skip/update/move/write）

## 与其他实体的关系

- [[RAG]] —— 金字塔在 RAG 之上增加结构化路由和导航层
- [[GraphRAG]] —— 金字塔在 GraphRAG 基础上增加层次感知和角色适配
- [[LLM-Wiki-Pattern]] —— LLM Wiki 是金字塔的范式二，金字塔是更系统的演进
