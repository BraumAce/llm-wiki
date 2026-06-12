---
title: "Hook-机制"
type: entity
date: 2026-06-12
also_known_as:
  - "Hook 机制"
  - "工具调用生命周期钩子"
  - "Claude Code Hooks"
tags: [Claude-Code, Hook, automation]
sources: [让-Claude-Code-拥有自我进化和记忆系统]
related_entities: [Claude-Code, Instinct-Engine]
---

# Hook-机制

## 一句话定义

Hook 机制是 Claude Code 在工具调用生命周期中的回调点，允许在工具执行前（PreToolUse）、执行后（PostToolUse）、会话结束（Stop）等时机触发自定义脚本，实现确定性的行为观测和自动化流程，是 Claude Code 自我学习系统的基础设施。

## 摘要

Hook 机制的核心价值是"确定性触发"——相比依赖模型主动调用的 Skill，Hook 由系统级事件驱动，确保 100% 的触发率。在 Claude Code 的自我学习系统中，Hook 被用于实现行为观测（记录每次工具调用）和模式提炼（会话结束时自动分析）。

Hook 的配置在 `~/.claude/settings.json` 中，支持按工具类型匹配（matcher）和自定义命令。每个 Hook 点可以配置多个钩子，按顺序执行。Hook 机制是 Claude Code 自我进化系统的基础设施，解决了早期版本用 Skill 触发学习时触发率不稳定的问题。

## 详情

### 起源与背景

早期版本用 Skill 来触发学习，但 Skill 依赖模型主动调用，触发率不稳定——模型可能忘记调用 Skill，或者在不恰当的时机调用。v2 版本改用 Claude Code 原生 Hook 机制，彻底解决了这个问题。Hook 是 Claude Code 在工具调用生命周期中的回调点，可以通过 Claude CLI 执行 `/hooks` 命令获取可用的 Hook 类型。

### 核心机制 / 工作原理

```
Hook 类型与配置：

1. PreToolUse：工具执行前触发
   - 用途：记录意图、参数验证、前置检查
   - matcher: "Bash"（只匹配 Bash 工具）
   - matcher: ".*"（匹配所有工具）
   - 典型命令：observe.sh pre

2. PostToolUse：工具执行后触发
   - 用途：记录结果、后置处理、质量检查
   - 通常匹配所有工具（".*"）确保 100% 采集率
   - 典型命令：observe.sh post

3. Stop：会话结束时触发
   - 用途：触发分析和提炼流程
   - 典型命令：auto-analyze-instincts.py && auto-evolve.py

4. SessionStart：会话开始时触发
   - 用途：注入记忆上下文
   - 典型命令：inject_memory_context.py

配置示例（~/.claude/settings.json）：
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "~/.claude/hooks/observe.sh pre" }] }
    ],
    "PostToolUse": [
      { "matcher": ".*", "hooks": [{ "type": "command", "command": "~/.claude/hooks/observe.sh post" }] }
    ],
    "Stop": [
      { "hooks": [{ "type": "command", "command": "~/.claude/bin/auto-analyze-instincts.py && ~/.claude/bin/auto-evolve.py" }] }
    ]
  }
}
```

### 应用 / 使用场景

- 行为观测：记录每次工具调用的输入输出，构建行为数据集
- 模式提炼：会话结束时自动分析行为模式，提炼 Instinct 规则
- 记忆注入：会话开始时自动注入相关记忆，减少冷启动时间
- 质量检查：工具执行后自动验证结果，发现规范性错误
- 自动化流程：会话结束时自动触发分析、提炼、进化流程

### 局限与争议

- Hook 执行会增加工具调用的延迟（通常在毫秒级，可接受）
- Hook 脚本的错误可能影响正常工具调用，需要错误处理
- 需要仔细设计 Hook 的触发条件，避免过度触发导致日志膨胀
- Hook 机制是 Claude Code 特定的，不通用到其他 AI Coding 工具
- Hook 脚本的维护成本随系统复杂度增加

## 与其他实体的关系

- [[Claude-Code]] —— Hook 机制是 Claude Code 的原生功能
- [[Instinct-Engine]] —— Hook 机制驱动 Instinct Engine 的数据采集

## 参考来源

- [[让-Claude-Code-拥有自我进化和记忆系统]]
