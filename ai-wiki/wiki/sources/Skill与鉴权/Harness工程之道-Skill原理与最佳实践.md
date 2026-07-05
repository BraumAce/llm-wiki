---
title: "Harness 工程之道：Skill 原理与最佳实践"
type: source
date: 2026-07-01
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/yo2f5edeNNkYtCte9P0yhQ"
author: "阿里云开发者"
ingested_at: 2026-07-01
tags:
  - agent-skill
  - trade-ab-skill
  - tool-isolation
  - skill-testing
related_entities:
  - "[[Agent-Skill]]"
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
  - "[[MCP]]"
  - "[[Progressive-Disclosure]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
  - "[[Skill开发最佳实践]]"
---

# Harness 工程之道：Skill 原理与最佳实践

## 一句话概括

这篇文章用 trade-ab-skill 案例系统讲解 Agent Skill 的目录结构、frontmatter 字段、触发机制、作用域优先级、模块化路由、工具隔离、脚本增强、参数快照和测试迭代方法。

## 实践内容

Skill 标准目录：

```text
my-skill/              # 必需：skill名称，短横线分隔
├── SKILL.md           # 必需：主文件，包括元信息 + 指令，文件名需全大写
├── scripts/           # 可选：可执行脚本
├── references/        # 可选：参考文档
├── assets/            # 可选：模板、资源
└── ...                # 任意额外文件
```

frontmatter 示例与字段：

```yaml
---
name: trade-ab-skill
description: 为用户提供 AB 实验的创建与修改能力，支持实验创建、调流量、
加桶删桶、实验下线等操作。当用户提到创建实验、修改实验、调流量、加桶删桶、
实验下线等场景时触发。
---
```

原文列出的 Claude Code 字段包括 `name`、`description`、`argument-hint`、`disable-model-invocation`、`user-invocable`、`allowed-tools`、`model`、`context`、`agent`、`hooks`、`version`。其中 `allowed-tools` 用于控制 Skill 执行时可调用的工具及权限范围，`context: fork` 用于隔离子智能体执行，`model` 可指定简单任务用 Haiku 降低成本。

`SKILL.md` 应作为路由器：

```markdown
# ✅ 最佳实践：SKILL.md 是路由器

## 意图路由表
| 场景示例 | 路由模块 | 加载文件 |
|-----------------|-----------|------------------------------|
|"创建实验"| creator | modules/creator/creator.md |
|"实验XX调流量"| modifier | modules/modifier/modifier.md |

## 全局安全红线
1. 禁止调用万能工具
2. 禁止编造数据
3. 写模块限定接口
```

trade-ab-skill 的分层结构：

```text
trade-ab-skill/
├──SKILL.md←意图路由表、全局安全红线（每次激活必读）
├──modules/creator/creator.md←创建流程Step编排、scenarioId 对照表（进入创建模块才读）
├──modules/creator/collect-phase.md←参数填充的11项执行清单（仅Step2才读）
├──modules/creator/validate-phase.md←校验规则（仅Step3才读）
├──modules/creator/tools.md←MCP工具接口列表（调接口时按需查阅）
└──modules/creator/safety.md←安全约束详细规则（validate 阶段按需加载）
```

工具隔离原则：

```text
白名单制：每个模块的 tools.md 明确列出可用接口，白名单外一律禁止；
危险接口显式禁用：万能工具（如直接 HTTP 调用）全局禁止；
工具隔离：不同模块使用不同的接口集合，防止误调用。
```

脚本设计原则：

```text
自愈性——脚本内部处理所有异常，始终正常退出，绝不阻断 Skill 主流程
结构化输出——统一输出 JSON，方便 Agent 解析和流转
幂等性——多次执行结果一致，预检脚本只追加缺失项，不覆盖已有配置
安全边界——只操作指定文件，不触碰其他系统资源
```

用户偏好持久化示例：

```json
{
  "defaultScenarioId": "<场景ID>",
  "defaultMetricTemplateId": "<模板ID>",
  "recentExperimentIds": ["<实验ID1>", "<实验ID2>"],
  "lastUsed": "2026-06-17",
  "usageCount": 2
}
```

测试维度：

```text
触发测试：准备 10 个左右的自然语言变体去触发 Skill，检查是否都能正确激活，同时验证不相关的输入是否会误触发。
功能走查：用自然语言驱动完整流程，检查每个阶段的输出是否符合预期。重点关注路由是否准确分发、渐进加载是否按时序工作、红线规则是否被遵守、异常场景是否正确熔断。
性能对比：针对同一任务，分别用"无 Skill"和"有 Skill"两种方式各跑 5 次，对比 Token 用量和完成质量。
```

## 摘录

> Skill 体系最核心的设计理念是渐进性披露（Progressive Disclosure），即只在需要时才加载需要的知识，而非一次性加载全部。Skill 的渐进性披露主要分三阶段：Discovery（发现）阶段仅加载每个 Skill 的 name 和 description；Activation（激活）阶段读取完整的 SKILL.md，加载路由表和全局规则；Execution（执行）阶段按路由表加载对应模块文件，按需读取参考文档，只加载当前任务真正需要的知识。

> 核心理念：将确定性计算逻辑封装为脚本，由 Agent 调用执行而非自行推导。脚本是 Skill 突破 LLM 能力边界的利器。如果这件事让 LLM 做有概率出错，但让脚本做能 100% 确定性完成，那就该封装成脚本。如果发现自己在 SKILL.md 中编写公式让 Agent 运行计算，该逻辑也应该被挪到脚本中。

## 涉及实体

- [[Agent-Skill]] —— 文章完整描述了 Skill 的开放格式、触发机制和工程约束。
- [[Claude-Code]] —— 文中以 Claude Code frontmatter、allowedTools、model、context、hooks 等字段作为实践参考。
- [[Harness-Engineering]] —— Skill 被放在 Harness 工程语境中，用工具隔离、脚本、门卡和日志驱动迭代。
- [[MCP]] —— trade-ab-skill 通过模块级 tools.md 管理 MCP 工具接口。
- [[Progressive-Disclosure]] —— 三阶段加载是文章的核心理念。

## 涉及主题

- [[AI-Skill体系-主题]]
- [[Skill开发最佳实践]]

## 我的评注

这篇比一般 Skill 教程更工程化：它明确把 `SKILL.md` 定位为路由器，把模块文件定位为执行细节，把脚本定位为确定性边界，把日志定位为迭代数据源。尤其是模块级工具白名单、快照参数传递和“无 Skill vs 有 Skill”性能对比，很适合沉淀为团队级 Skill 质量门禁。
