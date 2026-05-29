---
title: "Claude-Code-Harness工程-数仓侧落地方案-得物技术"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/KmQJU7nXmYh5qgWPj4ajlw"
author: "得物技术"
ingested_at: 2026-05-29
tags: [harness-engineering, claude-code, data-warehouse]
related_entities: [Harness-Engineering]
related_topics: [Harness-Engineering-主题]
---

# Claude-Code-Harness工程-数仓侧落地方案-得物技术

## 一句话概括
本文介绍了得物技术团队在数仓场景下基于Claude Code构建Harness工程的五层防御体系，解决了AI开发中的失忆、规范执行不稳定和context膨胀三大痛点。

## 摘录
> 尽管整体提效已显现，但团队在实际使用中暴露出三类结构性痛点。痛点一：AI 不记得上下文约束，开发过程中反复"失忆"。会话开始时告知了"金额字段单位是千元"，对话进行到一半后 AI 忘了，生成的 SQL 把千元当元用，导致数据差了 1000 倍。这不是偶发问题，而是 Claude Code 的 context compact 机制的系统性限制。

> Harness = Claude Code 的宿主运行框架，即 Claude Code 客户端本身这个"工具链容器"。它管理 context window 生命周期；在 LLM 推理循环之外确定性地执行 hooks；协调 subagents 的生命周期；不依赖模型判断，直接执行配置的自动化行为。

> 核心矛盾：越是复杂的需求，越依赖 AI；但越复杂的需求，context 越容易撑满，AI 越容易"失忆"。Harness 工程的目标，就是把"执行层"的不稳定因素系统性地消掉：把规范写进 hooks，不再靠 AI 记忆；把迭代约束写进持久化文件，compact 后自动重新注入；把高 token 操作隔离到 subagent，主 context 只接收摘要。

> Harness 工程的本质，是把"语义"和"规范"从不可靠的 LLM 记忆中，迁移到确定性的 hooks + 持久化文件里，从而让语义 × 规范 = 准确率这个等式两边的变量都变得稳定。

## 涉及实体
- [[Harness-Engineering]] —— 在数仓场景下通过五层防御体系落地

## 涉及主题
- [[Harness-Engineering-主题]] —— hooks、subagents与持久化三层机制
