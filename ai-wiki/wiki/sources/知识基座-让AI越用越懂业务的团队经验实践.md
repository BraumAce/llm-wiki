---
title: "知识基座：让AI越用越懂业务的团队经验实践"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/P-p4-BH8AAOnTBRcpsoKeQ"
author: "天猫"
published_at: "2026-03-23"
ingested_at: 2026-05-31
tags:
  - knowledge-base
  - ai-coding
  - enterprise
related_entities:
  - "[[Claude-Code]]"
related_topics: []
---

# 知识基座：让"AI 越用越懂业务"的团队经验实践

## 一句话概括

天猫近 200 人后端全栈试点中通过云端共享、信号驱动自动捕获 1% 真正有价值的踩坑会话，LLM 提炼 pitfall/decision/faq 三类知识并五维度评分，1 个月沉淀 128 条、置信度 0.92、召回率 85%。

## 实践内容

### 信号驱动的知识捕获

四种信号：
1. **关键词信号** —— 特定关键词触发
2. **多轮调试信号** —— 多轮对话后仍未解决
3. **否定信号** —— 用户否定 AI 的回答
4. **代码改动信号** —— 实际发生了代码修改

### 三类知识

1. **pitfall** —— 踩坑经验
2. **decision** —— 决策记录
3. **faq** —— 常见问题

### 五维度评分

对每条知识进行五维度评分，确保质量。

### 分级召回

repo → domain → global 三级召回，按相关性排序。

### 效果数据

- 1 个月沉淀 128 条
- 置信度 0.92
- 召回率 85%
- tsconfig 类问题从 30 分钟降至 1 分钟

## 摘录

> 天猫近 200 人后端全栈试点中通过云端共享、信号驱动（关键词 + 多轮调试 + 否定 + 代码改动）自动捕获 1% 真正有价值的踩坑会话，LLM 提炼 pitfall/decision/faq 三类知识并五维度评分。

> repo → domain → global 分级召回，1 个月沉淀 128 条、置信度 0.92、召回率 85%，tsconfig 类问题从 30 分钟降至 1 分钟。

## 涉及实体

- [[Claude-Code]] —— 知识基座与 Claude Code 的记忆系统有相似之处

## 涉及主题

- []

## 我的评注

"1% 真正有价值的踩坑会话"这个洞察很关键——不是所有对话都值得沉淀为知识。信号驱动的捕获方法（关键词、多轮调试、否定、代码改动）很实用。tsconfig 类问题从 30 分钟降至 1 分钟的效果也很显著。
