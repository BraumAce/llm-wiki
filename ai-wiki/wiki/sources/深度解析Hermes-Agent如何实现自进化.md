---
title: "深度解析 Hermes Agent 如何实现自进化"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/2xFei8dMx99lc-iyrZZrww"
author: "阿里云开发者 / 飞樰"
published_at: "2026-05-30"
ingested_at: 2026-05-30
tags:
  - hermes-agent
  - self-evolving
  - skill-generation
  - reinforcement-learning
  - agent-trajectory
  - context-engineering
  - prompt-engineering
related_entities:
  - "[[Hermes Agent]]"
  - "[[Nous Research]]"
  - "[[OpenClaw]]"
  - "[[Claude Code]]"
  - "[[ShareGPT]]"
  - "[[LLaMA-Factory]]"
  - "[[Andrej Karpathy]]"
related_topics:
  - "[[Agent自进化]]"
  - "[[Skill动态生成]]"
  - "[[强化学习训练闭环]]"
  - "[[Agent轨迹捕获]]"
  - "[[Context Engineering]]"
  - "[[Harness Engineering]]"
---

# 深度解析 Hermes Agent 如何实现自进化

## 一句话概括

阿里云开发者公众号上由"飞樰"撰写的 [[Hermes Agent]] 源码深度解析，核心聚焦"自进化"（Self-Evolving）机制——通过**动态 Skill 生成**（从执行轨迹自动沉淀可复用技能）和**RL 训练闭环**（基于 ShareGPT 格式轨迹数据的强化学习微调）两条内外双路径驱动 Agent 越用越强，是继 OpenClaw、Claude Code 之后"项目深度解析"系列的第三篇。

## 实践内容

### Skill 催促触发机制（run_agent.py）

根目录下的 `run_agent.py` 中有一个"技能催促"计数器：

- `_iters_since_skill`：记录距离上次使用 `skill_manage` 工具过了多少轮
- `_skill_nudge_interval = 10`：当 Agent 连续工作了 10 轮对话都没有创建/修改技能时，系统会"提醒"Agent 把经验整理成技能

### 后台审查 Agent（_spawn_background_review）

每当主 Agent 完成对用户的回复后，通过 `_spawn_background_review` 在后台异步启动审查 Agent，从三个维度进行全方位审查：

- **记忆审查**（`_MEMORY_REVIEW_PROMPT`）：判断对话中是否蕴含值得长期保留的关键经验或事实，提炼长期记忆存入记忆库
- **技能审查**（`_SKILL_REVIEW_PROMPT`）：分析当前任务解决路径是否具有通用性，是否值得抽象并固化为可复用的 Skill
- **综合审查**（`_COMBINED_REVIEW_PROMPT`）：反思整个执行过程中是否存在优化空间或潜在的错误模式

### Agent 轨迹数据格式（ShareGPT）

```json
[
  {"from": "system", "value": "你是 Hermes Agent..."},
  {"from": "human", "value": "帮我部署这个应用"},
  {"from": "gpt", "value": "好的，我先检查环境..."},
  {"from": "tool", "value": ""},
  {"from": "tool", "value": "<tool_response>成功</tool_response>"},
  {"from": "gpt", "value": "部署完成！"}
]
```

使用 ShareGPT 格式的原因：整个生态（LLaMA-Factory、FastChat、OpenChat）都支持此格式。`"gpt"` 标签是历史遗留的行业约定，训练框架会将其映射到具体模型的 chat template 中正确的 assistant token。

### 轨迹 JSONL 数据格式

```json
{
  "conversations": [...],     // ShareGPT格式的对话
  "timestamp": "2025-04-11T10:30:00",
  "model": "anthropic/claude-4.6-opus",
  "completed": true
}
```

输出文件：
- `trajectory_samples.jsonl`：成功完成的轨迹
- `failed_trajectories.jsonl`：失败的轨迹

### 轨迹数据预处理（agent/trajectory.py）

三个核心函数：

1. `save_trajectory`：将 Agent 运行轨迹以追加模式持久化存储至 JSONL 文件，实现数据增量积累
2. `convert_scratchpad_to_think`：将内部使用的 `<REASONING_SCRATCHPAD>` 标签转换为模型训练通用的 `<think>` 格式，适配主流大模型的 CoT 训练要求
3. `has_incomplete_scratchpad`：检测推理标签完整性，过滤因截断导致的数据残缺

### 批量数据生成（batch_runner.py）

`batch_runner.py` 是"自进化"的主力数据工厂：

