---
title: "Claude Code 源码架构解析：从启动 Prompt 到权限管道"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/ibU8rAPPkcWrBKw3wArUFw"
author: "架构师"
ingested_at: 2026-05-30
tags: [claude-code, source-code, architecture, prompt-engineering, permission-pipeline, cli-agent]
related_entities: Claude Code, Claude, Anthropic
related_topics:
  - AI Agent Architecture
  - Prompt Engineering
  - Permission Model
---

# Claude Code 源码架构解析：从启动 Prompt 到权限管道

## 一句话概括
对 Claude Code CLI 工具的源码架构进行逆向分析，涵盖从启动时加载的系统 Prompt 到运行时权限校验管道的完整链路。

## 实践内容

文章沿 Claude Code 的运行主链路逐层拆解其源码架构：

1. **启动阶段（`src/main.tsx`）**：系统在启动时提前并行触发 profile checkpoint、MDM 读取、keychain 预取等动作，与后续 import 过程重叠，说明从一开始就按 Runtime（长期交互系统）而非一次性 CLI 来设计。

2. **Prompt 装配层（`src/constants/prompts.ts`、`src/utils/queryContext.ts`）**：Prompt 不是静态文案，而是可装配、可分段、可缓存的运行时上下文。`getSystemPrompt()` 按 section 组织；`SYSTEM_PROMPT_DYNAMIC_BOUNDARY` 将静态前缀与动态部分切开；`fetchSystemPromptParts()` 并行准备 defaultSystemPrompt、userContext、systemContext 三块 API cache-key 前缀材料。每个工具目录下还有独立的 `prompt.ts`（如 `BashTool/prompt.ts` 中的 Git Safety Protocol），工具排序固定以保持 Prompt Cache 字节级前缀稳定。

3. **运行主链路（`src/QueryEngine.ts`、`src/utils/processUserInput/processUserInput.ts`、`src/query.ts`）**：`QueryEngine.submitMessage()` 准备 cwd、tools、commands、mcpClients、thinkingConfig、budget、session state，结合 memory/custom/append prompt 组出 system prompt；`processUserInput()` 处理 slash command、附件、图片、IDE selection、粘贴内容，并执行 `executeUserPromptSubmitHooks()`；`query.ts` 作为"胖核心"驱动 Agent Loop，处理消息准备、工具调用、结果回填、token budget、stop hooks、continue 状态、compact 判断。源码中可见 `USER_TYPE === 'ant'` 分支，Anthropic 内部版本有更激进的输出策略和 A/B 测试功能。

4. **工具系统（`src/Tool.ts`、`src/tools.ts`、`src/tools/FileEditTool/*`）**：工具在进入系统前必须声明边界——`isReadOnly`、`isConcurrencySafe`、`isDestructive`、`needsUserInteraction`、`checkPermissions`，且 `buildTool()` 默认值是保守的（`isConcurrencySafe` 默认 false，`isReadOnly` 默认 false）。FileEditTool 强制"先读再改"：模型未先用 Read 工具读过文件就调编辑会被系统拦截，还包含路径规范化、denied directory 拦截、超大文件保护等机制。

5. **权限管道（`src/utils/permissions/permissions.ts`）**：`hasPermissionsToUseToolInner()` 构成一条可治理的决策链路——deny tool → ask tool → 工具自身 checkPermissions → 内容级 ask rule / safety check → mode 判断（如 bypassPermissions）→ always allow → passthrough 收敛为 ask，配合 classifier、PermissionRequest hooks、MCP 规则匹配、denial tracking 等补充机制。

6. **上下文压缩与长期记忆**：三级压缩策略——microcompact（只清理旧工具调用结果，保留对话主线）、autocompact（token 消耗接近上下文窗口 87% 时自动触发）、完全压缩（AI 对整段对话生成摘要替换历史，前置指令"CRITICAL: Respond with TEXT ONLY. Do NOT call any tools."）。`src/services/extractMemories/prompts.ts` 负责长期记忆提取，`src/services/SessionMemory/prompts.ts` 维护当前会话状态（Current State、Task specification、Files and Functions、Errors & Corrections、Worklog 等区块）。

7. **配置投毒攻击面**：hooks、`.mcp.json`、skill 文件 frontmatter 中的 hooks 均为 Claude Code 默认信任、不做二次确认的确定性执行入口。clone 包含恶意 `.claude/settings.json` 的仓库后运行 `claude` 命令，hooks 字段中定义的脚本会静默执行。CVE-2025-59536 报告指出"曾经作为被动数据的配置文件，如今成了主动执行路径的控制器"。

## 摘录

> 从 src/constants/prompts.ts 和 src/utils/queryContext.ts 看，更贴近工程实际的说法应该是：Claude Code 把 Prompt 做成了一层可装配、可分段、可缓存的运行时上下文。它关心的已经不是"提示词写得漂不漂亮"，而是哪些内容可以稳定复用、哪些内容必须每轮重新感知、哪些上下文属于会话状态、哪些上下文属于系统环境。

> buildTool() 背后的默认值是保守的。isConcurrencySafe 默认 false，isReadOnly 默认 false。它说明系统默认不信任一个"没写清楚安全属性"的工具。只要作者漏配了关键声明，系统就先把它看成可能会写、可能不安全并发的那一类。很多产品的节奏是"先把工具接上，规则以后慢慢补"。Claude Code 反过来，先把安全属性声明清楚，再暴露给模型。

> Claude Code 的权限系统，更像一条可以持续治理、持续插入规则的管道，远不止一个弹窗确认。沿着 hasPermissionsToUseToolInner() 往下看，大致能看到：先判断是否命中 deny tool，再判断是否命中 ask tool，再进入工具自己的 checkPermissions，再处理内容级 ask rule 和 safety check，再看当前 mode，再看 always allow，最后把 passthrough 收敛成 ask。

> 曾经作为被动数据的配置文件，如今成了主动执行路径的控制器。当这个确定性入口对项目级配置文件也默认信任时，攻击者就可以把恶意命令藏在一个看起来正常的开源项目里。Hooks、MCP、Skill 这些"扩展入口"越强大，它们被投毒时的伤害也越大。确定性执行是优势，但确定性信任可能是风险。

> Claude Code 这次更值得借鉴的，其实是它把很多原本只写在最佳实践文档里的东西，一步步推进成了代码里的系统约束。Prompt 分层装配、工具先声明边界、编辑尽量先读后改、权限做成决策链、长任务把"历史压缩"和"状态续写"分开处理。这些做法看起来都不新，但它们一旦真的被写进系统，产品体验通常就会稳定不少。

## 涉及实体
- Claude Code —— 被分析的 CLI 工具
- Anthropic —— Claude Code 的开发方

## 涉及主题
- AI Agent Architecture —— Agent 工具的系统架构设计
- Prompt Engineering —— 启动 Prompt 的组织与分层
- Permission Model —— 工具调用的权限校验机制
