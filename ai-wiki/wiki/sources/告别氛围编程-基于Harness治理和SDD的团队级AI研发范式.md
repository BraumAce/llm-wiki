---
title: "告别氛围编程-基于Harness治理和SDD的团队级AI研发范式"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/-_IBJFuXpvoqMJxL9oaEJQ"
author: "阿里云开发者"
ingested_at: 2026-05-29
tags: [harness-engineering, sdd, vibe-coding]
related_entities: [Harness-Engineering, Spec-Driven-Development]
related_topics: [Harness-Engineering-主题]
---

# 告别氛围编程-基于Harness治理和SDD的团队级AI研发范式

## 一句话概括
本文从出码率提升却未带来真正提效的困惑出发，提出通过SDD（规范驱动开发）和Harness Engineering将AI编程从"氛围编程"升级为团队级工程能力的解决方案。

## 摘录
> 出码率提升了，但项目交付周期没有明显缩短；AI 写了更多代码，但开发者的工作量并没有减少。AI Coding 存在的三大问题：第一，自由发挥问题——AI 生成的代码常常天马行空；第二，效率降低问题——如果指令不够清晰，你会在多轮对话中反复拉扯；第三，关键信息丢失问题——多轮对话中，AI 往往会"忘记"之前的重要约束。

> SDD 的核心思想是颠覆性的：规范不再是写给人类看的散文，而是结构化的、可被 AI Agent 精确理解和执行的"意图代码"。在传统开发中，PRD 或设计文档只是"指导书"，代码才是唯一的"真理之源"。SDD 颠覆了这个结构：规范成了唯一的真实来源。当需求变更时，开发者首先修改的是"规范"，随后由 AI 工具根据规范重新生成、验证并更新底层代码。

> Harness 这个词很形象。想象一匹野马——AI 大模型拥有无穷的力量，但没有马具，你根本骑不上去，甚至可能被它甩下来。Harness Engineering 的核心，不是去改变马的基因（模型本身），而是为这匹野马设计一套精密的控制系统。一个成熟的 Harness 系统包含四个核心支柱：上下文工程、架构约束、反馈回路与熵管理、人类监督。

> 从提示词工程到上下文工程，再到 Harness Engineering，这是一个范式转移：从"怎么跟 AI 说话"，到"AI 应该看到什么"，再到"AI 如何在受控环境中运行"。AI 编程要从"个人技能"升级为"团队级工程能力"，要从"氛围编程"进化为"规范驱动、工程治理"的研发范式。

## 涉及实体
- [[Harness-Engineering]] —— 作为AI运行的受控环境
- [[Spec-Driven-Development]] —— 规范驱动开发，SDD工作流四阶段

## 涉及主题
- [[Harness-Engineering-主题]] —— SDD与Harness的协同落地
