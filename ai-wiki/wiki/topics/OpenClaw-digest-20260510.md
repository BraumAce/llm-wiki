---
title: "OpenClaw 综合：架构总览、三大子系统的共同设计哲学与开放问题"
type: topic
date: 2026-05-10
tags:
  - digest
  - openclaw
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-SandBox]]"
  - "[[OpenClaw-双源记忆系统]]"
  - "[[OpenClaw-Skills]]"
sources:
  - "[[深入理解OpenClaw技术架构与实现原理-上]]"
  - "[[深入理解OpenClaw技术架构与实现原理-下]]"
  - "[[从架构到代码-深入理解OpenClaw的双源记忆系统]]"
  - "[[玩转OpenClaw-核心架构-运作原理-Agent部署步骤]]"
  - "[[龙虾大脑核心揭秘1-OpenClaw处理流程链路解析]]"
  - "[[以OpenClaw为例介绍AI-Agent的运作原理]]"
  - "[[OpenClaw-Agent与Skill架构详解]]"
  - "[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]"
  - "[[OpenClaw橙皮书-从入门到精通]]"
---

# OpenClaw 综合：架构总览、三大子系统的共同设计哲学与开放问题

> 本文是 [[OpenClaw]] 主题在 2026-05-10 的首次综合报告，跨 9 个来源（阿里云 / 腾讯云 / 腾讯技术 / 京东科技 / 京东技术 / Java 一条人 / 花叔的飞书 wiki）+ 4 个实体页，从架构总览、三大子系统横向对比、设计哲学抽象、开放问题、阅读路径五条线索整合。

## 核心要点

1. **OpenClaw 的真正价值不在技术难度本身，而在"共识的推广"**——把 IM 接入、本地优先、Agent 沉淀、Skills/Memory/Sandbox 等"每个搭 Agent 的人都要重做一遍"的事情打包成默认范式
2. **三大子系统（SandBox / 记忆 / Skills）共享一组同构的设计哲学**：文件即真相、可配置粒度、默认安全、单调收紧
3. **System Prompt 是运行时拼接产物**：23 个条件加载模块按当前任务、配置、可用工具动态裁剪，非硬编码字符串
4. **记忆与上下文是不同的物种**：上下文是工作台（临时、有限、昂贵），记忆是知识库（持久、无限、成本接近零）；OpenClaw 把它们彻底剥离
5. **多个开放问题尚未充分讨论**：自进化的回滚边界、多 Agent 的 IM 额度爆掉、长尾记忆的时间衰减偏激进、System Prompt 模块 18 在原文目录中缺失

## 一、生态位与诞生时序

| 时间点 | 事件 |
|---|---|
| 2026-01 | OpenClaw 开源 |
| 2026-03 上 | 中文技术圈集中报道开始（[[玩转OpenClaw-核心架构-运作原理-Agent部署步骤]] 03-09 / [[以OpenClaw为例介绍AI-Agent的运作原理]] 03-17 / [[深入理解OpenClaw技术架构与实现原理-上]] 03-19 / [[从架构到代码-深入理解OpenClaw的双源记忆系统]] 03-19 / [[龙虾大脑核心揭秘1-OpenClaw处理流程链路解析]] 03-23 / [[深入理解OpenClaw技术架构与实现原理-下]] 03-26）|
| 2026-04 | 深度专题二轮（[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] 04-13 / [[OpenClaw-Agent与Skill架构详解]] 04-15）+ [[OpenClaw橙皮书-从入门到精通]] 上架微信读书 |

10 周内中文圈完成"现象级产品 → 源码级解析 → 全民手册"的传播链路，节奏快得不正常——是"共识推广"叙事的最直接证据。

## 二、整体架构总览

[[OpenClaw]] 主架构是**以 Gateway 为单一控制平面的分布式系统**：

- **Gateway**（[[深入理解OpenClaw技术架构与实现原理-上]] 3.1）：常驻 WebSocket 服务器，端口 18789，单端口复用 RPC + HTTP API + Control UI；协议版本化、角色分离（operator / node）
- **Pi Agent / Agentic Loop**（[[OpenClaw-Agent与Skill架构详解]] 2.1.2 / 上篇 3.2）：基于 ReAct 的事件驱动循环，主循环（run.ts）→ 单次尝试（attempt.ts）→ 事件订阅（subscribe.ts）→ 工具循环
- **Channels**：原生支持 WhatsApp / Telegram / Slack / Discord / Google Chat / Signal / iMessage / Microsoft Teams / Matrix / Zalo
- **Nodes**：把 macOS / iOS / Android 等设备定义为节点，远程调用硬件能力（摄像头 / 屏幕 / 地理位置 / `system.run`）
- **三大子系统**：SandBox（[[OpenClaw-SandBox]]）/ Memory（[[OpenClaw-双源记忆系统]]）/ Skills（[[OpenClaw-Skills]]）

