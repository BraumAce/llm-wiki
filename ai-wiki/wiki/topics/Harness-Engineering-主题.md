---
title: "Harness Engineering 主题"
type: topic
date: 2026-05-29
tags:
  - harness-engineering
  - ai-engineering
  - methodology
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Loop-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
  - "[[OpenHarness]]"
  - "[[Headroom]]"
  - "[[去哪儿AI-Coding体系]]"
  - "[[Agent-Skill]]"
  - "[[知识库工程]]"
sources:
  - "[[Loop-Engineering循环工程橙皮书]]"
  - "[[从Prompt-Context到Harness-工程的三次进化与终局之战]]"
  - "[[Harness-Engineering-耗时一周将AI-Coding率提升至90]]"
  - "[[Claude-Code-Harness工程-数仓侧落地方案-得物技术]]"
  - "[[告别氛围编程-基于Harness治理和SDD的团队级AI研发范式]]"
  - "[[QQ音乐Harness-Engineering实践]]"
  - "[[别让AI瞎猜了-用Harness-Engineering终结无限返工]]"
  - "[[Harness不是目的-知识才是护城河]]"
  - "[[Harness的尽头不是缰绳是镜子]]"
  - "[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]"
  - "[[Harness-Engineering-来龙去脉]]"
  - "[[Harness-Engineering-来了-SDD-还有意义吗]]"
  - "[[Claude-Code-最佳实践-可验证可治理可分层的工程现实]]"
  - "[[Claude-Code-加-OpenSpec-正在加速-AICoding-落地]]"
  - "[[AI-Coding思考-从工具提效到范式变革]]"
  - "[[规范驱动AI编程实战指南-OpenSpec-vs-Spec-Kit-vs-BMAD]]"
  - "[[TRAE-2026企业级AI编程实践手册]]"
  - "[[实战报告-AI-Coding已经能做交付了但前提苛刻]]"
  - "[[如何让你的Agent更准确-MCP工具设计技巧]]"
  - "[[你不知道的-Claude-Code-架构治理与工程实践]]"
  - "[[Harness-Engineering-长程自动化AI-Coding-Skills开发实践]]"
  - "[[4000行代码撑起一个Agent框架-nanobot架构深度解析]]"
  - "[[AI-时代如何超过大多数人]]"
  - "[[更可靠的主播助理：淘宝主播Agent的Harness工程实战]]"
  - "[[一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制]]"
  - "[[面向Skills编程-淘宝企业购端对端研发提效实践]]"
  - "[[Loop Engineering 概念解析、思考与实践]]"
  - "[[AI编程实践第18节：使用Headroom代理，帮我省下Token的隐形管家]]"
  - "[[重磅！Loop Engineering 实操手册公开]]"
  - "[[精华：去哪儿网AI-Coding研发平台实践，值得读三遍的样本]]"
  - "[[一文搞懂！Loop Engineering的进化史和本质]]"
  - "[[最新-万字综述-Prompt-到-Loop-进化]]"
  - "[[开启Harness-Engineering探索之旅]]"
  - "[[给野马套上缰绳-Agent-Harness工程实践-从范式理论到钉钉AI招聘的真实落地]]"
  - "[[从Vibe-Coding到Harness-一套大仓AI工程化实战]]"
  - "[[Loop-Engineering实战-实现从日志扫描到预发部署的全自主闭环]]"
  - "[[Harness工程实践-如何让Agent完成自主迭代]]"
  - "[[一文读懂Harness-Engineering]]"
  - "[[从AI-Coding到Harness-Engineering的端到端工程开发实践]]"
---

# Harness Engineering 主题

## 主题定义

Harness Engineering 涵盖 2026 年 AI 工程领域最重要的范式转移——从"怎么写好 prompt"到"怎么设计好整个工程框架"。包括 Rules（规则约束）、Skills（能力封装）、Wiki（知识沉淀）、Changes（变更追踪）四大要素，以及 hooks、lint、CI 等工程化机制。

## 核心要点

1. **三次进化**：Prompt Engineering（该说什么）→ Context Engineering（模型该知道什么）→ Harness Engineering（怎样让系统稳定可靠）。每一层都是上一层的超集

2. **生产 Harness 必须显式管理阶段和副作用**：腾讯 TAB 的 13 阶段流程把初始化、需求、方案、开发、真实 HTTP 集成测试、审查、验收和交付收尾拆成有输入输出的状态机；可判定的规则下沉为脚本，外部写操作限制在可审计的 MCP 收尾点。

