---
title: "企业级 Agent 多智能体架构与选型指南"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/_bz8DEgp4Lqt-xTa_lWN0A"
author: "未知"
published_at: "2026-03-20"
ingested_at: 2026-05-31
tags:
  - agent
  - multi-agent
  - architecture
  - enterprise
related_entities:
  - "[[Claude-Code]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# 企业级 Agent 多智能体架构与选型指南

## 一句话概括

基于 AgentScope Java 1.0.10 与 Spring AI Alibaba 1.1.2.2，主张 Single Agent First，按上下文/分工/并行/结构化四阈值演进，系统梳理 Pipeline、Routing、Skills、Subagents、Supervisor、Handoffs、Custom Workflow 七种模式。

## 实践内容

### Single Agent First 原则

优先使用 Single Agent，只在以下阈值满足时才演进：
1. **上下文阈值** —— 单 Agent 上下文窗口不够
2. **分工阈值** —— 任务需要不同专业能力
3. **并行阈值** —— 任务可以并行执行
4. **结构化阈值** —— 需要结构化的执行流程

### 七种多智能体模式

| 模式 | 适用场景 | 复杂度 |
|------|----------|--------|
| Pipeline | 线性流程 | 低 |
| Routing | 条件分支 | 低 |
| Skills | 能力复用 | 中 |
| Subagents | 任务委派 | 中 |
| Supervisor | 监督管理 | 高 |
| Handoffs | 任务交接 | 高 |
| Custom Workflow | 自定义流程 | 高 |

### 关键数据

- 多智能体协作准确率比单模型高约 32%
- 批评 + 优化 Agent 提升事实检索 26%

### 工作流 vs 对话

| 维度 | 工作流 | 对话 |
|------|--------|------|
| 确定性 | 高 | 低 |
| 灵活性 | 低 | 高 |
| 适用场景 | 流程化任务 | 开放式交互 |

## 摘录

> 基于 AgentScope Java 1.0.10 与 Spring AI Alibaba 1.1.2.2，主张 Single Agent First，并按上下文/分工/并行/结构化四阈值演进，系统梳理 Pipeline、Routing、Skills、Subagents、Supervisor、Handoffs、Custom Workflow 七种模式。

> 多智能体协作准确率比单模型高约 32%、批评 + 优化 Agent 提升事实检索 26%。

## 涉及实体

- [[Claude-Code]] —— 多智能体架构在 Claude Code 中的实现

## 涉及主题

- [[Agent架构演进-主题]]

## 我的评注

"Single Agent First"是一个重要的设计原则——很多团队过早引入多智能体架构，增加了不必要的复杂度。四阈值演进模型提供了清晰的决策框架。32% 的准确率提升数据也很有说服力。
