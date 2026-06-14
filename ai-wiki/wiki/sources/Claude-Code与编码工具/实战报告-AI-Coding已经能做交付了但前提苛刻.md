---
title: "【万字】实战报告：AI Coding 已经能做交付了，但前提苛刻"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/Gc5P60gqmoXQov3fy0_85A"
author: "未知"
published_at: "2026-03-11"
ingested_at: 2026-05-31
tags:
  - ai-coding
  - spec-driven-development
  - practice
related_entities:
  - "[[Claude-Code]]"
  - "[[Spec-Driven-Development]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 【万字】实战报告：AI Coding 已经能做交付了，但前提苛刻

## 一句话概括

通过「从 0 到 1 新项目、已有项目迭代、文档不全的老项目」三场景验证，得出 AI Coding 已可承接真实交付，但前提是把目标、字段、校验规则、feature flag、测试与验收命令显式写成可执行规格。

## 实践内容

### 三场景验证

1. **从 0 到 1 新项目** —— 最适合 AI Coding
2. **已有项目迭代** —— 需要更多上下文
3. **文档不全的老项目** —— 最具挑战

### 前提条件

必须把以下内容显式写成可执行规格：
- 目标
- 字段
- 校验规则
- feature flag
- 测试
- `pnpm lint/test/build` 验收命令

### 核心结论

输入质量而非模型本身决定结果稳定性。

## 摘录

> 作者通过「从 0 到 1 新项目、已有项目迭代、文档不全的老项目」三场景验证，得出 AI Coding 已可承接真实交付，但前提是把目标、字段、校验规则、feature flag、测试与 `pnpm lint/test/build` 验收命令显式写成可执行规格。

> 输入质量而非模型本身决定结果稳定性。

## 涉及实体

- [[Claude-Code]] —— AI Coding 的交付实践
- [[Spec-Driven-Development]] —— 可执行规格是 SDD 的核心

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

"输入质量而非模型本身决定结果稳定性"——这是 AI Coding 最重要的洞察。模型能力已经足够，关键是输入的质量。
