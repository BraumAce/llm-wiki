---
title: "oh-my-claudecode"
type: entity
date: 2026-07-05
also_known_as:
  - "Yeachan-Heo/oh-my-claudecode"
  - "OMC"
  - "oh-my-claude-sisyphus"
  - "omc"
tags:
  - claude-code
  - multi-agent
  - team-mode
  - skills
  - tmux
  - orchestration
sources:
  - "[[oh-my-claudecode-GitHub]]"
related_entities:
  - "[[Claude-Code]]"
  - "[[Agent-Skill]]"
  - "[[Harness-Engineering]]"
  - "[[Agentic-Engineering]]"
  - "[[Cursor]]"
  - "[[oh-my-pi]]"
---

# oh-my-claudecode

## 一句话定义

oh-my-claudecode 是 Claude Code 的多代理编排与技能扩展层，通过插件、CLI、Team pipeline、tmux workers、HUD、通知、记忆和项目级 skills，把 Claude Code 个人会话扩展成可治理的工程工作流。

## 摘要

[[oh-my-claudecode-GitHub]] 明确把项目定位为 “Teams-first Multi-agent orchestration for Claude Code”。它不是替代 [[Claude-Code]] 的独立模型客户端，而是围绕 Claude Code 会话提供编排、技能、可观测性和自动化层。README 把入口分成两类：一类是 Claude Code 内的 slash skills，例如 `/setup`、`/omc-setup`、`/team`、`/autopilot`、`/ralph`、`/ultrawork`、`/deep-interview`；另一类是终端 CLI，例如 `omc setup`、`omc team`、`omc ask`、`omc wait`。这种分层很关键，因为它区分了需要活跃 Claude Code 会话的交互能力，以及可在 shell、CI 或 tmux 中执行的确定性命令。

项目的核心价值在于把 Claude Code 周边生态产品化。README 中 Team 被定义为 canonical orchestration surface，执行 pipeline 是 `team-plan → team-prd → team-exec → team-verify → team-fix`；CLI 版 `omc team` 则能启动真实 `claude`、`codex`、`gemini`、`antigravity`、`grok`、`cursor-agent` worker panes。仓库中还有大量 `skills/*/SKILL.md`，涵盖 autopilot、ultrawork、ultraqa、remember、skillify、visual-verdict、configure-notifications、wiki、mcp-setup、hud 等。这使它更像 Claude Code 的工作流发行版，而不是单个插件。

## 详情

### 起源与背景

Claude Code 本身已经提供强大的工具调用、上下文注入和代码执行能力，但复杂任务仍会遇到角色分工、长任务坚持、团队协作、跨模型复核、通知、记忆沉淀和技能复用等问题。oh-my-claudecode 的 README 以 “Zero learning curve” 包装这些能力，实际设计却很工程化：插件安装、npm runtime、workspace state、项目级 `.omc/skills/`、`.omc/` runtime data、worktree 状态、multi-repo workspace marker、notification hooks 和 session summaries 都有清晰的落点。

### 核心机制 / 工作原理

OMC 的基本安装路径是 Claude Code marketplace/plugin，也可以用 npm 包 `oh-my-claude-sisyphus` 安装 `omc` 命令。Team mode 是主编排面：在会话内 `/team` 走 native team workflow；在终端 `omc team` 则启动 tmux CLI worker。`/ccg` 通过 `/ask codex` 和 `/ask antigravity` 形成多模型 advisor synthesis；`/autopilot` 面向端到端执行；`/ralph` 面向 persistent verified completion；`/ultraqa` 面向质量门循环；`/deep-interview` 面向需求澄清。技能层则支持项目级与用户级 skill，`/skillify` 可把会话中的经验提炼成可复用 skill。

```bash
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
npm i -g oh-my-claude-sisyphus@latest
omc setup
/team 3:executor "fix all TypeScript errors"
```

### 应用 / 使用场景

- 在 Claude Code 内将复杂任务拆成计划、PRD、执行、验证和修复阶段。
- 用 tmux worker 同时调用 Codex、Gemini、Antigravity、Grok、Cursor 等外部 CLI 做 review、设计、实现或交叉验证。
- 将团队经验沉淀成项目级 skills，并在相关任务自动注入。
- 给长任务增加 HUD、通知、session artifacts、friction reports 和 rate-limit wait。

### 局限与争议

oh-my-claudecode 的能力很多，但这也要求用户理解“会话内 skill”和“终端 CLI”之间的边界。README 自身也强调 CI/CD 和 headless automation 不应依赖交互式 slash commands，而应使用 deterministic terminal commands 和 runner 环境中的认证。另一个边界是多 agent 并行并不自动等于高质量：如果任务边界、验收标准、共享上下文和冲突解决不清楚，更多 worker 只会增加协调成本。它更适合已经接受 [[Harness-Engineering]] 思维的团队，而不是只想安装一个提示词包的用户。

## 与其他实体的关系

- [[Claude-Code]] —— oh-my-claudecode 是围绕 Claude Code 的插件/CLI 编排层。
- [[Agent-Skill]] —— 仓库以大量 skill 包表达能力，并支持项目级 skill 提取、搜索和自动注入。
- [[Harness-Engineering]] —— setup、Team、verify/fix、HUD、notifications 和 state 目录都是 harness 化控制点。
- [[Agentic-Engineering]] —— OMC 将任务执行从单 agent 对话推进到多角色、多阶段和多模型协作。
- [[Cursor]] —— `omc team` 支持 Cursor executor worker。
- [[oh-my-pi]] —— 两者都增强 coding agent 运行环境；oh-my-pi 更偏完整 agent surface，OMC 更偏 Claude Code orchestration。

## 参考来源

- [[oh-my-claudecode-GitHub]]
