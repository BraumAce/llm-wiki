---
title: "工作流的 Skill 怎么写"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/aoNwyY5ZkCRMkZirn1rElQ"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags: [skill, workflow, agent, best-practices, prompt-engineering, llm]
related_entities: []
related_topics: Agent Skill设计, 工作流编排, Prompt工程
---

# 工作流的 Skill 怎么写

## 一句话概括
从 7 个顶级 Skill 的实践中总结编写高效 Agent Skill 的模式与最佳实践。

## 实践内容

### Skill 基础结构
Skill 是一个文件夹，核心是 SKILL.md 文件（YAML frontmatter + Markdown 正文）。LLM 判断需要某个 Skill 时会调用 skill 工具加载，SKILL.md 全部内容作为 tool-result 注入对话上下文。Skill 本质是"知识注入"——不会动态生成新工具，而是把指令文本注入 LLM 上下文，LLM 用已有的工具（bash、read、edit 等）执行指令。

### Frontmatter 设计
- **name**（必填）：唯一标识符，小写连字符
- **description**（必填，最关键）：LLM 通过它决定是否加载。写法要点：列举触发短语（把用户可能说的话写进去）、定义时序位置（"在什么之前/之后"使用）、包含产品关键词
- 可选扩展字段：references（声明参考文档）、allowed-tools（声明工具权限）、type（workflow/component）、best_for、scenarios、estimated_time

### 5 种核心设计模式

**模式 1：线性流程**（代表：vercel-deploy，77 行）
适用：部署、安装、迁移等有明确步骤的操作。结构：Prerequisites → Quick Start → Fallback → Troubleshooting。关键技巧：安全默认值、具体命令、超时提示、降级方案、负面指令。

**模式 2：决策树 + 按需加载**（代表：cloudflare-deploy，224 行）
适用：大型平台选型、产品导航、问题诊断。结构：Authentication → Quick Decision Trees → Product Index。关键技巧：用户意图分类（用用户语言而非技术术语）、树形导航、渐进式披露（主文件 7KB，references 按需展开到几十万字）。

**模式 3：循环迭代**（代表：test-driven-development，371 行）
适用：TDD、代码审查、设计评审等需要反复执行的流程。结构：The Iron Law → Red-Green-Refactor 循环体 → Common Rationalizations → Verification Checklist。关键技巧：强硬语气（"Delete it. Start over."）、Good/Bad 对比、借口反驳表（预判 12 种偷懒借口并逐一反驳）、验证清单。

**模式 4：接力棒循环**（代表：stitch-loop，203 行）
适用：多次迭代的长期项目，需要跨多个 session 持续工作。核心：文件即状态（next-prompt.md 作为接力棒），Step 6 标记为 Critical + MUST（忘了写接力棒循环就断了）。与循环迭代的区别：状态存储在外部文件系统而非对话上下文，支持跨 session。

**模式 5：多阶段 + 检查点 + Skill 编排**（代表：discovery-process，502 行）
适用：复杂的多周流程，需要在关键节点做 Go/No-Go 决策。统一阶段模板（Activities → Outputs → Decision Point），每个 NO 路径标注时间影响（"+2-3 days"、"+1 week"），调度 10+ 个子 Skill 完成各阶段。

**特殊模式：思维框架**（代表：audit-context-building，302 行）
适用：安全审计、代码审查、架构分析等需要深度思考的场景。控制的是"思维质量"而非"操作步骤"。关键技巧：思维工具（第一性原理、5 Why）、量化阈值（"每个函数最少 3 个不变量、5 个假设"）、非目标约束、反幻觉规则。

### 通用写作技巧
- **防止 LLM 偷懒**：强硬语气、借口反驳表、量化阈值、负面指令
- **教学方式**：Good/Bad 对比、具体命令、完整示例
- **安全与边界**：安全默认值、权限最小化、人类兜底
- **知识组织 3 层架构**：Frontmatter（~100 tokens）→ SKILL.md 正文（2K-5K tokens）→ references/resources（按需加载），总上下文占用 <10K tokens

## 摘录
> Skill 是一个文件夹，核心是 SKILL.md 文件，使用 YAML frontmatter + Markdown 正文的格式。当 LLM 判断需要某个 Skill 时，会调用 skill 工具加载它，SKILL.md 的全部内容会作为 tool-result 注入到对话上下文中，LLM 读到后自主决定怎么执行。关键机制：Skill 本质是"知识注入"——它不会动态生成新工具，而是把指令文本注入到 LLM 的上下文中，LLM 用已有的工具来执行这些指令。

> 如果你的 Skill 跨越多天/多周，有明确的阶段划分和 Go/No-Go 决策点，就用多阶段模式。每个 Phase 都有 Activities → Outputs → Decision Point，LLM 快速理解结构。决策检查点（"达到饱和了吗？YES → 下一阶段，NO → +1 周"）防止盲目推进，时间影响标注让用户了解延迟成本。

> 防止 LLM 偷懒的 4 种武器：强硬语气——LLM 对命令式语气的遵从率更高；借口反驳表——预判 LLM 的自我合理化路径并堵死；量化阈值——给出硬性的最低标准；负面指令——明确说"不要做 X"。教学的 3 种有效方式：Good/Bad 对比（对比学习效果最好）、具体命令（LLM 擅长执行具体指令）、完整示例（展示期望的输出格式）。

## 涉及实体
- openai/skills — OpenAI Codex 官方 Skill 目录
- obra/superpowers — 14 个工作流型 Skill（含 test-driven-development）
- google-labs-code/stitch-skills — 设计到代码的 Skill（含 stitch-loop）
- deanpeters/Product-Manager-Skills — 40+ 产品管理 Skill（含 discovery-process）
- trailofbits/skills — 安全审计 Skill（含 audit-context-building）
- openclaw/clawhub — Skill 注册中心
- VoltAgent/awesome-agent-skills — 500+ Skill 索引
- travisvn/awesome-claude-skills — 精选列表
- agentskills.io — Agent Skills 开放标准

## 涉及主题
- Agent Skill设计
- 工作流编排
- Prompt工程
