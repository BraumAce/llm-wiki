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
  - "[[Spec-Driven-Development]]"
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
sources:
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

## 涉及实体

- [[Harness-Engineering]] —— 核心概念实体
- [[Spec-Driven-Development]] —— SDD 是 Harness 在需求阶段的实践
- [[OpenClaw]] —— OpenClaw 体现了 Harness 思维
- [[OpenClaw-Skills]] —— Skills 是 Harness 的能力封装层

## 对比矩阵

| 维度 | Prompt Engineering | Context Engineering | Harness Engineering |
|------|---|---|---|
| 关注点 | 说什么 | 知道什么 | 怎样可靠运行 |
| 典型产物 | prompt 模板 | context 注入策略 | .harness/ + hooks + CI |
| 可复用性 | 低 | 中 | 高 |
| 团队协作 | 弱 | 中 | 强 |

## 关键来源

- [[从Prompt-Context到Harness-工程的三次进化与终局之战]] —— 三次进化框架
- [[Harness-Engineering-耗时一周将AI-Coding率提升至90]] —— 阿里实践
- [[QQ音乐Harness-Engineering实践]] —— 团队级实践
