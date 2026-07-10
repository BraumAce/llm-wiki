---
title: "Agent-Skill"
type: entity
date: 2026-07-01
also_known_as:
  - "Agent Skill"
  - "AI Skill"
  - "智能体技能"
tags:
  - agent-skill
  - skill-engineering
  - harness-engineering
  - progressive-disclosure
sources:
  - "[[AI-Agent的Skill系统设计]]"
  - "[[Harness工程之道-Skill原理与最佳实践]]"
  - "[[Claude-Code-Skills的技术实现和运行方式]]"
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Harness-Engineering]]"
  - "[[Progressive-Disclosure]]"
  - "[[Token成本控制]]"
  - "[[MCP]]"
---

# Agent-Skill

## 一句话定义

Agent-Skill 是面向 AI Agent 的可发现、可加载、可验证的能力包，用 `SKILL.md`、脚本、参考资料和资产把通用模型转化为在特定任务上更稳定的专用执行者。

## 摘要

Agent-Skill 的核心不是“多写一段提示词”，而是把某类任务的触发条件、执行路径、资源边界、工具权限和验收方式组织成一个可复用的行为系统。它通常以一个包含 `SKILL.md` 的目录出现，`name` 和 `description` 负责让 Agent 在正确场景发现它，正文负责路由和全局规则，`scripts/` 承接确定性计算，`references/` 承接按需查阅的领域知识，`assets/` 承接最终产物需要复制或改写的素材。

与传统 System Prompt 相比，Agent-Skill 的关键优势是渐进式披露：会话启动时只暴露元数据，命中任务后再读取 `SKILL.md`，执行到具体阶段时才读取模块文件或参考资料。这种设计让知识覆盖范围扩大，但上下文成本不会随技能库规模线性爆炸。它也让 Skill 从“文档”升级为 Harness 的能力封装层：对高风险任务加门控，对确定性步骤加脚本，对跨阶段状态加快照，对质量保证加前向测试和日志回放。

## 详情

### 起源与背景

Agent-Skill 出现在 Prompt 工程遇到两类瓶颈之后：一是项目规则和领域知识全塞进长 Prompt 会污染上下文、稀释注意力；二是 Agent 在复杂任务、工具众多或执行压力下会走捷径，单靠“请遵守规则”难以稳定约束行为。Skill 体系把“项目级全局规则”和“可复用领域能力”分开：前者留在 AGENTS.md / CLAUDE.md / System Prompt 中，后者做成可安装、可版本控制、可按需加载的能力包。

### 核心机制 / 工作原理

一个成熟 Agent-Skill 通常包含三层：

1. **发现层**：`name` 与 `description` 是路由索引。description 要同时回答“做什么”和“什么时候用”，列出典型触发词与排除边界，但不把完整流程写进去，避免 Agent 只凭描述执行。
2. **执行层**：`SKILL.md` 是入口和路由器，保留意图路由表、全局安全红线、阶段门卡和最小必要流程。复杂业务细节不堆在主文件里，而是按阶段下沉到模块文件。
3. **资源层**：脚本、参考资料和资产各司其职。脚本用于格式转换、环境检测、复杂计算、日志采集等确定性环节；参考资料用于 schema、业务口径、流程细则；资产用于模板、字体、图片或示例工程。

Skill 的自由度要匹配任务风险。写技术文章可以给较高自由度，用原则和示例引导；内部指标查询适合中自由度，用字段说明和 SQL 模板控制口径；PDF 转换、固定报告生成、外部消息发送等脆弱操作适合低自由度，用脚本、白名单和硬门控约束。门控的意义不是语气更严厉，而是在条件满足前明确禁止下一步动作，把自然语言建议变成执行边界。

### Claude Code 中的发现、加载与可信边界

Claude Code 的实现说明让三层结构获得了可运行的解释：文件系统 Skill 标准形态是 `<skill-name>/SKILL.md`，用户级、项目级、managed、bundled、Plugin 和 MCP 都可提供来源；会话启动时系统只用 `name`、`description`、`when_to_use` 等元数据供模型判断，真正命中或显式调用后才渲染正文、展开参数与路径变量。因而 Skill 的渐进披露不是写作偏好，而是由发现索引、调用时渲染和 supporting files 三个时点共同实现的上下文预算策略。

安全边界同样应随来源变化：动态上下文命令只适合收集只读材料，不能替代真实操作；远端 MCP Skill 不执行内嵌 shell，防止远程返回的内容变成本机代码执行。本地第三方 Skill 也要审查脚本与参考资料，并以 `allowed-tools` 收窄权限。这个机制说明 Skill 的风险不只在“description 是否命中”，也在命中后到底让 Agent 获得了哪些预处理和工具能力。

### 应用 / 使用场景

- **AI Coding 工作流**：封装代码审查、需求澄清、PR 处理、测试生成、迁移改造等重复流程。
- **企业业务操作**：把 AB 实验、招聘沟通、指标查询、订单处理等内部系统能力做成带工具白名单和审批边界的技能。
- **文档和内容生产**：用 references 承载写作规则、品牌语气、模板结构，用 assets 承载可复用素材。
- **跨平台能力迁移**：尽量把 Skill 写成行为规则，再由平台适配层映射 TodoWrite、Task tool、native skill tool、MCP 工具等具体实现。

### 局限与争议

- Skill 不是免费的：一旦完整 `SKILL.md` 进入对话历史，就会持续占用上下文，复杂 Skill 必须靠拆分和按需引用控制成本。
- 触发质量是第一瓶颈：description 太宽会误触发，太窄会漏触发，黑话过多会让新用户的自然语言请求无法命中。
- Skill 容易被写成 Wiki：把大量背景知识堆进正文，会让它失去“能力包”的执行属性。
- 低风险任务过度脚本化会僵硬；高风险任务只写开放建议又会让 Agent 在压力下合理化违规。
- 跨平台适配需要抽象行为规则，直接绑定某个平台的私有工具名会降低可迁移性。

## 与其他实体的关系

- [[OpenClaw-Skills]] —— OpenClaw 的 Skills 是 Agent-Skill 体系的一种具体实现，强调菜单注入、自主选择和按需读取。
- [[Harness-Engineering]] —— Agent-Skill 是 Harness 的能力封装层，把流程、工具、验证和权限封成可复用单元。
- [[Progressive-Disclosure]] —— 渐进式披露是 Skill 控制上下文成本的核心机制。
- [[Token成本控制]] —— Skill 的加载策略、拆分粒度和资源引用方式直接影响上下文预算和缓存命中。
- [[MCP]] —— 很多 Skill 最终会调用 MCP 工具或内部 CLI，工具 schema 与权限白名单决定执行边界。

## 参考来源

- [[AI-Agent的Skill系统设计]] —— 大淘宝技术，从行为编程、上下文预算、资源分层、门控和前向测试角度系统定义 Skill。
- [[Harness工程之道-Skill原理与最佳实践]] —— 阿里云开发者，以 trade-ab-skill 为例说明 Skill 的结构、触发机制、作用域优先级、工具隔离、脚本增强和观测迭代。
- [[Claude-Code-Skills的技术实现和运行方式]] —— JavaGuide，补充 Skill 来源、延迟渲染、supporting files、动态上下文与 MCP shell 安全边界。
