---
title: "后端架构 AI Friendly 的标准与路径：面向无人值守开发时代的系统重构"
type: source
date: 2026-06-15
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/XpSpAiWY-nXjw8d8QPbabg"
author: "刘瑞洲（阿里技术）"
ingested_at: 2026-06-15
tags:
  - ai-friendly
  - backend-architecture
  - unattended-development
  - harness
related_entities:
  - "[[AI-Friendly架构]]"
  - "[[AI-Friendly-API]]"
  - "[[AI可观测性]]"
  - "[[Harness-Engineering]]"
  - "[[AI-Native软件工程]]"
  - "[[Spec-Driven-Development]]"
  - "[[Loop-Engineering]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 后端架构 AI Friendly 的标准与路径：面向无人值守开发时代的系统重构

## 一句话概括

阿里技术刘瑞洲从**后端分布式系统、面向 7×24 无人值守开发**的角度，系统给出 14 节的 AI Friendly 标准与落地路线：把藏在人脑/群聊/口头约定/历史事故里的系统知识，显式化、结构化、可检索化、可执行化、可验证化——从「可维护系统」转向「可被智能体维护的系统」。

## 实践内容

**六类机器可读「事实」底座：** 架构事实（全局地图）、服务事实、领域事实、接口事实、数据事实、运行事实。其中架构事实提供全局地图、服务事实提供节点身份、领域事实提供业务语义、接口事实提供协作契约、数据事实提供状态基础、运行事实提供真实反馈。

**Service Card（服务身份证）必备字段：** 服务定位 / 核心职责（3-7 条，过多说明边界腐化）/ 核心实体 / 数据所有权（哪些表只读、哪些禁止跨服务访问）/ 接口清单（调用方、稳定性等级、是否允许新增字段）/ 消息清单（topic、幂等 key、重试、死信）/ 依赖清单（强依赖 vs 可降级）/ 运行特征（QPS/延迟/告警）/ 变更约束 / 测试入口 / 发布与回滚。放服务仓库根目录、由 CI 校验、部分自动生成（接口从 IDL/OpenAPI、依赖从调用链、表结构从 schema）。

**Harness 七层执行轨道：** 上下文装载层 → 工具层（权限边界，生产库默认只读、敏感表脱敏、危险命令禁止）→ 计划层（改前输出计划）→ 执行层（独立分支/worktree/sandbox）→ 验证层（单测/集成/契约/静态/安全/schema）→ 审计层 → 回滚层。

**Test-Gated 七类测试：** 单元测试、契约测试、集成测试、回归用例库、数据迁移测试、性能测试、**架构级测试**（验证服务依赖是否违反分层、非 owner 是否直连他服务库、核心链路是否新增未备案强依赖、消息 schema 兼容性、migration 锁表风险）。

**分级权限模型 L0–L5：**

```
L0：只读代码和文档（问答、解释、影响面分析）
L1：本地 sandbox 改代码 + 跑测试，不能访问真实数据
L2：查询脱敏日志、测试环境数据库、监控指标
L3：创建 PR、触发 CI、生成灰度配置，但不能直接发布
L4：低风险服务自动合并和发布（须满足测试/灰度/回滚条件）
L5：执行生产修复（回滚/降级/扩容/切配置），须强审计 + 强策略 + 人类预授权
```

**Architecture as Code（让架构进 CI/CD）：**

```
architecture.yaml   # 业务域、服务分层、允许的依赖方向
ownership.yaml      # 每张表/每个 topic/每个 API 的 owner
critical-path.yaml  # 核心链路和延迟预算
risk-policy.yaml    # 不同风险等级下 AI 可自动执行到哪一步
```

**Docs as Code CI 硬门槛示例：** 新增 controller 未更新接口文档、新增 migration 未写字段说明、新增 consumer 未写 topic 文档 → 阻止合并。

**14 节框架：** 01 架构事实清晰 / 02 Architecture Map / 03 System Card / 04 Domain Clarity（不变量+状态机+幂等+风险等级+跨域链路模型）/ 05 Skill-Based / 06 Harness Augmentation / 07 Test-Gated / 08 AI-Observable / 09 Tiered Access Control / 10 Code Navigation Framework / 11 Docs & Architecture as Code / 12 Copilot→Coworker→Operator / 13 Practical Roadmap（11 步）/ 14 Future。

**落地 Roadmap（节选）：** ① 选中等复杂度、可灰度可回滚的试点服务（不选玩具、不选支付/资金）② 建最小可用全局 Architecture Map（可粗但必须真实，可不完整但不能误导）③ 补 Service Card ④ 梳理领域模型（实体/状态机/不变量/幂等）⑤ 沉淀 5-10 个高频 SKILL ⑥ 补测试和契约 ⑦ 建 AI PR 模板 ⑧ CI 变硬门槛 ⑨ 接只读可观测 ⑩ 允许低风险自动 PR（先不自动合并）⑪ 逐渐扩大。

## 摘录

> 真正的 AI Friendly，应该是让一个 AI Agent 能够在有限上下文、有限权限、有限试错成本的前提下，正确理解系统、定位边界、拆解任务、修改代码、验证结果、评估风险、生成变更说明，并在自动化规则约束下安全地推进系统演进。换句话说，过去我们建设的是「可维护系统」，未来要建设的是「可被智能体维护的系统」。

> AI 对字段语义的猜测，是未来自动化开发中最危险的风险点之一……尤其在大规模系统中，字段名经常不足以表达真实含义。比如 status=3 到底是"已支付""已取消"还是"处理中"，必须有枚举说明。代码告诉 AI"现在怎么做"，领域模型告诉 AI"为什么必须这么做"。

> 所谓 7×24 小时无人化值守开发，并不是一步到位让 AI 接管生产，而是逐步扩大 AI 的可信半径。先让它在低风险、强验证的区域自动化，再逐步进入复杂系统和生产运维。这条路线的关键是：不要先追求"无人化"，而要先追求"可验证"。无人化不是目标本身，可验证的自动化才是目标。

## 涉及实体

- [[AI-Friendly架构]] —— 本文是其「后端分布式/无人值守」视角的重要补充来源
- [[AI-Friendly-API]] —— 对应「接口事实」：幂等/重试/兼容/字段废弃/端版本兼容
- [[AI可观测性]] —— 对应 §08 AI-Observable Architecture（日志结构化、Trace 关联业务实体、告警带 Runbook）
- [[Harness-Engineering]] —— §06 Harness Augmentation 七层执行轨道 + Architecture Policy 执行器
- [[AI-Native软件工程]] —— 软件组织方式从「人的经验」转向「结构化资产」
- [[Spec-Driven-Development]] —— SKILL 化与可执行规范的思路相通
- [[Loop-Engineering]] —— Operator 阶段的「黑灯工厂」即无人值守循环

## 涉及主题

- [[Harness-Engineering-主题]] —— AI 工程化/Harness 范式

## 我的评注

与现有 [[AI-Friendly架构]]（大淘宝技术、前端应用 Agent 视角）正好互补：本文聚焦后端分布式系统，把 AI Friendly 拆成「六类事实 + Architecture Map/Service Card + Harness/测试/可观测/权限分级 + Architecture as Code」的可执行清单，并给出 Copilot→Coworker→Operator 的成熟度阶梯。最值得吸收的判断是「先可验证、再无人化」——与 [[Loop-Engineering]] 里"循环的难点是放一个能说不的东西"是同一条主线。
