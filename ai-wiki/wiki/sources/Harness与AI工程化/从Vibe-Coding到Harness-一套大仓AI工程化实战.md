---
title: "从 Vibe Coding 到 Harness：一套大仓 AI 工程化实战"
type: source
date: 2026-07-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/LGo7daiYYRf1r_YY3r-cXw"
author: "fitchzheng、leoshli（腾讯技术工程）"
published_at: "2026-07-07"
ingested_at: 2026-07-10
tags:
  - harness-engineering
  - spec-driven-development
  - multi-repo
  - workflow
  - mcp
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Agent-Skill]]"
  - "[[Loop-Engineering]]"
  - "[[Spec-Driven-Development]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 从 Vibe Coding 到 Harness：一套大仓 AI 工程化实战

## 一句话概括

腾讯 TAB 团队用真实跨仓需求复盘了 [[Harness-Engineering]] 的生产形态：SPEC 先行，能判定的 Rule 下沉为 Skill 或脚本，4 个专职 Agent 在 13 个阶段中交接，门禁和 MCP 把开发闭环延伸为有证据的交付闭环。

## 实践内容

### 大仓 Harness 的资产与角色边界

```text
六层资产：Rule / Skill / Sub Agent / Workflow / Scripts / MCP

角色：需求 Agent → 方案 Agent → 开发 Agent → 代码审查 Agent
原则：下游 Agent 不可改上游产物；开发 Agent 不得超出设计范围；
      代码审查 Agent 只产出阻塞项、不直接改代码。

可判定约束优先脚本化：
- 数据访问层必须使用 GORM → lint
- 错误必须走统一错误码 → 静态检查
- 覆盖率阈值 → 测试脚本
- 写操作必须走事务切面 → CR 阶段扫描
```

### 把测试和交付纳入流程状态机

```text
初始化 → 需求分析 → 方案 → Bug 复现（按需） → 分支准备 → 开发
→ 集成测试（真实 HTTP） → 代码审查 → 验收（含 diff 基线） → 交付收尾

外部系统操作：TAPD / Knot / iWiki / 工蜂 / 企微均以 MCP 方法封装。
写操作只在初始化、交付收尾发生；必须幂等、留痕，MCP 失败可软降级。
```

## 摘录

> TAB 的真实复杂度不在某一个仓库，而在多工作区、多子仓、协议字段、测试和外部协作系统同时变化。文章指出，模型“改完代码”的口头结论不能替代机器可读的事实；例如“跑过沙箱接口测试且新增覆盖率达到阈值”才是能被团队信任的完成证据。Harness 的目标因此不是让 AI 看上去更聪明，而是让它在复杂工程里稳定、规范、可审计地把事情做对。

> 在 TAB 的实践中，独立 Rule 被大幅压缩：凡是能被判定的约束，优先写成 Skill 里的确定性操作或脚本门禁。作者把 Skill 定位成注意力管理，而非能力增强——把数据访问规约、单测约束、接口测试生成、影响半径分析、范围溢出检查等按职责拆开，只在相应任务发生时加载，避免主 prompt 膨胀并降低规则同步成本。

> 流程阶段不能只按“看上去是否重复”合并。初始化包含只应执行一次的外部副作用；集成测试若留到代码审查之后，会让最昂贵的审查反复为路径或参数错误返工；验收阶段的基线对比则用来识别“历史问题”借口。作者最终将接口测试前置为硬门禁，使代码审查的平均打回次数从 1.8 次降至 0.4 次，并把“开发完成”重定义为代码、单测、接口用例文档和增量接口测试同时具备。

## 涉及实体

- [[Harness-Engineering]] —— 用规则、角色、工作流、门禁和交付接口构成可审计研发系统。
- [[Agent-Skill]] —— 将按职责加载的 SOP 从常驻 prompt 中剥离出来。
- [[Loop-Engineering]] —— 文章的阶段化与外置项目记忆可作为进一步持续循环的基础。
- [[Spec-Driven-Development]] —— 在拆 Agent 之前先确定目标、边界与验收契约。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

它给“企业大仓怎样少而精地拆 Agent”提供了清晰答案：角色数量不是架构美学，而由不可共享的认知责任、不可逆的外部副作用和可验证的阶段边界决定。相比只堆 Rule 的方案，更值得迁移的是“能判定就脚本化、能交付才接 MCP、每次写操作都能审计”的优先级。
