---
title: "从 Coder 到 Designer ：电商团队数据研发的 Harness Engineering 实践"
type: source
date: 2026-07-14
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/B1xFrqhjsoXbK0aWh79vGg"
author: "阿里技术"
ingested_at: 2026-07-14
tags:
  - harness-engineering
  - data-engineering
  - nl2sql
  - knowledge-engineering
  - multi-agent
related_entities:
  - "[[Harness-Engineering]]"
  - "[[知识库工程]]"
  - "[[NL2SQL]]"
  - "[[Agent-Skill]]"
  - "[[OpenClaw]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 从 Coder 到 Designer ：电商团队数据研发的 Harness Engineering 实践

## 一句话概括

阿里技术以电商数据研发为例，将 NL2SQL 的语义资产治理、文档状态机、多 Agent 协同、人工 Gate、执行证据校验与知识回写组合为一个可逐步演进的 Harness，说明数据研发 AI 化的前提是“AI 有据可依且稳定可控”。

## 实践内容

文章给出以下可直接复用的约束与目录约定：

```text
NL2DSL2SQL：自然语言 → 标准化指标-维度语义 → SQL

语义资产：标准名称 + 别名映射 + 语义边界
资产防腐：上线前拦截重复资产；上线后定期健康度评估与冗余清理

方法论文档链：SPEC → PLAN → SQL
经验回写：SPEC、PLAN、SQL、验证报告 → Archival Memory
           新指标定义 → 语义资产库
           踩坑 → anti-patterns.md

子 Agent Workspace：~/.openclaw/workspace/{project_name}/
项目命名：{domain}_{date}_{seq}
Skill/MCP 加载优先级：workspace/skills/ → workspace/mcp/ → 全局 fallback
强约束：禁止跨 workspace 加载；只按需开放技能和服务
```

文章的完成判据也值得作为 Harness 的默认底线：技能执行后要把 Agent 自述和真实系统状态比对；关键操作必须交付文件、数据或状态变更等可验证工件；调试、替换模型或更换业务类型后，工作流需要重新评测，不能仅以文本回复宣布任务完成。

## 摘录

> 问题的本质在于“数据研发的知识是碎片化的，流程是非标准化的”。每个数研同学脑中都有一套“怎么做”的经验，但这些经验难以被复用、被传承、被 AI 理解。基于这些认知，作者将数研工作范式升级拆为知识工程的构建和 Harness Engineering 的架构设计：前者把专家经验、业务规则、数据资产转成 LLM 可理解的结构化知识，后者以分离关注点、施加约束、管理上下文与熵值，让长程任务稳定、安全且可回溯地运行。

> 语义层是 NL2SQL 的核心基础设施，它解决从自然语言到精确数据语义的映射。文章不直接把自然语言转 SQL，而是先映射到标准化的指标—维度语义，再生成 SQL。为减少同义词和近义词带来的 RAG 召回偏差与出码错误，方案采用“先治理再录入”，由专家确认核心指标，并以标准名称、别名映射和语义边界规范资产；上线前拦截重复资产，上线后通过健康度评估和冗余清理防止资产持续劣化。

> 对稳定性，文章要求技能幻觉检测 Hook 在每次技能后核对 Agent 声称的结果与真实状态；所有关键操作必须产出可验证的文件、数据或状态变更，不能只依赖文字回复。空间上，每个子 Agent 使用独立 Workspace，禁止跨 workspace 加载；配置则通过 Git 备份、agents.md 同步和模板化恢复治理。心跳机制再从执行监控、模式识别到自动优化，把人类修正写回知识库与规则配置，形成“执行 → 评估 → 优化 → 再执行”的闭环。

## 涉及实体

- [[NL2SQL]] —— 用语义层把自然语言需求约束到可验证的数据语义和 SQL。
- [[知识库工程]] —— 将语义资产、SPEC/PLAN/SQL、验证报告和反模式组织成可检索、可演进的工程资产。
- [[Harness-Engineering]] —— 以职责分离、Gate、结果校验、隔离与配置治理处理 Agent 的不确定性。
- [[Agent-Skill]] —— 将标准流程与核心操作固化为按需加载的能力单元。
- [[OpenClaw]] —— 文中以 OpenClaw Workspace 说明子 Agent 的隔离与配置管理方式。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这篇实践最有价值的不是“用了 7 个 Agent”，而是把 NL2SQL 的正确性边界下沉到语义资产治理，再把 Agent 是否完成从自述迁移到独立工件和真实状态。文章中的具体实现和未来计划应视为该团队的案例，不应直接外推为通用效果指标；但“语义先治理、关键点留人、结果需验证、经验要回写”是可迁移的设计原则。
