---
title: "Prompting guidance for GPT-5.6 Sol"
type: source
date: 2026-07-15
source_type: webpage
source_url: "https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6"
author: "OpenAI"
ingested_at: 2026-07-15
tags: [gpt-5.6, prompting, agent, tool-routing, evals]
related_entities: ["[[GPT-5.6]]", "[[Prompt分层组合架构]]", "[[Harness-Engineering]]"]
related_topics: ["[[Harness-Engineering-主题]]"]
---

# Prompting guidance for GPT-5.6 Sol

## 一句话概括

OpenAI 的 GPT-5.6 Prompt 指南把“更长、更细的系统提示”改写为可验证的提示词契约：先声明用户可见结果、证据和停止条件，删去冗余规则与无关工具，再用代表性评测验证每一处小改动。

## 实践内容

以下是原文给出的 outcome-first 约束示例；可作为 Agent 提示词中的完成定义：

```text
Resolve the customer's issue end to end.

Success means:
- make the eligibility decision from available policy and account evidence
- complete any allowed action before responding
- return completed_actions, customer_message, and blockers
- if required evidence is missing, ask for the smallest missing field
```

以下是原文的停止条件示例：

```text
Resolve the request in the fewest useful tool loops, but do not let loop
minimization outrank correctness, required evidence, calculations, or
required citations.

After each result, ask whether the core request can now be answered with
useful evidence. If yes, answer. If required evidence is still missing,
name the missing fact and use the smallest useful fallback.
```

原文的迁移顺序是：先切换模型并保留当前 reasoning effort；以代表性 eval 建立基线；逐项去除过时脚手架、重复指令与无关工具；仅为已测得的回归添加最小定向指令；每次改 prompt 或 reasoning 后复跑同一评测。PTC 只适用于可被程序过滤、去重、聚合或确定性验证的有界中间阶段；涉及审批、语义判断、引用和最终验证时，回到直接工具调用。

## 摘录

> GPT-5.6 works best when prompts define the outcome, important constraints, available evidence, and completion bar, then leave room for the model to choose an efficient path. Removing repeated instructions and examples and simplifying tool descriptions can improve task performance and token efficiency. In a sample of internal coding-agent eval runs, configurations with leaner system prompts improved evaluation scores by roughly 10–15% while reducing total tokens by 41–66% and cost by 33–67%. Results will vary by workload, so treat these ranges as directional and validate changes on representative tasks from your own application.

> Start with a prompt and tool set that already works. Remove one group of instructions, examples, or tools at a time, then rerun the same evals. Keep the user-visible outcome; success criteria and stopping conditions; safety, business, evidence, and permission constraints; tool-routing rules when the route depends on context; and required output shape and validation requirements. Review the remaining instructions for contradictions. GPT-5-class models follow prompt contracts closely, so conflicting rules can create more instability than missing detail.

> Programmatic Tool Calling works best for bounded workflows where code can process several tool results or large intermediate outputs and return a much smaller structured result. Prefer direct tool calls when each result may change the next decision, an action requires approval, the final answer must preserve citations or native artifacts, or the workflow requires semantic judgment between calls. Compare direct and programmatic calling on representative tasks, and count lower resource use as an improvement only when the response still passes existing evals.

## 涉及实体

- [[GPT-5.6]] —— 本文对应的模型家族及其 prompt 迁移边界。
- [[Prompt分层组合架构]] —— 两者都将稳定契约、任务要求和上下文/工具信息分开管理，并反对无效冗余。
- [[Harness-Engineering]] —— 完成条件、权限边界、工具路由和验证循环共同构成 Agent 的运行约束。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这份指南最有价值的不是某条固定模板，而是“删除也必须可证”的迭代纪律：精简提示词并不等于删约束。用户可见目标、验证门槛、证据与权限边界、工具路由和停止条件都是契约核心；是否删掉某项要由同一批真实任务评测决定。它与本库既有的分层 Prompt 结构兼容，但额外强调不要把流程细节和绝对词当成默认安全感来源。