3. **长程任务的可靠性来自结构化状态与可恢复证据**：JSON 任务清单、Git 历史、进度文件、测试后才能标通过以及 Context Reset，共同防止提前交卷、虚标完成和 session 失忆；单纯增加外置记忆或上下文长度不足以解决这些问题。

4. **评测驱动的 Agent 优化需要抵抗自我欺骗**：部署和评测工具要成为 Agent 能力，复杂分析应由独立子 Agent 完成；训练/验证隔离与 champion-challenger 基线避免模型把单个 badcase 写成硬编码规则。

5. **Loop 将 Harness 延伸为持续维护，但必须有预算和停止条件**：日志发现、补丁、334 条测试、预发和 Trace 验证可以自动衔接，但重试需受上限约束、验证者不能是修复者本人，超过边界要转人工而非无限运行。
2. **返工根因不是模型不行**：爱奇艺团队——"返工根因不是模型不会写代码，而是任务入口、执行依据、边界、验证、回写没提前备好"
3. **知识才是护城河**：腾讯团队——"Skill / Agent / 工具链会随模型迭代过期，私域知识才是护城河"
4. **隐性知识显性化**：James C. Scott 的"可读性"理论——AI 正在引发人类第三次"显形运动"
5. **五类最小组件**：入口定义、执行依据、边界约束、验证机制、回写规则
6. **AI 代码率可达 90%+**：阿里工程师在 10 万行 Java 存量应用中验证
7. **Goodhart 定律的阴影**：当指标成为目标，AI 可能学会"满足检查"而非"做正确的事"
8. **再上一层是 Loop Engineering**：harness 武装单次运行，[[Loop-Engineering]]（循环工程）让它在定时器上一遍遍自己跑、自己孵化子 agent、自我喂食——栈从"一次跑"延伸到"自己跑下去"

9. **个人层面的 Harness 是材料、标准、验证和流程沉淀**：AI 时代超过大多数人不是靠 prompt 模板，而是靠问题定义、上下文质量、验证能力、工作流沉淀和判断标准。这个个人工作法和团队 Harness 的底层逻辑一致：少让模型猜，多给事实、边界和可验收标准。

10. **生产业务 Agent 把 Harness 变成安全边界**：淘宝主播 Agent 的直播间场景要求操作即时生效、错误不可撤回、主播无法逐条核验，因此上下文、状态、Hook、幂等、安全审批、评测和记忆对账都必须由框架层兜住。

11. **Skill 与 Token 经济学决定 Harness 厚度**：Skill 可以封装流程和领域知识，但加载后会进入历史上下文；MCP Schema、工具结果、Memory/Rules 抖动都会影响缓存命中。生产 Harness 需要同时治理质量与成本。

12. **上下文治理可以外置成运行时中间层**：[[Headroom]] 这类工具把压缩、可逆检索、预算、审计和跨会话记忆放在 Agent 与模型 API 之间，说明 Harness 不只存在于仓库规则和工作流里，也可以成为流量侧的成本与上下文控制面。

13. **不是所有团队都该立刻上 Loop**：Loop 只有在任务重复、验证可自动化、token 预算可承受、日志可观测、且人仍愿意 review 产出的前提下才值得搭。否则它更像一个昂贵的自动返工器，而不是生产力放大器。

14. **在 Loop 时代，验证器比更强的生成模型更关键**：从控制论视角看，loop 是否收敛取决于传感器给控制器喂回来的偏差信号质量。`strong verification > strong prompt`，这也是 Harness 为什么必须把评测、断言、审查和门禁前置成系统能力。

15. **组织级 AI Coding 要先进入度量和计划系统**：去哪儿实践把出码率放回 Volume × Maturity 框架下，用 L0-L5 自动化等级、Harness 四把锁、QunarDevCenter 会话采集和“双估时”机制，让 AI Coding 从个人工具升级为研发管理对象。

16. **Loop 必须先有运行协议再谈自治**：`TRIGGER`、`SCOPE`、`ACTION`、`BUDGET`、`STOP`、`REPORT` 组成 Loop Contract；Circuit Breaker 和 Watchdog 是防止自动化返工、死循环和风险动作外溢的最低安全线。

17. **生产级 Harness 是研发操作系统**：腾讯 SpecWorker 样本说明，P1-P6 阶段、机器可读契约、评分卡、SubAgent、trace 诊断、阶段指标和知识库回写要串成一条线，单点规则文件不足以支撑团队级 AI Coding。