[[龙虾大脑核心揭秘1-OpenClaw处理流程链路解析]] 提出的"四层架构（Model / Skills / Workflow / Execution）+ 十大消息处理步骤" 是面向非工程读者的另一种叙事，可作为白板讲解模板。

## 三、三大子系统横向对比

|  | [[OpenClaw-SandBox]] | [[OpenClaw-双源记忆系统]] | [[OpenClaw-Skills]] |
|---|---|---|---|
| **核心问题** | AI 帮我跑命令的安全问题 | AI 怎么"记住"我 | AI 怎么"知道"做某类事的方法 |
| **存储介质** | Docker 容器 + 工作区挂载 | Markdown（静态）+ JSONL（动态）+ SQLite 索引 | SKILL.md 文件 |
| **配置粒度（核心档位）** | mode: off/non-main/all<br>scope: session/agent/shared<br>workspaceAccess: none/ro/rw | 静态记忆三种产生途径（用户手写 / hook 自动 / Memory Flush）<br>向量+BM25 加权融合 | 6 源加载（project > plugin > user > bundled > external > fallback）|
| **默认配置** | mode=non-main, scope=session, workspaceAccess=none, network=none, capDrop=ALL | vectorWeight=0.7 / textWeight=0.3 / MMR λ=0.7 / 半衰期 30 天 | 仅菜单注入 prompt（name+description+location），never read more than one skill up front |
| **核心约束** | 工具策略只能进一步收紧，不能放宽 | 文件即真相，索引只是加速器 | 全文按需读取，菜单为先 |
| **CLI 实用命令** | `sandbox list/recreate/explain` | （见双源记忆系统章节） | `skill install/list/update/sync` |

## 四、共同设计哲学的横向抽象

跨三大子系统提炼出来的**四条同构原则**：

### 4.1 文件即真相（Files-as-Source-of-Truth）

- **记忆**：主存是 `MEMORY.md` + `memory/YYYY-MM-DD.md`，SQLite 索引仅辅助（[[从架构到代码-深入理解OpenClaw的双源记忆系统]]）
- **Skills**：主体是 `SKILL.md`，菜单注入是路由层
- **Workspace 灵魂文件**：`AGENTS.md` / `SOUL.md` / `USER.md` / `IDENTITY.md` / `TOOLS.md` 直接拼到 system prompt 模块 15（[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]）
- **配置文件**：`openclaw gateway.json` 等可被人直接编辑

含义：用户随时可以打开任何状态文件直接读、直接改，不被数据库黑盒锁住。

### 4.2 可配置粒度 + 默认安全（Default-Secure with Knobs）

每个子系统都给"默认安全"和"可放宽"两套配置，但放宽必须显式声明：
- SandBox：默认 `network: "none"` / `capDrop: ["ALL"]`，开网络要主动声明
- Skills：默认仅注入菜单不读全文，全文必须 LLM 主动 `read SKILL.md`
- 记忆：默认只索引 Markdown 不索引 JSONL，避免噪声

### 4.3 单调收紧（Monotonically Restricting）

策略只能层叠收紧，不能从下层放宽上层。SandBox 的工具策略层级最明显：

```
全局策略 → Agent 特定 → Sandbox 工具策略 → 子 Agent 策略
（每一层只能进一步限制）
```

这种属性让安全审计变简单——只要看最严的那一层就足够。

### 4.4 条件化拼接（Conditional Composition）

System Prompt 不是定死字符串，而是 23 个模块按当前 context 拼出来的运行时产物（[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]）。每个模块带 `[full / minimal / 有X时]` 三档加载条件，让 token 预算可控。

## 五、与同代产品的差异化定位

[[OpenClaw-Agent与Skill架构详解]] 给出三层差异：
- **基础设施层**：基于 pi-mono 嵌入 Agent 引擎（ReAct + LLM + 工具）
- **平台层**：在 pi-mono 之上加路由 / 容错 / 认证 / Skill 系统
- **渠道层**：统一消息抽象 → 同一 Agent 服务多平台

与 Claude Code / Cursor / Aider 的本质区别：
- **场景**：日常 IM 而非编辑器内
- **运行**：本地常驻而非每次启动
- **数据**：完全留在本机（用户控制密钥、无云端账号绑定）
- **演化**：自我修改（动态系统提示 / Skills / 自更新指令）

