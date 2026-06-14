---
title: "你不知道的 Claude Code：架构、治理与工程实践"
type: source
date: 2026-05-31
source_type: webpage
source_url: "https://tw93.fun/2026-03-12/claude.html"
author: "Tw93"
published_at: "2026-03-12"
ingested_at: 2026-05-31
tags:
  - claude-code
  - harness-engineering
  - context-engineering
  - skills
  - hooks
  - subagents
related_entities:
  - "[[Claude-Code]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[Harness-Engineering-主题]]"
---

# 你不知道的 Claude Code：架构、治理与工程实践

## 一句话概括

Tw93 半年深度使用 Claude Code 的经验总结，将 Claude Code 拆为六层架构（上下文/工具/技能/钩子/子代理/验证），配五个诊断面（Context-Action-Control-Isolation-Verification），揭示 MCP 工具定义 25K 固定开销、Tool Output 噪声、Prompt Caching 架构核心等关键工程细节。

## 实践内容

### 200K 上下文的真实成本构成

```
200K 总上下文
├── 固定开销 (~15-20K)
│   ├── 系统指令: ~2K
│   ├── 所有启用的 Skill 描述符: ~1-5K
│   ├── MCP Server 工具定义: ~10-20K  ← 最大隐形杀手
│   └── LSP 状态: ~2-5K
│
├── 半固定 (~5-10K)
│   ├── CLAUDE.md: ~2-5K
│   └── Memory: ~1-2K
│
└── 动态可用 (~160-180K)
    ├── 对话历史
    ├── 文件内容
    └── 工具调用结果
```

一个典型 MCP Server（如 GitHub）包含 20-30 个工具定义，每个约 200 tokens，合计 4,000-6,000 tokens。接 5 个 Server，光固定开销就到 25,000 tokens（12.5%）。

### 上下文分层推荐

```
始终常驻    → CLAUDE.md：项目契约 / 构建命令 / 禁止事项
按路径加载  → rules：语言 / 目录 / 文件类型特定规则
按需加载    → Skills：工作流 / 领域知识
隔离加载    → Subagents：大量探索 / 并行研究
不进上下文  → Hooks：确定性脚本 / 审计 / 阻断
```

### Compact Instructions 模板

```markdown
## Compact Instructions

When compressing, preserve in priority order:

1. Architecture decisions (NEVER summarize)
2. Modified files and their key changes
3. Current verification status (pass/fail)
4. Open TODOs and rollback notes
5. Tool outputs (can delete, keep pass/fail only)
```

### Skills 三种典型类型

**检查清单型（质量门禁）：**
```markdown
---
name: release-check
description: Use before cutting a release to verify build, version, and smoke test.
---
## Pre-flight (All must pass)
- [ ] `cargo build --release` passes
- [ ] `cargo clippy -- -D warnings` clean
- [ ] Version bumped in Cargo.toml
- [ ] CHANGELOG updated
- [ ] `kaku doctor` passes on clean env
```

**工作流型（标准化操作）：**
```markdown
---
name: config-migration
description: Migrate config schema. Run only when explicitly requested.
disable-model-invocation: true
---
## Steps
1. Backup: `cp ~/.config/kaku/config.toml ~/.config/kaku/config.toml.bak`
2. Dry run: `kaku config migrate --dry-run`
3. Apply: remove `--dry-run` after confirming output
4. Verify: `kaku doctor` all pass
## Rollback
`cp ~/.config/kaku/config.toml.bak ~/.config/kaku/config.toml`
```

**领域专家型（封装决策框架）：**
```markdown
---
name: runtime-diagnosis
description: Use when kaku crashes, hangs, or behaves unexpectedly at runtime.
---
## Evidence Collection
1. Run `kaku doctor` and capture full output
2. Last 50 lines of `~/.local/share/kaku/logs/`
3. Plugin state: `kaku --list-plugins`
## Decision Matrix
| Symptom | First Check |
|---|---|
| Crash on startup | doctor output → Lua syntax error |
| Rendering glitch | GPU backend / terminal capability |
```

### Skill 描述符优化

```markdown
# 低效（~45 tokens）
description: |
  This skill helps you review code changes in Rust projects.
  It checks for common issues like unsafe code, error handling...
  Use this when you want to ensure code quality before merging.

# 高效（~9 tokens）
description: Use for PR reviews with focus on correctness.
```

