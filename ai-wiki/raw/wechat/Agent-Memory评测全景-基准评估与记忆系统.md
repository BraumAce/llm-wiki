---
title: "Agent-Memory 评测全景：基准、评估与记忆系统（理论篇）"
source_url: https://mp.weixin.qq.com/s/JZhN6auXKOzEh3OHgkjrdw
author: 阿元（淘天集团·场景智能技术团队）
source: 大淘宝技术
fetched_at: 2026-06-03T18:12:00+08:00
---

本文系统梳理了Agent长期记忆能力的评测全景，涵盖基准数据集、评估框架与记忆系统三大核心维度。在基准方面，介绍了MUSE、LOCOMO等贴近真实交互的数据集；在评估方面，分析了MemoryAgentBench、LONGMEMEVAL及MemBench等框架，重点考察准确检索、长程理解、冲突解决及反思记忆等关键能力；在系统实现上对比了THEANINE、RMM、M3-Agent及Mem0等代表性方案的技术机制与性能表现。文章指出当前技术虽在检索准确性上有所进展，但在跨会话推理、动态更新及效率平衡上仍存瓶颈，并强调未来评测需统一口径，综合考量检索正确性、使用有效性、时间维度及成本约束，以真正指导工程落地。

## 引言

随着大语言模型（LLM）在对话系统与智能代理中的应用加深，长期记忆能力正成为影响真实效能的关键因素。尽管LLM擅长短上下文生成，但在多轮、跨会话甚至多模态交互中仍常出现遗忘、推理断裂与一致性缺失。如何构建、更新与检索长期记忆，使模型能持续保留关键信息并适应变化，已成为重要挑战。

近年研究从三条主线推进：一是提出更贴近真实交互的基准与数据集（如MUSE、LOCOMO），二是建立更系统的评估框架（如MemoryAgentBench、LONGMEMEVAL、MemBench），三是探索更有效的记忆方法与系统（如THEANINE、RMM、Mem0，以及面向多模态场景的M3-Agent）。

## 技术概况

### Memory Benchmark

| 来源 | 发表 | 被引次数 |
|------|------|---------|
| MUSE | Northeastern University · ACL 2025 | 5 |
| LOCOMO | University of North Carolina · ACL 2024 | 274 |

### Memory Evaluation

| 来源 | 发表 | 被引次数 |
|------|------|---------|
| MemoryAgentBench | UC San Diego · arxiv | 43 |
| LONGMEMEVAL | UCLA, Tencent · arxiv | 141 |
| MemBench | Huawei · ACL 2025 | 23 |

### Memory System

| 来源 | 发表 | 被引次数 |
|------|------|---------|
| THEANINE & TeaFarm | Yonsei University · NAACL 2025 | 23 |
| RMM | Google · ACL 2025 | 35 |
| M3-Agent | ByteDance-Seed · ICLR 2026 | 29 |
| Mem0 | mem0ai · ECAI 2026 | 222 |

## Memory Benchmark

### MUSE

《MUSE: A Multimodal Conversational Recommendation Dataset with Scenario-Grounded User Profiles》

- 特点：大模型生成对话，基于真实场景和VLM生成的用户画像
- 数量：7k个case，8.3w个对话
- 场景：对话推荐数据集，服装领域

数据集构建：
- 用户画像生成器：收集多样的真实场景，生成用户画像
- 模拟对话生成器：利用用户画像进行角色扮演，模拟用户与推荐助手之间的对话
- 对话优化器：通过重写和审查机制提升对话的多样性和质量

### LOCOMO

《Evaluating Very Long-Term Conversational Memory of LLM Agents》

- 特点：大模型生成对话，基于个性化角色和时间事件图来构建对话
- 数量：50个对话，每个对话平均300轮、9000个标记
- 场景：评估LLM处理长对话的记忆能力：问题回答、事件总结和多模态对话生成

数据集构建：
- 人物设定与时间事件图：获取初始人物设定，利用LLM扩展设定；每个agent构建的时间事件图包含多个事件，通过因果关系相互连接
- 反思与回应机制：每次会话结束，生成总结，存储为短期记忆；每次对话的单个回合，作为观察内容，存储为长期记忆
- 人工验证与编辑：人工对15%的对话回合进行了编辑，对19%的图像进行了替换或移除

实验结论：
- 具有有限上下文长度的LLM，对极长对话的理解较差。gpt-4-turbo表现最佳（32.4），但仍显著低于人类基准（87.9）
- 长上下文LLM能理解更长的叙述，但容易产生幻觉
- RAG将对话存储为观察内容时有效，随着检索观察数量的增加，性能改善减弱
- LLMs在理解长时间叙述和提取时间及因果关系方面存在困难

## Memory Evaluation

### MemoryAgentBench

