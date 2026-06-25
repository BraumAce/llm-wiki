---
title: "精华：去哪儿网AI Coding研发平台实践，值得读三遍的样本"
type: source
date: 2026-06-26
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/Ug_fMuGkQmM4tECUbpfXOg"
author: "无处不在的技术"
ingested_at: 2026-06-26
tags:
  - ai-coding
  - harness
  - metrics
  - skill-governance
  - engineering-management
related_entities:
  - "[[去哪儿AI-Coding体系]]"
  - "[[Harness-Engineering]]"
  - "[[AI-Friendly架构]]"
  - "[[OpenClaw-Skills]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
  - "[[AI-Skill体系-主题]]"
  - "[[Agentic-Engineering-主题]]"
---

# 精华：去哪儿网AI Coding研发平台实践，值得读三遍的样本

## 一句话概括

这篇文章拆解去哪儿 AI Coding 研发平台实践，核心不是工具试用，而是用度量、自动化分级、Harness、数据采集、天弦编排、Qsuperpowers 和 Skills Gateway 把 AI Coding 做成组织能力。

## 实践内容

### L0-L5 自动化分级

```text
L0 全手动：研发过程完全由人完成。
L1 代码补全与辅助：AI 补全变量、函数、样板代码或局部片段。
L2 部分自动生成：AI 生成函数、类、接口代码，人负责监控、调整、测试和组装。
L3 有条件自动化：人提供需求、API 规范、编码规范和示例；AI 生成可运行代码并进行功能测试，遇阻请求人工介入。
L4 高度自动化：AI 承担大部分编码、测试、集成和交付流水线工作。
L5 完全自动化：从需求理解、方案拆解、编码、测试到上线主要由 AI 完成。
```

### 指标与数据采集

```text
AI R&D Metrics = Volume × Maturity
量：出码率、出码量、团队覆盖率、需求覆盖率
质：Coding 自动化水平、Harness 等级

AI 估时压缩率 = (原始估时 - AI 结合估时) / 原始估时
AI 估时兑现率 = (原始估时 - 实际工时) / (原始估时 - AI 结合估时)
AI 输出效率 = 周期内人均完成需求的原始估时总和 / 周期工作目数
```

### Session 上报与表结构

```sql
-- session_upload_objects：上传内容 + 元数据
-- session_meta_info：会话级元信息
-- ai_gen_code_change：AI 代码变更记录
```

```text
Discovery：扫描 ~/.claude/projects/**/*.jsonl、~/.codex/sessions/**/*.jsonl、OpenCode SQLite。
Scan：mtime + size + cache 快速路径，解析 git remote/workspace，按 gitRemoteAllow 白名单过滤。
Upload：定时器轮询、rate limit、4xx/5xx 区分、SQLite upload_state 持久化。
```

## 摘录

> Harness = AI 研发过程控制能力。衡量 AI 在研发流程中是否被稳定触发、被约束、被隔离、被审查。不是只看 AI 是否参与，更关注 AI 参与方式是否可控、可复用、可审计、可规模化。目标：安全地提升自动化。在关键节点保留人工判断，避免 AI 直接无约束进入生产链路。

> Skills 不能再“野蛮生长”——必须经过私有验证 → PR 提交 → 基础研发团队审核 → 合并 → 统一分发 → 全流程观测的完整闭环；Skills Gateway 是 AI Coding 的“流量网关”——所有 skills 调用必须经过它，才能被统一治理、观测、分析；“种子上下文”是 Skills 智能化的关键——没有上下文的 skills 是“死”的。

## 涉及实体

- [[去哪儿AI-Coding体系]] —— 本文的组织级 AI Coding 平台方案。
- [[Harness-Engineering]] —— Harness 四把锁是全文主线之一。
- [[AI-Friendly架构]] —— QunarDevCenter、天弦和 Skills Gateway 都要求研发系统重写为 AI 可接入。
- [[OpenClaw-Skills]] —— Skills Gateway 与标准仓库治理对应 Skill 体系的组织化版本。

## 涉及主题

- [[Harness-Engineering-主题]]
- [[AI-Skill体系-主题]]
- [[Agentic-Engineering-主题]]

## 我的评注

这篇值得进入知识库的原因是它把 AI Coding 的“组织化”讲完整了：不是 Cursor/Claude Code/Codex 谁更好，而是全员使用后如何度量、治理、分级、采集、编排和复盘。尤其是双估时机制，让 AI 价值进入计划阶段，这是很多团队还没跨过去的门槛。
