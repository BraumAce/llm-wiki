---
title: "Agent skill 迭代式编写实战"
type: source
date: 2026-06-12
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/59Z2eVOg914_bpRD6-WsYg"
author: "大淘宝技术"
ingested_at: 2026-06-12
tags: [Agent-Skill, Skill编写, 最佳实践]
related_entities: [Agent-Skill, OpenClaw-Skills, Claude-Code]
related_topics: [Skill开发最佳实践, Agentic-Engineering-主题]
---

# Agent skill 迭代式编写实战

## 一句话概括

Agent Skill 编写经验总结，定义为模块化领域知识资产，核心设计遵循三层渐进式披露架构，用决策树替代模糊判断、确定性操作脚本化，建立内部自查与外部评估双重验证机制。

## 实践内容

### Skill 定义与形态

```
Agent Skill = 模块化能力包 = 给 AI 的"操作手册"
- 自然语言指令 + 元数据 + 可选资源（脚本、模板）
- MCP 提供"手"来操作工具，Skill 提供"操作手册"教怎么用
- 基于文件系统驱动，零依赖部署
- 以文件系统结构替代复杂运行时服务
```

### 三层渐进式加载架构

```
渐进式披露（Progressive Disclosure）是核心设计思想：
第一层：SKILL.md 主文件（入口，概述和关键指引）
第二层：references/（补充文档、详细规范、示例代码）
第三层：完整资源（包含详细步骤和工具脚本）

原则：不要把大量内容堆进主文件，通过路径按需引用
```

### 决策树替代模糊判断

```
决策树是正向约束，让 agent 在需要做判断时行为可控：
- 把"应该怎么判断"写清楚
- agent 不需要推理，顺着树走
- 比模糊描述的可执行性高很多
- skill-judge 把决策树列为高质量 skill 的明确标志

写 skill 时遇到分支判断，优先用树形结构，而不是让 agent 自行决策
```

### 执行后自查机制

```
自查机制解决：执行完了，产出物是否合格
- agent 的自然倾向是完成任务就结束，不会主动回头检验
- 很多规范性错误恰恰在"完成"之后才能发现
- 把自查写进 skill，强制插入一个反射节点
- 把"我觉得做完了"变成"我验证过做完了"
```

### 适用场景

```
Skill 适用场景：
- 半自动化场景
- 专家经验导向场景
- 需要可复用、可验证的知识资产
相比专用 Agent 框架，更轻量但确定性稍弱
```

## 摘录

> Agent Skill 是模块化的能力包，沉淀了领域知识的资产 bundle，资产包括自然语言指令、元数据和可选资源（脚本、模板），让 AI Agent 在需要时自动加载和使用。如果说 MCP 为 agent 提供了"手"来操作工具，那么 skill 就是"操作手册"，教 agent 怎么用这些工具。

> 决策树是正向约束，能让 agent 在需要做判断时行为可控。skill 的核心价值是封装专家才有的判断知识。决策树把"应该怎么判断"写清楚，而不是用模糊语言把判断压力甩给 agent。agent 不需要推理，顺着树走就行。

## 涉及实体

- Agent Skill —— 本文核心，模块化领域知识资产
- [[OpenClaw-Skills]] —— Skill 标准的实现之一
- [[Claude-Code]] —— 支持 Skill 的 AI Coding 工具
- [[MCP]] —— 提供工具操作能力的协议

## 涉及主题

- [[Skill开发最佳实践]]
- [[Agentic-Engineering-主题]]
