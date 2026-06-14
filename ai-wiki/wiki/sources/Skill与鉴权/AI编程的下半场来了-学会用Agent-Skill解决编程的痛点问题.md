---
title: "AI编程的下半场来了？学会用Agent Skill解决编程的痛点问题"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/ho1l5v5mrNr_f6JXARMlFQ"
author: "腾讯 CloudBase"
published_at: "2026-03-02"
ingested_at: 2026-05-31
tags:
  - skills
  - agent
  - serverless
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
---

# AI编程的下半场来了？学会用Agent Skill解决编程的痛点问题

## 一句话概括

腾讯 CloudBase 把 8 年 Serverless 经验封装为 21 个 Skill + 1 个 cloudbase-guidelines 总纲，靠首行注入、CLAUDE.md / AGENT.md 项目家法与 settings.json Forced Eval Hook 三层手段把 Skill 激活率从 20% 提到 84%。

## 实践内容

### 21 个 Skill + 1 个总纲

- 21 个具体 Skill
- 1 个 cloudbase-guidelines 总纲

### 云端原生最佳实践

强制 AI 用云端原生：
- OPENID（而非前端传参）
- Security Rules（而非硬编码）
- 托管 API Key（而非暴露）

### 三层激活手段

1. **首行注入** —— 在 SKILL.md 首行注入关键信息
2. **CLAUDE.md / AGENT.md 项目家法** —— 项目级规范
3. **settings.json Forced Eval Hook** —— 强制评估钩子

### 效果数据

Skill 激活率从 20% 提到 84%。

### MCP 与 Skills 的分工

- MCP 提供连接
- Skills 提供工程直觉

## 摘录

> 腾讯 CloudBase 把 8 年 Serverless 经验封装为 21 个 Skill + 1 个 cloudbase-guidelines 总纲，强制 AI 用云端原生 OPENID、Security Rules、托管 API Key 替代前端传参与硬编码。

> 靠首行注入、CLAUDE.md / AGENT.md 项目家法与 settings.json Forced Eval Hook 三层手段把 Skill 激活率从 20% 提到 84%，并阐明 MCP 提供连接、Skills 提供工程直觉的分工。

## 涉及实体

- [[OpenClaw-Skills]] —— Skills 的激活策略
- [[Claude-Code]] —— Claude Code 中的 Skills 配置

## 涉及主题

- [[AI-Skill体系-主题]]

## 我的评注

Skill 激活率从 20% 到 84% 的提升很有说服力。三层激活手段（首行注入、项目家法、Forced Eval Hook）是实用的工程实践。"MCP 提供连接、Skills 提供工程直觉"的分工也很清晰。
