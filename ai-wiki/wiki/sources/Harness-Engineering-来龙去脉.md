---
title: "Harness Engineering 来龙去脉"
type: source
date: 2026-05-30
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/hsItMKR-J7w16DtjtkJQPw"
author: "代码随想录 / 卡哥"
ingested_at: 2026-05-30
tags:
  - harness-engineering
  - prompt-engineering
  - context-engineering
  - agent
  - ai-engineering
  - interview
related_entities:
  - "[[Harness-Engineering]]"
  - "[[OpenClaw]]"
  - "[[Mitchell-Hashimoto]]"
  - "[[Hermes-Agent]]"
  - "OpenAI-Codex"
  - "Anthropic"
  - "[[Agent-Memory]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
  - "[[Agent架构演进-主题]]"
---

# Harness Engineering 来龙去脉

## 一句话概括

代码随想录卡哥从面试视角系统梳理 Harness Engineering 的概念起源（Mitchell Hashimoto 2026.2.5 博客）、与 Prompt/Context Engineering 的三次重心转移、六层核心组件架构、大厂五大真实难题、以及 Hermes Agent 与 OpenClaw 两种实现路径的对比，是一篇面向面试准备的 Harness 全景入门文章。

## 实践内容

### 核心等式

```
Agent = Model + Harness
Harness = Agent - Model
```

### 六层核心组件

| 层 | 解决的核心问题 |
|---|---|
| 上下文精细化 | 模型这一轮该看到什么？ |
| 工具系统 | 模型用什么动手？ |
| 执行编排 | 模型下一步该干啥？ |
| 记忆与状态 | 模型跨轮该记住什么？ |
| 评估与观测 | 模型做得好不好有没有尺子？ |
| 约束与恢复 | 模型出错了能不能爬起来？ |

### 六层分组

```
输入侧（让模型看到正确的东西）：上下文精细化管理 + 记忆与状态管理
动作侧（让模型做出正确的事）：工具系统 + 任务执行编排
校验侧（让模型知道做没做对 + 出错能爬起来）：评估观测 + 约束恢复
```

### Mitchell Hashimoto 的定义

> 每次当你发现 Agent 犯了一个错误，就花点时间去工程化一个解决方案，让它永远不会再犯同样的错误。

核心做法：给 AGENTS.md 加一条规则、加一个 linter、补一个自动化测试、搞一个 Git Hook——修补必须沉淀到环境里，而不是留在人脑子里。

### Agent 演进四阶段

```
聊天机器人 → 接上检索和工具 → 自主 Agent → 自进化 Agent
（问答）     （干活）           （长期干活）  （越干越强）
```

### Anthropic 的上下文管理策略

- "just-in-time retrieval"——让 Agent 边干活边按需抓信息，而不是一上来把所有可能有用的东西一股脑塞进去
- Agent 的状态不应该放在上下文窗口里，而应该外化到文件系统
- 记忆分层：任务状态（写到 progress 文件里）、会话中间结果（当轮用完就丢）、长期记忆（写在常驻配置里）

### OpenAI Codex 的工具系统经验

> 一开始给 Agent 接了一堆工具，想着"选择多总是好的"，结果 Agent 频繁用错工具、用错时机。后来砍掉一大半，效果反而上去了。

## 摘录

> 2026 年 2 月 5 号，Mitchell Hashimoto（HashiCorp 联合创始人，Vagrant、Terraform 的作者）发了一篇博客，叫《My AI Adoption Journey》。他把接纳 AI 的过程拆成 6 步，第 5 步的名字就叫"Engineer the Harness"。他的定义特别简洁：每次当你发现 Agent 犯了一个错误，就花点时间去工程化一个解决方案，让它永远不会再犯同样的错误。你品品这个思路。绝大多数人遇到 Agent 犯错，骂两句手动改掉，祈祷下次别再犯。但 Mitchell 不是这么干的——他每次 Agent 犯错，都会停下来问自己：我能不能把这个错误永久性地修到环境里，让它下次在结构上就不可能再犯？

> 你把提示词写得再漂亮，把上下文管得再完美，模型在单步上的表现确实越来越好。但只要任务的链路一长，还是会出问题：计划做得很好，执行时突然跑偏；调用工具调对了，但理解错了返回结果；在长任务链里悄悄偏离初衷，系统完全没察觉；跑着跑着忘了自己最初要干啥。提示词优化的是"意图表达"，上下文优化的是"信息供给"，但这两个都还停留在输入侧。当模型真正开始连续行动时，会出现一个全新的问题：谁来监督它？谁来约束它？谁来在它跑偏时把它拉回来？

> Harness 这个词直译叫"马具"，或者"缰绳"。想象一下骑马：马本身有强大的力量，能跑能跳能驮东西。但如果没有缰绳和马具，这股力量就是失控的——马可能往悬崖上跑，可能甩你下来，可能跑去吃草不回来了。马具的作用，就是让这股力量为你所用。AI 系统也一样。LLM 很强，Agent 很能干，但如果没有一套东西把它们"拴住"、监测住、约束住，它们就是脱缰的野马——可能跑偏、可能幻觉、可能越权、可能悄悄变差。

> 太多团队做出 Agent 高高兴兴上线，跑了两周才发现实际成功率只有 50%——不是它不出结果，而是它每次都出结果，但一半时候是错的。这两周里没人发现，因为根本没有机制能告诉团队"它这次到底做得对不对"。

## 涉及实体

- [[Harness-Engineering]] —— 本文核心概念，从概念起源到六层架构的全景梳理
- [[Mitchell-Hashimoto]] —— HashiCorp 联合创始人，2026.2.5 首次提出"Engineer the Harness"
- [[OpenClaw]] —— 文章对比的两种 Harness 实现之一
- [[Hermes-Agent]] —— 文章对比的两种 Harness 实现之一
- OpenAI-Codex —— OpenAI 官方博客背书 Harness Engineering，内部 5 个月 100 万行代码实践
- Anthropic —— "just-in-time retrieval" 和状态外化到文件系统的策略
- [[Agent-Memory]] —— 第四层"记忆与状态"的核心，CLAUDE.md/.cursorrules 是长期记忆的典型实现

## 涉及主题

- [[Harness-Engineering-主题]] —— 本文是该主题的核心来源之一
- [[Agent架构演进-主题]] —— 聊天机器人 → 自主 Agent → 自进化 Agent 的四阶段演进

## 我的评注

- 本文最有价值的贡献是把 Harness Engineering 的"出身"讲清楚了：基础设施圈老法师先喊出来 → OpenAI 几天后发文背书 → 一周内整个 AI 圈刷屏。这个路径决定了它不会是"换皮概念"
- "Agent = Model + Harness"这个等式虽然简洁，但边界划得非常清楚——面试时能用一句话把 Harness 的范围说清楚
- 六层组件的分组方式（输入侧/动作侧/校验侧）比逐层罗列更容易记忆，面试时按"看得准 → 做得对 → 错了能兜底"的逻辑展开
- 文章提到但未展开的 Hermes Agent vs OpenClaw 对比值得单独深挖——已有 [[Agent从一问一答到自主执行面临哪些挑战]] 涉及两者对比
- 与 [[从Prompt-Context到Harness-工程的三次进化与终局之战]] 互补：本文偏面试准备和概念起源，那篇偏腾讯云实践落地
