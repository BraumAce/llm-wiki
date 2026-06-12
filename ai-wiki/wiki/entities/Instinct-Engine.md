---
title: "Instinct-Engine"
type: entity
date: 2026-06-12
also_known_as:
  - "模式提炼引擎"
  - "Instinct Engine"
tags: [Claude-Code, self-learning, pattern-mining]
sources: [让-Claude-Code-拥有自我进化和记忆系统]
related_entities: [Claude-Code, Hook-机制, Agent-Memory]
---

# Instinct-Engine

## 一句话定义

Instinct Engine 是 Claude Code 自我学习系统的模式提炼层，在会话结束时通过统计模式检测和 AI 语义分析双路径，从行为观测数据中提炼出原子化的 Instinct 规则，并通过置信度演化机制持续优化，实现跨会话的知识传递。

## 摘要

Instinct Engine 的核心思想是"先积累原子规则，等同类足够多再聚类聚合"。每个 Instinct 是一个独立的 Markdown 文件，包含触发条件、行动建议、置信度和来源证据。通过两条互补路径提炼：统计路径快速可靠，覆盖常见模式；语义路径捕获统计模式无法识别的深层规律。

Instinct 的置信度不是静态的——反复观测强化（+0.05），长期未触发衰减（-0.05），低于阈值标记为 deprecated。这种动态演化机制让系统具有"遗忘"能力，自然淘汰过时规则。同域高置信度规则通过 Jaccard 语义去重后聚合成 Evolved Skill，写入 `rules/auto-evolved.md`，实现跨会话的知识传递。

## 详情

### 核心机制 / 工作原理

```
双路径提炼架构：

路径 A：统计模式检测
- 基于规则的硬编码检测器
- 识别高频出现的工具调用序列
- 快速可靠，覆盖常见模式
- 示例：检测到 "Read → Edit" 序列频繁出现

路径 B：AI 语义分析
- 将观测摘要交给 Claude 模型（claude-haiku-4-5）
- 捕获统计模式无法识别的深层规律
- 处理复杂的行为模式
- 示例：识别出"总是先检查 git status 再提交"的习惯

置信度演化机制：
- 首次发现：confidence = 0.5
- 重复验证：confidence += 0.05（上限 0.9）
- 长期未触发：confidence -= 0.05（低于 0.55 标记为 deprecated）
- 设计理念：规则不是静态的，反复观测强化，长期不触发衰减
```

### Instinct 数据模型

```yaml
---
id: read-before-edit-pattern
trigger: "when about to edit a file that hasn't been read in this session"
confidence: 0.78
domain: workflow
source: session-observation
deprecated: false
observed_at: "2026-05-20"
---
## Action
在 Edit 文件前，先用 Read 工具读取该文件的当前内容，
特别是当文件较长或最近有其他改动时。不跳过读取直接编辑，
以避免基于过时内容产生错误的修改。

## Evidence
在过去多次 Edit 操作中，绝大多数之前有对应的 Read 调用。
```

### 语义去重与聚合

```
Jaccard 语义去重算法：
1. 提取英文关键词（跨语言识别同一意图）
2. 计算 Jaccard 相似度
3. 相似度 >= 0.5 的合并为一组
4. 每组取置信度最高的作为代表

设计巧思：只提取英文关键词
- 用户可能用中文或英文描述同一个习惯
- 基于英文技术词汇的 Jaccard 相似度能跨语言识别同一意图

Domain 聚合：
- 按 domain 分组（workflow, testing, git, code-style 等）
- 每组 >= 2 条才生成 Evolved Skill
- 写入 rules/auto-evolved.md（每次会话覆盖重写）
- Claude Code 启动时自动加载 rules/ 目录下所有 .md 文件
```

### 应用 / 使用场景

- 个人编程习惯的学习和自动化（如"总是先写测试再写实现"）
- 项目特定规范的自动应用（如"本项目使用 Prettier 格式化"）
- 错误模式的识别和预防（如"提交前先运行 lint"）
- 工作流优化建议（如"并行执行独立的测试用例"）

### 局限与争议

- 依赖足够多的观测数据才能提炼出有效规则（冷启动问题）
- 统计路径的硬编码检测器可能遗漏新模式
- 语义路径依赖 LLM 的理解能力，可能产生错误规则
- 置信度演化需要长期运行才能稳定
- 跨项目的 Instinct 可能不通用

## 与其他实体的关系

- [[Claude-Code]] —— Instinct Engine 运行在 Claude Code 之上
- [[Hook-机制]] —— Hook 机制驱动 Instinct Engine 的数据采集
- [[Agent-Memory]] —— Instinct 规则是一种长期记忆形式

## 参考来源

- [[让-Claude-Code-拥有自我进化和记忆系统]]
