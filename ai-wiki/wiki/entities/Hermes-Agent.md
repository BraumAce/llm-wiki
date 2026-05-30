---
title: "Hermes Agent"
type: entity
date: 2026-05-30
also_known_as:
  - "Hermes"
  - "Hermes Agent 框架"
  - "Nous Hermes Agent"
tags:
  - agent
  - open-source
  - self-evolving
  - skill-generation
  - reinforcement-learning
  - harness-engineering
  - context-engineering
  - trajectory
sources:
  - "[[深度解析Hermes-Agent如何实现自进化]]"
  - "[[一文搞懂Hermes-新顶流Agent如何从经验中自我进化]]"
  - "[[深入源码-Hermes-Agent如何实现Self-Improving]]"
  - "[[Harness-Engineering-来龙去脉]]"
  - "[[Agent从一问一答到自主执行面临哪些挑战]]"
  - "[[Agent核心技术概念与范式发生了哪些演变]]"
  - "[[深度解析LLM-Wiki-Obsidian-Wiki-GBrain]]"
related_entities:
  - "[[OpenClaw]]"
  - "Claude Code"
  - "Nous Research"
  - "[[Harness-Engineering]]"
  - "ShareGPT"
  - "LLaMA-Factory"
  - "Andrej Karpathy"
  - "Context-Engineering"
---

# Hermes Agent

## 一句话定义

Hermes Agent 是 Nous Research 开源的自进化 AI Agent 框架，其核心创新在于内置学习闭环——任务完成后自主创建 Skill、在后续使用中持续改进、跨会话持久化知识并构建用户画像，实现从"每次对话归零"到"越用越聪明"的跨越。

## 摘要

Hermes Agent 是 2026 年由美国开源人工智能研究机构 Nous Research 推出的 AI Agent 项目，主打"持久运行"和"自进化"。与大多数每次对话从零开始的无状态 Agent 不同，Hermes 通过两条路径驱动自进化：一是日常的自动 Skill 生成（Skill Generation），从 Agent 执行轨迹中自动沉淀可复用技能，快速、轻量、即时生效；二是可手动触发的 RL 训练（Reinforcement Learning），基于 ShareGPT 格式的轨迹数据进行强化学习微调，从根本上改变模型本身的能力。这两种路径共同构成了 Hermes 的"内外双轮驱动"自进化闭环。在 Harness Engineering 的语境下，Hermes Agent 与 OpenClaw 并列为两种典型的实现路径，代表了不同的设计选择。Hermes 支持 Nous Portal、OpenRouter（200+ 模型）、NovitaAI、NVIDIA NIM、OpenAI 等多种模型供应商，提供 local、Docker、SSH、Singularity、Modal、Daytona 六种运行时后端，并提供从 OpenClaw 的一键迁移工具。

## 详情

### 起源与背景

Hermes Agent 由 Nous Research 开发维护。Nous Research 是一家美国开源人工智能研究机构，同时维护 Nous Portal 统一模型订阅平台。Hermes 的出现标志着 Agent 技术从"自主 Agent"阶段向"自进化 Agent"阶段的跃迁。

在此之前，以 OpenClaw 为代表的自主 Agent 已经解决了长程任务执行、工具调用、上下文压缩等问题，但其执行过程本质上是"无状态"的——当 Agent 完成一个任务后，无论过程中走了多少弯路、犯了多少错误，这些宝贵的"试错经验"都很难被沉淀下来。OpenClaw 的上下文管理策略主要服务于"当前会话"的稳定性，通过压缩上下文来防止 Context Window 爆炸，通过记录 Memory 来记住关键事实，但 Agent 的模型权重始终不变，它只是在不断检索外部知识库，而非将经验内化为自身能力。

Hermes Agent 正是为了解决这一痛点而生。它引入了自进化机制，试图让 Agent 不再仅仅被动地接收人类编写的 Skill，而是能够在交互过程中自动从历史对话、成功/失败案例中提取模式，自动生成或优化新的 Skill。Hermes 还提供了从 OpenClaw 的一键迁移工具 `hermes claw migrate`，可以迁移 SOUL.md 人格文件、记忆（MEMORY.md 和 USER.md）、用户自建 Skill、命令白名单、消息设置、API 密钥、TTS 资产和工作区指令（AGENTS.md）等。

