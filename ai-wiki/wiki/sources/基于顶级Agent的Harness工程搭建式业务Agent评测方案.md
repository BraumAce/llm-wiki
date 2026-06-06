---
title: "基于顶级 Agent（Claude Code）的 Harness 工程搭建式业务 Agent 评测方案"
type: source
date: 2026-06-06
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/n9zkbKTi3Q1j-L2vgmO1Vw"
author: "泊予 / 阿里云开发者"
ingested_at: "2026-06-06"
tags:
  - harness-engineering
  - agent-evaluation
  - claude-code
  - llm-as-judge
  - alibaba
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Claude-Code]]"
  - "[[Anthropic]]"
related_topics:
  - "[[Agent评测方法论]]"
---

# 基于顶级 Agent（Claude Code）的 Harness 工程搭建式业务 Agent 评测方案

## 一句话概括

用一个顶级 Agent（Claude Code）搭建评测 Harness，将评测逻辑从"代码"升级为"Prompt"，系统性评测一群业务 Agent，让评测从"周级"变为"天级"。

## 实践内容

### Harness 搭建五步法

```
Step 1: 设计评测方案（10-30 分钟）
  输入：被测 Agent 的 prompt 文件 + 业务上下文
  CC 输出：维度、指标、阈值、数据集要求、错误分类

Step 2: 构建评测集（半天，含人工标注）
  CC 编写脚本拉取候选数据 → 人做 GT 标注 → 打包为 Excel

Step 3: 编写评测 Agent 提示词（1-2 小时）
  核心创新：把 test_runner.py 替换为评测 Agent 的 System Prompt

Step 4: 跑批执行（平台）

Step 5: 结果分析（10-20 分钟）
  CC 读取结果 Excel → 出报告 + 优化建议
```

### 评测 Agent 提示词模板

```markdown
## 角色定义
你是一个严谨的 AI 评测专家，负责对「XXX」Agent 进行单条样本评测。

## 工具声明
-{agentId}：调用被测 Agent，传入 XXX，返回原始输出

## 约束
1. 必须先调用工具获取 Agent 输出，再评测
2. 最终只输出一个合法 JSON
3. 数值统计必须精确计算，不可估算

## 工作流程
1. 解析输入（提取 post_id、输入数据、ground_truth）
2. 调用被测 Agent
3. 解析输出为 JSON
4. 硬规则自动检查（格式/字段/枚举/字数/...）
5. LLM-as-Judge 打分（对比 ground_truth 或按评分标准）
6. 错误归因（FORMAT_ERROR / WRONG_CHOICE / ...）
7. 输出最终 JSON

## 输出 Schema
{完整的 JSON schema 定义}
```

### 三层指标框架

**L1：通用基础指标（所有 Agent 必报）**
- 输出格式合规率：JSON 可成功解析的比例
- 字段完整率：必要字段均存在的比例

**L2：按能力类型选用**

| 能力类型 | 指标 | 适用场景 |
|---------|------|---------|
| 分类判断 | 分类准确率 | 枚举值选择 |
| 二元决策 | 召回率 / 精确率 | 过滤 / 准入决策 |
| 数值提取 | 精确匹配率 | 离散数值的精确提取 |
| 连续评分 | MAE + 分档一致率 | 内容质量打分 |
| 文本生成 | LLM-as-Judge 1-5 分 | 文案等开放式输出 |

**L3：Agent 专属指标** —— 按需自定义

### system.question 列设计（评测集核心）

```json
{
  "sample_id": 243,
  "title": "XX品牌零食合集...",
  "content": "最近发现了...",
  "items": [...],
  "ground_truth": {
    "should_filter": false,
    "total_score": 64,
    "dimension_a": 22,
    "dimension_b": 22,
    "dimension_c": 20
  }
}
```

### LLM-as-Judge 评分标准设计（rubric）

```
5 分：改写自然，传达原文单一核心意图，一次读完即懂
4 分：基本达标，有轻微瑕疵但整体可读
3 分：勉强可接受，但存在轻度问题
2 分：明显问题：信息压缩过度或照抄原文
1 分：严重错误：与输入无关或完全无法理解
```

### 效率对比数据

| 阶段 | 传统方式 | CC 协助 | 加速比 |
|------|---------|---------|-------|
| 评测方案设计 | 1-2 天 | 10-30 分钟 | ~10x |
| 评测集构建 | 2-3 天 | 半天 | ~5x |
| 评测脚本开发 | 2-3 天 | 1-2 小时 | ~10x |
| 结果分析 + 报告 | 半天-1天 | 10-20 分钟 | ~5x |
| **单 Agent 全流程** | **~1.5 周** | **~1-2 天** | **~5x** |

## 摘录

> 核心思路：用一个顶级 Agent（Claude Code）作为 Harness 工程的搭建者和运行者，系统性地对业务 Agent 进行评测。传统做法：人写评测代码 → 跑脚本 → 看结果 → 改代码 → 再跑。Harness 式做法：顶级 Agent 搭建完整的评测骨架（harness），包括评测方案、数据集、评测逻辑（以 Agent 提示词形式表达）、分析流程。

> 关键洞察：评测 Harness 的本质是一套结构化的评估规则 + 执行流程。传统做法把它编码为 Python 脚本，而我们把它编码为 Agent 提示词——更灵活、更可读、更易迭代。

> 这是整套方案最核心的创新：把传统的评测脚本（Python/Java）替换为一份评测 Agent 提示词。评测逻辑从"代码"变为"自然语言指令"，一个 Agent 来评测另一个 Agent。

> 评测 Agent 本身也需要迭代（评测系统 bug ≠ 被测 Agent bug）。匹配逻辑过严、硬编码规则误报、Token 截断、GT 覆盖缺口——这些坑都需要在迭代中修复。迭代节奏：v1 基本逻辑跑通 → v2 切换跑批模式 → v3+ 基于实际结果持续调优。

## 涉及实体

- [[Harness-Engineering]] —— 本文将 Harness 理念应用于 Agent 评测领域，用 CC 搭建评测 Harness
- [[Claude-Code]] —— 作为顶级 Agent 充当 Harness 搭建者，负责方案设计、数据处理、结果分析
- [[Anthropic]] —— Claude Code 的开发者，三层架构（Planner/Generator/Evaluator）的设计者

## 涉及主题

- [[Agent评测方法论]]

## 我的评注

这篇文章的核心创新在于**把评测逻辑从代码变为 Prompt**——本质上是 Harness Engineering 在评测领域的具体实践。几个关键洞察：

1. **用强 Agent 评测弱 Agent** —— 这和 Anthropic 的三代理架构（Planner/Generator/Evaluator）理念一致，但更轻量
2. **评测 Agent 的迭代同样重要** —— 评测系统 bug ≠ 被测 Agent bug，这个区分很关键
3. **三层指标框架（L1/L2/L3）** —— 可复用性很强，新 Agent 照着勾选就行
4. **LLM-as-Judge 的 rubric 设计** —— "每个分值必须有具体、可区分的判定标准"，这条经验在任何需要 LLM 评判的场景都适用
5. 文章最后致谢提到了"营销消费清单 AI 项目"，说明这是阿里内部真实业务场景的实践总结
