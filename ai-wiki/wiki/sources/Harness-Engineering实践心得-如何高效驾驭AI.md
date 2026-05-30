---
title: "Harness Engineering实践心得：如何高效驾驭AI"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/NtsksL2gkMtMqkILi4xvRg"
author: "腾讯云开发者"
ingested_at: 2026-05-30
tags: [harness-engineering, ai-engineering, prompt-engineering, llm, best-practices]
related_entities: []
related_topics: []
---

# Harness Engineering实践心得：如何高效驾驭AI

## 一句话概括
从 Prompt 到 Context 再到 Harness，通过搭建声明式规则、多 Agent 协作和自动化验证体系，让 AI 在受控环境中稳定产出高质量代码。

## 实践内容

### AI 编程的三次跃迁

文章将 AI 编程演进划分为三个时代：

| 维度 | Prompt 时代 | Context 时代 | Harness 时代 |
|------|------------|--------------|--------------|
| 人怎么指挥 AI | 一句话描述任务 | 喂设计文档 + 代码上下文 | 搭建环境 + 编写规则 + 构建反馈闭环 |
| AI 出错怎么办 | 重新写 Prompt | 补充更多上下文 | 分析缺失的护栏，编码为自动检查 |
| 知识在哪里 | 人脑里、聊天记录中 | 设计文档中 | 仓库里的规则文件、自动化脚本、基线数据 |
| 质量怎么保证 | 人工肉眼 Review | 编译 + 测试 | 声明式规则 + 自动化验证 + 修复闭环 |
| 可复现性 | 极低 | 中等 | 高（新 Agent 能按规则自治） |

### 实际案例：JK Launcher 项目

作者以 Unity 项目管理工具 JK Launcher（WPF .NET Framework 4.8）为例，展示了从 V3.0 到 V3.11 的 12 个大版本迭代过程：

- **Prompt 时代（V3.0 ~ V3.3）**：每次对话从零开始，AI 不知道项目规范，代码风格不一致
- **Context 时代（V3.4 ~ V3.8）**：开始写设计文档引导 AI，V3.5 写了近 1000 行设计规格文档
- **Harness 时代（V3.9 至今）**：搭建完整系统，包括声明式规则、技能封装、自动化验证、多 Agent 协作、基线管理

### 多 Agent 协作体系（7 个角色）

| Agent | 模型 | 职责 |
|-------|------|------|
| PM Orchestrator | composer-2 | 流程总控：协调各阶段、拍板前进还是回退 |
| Requirement Analyst | composer-2 | 需求分析：拆解多义性、对比候选方案、定验收标准 |
| Solution Architect | composer-2 | 方案设计：模块划分、接口定义、风险预判 |
| Gate Reviewer | composer-2 | 闸门评估：开发前做 8 个维度的审查 |
| Developer Agent | claude-4.6-opus-high-thinking | 写代码：按方案落地、编译自检 |
| Code Reviewer | gpt-5.4-medium | 代码评审：找逻辑漏洞、查需求遗漏、看设计偏离 |
| QA Tester | composer-2 | 测试验证：设计用例、分类缺陷、维护测试工程 |

### Rules vs Skills vs Scripts 三层分离

作者将原本 14 条 always-applied 规则（1000+ 行）精简为三层架构：

- **流程 Rule**：只保留 1 条核心流程规则（build-after-changes.mdc，<90 行），确保 AI 不会忘记要验证
- **Skill**：封装验证操作步骤，告诉 AI "怎么跑验证"
- **Script**（verify_all.ps1）：执行 14 项自动检查，输出 PASS/WARN/FAIL 报告

迁移后 always-applied 规则从 14 条降到 4 条，总行数从 1010 行砍到 275 行。核心思想：能用机器查的就别靠 AI 记。

## 摘录

> "Harness 这个词本意是'马具、挽具'——马再好，不套上鞍具它也拉不了车。给 AI Agent 套上合适的 Harness，它才能稳定地干活。"

> "Agent 搞砸的时候，解决办法不是'再跑一次试试'，而是退一步去想'缺了什么护栏？怎么让 Agent 看得懂、绕不过？'"

> "以前是'告诉 AI 做什么'，现在是'建一个 AI 能自己转起来的环境'。这就是 Harness。"

> "每个 Agent 都抓到了前面 Agent 没抓到的东西。这就是流水线的价值——不是 7 倍工作量，而是 7 层过滤网。"

> "规则写得再多，终归只是'告诉 AI 应该怎么做'。AI 可能看到了但忽略了，可能理解了但写的时候注意力没覆盖到。而脚本检查是机械执行的——只要文件里存在违规内容，就一定会被逮到。"

## 涉及实体
- OpenAI（Ryan Lopopolo 提出 Harness Engineering 概念）
- Unity 引擎
- WPF / .NET Framework 4.8
- Claude (claude-4.6-opus-high-thinking)
- GPT (gpt-5.4-medium)
- Cursor IDE（.cursor/rules/, .cursor/skills/, .cursor/agents/）
- SVN

## 涉及主题
- [[Harness Engineering]] —— AI 编程的第三阶段，搭建受控环境让 AI 自主执行
- [[多Agent协作]] —— 7 个角色分工协作的流水线开发模式
- [[AI代码质量保障]] —— 声明式规则 + 自动化验证 + 基线管理
- [[Prompt Engineering]] —— 从 Prompt 到 Context 到 Harness 的演进