### Hooks 配置示例

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "pattern": "*.rs",
        "hooks": [
          {
            "type": "command",
            "command": "cargo check 2>&1 | head -30",
            "statusMessage": "Running cargo check..."
          }
        ]
      }
    ],
    "Notification": [
      {
        "type": "command",
        "command": "osascript -e 'display notification \"Task completed\" with title \"Claude Code\"'"
      }
    ]
  }
}
```

### CLAUDE.md 高质量模板

```markdown
# Project Contract

## Build And Test
- Install: `pnpm install`
- Dev: `pnpm dev`
- Test: `pnpm test`
- Typecheck: `pnpm typecheck`
- Lint: `pnpm lint`

## Architecture Boundaries
- HTTP handlers live in `src/http/handlers/`
- Domain logic lives in `src/domain/`
- Do not put persistence logic in handlers

## NEVER
- Modify `.env`, lockfiles, or CI secrets without explicit approval
- Remove feature flags without searching all call sites
- Commit without running tests

## Compact Instructions
Preserve:
1. Architecture decisions (NEVER summarize)
2. Modified files and key changes
3. Current verification status (pass/fail commands)
4. Open risks, TODOs, rollback notes
```

### Prompt Caching 架构核心

Prompt 缓存按前缀匹配工作：
```
1. System Prompt → 静态，锁定
2. Tool Definitions → 静态，锁定
3. Chat History → 动态，在后面
4. 当前用户输入 → 最后
```

破坏缓存的陷阱：在静态系统 Prompt 中放入带时间戳的内容、非确定性地打乱工具定义顺序、会话中途增删工具。

defer_loading 机制：发送轻量级 stub（仅工具名），标记 `defer_loading: true`，完整 schema 只在模型选择后才加载。

### 工程化布局参考

```
Project/
├── CLAUDE.md
├── .claude/
│   ├── rules/
│   │   ├── core.md
│   │   ├── config.md
│   │   └── release.md
│   ├── skills/
│   │   ├── runtime-diagnosis/
│   │   ├── config-migration/
│   │   ├── release-check/
│   │   └── incident-triage/
│   ├── agents/
│   │   ├── reviewer.md
│   │   └── explorer.md
│   └── settings.json
└── docs/
    └── ai/
        ├── architecture.md
        └── release-runbook.md
```

## 摘录

> Claude Code 运行的是反复循环的代理过程：收集上下文 → 采取行动 → 验证结果。卡住的地方往往不是模型不够聪明，而是给了错误的上下文，或者输出无法判断对错、无法撤回。单独优化任何一层都会在其他层出问题。

> 一个典型 MCP Server（如 GitHub）包含 20-30 个工具定义，每个约 200 tokens，合计 4,000-6,000 tokens。接 5 个 Server，光固定开销就到 25,000 tokens（12.5%）。在要读大量代码的场景，这 12.5% 很关键。

> 简单记：新动作能力用 Tool/MCP，一套工作方法用 Skill，隔离执行环境用 Subagent，强制约束和审计用 Hook，跨项目分发用 Plugin。

> Skill 官方描述是"按需加载的知识与工作流"，描述符常驻上下文，完整内容按需加载。描述要让模型知道"何时该用我"，而不是"我是干什么的"。

> 用 Claude Code 大概会经历三个阶段：工具使用者（"这个功能怎么用"）→ 流程优化者（"如何让协作更顺"）→ 系统设计者（"如何让 Agent 在约束下自主运作"）。核心洞察：假如一个任务说不清楚"什么叫做完"，大概率也不适合直接扔给 Claude 自主完成。

## 涉及实体

- [[Claude-Code]] —— 本文从六层架构全面拆解 Claude Code 的设计与工程实践
- [[Harness-Engineering]] —— 本文是 Harness Engineering 的实践指南，涵盖上下文/工具/技能/钩子/子代理/验证六层治理
- [[MCP]] —— MCP 工具定义是上下文的最大隐形杀手，5 个 Server 占 25K tokens
- [[OpenClaw-Skills]] —— Skills 的三种典型类型和渐进式披露设计

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[Harness-Engineering-主题]]

## 我的评注

Tw93 这篇是目前中文社区对 Claude Code 工程实践最全面的拆解。核心价值在于：
1. **上下文成本量化**：首次给出 MCP 工具定义的具体 token 开销数据（25K/12.5%），这对实际项目决策非常关键
2. **六层架构模型**：比单纯讲"怎么用"高出一层，提供了排查问题的系统性框架
3. **Prompt Caching 洞察**：揭示了 Claude Code 整个架构围绕缓存设计的事实，包括 defer_loading 机制
4. **反模式清单**：8 个常见反模式非常实用，尤其是"CLAUDE.md 当 wiki"和"Skill 大杂烩"
