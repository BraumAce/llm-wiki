---
title: "Harness Engineering"
type: entity
date: 2026-05-29
also_known_as:
  - "Harness 工程"
  - "AI Harness"
  - "驾驭工程"
tags:
  - ai-engineering
  - methodology
  - harness
  - context-engineering
  - prompt-engineering
sources:
  - "[[如何写好Skill-一份终极实战经验手册]]"
  - "[[基于顶级Agent的Harness工程搭建式业务Agent评测方案]]"
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
  - "[[深入浅出Harness-Engineering之核心模式与理念]]"
  - "[[万字干货-Harness-Engineering如何工程化落地]]"
  - "[[Harness-Engineering实践心得-如何高效驾驭AI]]"
  - "[[Harness-Engineering-AI能在出事会炸的后端系统里写代码吗]]"
  - "[[从玩具到生产力-用真实项目讲透AI-Agent的Harness-Engineering]]"
  - "[[一文讲透如何构建Harness-六大组件全解析]]"
  - "[[一文讲透-Harness-Engineering即控制论]]"
  - "[[重新思考研发基础设施-当Agent成为第一公民]]"
  - "[[Harness-Engineering-长程自动化AI-Coding-Skills开发实践]]"
  - "[[4000行代码撑起一个Agent框架-nanobot架构深度解析]]"
  - "[[AI-时代如何超过大多数人]]"
  - "[[更可靠的主播助理：淘宝主播Agent的Harness工程实战]]"
  - "[[面向Skills编程-淘宝企业购端对端研发提效实践]]"
  - "[[Loop Engineering 概念解析、思考与实践]]"
  - "[[最新-万字综述-Prompt-到-Loop-进化]]"
  - "[[开启Harness-Engineering探索之旅]]"
  - "[[给野马套上缰绳-Agent-Harness工程实践-从范式理论到钉钉AI招聘的真实落地]]"
  - "[[Agent 评测：方法论与体系设计]]"
  - "[[从Vibe-Coding到Harness-一套大仓AI工程化实战]]"
  - "[[Loop-Engineering实战-实现从日志扫描到预发部署的全自主闭环]]"
  - "[[Harness工程实践-如何让Agent完成自主迭代]]"
  - "[[一文读懂Harness-Engineering]]"
  - "[[从AI-Coding到Harness-Engineering的端到端工程开发实践]]"
  - "[[从-Coder-到-Designer-电商团队数据研发的-Harness-Engineering实践]]"
related_entities:
  - "[[OpenClaw]]"
  - "[[Loop-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[Agent-Skill]]"
  - "[[OpenClaw-Skills]]"
  - "[[OpenHarness]]"
  - "[[Agent-Oriented-Infra]]"
  - "[[Credential-Brokering]]"
  - "[[AI可观测性]]"
---

# Harness Engineering

## 一句话定义

Harness Engineering 是继 Prompt Engineering、Context Engineering 之后的第三次 AI 工程范式进化——通过设计完整的约束、验证、反馈和治理框架，让 AI 系统在生产环境中稳定、可靠、可审计地运行。

## 摘要

Harness Engineering 的核心洞察是：AI 模型的能力已经不是瓶颈，真正的瓶颈在于"怎样让系统稳定可靠"。Prompt Engineering 回答"该说什么"，Context Engineering 回答"模型该知道什么"，Harness Engineering 回答"怎样让模型在工程约束下可靠地做正确的事"。2026 年上半年，从阿里、腾讯、得物、爱奇艺、QQ 音乐等多个团队的实践中可以看到一致共识：**返工根因不是模型不会写代码，而是任务入口、执行依据、边界、验证、回写没提前备好**。

Harness 一词取自"马具/驾驭"的隐喻——不是限制 AI 的缰绳，而是让 AI 可控运转的工程骨架。它包含 Rules（规则约束）、Skills（能力封装）、Wiki（知识沉淀）、Changes（变更追踪）四大要素，通过 hooks、lint、CI 等机制把 AI 的输出纳入可审计的工程流程。

