---
title: "深度解析 Claude Code 在 Prompt / Context / Harness 的设计与实践"
type: source
date: 2026-05-30
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/YgGW92VBP8s846yzIxjVWQ"
author: "阿里云开发者 / 飞樰"
published_at: "2026-04-20"
ingested_at: 2026-05-30
tags:
  - claude-code
  - prompt-engineering
  - context-engineering
  - harness-engineering
  - agent-system
  - context-compression
related_entities:
  - "[[Claude-Code]]"
  - "[[Claude-Opus]]"
  - "[[Claude-Sonnet]]"
  - "[[OpenClaw]]"
related_topics:
  - "[[Agent-系统设计方法论]]"
  - "[[Context-Compression]]"
  - "[[CLAUDE-md]]"
---

# 深度解析 Claude Code 在 Prompt / Context / Harness 的设计与实践

## 一句话概括

阿里云开发者公众号上由"飞樰"撰写的 Claude Code 三维度深度解析，最大亮点是**详细拆解了 Claude Code 的三层渐进式上下文压缩体系**（MicroCompact / Session Memory Compact / Full LLM Compact）以及 System Prompt 的动态组装流程、CLAUDE.md 四级注入机制和 Memdir 结构化记忆系统，为构建 95 分 Agent 系统提供了从 Prompt（70 分）到 Context（80-85 分）再到 Harness（90-95 分）的完整方法论。

## 实践内容

### System Prompt 动态组装流程

**步骤 1：QueryEngine 发起请求**

`QueryEngine.ts` 中的 `ask()` 函数是主入口，流程经过 `fetchSystemPromptParts()` → `buildEffectiveSystemPrompt()` → `query()` 发送到 API。

**步骤 2：获取三个组件**

`queryContext.ts` 中的 `fetchSystemPromptParts()` 并行获取：
1. **defaultSystemPrompt** —— `constants/prompts.ts` 中的 `getSystemPrompt()` 构建
2. **systemContext** —— `context.ts` 中的 `getSystemContext()` 获取（Git 状态信息）
3. **userContext** —— `context.ts` 中的 `getUserContext()` 获取（CLAUDE.md 内容 + 当前日期）

**步骤 3：组装默认 System Prompt**

