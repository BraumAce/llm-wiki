---
title: "Agent-DX"
type: entity
date: 2026-06-03
also_known_as:
  - "Agent Developer Experience"
  - "Agent 开发者体验"
tags:
  - developer-experience
  - ai-engineering
  - dx
sources:
  - "[[重新思考研发基础设施-当Agent成为第一公民]]"
related_entities:
  - "[[Agent-Oriented-Infra]]"
  - "[[AI-Friendly架构]]"
  - "[[Harness-Engineering]]"
---

# Agent DX

## 一句话定义

Agent DX（Agent Developer Experience）是面向 Agent 的开发者体验，与 Human DX 正交：Human DX 优化的是可发现性（discoverability），Agent DX 优化的是可预测性（predictability）。Google Workspace CLI (gws) 从第一天就按 agent-first 设计，是 Agent DX 的标杆实践。

## 摘要

Agent DX 的提出基于一个关键区分：人和 Agent 对"好用"的定义完全不同。人需要的是可发现性 — 能通过 --help、文档、自动补全找到功能；Agent 需要的是可预测性 — 输入输出格式稳定、错误语义明确、不变量可机器读取。Google 的 gws CLI 从第一天就按 agent-first 设计，提供了 schema 自省、输入加固防 hallucination、SKILL.md 编码不变量等实践。

## 详情

### Human DX vs Agent DX

| 维度 | Human DX | Agent DX |
|------|----------|----------|
| 核心目标 | 可发现性（discoverability） | 可预测性（predictability） |
| 帮助方式 | --help、文档、自动补全 | schema 自省、SKILL.md、结构化错误 |
| 输入验证 | 宽容（自动纠正、猜测意图） | 严格（拒绝非法输入、防 hallucination） |
| 输出格式 | 人类可读（表格、颜色） | 机器可解析（JSON、结构化） |
| 错误处理 | 友好提示 | 语义丰富、可机器决策 |

### Google Workspace CLI (gws) 的 Agent DX 实践

**1. Schema 自省替代静态文档**
```
gws schema drive.files.list
```
输出完整方法签名，CLI 成为 API 运行时状态的权威来源。Agent 不需要猜，直接查询。

**2. 输入加固防 hallucination**
- 路径沙箱化：拒绝 `../../.ssh` 这样的路径穿越
- 拒绝控制字符
- 资源 ID 校验：Agent 可能 hallucinate 出包含查询参数的 ID

**3. 发布 SKILL.md 文件**
编码 Agent 无法从 `--help` 推断的不变量：
- "写操作必须先 dry-run"
- "list 调用必须加 --fields"
- "回复 MR 评论必须回复 root 评论"

**4. 响应消毒防 prompt injection**
- 过滤输出中的潜在注入内容
- 防止 Agent 被恶意响应操纵

### Agent 不是可信的操作者

**核心观点：The agent is not a trusted operator.**

Agent 会：
- Hallucinate
- 生成路径穿越（`../../.ssh`）
- 在资源 ID 里嵌入查询参数
- 混淆 MR 全局 id 和项目 iid

面向 Agent 的设计需要把 Unix 哲学里 "Trust the user" 的假设翻转过来。

### 接口设计的 Agent DX 要求

**负面案例（从实际痛点中提取）：**
- MR 的全局 id 和项目 iid 缺少强类型化区分 → Agent 经常传错
- "回复 MR 评论必须回复 root 评论" 散落在口头知识里 → Agent 不知道
- `--dry-run` 只停留在 CLI 层，无法穿透到底层平台 → Agent 无法验证
- Pipeline 报错后 Agent 不知道下一步该干什么 → 反馈语义不足

**正面实践：**
- 强类型化区分相似概念
- 不变量化为 SKILL.md
- dry-run 贯穿全栈
- 错误响应包含下一步建议

### 应用 / 使用场景

- 企业内部 CLI/SDK 的 Agent-Friendly 改造
- 开源工具的 Agent DX 标准化
- Agent 平台的接口设计规范

### 局限与争议

- 同时满足 Human DX 和 Agent DX 可能增加维护成本
- 严格的输入验证可能破坏现有的向后兼容
- SKILL.md 的维护需要纳入 CI 流程

## 与其他实体的关系

- [[Agent-Oriented-Infra]] —— Agent DX 是 Agent-Oriented Infra 在开发者体验维度的体现
- [[AI-Friendly架构]] —— AI-Friendly 架构是 Agent DX 在接口设计维度的子集
- [[Harness-Engineering]] —— Harness 需要 Agent DX 来定义环境的自描述能力

## 参考来源

- [[重新思考研发基础设施-当Agent成为第一公民]] —— Agent DX vs Human DX 与 gws 实践
