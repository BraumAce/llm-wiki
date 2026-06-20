---
title: "一篇搞懂 AI Coding Agent 的 Token 成本控制"
type: source
date: 2026-06-15
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/x8ssQ-trmIqHMPlvQSE9SA"
author: "devinyzeng（腾讯技术工程）"
ingested_at: 2026-06-15
tags:
  - token
  - cost-optimization
  - ai-coding
  - context-engineering
related_entities:
  - "[[Headroom]]"
  - "[[Token成本控制]]"
  - "[[Prompt-Cache]]"
  - "[[Orchestrator-Worker模式]]"
  - "[[Context-Engineering]]"
  - "[[CodeBuddy]]"
  - "[[MCP]]"
  - "[[DeepSeek-V4]]"
related_topics: []
---

# 一篇搞懂 AI Coding Agent 的 Token 成本控制

## 一句话概括

腾讯技术工程出品的 AI Coding Agent（CodeBuddy/Cursor/Codex/Gemini CLI）降本完整指南：建立"成本大头是系统重复搬运的上下文，不是你那句提问"的心智模型，给出使用习惯 → 模型路由 → 上下文压缩 → 代码图谱 → Agent 架构五层、由便宜到贵的优化路径，外加观测与预算治理。

## 实践内容

**一轮请求的典型 Token 分布（贵的是系统塞进去的，不是你写的那句话）：**

```
System Prompt         5K
项目说明文档          10K
Skill 定义            20K
Tool / MCP 定义       30K
历史会话             100K
代码文件              50K
用户问题               0.1K
总成本 ≈ 固定前缀 + 会话历史 + 运行时检索 + 工具往返 + 模型输出
```

**使用习惯（今天就能做）：** 一个 Session 一件事；长会话及时 `/compact`；长期信息外置（项目文档/Summary/Memory/Repo Map/任务清单）；指定输出格式（"直接给结论，不要复述问题，必要时再展开"）；高频 Skill 常驻、低频按需；CLI 优先于 MCP（`gh pr create`、`kubectl get pods`、`git diff`；国内有 tapd-ai-cli、gongfeng-cli 专为 Agent 优化输出格式）；引用文件带完整 `@路径`；意图一次说完。

**模型路由表：** 写 UT/commit→便宜模型；Code Review→中高档；架构设计/复杂 Bug→强模型；批量分类/摘要→低价或 Batch。先过便宜模型再按需升级；调 reasoning effort / thinking budget / verbosity / max output。

**Skill 绑定模型（CodeBuddy SKILL.md 头部）：**

```
---
context: fork
model: deepseek-v4-pro
---
```

`model` 指定该 Skill 用的模型，`context: fork` 把固定流程放到独立执行上下文，不带主会话全部历史。斜杠命令与 Agent 同样支持 `model` 参数绑定。

**上下文压缩四工具（互补不互斥，最低成本起点：先装 RTK + Caveman）：**

```
# RTK —— 压终端命令输出（~89%；智能过滤/分组聚合/智能截断/去重合并）
brew install rtk          # macOS
rtk init -g --agent codebuddy
rtk gain                  # 查看节省统计
rtk discover              # 扫描哪些命令还没用 RTK

# Caveman —— 压 AI 回复输出（65-75%；lite/full/ultra/wenyan 四模式）
git clone https://github.com/studyzy/caveman && cd caveman && ./install.sh

# Headroom —— 压所有进上下文内容（47-92%，可逆压缩+按需还原；内置 CacheAligner 稳前缀）
pip install "headroom-ai[all]"
headroom wrap codebuddy --memory --code-graph

# context-mode —— 沙箱化 MCP 工具输出（98%）+ 跨 compact 会话连续性（SQLite/FTS5）
npm install -g context-mode
/context-mode:ctx-doctor   # 验证
```

**代码图谱：** Graphify（`uv tool install graphifyy`，Tree-sitter 建图，官方称省 71.5× Token，产出 graph.html/GRAPH_REPORT.md/graph.json）；CodeGraph（`npm i -g @colbymchenry/codegraph`，MCP+持久化图库，7 仓库 benchmark 平均 -47% Token、-58% Tool Call，核心工具 `codegraph_context`/`codegraph_trace`/`codegraph_impact`）。

**多 Agent（Orchestrator-Worker）数据流转约定：** 通过共享外置文件而非会话历史——`.agent/findings.json`（结构化 file/line/issue/severity/next_step）、`.agent/progress.json`（step status/worker/depends_on）；任务完成后 `mv .agent/ .agent-archive/...` 或 `rm -rf .agent/`。并行加速：2 个 ~1.5-1.8×、3 个 ~2.2-2.6×、4 个 ~2.8-3.4×。

## 摘录

> 很多人本能地把优化方向定为"怎么把问题写短点"。这当然不是坏事，但它抓不到主要矛盾。因为模型真正收到的，不是"你的问题"，而是"带着整包上下文的问题"……你那句提问，往往只是最后一撮"点火器"。它负责触发任务，但通常不是成本主体。答案是：你只问了一句话，但系统替你背了一整车背景。

> 第一，Prompt Cache 省的不是首次成本，而是重复成本。第一次发送长前缀时，通常还是要正常付费；价值在第二次、第三次、后续很多次复用时才会体现出来。第二，缓存不是"写短"，而是"写稳"。你天天改系统提示词、天天调 Skill Prompt，那缓存理论上存在，实践里也很难命中。第三，缓存优化和上下文治理是一回事。

> 一个单 Agent 处理复杂任务时，它必须同时承载规划、代码阅读、工具调用、生成、验证的所有上下文——哪怕它当前正在做的只是"改一个函数"。Orchestrator-Worker 模式的本质，是让每个 Agent 只看和当前步骤相关的内容，而不是把整个任务的所有背景都塞进每一次调用。

## 涉及实体

- [[Token成本控制]] —— 全文方法论主体
- [[Headroom]] —— 上下文压缩四工具之一，覆盖所有进入上下文的内容
- [[Prompt-Cache]] —— §1.4，所有优化的基础
- [[Orchestrator-Worker模式]] —— §6 多 Agent 协作核心范式
- [[Context-Engineering]] —— 上下文压缩与"减少重复上下文"
- [[CodeBuddy]] —— 主要示范的 AI Coding Agent
- [[MCP]] —— 工具治理对象、"CLI 优先于 MCP"
- [[DeepSeek-V4]] —— 执行类任务的便宜模型示例

## 涉及主题

（暂无聚合主题；与 [[Context-Engineering]]、[[Harness-Engineering]] 的成本/工程化议题相关）

## 我的评注

这篇把"账单大头是重复搬运的上下文"讲得极透，行动清单分今天/这周/这个月三档，落地性强。需注意：文中 RTK/Caveman/headroom/context-mode/Graphify 等工具的压缩率多为各项目自报数据（部分混用 token 与字符口径，原文已注明），引用时宜当参照而非定论；CodeGraph 的 benchmark 相对规范（7 个真实开源仓库 + Claude Opus 4.8 验证）。
