---
title: "基于 Cursor Agent 的流水线 AI CR 实践"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/BtlrcAhqVDv0oIhnoM9hBQ"
author: "得物技术"
published_at: "2026-03-16"
ingested_at: 2026-05-31
tags:
  - cursor
  - code-review
  - ai-coding
related_entities:
  - "[[Claude-Code]]"
related_topics: []
---

# 基于 Cursor Agent 的流水线 AI CR 实践

## 一句话概括

得物在 MR 流水线中以 Cursor Agent CLI 取代传统 Diff + 大模型 API 的高误报 CR 链路，每次提交自动触发产出聚类为严重/警告/建议的 AI CR 报告，有效问题率约 50%。

## 实践内容

### 三种闭环

1. **一键添加 MR 评论** —— 直接在 MR 中添加评论
2. **复制 Prompt** —— 复制到其他工具使用
3. **跳转本地 Cursor 创建 Chat 修复** —— 在 Cursor 中直接修复

### .cursor/rules 配置

内置 13 类 mdc 规则：
- 空指针
- React Hooks
- 安全编码
- Monorepo 依赖
- 等等

### 性能对比

- Composer 1.5：44 秒
- Auto：91 秒
- 有效问题率：约 50%

## 摘录

> 得物在 MR 流水线中以 Cursor Agent CLI 取代传统 Diff + 大模型 API 的高误报 CR 链路，每次提交自动触发产出聚类为严重/警告/建议的 AI CR 报告。

> 通过 `.cursor/rules` 内置 13 类 mdc 规则（空指针、React Hooks、安全编码、Monorepo 依赖等），优先用 Composer 1.5（44s）降级 Auto（91s），实测有效问题率约 50%。

## 涉及实体

- [[Claude-Code]] —— Cursor 是 Claude Code 的竞品

## 涉及主题

- []
