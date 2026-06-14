---
title: "OpenAI-Codex-Plugin-for-Claude-Code源码剖析"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/oOdSoAtitE_ayAfA607HwA"
author: ""
ingested_at: 2026-05-29
tags:
  - claude-code
  - codex
  - plugin
  - openai
related_entities:
  - "[[OpenClaw]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# OpenAI-Codex-Plugin-for-Claude-Code源码剖析

## 一句话概括

逐层拆解 OpenAI 官方 codex-plugin-cc 的桥接架构——Claude Code 侧提供 /codex:review 等命令，底层复用本机 Codex CLI / App Server，通过 Broker 协议把 Codex 变成 Claude Code 工作流里的第二审阅者和异步 worker。

## 摘录

> Claude Code 侧提供 /codex:review、/codex:adversarial-review、/codex:rescue 等命令，底层复用本机 Codex CLI / App Server，通过 Broker 协议、后台任务、状态持久化与 Review Gate 把 Codex 变成 Claude Code 工作流里的第二审阅者和异步 worker。

> 这种设计体现了 Harness Engineering 的思想——不是替换工具，而是在已有工具之上构建协调层，让不同 AI 系统各司其职。

## 涉及实体

- [[OpenClaw]] —— 类似的多 Agent 协调架构
- [[Harness-Engineering]] —— 工具协调层的实践

## 涉及主题

- [[Agent架构演进-主题]]
