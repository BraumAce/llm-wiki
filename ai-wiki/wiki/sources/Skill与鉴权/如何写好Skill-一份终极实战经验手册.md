---
title: "如何写好 Skill：一份终极实战经验手册"
type: source
date: 2026-06-06
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/SZv3pDXPrL9vwV3Ua_84Kg"
author: "jackjchou / 腾讯技术工程"
ingested_at: "2026-06-06"
tags:
  - skill
  - agent
  - prompt-engineering
  - best-practice
  - tencent
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[MCP]]"
  - "[[Harness-Engineering]]"
  - "[[Anthropic]]"
related_topics:
  - "[[Skill开发最佳实践]]"
---

# 如何写好 Skill：一份终极实战经验手册

## 一句话概括

腾讯工程师总结的 Skill 编写全指南，从基础概念到进阶技巧、从 MCP 集成到安全防护、从 Skill Creator 工程化评估到反模式排查，覆盖 Skill 生命周期的完整链路。

## 实践内容

### Skill 三层渐进式加载机制

```
Level 1: 元数据（name + description）    → 始终驻留在 AI 上下文中
Level 2: SKILL.md 主体                  → Skill 被匹配触发时加载
Level 3: 附带的脚本和参考资料             → 执行过程中按需引用
```

Token 成本估算：
- 英文：约 1 Token / 4 字符
- 中文：约 1 Token / 1.5-2 字符
- Level 1 约 50-150 Token/个 Skill，Level 2 约 2,000-5,000 Token

### SKILL.md 基本结构模板

```yaml
---
name: my-skill-name           # 必需：唯一标识符，小写，连字符分隔
description: >                 # 必需：清晰描述功能和触发场景
  将项目中的旧版 HTTP 客户端迁移到新版统一请求库。
  适用于 Go 项目中使用了 old-http-client 模块，
  需要替换为 unified-httpclient 的场景。
license: MIT                   # 可选
metadata:                      # 可选
  author: TeamName
  version: "1.0"
---
```

Markdown 正文参考结构：

```markdown
# Skill 名称
## 概述
## 前置条件
## 处理步骤
### Step 1: xxx
### Step 2: xxx
## 代码示例（Before/After）
## 验证清单
## 常见问题
## 相关 Skill
```

### Description 写法要点

```
# ❌ 反面案例
description: 处理代码迁移

# ✅ 正面案例
description: >
  将项目中的旧版 HTTP 客户端迁移到新版统一请求库。
  适用于 Go 项目中使用了 old-http-client 模块，
  需要替换为 unified-httpclient 的场景。
  包含 import 路径替换、请求参数适配和错误处理改造。
```

**触发评估技巧**：自己想 20 个问题（一半该触发、一半不该触发），测试 AI 是否每次都能正确判断。

### Few-Shot 示例设计原则

- 覆盖典型场景：正常情况、边界情况、错误情况各来一个
- 输入输出成对出现
- 示例之间有差异，别搞 3 个长得差不多的
- 先放最典型的（AI 更倾向模仿前面的示例）

### Skill Creator 工程化评估流程

```
Phase 1: 触发评估（Trigger Evaluation）
├── 自动生成正例和反例提问（各 10-20 条）
├── 批量测试 Skill 是否在正确时机被触发
├── 计算触发准确率（Precision）和召回率（Recall）
└── 输出触发评估报告

Phase 2: 效果评估（Quality Evaluation）
├── 基于预定义的测试用例，运行 Skill 执行流程
├── 对比"有 Skill"和"无 Skill"两组输出
├── 按评分标准自动打分
└── 输出效果评估报告

Phase 3: 综合报告与优化建议
├── 汇总触发和效果两个维度
├── 自动标注薄弱环节
└── 给出针对性优化建议
```

评估达标的参考标准：

| 指标 | 达标线 | 优秀线 |
|------|--------|--------|
| 触发准确率（Precision） | ≥ 85% | ≥ 95% |
| 触发召回率（Recall） | ≥ 85% | ≥ 95% |
| 效果通过率 | ≥ 80% | ≥ 90% |
| 相对提升率 | ≥ 30% | ≥ 50% |