## 详情

### 起源与背景

Harness Engineering 的思想萌芽可以追溯到 2025 年底。当时业界发现：AI Coding 的出码率从 53% 涨到 90%，但项目周期并没有相应缩短。根因分析指向三个问题：研发全链路覆盖不足、存量代码风险未管控、超长上下文导致模型失焦。

2026 年初，随着 Claude Code、Cursor 等 AI IDE 的普及，AGENTS.md / CLAUDE.md 等"给 AI 看的 README"成为实践入口。工程师们逐渐意识到，与其不断优化 prompt，不如设计一个完整的工程框架——把确定性的工作交给脚本和 lint，让 AI 只做理解和决策。

James C. Scott 的"可读性"理论为其提供了学术框架：AI 正在引发人类第三次"显形运动"，将工程师脑中不可言说的隐性知识强制文本化。从意图层、执行层、判断层三个维度，AI 改变了写文档的 ROI 经济学。

### 核心机制 / 工作原理

Harness Engineering 的核心是五类组件的协同：

1. **入口定义（Entry Point）**：明确 AI 拿到什么输入、上下文中包含什么。典型载体是 AGENTS.md / CLAUDE.md / .harness/ 目录
2. **执行依据（Execution Basis）**：Rules 层——代码规范、架构约束、命名约定等，通过 hooks 在每次工具调用前注入
3. **能力封装（Capability Packaging）**：Skills 层——把领域知识打包成可热插拔的 Skill，Agent 按需加载
4. **验证闭环（Verification Loop）**：lint / 自动测试 / 数据比对 / 四道门禁，确保输出符合预期
5. **知识沉淀（Knowledge Retention）**：Wiki 层——把项目私域知识持久化，不依赖 context window

落地分三阶段：
- **阶段一：找到入口**——梳理 AI 需要知道什么，写入 AGENTS.md
- **阶段二：可复盘**——记录每次 AI 交互的输入/输出/决策依据
- **阶段三：机械化**——把规则沉淀为 lint 脚本、CI 检查、自动化工作流

```
典型 .harness/ 目录结构
├── rules/           # 代码规范、架构约束
├── skills/          # 领域知识包
├── wiki/            # 项目知识库
├── changes/         # 变更历史与决策记录
└── AGENTS.md        # 入口文件
```

### 端到端研发管线：协议层、纪律层与长期记忆

腾讯技术工程的 SpecWorker 实践把 Harness 进一步落成“2 条轨道 + 1 个长期记忆”：研发端到端交付、线上运营，以及项目知识库。研发轨道从 P1 requirements、P2 design、P3 implementation、P4 e2e-test、P5 deploy 到 P6 archive，每个阶段都有机器可读的输入/输出、评分门槛和停止点。

这套实践的关键不是阶段命名，而是三层约束：

- **协议层**：`requirements.md` 和 `test-cases.md` 共用同一组 AC；`design.md` 写接口签名、数据模型、`sandbox_mode` 和 D-x 改动点；P6 用 delta spec 标记 ADDED / MODIFIED / REMOVED / RENAMED。
- **纪律层**：TDD、Debug、Verify、Review、Evaluate 分别拦住 AI 跳过测试、猜修复、无证据完成、偏离设计和自评偏高。
- **长期记忆**：项目级 `specs/` 与变更级 `knowledge-spec/` 通过 `index.md` 互通，P6 强制把反复出现的契约、坑和约定增量沉回知识库。

这说明 Harness 的生产形态已经不只是 `.harness/` 目录，而是一套让 AI 能看见契约、系统能追踪证据、团队能复用知识的研发操作系统。

### 应用 / 使用场景

