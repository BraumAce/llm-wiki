---
title: "从Vibe Coding到Agentic Engineering：重构后台开发全流程"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/pr8oQ9wEC7Oa1NvvW89j6w"
author: "腾讯技术工程"
ingested_at: 2026-05-30
tags: [vibe-coding, agentic-engineering, backend-development, ai-assisted-development, workflow-automation]
related_entities: []
related_topics: [[Vibe Coding]], [[Agentic Engineering]], [[AI辅助开发]], [[后台开发]]
---

# 从Vibe Coding到Agentic Engineering：重构后台开发全流程

## 一句话概括
探讨从"Vibe Coding"（借助AI快速生成代码片段）到"Agentic Engineering"（由AI Agent端到端驱动开发流程）的演进，以及这一范式如何重构后台开发的完整工作流。

## 实践内容

作者以一个真实的后台开发需求（RedeemReward 接口数据上报逻辑变更）为例，展示了使用 Claude Code + 自定义 Skill/Command/MCP 体系完成从需求到发布的全流程。核心流程分 11 个阶段：

**工具体系三层架构：**
- **Skill（技能）**：核心业务逻辑，系统根据上下文自动触发，如 pm-dev、git-workflow、code-review、dtools、galileo-log-query
- **Command（斜杠命令）**：用户通过 /xxx 主动调用的入口，如 /commit、/create-mr、/review-mr、/fix-mr
- **MCP Server（外部服务）**：通过 Model Context Protocol 连接的外部平台 API，如 GitPlatform MCP、PM MCP、Galileo MCP
- 另有 superpowers 插件提供的结构化工作流 Skill（brainstorming、writing-plans、executing-plans 等）

**全流程 11 个阶段：**
1. **需求创建 + 分支初始化**（pm-dev Skill）：口述需求 → AI 自动创建 PM 需求单 → 建立 feature 分支 → 保存需求文档
2. **交互式需求澄清**（brainstorming Skill）：AI 先探索代码库了解现状，再通过提问逐步明确需求边界和技术方案
3. **制定实施计划**（writing-plans Skill）：AI 深入读代码细节，生成精确的多 Task 实施计划，人工审核后才进入执行
4. **并行执行开发任务**（executing-plans Skill + /commit）：支持子 Agent 并行执行多个 Task，每个 Task 完成后自动跑 spec review 和 code quality review，自动生成 Conventional Commits 格式 commit
5. **代码自审**（code-review Skill）：按 4 级严重度（Critical/Major/Minor/Suggestion）× 8 类标签系统化审查
6. **编译部署到测试环境**（dtools Skill）：自动从 Makefile 探测参数，处理 Mac→Linux 交叉编译，发现并修正过期配置
7. **日志排查与调试**（galileo-log-query Skill）：通过 Galileo API 查日志，自动关联代码上下文分析问题
8. **创建 Merge Request**（/create-mr）：从分支名提取 PM ID，分析全部 commit 自动生成 MR 标题和描述
9. **AI 辅助代码评审**（/review-mr）：加载 code-review 审查标准，精确提交行级评论到 GitPlatform
10. **修复评审意见**（/fix-mr）：自动拉取未解决评论，逐条分析问题并生成修复方案
11. **合入发布**：人工在 GitPlatform 点 Merge，CI/CD 自动触发灰度发布

**关键设计决策：**
- Command 是薄壳，每个 /xxx 命令委托给 git-workflow 对应模块执行
- Skill 之间可组合：pm-dev → brainstorming → writing-plans 自动链式调用
- Superpowers 管纪律：确保 AI 先理解再动手、先计划再执行、按步骤推进
- MCP 对用户透明：Skill 通过 MCP 自动完成外部平台操作

**Agentic Engineering vs Vibe Coding 的本质区别：**
- Vibe Coding 是"提示即祈祷"（prompt-and-pray），依赖运气
- Agentic Engineering 依赖流程，每个关键节点都有人工审核，AI 是高效的执行者而非不受控的自动机
- 人负责定义目标、审核方案、把关质量；AI 在结构化流程中自主执行代码生成、commit、MR 描述整理等重复性工作

**消耗情况：** 整个流程 token 消耗较大，作者提到需要更高的 token 额度。各阶段合计耗时约 30 分钟左右，开发者主要在关键节点做审核确认。

## 摘录
> 今年行业里逐渐形成了一个更成熟的概念：Agentic Engineering（智能体工程）。核心思路是——人负责定义目标、约束条件和质量标准，AI 作为自主智能体在结构化流程中自主执行规划、编码、测试和迭代，每个关键节点都有人工审核。它不是让 AI 随意发挥，而是把 AI 的能力嵌入到一套有纪律的工程体系里。

> 这和 Vibe Coding 的本质区别在于：Vibe Coding 依赖运气，Agentic Engineering 依赖流程。每个关键节点都有人工审核，AI 是高效的执行者，不是不受控的自动机。Skill/Command 体系就是那个"结构化流程"——brainstorming 确保先理解再动手，writing-plans 确保先计划再执行，code-review 确保有检查清单而非凭感觉审查。

> AI 能区分"本次引入"和"历史遗留"——审查过程中 AI 发现 asyncReportRedeemReward 函数名带 async 前缀但实际是同步调用，但它主动拉了 master 分支原始代码对比，确认这是历史遗留而非本次引入，所以没有纳入审查范围。这个能力很重要——没人喜欢 reviewer 在你的 MR 里提一堆历史债务。

> AI 评审有对有错，人工审核不能省。AI 给出的评审意见不一定都是对的。它可能误判代码意图、遗漏业务上下文、或者给出看起来合理但实际不适用的建议。reviewer 拿到 AI 的审查结果后，每一条都要过脑子判断，该采纳的采纳，不靠谱的直接丢掉。

## 涉及实体
- [[Claude Code]] —— Anthropic 的 AI 编程助手，本文的核心开发工具
- [[GitPlatform]] —— 团队内部的 Git 代码托管平台（类似 GitLab）
- [[Galileo]] —— 内部日志查询与分析平台
- [[MCP (Model Context Protocol)]] —— 模型上下文协议，用于连接外部平台 API
- [[Superpowers]] —— Claude Code 插件，提供结构化工作流 Skill（brainstorming、writing-plans、executing-plans 等）
- [[trpc-go]] —— Go 语言的 tRPC 框架
- [[dtools]] —— DevOps 平台 CLI 工具，支持包发布/二进制发布/镜像发布
- [[PM (Project Management)]] —— 内部项目管理平台

## 涉及主题
- [[Vibe Coding]] —— 借助AI大模型快速生成代码的开发方式
- [[Agentic Engineering]] —— 由AI Agent自主驱动软件工程全流程的进阶范式
- [[AI辅助开发]] —— 利用AI工具提升开发效率的实践
- [[后台开发]] —— 服务端/后端系统的开发工作流
