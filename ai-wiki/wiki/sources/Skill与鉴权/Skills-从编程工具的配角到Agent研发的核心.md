---
title: "Skills：从编程工具的配角到Agent研发的核心"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/OmA2xcmpXNITxbR5bTsT6w"
author: "未知"
published_at: "2026-03-03"
ingested_at: 2026-05-31
tags:
  - skills
  - agent
  - context-engineering
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
---

# Skills：从编程工具的配角到Agent研发的核心

## 一句话概括

Skills 价值高度场景依赖，在 Claude Code 中被 Commands 的即时性与 SubAgent 的专业性挤压而沦为鸡肋，但在企业级 Agent 平台里凭借标准化接口、按需加载、声明式解耦解决重复造轮子、能力孤岛与跨团队协作痛点。

## 实践内容

### Skills 在不同场景的价值

| 场景 | Skills 价值 | 原因 |
|------|------------|------|
| Claude Code CLI | 低（鸡肋） | 被 Commands 和 SubAgent 挤压 |
| 企业级 Agent 平台 | 高（核心） | 解决复用、协作、标准化问题 |

### 判断是否引入 Skills 的四维度

1. **复用频率** —— 同一工作流被重复使用的次数
2. **复杂度** —— 工作流的复杂程度
3. **协作规模** —— 需要跨团队协作的程度
4. **生态开放性** —— 是否需要与外部系统集成

### 不推荐使用 Skills 的场景

- 原型开发
- 专用工具
- 小项目
- 性能敏感场景

## 摘录

> Skills 价值高度场景依赖，在 Claude Code 中被 Commands 的即时性与 SubAgent 的专业性挤压而沦为鸡肋，但在企业级 Agent 平台里凭借标准化接口、按需加载（渐进式披露）、声明式解耦解决重复造轮子、能力孤岛与跨团队协作痛点。

> 判断是否引入看复用频率、复杂度、协作规模、生态开放性四维度，原型/专用工具/小项目/性能敏感场景不推荐。

## 涉及实体

- [[OpenClaw-Skills]] —— Skills 的适用场景和价值判断
- [[Claude-Code]] —— Skills 在 Claude Code 中的局限性

## 涉及主题

- [[AI-Skill体系-主题]]

## 我的评注

这篇文章提供了 Skills 选型的实用框架。"在 Claude Code 中沦为鸡肋"这个观点很有意思——因为 Commands 提供了即时性，SubAgent 提供了专业性，Skills 处于一个尴尬的中间位置。但在企业级场景中，Skills 的标准化和可复用性价值就凸显出来了。