- **存量应用改造**：阿里工程师在 10 万行 Java 应用中搭建 Harness，AI 代码率从 24.86% 提升到 90.54%
- **数仓治理**：得物离线数仓用 CLAUDE.md + hooks + subagents 解决 compact 后约束丢失问题
- **团队协作**：QQ 音乐在 50+ 微服务拓扑中用服务矩阵 + 五阶段流程 + 四道门禁实现可审计的 AI 协作
- **消除返工**：爱奇艺数据库团队用最小 harness（五类组件）终结"AI 瞎猜"式的无限返工
- **全栈开发**：得物团队用 Harness + SDD + 多仓模式实现前后端并行开发，提效 50%+
- **端到端研发交付**：腾讯技术工程用 P1-P6 流水线、评分卡、SubAgent、trace 诊断和知识库回写，把“AI 多写代码”推进到“AI 可交付、可追踪、可复用”
- **个人工作流**：把一次性 AI 对话沉淀为材料、标准、验证和复用流程。问题定义、上下文质量、验证能力、工作流沉淀和判断标准，是个人层面最小 Harness 的五个抓手
- **高风险业务 Agent**：淘宝主播 Agent 把 Harness 推到直播间场景，要求操作即时生效、错误不可撤回、主播无法逐条复核、会话长且可中断。框架层负责上下文、状态、Hook、安全、评测和记忆，业务方只用 Skill 声明能力边界、风险等级和参数校验
- **端到端研发流水线**：淘宝企业购把客户定制对接沉淀为 Skill 工作流，脚本承担接口提取等高精度环节，references 承载领域知识，子 Skill 拆分长文档与单接口生成，把不可控对话变成可复现流水线
- **企业招聘 Agent**：钉钉悟空 AI 招聘系统把全能 Agent 拆成 2 个专才 Agent 与一组原子化 Skill，用 Workspace 文件、RPA lock、Linter 和独立 Reviewer 守住状态、合规和对外消息边界

### Harness 平台化（Agent-Oriented Infra 视角）

从「每个团队自己在云服务器上搭运行环境」变成平台的内建能力：
- **Harness spec 声明式定义**：角色、工具、凭证、workspace、skill
- **Handoff 时自动初始化，完成后自动回收**
- **核心约束是即时供给**：并行 agent 数量对环境供给是乘法压力
- Agent 需要的完整工作环境：workspace + 前序 artifact + 工具权限 + 隔离凭证 + skill + handoff 通道

### 生产级 Agent 的状态、Hook 与评测

直播场景补充了一个重要视角：Harness 不只是 AI Coding 的质量辅助，而是高风险业务操作的安全边界。主播 Agent 的实现把状态更新从模型里拿出来，采用 Reducer 模式：模型只产生 Action，确定性的 Reducer 负责更新结构化 State，每轮再通过 system-hint 注入最新状态。这样既减少工具 JSON 污染上下文，也让状态可回放、可审计。

Lifecycle Hook 则把强规则放到模型循环的关键节点：`PreReasoning` 注入状态和记忆，`PreToolCall` 校验能力边界、幂等键和审批，`PostToolCall` 校验结果并更新状态，`PostReasoning` 检测幻觉，`LiveEnd` 触发记忆回写。评测层不只看最终答案，还看工具成功率、审批通过率、主播干预率、端到端延迟和会话满意度。

### 专才 Agent、Workspace 与 Agent OS

钉钉悟空 AI 招聘实践把 Harness 的工程取舍压缩成四条铁律：上下文越少越好，专才 Agent 胜过通才 Agent，状态写文件而不是塞上下文，能写成 Linter 的约束不要只留在文档里。它的第一版“全能招聘 Agent”把简历解析、人岗匹配、聊天、约面试、日历、RPA 和日报都塞进同一个 600 行 Prompt 与十多个工具中，结果工具选择、状态延续和错误复现都失控。

改造后变成“2 Agent + N Skill + Workspace”：悟空只做 Orchestrator，人岗匹配 Agent 负责 RPA 与打分，招聘沟通 Agent 负责候选人对话，其余能力下沉为原子化 [[Agent-Skill]]。候选人状态、聊天历史、JD、RPA lock 都写入 Workspace，外发消息再经过白名单工具、Linter 拦截和独立 Reviewer Agent 三层护栏。这个案例说明，Agent 数量本身也是上下文成本；Skill 可以增加很多，但对外说话和动用户数据的地方必须先有硬护栏。

