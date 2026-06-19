---
title: "Token成本控制"
type: entity
date: 2026-06-15
also_known_as:
  - "AI Coding Agent 成本优化"
  - "Token Cost Control"
  - "Token 成本优化"
tags:
  - ai-engineering
  - cost-optimization
  - token
  - ai-coding
  - context-engineering
sources:
  - "[[一篇搞懂-AI-Coding-Agent的Token成本控制]]"
  - "[[一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制]]"
related_entities:
  - "[[Prompt-Cache]]"
  - "[[Orchestrator-Worker模式]]"
  - "[[Context-Engineering]]"
  - "[[CodeBuddy]]"
  - "[[MCP]]"
  - "[[DeepSeek-V4]]"
  - "[[KV-Cache]]"
  - "[[OpenClaw-Skills]]"
---

# Token成本控制

## 一句话定义

Token 成本控制是 AI Coding Agent 的成本优化方法论，核心心智模型是：账单的大头不是"你问的那句话"，而是"系统为了回答你，重复搬运了多少上下文"——优化的本质是让系统少重复做无效工作，而不是把提问写短。

## 摘要

腾讯技术工程（作者 devinyzeng）总结了一套适用于 [[CodeBuddy]]、[[Cursor]]、Codex、Gemini CLI 等 AI Coding Agent 的完整降本方法。一个反直觉的事实是：在一轮典型请求里，用户问题往往连 1% 都不到，真正贵的是 System Prompt、Skill 定义、Tool/[[MCP]] 定义、会话历史、代码文件这些"系统替你背的一整车背景"。大模型本身是无状态的，"它记得"只是 Agent/CLI 层在每轮把历史、规则、工具、代码重新拼起来再发给模型——所谓记忆，很多时候只是"再次传入"。

方法论分五层、由便宜到贵：**使用习惯 → 模型路由 → Context 工程（上下文压缩）→ 代码图谱 → Agent 架构**，外加一条贯穿全程的观测与预算治理。

## 详情

### 成本结构：五类开销

Token 不等于"字数"，Agent 场景至少五类开销：输入 Token（每轮重复携带，最大头）、输出 Token（回答越啰嗦越贵）、推理 Token / thinking budget（简单任务走高推理档会溢价）、工具往返成本（一次工具调用常比原问题还长）、重试成本（第一次不合格→整包上下文再付一遍）。最易被低估的是后两项——"减少重试"本身就是硬核降本手段。

近似公式：`总成本 ≈ 固定前缀 + 会话历史 + 运行时检索 + 工具往返 + 模型输出`。

### 缓存链与四类配置税

新一轮成本分析把缓存链说得更细：缓存只能从前缀开始连续命中，系统指令、工具定义、Rules/Memory、历史消息任何中间节点变化，都会让后续内容重新计价。切换模型更会让 KV 张量不互通，整条链从头全价。

AI Coding 工具中的四类配置成本不同：

| 层级 | 成本形态 | 使用建议 |
|------|---|---|
| Memory | 全量常驻，改动会打断缓存链 | 只放一句话偏好和短约定 |
| Rules | 常驻或触发式 | 高频规则常驻，低频规则触发加载 |
| Skills | 加载前只有 description，加载后 SKILL.md 留在历史 | 用于完整工作流，避免无谓加载 |
| MCP | Schema 常驻，返回结果留在历史 | 低频能力优先 CLI/脚本，避免闲置工具税 |

因此 Token 优化不是单纯"少写 prompt"，而是维护稳定前缀、控制配置抖动、减少长工具结果进入主上下文。

### 五层优化路径

1. **使用习惯（零工程投入，收益最大）**：一个 Session 只服务一个目标；长会话及时 `/compact`（把完整历史压成可继续工作的状态）；聊天记录不是数据库，长期信息外置到文档/Memory/Repo Map；指定输出格式（直接给 diff/结论/JSON）减少废话与重试；Skill/MCP 高频常驻、低频按需加载；**CLI 优先于 MCP**（能 CLI/脚本解决就不挂一套 MCP 说明，如 tapd-ai-cli、gongfeng-cli 专为 Agent 输出格式优化）；引用文件带完整 `@路径`（省掉一整条搜索链路）；意图一次说完，别聊天式拆碎。
2. **模型路由**：匹配优先而非便宜优先——写 UT/commit 用便宜模型，Code Review 用中高档，架构设计/复杂 Bug 用强模型，批量分类/摘要走低价或 Batch；先过便宜模型再按需升级（级联工作流）；调预算旋钮（reasoning effort / thinking budget / verbosity / max output）；Skill/Agent/Command 都绑定默认模型（CodeBuddy 的 SKILL.md 头部可声明 `model:` 与 `context: fork`）。
3. **上下文压缩（Context 工程）**：把一定会进上下文的内容压短。代表工具——RTK（压终端命令输出，~89%）、Caveman（压 AI 回复输出，65-75%）、headroom（压所有进上下文内容，可逆压缩+按需还原，47-92%）、context-mode（沙箱化 MCP 工具输出 98%+跨 compact 会话连续性）。
4. **代码图谱**：真正贵的是"找代码"不是"读代码"。让 AI 动手前就知道该读哪里——Graphify（Tree-sitter 建图，官方称比直接读文件省 71.5× Token）、CodeGraph（MCP+持久化图库，7 仓库 benchmark 平均省 47% Token、58% Tool Call）。
5. **Agent 架构**：别让所有任务都挤进同一个上下文，用 [[Orchestrator-Worker模式]] 把臃肿长任务拆成有分工的流水线，每个 Worker 只看当前步骤所需内容，便宜模型干执行、强模型做规划。

### 应用 / 使用场景

- AI Coding Agent（CodeBuddy/Cursor/Codex/Gemini CLI）日常使用的成本治理
- 团队级降本：给命令/Skill 绑模型，把"靠人记得切"变成"系统默认更省"
- 大型仓库：代码图谱 + 多 Agent 编排显著降本

### 局限与争议（六个误区）

上下文越多越好（噪音让模型分神）、MCP 越多越强（选择空间大决策慢）、所有 Agent 都上最强模型（这叫放弃路由）、聊天记录当长期记忆、只看单价不看总成本（便宜模型若引发更多重试总成本未必低）、Prompt 越短越好（丢掉必要 few-shot/格式说明导致反复重试）。压缩要精准，不是一味缩短。[[Prompt-Cache]] 的要点也呼应这点——Token 优化重点不是把提示词写短，而是把前缀写稳。

## 与其他实体的关系

- [[Prompt-Cache]] —— 所有上下文优化的基础：稳定前缀命中缓存，省的是重复成本
- [[Orchestrator-Worker模式]] —— 第五层 Agent 架构优化的核心范式
- [[Context-Engineering]] —— 上下文压缩与"减少重复上下文"本质同源
- [[CodeBuddy]] —— 文中主要示范的 AI Coding Agent（SKILL.md 绑模型、subagent、worktree）
- [[MCP]] —— 工具治理对象；"CLI 优先于 MCP"的权衡
- [[DeepSeek-V4]] —— 执行类任务常绑定的便宜模型示例
- [[KV-Cache]] —— 缓存命中的底层机制；Prompt Cache 是产品层对稳定前缀复用的抽象
- [[OpenClaw-Skills]] —— Skill 的渐进式披露有助于未加载时省成本，但加载后会成为长期历史

## 参考来源

- [[一篇搞懂-AI-Coding-Agent的Token成本控制]] —— 腾讯技术工程 devinyzeng，五层降本框架
- [[一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制]] —— 腾讯云开发者，缓存链、四类配置成本与 Sub-Agent 冷启动经济学
