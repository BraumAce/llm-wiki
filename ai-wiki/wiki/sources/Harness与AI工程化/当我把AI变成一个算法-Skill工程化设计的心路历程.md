---
title: "当我把AI变成一个算法-Skill工程化设计的心路历程"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/bD10zbBeTtzMyEKqjIdT1w"
author: "腾讯技术工程"
ingested_at: 2026-05-29
tags: [skill, engineering, workflow]
related_entities: [OpenClaw-Skills, Harness-Engineering]
related_topics: [Agent架构演进-主题]
---

# 当我把AI变成一个算法-Skill工程化设计的心路历程

## 一句话概括
通过CLI接管一切确定性事务（API调用、状态管理、流程编排），将Agent限定为纯决策引擎，配合步进式披露、Gate门禁、状态持久化和模板变量等机制，把Agent从不可控的对话机器人变成精确、可恢复、可审计的工程化组件——"不改变河的本性，但给它修好渠"。

## 摘录
> LLM 是一条河，你没法改变它的本性——它就是概率性的、注意力有限的、没有持久记忆的。但你可以给它修渠。渠道的走向是确定的，闸门的启闭是可控的，每一段蓄水量是可测的。河水在渠里流动时，它依然是那条河——灵动的、有理解力的、善于表达的。但它流向了你需要它去的地方。

> 规则越多，模型的行为越不确定。这不是模型的问题，是规则本身的复杂度在爆炸。真正该问的问题不是"怎么写更好的提示词"，而是：怎么设计一个让 AI 在每个时刻都只需要关注最少信息的执行环境？

> 凡是涉及精确格式、固定流程的事，AI 不靠谱；凡是涉及理解、判断、表达的事，AI 很在行。这就像一个绝顶聪明的战略家让他去填税务表格——他照样漏格子。不是笨，是能力类型不匹配。Agent 的不确定性，被 CLI 的确定性包裹住了。

> Workflow 不写在 Skill 代码里，它就是文件系统上的一组 Markdown 文件。新增一个工作流的全部成本：在 workflows/ 目录下新建一个文件夹。Skill 的业务能力可以无限横向扩展，而 Skill 本身的代码完全不动。

## 涉及实体
- [[OpenClaw-Skills]] —— 文章详细设计了Skill的工程化实现架构
- [[Harness-Engineering]] —— CLI+Workflow构成的执行环境是典型的Harness设计

## 涉及主题
- [[Agent架构演进-主题]]
