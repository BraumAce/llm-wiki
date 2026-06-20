---
title: "Harness Engineering 主题"
type: topic
date: 2026-05-29
tags:
  - harness-engineering
  - ai-engineering
  - methodology
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Loop-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
  - "[[OpenHarness]]"
  - "[[Headroom]]"
sources:
  - "[[Loop-Engineering循环工程橙皮书]]"
  - "[[从Prompt-Context到Harness-工程的三次进化与终局之战]]"
  - "[[Harness-Engineering-耗时一周将AI-Coding率提升至90]]"
  - "[[Claude-Code-Harness工程-数仓侧落地方案-得物技术]]"
  - "[[告别氛围编程-基于Harness治理和SDD的团队级AI研发范式]]"
  - "[[QQ音乐Harness-Engineering实践]]"
  - "[[别让AI瞎猜了-用Harness-Engineering终结无限返工]]"
  - "[[Harness不是目的-知识才是护城河]]"
  - "[[Harness的尽头不是缰绳是镜子]]"
  - "[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]"
  - "[[Harness-Engineering-来龙去脉]]"
  - "[[Harness-Engineering-来了-SDD-还有意义吗]]"
  - "[[Claude-Code-最佳实践-可验证可治理可分层的工程现实]]"
  - "[[Claude-Code-加-OpenSpec-正在加速-AICoding-落地]]"
  - "[[AI-Coding思考-从工具提效到范式变革]]"
  - "[[规范驱动AI编程实战指南-OpenSpec-vs-Spec-Kit-vs-BMAD]]"
  - "[[TRAE-2026企业级AI编程实践手册]]"
  - "[[实战报告-AI-Coding已经能做交付了但前提苛刻]]"
  - "[[如何让你的Agent更准确-MCP工具设计技巧]]"
  - "[[你不知道的-Claude-Code-架构治理与工程实践]]"
  - "[[Harness-Engineering-长程自动化AI-Coding-Skills开发实践]]"
  - "[[4000行代码撑起一个Agent框架-nanobot架构深度解析]]"
  - "[[AI-时代如何超过大多数人]]"
  - "[[更可靠的主播助理：淘宝主播Agent的Harness工程实战]]"
  - "[[一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制]]"
  - "[[面向Skills编程-淘宝企业购端对端研发提效实践]]"
  - "[[Loop Engineering 概念解析、思考与实践]]"
  - "[[AI编程实践第18节：使用Headroom代理，帮我省下Token的隐形管家]]"
---

# Harness Engineering 主题

## 主题定义

Harness Engineering 涵盖 2026 年 AI 工程领域最重要的范式转移——从"怎么写好 prompt"到"怎么设计好整个工程框架"。包括 Rules（规则约束）、Skills（能力封装）、Wiki（知识沉淀）、Changes（变更追踪）四大要素，以及 hooks、lint、CI 等工程化机制。

## 核心要点

1. **三次进化**：Prompt Engineering（该说什么）→ Context Engineering（模型该知道什么）→ Harness Engineering（怎样让系统稳定可靠）。每一层都是上一层的超集
2. **返工根因不是模型不行**：爱奇艺团队——"返工根因不是模型不会写代码，而是任务入口、执行依据、边界、验证、回写没提前备好"
3. **知识才是护城河**：腾讯团队——"Skill / Agent / 工具链会随模型迭代过期，私域知识才是护城河"
4. **隐性知识显性化**：James C. Scott 的"可读性"理论——AI 正在引发人类第三次"显形运动"
5. **五类最小组件**：入口定义、执行依据、边界约束、验证机制、回写规则
6. **AI 代码率可达 90%+**：阿里工程师在 10 万行 Java 存量应用中验证
7. **Goodhart 定律的阴影**：当指标成为目标，AI 可能学会"满足检查"而非"做正确的事"
8. **再上一层是 Loop Engineering**：harness 武装单次运行，[[Loop-Engineering]]（循环工程）让它在定时器上一遍遍自己跑、自己孵化子 agent、自我喂食——栈从"一次跑"延伸到"自己跑下去"

9. **个人层面的 Harness 是材料、标准、验证和流程沉淀**：AI 时代超过大多数人不是靠 prompt 模板，而是靠问题定义、上下文质量、验证能力、工作流沉淀和判断标准。这个个人工作法和团队 Harness 的底层逻辑一致：少让模型猜，多给事实、边界和可验收标准。

10. **生产业务 Agent 把 Harness 变成安全边界**：淘宝主播 Agent 的直播间场景要求操作即时生效、错误不可撤回、主播无法逐条核验，因此上下文、状态、Hook、幂等、安全审批、评测和记忆对账都必须由框架层兜住。

11. **Skill 与 Token 经济学决定 Harness 厚度**：Skill 可以封装流程和领域知识，但加载后会进入历史上下文；MCP Schema、工具结果、Memory/Rules 抖动都会影响缓存命中。生产 Harness 需要同时治理质量与成本。

12. **上下文治理可以外置成运行时中间层**：[[Headroom]] 这类工具把压缩、可逆检索、预算、审计和跨会话记忆放在 Agent 与模型 API 之间，说明 Harness 不只存在于仓库规则和工作流里，也可以成为流量侧的成本与上下文控制面。

## 涉及实体

- [[Harness-Engineering]] —— 核心概念实体
- [[Loop-Engineering]] —— 四层栈最上层，坐在 harness 的"上一层楼"
- [[Spec-Driven-Development]] —— SDD 是 Harness 在需求阶段的实践
- [[OpenClaw]] —— OpenClaw 体现了 Harness 思维
- [[OpenClaw-Skills]] —— Skills 是 Harness 的能力封装层
- [[AI可观测性]] —— Harness 的评测与 trace 观测能力
- [[Headroom]] —— Agent 上下文压缩与成本治理中间层

## 对比矩阵

| 维度 | Prompt Engineering | Context Engineering | Harness Engineering | Loop Engineering |
|------|---|---|---|---|
| 关注点 | 说什么 | 知道什么 | 怎样可靠运行 | 怎样自己一遍遍跑 |
| 典型产物 | prompt 模板 | context 注入策略 | .harness/ + hooks + CI | automation + worktree + evaluator + memory |
| 可复用性 | 低 | 中 | 高 | 高 |
| 团队协作 | 弱 | 中 | 强 | 强（一个人干一个团队的活） |
| 管的范围 | 一句话 | 一个窗口 | 一次运行 | 让它自己跑下去 |

## 关键来源

- [[从Prompt-Context到Harness-工程的三次进化与终局之战]] —— 三次进化框架
- [[Harness-Engineering-耗时一周将AI-Coding率提升至90]] —— 阿里实践
- [[QQ音乐Harness-Engineering实践]] —— 团队级实践
- [[AI-时代如何超过大多数人]] —— 个人层面的上下文、验证和工作流沉淀方法
- [[更可靠的主播助理：淘宝主播Agent的Harness工程实战]] —— 高风险直播业务 Agent 的 Harness 实战
- [[面向Skills编程-淘宝企业购端对端研发提效实践]] —— Skill 流水线与端到端生码平台
- [[Loop Engineering 概念解析、思考与实践]] —— Loop 作为 Harness 之上的自动化验收闭环
- [[AI编程实践第18节：使用Headroom代理，帮我省下Token的隐形管家]] —— Headroom 作为流量侧上下文治理和成本控制面的实践
