---
title: "开源 Claude Code 工程级开发插件 Superpowers 完整上手攻略"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/n52dg8R2fzgHNIo9XX-HMA"
author: "未知"
published_at: "2026-03-18"
ingested_at: 2026-05-31
tags:
  - claude-code
  - plugin
  - subagents
related_entities:
  - "[[Claude-Code]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
---

# 开源 Claude Code 工程级开发插件 Superpowers 完整上手攻略

## 一句话概括

拆解 Anthropic 开源插件 Superpowers 的分层架构与 20+ 可组合 Skills 体系，核心是 Subagent-Driven Development：每个子 Agent 全新上下文启动以隔离污染，配合 Spec Review + Code Quality Review 两阶段审查。

## 实践内容

### 分层架构

1. **用户层** —— 用户交互界面
2. **框架层** —— 核心框架逻辑
3. **执行层** —— 任务执行引擎
4. **输出层** —— 结果输出和格式化

### Subagent-Driven Development

每个子 Agent 全新上下文启动以隔离污染，避免上下文累积导致的质量下降。

### 两阶段审查

1. **Spec Review** —— 审查规格文档
2. **Code Quality Review** —— 审查代码质量

### 关键 Skills 速查表

| Skill | 触发关键词 | 功能 |
|-------|-----------|------|
| brainstorming | 头脑风暴 | 生成创意和方案 |
| writing-plans | 写计划 | 制定执行计划 |
| tdd | 测试驱动 | TDD 开发流程 |
| systematic-debugging | 系统调试 | 系统化调试方法 |
| using-git-worktrees | git worktree | 使用 git worktree 隔离 |

### personal skills 覆盖

personal skills 可以覆盖默认技能，解析顺序决定优先级。

## 摘录

> 拆解 Anthropic 开源插件 Superpowers 的分层架构（用户层 / 框架层 / 执行层 / 输出层）与 20+ 可组合 Skills 体系，核心是 Subagent-Driven Development：每个子 Agent 全新上下文启动以隔离污染。

> 配合 Spec Review + Code Quality Review 两阶段审查；附 brainstorming、writing-plans、TDD、systematic-debugging、using-git-worktrees 等关键 Skill 速查表与触发关键词，给出 personal skills 覆盖默认技能的解析顺序。

## 涉及实体

- [[Claude-Code]] —— Superpowers 是 Claude Code 的官方插件

## 涉及主题

- [[Claude-Code源码解析-主题]]

## 我的评注

Subagent-Driven Development 是一个重要的设计模式——每个子 Agent 用全新上下文启动，避免上下文累积导致的质量下降。20+ 可组合 Skills 也展示了 Skills 系统的扩展性。
