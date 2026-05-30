---
title: "深入浅出Harness Engineering之核心模式与理念"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/8PwDQSX7ZX6HdDiW-H9Dzg"
author: "张碧泉"
ingested_at: 2026-05-30
tags: [harness-engineering, llm, prompt-engineering, ai-agent, core-patterns]
related_entities: []
related_topics:
  - Harness Engineering
  - LLM应用开发
  - AI Agent
---

# 深入浅出Harness Engineering之核心模式与理念

## 一句话概括
介绍 Harness Engineering（驾驭工程）的核心模式与理念，探讨如何系统性地组织和优化与大语言模型的协作流程。

## 实践内容
文章围绕Harness Engineering（驾驭工程）展开，系统介绍三大框架的工程模式：

**Claude Code 模式：**
- 持久化指令文件（CLAUDE.md）：让智能体跨会话保持一致行为
- 作用域上下文组装：按组织/项目拆分指令，动态加载最相关规则
- 分层记忆：三层记忆结构（常驻精华摘要、按需加载细节、可搜索完整历史）节省Token
- 做梦整理：后台对记忆去重清理重组，类似垃圾回收
- 渐进式上下文压缩：新对话保留细节，旧对话轻量总结，更早的压缩成简短摘要
- 工作流与编排：探索-规划-行动循环、上下文隔离子智能体、分支-合并并行
- 工具与权限：渐进式工具扩展、命令风险分类、单用途工具设计
- 自动化：确定性生命周期钩子

**Claude Managed Agents 模式：**
- 智能体三件套解耦：Claude（大脑）、Harness（双手）、Sandbox（工作台）
- Session为不可变事件流，Harness为无状态驱动循环，Sandbox为隔离执行环境
- 安全设计：凭证永不进沙盒，采用保险库(vault)+代理(proxy)架构
- 多智能体协作：多脑一手、一脑多手、多脑多手
- 上下文工程：压缩、记忆工具、裁剪三者协同
- 性能优化：将推理从容器解耦，首Token延迟降低60-90%

**Hermes 会进化智能体：**
- 五段式循环：规划→执行→观察→学习→适应
- 五层记忆架构：L1短期记忆、L2技能手册（SKILL.md）、L3知识库（向量存储语义检索）、L4用户建模（黑格尔辩证式）、L5工作日志（FTS5全文检索+LLM摘要）

## 摘录
> 将指令按不同范围（如组织、项目）拆分，让智能体能动态加载最相关的规则。代价：规则分散在多个文件，可读性变差，且不同范围规则可能冲突。

> 严格分为三步：只读探索、与用户对齐的规划、拥有写权限的执行，避免盲目操作。适用于不熟悉的代码库或复杂修改。代价：流程更慢，小任务会显得"笨重"。

> Session核心接口只有两个：记录事件（emitEvent()）和读取事件(getEvents())。它是只追加的日志，天然支持重放和状态恢复，赋予智能体容错能力。

> 采用保险库(vault) + 代理(proxy)架构：所有第三方凭证存储在独立的保险库中，Harness和Sandbox都无法直接访问。当需要调用外部工具时，通过代理从保险库按需获取凭证并执行请求。

> 解耦前，每次推理都需等待Sandbox容器完全启动。解耦后，编排层从Session日志拉取事件后，推理可立即开始，使得首Token延迟降低60-90%。

> 完成复杂任务（如涉及5次以上工具调用）后，自动生成SKILL.md文件，记录完整的解决步骤，形成可复用的流程。

## 涉及实体
- Harness Engineering —— 核心主题，指系统性驾驭LLM的工程方法论

## 涉及主题
- Harness Engineering
- LLM应用开发
- AI Agent
