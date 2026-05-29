---
title: "Harness Engineering"
type: entity
date: 2026-05-29
also_known_as:
  - "Harness 工程"
  - "AI Harness"
  - "驾驭工程"
tags:
  - ai-engineering
  - methodology
  - harness
  - context-engineering
  - prompt-engineering
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
related_entities:
  - "[[OpenClaw]]"
  - "[[Spec-Driven-Development]]"
  - "[[OpenClaw-Skills]]"
---

# Harness Engineering

## 一句话定义

Harness Engineering 是继 Prompt Engineering、Context Engineering 之后的第三次 AI 工程范式进化——通过设计完整的约束、验证、反馈和治理框架，让 AI 系统在生产环境中稳定、可靠、可审计地运行。

## 摘要

Harness Engineering 的核心洞察是：AI 模型的能力已经不是瓶颈，真正的瓶颈在于"怎样让系统稳定可靠"。Prompt Engineering 回答"该说什么"，Context Engineering 回答"模型该知道什么"，Harness Engineering 回答"怎样让模型在工程约束下可靠地做正确的事"。2026 年上半年，从阿里、腾讯、得物、爱奇艺、QQ 音乐等多个团队的实践中可以看到一致共识：**返工根因不是模型不会写代码，而是任务入口、执行依据、边界、验证、回写没提前备好**。

Harness 一词取自"马具/驾驭"的隐喻——不是限制 AI 的缰绳，而是让 AI 可控运转的工程骨架。它包含 Rules（规则约束）、Skills（能力封装）、Wiki（知识沉淀）、Changes（变更追踪）四大要素，通过 hooks、lint、CI 等机制把 AI 的输出纳入可审计的工程流程。

## 详情

### 起源与背景

Harness Engineering 的思想萌芽可以追溯到 2025 年底。当时业界发现：AI Coding 的出码率从 53% 涨到 90%，但项目周期并没有相应缩短。根因分析指向三个问题：研发全链路覆盖不足、存量代码风险未管控、超长上下文导致模型失焦。

2026 年初，随着 Claude Code、Cursor 等 AI IDE 的普及，AGENTS.md / CLAUDE.md 等"给 AI 看的 README"成为实践入口。工程师们逐渐意识到，与其不断优化 prompt，不如设计一个完整的工程框架——把确定性的工作交给脚本和 lint，让 AI 只做理解和决策。

James C. Scott 的"可读性"理论为其提供了学术框架：AI 正在引发人类第三次"显形运动"，将工程师脑中不可言说的隐性知识强制文本化。从意图层、执行层、判断层三个维度，AI 改变了写文档的 ROI 经济学。

### 核心机制 / 工作原理

Harness Engineering 的核心是五类组件的协同：

1. **入口定义（Entry Point）**：明确 AI 拿到什么输入、上下文中包含什么。典型载体是 AGENTS.md / CLAUDE.md / .harness/ 目录
2. **执行依据（Execution Basis）**：Rules 层——代码规范、架构约束、命名约定等，通过 hooks 在每次工具调用前注入
3. **能力封装（Capability Packaging）**：Skills 层——把领域知识打包成可热插拔的 Skill，Agent 按需加载
4. **验证闭环（Verification Loop）**：lint / 自动测试 / 数据比对 / 四道门禁，确保输出符合预期
5. **知识沉淀（Knowledge Retention）**：Wiki 层——把项目私域知识持久化，不依赖 context window

落地分三阶段：
- **阶段一：找到入口**——梳理 AI 需要知道什么，写入 AGENTS.md
- **阶段二：可复盘**——记录每次 AI 交互的输入/输出/决策依据
- **阶段三：机械化**——把规则沉淀为 lint 脚本、CI 检查、自动化工作流

```
典型 .harness/ 目录结构
├── rules/           # 代码规范、架构约束
├── skills/          # 领域知识包
├── wiki/            # 项目知识库
├── changes/         # 变更历史与决策记录
└── AGENTS.md        # 入口文件
```

### 应用 / 使用场景

- **存量应用改造**：阿里工程师在 10 万行 Java 应用中搭建 Harness，AI 代码率从 24.86% 提升到 90.54%
- **数仓治理**：得物离线数仓用 CLAUDE.md + hooks + subagents 解决 compact 后约束丢失问题
- **团队协作**：QQ 音乐在 50+ 微服务拓扑中用服务矩阵 + 五阶段流程 + 四道门禁实现可审计的 AI 协作
- **消除返工**：爱奇艺数据库团队用最小 harness（五类组件）终结"AI 瞎猜"式的无限返工
- **全栈开发**：得物团队用 Harness + SDD + 多仓模式实现前后端并行开发，提效 50%+

### 局限与争议

- **过度工程化风险**：Harness 过厚会降低开发速度，"合适厚度"需要团队自己摸索
- **知识才是护城河**：腾讯团队指出"Skill / Agent / 工具链会随模型迭代过期，私域知识才是护城河"——Harness 是手段不是目的
- **Goodhart 定律**：当 Harness 的指标成为目标，它就不再是好的指标。AI 可能学会"满足 harness 检查"而非"做正确的事"
- **团队采纳门槛**：需要团队共识和持续维护，个人项目收益有限

## 与其他实体的关系

- [[OpenClaw]] —— OpenClaw 的设计哲学本身就体现了 Harness 思维：CLAUDE.md 持久化状态、hooks 强制规范、Skills 封装领域知识
- [[Spec-Driven-Development]] —— SDD 是 Harness 在需求阶段的具体实践，两者经常组合使用
- [[OpenClaw-Skills]] —— Skills 是 Harness 的能力封装层，Agent 按需加载领域知识包

## 参考来源

- [[从Prompt-Context到Harness-工程的三次进化与终局之战]] —— 腾讯云开发者，三次进化框架
- [[Harness-Engineering-耗时一周将AI-Coding率提升至90]] —— 阿里工程师，10万行Java存量应用实践
- [[Claude-Code-Harness工程-数仓侧落地方案-得物技术]] —— 得物技术，数仓侧落地方案
- [[QQ音乐Harness-Engineering实践]] —— QQ音乐，50+微服务团队实践
- [[别让AI瞎猜了-用Harness-Engineering终结无限返工]] —— 爱奇艺，最小harness五类组件
- [[Harness不是目的-知识才是护城河]] —— 腾讯团队，知识沉淀实践
- [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] —— OpenClaw 的 Harness 设计
