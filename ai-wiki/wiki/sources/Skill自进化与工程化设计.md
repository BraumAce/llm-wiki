---
title: "Skill 自进化与工程化设计"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://blog.bytelighting.cn/program/reading/2026/2026.5.html"
author: "多作者综合"
ingested_at: 2026-05-29
tags:
  - skill
  - self-evolution
  - engineering
  - agent
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# Skill 自进化与工程化设计

## 一句话概括

综合 2 篇文章，展示 Skill 从"静态知识包"演进到"可自进化单元"的工程化路径——8 阶段 Loop 驱动迭代、3 层评测衡量质量、5 维 AND 门控决定保留。

## 实践内容

### Skill 自进化 8 阶段 Loop

```
阶段 1: 基线评估 — 当前 Skill 的质量评分
阶段 2: 问题诊断 — 识别 Skill 的薄弱环节
阶段 3: 改进生成 — AI 生成改进版本
阶段 4: 结构检查 — 格式、必填字段、链接完整性
阶段 5: 逐条打分 — 每条规则/约束的质量评分
阶段 6: 对比评选 — 新旧版本 A/B 对比
阶段 7: 5 维 AND 门控 — 全部通过才保留 checkpoint
阶段 8: 回到阶段 1 — 下一轮迭代

19 轮自动迭代后实现从"能跑"到"真的好"的质量收敛
```

### 5 维 AND 门控

```
五个维度（全部通过才保留）：
1. 功能正确性 — 输出是否符合预期
2. 结构完整性 — 格式、字段、链接是否规范
3. 边界处理 — 异常输入、边界条件是否覆盖
4. 一致性 — 与已有 Skill / 规则是否冲突
5. 效率 — Token 消耗是否在合理范围

AND 逻辑：任一维度不通过 → 回退到上一个 checkpoint
```

### 工具信息三层分离

```
问题：工具数量膨胀 → context 被工具描述撑爆

解法：三层分离
1. 索引层 — 工具名称 + 一句话描述（始终在 context 中）
2. 元数据层 — 参数 schema + 返回格式（按需加载）
3. 规则层 — 使用约束 + 边界条件（Skill 文件中定义）

效果：Agent 只在需要时加载完整工具信息
```

### Workflow 文件系统驱动

```
传统：代码中硬编码工作流逻辑
新范式：Workflow 以文件系统驱动

workflows/
├── ingest.md      # 消化流程
├── query.md       # 查询流程
├── digest.md      # 综合报告
└── lint.md        # 健康检查

优势：热插拔 — 修改 .md 文件即可改变 Agent 行为
```

## 摘录

> 借鉴 Karpathy autoresearch 与深度学习训练循环思路，构建一套 Skill 自进化框架——以 8 阶段 Loop 驱动迭代、3 层评测（结构检查 + 逐条打分 + 对比评选）衡量质量、5 维 AND 门控决定是否保留 checkpoint，19 轮自动迭代后实现从"能跑"到"真的好"的质量收敛。（让Skill自己训练自己）

> 将 Agent 当"算法"用——通过 CLI 接管一切确定性工作，让 Agent 只做理解与决策。工具信息三层分离（索引/元数据/规则）解决工具数量膨胀问题，Workflow 以文件系统驱动实现热插拔。（Skill 工程化设计的心路历程）

## 涉及实体

- [[OpenClaw-Skills]] —— Skill 机制的典型实现：SKILL.md 定义 + 6 源加载
- [[Harness-Engineering]] —— Skills 是 Harness 的能力封装层

## 我的评注

"让 Skill 自己训练自己"是最有启发性的概念。它把深度学习的训练循环（train → eval → checkpoint → iterate）搬到了 Skill 工程中。5 维 AND 门控的设计也很精巧——避免了"某维度大幅提升但另一维度崩溃"的问题。不过 19 轮迭代的 Token 成本不低，适合高价值 Skill 的精调，不适合快速原型。
