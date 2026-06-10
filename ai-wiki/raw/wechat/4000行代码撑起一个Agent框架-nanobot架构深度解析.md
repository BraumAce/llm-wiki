# 4000行代码撑起一个Agent框架？nanobot架构深度解析

- 作者: 俞孟凡
- 发布时间: 2026年6月8日
- 原文链接: https://mp.weixin.qq.com/s/6m2ezyi119r8NLMBjsARDQ
- 来源: 腾讯云开发者

---

香港大学数据科学实验室（HKUDS）的 nanobot，2026 年 2 月初开源，30 天内：28,500+ GitHub Stars、8 次大版本发布、核心代码 3,935 行。对比 LangChain 核心代码 430,000+ 行。

## 01 整体架构：控制面集中化

Chat Platforms (13 channels) → MessageBus (asyncio.Queue) → AgentLoop（核心控制面）→ ToolRegistry + SubagentMgr

控制面完全集中在 AgentLoop。没有 LangChain 的 Chain/Runnable/LCEL 等编排层，没有 LangGraph 的节点/边/DAG，没有 AutoGPT 的显式 PLAN 步骤。所有决策路径都穿过同一个 while 循环。可理解性最大化，但弹性空间随之缩小。

## 02 核心：ReAct 循环的极简实现

agent/loop.py 约 20 行，是整个 agent 编排逻辑的全部。

关键工程细节：
- 错误响应不持久化到 session history — 防止"400 中毒循环"
- 工具结果存入 session 时截断为 500 字符 — 控制上下文增长速率
- 错误处理只有一行，把错误恢复的全部责任交给 LLM

## 03 Tool 系统：Python 插件的最小接口

Tool 抽象类：name、description、parameters（JSON Schema）、execute（必须返回 str）。没有装饰器、没有注册配置文件、没有元类。代价是 JSON Schema 要手写。

## 04 Skill 系统：用 Markdown 扩展 LLM 能力

nanobot 最独特的设计。Skills 不是 Python 代码，而是 Markdown 文档，教 LLM 如何使用已有的 CLI 工具。

Progressive Loading：系统不把所有 skill 内容塞进 system prompt，而是注入一个 XML 索引。LLM 自主决定何时需要加载哪个 skill，按需加载，不用的 skill 零 token 开销。

相比向量检索的优势：确定性、可审计、零额外成本。局限：skill 数量极大时 XML 索引本身会占满 context window。

分工原则：需要执行 Python 逻辑 → Tool；包装已有 CLI 工具 → Skill。非工程师也能扩展 agent 能力。

## 05 记忆系统："grep beats RAG"

两个 Markdown 文件，不用向量库：
- MEMORY.md：长期事实、用户偏好，每次都注入 system prompt
- HISTORY.md：对话摘要，追加写入，LLM 用 exec grep 按需搜索

当 unconsolidated_messages >= 100 时，异步触发记忆整合。作者论据："grep beats RAG for agent memory — deterministic, auditable, zero-cost, composable"。在个人规模成立，企业规模时文件 grep 的局限会暴露。

## 06 Subagent 系统：消息总线重注入

spawn 工具允许主 agent 把长任务委托给后台 asyncio.Task。Subagent 没有 message 工具、没有 spawn 工具（防递归）、最多 15 次迭代、无 memory/history。

结果通知：Subagent 完成后通过消息总线重新注入一条 InboundMessage，主 agent 像处理普通用户消息一样处理。无需特殊的结果传递协议。

## 07 MCP 集成

MCP 工具被自动包装为原生 Tool 对象，名字带 mcp_{server}_ 前缀做命名空间隔离。支持 stdio 和 streamable-http 两种 MCP 服务器。

## 08 可借鉴的架构模式

- 配置驱动的能力扩展（Markdown-as-Config）
- 懒加载 + 文件系统作为 context 管理策略
- 消息总线解耦异步任务的结果通知
- 工具接口的最小公共类型（所有工具返回 str）
- 错误恢复委托给 LLM
