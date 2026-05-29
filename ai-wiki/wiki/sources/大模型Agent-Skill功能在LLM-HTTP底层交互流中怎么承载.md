---
title: "大模型Agent-Skill功能在LLM-HTTP底层交互流中怎么承载"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/dAD9srnD5MpoCkHWlRYtzQ"
author: "腾讯云开发者"
ingested_at: 2026-05-29
tags: [skill, protocol, llm-http]
related_entities: [OpenClaw-Skills]
related_topics: [Agent架构演进-主题]
---

# 大模型Agent-Skill功能在LLM-HTTP底层交互流中怎么承载

## 一句话概括
Skill在OpenAI兼容协议层面完全不存在，它是纯粹的应用层抽象，最终被编译为三种协议原语的组合：System/Developer Message注入指令、Tools Definition注册工具、Multi-turn Tool Calling Loop执行循环，其全部"魔法"发生在system prompt的措辞和SKILL.md文件的编写质量上。

## 摘录
> 核心结论先说：Skills 不是协议层概念。在 OpenAI 兼容协议中，根本不存在"Skill"这个字段或角色。Skills 是一个纯粹的应用层抽象，它最终被"编译"成三种协议原语的组合：System/Developer Message、Tools Definition、Multi-turn Tool Calling Loop。

> Skill 在协议层面完全不存在。它是一种"给 LLM 写使用手册，让 LLM 通过已有工具自己照着做"的设计模式。整个过程就是：在 system prompt 里告诉 LLM "你有这些技能手册可以查"，LLM 通过 Read 工具自己去读手册，LLM 读完手册后，按手册说的步骤，通过 Shell/Read 等工具一步步执行。

> 这种设计的精妙之处在于：它完全复用了 OpenAI 协议已有的 tool calling 机制，不需要任何协议扩展。Skill 的全部"魔法"都发生在 system prompt 的措辞和 SKILL.md 文件的编写质量上——本质上是一种 prompt engineering + 文件系统的组合。

## 涉及实体
- [[OpenClaw-Skills]] —— 文章揭示了Skill在底层HTTP协议中的承载机制

## 涉及主题
- [[Agent架构演进-主题]]
