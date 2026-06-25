---
title: "last30days-skill GitHub"
type: source
date: 2026-06-26
source_type: webpage
source_url: "https://github.com/mvanhorn/last30days-skill"
author: "mvanhorn"
ingested_at: 2026-06-26
tags:
  - ai-skill
  - deep-research
  - social-search
  - recency
related_entities:
  - "[[last30days]]"
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
  - "[[Token成本控制]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
  - "[[Skill开发最佳实践]]"
---

# last30days-skill GitHub

## 一句话概括

last30days 是一个复杂 Agent Skill 样本：把最近 30 天跨平台社区搜索、实体解析、互动信号排序、GitHub activity 和 HTML brief 输出封装成可安装的研究技能。

## 实践内容

```bash
/plugin marketplace add mvanhorn/last30days-skill
/plugin install last30days

npx skills add mvanhorn/last30days-skill -g
npx skills update last30days -g

/last30days OpenClaw --emit=html
/last30days Cursor IDE for slack
/last30days Anthropic earnings export as html
```

```bash
python3 skills/last30days/scripts/last30days.py --preflight
LAST30DAYS_NATIVE_SEARCH=1 python3 scripts/last30days.py "$TOPIC" --plan "$QUERY_PLAN_FILE" --emit=compact
```

## 摘录

> Reddit upvotes. X likes. YouTube transcripts. TikTok engagement. Polymarket odds backed by real money and insider information. That's millions of people voting with their attention and their wallets every day. /last30days searches all of it in parallel, scores it by what real people actually engage with, and an AI agent judge synthesizes it into one brief.

> The v3 engine doesn't just search for your topic. It figures out where to search before the search begins. Type "OpenClaw" and the engine resolves @steipete, r/openclaw, r/ClaudeCode, and the right YouTube channels and TikTok hashtags. The old engine searched keywords. The new engine understands your topic first.

## 涉及实体

- [[last30days]] —— 本项目实体，最近 30 天社区信号研究 Skill。
- [[OpenClaw-Skills]] —— last30days 支持 OpenClaw/ClawHub 安装。
- [[Claude-Code]] —— Claude Code marketplace 是推荐安装路径。
- [[Token成本控制]] —— 复杂 SKILL.md 展示了可靠性和上下文成本的权衡。

## 涉及主题

- [[AI-Skill体系-主题]]
- [[Skill开发最佳实践]]

## 我的评注

这个仓库最值得学的不是“搜索源很多”，而是一个生产级 Skill 如何把失败模式写进合同：stale clone 检测、first-run gate、host renderer 分支、强输出法律、query plan、engine footer。它也反过来证明：越强的 Skill 越像一个小型软件系统，而不是一段 prompt。