这也把 Harness 推向“Agent OS”隐喻：用户交互层像 Shell，编排层像 Scheduler，Skill 是系统调用，Workspace 是文件系统，MCP 是设备驱动。竞争焦点不再只是“模型多聪明”，而是运行环境是否干净、可审计、可恢复、可替换。

### Harness 在评测领域的应用

Harness Engineering 的理念可以扩展到 Agent 评测领域。阿里团队的实践表明，用一个顶级 Agent（Claude Code）搭建评测 Harness，将评测逻辑从 Python 脚本升级为 Agent 提示词，可以实现：

- 评测方案设计从 1-2 天缩短到 10-30 分钟（~10x）
- 评测脚本开发从 2-3 天缩短到 1-2 小时（~10x）
- 单 Agent 全流程从 ~1.5 周压缩到 ~1-2 天（~5x）

核心创新是**三层指标框架（L1/L2/L3）**和**评测 Agent 提示词模板**——把 `test_runner.py` 的逻辑用自然语言表达，让一个 Agent 评测另一个 Agent。

同时，Skill 编写领域的工程化评估（Skill Creator 的触发评估 + 效果评估）也体现了 Harness 思维：不是靠感觉判断 Skill 好不好，而是用数据说话——触发准确率、召回率、效果通过率、相对提升率。

新一轮 Agent 评测实践把 Harness 的验证层进一步具体化：执行用例、采集 Trace、运行 Scorer、生成报告、根因归类可以作为通用骨架复用，但“评什么”和“怎么判”必须按 Agent 类型和业务风险定制。对话 Agent 要同时看 Turn、Session、Trace、Outcome；Skill 要评触发条件、流程正确性、工具参数、产物质量和异常降级。发布时还要把离线门禁与线上灰度联动，如果离线质量提升但转人工率、投诉率或业务闭环率恶化，就应触发回滚或降级。

这说明 Harness 的目标不是让每次评测出一个更漂亮的分数，而是形成反馈生产：线上失败通过 Trace 归因进入用例库、根因标签库、修复建议库、Judge 校准集和回归集。质量资产越厚，Agent 迭代越不依赖个人经验和临时救火。

### 多团队实践：从一次交付到持续维护与评测优化

腾讯 TAB 的大仓实践补强了 Harness 的**组织与交付边界**：先通过 SPEC 把需求、方案、实现、集成验证拆成有产物的阶段，再让需求、方案、开发、代码审查四个 Agent 只承担各自的认知责任。可判定规范不再停留在 Rule 文本，而是前移为 lint、覆盖率、事务扫描和真实 HTTP 集成测试等脚本证据；MCP 则只在初始化和交付收尾受控地接入需求、文档、代码评审和通知系统。这个案例说明，大仓的 Harness 首先是状态机和责任边界，而不是“多 Agent 数量”。

阿里两篇实践分别把 Harness 延长为**持续维护**与**自主优化**。前者以日志连接器、自动化、工作树、Skill、独立子 Agent 和状态文件构成发现→修复→预发的循环，且把重试限制为三轮；后者把部署和评测变成 Agent 工具，将结果分析委托给子 Agent，并以训练/验证隔离和 champion-challenger 防止 prompt 只对单个 badcase 过拟合。这些案例共同把“Agent 已完成”的判断从模型自述迁移到独立测试、Trace、评测集和对比基线。

长程 Agent 的底层制度也更清晰：[[Context-Engineering]] 解决信息存取和压缩，但不能保证 Agent 会读取、遵循和验证；Harness 还必须以机器可读任务清单、每轮唤醒步骤、Git 可恢复历史与 Context Reset 控制提前交卷、虚标完成和 session 失忆。因此，结构化状态和可验证完成条件优先于继续堆叠 prompt。

