---
title: "2026 年 AI 编码的渐进式 Spec 实战指南"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/7Lgb3GfgXKI0J9L9e9sq0w"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags: [ai-coding, spec-driven-development, prompt-engineering, workflow, best-practices]
related_entities: []
related_topics: [[AI编码]], [[Spec驱动开发]], [[提示工程]]
---

# 2026 年 AI 编码的渐进式 Spec 实战指南

## 一句话概括
介绍如何通过渐进式编写规格说明（Spec）来引导 AI 编码助手高质量完成开发任务的实战方法论。

## 实践内容

### 1. 三个基础认知

**大模型能力边界**：当前顶级模型可独立完成中等复杂度编码任务（理解需求、读代码、写实现、修编译错误），但仍需人审查结果。模型之间性能差异断崖式，T0 模型三轮搞定的事 T2 可能 15 轮还不一定对。

**Agent 本质**：Agent = while 循环 + Tool Use + 工具执行器。"智能"来自模型，"能力"来自工具，"自主性"来自循环。工具的边界就是 Agent 的能力边界。

**软件复杂度视角**（来自《人月神话》）：软件复杂度 = 本质复杂度（业务逻辑本身，不可消除）+ 偶然复杂度（工具/流程引入的额外负担，可以且应该被消除）。评判标准：一个方案好不好，看它能多高效地帮你应对本质复杂度，同时自身引入的偶然复杂度有多低。

### 2. 渐进式 Spec Coding 框架

**Spec Coding 三条铁律**：
- No Spec, No Code — 没有文档，不准写代码
- Spec is Truth — 文档和代码冲突时，错的一定是代码
- Reverse Sync — 发现 Bug，先修文档，再修代码

**核心设计：渐进式复杂度**：不同复杂度的需求暴露不同深度的流程。70% 的需求是 ≤5 人日的小需求，简单需求不承担复杂流程的成本。Rules 始终生效，Spec 按复杂度加载。

**自我迭代**：prompt、模板、rules 都是代码库中的普通文件，随 Git 版本演进。知识飞轮：需求实践 → 踩坑 → 沉淀 knowledge / 更新 prompt / 修改模板 → AI 更准。

**目录结构**：
```
code_copilot/
├── rules/          # Project Rules（始终生效）
├── knowledge/      # 领域知识（按需加载）
├── agents/         # Agent 配置与提示词
├── changes/        # 变更管理
└── archives/       # 已完成变更的归档
```

### 3. 工作流：Propose → Apply → Review → Archive

- **Propose**：人主导，AI 辅助。Research 代码现状 → 逐个提问收敛不确定性 → 分段生成 spec（每段确认）→ 生成 tasks → HARD-GATE 确认（待澄清全部解决前不允许进入 Apply）
- **Apply**：AI 主导，人审查。逐 task 执行，每个 task 完成后展示验证证据，零偏差原则
- **Review**：两阶段 Sub Agent 审查（Spec Compliance + Code Quality），上下文与实现者隔离
- **Archive**：知识沉淀，逐条确认 log.md 中的发现是否沉淀到 knowledge/
- **Debug**：四阶段调试：根因调查 → 模式分析 → 假设验证 → 实施修复

### 4. 工具选型：编排层 + 执行层两层架构

- **编排层**（强模型如 Claude Opus）：理解需求、生成 Spec、审查结果
- **执行层**（编码工具如 Claude Code / opencode）：读写代码、执行命令、运行测试

**透明度底线**：模型型号+版本可见、完整 context 可查、原始输出不被篡改、token 用量透明。在不透明的工具上花再多时间优化 prompt，效果都无法归因、无法复现。

### 5. 核心观点

- 人的角色从"全干"变成"管和验"：管控（控制 AI 看什么）、指挥（选方案、审计划、批准执行）、评价（验收结果、发现偏差）
- 知识底座才是真正的护城河：团队之间的差距不在于用什么工具，而在于积累了多少高质量的、结构化的领域知识
- 自由度曲线：调研（中）→ 方案设计（高）→ 规划（低）→ 执行（零）→ 验收（中）

## 摘录
> 当前顶级模型可以独立完成中等复杂度的编码任务——理解需求、读代码、写实现、修编译错误，但仍需人审查结果。它们没有持久记忆、没有自主意图，只处理你给它的上下文。核心结论：模型是地基，方法论是上层建筑。地基不行，上面盖得再好也白搭。

> Agent = while 循环 + Tool Use + 工具执行器。这个循环就是 Agent 的全部——"智能"来自模型，"能力"来自工具，"自主性"来自循环。关键理解：工具的边界就是 Agent 的能力边界。给它读写文件的工具，它能改代码；不给它网络工具，它就上不了网。

> 渐进式复杂度是框架的核心卖点。其他方案都假设所有需求都值得走完整流程，但现实中并非如此——70% 的需求是 ≤5 人日的小需求。不同复杂度的需求，暴露不同深度的流程。这本质上是在压缩偶然复杂度：只有本质复杂度够高时，才引入对应重量的流程。

> Spec Coding 三条铁律：No Spec, No Code — 没有文档，不准写代码；Spec is Truth — 文档和代码冲突时，错的一定是代码；Reverse Sync — 发现 Bug，先修文档，再修代码。把需求、约束、代码现状写进 Spec 作为高质量输入，AI 不用反复试错，对话轮次从 20 轮降到 3-5 轮，总成本反而更低，效果反而更好。

> 透明度不是奢侈品，是基础需求。透明度底线：模型型号+版本可见、完整 context 可查、原始输出不被篡改、token 用量透明。在不透明的工具上花再多时间优化 prompt 和框架，效果都无法归因、无法复现。切到透明工具链后，每次调优都能看到效果，迭代速度指数级提升。

> 往长远看，AI 编码工具会越来越同质化，团队之间的差距不在于用什么工具，而在于积累了多少高质量的、结构化的领域知识。这才是真正不可复制的护城河。一个没有 knowledge/ 的 Spec 框架，就像让一个刚入职的应届生对着编码规范写代码——规范他都能遵守，但业务逻辑全靠猜。

## 涉及实体
- Claude Code（Anthropic 官方终端 AI 编码 Agent）
- opencode（开源终端 AI 编码 Agent）
- Cursor / Windsurf（IDE 内交互式 AI 搭档）
- Cline / Aider（终端/IDE 插件）
- Chatbot Arena / LMSYS（模型评测平台）
- Gemini 3.1 Pro、Claude Sonnet 4.6（模型）
- 《人月神话》（Frederick Brooks）
- Superpowers（agentic skills 框架）
- Simon Willison（Agentic Engineering Patterns）

## 涉及主题
- [[AI编码]]
- [[Spec驱动开发]]
- [[提示工程]]
