---
title: "Harness Engineering 2026年实践全景"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://blog.bytelighting.cn/program/reading/2026/2026.5.html"
author: "多作者综合"
ingested_at: 2026-05-29
tags:
  - harness-engineering
  - ai-engineering
  - practice
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[OpenClaw]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# Harness Engineering 2026年实践全景

## 一句话概括

2026 年 5 月 ByteLighting 技术阅读合集中，8+ 篇文章从不同团队（阿里、腾讯、得物、爱奇艺、QQ 音乐、高德）的实践出发，共同验证了 Harness Engineering 作为 AI 工程第三次范式进化的地位。

## 实践内容

### 最小 Harness 五类组件（爱奇艺）

爱奇艺数据库团队定义的最小 harness 由五类组件组成：

```
1. 入口定义 — AGENTS.md / CLAUDE.md
2. 执行依据 — 代码规范、架构约束
3. 边界约束 — 禁止操作、安全红线
4. 验证机制 — lint / 自动测试 / 数据比对
5. 回写规则 — 变更如何落盘、谁来审查
```

落地三阶段：
```
阶段一：找到入口 — 梳理 AI 需要知道什么
阶段二：可复盘 — 记录每次 AI 交互的输入/输出/决策
阶段三：机械化 — 沉淀为 lint 脚本、CI 检查、自动化工作流
```

### .harness/ 目录结构（阿里）

阿里工程师在 10 万行 Java 存量应用中搭建的 Harness 体系：

```
.harness/
├── rules/           # 代码规范、架构约束
├── skills/          # 领域知识包（按服务/模块组织）
├── wiki/            # 项目知识库（架构决策、历史背景）
└── changes/         # 变更历史与决策记录
```

由 Application Owner Agent 编排 10 阶段流程，AI 代码率从 24.86% → 90.54%。

### QQ 音乐五阶段流程 + 四道门禁

```
五阶段流程：
1. 需求理解 — AI 解析需求文档
2. 方案设计 — AI 生成技术方案
3. 代码实现 — AI 按方案生成代码
4. 自审自测 — AI 自我审查 + 自动测试
5. 人工复核 — 人类最终确认

四道门禁：
1. 代码规范检查（lint）
2. 架构约束检查（自定义规则）
3. 安全扫描（敏感信息、危险操作）
4. 业务逻辑验证（测试用例）
```

### 得物数仓 Harness 方案

```
痛点：compact 后约束丢失、规范靠记忆、血缘/自测/数据比对撑爆 context
解法：
- CLAUDE.md 持久化迭代状态
- hooks 强制 SQL 规范与危险 DDL 检查
- subagents 隔离高 token 读操作
- 需求分析等收敛成 8 步 SKILL 工作流
```

### Harness + SDD 组合（高德）

```
出码率 53% → 90% 但项目周期没缩短
根因：研发全链路、存量风险、超长上下文
解法：SDD + Harness 四支柱
1. 上下文管理 — 分层注入、动态裁剪
2. 架构约束 — 硬性边界、不可违反的规则
3. 反馈回路 — 自动验证、持续改进
4. 人类监督 — 关键决策点的人工确认
```

## 摘录

> 返工根因不是模型不会写代码，而是任务入口、执行依据、边界、验证、回写没提前备好。Harness Engineering 的本质是：在 AI 动手之前，把所有确定性的工程约束提前备好，让 AI 只做理解和决策。（爱奇艺团队）

> Skill / Agent / 工具链会随模型迭代过期，私域知识才是护城河。Harness 是手段不是目的——知识体系按三维正交组织，上下文用三级渐进式索引替代一次性塞 5000-10000 行。（腾讯团队）

## 涉及实体

- [[Harness-Engineering]] —— 本文是 Harness Engineering 的实践全景综述
- [[Spec-Driven-Development]] —— SDD 是 Harness 在需求阶段的具体实践
- [[OpenClaw]] —— OpenClaw 的设计哲学体现了 Harness 思维

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这些来自不同团队的实践有一个共同模式：**先做减法（让 AI 少做错事），再做加法（让 AI 做更多事）**。Harness 的第一层价值是"防止 AI 犯错"，第二层价值是"让 AI 的产出可审计、可复用"。腾讯团队的反思很有洞察力——Harness 本身不是护城河，知识才是。这和 LLM Wiki 的"知识编译"理念异曲同工。