### 知识库底座与状态驱动的端到端交付

腾讯应用宝活动平台进一步给出了一种“底座 + 流水线”的拆法。底座是 [[知识库工程]]：总览、业务域索引、服务事实文档与人工 `custom/` 补充形成分层上下文；文档生成记录 `git hash`，借增量更新和追加式日志对抗业务知识过期。查询先缩小业务域，再按问题类型读取必要的服务文档，避免把整套知识一次性塞入模型窗口。

上层端到端开发不把状态藏在对话里，而将需求拆解、任务 DAG、波次开发、测试、代码审查、部署和接口验证的输入输出写成结构化状态。专家 Agent 只做一件事，并按职责裁剪可见上下文和工具；并发任务用 worktree 隔离，共享入口、协议和全局配置则串行收口。文章将此归结为“AI 负责认知，脚本负责执行”：状态解析、工作树、编译发布等确定性步骤封装为脚本，模型负责需求理解、方案和生成，从而减少随机性、token 浪费和越权操作。

### 数据研发：把“生成 SQL”收束为可验证交付

电商数研案例表明，Harness 的对象不必是代码仓库，也可以是高准确性的数据研发流程。其前置条件是语义资产：自然语言先映射为受治理的指标—维度语义，再生成 SQL；指标的标准名称、别名和语义边界由专家确认，并用上线前去重、上线后健康度评估对抗资产劣化。这样，模型的自由生成被收束为对业务契约的选择与组合。

工作流以顺序协作和反馈循环结合人工 Gate：下游发现 SQL 质量问题时能够回滚上游重新决策。对“Agent 说已完成”的幻觉，Hook 要比较自述与真实状态，关键步骤必须留下文件、数据或状态变更等独立证据。案例还要求 Workspace 隔离、禁止跨 workspace 加载、按需开放 Skill，并通过 Git 备份和配置同步保证运行环境可恢复。最后，心跳机制从成功率、失败原因和人工修正中发现模式，把核准后的 Prompt、知识条目或工作流参数调整写回，形成受控的持续优化而非无边界自治。

### 局限与争议

- **过度工程化风险**：Harness 过厚会降低开发速度，"合适厚度"需要团队自己摸索
- **知识才是护城河**：腾讯团队指出"Skill / Agent / 工具链会随模型迭代过期，私域知识才是护城河"——Harness 是手段不是目的
- **Goodhart 定律**：当 Harness 的指标成为目标，它就不再是好的指标。AI 可能学会"满足 harness 检查"而非"做正确的事"
- **团队采纳门槛**：需要团队共识和持续维护，个人项目收益有限

## 与其他实体的关系

- [[OpenClaw]] —— OpenClaw 的设计哲学本身就体现了 Harness 思维：CLAUDE.md 持久化状态、hooks 强制规范、Skills 封装领域知识
- [[Loop-Engineering]] —— 循环工程是 harness 的"上一层楼"：harness 武装单次运行，loop 让这次运行在定时器上自动重来
- [[Spec-Driven-Development]] —— SDD 是 Harness 在需求阶段的具体实践，两者经常组合使用
- [[Agent-Skill]] —— Skill 是 Harness 的低成本能力单元；在专才架构中，能沉成 Skill 的能力通常不应拆成新 Agent
- [[知识库工程]] —— 将代码事实、人工业务知识、索引和新鲜度检测转化为上层 Agent 可精确加载的上下文底座
- [[NL2SQL]] —— Harness 可把语义治理、文档状态机、人工 Gate 和结果验证组合为生产级的数据研发交付链
- [[OpenClaw-Skills]] —— Skills 是 Harness 的能力封装层，Agent 按需加载领域知识包
- [[AI可观测性]] —— 生产级 Agent 需要 trace、离线评测、在线指标和人工满意度共同判断质量

## 参考来源

