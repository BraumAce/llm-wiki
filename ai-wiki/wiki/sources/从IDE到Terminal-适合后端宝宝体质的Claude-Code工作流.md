---
title: "从IDE到Terminal：适合后端宝宝体质的Claude Code工作流"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/x9wUAM6QI1Ogv2B0biawbg"
author: "得物技术"
published_at: "2026-03-13"
ingested_at: 2026-05-31
tags:
  - claude-code
  - workflow
  - agent
related_entities:
  - "[[Claude-Code]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
---

# 从IDE到Terminal：适合后端宝宝体质的Claude Code工作流

## 一句话概括

基于「脑（模型）决定上限、手（提示词工作流）决定下限」选定 Claude Code CLI，用 zsh 函数 kcc/zcc/qcc 秒切模型，以 JetBrains IDE 为主轴借 AppleScript + iTerm2 三面板布局打通 GUI/TUI 自动跟随，串起 command、skill、subAgent、MCP、hook、plugin 六类扩展。

## 实践内容

### 多模型秒切换

```bash
# zsh 函数注入环境变量，在 Kimi、智谱 GLM、七牛之间秒切
kcc() { ANTHROPIC_BASE_URL="..." ANTHROPIC_API_KEY="..." claude "$@" }
zcc() { ANTHROPIC_BASE_URL="..." ANTHROPIC_API_KEY="..." claude "$@" }
qcc() { ANTHROPIC_BASE_URL="..." ANTHROPIC_API_KEY="..." claude "$@" }
```

### JetBrains IDE + iTerm2 三面板布局

用 AppleScript + iTerm2 打通 GUI/TUI 自动跟随切项目，实现 IDE 和终端的无缝协作。

### 六类扩展体系

1. **command** —— 自定义命令
2. **skill** —— 工作流技能
3. **subAgent** —— 子代理
4. **MCP** —— 外部工具连接
5. **hook** —— 生命周期钩子
6. **plugin** —— 打包分发

### 实用技巧

- 飞书 MCP 集成
- `@` 模糊搜索
- 注意力哨兵机制

## 摘录

> 作者基于「脑（模型）决定上限、手（提示词工作流）决定下限」选定 Claude Code CLI，用 zsh 函数 kcc/zcc/qcc 注入 ANTHROPIC_BASE_URL 等行内环境变量在 Kimi、智谱 GLM、七牛之间秒切模型。

> 以 JetBrains IDE 为主轴，借 AppleScript + iTerm2 三面板布局打通 GUI/TUI 自动跟随切项目，并串起 command、skill、subAgent、MCP、hook、plugin 六类扩展与飞书 MCP、@模糊搜索、注意力哨兵等技巧。

## 涉及实体

- [[Claude-Code]] —— Claude Code 的多模型切换和 IDE 集成工作流

## 涉及主题

- [[Claude-Code源码解析-主题]]
