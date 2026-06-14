---
title: "Claude Code Skills 完全指南：从零打造你的生产级别 AI 编程助理工作流"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/M-K8cDwLhpID1gkcZOdUkQ"
author: "码哥"
published_at: "2026-03-30"
ingested_at: 2026-05-31
tags:
  - claude-code
  - skills
  - hooks
  - context-engineering
related_entities:
  - "[[Claude-Code]]"
  - "[[OpenClaw-Skills]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[AI-Skill体系-主题]]"
---

# Claude Code Skills 完全指南：从零打造你的生产级别 AI 编程助理工作流

## 一句话概括

码哥用 fix-issue Skill 实战拆解 CLAUDE.md / Skills / Hooks 决策树（每次必用 / 按需加载 / 强制执行），详解 5 个高级特性：description 触发关键词、disable-model-invocation 控制、PR diff 动态注入、context:fork 子 Agent 隔离、supporting files 拆分。

## 实践内容

### CLAUDE.md / Skills / Hooks 决策树

| 类型 | 加载时机 | 适用场景 | 示例 |
|------|----------|----------|------|
| CLAUDE.md | 每次会话必用 | 项目契约、构建命令、禁止事项 | 架构边界、编码规范 |
| Skills | 按需加载 | 工作流、领域知识 | fix-issue、code-review |
| Hooks | 强制执行 | 确定性校验、自动化流程 | lint、格式化、安全检查 |

### Skills 5 个高级特性

1. **description 前 250 字符决定自动触发关键词** —— 模型根据描述判断何时使用该 Skill
2. **disable-model-invocation 与 user-invocable 双字段控制** —— 精确控制谁能调用 Skill
3. **`!\`command\`` 预处理动态注入** —— 在 Skill 执行前运行命令，将结果注入上下文（如获取 PR diff）
4. **context:fork + Explore/Plan 子 Agent 隔离上下文** —— 避免大量探索污染主对话
5. **supporting files 拆分长 Skill** —— 大资料拆到 references 目录，SKILL.md 只放导航和核心约束

### fix-issue Skill 实战示例

```markdown
---
name: fix-issue
description: Fix a GitHub issue. Use when user mentions fixing an issue or bug.
---

## Steps
1. Read the issue description and comments
2. Explore the codebase to understand the problem
3. Identify the root cause
4. Implement the fix
5. Run tests to verify
6. Create a commit with the fix
```

### 内置 Skills 速查

- `/batch` —— 批量处理任务
- `/simplify` —— 代码简化和优化
- `/loop` —— 循环执行任务
- `/debug` —— 调试辅助

## 摘录

> 码哥用 fix-issue Skill 实战拆解 CLAUDE.md / Skills / Hooks 决策树（每次必用 / 按需加载 / 强制执行）——给出 5 个高级特性：description 前 250 字符决定自动触发关键词、disable-model-invocation 与 user-invocable 双字段控制谁能调用、`!\`command\`` 预处理动态注入 PR diff、context:fork + Explore/Plan 子 Agent 隔离上下文、supporting files 拆分长 Skill。

> Skills 的核心价值在于把工作流标准化——不是告诉 AI "做什么"，而是告诉它"怎么做"。description 决定触发条件，SKILL.md 定义执行步骤，supporting files 提供领域细节。

## 涉及实体

- [[Claude-Code]] —— Skills 在 Claude Code 中的完整使用指南
- [[OpenClaw-Skills]] —— Skills 的设计原则和高级特性

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[AI-Skill体系-主题]]

## 我的评注

这篇指南的实战价值很高，特别是 5 个高级特性。`disable-model-invocation` 和 `user-invocable` 的组合使用对于控制 Skill 的触发非常关键——有副作用的 Skill 必须禁止模型自动调用。
