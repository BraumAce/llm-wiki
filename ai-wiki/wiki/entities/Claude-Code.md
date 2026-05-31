---
title: "Claude Code"
type: entity
date: 2026-05-30
also_known_as:
  - "Claude Code CLI"
  - "claude-code"
  - "@anthropic-ai/claude-code"
tags:
  - ai-coding
  - agent
  - cli-tool
  - anthropic
  - harness-engineering
  - context-engineering
  - replit
sources:
  - "[[逆向深扒Claude-Code源码我发现了什么]]"
  - "[[深度解析Claude-Code在Prompt-Context-Harness的设计与实践]]"
  - "[[Claude-Code-长任务为什么不容易跑偏]]"
  - "[[Claude-code云端部署-魔改sdk实现http流式调用]]"
  - "[[Claude-Code-Harness工程-数仓侧落地方案-得物技术]]"
  - "[[OpenAI-Codex-Plugin-for-Claude-Code源码剖析]]"
  - "[[Claude-Code-源码拆解-从启动到多Agent扩展层]]"
  - "[[Claude-Code-顶级开发团队设计的Harness工程项目源码什么样]]"
  - "[[Claude-Code源码泄露深度解析-51.2万行代码里藏着怎样的AI编程系统]]"
  - "[[Claude-Code-源码架构解析-从启动Prompt到权限管道]]"
  - "[[你不知道的-Claude-Code-架构治理与工程实践]]"
  - "[[Claude-Code防封号指南-国内终极解决方案]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[OpenClaw]]"
  - "[[Agent-Memory]]"
  - "[[Spec-Driven-Development]]"
  - "[[Hermes-Agent]]"
---

# Claude Code

## 一句话定义

Claude Code 是 Anthropic 官方推出的命令行 AI 编程助手（CLI Agent），基于 TypeScript 实现，采用 ReAct 推理循环 + 工具调用架构，通过 System Prompt 动态组装、CLAUDE.md 四级注入、三层渐进式上下文压缩和 Memdir 结构化记忆系统，在终端中提供代码阅读、编辑、调试、搜索、网页抓取等全链路编程能力。

## 摘要

Claude Code 是 2026 年 AI Coding Agent 领域最具影响力的工具之一。它不是一个简单的"把用户问题发给 LLM"的包装器，而是一个包含动态 Prompt 组装、多层上下文压缩、权限管控、工具调度和记忆管理的完整工程体系。其核心架构从内到外分为三层：Prompt 层解决"如何让模型理解角色"，Context 层解决"如何在有限窗口内保留关键信息"，Harness 层解决"如何让 Agent 在生产环境中稳定运行"。业界将其视为从 Prompt Engineering 到 Context Engineering 再到 Harness Engineering 三次范式进化的集大成者——仅靠 Prompt Engineering 只能达到约 70 分，Context Engineering 提升到 80-85 分，而 Harness Engineering 将其带到 90-95 分。

Claude Code 的设计哲学深刻影响了 2026 年上半年的 AI 工程实践：CLAUDE.md 四级注入机制成为行业标准，被 OpenClaw、Cursor 等竞品广泛借鉴；三层上下文压缩体系（MicroCompact / Session Memory Compact / Full LLM Compact）为长任务执行提供了工程化的解决方案；其 Hooks 机制让确定性行为不再依赖模型记忆，而是沉淀为可审计的工程流程。

## 详情

### 起源与背景

Claude Code 由 Anthropic 于 2025 年底推出，最初定位为面向开发者的命令行编程助手。与同期出现的 Cursor（IDE 集成）、OpenCode、Aider 等工具不同，Claude Code 选择了纯 CLI 路线——不提供图形界面，完全在终端中运行，通过 ReAct 循环驱动工具调用完成编程任务。

