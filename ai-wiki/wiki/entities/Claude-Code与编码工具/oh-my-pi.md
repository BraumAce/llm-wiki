---
title: "oh-my-pi"
type: entity
date: 2026-07-05
also_known_as:
  - "can1357/oh-my-pi"
  - "omp"
  - "@oh-my-pi/pi-coding-agent"
tags:
  - ai-coding-agent
  - terminal-agent
  - lsp
  - dap
  - hashline
  - subagents
sources:
  - "[[oh-my-pi-GitHub]]"
related_entities:
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
  - "[[Agentic-Engineering]]"
  - "[[MCP]]"
  - "[[oh-my-claudecode]]"
---

# oh-my-pi

## 一句话定义

oh-my-pi 是一个开放的终端 AI Coding Agent，把多模型 provider、文件系统工具、LSP/DAP、浏览器、子代理、协作、记忆和 hash-anchor 编辑组织成一套可运行的 coding harness。

## 摘要

[[oh-my-pi-GitHub]] 把项目定位为 “A coding agent with the IDE wired in”，它不是只提供聊天界面或简单 shell 工具，而是试图把一个成熟 IDE、调试器、终端、浏览器和 GitHub/PR 操作面整合进同一 agent 工具空间。README 中的事实点包括 40+ providers、32 个内置工具、14 个 LSP 操作、28 个 DAP 操作，以及约 55k 行 Rust core。仓库形态也是典型多语言 harness：TypeScript/Bun 负责 CLI、agent core、TUI、catalog、AI adapter 和 hashline；Rust crates 提供 native/search/shell/ast 等底层能力；Python `robomp` 则覆盖 GitHub 事件、队列、worker、sandbox 和 dashboard。

它的工程价值在于把 AI Coding Agent 的可靠性问题往工具协议和编辑格式里下沉。传统代码 agent 常见失败是读文件太长、搜索太慢、补丁格式不稳定、rename 破坏 import、调试只靠日志、子任务输出不可结构化。oh-my-pi 对应给出的方案包括 summarized read、in-process search、LSP rename、DAP 调试、Hashline 内容锚点编辑、schema-validated subagent 输出、advisor model 旁路审阅、collab relay、以及 `pr://`、`issue://`、`agent://`、`skill://` 等 filesystem-shaped internal schemes。这些设计都指向同一件事：让模型少猜字符串，多操作稳定对象。

## 详情

### 起源与背景

README 说明 oh-my-pi 是基于 Mario Zechner 的 Pi 项目继续扩展的 fork，目标是把真实世界使用中缺失的 “batteries” 补齐。和单纯提示词工程不同，它更像一个全栈 agent runtime：模型 catalog、tool surface、terminal UI、native utilities、collab web、benchmarks、stats、memory 和 automation service 都在一个 monorepo 里。这个定位和 [[Claude-Code]] 形成直接对照：Claude Code 是官方产品化 coding agent，oh-my-pi 则是开放工具面和编辑协议实验更激进的社区实现。

### 核心机制 / 工作原理

核心机制可以概括为“把 IDE 和运行时暴露给模型”。LSP 让 rename、references、diagnostics、code actions 不再依赖文本猜测；DAP 让 agent 能 attach lldb、dlv、debugpy 并读 frame/variables；persistent Python 与 Bun workers 让代码执行不只是一次性脚本，还能从 kernel 内回调 `read/search/task` 等 agent 工具；Hashline 让模型用内容 hash anchor 指向要改的位置，降低整段重写和 stale patch 风险。

```sh
curl -fsSL https://omp.sh/install | sh
bun install -g @oh-my-pi/pi-coding-agent
eval "$(omp completions zsh)"
```

它还把多 agent 协作设计成一等能力：`task` 可以 fan out 到隔离 worktree，子代理输出是 schema-validated object，parent 读取结构化结果而不是解析散文。advisor model 则在主 agent 每一步旁路审阅，发现风险后以内联 note 形式注入。这些机制把 [[Harness-Engineering]] 中“执行、观察、纠偏、验证”的闭环拆成可组合部件。

### 应用 / 使用场景

- 需要终端优先、跨 provider、可本地运行的 AI Coding Agent。
- 需要 LSP/DAP 深度接入，而不是只靠 grep、patch 和日志调试的代码工作流。
- 需要并行子代理、结构化输出、PR/issue 文件系统化读取和协作会话的团队研发场景。
- 需要评估 Hashline、AST edit、time-traveling stream rules 等新型编辑与控制协议的 agent 工程实验。

### 局限与争议

oh-my-pi 的能力面很宽，意味着集成复杂度也高。LSP、DAP、浏览器、subagent、collab、native Rust utilities 和多 provider catalog 都会引入环境依赖、权限边界和调试成本。它适合愿意把 agent 当工程系统治理的用户；如果只是轻量问答或偶尔生成脚本，完整 harness 可能过重。另一个边界是开放工具面会放大安全和权限问题，尤其是浏览器、GitHub、filesystem-shaped internal schemes 与远程协作能力必须配合明确的权限提示和审计。

## 与其他实体的关系

- [[Claude-Code]] —— 两者都是 AI Coding Agent；Claude Code 是官方产品化路径，oh-my-pi 是开放 harness 和工具协议路线。
- [[Harness-Engineering]] —— oh-my-pi 把编辑、搜索、调试、浏览器、子代理和协作都纳入可验证工具链。
- [[Agentic-Engineering]] —— 它体现了从“生成代码”到“设计 agent 运行系统”的范式转移。
- [[MCP]] —— 项目 topics 和工具生态都涉及 MCP/多 provider 思路，但它更强调统一本地工具面。
- [[oh-my-claudecode]] —— 两者都扩展 coding agent 能力；前者做完整 agent surface，后者围绕 Claude Code 做编排与技能层。

## 参考来源

- [[oh-my-pi-GitHub]]
