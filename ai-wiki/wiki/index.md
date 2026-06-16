---
title: "LLM Wiki"
type: index
date: 2026-06-03
---

> 个人 AI 知识库 —— AI 编译过的百科全书

## 状态

- 实体数：68 ｜ 主题数：9 ｜ 来源数：156
- 最后更新：2026-06-16

### 主题导航

- [[Agent架构演进-主题|Agent 架构演进]] —— 从"一问一答"到"自主执行"的架构演进路径
- [[Agentic-Engineering-主题|Agentic Engineering]] —— 从 Vibe Coding 到 AI 主导的工程范式
- [[Harness-Engineering-主题|Harness Engineering]] —— 从"写好 prompt"到"设计好整个工程框架"
- [[Claude-Code源码解析-主题|Claude Code 源码解析]] —— 社区对 Claude Code 的源码级深度分析
- [[AI-Skill体系-主题|AI Skill 体系]] —— Skill 的标准化、工程化与自进化
- [[Skill开发最佳实践|Skill 开发最佳实践]] —— Skill 迭代式编写与触发设计
- [[Agent评测方法论|Agent 评测方法论]] —— 结构化评估规则 + 执行流程
- [[AI-Infra推理优化-主题|AI Infra 推理优化]] —— 推理服务全栈：数学原理 → RAG / Memory
- [[OpenClaw-digest-20260510|OpenClaw 综合]] —— 架构总览与三大子系统设计哲学

## 最近更新

### 2026-06-16

新增来源：[[AI-Agent-Skill-测评方案及落地实践]] —— 腾讯技术工程网关测试团队的生产级 Agent/Skill 测评框架，覆盖三类评分器（确定性/Rubric/人工）、五大维度、四类用例、Trace、基线和 TPerf 性能分析 Agent 落地。

新增来源：[[AI-时代如何超过大多数人]] —— 拓跋阿秀从个人 AI 使用方法切入，把差距归结为问题定义、上下文质量、验证能力、工作流沉淀和判断标准，而不是 prompt 模板或模型榜单。

更新来源：[[AI-不缺智商缺纪律：一场-Harness-工程化实践]] —— 合并新 URL「我的 Harness 工程化实践」版本，补充 dispatcher 状态机、G1-G8 门禁、Hook 拦截、七维确定性评分和评测平台边界。

更新实体/主题：[[Prompt评估体系]]、[[Generator-Evaluator]]、[[Harness-Engineering]]、[[Context-Engineering]]、[[Agentic-Engineering]]、[[Agent评测方法论]]、[[AI-Skill体系-主题]]、[[Harness-Engineering-主题]]、[[Agentic-Engineering-主题]] —— 追加 Agent/Skill 测评、个人上下文质量和验证工作流视角。

新增来源：[[Loop-Engineering循环工程橙皮书]] —— 花叔「橙皮书系列」第四本，把 loop engineering（循环工程）一次讲清：四层栈（prompt→context→harness→loop）、一个循环的五个动作、六个零件、四笔代价（验证债/理解腐烂/认知投降/token 失控）、Claude Code 的 /loop 与 /goal 原语。

新增来源：[[一篇搞懂-AI-Coding-Agent的Token成本控制]] —— 腾讯技术工程 AI Coding Agent 降本完整指南，五层路径（使用习惯→模型路由→上下文压缩→代码图谱→Agent 架构），核心心智模型「账单大头是系统为了回答你重复搬运的上下文」。

新增来源：[[后端架构AI-Friendly的标准与路径]] —— 阿里技术从后端分布式系统、面向 7×24 无人值守开发角度给出 14 节 AI Friendly 标准（六类事实、Architecture Map、Service Card、Harness 七层、Test-Gated、L0–L5 权限、Architecture as Code、Copilot→Coworker→Operator）。

新增实体：[[Loop-Engineering]]、[[Generator-Evaluator]]、[[Stripe-Minions]]、[[Addy-Osmani]] —— Loop Engineering 循环工程 4 个实体。
新增实体：[[Token成本控制]]、[[Prompt-Cache]]、[[Orchestrator-Worker模式]] —— AI Coding 成本优化 3 个实体。

更新实体：[[AI-Friendly架构]] —— 补「后端分布式/无人值守」视角整节，关联 [[Harness-Engineering]]、[[AI-Native软件工程]]。
更新实体：[[Harness-Engineering]] —— 关联 [[Loop-Engineering]]（harness 的上一层楼）。
更新主题：[[Harness-Engineering-主题]] —— 四层栈对比矩阵补 Loop 列 + 核心要点。

### 2026-06-12

