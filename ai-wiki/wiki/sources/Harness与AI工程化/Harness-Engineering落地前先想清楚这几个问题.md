---
title: "Harness Engineering落地前，先想清楚这几个问题"
type: source
date: 2026-06-12
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/W7U9rs1xP2uRu7Ma-Z_diA"
author: "腾讯云开发者"
ingested_at: 2026-06-12
tags: [Harness-Engineering, AI-Coding, 前端架构, 流式渲染]
related_entities: [Harness-Engineering, Claude-Code, CodeBuddy, Cursor]
related_topics: [Harness-Engineering-主题, AI-Native软件工程]
---

# Harness Engineering落地前，先想清楚这几个问题

## 一句话概括

从数据中台 AI 助手 Dola 的实践出发，讨论两个问题：AI 产品形态变化后前端架构如何适配（流式渲染、图表推荐），以及存量项目如何用 Harness Engineering 思路改造以服务 AI Coding。

## 实践内容

### 流式渲染架构改造

```
问题：传统代码高亮库的 DOM 模型与 AI 对话的流式、多块、长会话场景架构错配
解决方案：
- 放弃给现有库打增量补丁
- 重新设计流式 chunk 到 DOM 的映射
- 着色与 DOM 解耦
```

### 图表推荐的工程化策略

```
策略：工程化推荐 + 大模型微调
1. 前端基于已有上下文快速给出推荐配置
2. 用户立刻就能看到一张相对合理的图
3. 不满意再让 AI 介入修改
优势：工程化的速度和稳定性 + AI 的灵活性
```

### 存量项目适配 AI Coding

```
核心思路：把项目改造成 AI 容易写对的样子
1. 规则机器可读：配置、约束用结构化格式而非注释
2. 入口足够收敛：减少 AI 需要理解的入口点
3. 决策足够显式：隐式规则变成显式检查
效果：AI 输出方差大幅下降，评审成本降低
```

### AI Coding 协作中的编码范式变化

```
发现：多年习以为常的"优雅写法"在 AI Coding 协作中反而成了拖累
原因：AI 需要的是明确、可预测的模式，而非需要上下文理解的"巧妙"设计
```

## 摘录

> 当我们开始大量用 CodeBuddy、Cursor 来协作开发时，发现多年来习以为常的"优雅写法"，在 AI Coding 协作中反而成了拖累。这两类问题逼着我重新思考前端在 AI 时代的定位。

> 存量项目适配 AI Coding 的核心，不是加一个插件，也不是写几句 prompt，而是把项目改造成 AI 容易写对的样子。规则机器可读、入口足够收敛、决策足够显式——AI 的输出方差就会大幅下降，评审成本随之降低，团队对 AI Coding 的信任才能真正建立起来。

## 涉及实体

- [[Harness-Engineering]] —— 用 harness 思路改造存量项目
- [[CodeBuddy]] —— 腾讯 AI Coding 工具
- [[Cursor]] —— AI Coding IDE
- [[Claude-Code]] —— AI Coding 工具

## 涉及主题

- [[Harness-Engineering-主题]]
- [[AI-Native软件工程]]
