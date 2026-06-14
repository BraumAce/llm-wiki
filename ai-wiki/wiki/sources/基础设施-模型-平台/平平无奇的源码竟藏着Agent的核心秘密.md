---
title: "平平无奇的源码竟藏着Agent的核心秘密"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/LEzv1rji5RZX889fkZQrqw"
author: ""
ingested_at: 2026-05-29
tags:
  - openclaw
  - agent
  - system-prompt
  - skill
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# 平平无奇的源码竟藏着Agent的核心秘密

## 一句话概括

以开源项目 OpenClaw 为例深度拆解 AI Agent 核心架构——Agent 由"三件套"组成：System Prompt、运行循环、Skill 机制，重点剖析 System Prompt 的分层组装方式和 Skill 的按需加载设计。

## 摘录

> Agent 由"三件套"组成：System Prompt（岗前培训手册）、运行循环（执行引擎）、Skill 机制（按需注入的专业知识扩展包）。重点剖析 System Prompt 的分层组装方式，以及 Skill 机制通过 XML 标签注入、Agent 自动扫描匹配并按需加载 SKILL.md 的精巧设计。

> Skill 机制通过 XML 标签注入、Agent 自动扫描匹配并按需加载 SKILL.md。这种设计让 Agent 的能力可以像插件一样热插拔，而不需要修改核心代码。

## 涉及实体

- [[OpenClaw]] —— 以 OpenClaw 为例拆解 Agent 核心架构
- [[OpenClaw-Skills]] —— Skill 机制的精巧设计

## 涉及主题

- [[Agent架构演进-主题]]
