---
title: "Chromium-AI-Coding"
type: entity
date: 2026-06-02
also_known_as: [Chromium AI Coding体系, Chromium AI Agent基础设施]
tags: [Chromium, AI-Coding, Prompt分层, Skills, 评估体系]
sources: [深入解析Chromium的AI-Coding开发体系]
related_entities: [Prompt分层组合架构, Prompt评估体系, OpenClaw-Skills, Spec-Driven-Development]
related_topics: [Agent架构演进-主题, AI-Skill体系-主题]
---

# Chromium AI Coding

## 一句话定义

Chromium是全球最大的开源C++项目之一（3500万+行代码），其源码仓库中内建了一套完整的AI Agent基础设施——包括四层Prompt分层组合架构、18+可复用Skills、MCP扩展、知识库、评估体系和大规模AI驱动项目，支持Gemini CLI、Claude Code、GitHub Copilot三种AI工具复用。

## 摘要

Chromium团队在源码仓库的`agents/`目录下构建了系统化的AI Coding基础设施。核心设计是四层Prompt分层组合架构（核心指令→完整工作流→平台模板→任务提示词），通过`@`引用组合，实现"动静分离"。同时建立了18+可复用Skills、Prompt评估体系（15+场景）和AI使用政策（人类始终是最终责任人）。这套体系支持跨工具复用（Gemini CLI/Claude Code/Copilot），是大型开源项目AI Coding的最佳实践参考。

## 详情

### 起源与背景

Chromium是Google主导的开源浏览器项目，代码量超过3500万行。面对如此庞大的代码库，团队在2025-2026年间开始系统化地将AI引入开发流程。与其他项目不同，Chromium的做法不是"在IDE里装个Copilot"，而是在源码仓库中建立了一整套AI Agent基础设施，从政策约束到提示词管理、技能系统、评估体系一应俱全。

### 核心机制 / 工作原理

#### 四层Prompt分层组合架构

```
┌─────────────────────────────────────────┐
│  第四层：Task Prompts（任务提示词）        │  ← 一次性任务指令
├─────────────────────────────────────────┤
│  第三层：Templates（平台模板）             │  ← desktop/android/ios
├─────────────────────────────────────────┤
│  第二层：common.md（完整工作流）           │  ← 8步标准编辑流程
├─────────────────────────────────────────┤
│  第一层：common.minimal.md（核心指令）     │  ← 构建、测试、编码规范
└─────────────────────────────────────────┘
```

开发者通过创建本地`GEMINI.md`文件，用`@`引用组合不同层级的prompt：

```markdown
# 桌面开发者的配置
@agents/prompts/common.md          # 自动包含 common.minimal.md
@agents/prompts/templates/desktop.md
```

#### AI使用政策（ai_policy.md）

```
核心原则：AI 是辅助工具，人类开发者始终是最终责任人

自审义务：作者必须在发送 Review 前自行审查并理解所有代码
  违规 → 剥夺 Committer 权限，再犯 → 封禁账号

原创声明：无论是否使用 AI，作者必须声明代码为自己的原创作品

人类回复人类：AI Agent 创建的 CL 收到人类反馈，必须由人类操作者亲自回复
```

#### 8步标准编辑工作流（common.md）

```
Step 1: 深度理解代码（强制第一步，不可跳过）
  ├── 定位核心文件
  ├── 完整审计（读取每个文件的完整源码）
  ├── 陈述理解（向开发者确认）
  └── 反模式规避：绝不从函数名猜测行为

Step 2: 编写代码（只做需求要求的事）

Step 3: 编写/更新测试

Step 4-8: 构建 → 修复编译错误 → 运行测试 → 修复测试错误 → 迭代
```

Step 1的设计尤为关键——强制AI在写任何代码之前，必须先完整阅读所有相关文件并向开发者确认理解。

#### Skills技能系统（18+个）

每个Skill是一个独立目录，包含SKILL.md描述文件和可选的脚本资源。支持跨工具复用——同一套Skills可以被Gemini CLI、Claude Code、GitHub Copilot使用。

#### Prompt评估体系

在`agents/prompts/eval/`中维护15+个评估场景，每次prompt修改后运行回归测试，确保改动不会降低AI表现。

### 与OpenClaw/Hermes的对比

```
Chromium的AI Coding体系 vs OpenClaw/Hermes的Skill体系

共同点：
- 都采用分层Prompt架构
- 都有Skills/技能系统
- 都强调人类监督

差异：
- Chromium：面向大型C++项目，强调代码审查和测试
- OpenClaw/Hermes：面向个人助手，强调任务执行和记忆管理
- Chromium有更强的评估体系（15+场景）
- OpenClaw有更强的记忆系统（双源记忆）
```

### 应用场景

- 大型开源项目的AI辅助开发
- 企业级代码仓库的AI Coding标准化
- AI工具的跨平台复用（同一套Prompt/Skills支持多种AI工具）
- Prompt工程的最佳实践参考

### 局限与注意事项

- 体系设计针对Chromium特定需求，不一定直接适用于其他项目
- 需要团队成员共同遵守AI使用政策
- 评估体系需要持续维护和更新
- 四层架构增加了配置复杂度
