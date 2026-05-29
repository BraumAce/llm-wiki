---
title: "Agent核心技术概念与范式发生了哪些演变"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/11Krmb5KYmCHDQ4zN9O4uQ"
author: "阿里云开发者"
ingested_at: 2026-05-29
tags: [agent, evolution, paradigm]
related_entities: [OpenClaw, OpenClaw-Skills]
related_topics: [Agent架构演进-主题]
---

# Agent核心技术概念与范式发生了哪些演变

## 一句话概括
系统梳理Agent技术从2023到2026年经历的四个发展阶段（被动式ReAct、工作流Agent、自主Agent、自进化Agent），以及Prompt、Planning、Memory、Tools、Workflow、Environment六大核心模块的演进逻辑，揭示Agent从"魔法调优"到"系统工程"的转变。

## 摘录
> Agent 的范式演化清晰地展示了一条从"简单交互"到"复杂执行"，再到"智能成长"的技术进阶之路。需要注意的是，这四个阶段并非完全的替代关系，而是并存且互补的。在实际落地中，我们需要根据业务的复杂度、对稳定性的要求以及成本预算，选择合适的 Agent 范式。

> 从早期的 Function Call 到如今的 CLI + Script 模式，Tools 的演进核心是从"人为适配模型"转向"利用模型原生能力"。我们不再试图为每一个操作编写专用的 API 接口，而是充分利用模型在预训练阶段积累的通用计算机操作知识和代码执行能力。

> Agent 正在从"魔法调优"到"系统工程"的转变，标志着 Agent 技术正在走向成熟。通过更精细的工程化手段来弥补模型的不足，放大模型的优势。"通过工程化手段构建确定性，以承载模型不确定性"的核心思想，将是未来很长一段时间内构建高质量 Agent 的基石。

## 涉及实体
- [[OpenClaw]] —— 自主Agent阶段的代表性框架
- [[OpenClaw-Skills]] —— Skill体系是Prompt演进和Workflow演进的核心载体

## 涉及主题
- [[Agent架构演进-主题]]
