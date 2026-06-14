---
title: "深度解析 OpenClaw 在 Prompt / Context / Harness 三个维度中的设计哲学与实践"
type: source
date: 2026-05-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/JycTfNd7EnmWCnJK-QCf0Q"
author: "阿里云开发者 / 飞樰"
published_at: "2026-04-13"
ingested_at: 2026-05-10
tags:
  - openclaw
  - prompt-engineering
  - context-engineering
  - harness
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
related_topics: []
---

# 深度解析 OpenClaw 在 Prompt / Context / Harness 三个维度中的设计哲学与实践

## 一句话概括

阿里云开发者公众号上由"飞樰"撰写的 [[OpenClaw]] Prompt / Context / Harness（脚手架）三维度深度解析，最大亮点是**列出了 OpenClaw System Prompt 的 23 个组装模块**——身份 / 工具清单 / 工具调用风格 / 安全准则 / CLI 操作 / Agent Skills / 记忆召回 / 自更新 / 模型别名 / Workspace / 参考文档 / Sandbox / 授权发送者 / 时间 / Workspace 文件注入 / Reply Tags / Messaging / 群聊回复 / 推理格式 / 静默回复 / 心跳 / Runtime 等。

## 实践内容

### System Prompt 23 个模块清单

每个模块带条件加载标记 `[full]` / `[full/minimal]` / `[full, 有X时]`：

| # | 模块 | 加载条件 |
|---|---|---|
| 1 | 身份与定位 | full |
| 2 | 工具清单 Available Tools | full / minimal |
| 3 | 工具调用风格 | full |
| 4 | 安全准则 Safety Guidelines | full |
| 5 | OpenClaw CLI 操作指令 | full |
| 6 | 技能（Agent Skills） | full, 有技能时 |
| 7 | 记忆召回 Memory Recall | full, 有记忆工具时 |
| 8 | 自更新管理 | full, 有网关工具时 |
| 9 | 模型别名 | full / minimal, 有配置时 |
| 10 | Workspace | full |
| 11 | 参考文档 Documentation | full, 有路径时 |
| 12 | 沙箱 Sandbox | full, 沙箱模式时 |
| 13 | 授权发送者 Authorized Senders | full, 有配置时 |
| 14 | 时间信息 Current Date & Time | full / minimal, 有配置时 |
| 15 | Workspace 文件注入（AGENTS.md / SOUL.md / USER.md / IDENTITY.md / TOOLS.md） | full / minimal |
| 16 | Reply Tags | full |
| 17 | Messaging | full |
| 19 | 群聊回复 | full, 有配置时 |
| 20 | 推理格式 Reasoning | — |
| 21 | 静默回复 Silent Mode | full |
| 22 | 心跳机制 Heartbeats | full |
| 23 | 运行时信息 Runtime | 永远存在 |

（编号 18 在原文跳过，未给出）

### Workspace 文件注入示例

```
# AGENTS.md - Your Workspace
## First Run
...
```

`AGENTS.md` / `SOUL.md` / `USER.md` / `IDENTITY.md` / `TOOLS.md` 是 Workspace 的"灵魂文件"——OpenClaw 启动时自动把它们的内容拼到 system prompt，让每个 Agent 拥有"个性"。

## 摘录

> OpenClaw 的 System Prompt 不是一段定死的字符串，而是一个由 23 个模块按条件拼接而成的运行时产物。每个模块都标注了加载粒度——full（完整加载）/ minimal（最小化）/ 仅当满足某条件时加载（如有技能时、有沙箱时、有配置时）。这种条件化拼接的核心动机是 token 预算：默认全量拼出来可能上万 tokens，按当下任务动态裁剪可以瘦到几千。OpenClaw 把"system prompt 是什么"重新定义成了"我现在需要的 system prompt 是什么"。

> Skill 的注入是其中第 6 个模块——而且仅"有技能时"才加载。注入的是 Skill 的菜单（name + description + location），不是 SKILL.md 的全文。这意味着 Agent 看到的是"我有什么 Skill 可选"而不是"每个 Skill 怎么用"，需要细读时再去 read 那个 Skill 文件。这种"两阶段加载"在多 Skill 场景下能省下数倍的 token 消耗。

> Workspace 的"灵魂文件"AGENTS.md / SOUL.md / USER.md / IDENTITY.md / TOOLS.md 是 OpenClaw 让每个 Agent 拥有"个性"的关键——这些文件的内容会被拼到 system prompt 第 15 个模块。换句话说，"配置一个 Agent" 在 OpenClaw 里被翻译成了"在 Workspace 里写几个 Markdown 文件"，而不是改某个 YAML 字段或 JSON schema。这与 [[OpenClaw-双源记忆系统]] 的"文件即真相"哲学是同一血脉。

## 涉及实体

- [[OpenClaw]] —— 父系统
- [[OpenClaw-Skills]] —— 第 6 个模块即 Skills 注入

## 涉及主题

（积累 ≥5 篇同议题来源后聚合）

## 我的评注

- 23 个模块的清单本身就是 OpenClaw 的"系统提示词工程化教科书"——每个模块的存在都对应一个真实的设计取舍，值得逐一研究
- "条件加载 + 模板拼接 + 灵魂文件" 是一套很有"架构感"的 prompt 工程——比起"写一段长 prompt"，这种思路更工程化、更可维护
- 模块 6（Skills）+ 模块 7（Memory Recall）+ 模块 12（Sandbox）+ 模块 22（Heartbeats）四个加在一起，几乎就是 OpenClaw 区别于普通 LLM 客户端的全部"特性密度"——每个特性都对应一个模块开关
- 有趣的是模块 18 在原文目录中被跳过，可能是作者整理时漏掉，或确有内部废弃模块；后续若 ingest 续作可对照