这一设计选择背后的逻辑是：CLI 天然适合与现有开发工作流（Git、CI/CD、Shell 脚本）集成，且不受 GUI 框架的限制，可以更灵活地扩展工具系统。2026 年初，随着 Claude Opus 4.6 等更强模型的发布，Claude Code 的能力边界迅速扩展，从简单的代码补全演变为能够执行复杂长任务的自主 Agent。

### 核心架构

Claude Code 的源码基于 TypeScript 实现，核心入口文件为 `QueryEngine.ts`，整体架构可分为以下几个关键模块：

```
src/
├── QueryEngine.ts              # 主入口，编排 LLM 调用
├── constants/
│   ├── prompts.ts              # System Prompt 构建
│   └── systemPromptSections.ts # 缓存友好的分块
├── services/
│   ├── compact/                # 三层上下文压缩
│   │   ├── microCompact.ts     # 规则驱动微压缩
│   │   ├── smCompact.ts        # 会话记忆压缩
│   │   └── compact.ts          # Full LLM 压缩
│   └── tools/                  # 工具注册与执行
├── utils/
│   └── systemPrompt.ts         # Prompt 优先级决策
├── context.ts                  # Git 状态 + CLAUDE.md 加载
└── memdir/                     # 结构化记忆系统
```

### ReAct 推理循环

Claude Code 采用经典的 ReAct（Reasoning + Acting）循环模式：

1. 用户输入 → 构建 System Prompt + 用户消息
2. 调用 Anthropic API（streaming 模式）
3. 解析响应：文本回复或工具调用
4. 执行工具 → 将结果追加到对话历史
5. 循环直到模型返回最终文本回复（无工具调用）

循环次数由 `MAX_RUN_LOOP_ITERATIONS` 参数控制，防止无限循环。

### 内置工具系统

Claude Code 内置了覆盖编程全链路的工具集：

- **Read** —— 读取文件，支持图片、PDF、Jupyter notebook 等多模态内容
- **Write** —— 覆盖式写入文件
- **Edit** —— 精确字符串替换编辑（非全文重写，确保最小变更）
- **Bash** —— 执行 shell 命令，支持后台运行和超时控制
- **Grep** —— 基于 ripgrep 的正则内容搜索
- **Glob** —— 文件模式匹配（如 `**/*.ts`）
- **WebFetch** —— 抓取网页内容并转换为 Markdown
- **WebSearch** —— 网络搜索

工具输出遵循 token 限制，过长输出会被自动截断。Edit 和 Write 的核心状态变更操作在上下文压缩时被完整保留，以确保后续决策的准确性。

### System Prompt 动态组装

Claude Code 的 System Prompt 不是静态文本，而是由多个组件动态组装而成。组装流程经过六个步骤：

