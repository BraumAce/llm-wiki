---
title: "Claude 工程师亲授 OpenClaw 调教指南：Skills 的工程化心法"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/VjBNgfDhJSMMlGw5n6RQMA"
author: "未知"
published_at: "2026-03-28"
ingested_at: 2026-05-31
tags:
  - skills
  - openclaw
  - context-engineering
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
---

# Claude 工程师亲授 OpenClaw 调教指南：Skills 的工程化心法

## 一句话概括

基于 Claude Code 工程师 Thariq 长文解读 Skills 工程化心法——Skill 是含 SKILL.md/references/assets/scripts 的目录级能力包，SKILL.md 是 README+runbook+routing contract，description 是触发协议，references 承担渐进式披露，scripts 把确定性动作下沉。

## 实践内容

### Skill 目录结构

```
skill-name/
├── SKILL.md          # README + runbook + routing contract
├── references/       # 渐进式披露的参考资料
├── assets/           # 静态资源
└── scripts/          # 确定性动作脚本
```

### SKILL.md 的三重身份

1. **README** —— 说明这个 Skill 是什么
2. **Runbook** —— 执行步骤和操作指南
3. **Routing Contract** —— 触发条件和边界定义

### description 作为触发协议

description 不是"我是干什么的"，而是"何时该用我"。前 250 字符决定自动触发关键词。

### 9 类分类法

Skills 按功能分为 9 类，每类有不同的设计模式和最佳实践。

### PreToolUse Hook 度量闭环

通过 PreToolUse Hook 在工具调用前度量和控制，把提示工程升级为上下文工程。

## 摘录

> Skill 是含 SKILL.md/references/assets/scripts 的目录级能力包；SKILL.md 是 README+runbook+routing contract，description 是触发协议，references 承担渐进式披露，scripts 把确定性动作下沉。

> 配套 9 类分类法、PreToolUse Hook 度量闭环，把提示工程升级为上下文工程。

## 涉及实体

- [[OpenClaw-Skills]] —— Skills 工程化心法的核心内容
- [[Claude-Code]] —— Claude Code 工程师的 Skills 设计理念

## 涉及主题

- [[AI-Skill体系-主题]]

## 我的评注

Thariq 的这篇文章是 Skills 设计的权威指南。"SKILL.md 是 README+runbook+routing contract"这个定义非常精准——它同时承担了文档、操作手册和路由契约三重职责。scripts 把确定性动作下沉也是重要的设计原则。
