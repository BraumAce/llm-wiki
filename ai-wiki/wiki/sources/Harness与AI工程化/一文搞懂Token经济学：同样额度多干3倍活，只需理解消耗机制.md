---
title: "一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制"
type: source
date: 2026-06-19
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/cMJvRw6OXU3Eztf5NymQ-g"
author: "腾讯云开发者"
ingested_at: 2026-06-19
tags:
  - token-cost
  - prompt-cache
  - kv-cache
  - context-engineering
  - skill-cost
related_entities:
  - "[[Token成本控制]]"
  - "[[Prompt-Cache]]"
  - "[[Context-Engineering]]"
  - "[[OpenClaw-Skills]]"
  - "[[Orchestrator-Worker模式]]"
  - "[[MCP]]"
  - "[[KV-Cache]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
  - "[[AI-Skill体系-主题]]"
  - "[[Skill开发最佳实践]]"
---

# 一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制

## 一句话概括

这篇把 AI Coding 的 Token 成本拆成 API 调用结构、KV/Prompt Cache、Memory/Rules/Skills/MCP 四层配置税、Sub-Agent 冷启动成本和会话习惯，结论是降本关键不是少打一行字，而是稳定缓存链、减少无效上下文和工具结果污染。

## 实践内容

### 一次调用的结构

```text
System Prompt: 行为规则、安全约束、工具 JSON Schema、项目规则、Memory、项目上下文
对话历史: 用户消息、AI 回复、工具调用入参、工具返回结果
当前输入: 本轮新增的问题、文件、上下文
模型输出: 文字回复、工具调用、可见或不可见的 reasoning
```

用户一句话通常只占总输入的很小一部分，大头来自固定系统税和逐轮累积的历史。

### 缓存链规则

```text
[System 指令] -> [工具定义] -> [Rules/Memory] -> [msg1] -> [msg2] -> [msg3]
```

- 只追加新消息：前缀命中，只有新消息全价。
- 中途修改 Rules/Memory：修改点之后全部重算。
- 切换模型：KV 张量不互通，整条链从头全价。
- API 层默认缓存有效期约 5 分钟；产品层可能有更长缓存策略。

### 四类配置的加载成本

| 层级 | 加载机制 | 成本特征 | 适合内容 |
|---|---|---|---|
| Memory | 全量常驻 | 简单但改动打断缓存链 | 一句话偏好、项目约定 |
| Rules | 常驻或触发式 | 高频规则可缓存，低频规则按需 | 编码规范、格式约束、模板 |
| Skills | description 低成本，SKILL.md 加载后留在历史 | 加载前近零开销，加载后不可卸载 | 完整工作流、脚本、参考文档 |
| MCP 工具 | Schema 常驻，结果进入历史 | 闲置工具也有固定税，长结果污染后续轮次 | 浏览器、数据库、部署等外部能力 |

### Sub-Agent 成本判断

Sub-Agent 不能天然复用主 Agent 的缓存：工具集、历史和模型都可能不同。它的核心价值不是省 Token，而是防止主上下文被大量探索/审查结果撑爆。简单读文件优先主 Agent，大范围探索和独立审查再派 Sub-Agent。

## 摘录

> 每当你在 AI 编程工具里敲一句话、或 AI 调用一个工具后准备回复，都是一次完整的 API 调用。每次调用发送的内容结构包括系统指令、对话历史和当前输入，模型输出又会把文字回复与工具调用结果带回下一轮。关键认知是，你打的那句话通常只占总输入的 1% 到 5%。

> Skills 是最重的配置单元，通常包含 SKILL.md、references 和 scripts。加载前只有 description 在可用列表中，成本极低；用户触发或 AI 判断需要后，SKILL.md 全文注入到对话历史中。加载后它不会影响 System Prompt 的缓存链，但会永久留在历史里，后续只能靠缓存命中降低边际成本。

## 涉及实体

- [[Token成本控制]] —— 本文进一步把成本模型细化到缓存链和配置层。
- [[Prompt-Cache]] —— 文章把 KV Cache/Prompt Cache 的前缀匹配规则转化为使用习惯。
- [[Context-Engineering]] —— 降本本质是上下文治理，尤其是减少无效历史和工具结果污染。
- [[OpenClaw-Skills]] —— Skill 的渐进式披露有成本收益，但加载后不可撤回。
- [[Orchestrator-Worker模式]] —— Sub-Agent 用于隔离污染，而不是默认省钱。
- [[MCP]] —— 工具 Schema 和工具返回结果是 AI Coding 固定税的一部分。
- [[KV-Cache]] —— 解释缓存命中的模型侧原因，并提示它与产品层 Prompt Cache 的关系。

## 涉及主题

- [[Harness-Engineering-主题]]
- [[AI-Skill体系-主题]]
- [[Skill开发最佳实践]]

## 我的评注

这篇补上了很多 Skill/Harness 文章容易忽略的经济账。它把"按需加载"和"可复用"拆开看：Skill 未加载时便宜，加载后会变成长期历史负担；MCP 能力强，但闲置工具也要付 Schema 税。对日常 Codex/Claude Code 工作流最直接的启发是：一个任务尽量一个 session，配置在开始前定好，中途不要频繁改模型、工具和规则。
