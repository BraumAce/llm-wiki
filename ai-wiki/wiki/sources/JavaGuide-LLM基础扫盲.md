---
title: "JavaGuide：LLM 基础扫盲"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/ZAipp74rijevYjFkzbswjw"
author: "JavaGuide"
published_at: "2026-03-26"
ingested_at: 2026-05-31
tags:
  - llm
  - fundamentals
  - token
related_entities:
  - "[[Claude-Code]]"
related_topics: []
---

# JavaGuide：LLM 基础扫盲

## 一句话概括

1.6 万字 LLM 底层扫盲，以自回归生成为心智模型串起 Tokenizer/BPE、上下文窗口、Temperature/Top-p、Max Tokens 全链路，给出中英文 Token 压缩比经验值。

## 实践内容

### 核心概念链

自回归生成 → Tokenizer/BPE → 上下文窗口 → Temperature/Top-p → Max Tokens

### Token 压缩比经验值

- 1 中文 ≈ 0.6 Token
- 1 英文字符 ≈ 0.3 Token
- 用官方 Tokenizer 精确计数而非估算

### 特殊 Token 占用

特殊 Token 也会占用上下文窗口。

### 多模态图片 Token 计费规则

图片 Token 有专门的计费规则。

## 摘录

> 1.6 万字 LLM 底层扫盲，以自回归生成为心智模型串起 Tokenizer/BPE、上下文窗口、Temperature/Top-p、Max Tokens 全链路。

> 给出中英文 Token 压缩比经验值（1 中文≈0.6 Token、1 英文字符≈0.3 Token）、特殊 Token 占用、多模态图片 Token 计费规则，强调用官方 Tokenizer 精确计数而非估算。

## 涉及实体

- [[Claude-Code]] —— Token 管理是 Claude Code 上下文工程的基础

## 涉及主题

- []