### 核心机制 / 工作原理

Hermes Agent 的自进化机制依赖两条路径：Skill 生成（外挂式进化）和 RL 训练（内化式进化）。

**路径一：自动 Skill 生成**

Hermes 在根目录的 `run_agent.py` 中实现了"技能催促"（Skill Nudge）机制。系统维护一个 `_iters_since_skill` 计数器，记录距离上次使用 `skill_manage` 工具过了多少轮对话。当 Agent 连续工作了 `_skill_nudge_interval = 10` 轮都没有创建或修改技能时，系统会主动"提醒"Agent 把经验整理成技能。

每当主 Agent 完成对用户的回复后，系统通过 `_spawn_background_review` 在后台异步启动审查 Agent，从三个维度进行全方位审查：

- **记忆审查**（`_MEMORY_REVIEW_PROMPT`）：判断对话中是否蕴含值得长期保留的关键经验或事实，提炼长期记忆存入记忆库
- **技能审查**（`_SKILL_REVIEW_PROMPT`）：分析当前任务解决路径是否具有通用性，是否值得抽象并固化为可复用的 Skill
- **综合审查**（`_COMBINED_REVIEW_PROMPT`）：反思整个执行过程中是否存在优化空间或潜在的错误模式

这种动态生成的 Skill 以明文 Markdown 文件存储，允许人工干预和纠偏，确保 Agent 不会在错误的道路上越走越远。但必须承认，这并不是真正意义上的"自进化"——无论 Agent 积累了多少 Skill，其底层的模型权重始终没变，它只是在不断检索外部知识库，而非将经验内化为自身的直觉与能力。

**路径二：RL 训练闭环**

Hermes 将 Agent 运行轨迹以 ShareGPT 格式持久化存储，构建完整的强化学习训练闭环：

1. **轨迹捕获**：Agent/trajectory.py 中的 `save_trajectory` 函数以追加模式将运行轨迹存储至 JSONL 文件，同时通过 `convert_scratchpad_to_think` 将内部的 `<REASONING_SCRATCHPAD>` 标签转换为模型训练通用的 `<think>` 格式
2. **批量数据生成**：batch_runner.py 作为"自进化"的主力数据工厂，支持从人工准备的提示词或 Benchmark 数据集（GSM8K、HumanEval 等）出发，用线程池并行处理，以 Teacher 模型（默认 anthropic/claude-opus-4.6）执行完整 Agent 对话并录制轨迹
3. **质量控制**：通过零推理过滤，统计推理字段出现次数，两者都为零则丢弃该样本；同时进行工具集随机采样，训练数据包含各种工具搭配场景
4. **渐进式训练**：先小规模实验验证可行性，再启动正式大规模训练；训练结束后自动评估，效果未达预期则反馈指导下一轮参数调整

输出文件分为 `trajectory_samples.jsonl`（成功轨迹）和 `failed_trajectories.jsonl`（失败轨迹），使用 ShareGPT 格式是因为 LLaMA-Factory、FastChat、OpenChat 等主流训练框架均支持此格式。

**多平台模型支持**

Hermes 支持 Nous Portal、OpenRouter（200+ 模型）、NovitaAI、NVIDIA NIM、Xiaomi MiMo、z.ai/GLM、Kimi/Moonshot、MiniMax、Hugging Face、OpenAI 或自定义端点。通过 `hermes model` 命令切换，无需代码改动，无供应商锁定。

**六种运行时后端**

local、Docker、SSH、Singularity、Modal 和 Daytona。其中 Daytona 和 Modal 提供无服务器持久化，环境空闲时休眠，按需唤醒。

### 应用 / 使用场景

- **持续学习型开发助手**：在长期软件开发项目中，Agent 随着使用不断积累项目特定的编码规范、架构决策和调试经验，越用越贴合团队习惯
- **自动化运维与定时任务**：通过 Cron Job / Scheduled Task 驱动 Agent 定时运行，执行监控、日志分析、报告生成等重复性工作
- **知识密集型任务**：结合 Skill 自动沉淀机制，将领域专家的操作经验结构化为可复用的 Skill 包，降低新用户上手门槛
- **模型能力微调**：通过 RL 训练闭环，针对特定领域或 Benchmark 追求极致性能，适用于 AI 研究人员和算法工程师
- **从 OpenClaw 迁移**：提供一键迁移工具，降低从 OpenClaw 生态切换的成本