《Evaluating Memory in LLM Agents via Incremental Multi-Turn Interactions》

识别出四个对记忆代理至关重要的核心能力：

1. **准确检索 (Accurate Retrieval, AR)**：从长对话历史中识别并检索重要信息的能力
2. **测试时学习 (Test-Time Learning, TTL)**：动态获取新技能的能力，无需额外训练
3. **长程理解 (Long-Range Understanding, LRU)**：在长对话中形成抽象的、高层次理解的能力
4. **冲突解决 (Conflict Resolution, CR)**：面对新旧信息冲突时，检测并解决矛盾的能力

评估了三种主要类型的记忆代理：
- 长上下文代理（Long-Context Agents）
- 检索增强生成（RAG）代理
- 代理记忆代理（Agentic Memory Agents）

实验结论：
- RAG方法在准确检索任务中表现优越
- 长上下文模型在测试时学习和长范围理解任务中表现最佳
- 所有现有方法在冲突解决任务上均表现不佳，尤其是在多跳场景中，准确率最高仅为6%

### LONGMEMEVAL

《LONGMEMEVAL: BENCHMARKING CHAT ASSISTANTS ON LONG-TERM INTERACTIVE MEMORY》

提出统一框架，优化记忆设计：
- **会话分解**：将每个会话分解为多个"轮次"，进一步提取摘要、关键短语或用户事实
- **事实增强的键扩展**：通过提取value中的摘要、关键短语、用户事实和时间戳事件来增强键
- **时间感知的查询扩展**：从文本中提取时间戳事件，从查询中推断时间范围并过滤

评估能力：信息提取、多会话推理、时间推理、知识更新和拒绝回答

结论：现有的商业聊天助手和长上下文LLM在LONGMEMEVAL基准上表现不佳，准确率下降30%至60%

### MemBench

《MemBench: Towards More Comprehensive Evaluation on the Memory of LLM-based Agents》

创新点：
- 区分**事实记忆**与**反思记忆**
- 引入**参与场景**与**观察场景**
- 多指标评估：记忆准确性、记忆召回率、记忆容量和记忆效率

## Memory System

### THEANINE & TeaFarm

《Towards Lifelong Dialogue Agents via Timeline-based Memory Management》

- 基于时间和因果关系的记忆图，保留重要的上下文信息
- 提出 TeaFarm 反事实评估基准：代理被"误导"生成错误响应，任务是通过正确引用过去的对话来避免被误导

### RMM

《In Prospect and Retrospect: Reflective Memory Management for Long-term Personalized Dialogue Agents》

提出了反思记忆管理（RMM）机制：
- **前瞻性反思**：通过将对话历史动态总结为主题基础的记忆表示，优化未来的检索能力
- **回顾性反思**：利用在线强化学习方法，基于LLMs生成的引用证据迭代精炼检索过程

### M3-Agent

《Seeing, Listening, Remembering, and Reasoning: A Multimodal Agent with Long-Term Memory》

- 具备长期记忆的多模态智能体框架，实时处理视觉和听觉输入构建和更新记忆
- 记忆以图形结构存储，每个节点代表一个独特的记忆项
- 通过强化学习优化，允许智能体在多轮交互中逐步获取信息
- M3-Bench：100个真实世界视频 + 929个网络视频
- 实验：M3-Agent在M3-Bench-robot、M3-Bench-web和VideoMME-long上的准确率分别提高了6.7%、7.7%和5.3%

### Mem0

《Mem0: Building Production-Ready AI Agents with Scalable Long-Term Memory》

提出Mem0和Mem0g两种记忆架构：
- **Mem0**：动态捕获、组织和检索对话中的显著信息。提取阶段利用对话摘要和最近消息建立上下文；更新阶段评估候选事实与现有记忆的一致性
- **Mem0g**：引入图形记忆表示，将记忆表示为有向标记图，节点代表实体，边表示实体之间的关系

实验结果：
- Mem0在单跳和多跳推理任务中表现出色
- Mem0g在时间推理和开放域任务中表现出色
- 两者在响应延迟和计算效率方面显著优于全上下文方法

## 总结与讨论

Agent-Memory 评测不应止于"跑分排名"，而应回答三件事：**记什么、怎么记、是否带来可量化的任务收益**。

现有评测的共性问题：
1. 增益难归因（记忆、长上下文、RAG 常叠加）
2. 口径不统一，易"命中但无用"，指标与端到端收益脱钩
3. 动态更新与遗忘覆盖不足，缺少长期压力测试
4. 成本与约束缺位（时延、token/调用、存储、隐私合规）

面向真实应用，更可用的评测应同时覆盖四个维度：**检索正确性、使用有效性、时间维度（跨会话/变化/遗忘）、成本维度（延迟/费用/存储/合规）**。
