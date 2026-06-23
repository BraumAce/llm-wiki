---
title: "Agent评测方法论"
type: topic
date: 2026-06-06
tags:
  - agent-evaluation
  - llm-as-judge
  - harness-engineering
  - quality-assurance
sources:
  - "[[基于顶级Agent的Harness工程搭建式业务Agent评测方案]]"
  - "[[Prompt评估体系]]"
  - "[[Agent-Memory评测全景-基准评估与记忆系统]]"
  - "[[AI-Agent-Skill-测评方案及落地实践]]"
  - "[[AI Evals的一些实践：如何从 0 到 1 构建 agent 的评测系统？]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Claude-Code]]"
  - "[[Anthropic]]"
  - "[[Prompt评估体系]]"
  - "[[Generator-Evaluator]]"
---

# Agent 评测方法论

## 核心要点

1. **评测 Harness 的本质是结构化的评估规则 + 执行流程**——传统做法编码为 Python 脚本，Harness 式做法编码为 Agent 提示词。更灵活、更可读、更易迭代。

2. **用强 Agent 评测弱 Agent**——让 Claude Code 作为 Harness 搭建者，负责评测方案设计、数据处理、评测 Agent 提示词编写、结果分析。人只需做 GT 标注和关键决策。

3. **三层指标框架（L1/L2/L3）**——L1 通用基础（格式合规率、字段完整率）；L2 按能力类型选用（分类准确率、召回率/精确率、MAE、LLM-as-Judge）；L3 Agent 专属指标。

4. **评测 Agent 的迭代同样重要**——评测系统 bug ≠ 被测 Agent bug。常见坑：匹配逻辑过严、硬编码规则误报、Token 截断、GT 覆盖缺口。迭代节奏：v1 跑通 → v2 跑批模式 → v3+ 持续调优。

5. **LLM-as-Judge 的 rubric 设计**——每个分值必须有具体、可区分的判定标准，避免"好/较好/一般"这类主观描述。分值之间的差异应该一个正常人也能判断。

6. **评测集设计原则**——小而精（20-55 条覆盖边界即可）、分布均衡、GT 可复核、版本化管理。

7. **"评测 Agent 调被测 Agent"的技巧**——评测 Agent 忘记调用工具（在 Constraints 强调）、工具参数传递失败（显式写明参数构造逻辑）、评测 Agent 重试耗尽 token（添加"禁止重试"约束）。

8. **效率提升数据**——单 Agent 全流程从 ~1.5 周压缩到 ~1-2 天（~5x），一人 + CC 完成原来需要测试开发 + 数据标注 + 分析师的工作。

9. **与 OpenAI Evals 的关系**——理念类似，但 Harness 式评测更轻量、更灵活、无需工程部署。

10. **适用场景**——Prompt 迭代验证（⭐⭐⭐⭐⭐）、多 Agent 横向对比（⭐⭐⭐⭐⭐）、新 Agent 上线前验收（⭐⭐⭐⭐）、线上问题复盘（⭐⭐⭐）。

11. **Agent/Skill 生产级评测要同时覆盖过程与结果**：腾讯技术工程把评测拆成确定性评分器、Rubric 评分器、人工评分器三类角色，并要求被测 Agent/Skill 输出结构化 Trace。没有 Trace，就无法做工具调用检查、过程对比、基线对比，只能退化为看最终答案。

12. **基线不是手写答案，而是人工确认过的一次真实执行快照**：用例先跑一轮，人工确认过程和结果可接受后，把工具调用序列、中间产物、最终报告、Token/耗时等固化为基线。后续回归时既能用程序判断步骤/产物是否偏离，也能用 Rubric 让模型比较语义差异。

13. **先校准评分器，再扩大样本规模**：小团队起步时，10 个高频黄金 case 就足够校准 LLM-as-Judge；如果维度分差、排序倒置率、极端 case 一致率都还没对齐，盲目扩到几百条样本只会放大噪声。

14. **只评结果不评过程，很难真正优化系统**：生产评测集跑完后，最有价值的不是“最后总分”，而是 bad case 暴露出的结构性缺陷。要把坏样本回推到 prompt、few-shot、模型选择、工具策略或验证规则，而不是停在“分数变低了”。