## 六、开放问题与已知陷阱

### 6.1 多 Agent 部署导致 IM 额度爆掉

[[玩转OpenClaw-核心架构-运作原理-Agent部署步骤]] 揭示：网关有定时健康探测（`refreshGatewayHealthSnapshot`），单 Agent 时不显眼，但 10 个 Agent 时 IM 调用额度可能瞬间耗尽。原文给出代码片段印证。**待补**：是否有"探测合并""探测降频"配置？官方文档需查。

### 6.2 自进化机制的回滚 / 审计边界

[[OpenClaw]] 的自进化（动态系统提示、Skills 扩展、自我更新指令）在工程上很激进。开放问题：
- 自我修改后如果出错，如何回滚？
- 多人协作时如何审计 Agent 的"成长史"？
- 是否有 git 化的 Workspace 版本控制？

目前的 9 个来源都未深入此话题。

### 6.3 长尾记忆的时间衰减可能偏激进

[[OpenClaw-双源记忆系统]] 默认半衰期 30 天（30 天后权重降到 50%）。对于"早期定调的核心偏好"，30 天衰减可能过快。建议高重要度记忆显式写到 `MEMORY.md`（不参与时间衰减），或自定义半衰期。

### 6.4 System Prompt 模块 18 在原文目录中缺失

[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] 列举了 1-17 + 19-23，**唯独跳过 18**。可能是作者整理时漏掉，也可能是内部保留/废弃模块。后续若有续作可对照。

### 6.5 OpenClaw 与 ClawHub / QClaw / ClawBot 的关系尚未在中文圈系统说清

[[OpenClaw橙皮书-从入门到精通]] v1.4 提到"微信 ClawBot 完整介绍、腾讯龙虾全家桶梳理，QClaw 全量公测"——这个"全家桶"的层级关系（哪些是官方、哪些是第三方）值得一篇专题。

## 七、阅读路径建议（按读者类型）

### 7.1 入门读者（仅想知道 OpenClaw 是什么）

1. [[以OpenClaw为例介绍AI-Agent的运作原理]] —— "龙虾的工具/技能/记忆"拟人化讲解
2. [[龙虾大脑核心揭秘1-OpenClaw处理流程链路解析]] —— 四层架构 + 十大步骤白板讲解
3. [[OpenClaw橙皮书-从入门到精通]] → 跳到微信读书读全书

### 7.2 部署实战读者（想自己装一个）

1. [[玩转OpenClaw-核心架构-运作原理-Agent部署步骤]] —— Mac Mini 配置选择、IM 工具选型、Skills CLI
2. [[深入理解OpenClaw技术架构与实现原理-上]] §3.1.7 / §3.1.10 —— Linux systemd 安装 + Gateway CLI
3. [[OpenClaw-SandBox]] —— 安全配置默认值与放宽方式

### 7.3 源码深度读者（想理解每个模块怎么实现）

1. [[深入理解OpenClaw技术架构与实现原理-上]] / [[深入理解OpenClaw技术架构与实现原理-下]] —— 16 模块全景
2. [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] —— System Prompt 23 模块
3. [[OpenClaw-Agent与Skill架构详解]] —— Agent 引擎 + Skill 加载链
4. [[从架构到代码-深入理解OpenClaw的双源记忆系统]] —— 记忆系统专题（SQLite + 双索引）

## 八、本 digest 引用清单

**实体**：[[OpenClaw]] / [[OpenClaw-SandBox]] / [[OpenClaw-双源记忆系统]] / [[OpenClaw-Skills]]

**来源（按发布时间）**：
1. [[玩转OpenClaw-核心架构-运作原理-Agent部署步骤]]（2026-03-09 / 腾讯技术工程）
2. [[以OpenClaw为例介绍AI-Agent的运作原理]]（2026-03-17 / Java 一条人）
3. [[深入理解OpenClaw技术架构与实现原理-上]]（2026-03-19 / 阿里云开发者）
4. [[从架构到代码-深入理解OpenClaw的双源记忆系统]]（2026-03-19 / 腾讯云开发者）
5. [[龙虾大脑核心揭秘1-OpenClaw处理流程链路解析]]（2026-03-23 / 京东科技）
6. [[深入理解OpenClaw技术架构与实现原理-下]]（2026-03-26 / 阿里云开发者）
7. [[OpenClaw橙皮书-从入门到精通]]（2026-04-02 / 花叔，飞书 wiki）
8. [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]（2026-04-13 / 阿里云开发者）
9. [[OpenClaw-Agent与Skill架构详解]]（2026-04-15 / 京东技术）
