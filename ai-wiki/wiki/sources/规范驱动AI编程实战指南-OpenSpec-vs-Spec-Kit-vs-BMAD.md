---
title: "规范驱动 AI 编程实战指南：OpenSpec vs Spec-Kit vs BMAD"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/kLVeNYxfg5xqcxixdttTGQ"
author: "未知"
published_at: "2026-03-01"
ingested_at: 2026-05-31
tags:
  - spec-driven-development
  - ai-coding
  - tools
related_entities:
  - "[[Spec-Driven-Development]]"
  - "[[Claude-Code]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 规范驱动 AI 编程实战指南：OpenSpec vs Spec-Kit vs BMAD

## 一句话概括

从 SDD 把规范升级为单一可信源的视角横评三款工具——OpenSpec 专攻遗留代码维护、Spec-Kit 工具无关适合新项目、BMAD 多智能体模拟全角色适合企业级。

## 实践内容

### 三款工具对比

| 工具 | 方法 | 适用场景 | 学习成本 |
|------|------|----------|----------|
| OpenSpec | specs/ 与 changes/ 文件夹，三步循环 | 遗留代码维护 | 低（5 分钟启动） |
| Spec-Kit | /specify、/plan 斜杠命令，6 步流程 | 新项目 | 中 |
| BMAD | 多智能体模拟全角色 | 企业级跨仓库复杂项目 | 高 |

### OpenSpec

- **方法**：specs/ 与 changes/ 文件夹做「提案 → 实施 → 归档」三步循环
- **优势**：专攻遗留代码维护，5 分钟即可启动
- **适用**：已有项目的迭代开发

### Spec-Kit

- **方法**：/specify、/plan 斜杠命令的 6 步流程
- **优势**：工具无关
- **适用**：新项目

### BMAD

- **方法**：多智能体模拟业务分析师、PM、架构师、开发、QA 全角色
- **优势**：适合企业级跨仓库复杂项目
- **劣势**：学习与维护成本最高

## 摘录

> 从 SDD 把规范升级为单一可信源的视角横评三款工具——OpenSpec 用 specs/ 与 changes/ 文件夹做「提案 → 实施 → 归档」三步循环，专攻遗留代码维护，5 分钟即可启动。

> Spec-Kit 走 /specify、/plan 斜杠命令的 6 步流程，工具无关，适合新项目；BMAD 多智能体模拟业务分析师、PM、架构师、开发、QA 全角色，适合企业级跨仓库复杂项目但学习与维护成本最高。

## 涉及实体

- [[Spec-Driven-Development]] —— 三款 SDD 工具的对比
- [[Claude-Code]] —— Claude Code 可以与这些工具配合使用

## 涉及主题

- [[Harness-Engineering-主题]]
