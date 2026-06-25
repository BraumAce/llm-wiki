---
title: "Ponytail"
type: entity
date: 2026-06-26
also_known_as:
  - "DietrichGebert/ponytail"
  - "lazy senior dev mode"
tags:
  - coding-agent
  - skill
  - plugin
  - yagni
  - minimalism
sources:
  - "[[Ponytail-GitHub]]"
related_entities:
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
  - "[[last30days]]"
  - "[[Spec-Driven-Development]]"
---

# Ponytail

## 一句话定义

Ponytail 是一个给 AI 编码 Agent 使用的“懒惰资深工程师”规则/插件集合，通过 YAGNI、复用、标准库优先、平台能力优先和最小 diff 梯子，压低过度工程化和无谓代码量。

## 摘要

Ponytail 的核心不是代码高尔夫，而是让 Agent 在真正理解问题后停在“足够简单”的第一层。它把 senior engineer 的工程直觉写成一条梯子：这个东西是否根本不需要做，仓库里是否已有实现，标准库是否覆盖，平台原生能力是否覆盖，已有依赖是否可用，能否一行完成，最后才写最小可工作代码。README 给出 agentic benchmark：在真实 FastAPI + React 仓库的 12 个 feature tasks 上，Ponytail 相比无 skill baseline 减少 LOC、tokens、cost 和 time，同时保持安全评分。它和用户给出的 AGENTS.md 指南方向一致：先想清楚、简单优先、手术式改动、以可验证目标执行。

## 详情

### 起源与背景

大模型编码常见问题是过度抽象、安装不必要依赖、为了简单需求生成大组件、顺手重构无关代码。Ponytail 把这种问题归纳为“Agent 太勤快”：它愿意写很多看起来合理但并非必要的代码。项目用一个具象角色提醒模型：真正资深的懒，是少写不必要代码，但并不偷懒于理解问题、信任边界验证、安全、可访问性和防数据丢失。

### 核心机制 / 工作原理

Ponytail 可以作为 Claude Code/Codex 插件、OpenCode/Gemini/Antigravity 扩展、OpenClaw skill，或直接通过 AGENTS.md / Cursor rules / Copilot instructions 等规则文件加载。其 AGENTS.md 是最小核心：先理解任务和真实调用链，再沿七级梯子选择最小实现。它还要求 bug fix 找根因而非症状，非平凡逻辑留下一个最小 runnable check，刻意简化时用 `ponytail:` 注释标明上限和升级路径。

```text
1. Does this need to be built at all?
2. Does it already exist in this codebase?
3. Does the standard library already do this?
4. Does a native platform feature cover it?
5. Does an already-installed dependency solve it?
6. Can this be one line?
7. Only then: write the minimum code that works.
```

### 应用 / 使用场景

- 给 Claude Code、Codex、Cursor 等 coding agent 加一层反过度工程化规则。
- 在 review 当前 diff 时找出可以删除、复用、标准库替代或原生控件替代的部分。
- 团队希望把“不要随便加依赖/抽象/驱动式重构”的工程文化写进 Agent 指令。
- 对 demo、CRUD、前端控件、简单校验等容易被 Agent 写大的任务做成本约束。

### 局限与争议

Ponytail 明确说“lazy, not negligent”：安全、可访问性、信任边界验证和防数据丢失不能被删。它适合抵抗过度工程，不适合把复杂问题强行变成一行。另一个风险是如果 Agent 没读代码就套梯子，会把“最小 diff”做在错误位置；因此 Ponytail 本身也强调先 tracing real flow，再选择 rung。

## 与其他实体的关系

- [[Claude-Code]] —— Ponytail 的主要分发路径之一是 Claude Code plugin marketplace。
- [[Harness-Engineering]] —— 它把代码评审标准、验证点和行为约束前置为 Agent harness。
- [[last30days]] —— 两者都是跨宿主插件/Skill 生态里的代表项目。
- [[Spec-Driven-Development]] —— Ponytail 强调需求边界和成功标准，能作为 SDD 之后的实现约束层。

## 参考来源

- [[Ponytail-GitHub]]