- [[如何写好Skill-一份终极实战经验手册]] —— 腾讯工程师，Skill 编写全指南与工程化评估
- [[基于顶级Agent的Harness工程搭建式业务Agent评测方案]] —— 阿里云开发者，用 CC 搭建评测 Harness
- [[从Prompt-Context到Harness-工程的三次进化与终局之战]] —— 腾讯云开发者，三次进化框架
- [[Harness-Engineering-耗时一周将AI-Coding率提升至90]] —— 阿里工程师，10万行Java存量应用实践
- [[Claude-Code-Harness工程-数仓侧落地方案-得物技术]] —— 得物技术，数仓侧落地方案
- [[QQ音乐Harness-Engineering实践]] —— QQ音乐，50+微服务团队实践
- [[别让AI瞎猜了-用Harness-Engineering终结无限返工]] —— 爱奇艺，最小harness五类组件
- [[Harness不是目的-知识才是护城河]] —— 腾讯团队，知识沉淀实践
- [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] —— OpenClaw 的 Harness 设计
- [[重新思考研发基础设施-当Agent成为第一公民]] —— Harness 平台化与 Agent-Oriented Infra
- [[AI-不缺智商缺纪律：一场-Harness-工程化实践]] —— 阿里技术，Harness 分层结构与评测驱动
- [[Harness-Engineering落地前先想清楚这几个问题]] —— 腾讯云开发者，存量项目 AI Coding 适配
- [[AI-时代如何超过大多数人]] —— 个人层面的材料、标准、验证和流程沉淀
- [[更可靠的主播助理：淘宝主播Agent的Harness工程实战]] —— 阿里云开发者，直播间高风险 Agent 的 Harness 六元组、Reducer 状态、Hook、评测和记忆对账
- [[面向Skills编程-淘宝企业购端对端研发提效实践]] —— 大淘宝技术，企业购客户对接从 Prompt/SDD 演进到 Skill 流水线
- [[Loop Engineering 概念解析、思考与实践]] —— 阿里技术，区分底层 Agent Loop 与 Harness 之上的自动化验收闭环
- [[最新-万字综述-Prompt-到-Loop-进化]] —— Datawhale，把 Prompt、Context、Harness、Loop 串成统一演进栈，并强调 Harness 的安全围栏位置
- [[开启Harness-Engineering探索之旅]] —— 腾讯技术工程，展示 P1-P6 研发交付、线上运营、知识库长期记忆和可观测性指标如何组成生产级 Harness
- [[给野马套上缰绳-Agent-Harness工程实践-从范式理论到钉钉AI招聘的真实落地]] —— 阿里云开发者，用悟空 AI 招聘说明全能 Agent 到 2 Agent + N Skill + Workspace + Linter 护栏的架构迁移
- [[Agent 评测：方法论与体系设计]] —— 阿里技术，把 Agent 评测拆成类型侧重、Trace、Scorer、线上灰度和反馈生产闭环
- [[从Vibe-Coding到Harness-一套大仓AI工程化实战]] —— 腾讯 TAB，SPEC、4 个 Agent、13 阶段、脚本门禁与 MCP 交付闭环
- [[Loop-Engineering实战-实现从日志扫描到预发部署的全自主闭环]] —— 阿里云开发者，日志发现、独立验证、预发与状态沉淀的持续维护 Loop
- [[Harness工程实践-如何让Agent完成自主迭代]] —— 阿里技术，父子 Agent、评测隔离与 champion-challenger 防止 reward hacking
- [[一文读懂Harness-Engineering]] —— 腾讯云开发者，长程 Agent 的结构化状态、唤醒、回滚与 Context Reset
- [[从AI-Coding到Harness-Engineering的端到端工程开发实践]] —— 腾讯应用宝活动平台，以知识库工程、状态文件、职责隔离、DAG/worktree 与脚本化执行串起从需求到接口验证的交付链
- [[从-Coder-到-Designer-电商团队数据研发的-Harness-Engineering实践]] —— 阿里技术以 NL2DSL2SQL、语义资产治理、7 Agent 工作流、结果校验和心跳回写构成数据研发 Harness 案例
