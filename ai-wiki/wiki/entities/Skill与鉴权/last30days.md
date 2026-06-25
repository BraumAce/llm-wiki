---
title: "last30days"
type: entity
date: 2026-06-26
also_known_as:
  - "/last30days"
  - "last30days-skill"
  - "mvanhorn/last30days-skill"
tags:
  - ai-skill
  - deep-research
  - social-search
  - recency
  - agent-tool
sources:
  - "[[last30days-skill-GitHub]]"
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
  - "[[Token成本控制]]"
  - "[[Ponytail]]"
---

# last30days

## 一句话定义

last30days 是一个跨 Reddit、X、YouTube、TikTok、Hacker News、Polymarket、GitHub 和 Web 的 Agent Skill，用最近 30 天的社区互动信号、市场赔率和公开内容合成带证据的趋势研究简报。

## 摘要

last30days 的关键不是“再做一个网页搜索”，而是把多个封闭平台上的社区信号并行拉出来，再按 upvotes、likes、views、comments、odds、GitHub activity 等真实互动指标排序，最后交给 Agent judge 合成。它把搜索从 SEO 和编辑排序转向“人们最近真的在说什么”。README 中的典型场景包括会前研究某个人最近在做什么、比较 AI 工具、观察突发事件、研究旅行或产品趋势、提取最近提示词实践。它的 `SKILL.md` 也展示了一个高复杂度 Skill 如何用严格输出合同、host renderer 分支、first-run gate、query plan、engine footer 等机制约束模型。

## 详情

### 起源与背景

AI 工具的训练数据和通用搜索往往落后，而许多新工具、舆论、产品体验和开发者实践先出现在 Reddit、X、Hacker News、YouTube 评论或 Polymarket。last30days 试图解决“最新事实分散在围墙花园里”的问题。它允许用户带自己的 API key、浏览器 session 或可用 CLI，把这些平台组合成一个 agent-led search engine。

### 核心机制 / 工作原理

v3 pipeline 的核心包括智能预研究、跨源并行搜索、实体解析、社区评论排序、跨源 cluster merging、比较任务单次并行、GitHub person-mode、HTML brief 生成和降级告警。它既有 README 里的用户安装路径，也有 `SKILL.md` 的运行合同：必须先检查 stale clone、first-run setup、是否有 native web search；命名实体主题要生成 JSON query plan；输出必须保留 engine footer，不能把 raw evidence cluster 直接倾倒给用户。

```bash
/plugin marketplace add mvanhorn/last30days-skill
/plugin install last30days

npx skills add mvanhorn/last30days-skill -g
/last30days OpenClaw --emit=html
```

### 应用 / 使用场景

- 会前研究：快速了解一个人、公司或项目最近 30 天在 X、GitHub、Reddit、YouTube 上的真实动态。
- 产品/工具比较：把多个项目放在同一轮查询里比较社区反馈、采用信号和争议点。
- 趋势研究：从 Reddit/HN/YouTube/TikTok/Polymarket 等平台提取最新社区共识。
- Prompt/工作流学习：研究最近社区实践，再生成可落地的生产提示词或行动建议。

### 局限与争议

它的强度来自多源接入，也带来配置复杂度：部分平台需要 API key、browser cookies 或第三方抓取服务。README 明确说零配置时 Reddit、HN、Polymarket、GitHub 可以立即工作，但 X、YouTube、TikTok 等需要向导解锁。另一个边界是输出合同很重，`SKILL.md` 长达上千行，这说明复杂 Skill 的可靠性往往要用大量规约、测试和失败模式沉淀来换。

## 与其他实体的关系

- [[OpenClaw-Skills]] —— last30days 支持 OpenClaw/ClawHub 安装，是跨宿主 Skill 生态的代表。
- [[Claude-Code]] —— Claude Code marketplace 是其推荐安装面之一。
- [[Token成本控制]] —— last30days 的长 `SKILL.md` 展示了复杂 Skill 在上下文成本与可靠性之间的张力。
- [[Ponytail]] —— 两者都是跨 Agent host 分发的技能/插件，但一个偏研究检索，一个偏代码简化规则。

## 参考来源

- [[last30days-skill-GitHub]]
