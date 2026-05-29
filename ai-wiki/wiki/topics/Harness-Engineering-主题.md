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
  - "[[Harness-Engineering-2026年实践全景]]"
  - "[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]"
  - "[[ByteLighting-2026年5月技术阅读合集]]"
---

# Harness Engineering 主题

## 主题定义

Harness Engineering 涵盖 2026 年 AI 工程领域最重要的范式转移——从"怎么写好 prompt"到"怎么设计好整个工程框架"。它包括 Rules（规则约束）、Skills（能力封装）、Wiki（知识沉淀）、Changes（变更追踪）四大要素，以及 hooks、lint、CI 等工程化机制。不包括单纯的 Prompt Engineering 技巧或 Context 管理策略。

## 核心要点

1. **三次进化**：Prompt Engineering（该说什么）→ Context Engineering（模型该知道什么）→ Harness Engineering（怎样让系统稳定可靠）。每一层都是上一层的超集，不是替代关系
2. **返工根因不是模型不行**：爱奇艺团队的结论——"返工根因不是模型不会写代码，而是任务入口、执行依据、边界、验证、回写没提前备好"。Harness 的第一层价值是"防止 AI 犯错"
3. **知识才是护城河**：腾讯团队指出"Skill / Agent / 工具链会随模型迭代过期，私域知识才是护城河"。Harness 是手段不是目的，知识沉淀才是长期价值
4. **隐性知识显性化**：James C. Scott 的"可读性"理论——AI 正在引发人类第三次"显形运动"，将工程师脑中不可言说的隐性知识强制文本化。这改变了写文档的 ROI 经济学
5. **五类最小组件**：入口定义（AGENTS.md）、执行依据（Rules）、边界约束（安全红线）、验证机制（lint/CI）、回写规则（变更审查）。这五类组件构成最小可用 Harness
6. **AI 代码率可达 90%+**：阿里工程师在 10 万行 Java 存量应用中验证——Harness 体系可以把 AI 代码率从 24.86% 拉升到 90.54%
7. **Goodhart 定律的阴影**：当 Harness 的指标成为目标，AI 可能学会"满足检查"而非"做正确的事"。需要持续人工抽样校准

## 涉及实体

- [[Harness-Engineering]] —— 核心概念实体，定义了 Harness 的五类组件和三阶段落地法
- [[Spec-Driven-Development]] —— SDD 是 Harness 在需求阶段的具体实践，"DAY 0 不写代码先固化规格"
- [[OpenClaw]] —— OpenClaw 的设计哲学体现了 Harness 思维：CLAUDE.md 持久化、hooks 强制规范、Skills 封装知识
- [[OpenClaw-Skills]] —— Skills 是 Harness 的能力封装层，Agent 按需加载领域知识包

## 演进时间线

- 2025-Q4：AGENTS.md / CLAUDE.md 实践萌芽，"给 AI 看的 README"成为入口
- 2026-Q1：多团队（阿里、腾讯、得物、爱奇艺）独立验证 Harness 价值
- 2026-05：概念成熟——Prompt → Context → Harness 三次进化框架被广泛接受
- 2026-05：实践深化——从个人 Harness 到团队级 Harness（QQ 音乐 50+ 微服务治理）

## 对比矩阵

| 维度 | Prompt Engineering | Context Engineering | Harness Engineering |
|------|---|---|---|
| 关注点 | 说什么 | 知道什么 | 怎样可靠运行 |
| 典型产物 | prompt 模板 | context 注入策略 | .harness/ 目录 + hooks + CI |
| 谁受益 | 单次交互 | 单次会话 | 整个项目生命周期 |
| 可复用性 | 低（场景绑定） | 中（会话绑定） | 高（项目级持久） |
| 团队协作 | 弱 | 中 | 强（可审计、可治理） |

## 关键来源

- [[Harness-Engineering-2026年实践全景]] —— 8+ 篇文章的综合实践总结
- [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] —— 从三维度拆解 OpenClaw
- [[ByteLighting-2026年5月技术阅读合集]] —— 原始阅读合集
