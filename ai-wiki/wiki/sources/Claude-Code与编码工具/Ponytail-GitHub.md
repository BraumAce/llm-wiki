---
title: "Ponytail GitHub"
type: source
date: 2026-06-26
source_type: webpage
source_url: "https://github.com/DietrichGebert/ponytail"
author: "DietrichGebert"
ingested_at: 2026-06-26
tags:
  - coding-agent
  - yagni
  - skill
  - plugin
related_entities:
  - "[[Ponytail]]"
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
  - "[[Spec-Driven-Development]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[Skill开发最佳实践]]"
  - "[[AI-Skill体系-主题]]"
---

# Ponytail GitHub

## 一句话概括

Ponytail 把“懒惰但不粗心的资深工程师”写成可安装插件/规则集，让 coding agent 在写代码前先沿 YAGNI、复用、标准库、平台原生能力和最小实现的梯子做取舍。

## 实践内容

```bash
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail

codex plugin marketplace add DietrichGebert/ponytail
codex

copilot plugin marketplace add DietrichGebert/ponytail
copilot plugin install ponytail@ponytail

clawhub install ponytail
```

```text
1. Does this need to be built at all? (YAGNI)
2. Does it already exist in this codebase?
3. Does the standard library already do this?
4. Does a native platform feature cover it?
5. Does an already-installed dependency solve it?
6. Can this be one line?
7. Only then: write the minimum code that works.
```

## 摘录

> The rule was never "fewest tokens." It is: write only what the task needs, and never cut validation, error handling, security, or accessibility. The code ends up small because it is necessary, not golfed.

> Lazy, not negligent: trust-boundary validation, data-loss handling, security, and accessibility are never on the chopping block. The ladder runs after it understands the problem, not instead of it: it reads the code the change touches and traces the real flow before picking a rung.

## 涉及实体

- [[Ponytail]] —— 本项目实体，反过度工程化插件/规则。
- [[Claude-Code]] —— Claude Code 是主要安装面之一。
- [[Harness-Engineering]] —— Ponytail 把行为约束和验证点作为 Agent harness。
- [[Spec-Driven-Development]] —— 需求边界清晰后，Ponytail 约束实现不要越界。

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[Skill开发最佳实践]]
- [[AI-Skill体系-主题]]

## 我的评注

Ponytail 和用户贴的 AGENTS.md 指南高度同构：先想清楚、简单优先、手术式改动、目标验证。它适合收进 Skill 最佳实践，因为它不只是“少写代码”的口号，而是把何时删、何时复用、何时留检查点、何时不能简化写成了可执行规则。
