---
title: "Loop Engineering 实战：实现从日志扫描到预发部署的全自主闭环"
type: source
date: 2026-07-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/AQLsjzD0s9d8kGUGdul0sg"
author: "也达（阿里云开发者）"
published_at: "2026-07-07"
ingested_at: 2026-07-10
tags:
  - loop-engineering
  - observability
  - automation
  - verification
  - worktree
related_entities:
  - "[[Loop-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Generator-Evaluator]]"
  - "[[AI可观测性]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# Loop Engineering 实战：实现从日志扫描到预发部署的全自主闭环

## 一句话概括

阿里云开发者给出一个生产维护 Loop：通过连接器从 3 个日志库发现问题，诊断、修复、334 条测试、预发、Trace 验证和通知审批全部串联，借由独立验证、外置状态和重试上限把 [[Loop-Engineering]] 从“自动跑”变成可停止、可复用的闭环。

## 实践内容

### Loop 的动作、组件与建造门槛

```text
五动作：发现 → 交付 → 验证 → 持久化 → 调度
六组件：Connectors / Automations / Skills / Worktrees / Sub Agents / State

动作映射：
- 发现：Connectors + Automations
- 交付：Skills + Worktrees
- 验证：独立 Sub Agents
- 持久化：State（仓库、知识库、状态文件）
- 调度：Automations

建 Loop 的四格检验：重复发生、可自动验证、token 预算可承受、工具齐备。
```

### 日志到预发的受控回环

```text
3 Logstore → 8 phase 诊断（含 git log 交叉验证）
→ 6 步修复 Skill → 334 条测试 → 预发部署
→ 集成测试 + Trace 验证 + 独立复查 → 钉钉审批

验证失败：分析原因 → 调整补丁 → 重跑，最多 3 轮
第 3 轮仍失败：停止循环，推送 Owner 工单
```

## 摘录

> 作者将 Prompt、Context、Harness、Loop 视为逐层叠加的四代工程化范式：Prompt 让模型完成一次回答，Context 补充材料，Harness 赋予工具和单次任务完成条件，Loop 则把巡检规则、修复手册、验证标准和自动调度接起来。Loop 的关键不在“让 Agent 再多跑几轮”，而在能否自动发现该做的事、独立判断结果、将经验存到会话之外并持续启动下一轮。

> 完整闭环由发现、交付、验证、持久化、调度五个动作构成。缺少验证，生成器只是在更快地烧 token；缺少调度，前面的工作只是一次性的人工操作。文章将五个动作落实到 Connectors、Automations、Skills、Worktrees、Sub Agents、State 六个组件，并要求按连接器、自动化、Skill、工作树、子 Agent、状态的依赖顺序建设，避免后续能力悬空。

> 生产案例里，日志诊断覆盖三个 Logstore，修复由自动补丁和 334 条测试把关，发布自动到预发后还需集成测试、Trace 验证与独立复查。修复 Agent 不能给自己打分；验证失败可进入下一轮，但最多三轮，第三轮仍无法通过就停止并通知 Owner。这些限制使“自主”不等同于无限重试，也给 token 和风险边界明确上限。

## 涉及实体

- [[Loop-Engineering]] —— 本文给出了从巡检到预发的五动作、六组件映射。
- [[Harness-Engineering]] —— 单次任务武装层被 Loop 的调度和持久化能力扩展。
- [[Generator-Evaluator]] —— 修复与独立验证分离，防止生成者自证完成。
- [[AI可观测性]] —— 日志、Trace 与发布验证构成持续维护的外部证据面。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

该案例把“Loop 比 Harness 多什么”说得很具体：不是再加一个定时器，而是把自动发现、独立验证、状态沉淀和中止机制一起做出来。尤其值得保留的是四格检验与三轮上限，它们为“是否值得自动化、何时必须退出”给出了工程化答案。