新增来源：[[如何构建一个更好的知识库]] —— 大淘宝技术系统讲解 RAG 知识库全链路优化，涵盖 RAGAS 评估、文档切分（Late Chunking）、混合检索（RRF 融合）、查询增强（HyDE/Multi-Query/EAR）、Cross-Encoder 重排序、AutoRAG 自动化、QuIM-RAG 问题倒排索引、OpenViking 文件系统范式。

新增来源：[[面向-Agent-Skill的-CLI-SSO-鉴权体系]] —— 货拉拉技术为 Agent Skill 调用企业内部系统设计的 SSO 鉴权方案，keychain 主密钥 + 密文文件 + 飞书 Hook 登录 + Agent 轮询授权，实现 token 不落盘、多用户隔离、登录无感。

新增来源：[[让-Claude-Code-拥有自我进化和记忆系统]] —— 得物技术为 Claude Code 构建持久化记忆与自我学习系统，Hook 机制 100% 捕获工具调用 → 统计+语义双路径提炼 Instinct 规则 → 向量检索+上下文注入，Token 消耗降低 78%，错误重复率下降 80%。

新增来源：[[AI-不缺智商缺纪律：一场-Harness-工程化实践]] —— 阿里技术两个月 Harness 工程化复盘，五层 harness 分层结构、多 Agent 职责隔离、评测驱动迭代、4 条踩坑教训（prompt 是负债不是资产、过度拆分 Agent 代价大等）。

新增来源：[[Harness-Engineering落地前先想清楚这几个问题]] —— 腾讯云开发者从数据中台 AI 助手 Dola 出发，讨论流式渲染架构改造和存量项目如何用 Harness Engineering 思路适配 AI Coding（规则机器可读、入口收敛、决策显式）。

新增来源：[[Agent-skill-迭代式编写实战]] —— 大淘宝技术 Agent Skill 编写经验，三层渐进式披露架构、决策树替代模糊判断、执行后自查机制、内部+外部双重验证。

新增实体：[[RAGAS]]、[[HyDE]]、[[Cross-Encoder]]、[[AutoRAG]]、[[QuIM-RAG]]、[[OpenViking]]、[[Late-Chunking]] —— RAG 全链路优化 7 个实体。
新增实体：[[Agent-Skill-Auth]]、[[sso-cli]] —— Agent Skill 鉴权 2 个实体。
新增实体：[[Hook-机制]]、[[Instinct-Engine]] —— Claude Code 自我学习系统 2 个实体。
新增实体：[[Cursor]]、[[CodeBuddy]] —— AI Coding IDE 2 个实体。

更新实体：[[RAG]]、[[Harness-Engineering]]、[[Claude-Code]]、[[Agent-Memory]]、[[Credential-Brokering]] —— 追加来源引用。

### 2026-06-09

新增来源：[[知识库分层编排-从RAG到Agent-native-Knowledge-Context-Layer]] —— 阿里云板牙系统梳理知识库四大范式（Naive RAG → LLM Wiki → Graphify → GraphRAG），提出金字塔知识库五层分层模型（原则→架构→规范→实现→经验），结合角色感知检索和图谱关联，Pyramid+RAG Hit@3=89% vs Naive RAG ~75%。

新增来源：[[设计模式已死]] —— 腾讯云王顺驰论证 AI 时代设计模式的永恒价值，10 个经典模式（单例、工厂、观察者、装饰者、策略、适配器、代理、命令、组合、迭代器）在 Agent 系统中自发重现。

新增实体：[[GraphRAG]] —— Microsoft 提出的图谱增强检索，通过知识图谱 + Leiden 社区聚类 + 分层社区摘要解决传统 RAG 的碎片化检索和全局理解问题。
新增实体：[[Pyramid-KB]] —— 金字塔知识库，五层分层 + 角色感知 + 图谱关联，Agent-native 的知识基座。

更新实体：[[RAG]] —— 追加知识库分层编排来源，补充 GraphRAG、Pyramid-KB 关联。

### 2026-06-03

新增来源：[[Agent-Memory评测全景-基准评估与记忆系统]] —— 大淘宝技术阿元系统梳理 Agent 长期记忆评测全景，涵盖基准（MUSE、LOCOMO）、评估（MemoryAgentBench、LONGMEMEVAL、MemBench）与系统（THEANINE、RMM、M3-Agent、Mem0）三条主线，指出冲突解决是所有方法的短板（多跳场景最高仅6%）。

新增来源：[[重新思考研发基础设施-当Agent成为第一公民]] —— 阿里技术晓斌提出意图驱动+代码沉淀统一框架，Agent 把循环速度从月级压缩到分钟级导致原有 infra 系统性失配，需要从 People-Oriented 重建为 Agent-Oriented 的四层设计原则。

