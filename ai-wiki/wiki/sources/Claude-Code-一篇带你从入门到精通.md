---
title: "Claude Code 一篇带你从入门到精通"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/1FIyJ08MaKb6bHY2PGAmbQ"
author: "未知"
published_at: "2026-03-14"
ingested_at: 2026-05-31
tags:
  - claude-code
  - skills
  - subagents
  - context-engineering
related_entities:
  - "[[Claude-Code]]"
  - "[[OpenClaw-Skills]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
---

# Claude Code 一篇带你从入门到精通

## 一句话概括

系统拆解 Claude Code 的三大进阶能力：CLAUDE.md 四级注入、Skills 三级渐进式披露（元数据约 100 token / SKILL.md <5k token / 资源按需 bash 加载）、Sub-Agent 独立上下文与受限工具的任务委派。

## 实践内容

### CLAUDE.md 四级注入

通过 `/init`、`/memory`、`#` 操作符落地企业→项目→用户三级记忆，用 `@` 实现模块化导入。

### Skills 三级渐进式披露

| 层级 | Token 消耗 | 加载时机 | 内容 |
|------|-----------|----------|------|
| 元数据 | ~100 token | 预加载 | description、触发条件 |
| SKILL.md | <5k token | 按需加载 | 完整指令和步骤 |
| 资源文件 | 按需 | 执行时 bash 加载 | references、scripts |

### 两种触发方式

1. **手动触发** —— 用户输入 `/skill-name`
2. **自动发现** —— 模型根据 description 自动判断是否使用

### Sub-Agent 分工

Sub-Agent 以独立上下文与受限工具承担任务委派，与 Skills 的「知识注入」形成「加技能 vs 召唤分身」分工：
- **Skills**：注入知识和工作流，扩展主 Agent 的能力
- **Sub-Agent**：隔离上下文和权限，委派独立任务

## 摘录

> 系统拆解 Claude Code 的三大进阶能力：CLAUDE.md 通过 /init、/memory、`#` 操作符落地企业→项目→用户三级记忆并用 `@` 实现模块化导入；Skills 采用元数据 / SKILL.md / 资源三级渐进式披露（元数据约 100 token、SKILL.md <5k token、资源按需 bash 加载）配合手动 `/skill-name` 与自动发现两种触发。

> Sub-Agent 以独立上下文与受限工具承担任务委派，与 Skills 的「知识注入」形成「加技能 vs 召唤分身」分工——Skills 扩展能力，Sub-Agent 委派任务。

## 涉及实体

- [[Claude-Code]] —— Claude Code 三大进阶能力的系统拆解
- [[OpenClaw-Skills]] —— Skills 三级渐进式披露机制

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[AI-Skill体系-主题]]