1. **准备提示词**：人工准备 JSONL 格式提示词文件（如 `{"prompt": "请帮我搜索AI领域的最新进展"}`），或从 Benchmark 数据集采集（GSM8K、HumanEval 等）
2. **并行处理**：用线程池并行处理每条提示词，每条创建独立 Agent 实例
3. **Teacher 模型生成**：默认使用 `anthropic/claude-opus-4.6` 作为 Teacher 模型执行完整 Agent 对话
4. **录制轨迹**：将 Teacher 模型的完整对话过程转化为 ShareGPT 格式训练数据
5. **工具集随机采样**：随机采样不同工具组合，训练数据包含各种工具搭配场景，模型学会灵活运用而非死记硬背
6. **零推理过滤的质量控制**：通过 `_extract_reasoning_stats` 统计 `<REASONING_SCRATCHPAD>` 和 `reasoning` 字段出现次数，两者都为零则丢弃该样本

### RL 训练闭环流程

1. **任务定义**：用户指定训练目标（如"提升数学推理能力"），系统选择可用训练数据/Benchmark 或用户提供数据集
2. **轨迹捕获 & 批量数据合成**：`batch_runner.py` 自动合成 Agent 运行轨迹，筛选高质量数据集，清洗转换为 ShareGPT 格式
3. **渐进式训练与自动评估**：先小规模实验验证可行性，再启动正式大规模训练；训练结束后自动评估，效果未达预期则反馈指导下一轮参数调整
4. **领域内局部最优解**：通过奖励机制（Reward Model），模型针对特定场景下的正确行为获得正向反馈，达到该场景下的局部最优解

## 摘录

> 之前我在分析 OpenClaw 的时候，可以发现其上下文管理策略主要服务于"当前会话"的稳定性：它通过压缩上下文来防止 Context Window 爆炸，并通过记录 Memory 来记住关键事实或日常事件，来避免后续对话中的遗忘。然而，这种设计下，只解决了 Context 的容量问题，Agent 的执行过程依然存在一个明显的短板——它是"无状态"的。当 OpenClaw 完成一个任务后，无论过程中走了多少弯路、犯了多少错误，亦或是经过了多少次自我纠正甚至人工引导才最终成功，这些宝贵的"试错经验"都很难被沉淀下来。

> Hermes Agent 之所以可以做到"自进化"，最主要就是依赖于两条路径：一是日常的自动 Skill 生成（Skill Generation），可以快速、轻量、即时生效；二是可以手动触发的 RL 训练（Reinforcement Learning），从更深度、根本上改变模型本身的能力。这两种路径共同构成了 Hermes Agent 的"内外"双轮驱动的"自进化闭环"。

> 虽然通过动态生成 Skill 沉淀实现的"外挂式"进化在时效性和可解释性上表现优异——毕竟明文记录的 Markdown 文件允许人工进来进行干预和纠偏，确保 Agent 不会在错误的道路上越走越远——但我们必须承认一个事实：这并不是真正意义上的"自进化"或者"自我学习"。因为无论 Agent 积累了多少 Skill，其底层的"模型权重"始终没变。它只是在不断地检索外部知识库，而非将经验内化为自身的直觉与能力。

## 涉及实体

- [[Hermes Agent]] —— 本文核心分析对象，Nous Research 推出的开源 Agent 项目，主打"持久运行"和"自进化"
- [[Nous Research]] —— Hermes Agent 的开发者，美国开源人工智能研究机构
- [[OpenClaw]] —— 作为对比对象，Hermes 的前身/竞品，支持从 OpenClaw 无缝迁移
- [[Claude Code]] —— 系列文章的第二个深度解析对象，与 Hermes 有相似的 Prompt/Context/Harness 设计
- [[ShareGPT]] —— Hermes 自进化 Pipeline 使用的统一数据格式，LLaMA-Factory/FastChat/OpenChat 等生态均支持
- [[LLaMA-Factory]] —— 支持 ShareGPT 格式的主流训练框架之一
- [[Andrej Karpathy]] —— 其开源项目 AutoResearch 与 Hermes 的 RL 训练闭环有相似之处

## 涉及主题

- [[Agent自进化]] —— Hermes 的核心差异化能力，通过 Skill 生成 + RL 训练双路径实现
- [[Skill动态生成]] —— 从"静态调用"到"动态生成"的 Skill 机制变革，基于执行轨迹自动沉淀可复用技能
- [[强化学习训练闭环]] —— 从数据合成、质量筛选到 RL 训练、自动评估的完整闭环
- [[Agent轨迹捕获]] —— Agent 完成任务的完整对话记录，用于 Skill 生成和 RL 训练的数据源
- [[Context Engineering]] —— Hermes 与 OpenClaw/Claude Code 的共性设计维度
- [[Harness Engineering]] —— Hermes 与 OpenClaw/Claude Code 的共性设计维度
