---
title: "万字干货！Harness Engineering如何工程化落地"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/77dyufF3MP8stHPS0BApNw"
author: "腾讯云开发者"
ingested_at: 2026-05-30
tags: [harness, engineering, ai-development, agent, workflow, rule, skill, mcp]
related_entities: Harness, Claude, MCP
related_topics: AI辅助开发, Harness Engineering, 多Agent协作, 工程化落地
---

# 万字干货！Harness Engineering如何工程化落地

## 一句话概括
以JK Launcher真实工程为例，详解如何从0搭建Harness Engineering体系（SPEC、Rule、Skill、Sub Agent、Workflow、Scripts、MCP），让AI在工程中持续稳定产出正确结果。

## 实践内容

以 JK Launcher（Unity 项目桌面启动器）为真实工程案例，详解 Harness Engineering 从 0 到 1 的落地全过程，共分 12 章：

**核心概念体系（第一章）**
- Rule：给 AI 的工程规矩，软约束非硬门禁，负责"什么是底线"
- Skill：固定流程的标准操作手册（编译、测试、事后验证），负责"关键流程不要靠临场发挥"
- Sub Agent：多角色分工（需求分析、方案设计、闸门、开发、代码审查、测试、PM），避免单 Agent 自审自批
- Workflow：接力赛规则，明确每阶段输入输出、前进/打回/重跑条件，拆成三层（给人看、给系统看、给角色看）
- Scripts：可执行的硬门禁检查（XAML 中文检查、Emoji 检查、C# 语法版本、MessageBox 硬编码、日志格式、编译/测试通过等）
- MCP：外部工程系统接入层（CI 构建、签名、制品、发布、状态回写）

**落地路径（第二至八章）**
1. 以设计规格文档（SPEC）为先，与 AI 反复磨透需求边界，SPEC 中不得出现"建议/可以/推荐/可选"等模糊词
2. Rule 补充底线约束，但发现 Rule 存在天花板：AI 会局部遗忘、会绕过 Rule 找理由
3. 将编译、测试、验证从 Rule 拆出做成 Skill，Rule 变轻、执行稳定性提高、维护成本降低
4. 走向结构化多 Agent 调度（而非继续强化单 Agent 或去中心化协作），选择固定角色+固定流程方案
5. Workflow 拆三层：人可读的流程说明、系统可读的阶段与迁移定义、角色可读的接棒/交棒文档要求
6. Scripts 硬门禁落地为可执行脚本，覆盖代码规范、编译、测试数量异常、规则同步等十余项检查
7. dev-map（开发导航地图）让 AI 快速理解项目结构和既有模式，避免重复造轮子

**关键认知**
- "真正贵的不是 token，真正贵的是失控"
- 人搭 Harness，AI 写代码——人不亲手写一行代码，AI 从能做小任务逐步走到能持续维护整个项目
- 上下文纪律：每一棒只给当前该看的材料，避免规则/地图/任务历史全堆给 AI

## 摘录
> 如果你往下挖，会发现它们解决的其实都是同一个问题：如何让 AI 在你的项目里，持续、稳定、规范、顺畅地做出你真正想要的结果。这一篇我就不再谈泛泛而论的"AI 很重要""工程化很重要"。我只做一件事：拿 JK Launcher 这个真实工程做例子，把我们这一路是怎么一步一步把 Harness 搭出来的，原原本本讲清楚。

> 它不是某一个工具，也不是某一条提示词技巧，而是一整套让 AI 在工程里稳定产出正确结果的工程系统。注意这里有三个关键词：稳定——不是这次运气好做对了，而是下次、下下次、换个需求、换个维护人，它仍然能比较稳定地工作；产出——不只是写代码，还包括需求、方案、验证、交付等完整过程产物；正确结果——不是"做完了就算"，而是最终要有办法判断它到底做得对不对。

> 这些东西单独看都不稀奇，真正有价值的是：它们组合起来以后，AI 才第一次像是在一个真实工程里工作，而不是只是在聊天窗口里表现得很聪明。Harness Engineering 就像是在给 AI 搭一整套"工程作战系统"。规格设计文档（SPEC）是作战目标，Rule 是纪律，Skill 是标准动作，Sub Agent 是兵种分工，Workflow 是指挥链，Scripts 是验收和反馈闭环。

> Rule 不是没用，而是 Rule 只能做"原则约束"，不能做"流程执行"。当我意识到这件事以后，我就开始做下一步：把固定流程从 Rule 里拆出去，做成 Skill。Rule 只要保留一句话："你必须做这件事。"而 Skill 则负责把"这件事具体怎么做"写清楚。

> 真正贵的不是 token，真正贵的是失控。我们需要的，不只是"AI 把代码写出来"，我们还需要：需求文档、方案文档、开发文档、代码评审结论、测试文档、交付结论、阶段进度和回退记录。这些东西不是形式主义，而是为了让后续任何一个人、任何一个 AI，在几天后、几周后、几个月后，都还能看懂：这个任务为什么这么做，做到哪一步了，哪些风险已经处理。

## 涉及实体
- Harness —— AI开发工程化框架体系
- Claude —— 作为工程执行AI的角色
- MCP —— Model Context Protocol，外部工程系统接入层

## 涉及主题
- AI辅助开发
- Harness Engineering
- 多Agent协作
- 工程化落地
