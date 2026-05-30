---
title: "你不知道的 Agent：原理、架构与工程实践"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/cIQYl9Wr1Eov4ma-_bYh-w"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags: [agent, llm-agent, architecture, engineering-practice, prompt-engineering]
related_entities: []
related_topics: [[AI Agent]], [[LLM应用架构]], [[Prompt Engineering]]
---

# 你不知道的 Agent：原理、架构与工程实践

## 一句话概括
一篇深入探讨 AI Agent 原理、系统架构设计与工程落地实践的技术文章。

## 实践内容

### Agent Loop 核心实现

Agent Loop 核心逻辑不到 20 行代码：消息数组初始化后进入 while 循环，调用模型，若 stop_reason 为 tool_use 则并行执行工具并将结果追回 messages，否则返回纯文本。新能力通过三种方式接入：扩展工具集和 handler、调整系统提示结构、将状态外化到文件或数据库。循环体本身不应变成巨大状态机——模型负责推理，外部系统负责状态和边界。

### Workflow vs Agent 区分

Anthropic 的区分：执行路径由代码预先写死的是 Workflow，由 LLM 动态决定下一步的是 Agent。核心区别在于控制权掌握在谁手里。维度对比：控制权（代码预定义 vs LLM 动态决策）、执行方式（工具顺序固定 vs 按需选择）、状态与记忆（显式状态机 vs 隐式上下文）、维护成本（改代码重部署 vs 调整系统提示）、可观测性（日志定位节点 vs 完整执行记录）。

### 五种常见控制模式

1. **提示链 Prompt Chaining**：任务拆成顺序步骤，每步 LLM 处理上一步输出，中间可加代码检查点
2. **路由 Routing**：对输入分类定向到对应专用处理流程，简单问题走轻量模型，复杂问题走强模型
3. **并行 Parallelization**：分段法拆独立子任务并发跑，投票法同一任务跑多次取共识
4. **编排器-工作者 Orchestrator-Workers**：中央 LLM 动态分解任务委派给工作者 LLM，综合结果
5. **评估器-优化器 Evaluator-Optimizer**：生成器产出，评估器给反馈，循环直到达标

### Harness 比模型更关键

Harness 包括验收基线、执行边界、反馈信号和回退手段。OpenAI 实践：3 个工程师 5 个月百万行代码、近 1500 个 PR。关键工程决策：
- Agent 看不到的内容等于不存在：知识必须存在于代码库本身，AGENTS.md 只保留约 100 行作为索引
- 约束编码化而非文档化：写进 Linter、类型系统或 CI 规则的约束才具备可执行性
- Agent 端到端自主完成任务：从验证状态、复现 Bug、实现修复、驱动验证到开 PR 全链路不需要人介入
- 最小化合并阻力：测试偶发失败用重跑处理而不是阻塞进度

任务四象限：右上角（目标明确+结果可自动验证）最适合 Agent 发挥。Harness 要做的就是把任务推进右上角。

### 上下文工程与稳定性

Transformer 注意力复杂度 O(n²)，上下文越长关键信号越容易被噪声稀释（Context Rot）。分层管理：
- **常驻层**：身份定义、项目约定、绝对禁止项，保持短、硬、可执行
- **按需加载**：Skills 和领域知识，描述符常驻，完整内容触发时再注入
- **运行时注入**：当前时间、渠道 ID、用户偏好等动态信息
- **记忆层**：跨会话经验写入 MEMORY.md，不直接进系统提示
- **系统层**：Hooks 或代码规则处理确定性逻辑，完全不进上下文

三种压缩策略：滑动窗口（极低成本，丢早期上下文）、LLM 摘要（中成本，保留决策）、工具结果替换（极低成本，丢工具原始输出）。Prompt Caching 原理：精确前缀匹配的 KV 可直接从缓存读取，写入成本只付一次，后续读取折扣可达 90%。

### Skills 按需加载设计

系统提示只保留索引，完整知识按需加载。Skill 描述要足够短（约 9 tokens vs 45 tokens），要像路由条件而不是功能介绍。没有反例时准确率从 73% 掉到 53%，加上反例后升到 85%，响应时间降 18.1%。常驻系统提示只放高频 Skill，低频手动引入，极低频用文档替代。Cursor 验证：工具描述同步到文件夹，Agent 默认只看工具名，A/B 测试中 MCP 工具任务总 token 消耗减少 46.9%。