1. **QueryEngine 发起请求**：`QueryEngine.ts` 的 `ask()` 函数是主入口
2. **获取三个组件**：`fetchSystemPromptParts()` 并行获取 defaultSystemPrompt、systemContext（Git 状态信息）、userContext（CLAUDE.md 内容 + 当前日期）
3. **组装默认 System Prompt**：分为静态部分（角色定义、工具使用规范、安全约束）和动态部分，中间有 `SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 分隔符
4. **优先级决策**：按从高到低的优先级选择最终 Prompt —— `overrideSystemPrompt > Coordinator > Agent > customSystemPrompt > defaultSystemPrompt`
5. **上下文注入**：`appendSystemContext()` 追加 Git 状态快照，`prependUserContext()` 将 CLAUDE.md 作为 `<system-reminder>` 插入用户消息列表最前面
6. **缓存友好的分块**：`splitSysPromptPrefix()` 将 System Prompt 拆分为适合 KV Cache 前缀的分块

### CLAUDE.md 四级注入机制

CLAUDE.md 是 Claude Code 最具标志性的设计之一——通过四级文件注入，让开发者用纯文本定义 AI 的行为规范：

| 级别 | 路径 | 用途 | 是否提交 Git |
|------|------|------|-------------|
| 个人通用偏好 | `~/.claude/CLAUDE.md` | 开发者个人全局角色（如"始终用中文回复"） | 不适用 |
| 项目共享规范 | `项目根目录/CLAUDE.md` | 项目架构描述、统一编码标准、构建命令 | 是 |
| 个人私有指令 | `项目根目录/CLAUDE.local.md` | 不应公开但当前开发者需要的信息 | 否 |
| 文件类型特定规则 | `.claude/rules/*.md` | 按文件类型或业务领域拆分规则 | 视情况 |

这一机制后来被 OpenClaw、Cursor 等竞品广泛借鉴，成为 AI Coding Agent 领域的事实标准。

### 三层渐进式上下文压缩体系

上下文管理是 Claude Code 最核心的工程创新。系统采用三层渐进式压缩，逐级降级：

**第 1 层：MicroCompact（微压缩）**——规则驱动，不调用 LLM，成本最低。定义可压缩工具白名单（Bash、Read、Grep、Glob），仅压缩这些工具的大型标准化输出。Edit 和 Write 的状态变更完整保留。执行路径分两种：基于时间截断旧消息，或基于 KV Cache 边界仅在边界外压缩。

**第 2 层：Session Memory Compact（会话记忆压缩）**——利用之前生成的会话记忆替换冗长的原始历史消息，无额外 LLM 调用。触发阈值为上下文 token 超过 10,000 且文本消息数超过 5，每次执行最多压缩 40,000 token。

**第 3 层：Full LLM Compact（完全 LLM 压缩）**——通过调用 LLM 生成结构化摘要，强制使用 9 段模板（主要请求和意图、关键技术概念、文件和代码段、错误和修复、问题解决、所有用户消息、待处理任务、当前工作、可选的下一步）。采用隐式 CoT 优化——要求模型在 `<analysis>` 标签内执行逻辑分析，程序剥离后只保留 `<summary>` 中的干净摘要。同时通过 `NO_TOOLS_PREAMBLE` 严格禁止压缩期间调用任何工具。

AutoCompact 触发机制设置 13,000 token 的安全缓冲水位线，采用分层降级策略：首选 Session Memory Compact（无 LLM 调用，最快），不足时降级到 Full LLM Compact。

### Memdir 结构化记忆系统

Claude Code 的 Memdir 系统提供四种核心记忆类型：

- **User** —— 个人偏好、操作习惯和特定指令风格
- **Feedback** —— 模型行为纠正和历史错误案例（"避坑指南"）
- **Project** —— 技术选型、架构决策和约束
- **Reference** —— 常用文档片段和代码模式

`loadMemoryPrompt` 函数扫描记忆目录、按类型分类、动态裁剪内容并生成格式化记忆提示。`findRelevantMemories.ts` 引入 Sonnet 模型进行语义检索，返回最多 5 个最相关记忆，避免将全部记忆塞入上下文。

### 长任务执行与子代理调度

Claude Code 在执行长任务时展现出高度的可靠性，核心机制包括：

- **任务编排元数据文件化**：将任务计划、进度、决策写入文件系统，而非依赖脆弱的对话上下文。有开发者报告在单日连续操作中消耗约 9 亿 token
- **TODO 驱动开发**：将 TODO 直接插入代码文件，代码库本身成为唯一的真相来源，缺失的工作直接定位在相关文件中
- **接力赛式子代理调度**：避免并行处理导致的文件冲突，每次只派出一个 Sub-Agent 专注一个阶段，完成后再交接
- **三步循环**：生成任务 → 生成计划 → 实现代码，成功率从 50%（仅 README + CLAUDE.md）提升到 75%（独立 task-plan.md）再到 95%+（自动化 CLI 工具生成任务文件）

### Hooks 机制

Claude Code 的 Hooks 系统是 Harness Engineering 的核心实践——将确定性行为从不可靠的 LLM 记忆迁移到工程化的 hooks + 持久化文件中。Hooks 在每次工具调用前后确定性地执行，用于注入规范、验证输出、触发自动化流程，不依赖模型判断。

### 应用 / 使用场景

- **日常编程**：代码阅读、编辑、调试、重构，支持图片和 PDF 等多模态输入
- **长任务执行**：跨文件重构、大规模迁移、overnight 自动化开发
- **Harness 工程化**：得物技术团队在数仓场景下用 CLAUDE.md + hooks + subagents 构建五层防御体系，解决 compact 后约束丢失问题
- **云端部署**：通过 npm pack 离线打包 + FastAPI + SSE 魔改 SDK，实现 HTTP 流式调用和多用户沙箱隔离
- **插件生态**：OpenAI 官方推出 codex-plugin-cc，将 Codex 变成 Claude Code 工作流里的第二审阅者和异步 worker

### 局限与争议

- **Context 膨胀与失忆**：越是复杂的需求越依赖 AI，但 context 越容易撑满，AI 越容易"失忆"。得物团队报告"金额字段单位是千元"的约束在对话进行到一半后被遗忘，导致数据差 1000 倍
- **长任务可靠性非 100%**：即使有完善的机制，约 25% 的 overnight 输出仍需丢弃，长任务不是"放手不管"的
- **过度工程化风险**：Harness 过厚会降低开发速度，"合适厚度"需要团队自己摸索
- **成本问题**：Full LLM Compact 需要额外 LLM 调用，大规模使用时 token 成本可观
- **本地优先 vs 云端**：CLI 工具天然受限于本地环境，云端部署需要额外的 SDK 改造和沙箱隔离工程

## 与其他实体的关系

- [[Harness-Engineering]] —— Claude Code 是 Harness Engineering 理念最完整的工程实现。CLAUDE.md 四级注入、Hooks 机制、三层上下文压缩体系是 Harness 的核心组件。得物团队称"Harness = Claude Code 的宿主运行框架"
- [[OpenClaw]] —— 同为 Agent 系统但定位不同：Claude Code 聚焦 AI Coding（开发者工具），OpenClaw 聚焦个人 AI 助手（日常交互）。两者在 CLAUDE.md 注入、上下文管理、工具系统等方面有大量设计交集
- [[Agent-Memory]] —— Claude Code 的 Memdir 系统和三层上下文压缩体系是 Agent Memory 的一种实现路径，与 OpenClaw 的双源记忆系统、腾讯云的 4 层渐进式管道形成对比
- [[Spec-Driven-Development]] —— SDD 的 Spec 文档 + constitution.md 设计与 Claude Code 的 CLAUDE.md 四级注入异曲同工，两者经常组合使用
- [[Hermes-Agent]] —— 同为 Harness Engineering 的实现载体，但在高可用、运维成本方面面临不同挑战

## 参考来源

- [[逆向深扒Claude-Code源码我发现了什么]] —— 源码级架构解析，揭示 Agent 循环、工具调度、System Prompt 动态组装等核心实现
- [[深度解析Claude-Code在Prompt-Context-Harness的设计与实践]] —— 三层渐进式上下文压缩体系和 CLAUDE.md 四级注入机制的详细拆解
- [[Claude-Code-长任务为什么不容易跑偏]] —— 长任务执行可靠性的六大核心机制和从 50% 到 95% 的成功率演化路径
- [[Claude-code云端部署-魔改sdk实现http流式调用]] —— 云端部署的四层架构（离线打包、HTTP 服务化、镜像构建、沙箱隔离）
- [[Claude-Code-Harness工程-数仓侧落地方案-得物技术]] —— 数仓场景下 Harness 工程的五层防御体系实践
- [[OpenAI-Codex-Plugin-for-Claude-Code源码剖析]] —— OpenAI Codex 插件的桥接架构，将 Codex 集成为 Claude Code 的第二审阅者
