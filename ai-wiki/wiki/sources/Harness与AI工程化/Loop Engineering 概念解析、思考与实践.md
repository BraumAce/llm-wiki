---
title: "Loop Engineering 概念解析、思考与实践"
type: source
date: 2026-06-19
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/ael7aIEoomk4AU84E-mpGg"
author: "阿里技术"
ingested_at: 2026-06-19
tags:
  - loop-engineering
  - automation
  - agent-loop
  - human-in-the-loop
  - skill
related_entities:
  - "[[Loop-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Generator-Evaluator]]"
  - "[[OpenClaw-Skills]]"
  - "[[Claude-Code]]"
  - "[[MCP]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
  - "[[Agentic-Engineering-主题]]"
  - "[[AI-Skill体系-主题]]"
---

# Loop Engineering 概念解析、思考与实践

## 一句话概括

这篇把底层 Agent Loop 与上层 [[Loop-Engineering]] 区分开：前者是 LLM 工具调用的基础执行循环，后者是把开发、验证、反馈、调优和沉淀写成自动化闭环，让人从"持续催模型"变成"定义目标与验收标准"。

## 实践内容

### Agent Loop vs Loop Engineering

| 概念 | 位置 | 关注点 |
|---|---|---|
| Agent Loop | Agent 内部执行机制 | 模型输出 function call -> 工具执行 -> observation 回灌 -> 下一轮 |
| Loop Engineering | Harness 之上的外部闭环 | 需求、执行、验证、反馈、调优、沉淀如何自动循环 |

### Loop 六个组成部分

- **Automations**：定时或事件触发，让 Loop 不只是手动跑一次。
- **Worktrees**：多 Agent 并行时用独立工作树隔离修改。
- **Skills**：把可复用流程和经验做成可进化能力包。
- **Connectors / Plugins**：通过 [[MCP]] 或插件连接外部系统。
- **Sub Agents**：主 Agent 交付后，独立验收 Agent 检查产出，避免自评偏差。
- **State**：用 Markdown、Linear 或外部系统记录哪些事已完成，支撑恢复和追踪。

### 文本分类 Loop 示例

```text
请完成文本分类，分类标准为 1/2/3/4/5；
完成后，严格按照标准对结果进行自评；
若发现错误，请主动修正分类逻辑或标准，直到满足要求；
最终将稳定的分类能力沉淀为 Skill。

量化目标：100 条测试数据准确率 >= 95%，或错误率 <= 5%。
```

### 使用边界

- 固定、无需模型每天重新推理的流程，应沉淀为脚本。
- 需要模型做动态判断的流程，应沉淀为 Skill 或定时 Loop。
- Loop 对需求描述和验证标准要求更高；需求模糊时，Human-in-the-Loop 反而更稳、更省成本。

## 摘录

> 大佬们说的这个 Loop，跟底层 Agent Loop 完全不是一回事。底层的 Agent Loop 是 Agent 最核心的基础循环，现在已经是默认基础设施；而 Loop Engineering 是构建在 Agent 或 Harness 之上的，由人来设计和控制 Agent 使用方式的新范式。

> 用 Loop 的时候，需求和验证标准必须比原来写得更加明确。因为以前提需求哪怕模糊一点也没关系，人在 Human-in-the-Loop 的过程中可以不断纠偏；但用了 Loop 之后，中间过程人不参与，如果开头没把需求和验证逻辑定义明白，Loop 很可能从一开始就跑偏。

## 涉及实体

- [[Loop-Engineering]] —— 本文提供中文语境下的概念辨析、组成框架和实践边界。
- [[Harness-Engineering]] —— Loop 构建在 Harness 之上，依赖工具、验证、状态和边界。
- [[Generator-Evaluator]] —— 独立验收 Sub Agent 是 Loop 质量门禁。
- [[OpenClaw-Skills]] —— 成熟 Loop 应把稳定能力沉淀为 Skill。
- [[Claude-Code]] —— 文中提到 `/loop`、cron、hook、`/goal` 等 Loop 原语。
- [[MCP]] —— Connectors / Plugins 是 Loop 触达外部系统的手段。

## 涉及主题

- [[Harness-Engineering-主题]]
- [[Agentic-Engineering-主题]]
- [[AI-Skill体系-主题]]

## 我的评注

这篇和已有"循环工程橙皮书"互补：橙皮书偏概念源流和系统栈，这篇强调普通任务里的实践边界。最重要的判断是"不要为了 Loop 而 Loop"：固定流程脚本化，动态判断 Skill 化，验证标准不清时保留人在环。