### 工具设计演进

三代演进：
1. **API 封装**：每个 API Endpoint 对应一个工具，粒度过细
2. **ACI（Agent-Computer Interface）**：工具对应 Agent 目标而非底层 API 操作
3. **Advanced Tool Use**：Tool Search 动态发现（准确率从 49% 提升到 74%）、Programmatic Tool Calling 代码编排（token 从约 150,000 降到约 2,000）、Tool Use Examples 示例驱动（准确率从 72% 提升到 90%）

ACI 原则：用 betaZodTool 把定义和实现绑在一起，参数描述直接约束格式，错误结构化给出修正建议。调试 Agent 时应优先检查工具定义，多数工具选择错误出在描述不准确。

### 记忆系统设计

四种记忆：工作记忆（上下文窗口，当前任务最小信息）、程序性记忆（Skills，按需加载）、情景记忆（JSONL 会话历史，磁盘持久化支持跨会话检索）、语义记忆（MEMORY.md，Agent 主动写入的重要事实）。

ChatGPT 四层记忆：Session Metadata（会话级）、User Memory（约 33 条关键偏好事实）、Conversation Summary（约 15 个最近对话摘要）、Current Session（滑动窗口）。未使用向量数据库或 RAG。

OpenClaw 混合检索：memory/YYYY-MM-DD.md 追加写日志保留原始细节，MEMORY.md 精选事实，memory_search 70% 向量相似度 + 30% 关键词权重混合检索。记忆整合触发阈值为 tokenUsage/maxTokens >= 0.5，失败路径把原始消息写入 archive/ 保留完整历史。

### 长任务跨 session 继续

Initializer Agent 只在第一轮运行，负责生成 feature-list.json、init.sh、初始 git commit 和 claude-progress.txt，把任务变成可持久化的外部状态。后续多个 session 由 Coding Agent 接力执行。

## 摘录

> Agent Loop 的核心实现逻辑抽象后其实不到 20 行代码。新能力基本只通过三种方式接入：扩展工具集和 handler、调整系统提示结构、把状态外化到文件或数据库，不应该让循环体本身变成一个巨大的状态机，模型负责推理，外部系统负责状态和边界，一旦这个分工确定下来，核心循环逻辑就很少需要频繁调整了。

> Harness 是指围绕 Agent 构建的测试、验证与约束基础设施，这里的 Harness 至少包括四个部分：验收基线、执行边界、反馈信号和回退手段。模型虽然重要，但决定系统能不能稳定运行的，往往是这些外围工程条件。

> 约束编码化而非文档化：写在文档里的规范很容易被忽略，编码进 Linter、类型系统或 CI 规则里的约束才具备可执行性，架构分层靠自定义 Linter 机械强制，不靠人工 Review。

> 上下文为什么要分层？问题通常不是窗口不够长，而是信息密度不对，偶尔用的东西每次都加载进来，稳定的规则和动态的状态混在一起，模型能看到的内容越来越多，但真正有用的部分越来越难被注意到。

> 工具定义的质量比数量更关键，仅 5 个 MCP 服务器就可能带来约 55,000 tokens 的工具定义开销，相当于在 200K 上下文里还没开始对话就用掉了近三成，工具一旦过多，模型对单个工具的注意力也会被稀释。

> 没有反例时准确率从基准 73% 掉到 53%，加上反例后升到 85%，响应时间还降了 18.1%。反例不是可选项，是 Skill 描述能不能起作用的关键。

> Agent 不具备原生的时间连续性，会话结束后，上下文随之清空，下一次启动时也不会自动保留此前状态，要让系统具备跨会话的一致性，记忆层得单独设计，对 Agent 来说它是一层基础设施，不是可以事后补上的能力。

> 调试 Agent 时应先检查工具定义，大多数工具选择错误的原因出在描述不准确，不在模型能力，工具数量也要克制，能用 Shell 处理的、只需静态知识的、更适合 Skill 的，都不需要新增工具。

## 涉及实体

## 涉及主题
- [[AI Agent]] —— 文章核心主题，探讨 Agent 的原理与实现
- [[LLM应用架构]] —— Agent 的系统架构设计
- [[Prompt Engineering]] —— Agent 构建中的提示工程实践