18. **Agent 数量本身也是上下文成本**：悟空 AI 招聘案例显示，全能 Agent 会在工具堆、长 Prompt 和易失上下文里失控；更稳的做法是少量专才 Agent + 大量原子化 Skill + Workspace 状态文件 + Linter/Reviewer 硬护栏。能沉成 [[Agent-Skill]] 的能力，不要轻易拆成新 Agent。

19. **知识库是交付流水线的底座，不是静态附件**：应用宝活动平台将全局/域/服务三级知识、人工补充、`git hash` 新鲜度检测与渐进加载放在需求拆解前；上层用状态文件、职责隔离的专家 Agent、DAG/worktree 和脚本化确定性操作，把 AI 从单窗口编码延伸至可恢复、可审计的端到端交付。

## 涉及实体

- [[Harness-Engineering]] —— 核心概念实体
- [[Loop-Engineering]] —— 四层栈最上层，坐在 harness 的"上一层楼"
- [[Spec-Driven-Development]] —— SDD 是 Harness 在需求阶段的实践
- [[OpenClaw]] —— OpenClaw 体现了 Harness 思维
- [[OpenClaw-Skills]] —— Skills 是 Harness 的能力封装层
- [[Agent-Skill]] —— 通用 Skill 能力包，是 Harness 中比新增 Agent 更低成本的能力封装方式
- [[AI可观测性]] —— Harness 的评测与 trace 观测能力
- [[Headroom]] —— Agent 上下文压缩与成本治理中间层
- [[去哪儿AI-Coding体系]] —— QunarDevCenter、天弦、Qsuperpowers 与 Skills Gateway 组合成组织级 AI Coding 样本
- [[知识库工程]] —— 以分层目录、版本新鲜度和按需加载为 Harness 提供业务上下文底座

## 对比矩阵

| 维度 | Prompt Engineering | Context Engineering | Harness Engineering | Loop Engineering |
|------|---|---|---|---|
| 关注点 | 说什么 | 知道什么 | 怎样可靠运行 | 怎样自己一遍遍跑 |
| 典型产物 | prompt 模板 | context 注入策略 | .harness/ + hooks + CI | automation + worktree + evaluator + memory |
| 可复用性 | 低 | 中 | 高 | 高 |
| 团队协作 | 弱 | 中 | 强 | 强（一个人干一个团队的活） |
| 管的范围 | 一句话 | 一个窗口 | 一次运行 | 让它自己跑下去 |

## 关键来源

- [[从Prompt-Context到Harness-工程的三次进化与终局之战]] —— 三次进化框架
- [[Harness-Engineering-耗时一周将AI-Coding率提升至90]] —— 阿里实践
- [[QQ音乐Harness-Engineering实践]] —— 团队级实践
- [[AI-时代如何超过大多数人]] —— 个人层面的上下文、验证和工作流沉淀方法
- [[更可靠的主播助理：淘宝主播Agent的Harness工程实战]] —— 高风险直播业务 Agent 的 Harness 实战
- [[面向Skills编程-淘宝企业购端对端研发提效实践]] —— Skill 流水线与端到端生码平台
- [[Loop Engineering 概念解析、思考与实践]] —— Loop 作为 Harness 之上的自动化验收闭环
- [[AI编程实践第18节：使用Headroom代理，帮我省下Token的隐形管家]] —— Headroom 作为流量侧上下文治理和成本控制面的实践
- [[重磅！Loop Engineering 实操手册公开]] —— Loop 的五个核心构件、最小落地配方与上线安全红线
- [[一文搞懂！Loop Engineering的进化史和本质]] —— 从 Prompt / Context / Harness 到 Loop 的演进链，以及控制论视角下的验证器中心论
- [[精华：去哪儿网AI-Coding研发平台实践，值得读三遍的样本]] —— 去哪儿组织级 AI Coding 度量、分级、数据采集、自动化编排与 Skills 治理案例
- [[最新-万字综述-Prompt-到-Loop-进化]] —— 补充 Prompt / Context / Harness / Loop 四层栈、Loop Contract、熔断器、Watchdog 和 Loop Designer 角色变化
- [[开启Harness-Engineering探索之旅]] —— 腾讯技术工程 P1-P6、线上运营、长期记忆、可观测性和 token 成本治理的端到端实践
- [[给野马套上缰绳-Agent-Harness工程实践-从范式理论到钉钉AI招聘的真实落地]] —— 用钉钉悟空 AI 招聘案例展示专才 Agent、Workspace、RPA lock、外发消息硬护栏和 Agent OS 判断
- [[从AI-Coding到Harness-Engineering的端到端工程开发实践]] —— 腾讯应用宝活动平台以知识库工程、状态文件、专家 Agent、DAG/worktree 与脚本化执行串起端到端交付
