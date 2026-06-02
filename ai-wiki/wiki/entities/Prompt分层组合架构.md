---
title: "Prompt分层组合架构"
type: entity
date: 2026-06-02
also_known_as: [分层Prompt设计, Prompt分层组合]
tags: [Prompt, 架构设计, 渐进式加载]
sources: [深入解析Chromium的AI-Coding开发体系, Agent核心技术概念与范式发生了哪些演变以及背后的思考]
related_entities: [Context-Engineering, Chromium-AI-Coding, OpenClaw-Skills, Spec-Driven-Development]
related_topics: [Agent架构演进-主题]
---

# Prompt分层组合架构

## 一句话定义

Prompt分层组合架构是将传统的单体大System Prompt拆分为多层结构（核心指令→工作流→平台模板→任务提示词），通过引用机制按需组合，实现"动静分离"的Prompt工程最佳实践。

## 摘要

Prompt分层组合架构是Context Engineering在Prompt组织层面的具体实现方式。其核心思想是：将System Prompt按稳定性和复用性分为多层，固化底层（核心指令），灵活组合上层（平台模板、任务提示词）。Chromium的四层架构是这一理念的最佳实践——common.minimal.md（核心指令）→ common.md（完整工作流）→ templates/（平台模板）→ task prompts（任务提示词），开发者通过`@`引用按需组合。这种方式大幅降低了Prompt维护成本，提升了跨团队、跨平台的复用性。

## 详情

### 起源与背景

早期构建Agent时，Prompt设计是"一个任务一个Agent，一段精心调试的System Prompt"。随着场景增多，Prompt管理变得极其混乱——每个Agent背后都有一段独立的、长篇的System Prompt，维护成本极高。Agent技术演进中出现了"动静分离"的思路：将System Prompt中的稳定部分（核心指令、行为规范）固化，将易变部分（任务要求、领域知识）剥离到外部文件，通过渐进式加载实现灵活组合。

### 核心机制 / 工作原理

#### 分层设计原则

```
底层（高稳定性，跨任务复用）：
  核心指令、基本行为规范、通用工具定义
  → 变化频率：月级
  → 复用范围：所有任务

中层（中等稳定性，按场景组合）：
  平台模板、领域知识、工作流定义
  → 变化频率：周级
  → 复用范围：同类任务

顶层（低稳定性，动态变化）：
  具体任务指令、用户输入、上下文
  → 变化频率：每次对话
  → 复用范围：单次任务
```

#### Chromium的四层实现

```
第一层：common.minimal.md（核心指令）
  构建目录确认、测试运行方式、编码规范、JNI规则
  所有开发者共享，变化最少

第二层：common.md（完整工作流）
  8步标准编辑流程
  自动包含第一层

第三层：templates/（平台模板）
  desktop.md / android.md / ios.md / rust.md
  特定平台的文件命名、构建目标、测试方式

第四层：Task Prompts（任务提示词）
  一次性任务指令，如 /cr:gerrit/cl-description
  变化最频繁
```

#### 与单体Prompt的对比

```
单体Prompt：
  - 所有内容写在一个大文件中
  - 维护成本高，修改风险大
  - 跨任务复用困难
  - 上下文窗口浪费

分层组合架构：
  - 按稳定性分层，各层独立维护
  - 修改底层不影响上层
  - 跨任务复用同一底层
  - 按需组合，节省token
```

#### 渐进式加载机制

在Agent执行过程中，根据当前任务动态加载所需的层级：

```
1. 系统启动：加载第一层（核心指令）→ 始终生效
2. 任务识别：加载第二/三层（工作流/平台模板）→ 按需
3. 具体执行：加载第四层（任务提示词）→ 动态
```

### 应用场景

- 大型项目的AI Coding标准化（如Chromium）
- 多平台Agent开发（同一核心指令，不同平台模板）
- 企业级Agent系统的Prompt管理
- Context Engineering的组织层实践

### 局限与注意事项

- 分层设计需要前期投入，不适合快速原型
- 层级之间的引用关系需要清晰的文档
- 过度分层可能增加配置复杂度
- 需要团队共识和规范来维护层级边界
