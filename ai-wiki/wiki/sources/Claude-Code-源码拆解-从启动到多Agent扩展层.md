---
title: "Claude Code 源码拆解：从启动到多 Agent 扩展层"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/VHVZV0rrCxYkbrxjuQzIAQ"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags: [claude-code, source-code-analysis, multi-agent, agentic-coding]
related_entities: Claude Code, Anthropic
related_topics:
  - Multi-Agent 架构
  - Agentic Coding
  - AI 编程工具
---

# Claude Code 源码拆解：从启动到多 Agent 扩展层

## 一句话概括
对 Claude Code 的源码进行深度拆解，分析其从启动流程到多 Agent 扩展层的架构设计与实现细节。

## 实践内容

文章对 Claude Code 源码进行七层深度拆解，分析其架构设计与实现细节：

### 一、入口与启动链路
启动分三段：入口分流（本地交互/无界面/远程/后台）、进程级初始化（配置/telemetry/全局设施）、会话级准备（工作目录/工具面/权限模式/扩展能力）。关键设计是将"进程状态"（cwd、sessionId、telemetry）与"交互状态"（tasks、MCP clients、plugin 状态、permission context）分开，分别沉在不同层级。

### 二、REPL / UI Orchestration
REPL 不是"模型回复展示器"，而是 runtime 的 orchestrator。它负责两件大事：汇总当前能力面（本地工具、外部工具、插件能力、任务状态、权限确认队列、远程会话信息），归并当前事件流（助手消息、工具进度、待确认权限、任务通知、接口错误）。用户每次输入，REPL 先打包当前 turn 的执行制度，再交给 query loop。

### 三、Query Loop / QueryEngine
Query Loop 维护跨迭代状态机：消息集、执行上下文、上下文压缩状态、输出恢复计数、轮数预算、任务预算等。核心循环：
```
while (true) {
  prefetchMemoryAndSkills()
  messagesForQuery = applyBudget(messages)
  messagesForQuery = snipAndCompact(messagesForQuery)
  assistant = streamModel(messagesForQuery)
  if (!assistant.hasToolUse) return finishTurn(assistant)
  toolResult = runToolUse(assistant.toolUse, toolUseContext)
  state.messages = writeBack(messages, assistant, toolResult)
}
```
长上下文治理机制：snip、microcompact、collapse、autocompact；失败恢复：reactive compact、max output recovery、fallback model；工具结果标准化为 user message 回灌主消息流。

### 四、Tool Runtime
Tool 不是简单函数，而是带完整运行时语义的对象：
```typescript
interface Tool {
  name: string
  inputSchema: Schema
  canRunInParallel: boolean
  validate(input): ValidationResult
  execute(input, context): AsyncIterable<ToolEvent>
  toModelResult(output): StructuredResult
}
```
四段式执行链：解析真实 tool 做兜底 -> schema 校验和调用前准备 -> permission 决策再执行 -> 结果归一化。并发策略由工具语义决定（isConcurrencySafe），支持流式工具执行。权限拒绝也被包装成标准 tool_result 回到主循环。

### 五、Permission System
权限拆成四层：规则层（允许/拒绝/待确认，保留来源和理由）、运行时判定层（classifier/hooks/coordinator 自动决策）、交互层（需用户参与时确认）、执行隔离层（文件/网络/命令边界）。权限决策对象：
```typescript
type PermissionDecision =
  | { behavior: 'allow'; updatedInput?; decisionReason? }
  | { behavior: 'ask'; message: string; suggestions?; blockedPath?; pendingClassifierCheck? }
  | { behavior: 'deny'; message: string; decisionReason: string }
```
auto mode 会主动剔除过宽的 Bash、PowerShell、agent wildcard 等规则。

### 六、Task / 多 Agent / 后台执行
用 Task 统一表达主会话后台化、本地 subagent、in-process teammate、remote agent。子 Agent 任务状态包含 agentId、prompt、progress、result、messages、isBackgrounded、pendingMessages、retain、diskLoaded、evictAfter 等字段。用异步上下文隔离机制处理每个执行体的独立上下文，避免多 agent 并发时身份/通知/权限/工具上下文串线。任务的通知、待处理消息、会话记录输出最终都会重新回到主会话。

### 七、MCP / Skills / Plugins 扩展层
MCP 接入时将原生对象翻译成内部运行时模型：MCP prompt -> Command，MCP tool -> Tool，MCP resource -> 资源体系。Skills 是轻量能力声明：description、allowedTools、whenToUse、model、effort、hooks、executionContext、agent。Plugin 是能力组合包，可带能力单元、hooks、外部协议接入、语言服务、代理定义。核心原则："动态能力面，稳定内部对象"。

### 总架构三条主干链路
- **控制链**：启动层定边界 -> REPL 汇总能力面和会话状态 -> Query Loop 推进连续运行
- **执行链**：Tool Runtime -> Permission + sandbox -> 文件/命令/网络等外部副作用
- **任务链**：Task Runtime 管理生命周期和回流，多 Agent 不撕裂主会话

## 摘录

> 这两年大家都在写 Agent，但其实所有人都知道一个尴尬事实：Demo 阶段看起来势如破竹，一旦加到三五个工具、几种运行模式、几类权限规则之后，系统就开始肉眼可见地变形。主循环越来越脏，工具一多就互相污染，后台任务和前台会话互相打架，扩展一接进来就满地特判。模型能力当然重要，但真正决定一个 Agent 能不能长期活下去的，往往不是模型，而是围着模型搭起来的运行时。

> 一个普通 orchestrator 不会长期维护 autoCompactTracking、maxOutputTokensRecoveryCount、pendingToolUseSummary 这类对象；一旦这些状态都进入主循环，说明系统已经承认一件事：一次 agent turn 会被压缩、恢复、工具回灌、预算和中断反复改写。

> 很多团队的 Tool 抽象其实停在这里：type Tool = (input: unknown) => Promise<string>。Claude Code 更接近的是这样：interface Tool { name; inputSchema; canRunInParallel; validate; execute; toModelResult }。真正的差别不在 TypeScript 写法，而在系统观。前一种只是"模型能调一个函数"，后一种才是"运行时知道这个动作该怎么被约束、观测、并发和回灌"。

> Claude Code 连"被拒绝"这件事都纳入了统一协议，而不是让权限层和工具层各说各话。这种一致性对长时运行系统极其重要，因为主循环根本不需要知道这次是"执行成功"还是"权限拒绝"，它只需要知道"我收到了一份结构化结果，可以继续往下推理了"。

> 多 Agent 真正难的地方，从来不是 prompt 怎么分工，而是系统里一旦出现多个可持续执行的执行体，状态怎么管理、进度怎么观察、结果怎么回流、上下文怎么隔离、失败怎么恢复。如果没有统一执行抽象，多 Agent 只会是一堆黑盒同时跑。

> Claude Code 真正值得借鉴的，不是它"做了很多层"，而是它知道每一层在承接哪一种真实复杂度。对做 AI Agent 的团队来说，这比抄任何单点功能都更有价值。

> 真正成熟的 Agent 系统，不是"模型更会做事"，而是"组织能把模型做事这件事，稳定地接进交付链路里"。

## 涉及实体
- Claude Code —— 被分析的开源 AI 编程工具
- Anthropic —— Claude Code 的开发方

## 涉及主题
- Multi-Agent 架构 —— 文章核心关注的多 Agent 扩展层设计
- Agentic Coding —— Claude Code 所属的 AI 编程范式
- AI 编程工具 —— Claude Code 的产品定位
