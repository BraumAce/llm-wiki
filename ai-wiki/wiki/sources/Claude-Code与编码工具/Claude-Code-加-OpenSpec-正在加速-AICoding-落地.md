---
title: "Claude Code + OpenSpec 正在加速 AICoding 落地：从模型博弈到工程化的范式转移"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/aHAJxvrwobUKsPZ3w7GnYw"
author: "得物技术"
published_at: "2026-03-23"
ingested_at: 2026-05-31
tags:
  - claude-code
  - spec-driven-development
  - context-engineering
  - harness-engineering
related_entities:
  - "[[Claude-Code]]"
  - "[[Spec-Driven-Development]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# Claude Code + OpenSpec 正在加速 AICoding 落地

## 一句话概括

直指 AICoding 瓶颈是上下文管理而非模型（DORA 2024 显示 AI 采用率每 +25% 交付稳定性 -7.2%、32K Token 准确率从 99.3% 跌至 69.7%），用 Claude Code 的 Gather-Action-Verify 代理循环 + MCP 按需加载 + CLAUDE.md 持久记忆做执行，叠加 OpenSpec 的 proposal/specs/design/tasks 四工件做规格驱动开发。

## 实践内容

### AICoding 瓶颈量化

- DORA 2024 数据：AI 采用率每 +25%，交付稳定性 -7.2%
- 32K Token 准确率从 99.3% 跌至 69.7%
- 结论：瓶颈是上下文管理，不是模型能力

### Claude Code 执行层

- **Gather-Action-Verify 代理循环** —— 收集上下文 → 采取行动 → 验证结果
- **MCP 按需加载** —— 减少固定开销
- **CLAUDE.md 持久记忆** —— 跨会话保持上下文

### OpenSpec 规格驱动开发

四工件体系：
1. **proposal** —— 提案文档
2. **specs** —— 规格说明
3. **design** —— 设计文档
4. **tasks** —— 任务分解

生命周期：propose → apply → archive

### SDD 与 Harness 的协作

Claude Code 做执行（Gather-Action-Verify），OpenSpec 做规格（proposal/specs/design/tasks），两者结合实现规格驱动开发（SDD）。

## 摘录

> 直指 AICoding 瓶颈是上下文管理而非模型（DORA 2024 显示 AI 采用率每 +25% 交付稳定性 -7.2%、32K Token 准确率从 99.3% 跌至 69.7%），用 Claude Code 的 Gather-Action-Verify 代理循环 + MCP 按需加载 + CLAUDE.md 持久记忆做执行，叠加 OpenSpec 的 proposal/specs/design/tasks 四工件与 propose-apply-archive 生命周期做规格驱动开发（SDD）。

## 涉及实体

- [[Claude-Code]] —— 作为 SDD 的执行层
- [[Spec-Driven-Development]] —— OpenSpec 的四工件体系
- [[Harness-Engineering]] —— Gather-Action-Verify 循环是 Harness 的核心

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这篇文章的数据很有说服力——AI 采用率每增加 25%，交付稳定性下降 7.2%。这说明单纯增加 AI 使用量并不能提高质量，必须配合上下文工程和规格驱动开发。32K Token 准确率从 99.3% 跌至 69.7% 的数据也印证了上下文管理的重要性。
