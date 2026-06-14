---
title: "腾讯云开发者：兄弟！你真的懂 Skill 吗？"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/h9BKGfLgH7GCNEhvwDBYBg"
author: "腾讯云开发者"
published_at: "2026-03-17"
ingested_at: 2026-05-31
tags:
  - skills
  - openclaw
  - source-code-analysis
related_entities:
  - "[[OpenClaw-Skills]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
---

# 腾讯云开发者：兄弟！你真的懂 Skill 吗？

## 一句话概括

逐文件拆解 Anthropic 16 个官方 Skill 与约 2000 行框架源码，归纳 5 种执行模式，核心揭示 16 个 Skill 全部不用 function calling 注册而靠 SKILL.md + skill_run 沙箱命令驱动。

## 实践内容

### 5 种执行模式

1. **脚本执行** —— 直接运行 scripts/ 下的脚本
2. **纯 Prompt 注入** —— 只注入 SKILL.md 内容
3. **库调用** —— 调用外部库或 API
4. **参考文档编排** —— 编排 references/ 下的文档
5. **含子 Agent 编排** —— 启动子 Agent 执行复杂任务

### 核心发现

16 个 Skill 全部不用 function calling 注册，而是靠 SKILL.md + skill_run 沙箱命令驱动。这意味着：
- Skills 不是通过工具注册机制加载的
- Skills 通过文件系统和沙箱命令实现
- 这种设计更灵活，但也更依赖文件系统

### 7 步链路

Skill 从触发到执行的完整链路共 7 步。

### CQRS state_delta 解耦

使用 CQRS 模式解耦状态读写，通过 state_delta 增量更新状态。

### _stage_skill 增量哈希

通过增量哈希机制检测 Skill 是否需要重新加载。

### 本地 / Docker 双 runtime

支持本地执行和 Docker 沙箱两种运行时。

## 摘录

> 逐文件拆解 Anthropic 16 个官方 Skill 与约 2000 行框架源码，归纳 5 种执行模式（脚本执行、纯 Prompt 注入、库调用、参考文档编排、含子 Agent 编排）。

> 核心揭示 16 个 Skill 全部不用 function calling 注册，而靠 SKILL.md + skill_run 沙箱命令驱动；详解 7 步链路、CQRS state_delta 解耦、_stage_skill 增量哈希、符号链接与只读保护、本地 / Docker 双 runtime。

## 涉及实体

- [[OpenClaw-Skills]] —— Skills 的源码级实现解析

## 涉及主题

- [[AI-Skill体系-主题]]

## 我的评注

这篇文章的源码分析非常深入。"16 个 Skill 全部不用 function calling 注册"这个发现颠覆了很多人的认知——Skills 不是通过工具注册机制加载的，而是通过文件系统和沙箱命令实现的。这种设计更灵活，但也更依赖文件系统的正确性。
