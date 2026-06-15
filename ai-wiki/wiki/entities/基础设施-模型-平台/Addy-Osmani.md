---
title: "Addy Osmani"
type: entity
date: 2026-06-15
also_known_as:
  - "Addy Osmani"
tags:
  - person
  - google-chrome
  - loop-engineering
  - ai-engineering
sources:
  - "[[Loop-Engineering循环工程橙皮书]]"
related_entities:
  - "[[Loop-Engineering]]"
  - "[[Generator-Evaluator]]"
  - "[[Harness-Engineering]]"
---

# Addy Osmani

## 一句话定义

Addy Osmani 是 Google Chrome 团队的工程师，他在 2026 年 6 月 7 日把"别再亲自 prompt agent、去设计替你 prompt 的系统"这件事写成文章并正式命名为 **Loop Engineering（循环工程）**，是这一概念框架的奠基者。

## 摘要

循环工程这个词不是某天某个人拍脑袋造出来的，而是 2026 年 6 月那一周几拨人几乎同时撞到同一件事后才有了名字。把它真正引爆的是 [[OpenClaw]] 作者 Peter Steinberger 一条 800 多万浏览的推；[[Anthropic]] 的 Claude Code 负责人 Boris Cherny 同声"我的工作就是写循环"；而**真正给它命名、把它写成系统文章的，是 Addy Osmani**——6 月 7 日发在个人博客，顺手引了 Steinberger 和 Cherny 的话，次日同步到 Substack。一个引爆、一个同声、一个命名，前后就一周。

Addy 给出的定义被反复引用："Loop engineering is replacing yourself as the person who prompts the agent. You design the system that does it instead."。[[Loop-Engineering]] 橙皮书（花叔著）的核心框架——四层栈、五个动作、六个零件、四笔代价——大量建立在 Addy 这篇奠基文之上。

## 详情

### 主要贡献

- **命名并系统化循环工程**：把零散的实践提炼成"你设计的对象，从 agent 的一次行为，变成驱动 agent 的整个系统"这一身份转移。
- **"上一层楼"的定位**："Loop engineering sits one floor above the harness."——明确了 loop 与 [[Harness-Engineering]] 的分层关系：harness 武装单次运行，loop 让它一遍遍自己跑。
- **三个动词的画面**：loop"在定时器上跑、孵化小帮手、自我喂食"。其中"自我喂食"最关键——loop 跑出来的结果被它自己当成下一轮输入，所以才叫循环。

### 几句被反复引用的原话

- "Automations are what make a loop an actual loop and not just one run you did once."（调度才让 loop 成为真正的 loop）
- "The hard part of a loop is not the loop. It is putting something inside it that can say no."（难的是往循环里放一个能说"不"的东西，见 [[Generator-Evaluator]]）
- "The model that wrote the code is way too nice grading its own homework."（写代码的模型给自己批作业态度太好）
- "The agent forgets, the repo doesn't."（agent 会忘，仓库不会——记忆得落在磁盘上）
- "A loop running unattended is also a loop making mistakes unattended."（无人看管的循环也在无人看管地犯错）
- "Build the loop. But build it like someone who intends to stay the engineer, not just the person who presses go."（要像一个打算继续当工程师的人去造它）

### Addy 的早间 triage loop

Addy 描述过他自己每天早上自动发生的一个 triage loop，被反复引用因为足够具体：天亮一个 automation 自己醒来，一个 triage skill 去读昨天 CI 跑挂的测试、还开着的 issue、最近的 commit，把分诊结果写进 markdown 或 Linear 看板；每个值得动手的发现开一个隔离的 worktree，一个子 agent 起草修复，第二个子 agent 对照项目 skill 和测试做审查；connector 自动开 PR、更新 ticket，处理不了的进收件箱等人；状态文件留着，第二天接着跑。他强调 automation 里触发的应是 `$skill-name` 而不是"贴进一个没人会去更新的排程里的一大墙指令"。

### 影响 / 评价

Addy 的奠基文与 Claude Code / Codex 官方文档一起，成为花叔《Loop Engineering 循环工程橙皮书》（2026-06，v260615）的主要一手来源。他对"两个人造出一模一样的循环、结果可以完全相反"的论断，被花叔视为整篇里最该被记住的一句。

## 与其他实体的关系

- [[Loop-Engineering]] —— Addy 是该概念的命名者与框架奠基者
- [[Generator-Evaluator]] —— Addy 提出"loop 难在放一个能说不的东西"，对应生成器/评判器分离
- [[Harness-Engineering]] —— Addy 定位 loop 为 harness 的"上一层楼"

## 参考来源

- [[Loop-Engineering循环工程橙皮书]] —— 花叔，全书大量引用 Addy Osmani 的奠基文与原话