核心函数 `constants/prompts.ts` 中的 `getSystemPrompt()` 将 prompt 分为静态和动态两部分，中间有 `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 分隔。

**步骤 4：优先级决策**

`utils/systemPrompt.ts` 中的 `buildEffectiveSystemPrompt()` 按优先级选择（从高到低）：
1. `overrideSystemPrompt` —— 强制覆盖（loop 模式），立即返回忽略一切
2. Coordinator prompt —— 协调器模式激活时
3. Agent prompt —— 用户定义的 Agent prompt
4. `customSystemPrompt` —— `--system-prompt` 参数传递
5. `defaultSystemPrompt` —— 标准 prompt

`appendSystemPrompt` 始终追加到末尾（override 模式除外）。

**步骤 5：上下文注入**
1. `appendSystemContext()` —— 追加 Git 状态快照到 System Prompt 末尾
2. `prependUserContext()` —— 将 CLAUDE.md 和当前日期作为 `<system-reminder>` 插入用户消息列表最前面

**步骤 6：缓存友好的分块**

`constants/systemPromptSections.ts` 中的 `splitSysPromptPrefix()` 将 System Prompt 拆分为缓存友好的分块，标识哪些段适合 KV Cache 前缀。

### CLAUDE.md 四级注入机制

**个人通用偏好** —— `~/.claude/CLAUDE.md`，定义开发者个人全局角色（如"始终用中文回复"），用户级静态配置在所有项目中生效。

**项目共享规范** —— 项目根目录的 `CLAUDE.md`，必须提交到 Git，包含项目架构描述、统一编码标准、构建命令等公共知识。

**个人私有指令** —— `CLAUDE.local.md`，存储不应公开但当前开发者需要的信息（如"我负责支付模块"），不提交到 Git。

**文件类型特定规则** —— `.claude/rules/*.md` 目录，按文件类型或业务领域拆分规则，使用 Frontmatter 限制在特定文件路径。

### 三层渐进式上下文压缩体系

**第 1 层：MicroCompact（微压缩）**

实现在 `src/services/compact/microCompact.ts`，规则驱动不调用 LLM。

- 定义可压缩工具白名单 `COMPACTABLE_TOOLS`（Bash、Read、Grep、Glob），Edit 和 Write 的核心状态变更操作完整保留
- 多模态内容统一估算为 2000 token
- 两条执行路径：
  1. 基于时间 —— 截断超过时间阈值的旧消息工具输出
  2. 基于缓存 —— 识别 KV Cache 边界，仅在边界外压缩

**第 2 层：Session Memory Compact（会话记忆压缩）**

利用之前生成的会话记忆替换冗长的原始历史消息，无额外 LLM 调用。

配置 `DEFAULT_SM_COMPACT_CONFIG`：
- 触发阈值：上下文 token ≥ 10,000 且文本消息数 ≥ 5
- 压缩上限：每次执行最多压缩 40,000 token
- 执行逻辑：用会话记忆摘要替换旧消息，严格保留近期消息

**第 3 层：Full LLM Compact（完全 LLM 压缩）**

通过 `services/compact/compact.ts` 中的 `compactConversation` 执行，强制 9 段结构化模板：

1. 主要请求和意图（Primary Request and Intent）
2. 关键技术概念（Key Technical Concepts）
3. 文件和代码段（Files and Code Sections）
4. 错误和修复（Errors and fixes）
5. 问题解决（Problem Solving）
6. 所有用户消息（All user messages）
7. 待处理任务（Pending Tasks）
8. 当前工作（Current Work）
9. 可选的下一步（Optional Next Step）

关键 Prompt Engineering 技术：
- **隐式 CoT 优化** —— 要求模型在 `<analysis>` 标签内执行逻辑分析，程序剥离后只保留 `<summary>` 标签中的干净摘要
- **反工具调用保护** —— `NO_TOOLS_PREAMBLE` 严格禁止压缩期间调用任何工具

**AutoCompact 触发机制**

安全缓冲水位线 `AUTOCOMPACT_BUFFER_TOKENS = 13,000`，分层降级策略：
1. 首选 Session Memory Compact（无 LLM 调用，最快）
2. 降级到 Full LLM Compact（生成高质量摘要）

### Memdir 结构化记忆系统

四种核心记忆类型：
- **User** —— 个人偏好、操作习惯和特定指令风格
- **Feedback** —— 模型行为纠正和历史错误案例（"避坑指南"）
- **Project** —— 技术选型、架构决策和约束
- **Reference** —— 常用文档片段和代码模式

`memdir/memdir.ts` 中的 `loadMemoryPrompt` 函数扫描记忆目录、按类型分类、动态裁剪内容并生成格式化记忆提示。

`memdir/findRelevantMemories.ts` 引入 Sonnet 模型进行语义检索，返回最多 5 个最相关记忆。

## 摘录

> 一个常见的误解是，编写一段精心打磨的"prompt"就构成了良好的 prompt engineering。实际上，真正的"工程"体现在生产环境中如何根据角色、系统行为、安全规则、任务需求、工具规格、技能要求和约束条件来动态组装 prompt。这就是为什么业界正在从"如何写好 prompt"转向更广泛的"如何组装 prompt"。

> 如果要构建一个 95 分的 Agent 系统，仅靠 Prompt Engineering 实际上只能达到大约 70 分，Context Engineering 可以将其提升到 80-85 分，而 Harness Engineering 则将其带到 90-95 分。

> 与普遍认为压缩需要 LLM 摘要的观点相反，规则驱动的微压缩对结构化工具输出具有最高的投资回报率。系统定义了可压缩工具白名单，仅压缩 Bash、Read、Grep 和 Glob 等产生大型标准化输出的工具的输出。Edit 和 Write 的核心状态变更操作被完整保留，以确保后续决策的准确性。

> AutoCompact 触发机制编排三种压缩方法，设置安全缓冲水位线。决策过程遵循分层降级策略：首先尝试 Session Memory Compact（无 LLM 调用，最快，成本最低）。如果 SM Compact 不符合条件或压缩不足，系统自动降级到 Full LLM Compact 生成高质量摘要。该系统体现了"上下文工程"的本质：构建一个动态、分层、成本感知的系统，在正确的时间以正确的成本应用适当的信息压缩。

## 涉及实体

- [[Claude-Code]] —— 本文的核心分析对象，一款极其强大的 AI Coding Agent
- [[Claude-Opus]] —— Claude Code 使用的基础模型（Claude Opus 4.6）
- [[Claude-Sonnet]] —— 用于 Memdir 语义检索的模型
- [[OpenClaw]] —— 作者此前分析的对比对象，同为 Agent 系统但定位为个人 AI 助手

## 涉及主题

- [[Agent-系统设计方法论]] —— Prompt Engineering → Context Engineering → Harness Engineering 三阶段递进
- [[Context-Compression]] —— 三层渐进式压缩体系（MicroCompact / SM Compact / Full LLM Compact）
- [[CLAUDE-md]] —— 四级注入机制（个人通用 / 项目共享 / 个人私有 / 文件类型特定）
