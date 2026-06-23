---
title: "一文搞懂！Loop Engineering的进化史和本质"
type: source
date: 2026-06-23
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/7_QUAetJiDlH9pTXfsAAJA"
author: "Datawhale"
ingested_at: 2026-06-23
tags:
  - loop-engineering
  - control-theory
  - feedback
  - verification
  - automation
related_entities:
  - "[[Loop-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Anthropic]]"
  - "[[Addy-Osmani]]"
  - "[[Generator-Evaluator]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
  - "[[Agentic-Engineering-主题]]"
---

# 一文搞懂！Loop Engineering的进化史和本质

## 一句话概括

这篇文章把 Loop Engineering 放回到 `Prompt -> Context -> Harness -> Loop` 的演进链路里，并用控制论解释为什么 loop 的关键不是“让模型更强”，而是构造一个有传感器、有反馈、有独立验证的闭环系统。

## 实践内容

### 四层演进链

| 阶段 | 解决什么问题 | 典型做法 |
|---|---|---|
| Prompt Engineering | 怎么问 | 措辞、例子、格式 |
| Context Engineering | 模型该知道什么 | system prompt、few-shot、RAG、结构化输入 |
| Harness Engineering | 单次 session 怎么可靠执行 | 工具、重试、权限、验证 |
| Loop Engineering | 谁来持续触发、判断、续跑 | 调度、状态、外部验证、自动闭环 |

作者的核心判断是：Harness 解决“单次 session 内的执行能力”，Loop 解决“把人从重复触发、判断结果、决定下一步这件事里替换出去”。

### 用 CI triage 理解 Loop 六组件

1. **Automations**：每天早上 8 点自动醒来检查 CI 是否失败。
2. **Worktrees**：每个修复任务在独立工作区执行，避免相互覆盖。
3. **Skills**：用 AGENTS.md / CLAUDE.md / SKILL.md 让 agent 不用每次从零学习项目。
4. **Connectors**：接入 GitHub、Linear、Slack 等系统执行外部动作。
5. **Sub-agents**：让另一个 agent 负责验收，而不是写代码的 agent 自评。
6. **Memory / State**：把“今天做了什么、哪里失败了、下一步是什么”写回状态文件，供下次循环续跑。

### 控制论映射

| 控制论角色 | Loop 对应层 | 为什么需要 |
|---|---|---|
| 控制器 | 调度逻辑 + Skills + State | 决定下一步该做什么，并记住历史尝试 |
| 执行器 | 文件编辑、shell、MCP 工具 | 把决策变成真实世界的动作 |
| 传感器 | 测试、验证 agent、审阅规则 | 产生偏差信号，告诉系统离目标还差什么 |

文章最有辨识度的观点是：**在 loop 里，传感器决定收敛速度。** 如果验证器只会返回 pass/fail，控制器几乎是在盲修；如果验证器能指出哪个用例挂了、哪个断言失败了、哪个 diff 引入了问题，控制器才有足够高信号的反馈去修正。

### 什么时候不该上 Loop

- 目标不可测量，例如“让代码更优雅”“写一篇更好的技术博客”。
- 没有客观的 pass/fail 标准，只能依赖主观打分。
- 没有独立验证器，做完和没做完只能靠生成模型自己判断。

因此它给出的起步顺序是：**先写 Skills，后写传感器，最后再套 cron/automation。先建 Inspector，再建 Loop。**

## 摘录

> 到了 2025 年初，人们意识到问题不出在 prompt 的措辞上，而在于模型拿到的信息太少。Context Engineering 应运而生：不再纠结怎么“问”，而是精心构造模型“看到”的东西。上下文做好后，复杂任务一次做不完的问题又浮出来，于是有了 Harness Engineering——给 Agent 装上工具、重试、权限控制，让它能在一次 session 内完成多步操作。而 Loop Engineering 进一步把“人触发 Agent → 人判断结果 → 人决定下一步”替换成自动化系统。

> 大多数人的直觉是反的，花大钱买最强的模型来写代码，然后用简单的 chat 来做验证，最后反复幻觉，离目标越来越偏。而高杠杆的方式是去设计好的传感器，让它返回更丰富的信号，而不仅仅关注模型更聪明。这个逻辑就是：Great prompt + weak verification will fail；mediocre prompt + strong verification will converge。传感器就是设计本身。

## 涉及实体

- [[Loop-Engineering]] —— 本文补全了 loop 的演进脉络、六组件分工和控制论解释。
- [[Harness-Engineering]] —— Loop 是 Harness 之后的下一层，不是并列替代词。
- [[Anthropic]] —— Boris Cherny 的“我的工作是写 loops”成为 loop 破圈的重要信号。
- [[Addy-Osmani]] —— 作为命名者与系统化阐述者，为 loop 提供了统一话语。
- [[Generator-Evaluator]] —— 独立传感器 / 验证器的思想，本质上就是 generator-evaluator 分离。

## 涉及主题

- [[Harness-Engineering-主题]]
- [[Agentic-Engineering-主题]]

## 我的评注

如果说前一篇《重磅！Loop Engineering 实操手册公开》解决的是“怎么搭”，这篇解决的是“为什么要这样搭”。它把 loop 从“六个零件”上升成“反馈控制系统”，很适合回灌到 [[Loop-Engineering]] 实体里，补强“强验证比强 prompt 更关键”“先建 Inspector 再建 Loop”这两个非常高价值的判断框架。
