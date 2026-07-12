---
title: "从AI Coding到Harness Engineering的端到端工程开发实践"
type: source
date: 2026-07-03
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/UE-RZH9hnbBd06CVapFGrA"
author: "zimingxing、kinglongli、yifhao（腾讯技术工程）"
published_at: "2026-07-03"
ingested_at: 2026-07-12
tags:
  - harness-engineering
  - knowledge-engineering
  - ai-coding
  - multi-agent
  - workflow
related_entities:
  - "[[Harness-Engineering]]"
  - "[[知识库工程]]"
  - "[[Agent-Skill]]"
  - "[[CodeBuddy]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 从AI Coding到Harness Engineering的端到端工程开发实践

## 一句话概括

腾讯应用宝活动平台把 [[Harness-Engineering]] 拆成相互依赖的两层：底层 [[知识库工程]] 将代码、文档和可观测数据持续编译成可定位、可更新的业务上下文；上层端到端开发工程则以结构化状态、职责隔离的专家 Agent、DAG 并行、脚本化确定性操作及受控 DevOps 集成，将需求从拆解一路推进到接口验证和提交。

## 实践内容

### 知识库三层目录与文档职责

```text
llm-knowledge/
├── backend/
│   ├── overview.md                 # 全局总览：业务域关键词和服务范围
│   ├── business/
│   │   └── {domain}/
│   │       ├── meta.yaml           # 机器可读服务索引、文档状态、git hash
│   │       ├── custom/             # 域级人工业务文档
│   │       └── {service}/
│   │           ├── overview.md
│   │           ├── interfaces.md
│   │           ├── architecture.md
│   │           ├── dependencies.md
│   │           ├── storage.md
│   │           ├── config.md
│   │           ├── pitfalls.md
│   │           ├── log.md          # 追加式变更历史，不覆盖
│   │           └── custom/         # 服务级人工补充
│   └── common/                     # conventions / lib_usage / tech
└── .codebuddy/skills/
```

知识消费采用渐进式加载：先读全局总览缩小到 1–2 个业务域，再在 `meta.yaml` 中用 `grep` 精确筛选服务，最后只加载本次问题需要的文档类型；接口搜索不必读取服务总览。知识更新以 `meta.yaml` 保存的 `git_hash` 对比当前仓库 HEAD，超过阈值生成任务后增量更新，既更新代码事实，也保留人工业务批注，并向 `log.md` 追加记录。

### 状态驱动的端到端交付

```text
需求拆解 -> 需求澄清 -> 任务拆解 -> 并行开发 -> 单测校验
  -> 代码审查 -> 测试环境部署 -> 用例请求构造 -> 接口验证 -> 提交代码

Phase R: 产品需求拆解
  ↓
Fork（并行）：每个子需求执行 任务拆解 -> 波次开发 -> 单测 -> CR
  ↓
Join（串行）：合并 -> 发布 -> 验证 -> 提交
```

状态文件保存每一阶段的输入、产出、状态和失败原因；`Stop Hook` 禁止主调度器绕过未完成步骤，`SessionStart Hook` 恢复断点，`SessionEnd Hook` 清理残留状态。每个 Agent 单一职责、独立上下文、最小工具权限，且通过结构化状态文件而非自然语言对话交换结果：例如 `code-reviewer` 只评不改，`interface-verifier` 只诊断不改，`code-fixer` 仅在收到问题清单后修改。

### 确定性操作脚本化与权限边界

```text
e2e-dev.py                 # 解析状态与决定下一步
worktree.sh/sub_worktree.sh # 创建、合并、清理并行任务工作树
build-and-publish.sh       # 通用编译发布
kb-init.sh                 # 知识库初始化与更新
```

文章的原则是“AI 负责认知，脚本负责执行”：需求理解、方案分析和代码生成交给模型；JSON 状态解析、工作树创建与合并、编译发布等有明确输入输出的动作交给脚本。并行前由规划 Agent 标出每个任务会触碰的文件；共享入口文件、协议和数据库/配置等全局变更则前置确认或串行收口。平台能力可经 MCP 或 Skill 集成，但发布、配置写入、提交等外部副作用仍需人工确认和受控权限。

## 摘录

> 当前，我们的整套体系包含 800+ 结构化文档，知识范围涵盖后台 90+ 个微服务，端到端流程沉淀了 12 个专家 Agent、30+ 业务相关 Skill 以及 10+ 个固定流程脚本。可以看到，知识库工程是整个 Harness 体系的底座——上层端到端开发流程的每一个环节，从需求拆解到接口验证，都依赖它提供准确、结构化的业务上下文。因此，本文会先从知识库工程开始介绍，再展开到端到端开发工程。

> 在跑通流程之后，我们复盘发现一个现象：整个端到端流程中，大量步骤其实是确定性操作——比如解析状态文件的 JSON、创建 git worktree、执行编译命令、调用发布工具等。这些操作不需要推理，只需要执行。让 AI 来做这些事，不仅白白消耗了 token，还引入了不必要的随机性——AI 可能写错 shell 语法、用错参数、或者在无关步骤上发散，同时，同一需求多次跑、不同模型跑，token 消耗和结果也都可能不一致。

## 涉及实体

- [[Harness-Engineering]] —— 上层交付工作流的工程骨架，承担阶段、门禁与副作用治理。
- [[知识库工程]] —— 将业务知识组织、生成、检索和新鲜度检测为可被 Agent 消费的底座。
- [[Agent-Skill]] —— 用于代码文档生成、知识查询以及各平台能力的可复用封装。
- [[CodeBuddy]] —— 文中使用其 CLI 作为模型调用入口，并将不同职责分配给专门 Agent。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这篇实践的区分度在于把“知识库”从上下文附件提升为一条可审计的生产线：以仓库版本检测新鲜度、保留人工知识、按目录和查询意图逐层加载。其端到端层则提醒我们，多 Agent 的重点不是并发数量，而是让状态、输入输出、最小权限和串行收口成为能被脚本验证的契约。
