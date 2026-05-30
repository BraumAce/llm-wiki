---
title: "AI Skill 体系主题"
type: topic
date: 2026-05-30
tags:
  - ai-skill
  - skill-engineering
  - workflow
  - capability-standardization
  - pluggable-architecture
  - auditability
  - harness-engineering
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Harness-Engineering]]"
  - "[[OpenClaw]]"
sources:
  - "[[AI-Skill体系全解-企业级AI能力标准化可插拔可审计]]"
  - "[[Agent-Skills-打通可复用专业领域知识的最后一公里]]"
  - "[[工作流的Skill怎么写-从7个顶级Skill中提炼的模式与最佳实践]]"
  - "[[当我把AI变成一个算法-Skill工程化设计的心路历程]]"
  - "[[让Skill自己训练自己-8阶段Loop-3层评测-5维AND门控]]"
  - "[[大模型Agent-Skill功能在LLM-HTTP底层交互流中怎么承载]]"
  - "[[深度解析LLM-Wiki-Obsidian-Wiki-GBrain]]"
---

# AI Skill 体系主题

## 主题定义

AI Skill 体系涵盖 2026 年 AI 工程领域关于 Skill（技能/能力单元）标准化、工程化和自进化的系统性实践。Skill 是 Agent 能力封装的基本单位——把领域知识打包成可热插拔的模块，让 Agent 按需加载。这一主题关注三个核心问题：如何设计标准化的 Skill 接口、如何让 Skill 在工作流中可靠运行、如何让 Skill 自己训练自己持续进化。

## 核心要点

1. **Skill 本质是 Harness 而非 Prompt**：Skill 看起来像 prompt（都是 Markdown 文件），实际上更像 harness（约束 + 验证 + 反馈的工程框架）。写一个能跑的 Skill 不难——随手糊一个 SKILL.md 模型就能照着做事，但要让它稳定干活则是另一回事：触发边界怎么定？安全规则怎么加？references 之间的一致性谁来管？脚本版本兼容谁来保证？Skill 最容易让人误会的一点，是它看起来像 prompt，实际上更像 harness

2. **CLI 接管确定性事务，Agent 限定为纯决策引擎**：腾讯技术工程的核心洞察是"凡是涉及精确格式、固定流程的事 AI 不靠谱；凡是涉及理解、判断、表达的事 AI 很在行"。通过 CLI 接管一切确定性事务（API 调用、状态管理、流程编排），配合步进式披露、Gate 门禁、状态持久化和模板变量等机制，把 Agent 从不可控的对话机器人变成精确、可恢复、可审计的工程化组件。"不改变河的本性，但给它修好渠"

3. **Skill 的标准化三要素**：企业级 AI Skill 需要三个维度的标准化——接口标准化（name、description、input_schema、execute 四要素，input_schema 类型直接取自模型 SDK 的 Tool 类型定义，没有中间层转换）、能力标准化（将企业级 AI 能力抽象为标准化、可插拔、可审计的 Skill 单元）、治理标准化（可审计、可回滚、可监控的 Skill 生命周期管理）

4. **Workflow 不写在 Skill 代码里，而是文件系统上的一组 Markdown 文件**：新增一个工作流的全部成本只是在 workflows/ 目录下新建一个文件夹，Skill 的业务能力可以无限横向扩展，而 Skill 本身的代码完全不动。这种"薄抽象、显式控制流、贴近模型 API"的实现方式比引入多层中间件更容易获得工程确定性。800 行代码就能实现一个最小可运行的 Agent 框架，覆盖 Tool 系统、消息总线、子 Agent 管理、REPL 主循环四个核心模块

5. **Skill 自己训练自己——8 阶段 Loop + 3 层评测 + 5 维 AND 门控**：Skill-Evolver 将深度学习的训练范式应用于 Skill 优化，通过 8 阶段 Loop（Review → Ideate → Modify → Commit → Verify → Gate → Log → Loop）、3 层评测（快速门卫 / Dev Eval / Strict Eval）和 5 维 AND 门控实现 Skill 的自进化。19 轮零回滚迭代中发现了 14 个之前完全看不见的问题。"Meta-evolution 最有价值的不是自动化节省时间，是它在替一个你还没见过的用户，跑一遍你自己永远跑不到的路径"

6. **Skill 在 LLM HTTP 底层的承载方式**：从 LLM HTTP 底层视角看，Skill 不是协议层概念，最终被编译为 System/Developer Message + Tools Definition + Multi-turn Tool Calling Loop。理解这一底层承载方式对于 Skill 的工程化设计至关重要——它决定了 Skill 的触发机制、上下文注入方式和工具调用模式

7. **从 7 个顶级 Skill 中提炼的模式与最佳实践**：工作流 Skill 的编写有成熟的模式可循——触发条件定义、输入输出规范、错误处理策略、上下文注入时机、验证闭环设计等。这些模式从实践中提炼而来，为 Skill 的工程化设计提供了可复用的模板

## 涉及实体

- [[OpenClaw-Skills]] —— Skill 机制的典型实现，6 源加载 + 优先级覆盖 + 菜单注入 + 自主选择
- [[Harness-Engineering]] —— Skill 是 Harness 的能力封装层，两者在实践中高度融合
- [[OpenClaw]] —— OpenClaw 的 16 大模块中 Skills 模块是核心子系统之一

## 对比矩阵

| 维度 | 纯 Prompt | Skill（Harness 视角） | Skill + 自进化 |
|------|---|---|---|
| 可靠性 | 低（依赖模型记忆） | 中（CLI + Gate 门控） | 高（自训练 + 评测闭环） |
| 可维护性 | 低（文本混杂） | 中（文件系统化） | 高（版本控制 + 回滚） |
| 可扩展性 | 低（改 prompt） | 中（新增 Markdown 文件） | 高（自动生成新 Skill） |
| 适用场景 | 简单任务 | 工程化工作流 | 持续迭代的生产系统 |

## 关键来源

- [[AI-Skill体系全解-企业级AI能力标准化可插拔可审计]] —— 企业级 AI Skill 标准化的系统性框架
- [[Agent-Skills-打通可复用专业领域知识的最后一公里]] —— Skill 作为知识封装的最后一公里
- [[工作流的Skill怎么写-从7个顶级Skill中提炼的模式与最佳实践]] —— 从实践中提炼的 Skill 编写模式
- [[当我把AI变成一个算法-Skill工程化设计的心路历程]] —— CLI + Workflow 的 Skill 工程化设计哲学
- [[让Skill自己训练自己-8阶段Loop-3层评测-5维AND门控]] —— Skill 自进化的训练范式
- [[大模型Agent-Skill功能在LLM-HTTP底层交互流中怎么承载]] —— Skill 在底层协议中的承载方式
