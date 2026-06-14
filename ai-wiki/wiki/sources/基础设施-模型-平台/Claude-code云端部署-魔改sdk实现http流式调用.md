---
title: "Claude-code云端部署-魔改sdk实现http流式调用"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/ooTYAzFvxC4PCQ5H82dRhQ"
author: ""
ingested_at: 2026-05-29
tags:
  - claude-code
  - cloud-deployment
  - sdk
  - sse
related_entities:
  - "[[OpenClaw]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# Claude-code云端部署-魔改sdk实现http流式调用

## 一句话概括

将 Claude Code 从本地部署到云端并提供 HTTP 服务的完整实践——通过 npm pack 离线打包、FastAPI + SSE 魔改 claude-agent-sdk、Docker 镜像构建、沙箱平台多用户隔离四层架构。

## 摘录

> 通过 npm pack 离线打包解决无外网服务器安装问题，基于 FastAPI + SSE 魔改 claude-agent-sdk 将单次查询和多轮会话封装为流式 HTTP 接口，通过 Docker 基础镜像和沙箱平台实现多用户实例隔离，涵盖离线部署、HTTP 服务化、镜像构建、沙箱隔离四层架构。

## 涉及实体

- [[OpenClaw]] —— 类似的本地优先部署思路
- [[Harness-Engineering]] —— 云端 Agent 的 Harness 治理

## 涉及主题

- [[Agent架构演进-主题]]
