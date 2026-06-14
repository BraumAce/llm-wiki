---
title: "以 OpenClaw 为例介绍 AI Agent 的运作原理"
type: source
date: 2026-05-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/78mBt_5efHrTD7tChBRcTw"
author: "Java一条人 / 红薯的Java私房菜"
published_at: "2026-03-17"
ingested_at: 2026-05-10
tags:
  - openclaw
  - ai-agent
  - tutorial
related_entities:
  - "[[OpenClaw]]"
related_topics: []
---

# 以 OpenClaw 为例介绍 AI Agent 的运作原理

## 一句话概括

"红薯的 Java 私房菜"撰写的 [[OpenClaw]] 入门教程，从"AI Agent 是什么"讲起，依次介绍对话过程、多轮对话、操控电脑机制、安全攻防、龙虾的工具/Sub-agent/技能/记忆，最后讲心跳/Cron Job/Context Compression 三大特性。是面向 Java 背景开发者的 OpenClaw 概念入门读物。

## 实践内容

### 文章涵盖的关键机制清单

- **对话过程**：单轮 + 多轮 vs 单次请求模型
- **AI Agent 怎么用你的电脑**：通过 Skills + 系统调用
- **安全模型**：攻击过程（恶意 prompt / 钓鱼 / 越权）+ 防御方法（沙箱 + 权限分层）
- **龙虾的工具**：内置工具集合（exec/read/write/edit/browser 等）
- **Sub-agent**：派出子 Agent 并行执行 + 上下文隔离
- **龙虾的技能**：Skills 是 SKILL.md 知识包
- **龙虾的记忆**：保存（Memory Flush + 用户手动）/ 读取（向量 + BM25 混合搜索）
- **心跳机制 Heartbeats**：定时探活、自检
- **Cron Job 系统**：自然语言创建定时任务
- **Context Compression**：上下文压缩，避免溢出

## 摘录

> AI Agent 不是简单的"对话机器人"。它有三个区别于普通 ChatBot 的核心特征：第一，它能调用工具操作真实世界（读写文件、发请求、执行命令），不只是返回文字；第二，它有持久状态——记得你之前说过什么、做过什么决策；第三，它会主动出击——可以定时触发、心跳自检，不依赖每次都由用户问起才行动。OpenClaw（龙虾）就是这三种特征都做到极致的一个开源实现。

> 关于安全，OpenClaw 的攻击面比普通 ChatBot 大得多：因为它真能在你电脑上执行命令、读写文件、调浏览器。常见的攻击向量包括：恶意 prompt 注入（让 Agent 自动 rm -rf）、钓鱼消息（伪装成可信发送者发命令）、Skill 越权（一个 Skill 假装别的 Skill 的能力）。OpenClaw 的防御链路是层层叠加的：DM 配对码 → SandBox Docker 隔离 → 工具策略黑名单 → RSA 签名校验。哪一层失守了，下一层还能挡。

> 龙虾的记忆和我们直觉上的"对话历史"不一样。它把记忆分成两类：动态记忆（每次对话的原始 JSONL 日志）和静态记忆（提炼出来的 Markdown 文件）。每次和 Agent 聊完一段，系统会触发 Memory Flush，让 Agent 自己判断"这段话里有什么是我要长期记住的"，写到 memory/YYYY-MM-DD.md。下次启动时，这些 Markdown 文件被切块、向量化、放进 SQLite 索引，等你下次提到相关话题时再被搜出来——这个过程对用户是完全透明的。

## 涉及实体

- [[OpenClaw]] —— 父系统

## 涉及主题

（积累 ≥5 篇同议题来源后聚合）

## 我的评注

- 这篇是"门外汉版"的 OpenClaw 介绍，没源码、没调用链路图，但**把概念讲清楚了**：把"工具/技能/记忆/心跳/Cron"这些术语用日常语言讲，对非工程读者非常友好
- "龙虾的 X" 这种拟人叙事看起来童趣，但实际上是好的文档技术——把复杂系统的子模块都赋予一个角色，记忆负担降低
- 安全章节比阿里腾讯版的更具象：直接列攻击向量（rm -rf / 钓鱼 / 越权），让人对 SandBox 的存在意义有切身体感