### MCP vs HTTP 选择决策树

```
需要调用外部服务
↓
该服务是否已有 MCP Server？ ──── 是 → 优先使用 MCP
↓ 否
是否需要被多个 Skill / 多个 AI 平台复用？ ──── 是 → 封装为 MCP Server
↓ 否
是否需要统一的鉴权和安全管控？ ──── 是 → 封装为 MCP Server
↓ 否
是否为简单的一次性调用？ ──── 是 → 脚本中直接 HTTP 调用
↓ 否
评估改造成本 → 成本可接受则封装 MCP，否则先用 HTTP 脚本过渡
```

### 常见反模式速查表

| 反模式 | 一句话症状 | 解法指引 |
|--------|-----------|---------|
| 大杂烩 Skill | 一个 Skill 干三件事 | 拆分 |
| Description 黑话 | 全是内部术语 | 用通用语言 + 技术关键词 |
| 没有示例 | 纯文字描述 | 加 Few-Shot |
| 没有验证点 | 做完才检查 | 关键步骤加检查点 |
| 写死数值 | 硬编码配置 | 给判断规则和参考范围 |
| 当 Wiki 写 | 背景 300 行正文 50 行 | 背景放 references/ |

### Skill 安全防护要点

```bash
# ❌ 千万别硬编码
API_KEY="sk-xxxx-replace-me"

# ✅ 通过环境变量传入
if [ -z "$API_KEY" ]; then
  echo "❌ 请先设置环境变量 API_KEY"
  exit 1
fi
```

## 摘录

> Skill 就是给 AI 编程助手（Claude Code、CodeBuddy 等）"加装"的能力包。本质上，它是一种结构化的 Prompt Engineering——通过标准的文件格式，把分散在人脑中的领域知识、操作流程和最佳实践，转化为 AI 可理解、可执行的指令集。物理上看，它就是一个文件夹，里面放一个 SKILL.md 文件，再加上一些可选的脚本和参考资料。

> Description 这个字段太重要了。AI 就是靠它来判断"用户现在说的这个事，该不该用这个 Skill"。写得太笼统，AI 不知道啥时候该用；写得太窄，很多该触发的场景又漏了。一个实用的小技巧："触发评估"：你可以自己想 20 个问题（一半该触发、一半不该触发），然后测试一下 AI 是不是每次都能正确判断。

> Skill Creator 不只是"帮你生成 SKILL.md"的工具了。它最近新增了工程化评估能力，能系统化地评估 Skill 的触发准确率和执行效果。说白了，就是从"写完凭感觉觉得还行"升级到"跑一套测试，用数据告诉你行不行"。

> 大多数问题（估计 70% 以上）出在前两步——要么 Skill 没加载成功，要么 Description 写得不够好导致没触发。先查这两个，能省很多时间。

## 涉及实体

- [[OpenClaw-Skills]] —— 本文的核心主题，Skill 的编写方法论和最佳实践
- [[MCP]] —— MCP vs HTTP 的选择决策树，MCP Server 的配置方式
- [[Harness-Engineering]] —— Skill 是 Harness 的能力封装层，Skill Creator 的工程化评估体现了 Harness 思维
- [[Anthropic]] —— Skill Creator 是 Anthropic 官方的元 Skill 工具，三层渐进式加载机制的设计者

## 涉及主题

- [[Skill开发最佳实践]]

## 我的评注

这篇文章对 Skill 编写的覆盖面非常全，从基础的 SKILL.md 结构到 Skill Creator 的工程化评估都有涉猎。几个关键洞察值得关注：
1. **Skill 不是免费的**——每加载一个 Skill 都占上下文窗口，装 20 个 Skill 光 Level 1 就吃 1000-3000 Token
2. **工程化评估是 Skill 质量的分水岭**——从"凭感觉"到"跑数据"，这和 Harness Engineering 的核心理念一致
3. **反模式比正面指导更有价值**——知道什么不该做，往往比知道该做什么更能避坑
