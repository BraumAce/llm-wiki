---
title: "深入解析Chromium的AI-Coding开发体系"
type: source
date: 2026-06-01
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/sCmRKJjTpdB4k3145OzZMg"
author: "QQ浏览器团队 · 腾讯技术工程"
ingested_at: 2026-06-02
tags: [Chromium, AI-Coding, Prompt分层, Skills, 评估体系, 开源]
related_entities: [Chromium-AI-Coding, Prompt分层组合架构, Prompt评估体系]
related_topics: [Agent架构演进-主题, AI-Skill体系-主题]
---

# 深入解析Chromium的AI-Coding开发体系

## 一句话概括

腾讯QQ浏览器团队深入分析了Chromium源码仓库中内建的AI Agent基础设施——包括四层Prompt分层组合架构、18+可复用Skills、MCP扩展、知识库、评估体系和大规模AI驱动项目，展示了全球最大C++开源项目如何系统化地拥抱AI Coding。

## 实践内容

### Chromium AI Coding 目录结构

```
chromium/src/agents/
├── ai_policy.md             # AI 使用政策
├── prompts/                 # 提示词系统（分层组合设计）
│   ├── common.minimal.md    # 核心指令层
│   ├── common.md            # 完整工作流层
│   ├── knowledge_base.md    # RAG 知识库
│   ├── templates/           # 平台模板层（desktop/android/ios）
│   └── eval/                # 评估用例（15+ 个场景）
├── skills/                  # 技能系统（18+ 个可复用技能）
├── extensions/              # MCP 扩展（工具能力增强）
├── projects/                # AI 驱动的大型项目
└── testing/                 # Prompt 评估测试框架
```

### 四层 Prompt 分层组合架构

```
第四层：Task Prompts（任务提示词）
  一次性任务指令，如 /cr:gerrit/cl-description

第三层：Templates（平台模板）
  desktop.md / android.md / ios.md / rust.md

第二层：common.md（完整工作流）
  8 步标准编辑流程 + 知识库引用

第一层：common.minimal.md（核心指令）
  构建、测试、编码、JNI 等基础规范
```

开发者通过 GEMINI.md 文件用 @ 引用组合不同层级 prompt。

### AI Policy 核心规则

```
自审义务：作者必须在发送 Review 前自行审查并理解所有代码
  违规 → 剥夺 Committer 权限，再犯 → 封禁账号

原创声明：无论是否使用 AI，作者必须声明代码为自己的原创作品

人类回复人类：AI Agent 创建的 CL 收到人类反馈，必须由人类操作者亲自回复
```

一句话概括：AI 是工具，不是作者——人类开发者对每一行代码负全责。

### 8 步标准编辑工作流

```
Step 1: 深度理解代码（强制第一步，不可跳过）
  ├── 1a. 定位核心文件
  ├── 1b. 完整审计（读取每个文件的完整源码）
  ├── 1c. 陈述理解（向开发者确认）
  └── 1d. 反模式规避：绝不从函数名猜测行为

Step 2: 编写代码（只做需求要求的事）

Step 3: 编写/更新测试

Step 4: 构建

Step 5: 修复编译错误（为每个错误至少读取一个新文件）

Step 6: 运行测试

Step 7: 修复测试错误

Step 8: 迭代（循环 Step 4-7 直到全部通过）
```

### Skills 技能系统（18+ 个）

```
chromium/src/agents/skills/
├── add_feature/
├── fix_bug/
├── write_tests/
├── refactor/
├── code_review/
├── ...（18+ 个可复用技能）
```

每个 Skill 是一个独立目录，包含 SKILL.md 描述文件和可选的脚本资源。支持 Gemini CLI、Claude Code、GitHub Copilot 三种工具复用。

### Prompt 评估体系

```
agents/prompts/eval/
├── 15+ 个评估场景
├── 自动化测试框架
├── 回归测试：每次 prompt 修改后验证效果
```

### 大规模 AI 驱动项目

```
agents/projects/
├── 使用 AI Agent 完成的大型 Chromium 功能开发
├── 设计文档 + prompt 驱动代码生成
```

## 摘录

> Chromium 是全球最大的开源 C++ 项目之一，代码量超过 3500 万行。面对如此庞大的代码库，Chromium 团队在源码仓库中构建了一整套 AI Agent 基础设施——不只是"用 AI 写代码"，而是建立了一套完整的提示词管理、技能系统、知识库、评估体系和大规模自动化项目。

> Chromium 没有使用一个巨大的单体提示词，而是设计了一套四层分层组合的架构，开发者按需组合。核心思路是：尽量固化 System Prompt，将动态的、具体的任务要求剥离出来，通过渐进式披露的方式来进行读取和加载。

> Step 1 的设计尤为关键——它强制 AI 在写任何代码之前，必须先完整阅读所有相关文件并向开发者确认理解。使用过 AI 写代码的同学应该深有体会，充分的上下文理解是保证代码质量的关键，也有助于减少幻觉问题。

> AI 是工具，不是作者——人类开发者对每一行代码负全责。
