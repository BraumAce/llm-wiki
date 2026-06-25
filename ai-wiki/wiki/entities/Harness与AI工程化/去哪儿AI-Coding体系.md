---
title: "去哪儿AI-Coding体系"
type: entity
date: 2026-06-26
also_known_as:
  - "Qunar AI Coding"
  - "QunarDevCenter"
  - "天弦"
  - "Qsuperpowers"
tags:
  - ai-coding
  - harness
  - engineering-management
  - metrics
  - skill-governance
sources:
  - "[[精华：去哪儿网AI-Coding研发平台实践，值得读三遍的样本]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[AI-Friendly架构]]"
  - "[[OpenClaw-Skills]]"
  - "[[Agentic-Engineering]]"
---

# 去哪儿AI-Coding体系

## 一句话定义

去哪儿AI-Coding体系是一套把 AI Coding 从个人工具推广为组织能力的研发平台方案，核心由 AI R&D Metrics、自动化分级、Harness 四把锁、QunarDevCenter、天弦、Qsuperpowers 和 Skills Gateway 治理闭环组成。

## 摘要

这套体系的价值在于它不把 AI Coding 简化成“AI 写了多少代码”，而是同时追问规模、成熟度、质量、可治理性和业务价值。文章转述去哪儿旅行基础架构负责人李佳奇的分享：先用 AI R&D Metrics = Volume × Maturity 度量数量与质量，再用 L0-L5 自动化分级建立共同语言，再用 Harness 定义触发机制、约束门禁、安全隔离和人工审查。QunarDevCenter 负责采集 Claude Code、Codex、Cursor、OpenCode 等 session 数据；天弦承担多 Agent、多 Skills、端到端编排；Qsuperpowers 面向复杂需求做结构化任务分解；Skills Gateway 则把团队私有经验沉淀为可审核、可分发、可观测的组织资产。

## 详情

### 起源与背景

大型研发组织引入 AI Coding 后，最大挑战不是让个别工程师变快，而是让几千人使用同一套工具和流程时仍可度量、可治理、可审计。去哪儿的实践从“全员 AI Coding”出发，强调先回答度量问题：出码率、出码量、团队覆盖率和需求覆盖率只是量，Coding 自动化水平与 Harness 等级才是质。没有质的出码率容易变成 KPI 竞赛，长期会转化为维护性、安全性和审查成本。

### 核心机制 / 工作原理

体系中最重要的分层是 L0-L5 自动化等级：L0 全手动，L1 代码补全，L2 模块生成，L3 有条件自动化，L4 高度自动化，L5 完全自动化。去哪儿把 2026 H1 目标设为 L3 自动化任务占比 30%+。与之配套的是 Harness 四把锁：AI 触发机制、约束与门禁、安全隔离环境、人工审查节点。QunarDevCenter 从本地扫描 Claude/Codex/OpenCode session，按 git remote 白名单过滤后上传元数据和 artifact；服务端拆分 session upload object、session meta info、AI generated code change 三类数据表，为出码率、token、时间和代码变更分析提供基础。

```text
AI 研发落地闭环：Tool -> Infra -> Automation -> Insight

AI 估时压缩率 = (原始估时 - AI 结合估时) / 原始估时
AI 估时兑现率 = (原始估时 - 实际工时) / (原始估时 - AI 结合估时)
AI 输出效率 = 周期内人均完成需求的原始估时总和 / 周期工作目数
```

### 应用 / 使用场景

- 管理层用双估时机制让 AI 效率进入计划阶段，而不是事后宣称省了多少人天。
- 基础研发团队用 Skills Gateway 审核、合并、分发和观测高价值 skills。
- 业务团队先在私有仓库验证 skill，再通过 PR 进入标准仓库，形成“创新在线、标准化在平台”的循环。
- 天弦把需求输入、Agent 编码、编译、部署、日志、测试、Diff 和报告串成 workflow。
- 黑客松用 150 人、1 天、3 个真实复杂需求压测平台、skills、团队协作和数据采集链路。

### 局限与争议

文章数据很亮眼：100% 研发团队覆盖、75%+ 全司出码率、L3 30%+、3000+ 自动化任务、90%+ 测试通过率。但这些数字依赖高度组织化的基础设施、统一入口、数据采集和治理流程；小团队直接照搬可能成本过高。另一个风险是 Goodhart：如果只追出码率或 L3 占比，可能促使团队把 AI 生成量当目标，而不是把质量、业务收益和风险规避作为目标。

## 与其他实体的关系

- [[Harness-Engineering]] —— 去哪儿实践把 Harness 从概念变成组织级流程控制能力。
- [[AI-Friendly架构]] —— QunarDevCenter、天弦和 Skills Gateway 都要求研发基础设施对 AI 可读、可接入、可观测。
- [[OpenClaw-Skills]] —— Skills 治理闭环与 OpenClaw Skills 一样强调能力单元化，但更偏企业级审核与分发。
- [[Agentic-Engineering]] —— 这套体系把单个 coding agent 扩展为多 Agent、多 Skills、平台编排和组织管理。

## 参考来源

- [[精华：去哪儿网AI-Coding研发平台实践，值得读三遍的样本]]
