---
title: "Claude Code 源码解析主题"
type: topic
date: 2026-05-30
tags:
  - claude-code
  - source-code-analysis
  - agent-architecture
  - harness-engineering
  - context-engineering
  - prompt-engineering
  - typescript
related_entities:
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
  - "[[Anthropic]]"
sources:
  - "[[逆向深扒Claude-Code源码我发现了什么]]"
  - "[[深度解析Claude-Code在Prompt-Context-Harness的设计与实践]]"
  - "[[Claude-Code-长任务为什么不容易跑偏]]"
  - "[[Claude-Code-源码拆解-从启动到多Agent扩展层]]"
  - "[[Claude-Code-顶级开发团队设计的Harness工程项目源码什么样]]"
  - "[[Claude-Code源码泄露深度解析-51.2万行代码里藏着怎样的AI编程系统]]"
  - "[[Claude-Code-源码架构解析-从启动Prompt到权限管道]]"
---

# Claude Code 源码解析主题

## 主题定义

Claude Code 源码解析涵盖 2026 年上半年社区对 Anthropic 官方 AI 编程助手 Claude Code 的源码级深度分析。这些文章从不同角度拆解了 Claude Code 的 TypeScript 实现，揭示了其作为 Harness Engineering 集大成者的工程设计哲学——从 System Prompt 动态组装、CLAUDE.md 四级注入、三层渐进式上下文压缩，到 Hooks 机制、工具调度系统和多 Agent 扩展层，构成了一个完整的 AI Coding Agent 工程体系。

## 核心要点

1. **三层架构分离关注点**：Claude Code 的核心架构从内到外分为 Prompt 层（解决"如何让模型理解角色"）、Context 层（解决"如何在有限窗口内保留关键信息"）、Harness 层（解决"如何让 Agent 在生产环境中稳定运行"）。这三层分别对应 Prompt Engineering、Context Engineering 和 Harness Engineering 三次范式进化，仅靠 Prompt Engineering 只能达到约 70 分，Context Engineering 提升到 80-85 分，Harness Engineering 将其带到 90-95 分

2. **System Prompt 动态组装而非静态文本**：System Prompt 由 `QueryEngine.ts` 的 `ask()` 函数入口触发，通过 `fetchSystemPromptParts()` 并行获取 defaultSystemPrompt、systemContext（Git 状态信息）、userContext（CLAUDE.md 内容 + 当前日期），再按优先级决策（`overrideSystemPrompt > Coordinator > Agent > customSystemPrompt > defaultSystemPrompt`）组装最终 Prompt，最后通过 `splitSysPromptPrefix()` 拆分为适合 KV Cache 前缀的分块

3. **CLAUDE.md 四级注入成为行业标准**：个人通用偏好（`~/.claude/CLAUDE.md`）、项目共享规范（`项目根目录/CLAUDE.md`）、个人私有指令（`项目根目录/CLAUDE.local.md`）、文件类型特定规则（`.claude/rules/*.md`）四级文件注入机制，后来被 OpenClaw、Cursor 等竞品广泛借鉴，成为 AI Coding Agent 领域的事实标准

4. **三层渐进式上下文压缩体系解决长任务失忆**：MicroCompact（规则驱动微压缩，不调用 LLM，仅压缩 Bash/Read/Grep/Glob 的大型输出）、Session Memory Compact（利用之前生成的会话记忆替换冗长原始历史，无额外 LLM 调用）、Full LLM Compact（通过 LLM 生成结构化 9 段摘要，隐式 CoT 优化，`NO_TOOLS_PREAMBLE` 禁止压缩期间调用工具），AutoCompact 触发机制设置 13,000 token 安全缓冲水位线

5. **Hooks 机制将确定性行为从 LLM 记忆迁移到工程流程**：Hooks 在每次工具调用前后确定性地执行，用于注入规范、验证输出、触发自动化流程，不依赖模型判断。这是 Harness Engineering 的核心实践——把确定性的工作交给脚本和 lint，让 AI 只做理解和决策

6. **长任务执行的六大核心机制**：任务编排元数据文件化（将计划、进度、决策写入文件系统而非依赖脆弱的对话上下文）、TODO 驱动开发（将 TODO 直接插入代码文件）、接力赛式子代理调度（避免并行处理导致的文件冲突）、三步循环（生成任务 → 生成计划 → 实现代码，成功率从 50% 提升到 95%+）、消费约 9 亿 token 的长时连续操作能力、结构化 Memdir 记忆系统

7. **51.2 万行源码揭示的工程规模**：Claude Code 泄露的约 51.2 万行 TypeScript 代码展现了其作为工业级 AI 编程系统的完整度——从 `QueryEngine.ts` 主入口到 `services/compact/` 三层压缩、`services/tools/` 工具注册与执行、`constants/prompts.ts` System Prompt 构建、`utils/systemPrompt.ts` 优先级决策、`context.ts` Git 状态 + CLAUDE.md 加载、`memdir/` 结构化记忆系统，每一个模块都经过精心设计

## 涉及实体

- [[Claude-Code]] —— 被深度解析的 AI 编程助手主体
- [[Harness-Engineering]] —— Claude Code 是 Harness Engineering 理念最完整的工程实现
- [[Anthropic]] —— Claude Code 的开发方

## 对比矩阵

| 维度 | Prompt 层 | Context 层 | Harness 层 |
|------|---|---|---|
| 解决问题 | 如何让模型理解角色 | 如何在有限窗口内保留关键信息 | 如何让 Agent 稳定运行 |
| 典型产物 | System Prompt 动态组装 | 三层渐进式压缩 | Hooks + CLAUDE.md + 权限管道 |
| 得分上限 | ~70 分 | 80-85 分 | 90-95 分 |
| 工程复杂度 | 低 | 中 | 高 |

## 关键来源

- [[逆向深扒Claude-Code源码我发现了什么]] —— 源码级架构全景，揭示 Agent 循环、工具调度、System Prompt 动态组装等核心实现
- [[深度解析Claude-Code在Prompt-Context-Harness的设计与实践]] —— 三层架构分离关注点的详细拆解
- [[Claude-Code-长任务为什么不容易跑偏]] —— 长任务执行可靠性的六大核心机制和从 50% 到 95% 的成功率演化路径
- [[Claude-Code-源码拆解-从启动到多Agent扩展层]] —— 从启动流程到多 Agent 扩展层的架构设计
- [[Claude-Code-顶级开发团队设计的Harness工程项目源码什么样]] —— 顶级开发团队的 Harness 工程源码组织方式
- [[Claude-Code源码泄露深度解析-51.2万行代码里藏着怎样的AI编程系统]] —— 51.2 万行代码的系统性解析
- [[Claude-Code-源码架构解析-从启动Prompt到权限管道]] —— 从启动 Prompt 到权限校验管道的完整链路