### 局限与争议

- **"自进化"的边界**：Skill 自动沉淀本质上是"外挂式"进化，底层模型权重不变。正如深度解析文章所指出的，"这并不是真正意义上的自进化或者自我学习"，Agent 只是在不断检索外部知识库，而非将经验内化为自身能力
- **Skill 自动生成的可控性**：自动沉淀 Skill 的机制取决于模型自身的判断和决策，触发时机和可控性相对较低，实际使用中未必能沉淀出高质量的 Skill
- **RL 训练门槛高**：强化学习训练面向 AI 研究人员或算法同学设计，对于大多数工程落地场景，门槛和成本都相对较高
- **单进程架构**：与 OpenClaw 类似，Hermes Agent 采用单进程架构，机器或进程挂掉后服务不可用，缺乏原生高可用能力
- **可观测性不足**：Hermes Agent 甚至没有任务的执行记录功能，需要去会话里查找，缺乏搜索过滤条件，运维排查困难
- **定时任务管理分散**：每个 Agent 都有独立的控制台来管理定时任务，大规模部署时管理成本高
- **资源利用率问题**：定时任务功能内嵌在 Agent 进程里，需要 Agent 常驻才能正常执行任务，对于低频调度场景造成资源浪费

## 与其他实体的关系

- [[OpenClaw]] —— 前身/竞品，Hermes 提供一键迁移工具 `hermes claw migrate`；两者在 Harness Engineering 语境下代表不同的实现路径
- Claude Code —— 同系列深度解析对象，与 Hermes 有相似的 Prompt/Context/Harness 设计维度
- Nous Research —— Hermes Agent 的开发团队，美国开源人工智能研究机构，同时维护 Nous Portal 统一模型订阅平台
- [[Harness-Engineering]] —— Hermes 是 Harness 理念的实现载体之一，Agent = Model + Harness 的具体落地
- Context-Engineering —— Hermes 与 OpenClaw/Claude Code 的共性设计维度，涉及上下文精细化管理和渐进式披露
- ShareGPT —— Hermes 自进化 Pipeline 使用的统一数据格式，LLaMA-Factory/FastChat/OpenChat 等生态均支持
- LLaMA-Factory —— 支持 ShareGPT 格式的主流训练框架之一，用于 Hermes 的 RL 训练流程
- Andrej Karpathy —— 其开源项目 AutoResearch 与 Hermes 的 RL 训练闭环有相似之处；其 LLM-Wiki 项目与 Hermes 的 Skill 自动沉淀理念相通

## 参考来源

- [[深度解析Hermes-Agent如何实现自进化]] —— 最详尽的源码级解析，聚焦 Skill 催促机制、后台审查 Agent、轨迹数据格式、批量数据生成和 RL 训练闭环
- [[一文搞懂Hermes-新顶流Agent如何从经验中自我进化]] —— 全景概述，涵盖安装、命令、Nous Portal 集成、六种运行时后端和 OpenClaw 迁移
- [[Harness-Engineering-来龙去脉]] —— 对比了 Hermes Agent 与 OpenClaw 两种 Harness 实现路径
- [[Agent从一问一答到自主执行面临哪些挑战]] —— 提及 Hermes Agent 在高可用、运维成本、权限管理和可观测性方面的痛点
- [[Agent核心技术概念与范式发生了哪些演变]] —— 将 Hermes 定位为"自进化 Agent"阶段的代表性框架
- [[深度解析LLM-Wiki-Obsidian-Wiki-GBrain]] —— 从 Knowledge Engineering 角度讨论 Hermes 的 Skill 自动沉淀与知识自进化

<!-- 写作要点：
1. 字数 >= 1500（中文字符）
2. 不允许出现 "TODO" / "XXX" / "待补充" / "TBD"
3. 至少 1 个 related、>= 1 个 sources，frontmatter sources 与正文一致
4. 多次 ingest 同一实体时合并扩展，不覆盖
-->