新增实体：[[Mem0]]、[[M3-Agent]]、[[LOCOMO]]、[[MemoryAgentBench]]、[[LONGMEMEVAL]]、[[MemBench]]、[[THEANINE]]、[[RMM]]、[[MUSE]] —— Agent Memory 评测全景 9 个实体。

新增实体：[[Agent-Oriented-Infra]]、[[Credential-Brokering]]、[[Agent-DX]] —— 研发基础设施 Agent 化 3 个实体。

更新实体：[[Agent-Memory]] —— 追加评测全景来源。
更新实体：[[Harness-Engineering]] —— 追加来源，补充 Harness 平台化视角。

### 2026-06-02

新增来源：[[面向LLM的架构设计-什么是真正的AI-Friendly架构]] —— 大淘宝技术团队万字长文，系统阐述传统架构向 AI Friendly 架构演进的三范式，以及 Multi-Agent、Context Engineering、AI Friendly API、AI可观测等核心能力的落地实战。

新增来源：[[Agent核心技术概念与范式发生了哪些演变以及背后的思考]] —— 阿里技术飞樰系统梳理 Agent 从2023到2026年的四个发展阶段（被动式ReAct→工作流Agent→自主Agent→自进化Agent），深入分析 Prompt、Planning、Memory、Tools、Workflow、Environment 六大核心技术的前后演变逻辑。

新增来源：[[深入解析Chromium的AI-Coding开发体系]] —— 腾讯QQ浏览器团队深入分析 Chromium 源码仓库中内建的 AI Agent 基础设施——四层 Prompt 分层组合架构、18+ 可复用 Skills、MCP 扩展、知识库、评估体系和大规模 AI 驱动项目。

新增来源：[[AI软件工程范式革命的思考]] —— 腾讯云王鹏程从控制论和工程史视角论证软件工程过去五十年从未真正“工程化”，大模型第一次让“投入能源，另一头流出可工作的软件”成为可能。

新增实体：[[AI-Friendly架构]]、[[ReAct]]、[[Context-Engineering]]、[[AI-Friendly-API]]、[[AI可观测性]]、[[自进化Agent]]、[[Chromium-AI-Coding]]、[[Prompt分层组合架构]]、[[Prompt评估体系]]、[[软件工程范式革命]]、[[AI-Native软件工程]]

### 2026-05-31

新增实体：[[SkillOpt]] —— 微软开源的 Skill 自动优化框架，通过轨迹驱动编辑和验证门控机制，在不修改模型权重的前提下系统化优化 Agent Skill 文件。

新增实体：[[MiniCPM5-1B]] —— 面壁智能 & OpenBMB 开源的 1B 参数端侧文本基座模型，AA-Index 2B 以下最强，INT4 量化仅 0.5GB。

新增实体：[[OpenHarness]] —— 港大 HKUDS 开源的轻量级 Agent 基础设施，43+ 工具、多级权限、多 Provider 兼容，附带 ohmo 个人 AI 助手。

新增来源：[[SkillOpt-GitHub]]、[[MiniCPM5-1B-GitHub]]、[[OpenHarness-GitHub]]

---

新增 41 篇来源摘要（含 1 篇 GitHub Issue），通过 Playwright CDP 抓取微信公众号原文约 70 万字。

新增实体：[[MCP]]、[[Anthropic]]

更新实体：[[Claude-Code]]（+7 篇）

更新主题：[[Harness-Engineering-主题]]（+10）、[[Claude-Code源码解析-主题]]（+7）、[[AI-Skill体系-主题]]（+12）、[[Agent架构演进-主题]]（+6）

### 2026-05-30

新增 41 篇来源摘要，通过 CDP 浏览器补充微信公众号原文。

新增实体：[[Claude-Code]]、[[Hermes-Agent]]、[[Agentic-Engineering]]、[[Anthropic]]、[[Mitchell-Hashimoto]]、[[LightRAG]]、[[DeepSeek-V4]]、[[wechat-cli]]

新增主题：[[Claude-Code源码解析-主题]]、[[Agentic-Engineering-主题]]、[[AI-Skill体系-主题]]

### 2026-05-29

新增 38 篇来源摘要。

新增实体：[[Harness-Engineering]]、[[Spec-Driven-Development]]、[[vLLM]]、[[RAG]]、[[Agent-Memory]]

新增主题：[[Harness-Engineering-主题]]、[[Agent架构演进-主题]]、[[AI-Infra推理优化-主题]]

### 2026-05-10

首批入库。[[OpenClaw]] 9 篇来源 + 3 子实体（[[OpenClaw-双源记忆系统]]、[[OpenClaw-Skills]]、[[OpenClaw-SandBox]]）
