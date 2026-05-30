---
title: "Claude Code源码泄露深度解析：51.2万行代码里藏着怎样的AI编程系统"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/JDjXDArHdu1GVsg2y9J0cQ"
author: "石臻说AI"
ingested_at: 2026-05-30
tags: [claude-code, source-code-analysis, ai-programming, anthropic, code-generation]
related_entities: [[Claude Code]], [[Anthropic]]
related_topics: [[AI编程工具]], [[代码生成]], [[源码分析]]
---

# Claude Code源码泄露深度解析：51.2万行代码里藏着怎样的AI编程系统

## 一句话概括
对 Anthropic 旗下 AI 编程工具 Claude Code 泄露的约 51.2 万行源码进行深度解析，揭示其内部架构与 AI 编程系统设计。

## 实践内容

### Claude Code 五层架构

| 层级 | 代表文件/目录 | 职责 |
|------|-------------|------|
| 入口层 | main.tsx (4683行) | CLI、Ink/React界面、命令解析、状态管理 |
| 编排层 | QueryEngine.ts (1295行)、query.ts (1729行) | 对话主循环、消息压缩、权限与中断恢复 |
| Prompt/Memory层 | constants/prompts.ts、utils/claudemd.ts | 系统提示词（静态/动态拆分）、CLAUDE.md四层记忆 |
| 工具层 | tools/*、Tool.ts (792行) | 40+工具：文件、Shell、MCP、Agent、Task、Web |
| 服务层 | utils/*、tasks/*、coordinator/* | 任务模型、后台能力、多Agent调度 |

### 对话主循环流程

1. 接收输入 → 2. 装载上下文 → 3. 组装prompt → 4. 请求模型 → 5. 执行工具 → 6. 回填结果 → 7. 压缩与收敛（自动摘要，非上下文爆掉才补救）

### 四层记忆系统 (CLAUDE.md)

| 优先级 | 类型 | 典型位置 | 作用 |
|--------|------|---------|------|
| 1 | Managed memory | /etc/claude-code/CLAUDE.md | 全局托管规则 |
| 2 | User memory | ~/.claude/CLAUDE.md | 用户私有全局偏好 |
| 3 | Project memory | 项目根CLAUDE.md、.claude/rules/*.md | 项目级规则，可随仓库共享 |
| 4 | Local memory | CLAUDE.local.md | 本地私有项目特定指令 |

文件按低→高优先级装载，后加载者优先覆盖。支持 @include 指令实现模块化。

### System Prompt 设计

- **静态区**：固定规则（交互式工程agent定义、权限约束、防注入、自动压缩、避免过度设计）
- **动态区**：运行时注入（语言偏好、Output Style、MCP指令、agent列表、CLAUDE.md）
- 用 SYSTEM_PROMPT_DYNAMIC_BOUNDARY 分隔，优化缓存命中率（动态agent list约消耗10.2% fleet cache_creation tokens）

### 多Agent架构

- **COORDINATOR_MODE**：主agent变为调度者，拆解/分派/收集/合并，有独立的 ALLOWED_TOOLS 限制
- **FORK_SUBAGENT**：轻量级分身机制，独立上下文处理支线任务
- **内置agent**：Plan Agent（规划）、Explore Agent（探索代码库）、Verification Agent（破坏式验证）、Guide Agent（产品/环境解释器）
- **KAIROS**：持久化后台agent，支持跨session存在、外部事件响应、定时记忆整理、多渠道互动

### 关键Feature Flags

BUDDY（终端宠物系统）、KAIROS（持久后台）、KAIROS_DREAM（夜间记忆整合）、KAIROS_GITHUB_WEBHOOKS、COORDINATOR_MODE、FORK_SUBAGENT、ULTRAPLAN（强化规划）、BG_SESSIONS、EXTRACT_MEMORIES、CONTEXT_COLLAPSE等

## 摘录

> Anthropic 不是被黑了，而是自己把 Claude Code 的完整源码连同 source map 一起发到了 npm。真正值得看热闹的不是"泄露"两个字，而是这 51.2 万行 TypeScript 终于把一个顶级 AI coding agent 到底怎么组织上下文、怎么调工具、怎么管多 Agent、怎么藏彩蛋，全都摊在了桌面上。

> Claude Code 不是一个"包一层 API 的聊天壳子"，而是一套非常重的本地 agent runtime。它的核心设计不是"让模型会写代码"，而是"把模型塞进一个受控 runtime，让它像工程师一样拿到上下文、用工具、开分身、留记忆、跑后台"。

> 源码里明确写着："The conversation has unlimited context through automatic summarization." 这句话当然不是真的"无限"，而是说系统层面已经把自动压缩做成标准流程。Claude Code 不是等上下文爆掉了才补救，而是默认会在接近窗口极限时重写历史，把先前对话折叠成更短的摘要继续跑。

> SYSTEM_PROMPT_DYNAMIC_BOUNDARY 这种设计特别说明问题。Prompt 已经不只是"写一句提示词"，而是缓存优化、成本优化、动态注入、权限控制、角色分工、失误约束。未来优秀的 AI 产品团队，prompt 工程师会越来越像编译器/基础设施工程师。

> Verification Agent 的开头几乎就是对 LLM 本能弱点的公开羞辱："You are a verification specialist. Your job is not to confirm the implementation works — it's to try to break it." Anthropic 等于把"怎么防止 agent 自我感动"直接写进了系统机制。

> 模型只是 CPU，prompt 是内核策略，工具是外设，CLAUDE.md 是层叠配置，Coordinator 和 KAIROS 是进程系统，Buddy 则像那个写在 About 页面里、让你确认这东西真有人每天在用的签名。真正的竞争，正在从"谁更会答题"，切换到"谁能把 agent 变成可持续运行的软件系统"。

## 涉及实体
- [[Claude Code]] —— 被分析的 AI 编程工具主体
- [[Anthropic]] —— Claude Code 的开发公司

## 涉及主题
- [[AI编程工具]]
- [[代码生成]]
- [[源码分析]]
