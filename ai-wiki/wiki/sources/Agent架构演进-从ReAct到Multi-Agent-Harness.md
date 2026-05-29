---
title: "Agent架构演进：从 ReAct 到 Multi-Agent Harness"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://blog.bytelighting.cn/program/reading/2026/2026.5.html"
author: "多作者综合"
ingested_at: 2026-05-29
tags:
  - agent
  - architecture
  - evolution
  - multi-agent
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# Agent架构演进：从 ReAct 到 Multi-Agent Harness

## 一句话概括

综合 5+ 篇文章梳理 Agent 技术从硬编码流程到 Skill 封装、从单 Agent 到 Multi-Agent 编排、从无状态到持久记忆的完整演进脉络。

## 实践内容

### Agent 核心"三件套"（以 OpenClaw 为例）

```
Agent = System Prompt + 运行循环 + Skill 机制

System Prompt：岗前培训手册
  - 分层组装：基础指令 + 角色定义 + 工具说明 + Skill 注入
  - 通过 XML 标签分段，Agent 自动扫描匹配

运行循环（执行引擎）：
  - 事件驱动的推理循环
  - 主循环 → 单次尝试 → 事件订阅 → 工具循环

Skill 机制（按需加载的专业知识扩展包）：
  - 6 源加载 + 优先级覆盖
  - Agent 自动扫描 SKILL.md 并按需加载
```

### Skill 的协议层实现

```
Skill 并非协议层概念，而是纯粹的应用层抽象
最终被编译为三种协议原语：

1. System/Developer Message → 注入 system prompt
2. Tools Definition → 注册工具 schema
3. Multi-turn Tool Calling Loop → 多轮工具调用

渐进式加载流程：
  用户输入 → 意图识别 → 匹配 Skill → 加载 SKILL.md
  → 注入 System Message + 注册 Tools → 执行
```

### 17 种 Agent 架构演进

```
1. Reflection（自我反思）
2. Tool Use（工具调用）
3. ReAct（推理+行动）
4. Planning（规划）
5. Multi-Agent（多智能体编排）
6. Blackboard（共享黑板）
...
17. Cellular Automata（涌现计算）

每种架构新增的维度：
- State 字段：状态管理的复杂度递增
- 路由逻辑：从线性到网状
- 失败模式：从简单重试到降级策略
- 升级时机：什么时候该从 N 跳到 N+1
```

### Agent Room 协作模式

```
传统编排（DAG / Planner-Executor / Router）：
  预定义流程 → 固定路由 → 确定性执行

上下文编排（Agent Room）：
  产品、架构、开发、QA 在同一上下文场中交互
  → 形成超越单一角色的集体判断
  → 涌现式决策
```

### 从一问一答到自主执行的挑战

```
定时任务的痛点：
1. 高可用 — Agent 进程挂了任务就丢了
2. 统一管理 — 多 Agent 的定时任务分散
3. 权限控制 — 谁能创建/修改/删除任务
4. 可观测 — 任务执行状态、日志、告警
5. 资源利用率 — 空闲时的资源浪费

解法：将调度能力从 Agent 内部抽离到统一平台
```

## 摘录

> Agent 演进的本质是控制流设计而非 prompt engineering。从 Reflection、Tool Use、ReAct、Planning、多 Agent 编排、Blackboard 共享黑板，直到 Cellular Automata 涌现计算——每种架构新增的不是"更好的 prompt"，而是更复杂的 State 字段、路由逻辑和失败模式。（17种Agent架构演进）

> 旧范式不是被简单淘汰，而是从硬编码流程、无状态函数调用和堆 Prompt，逐步转向 Skill 封装、动态编排、持久运行现场与可恢复记忆。每个阶段解决的是不同层次的问题。（Agent核心技术概念与范式演变）

## 涉及实体

- [[OpenClaw]] —— Agent 架构的典型实现，16 大模块的完整工程案例
- [[OpenClaw-Skills]] —— Skill 机制的具体实现：6 源加载 + 优先级覆盖
- [[Harness-Engineering]] —— Agent 从"能跑"到"可靠"的关键框架

## 涉及主题

- [[Agent架构演进-主题]]

## 我的评注

最有价值的洞察来自"17种架构"那篇：Agent 演进的本质是**控制流设计**。不是 prompt 写得好不好，而是状态怎么管理、路由怎么决策、失败怎么处理。这和软件架构的演进规律一致——复杂度从代码层迁移到架构层。另一个值得注意的趋势是"Skill"作为知识封装的基本单位正在成为共识，无论是 OpenClaw 的 SKILL.md 还是各种 Agent 框架的 Plugin/Tool/Action，本质上都是在做同一件事。
