---
title: "Loop Engineering"
type: entity
date: 2026-06-15
also_known_as:
  - "循环工程"
  - "Loop 工程"
tags:
  - ai-engineering
  - methodology
  - agent-orchestration
  - automation
  - harness
sources:
  - "[[Loop-Engineering循环工程橙皮书]]"
  - "[[Loop Engineering 概念解析、思考与实践]]"
  - "[[Loop-Engineering实践指南-在CodeBuddy中构建自主循环系统]]"
  - "[[重磅！Loop Engineering 实操手册公开]]"
  - "[[一文搞懂！Loop Engineering的进化史和本质]]"
  - "[[最新-万字综述-Prompt-到-Loop-进化]]"
  - "[[Loop-Engineering实战-实现从日志扫描到预发部署的全自主闭环]]"
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Context-Engineering]]"
  - "[[Generator-Evaluator]]"
  - "[[Stripe-Minions]]"
  - "[[Addy-Osmani]]"
  - "[[Claude-Code]]"
  - "[[ReAct]]"
  - "[[CodeBuddy]]"
---

# Loop Engineering

## 一句话定义

Loop Engineering（循环工程）是把"那个负责 prompt agent 的人"从你自己换成一套系统——你不再亲自一句句喂指令，而是设计一个会自动发现任务、交给 agent、验证产出、记下状态、再决定下一步的自运转循环，自己退到循环外面当它的工程师。

## 摘要

循环工程标记的是一次**身份转移**：从"操作 agent 的人"变成"调度 agent 的人"。提出者 [[Addy-Osmani]] 给的原话是 "Loop engineering is replacing yourself as the person who prompts the agent. You design the system that does it instead."。它和过去两年的 Prompt / Context / [[Harness-Engineering]] 不是互相替代，而是叠在一起的第四层——Addy 的说法是"循环工程坐在 harness 的上一层楼"（sits one floor above the harness）。下面那层 harness 武装 agent 的单次运行，上面这层 loop 负责让它一遍遍自己跑起来。

这个词在 2026 年 6 月那一周由三个人几乎同时点燃：[[OpenClaw]] 作者 Peter Steinberger 的一条推（"You should be designing loops that prompt your agents"）冲到 800 多万浏览，[[Anthropic]] 的 Claude Code 负责人 Boris Cherny 同声（"My job is to write loops"），而真正命名并写成文章的是 Google Chrome 工程师 Addy Osmani（6 月 7 日博客，次日同步 Substack）。循环工程真正的难点从来不是把循环搭起来，而是往循环里放一个**能说"不"的东西**——这是后面所有讨论的核心。

## 详情

### 起源与背景

"XX Engineering"过去一年冒出一串，造词速度赶上模型迭代。循环工程的不同在于：前面几个词都假设你坐在键盘前一句句指挥 agent，而循环工程把这个假设删掉了——你不再在循环里，你在循环外面负责造那个循环。旧世界你是循环里的"人肉时钟"，每一拍都得你来敲；新世界你设计一套东西，让它在定时器上跑、自己孵化小帮手、自己把结果喂回给自己。

### 四层栈：从 Prompt 到 Loop

循环工程的位置由一张"四层栈"界定，每层管一件更大的事：

| 层 | 管什么 | 核心问题 |
|----|--------|----------|
| Prompt engineering | 写好一次的提示词 | 我该告诉模型什么 |
| [[Context-Engineering]] | 这一刻窗口里放什么 | 检索/摘要/清掉什么 |
| [[Harness-Engineering]] | 单次运行的武装 | 给哪些工具、什么算完成 |
| **Loop engineering** | 在 harness 之上调度 | 怎么让它自己一遍遍跑起来 |

层次越高，你离现场越远，犯的错攒得越久——这是为什么每一层的"能说不的检查"必须装在不同地方。

### 核心机制：一个循环的五个动作

把一个 loop 转一圈拆开，里面只有五个动作，少一个就转不起来或只是空转：

1. **发现（discovery）**：让 agent 自己去找活，而不是你把活喂给它。Addy 强调发现逻辑应固化成 skill（`fire $skill-name`），而不是往没人会更新的定时任务里贴一大墙指令。
2. **交付（handoff）**：把任务从调度系统交到干活的 agent 手里，每个发现单独开一个隔离的 git worktree，切成干净的小任务再分头交出去。
3. **验证（verification）**：换一个 instructions 不同、有时连模型都不同的 agent 来挑刺。这是最容易偷工减料、也最不能省的一步（见 [[Generator-Evaluator]]）。
4. **持久化（persistence）**：把状态写到对话之外的磁盘上——PR、工单、markdown 状态文件。"agent 会忘，仓库不会。"
5. **调度（decide next / scheduling）**："Automations are what make a loop an actual loop and not just one run you did once." 没有调度，前四步做得再漂亮也只是一次性手工活。

### Loop Contract：让循环有边界

Datawhale 的后续综述把 Loop Engineering 的安全边界总结成一份 **Loop Contract**：循环启动前必须明确 `TRIGGER`（触发条件）、`SCOPE`（影响范围）、`ACTION`（允许动作）、`BUDGET`（token/时长/重试/并发预算）、`STOP`（停止条件）和 `REPORT`（向人类汇报的证据）。这组字段把“让 agent 自己跑”从愿景变成可审查的运行协议。

真正生产化的 loop 还需要两道硬保护：**Circuit Breaker** 在连续失败、超时或风险动作异常时熔断并转人工；**Watchdog** 独立监控自旋、CPU 满载、长时间无 I/O 等死循环迹象，必要时强制杀进程和回收资源。没有这些边界的 loop，本质上只是无人看管的自动返工器。

### Agent Loop 与 Loop Engineering 的边界

阿里技术的中文实践文进一步明确了一个容易混淆的边界：Agent Loop 是底层执行循环，负责把模型输出的 function call、工具执行结果和下一轮输入串起来；Loop Engineering 是 Harness 之上的外部闭环，负责把需求、执行、验证、反馈、调优和能力沉淀自动化。前者是 Agent 能跑起来的基础设施，后者是把"人机反复催改"重构成"自动化验收闭环"。

这个边界带来一个实践判断：固定流程、无需模型每天重新推理时，应沉淀为脚本；确实需要模型动态判断时，才做成 Skill 或定时 Loop；需求和验证标准仍然模糊时，Human-in-the-Loop 反而更稳、更省成本。

### 六个零件：搭一个 Loop 需要什么

动作描述"转一圈发生了什么"，零件描述"你手里得攥着哪些东西"，两者一一对应：

| 零件 | 是什么 | 对应动作 |
|------|--------|----------|
| Automations | 挂在时间表/触发器上自动跑 | 调度 |
| Worktrees | git worktree 隔离并行 agent | 交付 |
| Skills | SKILL.md 固化项目知识、还"意图债" | 发现 |
| Connectors | [[MCP]] 接外部系统（issue tracker/数据库/Slack） | 持久化/发现 |
| Sub-agents | 生成者与评判者分离 | 验证 |
| Memory | 磁盘上的持久状态（非上下文） | 持久化 |

Connector 决定 loop 的"视野半径"——"A loop that can only see the filesystem is a tiny loop."

### 动手前的五个门槛

不是每个任务都值得做成 loop。Datawhale 转述的实操清单把门槛讲得很明确：任务必须**重复出现**，必须有**自动化验收器**（测试 / 类型检查 / linter / 构建），token 预算要能扛住探索和重试的浪费，agent 要能运行并观察自己的产出，而最容易被忽略的一条是——**人仍然要愿意 review 结果**。如果不 review，就不该建 loop。

这组门槛把 loop 从“看起来很酷的自动化”收回到成本核算问题：一次性的活、没有硬闸门的活、瓶颈在 review 而不在执行速度的活，往往更适合用 prompt、skill 或脚本，而不是直接套一层持续自转的 loop。

### ReAct 与 Loop Engineering：Inner Loop / Outer Loop

腾讯技术工程的实践文给了一个比"四层栈"更直观的边界：[[ReAct]] 是 Loop Engineering 的 **Inner Loop**，Loop Engineering 是套在外面的 **Outer Loop**。

```
Loop Engineering（Outer Loop）
  目标拆解 → 任务分配 → 结果汇总 → 再计划
  ┌──────────────────────────────────────┐
  │ ReAct（Inner Loop）                  │
  │ 思考 → 行动 → 观察 → 思考 → 行动 ... │
  └──────────────────────────────────────┘
```

- ReAct 解决"单次任务内怎么一步步做"，Loop Engineering 解决"跨任务做什么、谁来做、何时停、怎么续"。
- 关键差异落在四件事上：状态（窗口内记忆 vs 外置到文件/库、每轮全新上下文）、停止条件（模型自判 vs 独立评估器验证可度量条件）、验证（自我检查 vs 对抗验证）、恢复（同上下文重试 vs 断点续跑跨会话恢复）。
- 演进链：`Prompt（怎么问）→ ReAct（怎么做）→ Loop Engineering（怎么管）`。两者不是替代而是叠加——每一轮内部仍跑 ReAct，外层评估器在 Outer Loop 判断整体进度。

### CodeBuddy 的落地映射

腾讯 [[CodeBuddy]] 把六要素翻译成了具体命令面，是目前少见的"理念→工具命令"完整落地：

| Loop Engineering 要素 | CodeBuddy 实现 |
|------|------|
| 自动化（心跳） | `/goal`（条件驱动）、`/loop`（时间驱动）、Automations（跨会话 cron） |
| 工作树 | Git worktree + Team 模式 |
| 技能 | Skills（SKILL.md） |
| 连接器 | [[MCP]] 协议 |
| 子智能体 | Task 工具 + Team 模式（planner/coder/reviewer） |
| 状态文件 | Memory、CODEBUDDY.md、Rules |

其中 `/goal` 最贴近 Loop Engineering 本义：设一个可验证条件（含可度量终态 / 可证明方式 / 不可破坏约束 / `or stop after N turns` 兜底），每轮由**独立小模型评估器**（如 gemini-2.5-flash，只看 transcript 不调工具）三态判定 `ok:true` / `ok:false` / `impossible:true`。评估器与执行 Agent 用不同模型，天然构成 [[Generator-Evaluator]] 式对抗验证。

### 控制论视角：传感器决定收敛速度

另一篇 Datawhale 文章把 Loop Engineering 解释成一个控制论闭环：控制器负责读偏差并决定下一步，执行器把动作落到真实世界，传感器测量结果并把误差信号送回去。映射到 agent 系统里，Skills + State 更像控制器的“知识与记忆”，文件编辑 / shell / MCP 是执行器，而测试、断言、审阅 agent 和规则系统则是传感器。

这个视角把一个常见误解纠正得很彻底：决定 loop 是否收敛的，往往不是生成模型有多强，而是传感器有多好。只返回 `pass/fail` 的验证器会让控制器近乎盲修；能指出“哪个用例挂了、哪个断言失败了、哪个 diff 引入了问题”的验证器，才能真正压缩搜索空间。这也是为什么 **strong verification 比 strong prompt 更关键**。

### 生产维护 Loop：可观测、可停止、可交接

日志扫描到预发的实践把 Loop 的六个零件映射到一条很具体的维护链：Connectors 从多日志库获取事件，Automations 负责定时发现，诊断和修复 Skills 在隔离工作树内产出补丁，独立 Sub Agent 负责验证，最终把修复证据和结果写回状态系统。它将“循环已经完成”的判定拆成测试、集成测试、Trace 验证和独立复查，避免修复 Agent 既写补丁又宣布补丁正确。

这类生产 Loop 还补足了概念文常被略过的**停止协议**：验证失败可以根据失败证据回到修复，但最多三轮；超过上限转人工 Owner。循环开始前先检查任务是否重复、能否自动验收、token 预算是否承受、工具是否齐全。换言之，Loop 的成熟度不由能运行多久衡量，而由它是否能在证据不足、代价过高时果断停下衡量。

### 应用 / 使用场景

- **个人早间分诊**：Addy 的 triage loop，每天早上 automation 自动读 CI 失败 / open issue / 最近 commit，开 worktree，子 agent 起草+审查，过了自动开 PR，没把握的进收件箱。
- **企业级规模**：[[Stripe-Minions]] 每周合并 1300+ PR，没有一行人手写；靠确定性 orchestrator 在 LLM 醒来前备齐上下文。
- **落地原语**：[[Claude-Code]] 的 `/goal`（跑到条件满足为止，由 fresh 模型判定完成）、`/loop`（按 cron 间隔重跑）；Codex 对应 Automations 标签页。关机也跑要靠 Cloud Routines 或 GitHub Actions schedule。

### 局限与争议（四笔代价）

一个无人看管的 loop，也是一个无人看管地在犯错的 loop。书中点了四笔不会自己消失的账：

- **验证债**：产出堆着没人验，错误安静积累——防它靠一个独立评判者。
- **理解腐烂**：loop 交付你没写的代码越快，"实际存在"和"你真正理解"的差距越大；它平时不报警，只在你最需要理解时让你发现理解没了。
- **认知投降**：循环跑顺了人就懒得有意见，"执行可外包，拿主意不行"。
- **token 失控**：用量剧烈波动，取决于你是 token 富人还是穷人；上线前要钉死单次/每日预算和重试上限。
- **错误收敛**：最危险的不是 loop 一直跑不完，而是验证器太弱，导致它带着“已经通过”的错觉停下来。

书的结论是一句态度："Build the loop. But build it like someone who intends to stay the engineer, not just the person who presses go."——AI 生成不再稀缺，稀缺的是判断力。

## 与其他实体的关系

- [[Harness-Engineering]] —— loop 坐在 harness 的上一层楼；harness 武装单次运行，loop 让它自动重来
- [[Context-Engineering]] —— 四层栈中 loop 之下的第二层，管单个窗口里放什么
- [[Generator-Evaluator]] —— loop 五个动作里"验证"那一步的落地结构，是"能说不的东西"
- [[Stripe-Minions]] —— loop 推到企业规模的真实案例
- [[Addy-Osmani]] —— 命名并系统化循环工程的人
- [[Claude-Code]] —— 提供 `/loop`、`/goal`、worktree、subagent 等 loop 原语
- [[ReAct]] —— Loop Engineering 的 Inner Loop；外层编排内层的推理-行动循环
- [[CodeBuddy]] —— 腾讯工具侧的完整落地，把六要素翻成 `/goal`、`/loop`、Automations、Team 等命令

## 参考来源

- [[Loop-Engineering循环工程橙皮书]] —— 花叔，循环工程橙皮书第一版（v260615）
- [[Loop Engineering 概念解析、思考与实践]] —— 阿里技术，中文语境下区分 Agent Loop 与 Loop Engineering，并给出普通任务的实践边界
- [[Loop-Engineering实践指南-在CodeBuddy中构建自主循环系统]] —— 腾讯技术工程，落到 CodeBuddy 的命令面（`/goal`/`/loop`/Automations/Team），并厘清 ReAct 与 Loop Engineering 的 Inner/Outer Loop 边界
- [[重磅！Loop Engineering 实操手册公开]] —— Datawhale，总结 loop 的适用门槛、五个核心构件和 14 步最小落地路线
- [[一文搞懂！Loop Engineering的进化史和本质]] —— Datawhale，把 loop 放回 Prompt / Context / Harness / Loop 演进链，并用控制论解释为什么传感器决定收敛速度
- [[最新-万字综述-Prompt-到-Loop-进化]] —— Datawhale，补充 Loop Contract、Circuit Breaker、Watchdog 和开发者转向 Loop Designer 的系统架构视角
- [[Loop-Engineering实战-实现从日志扫描到预发部署的全自主闭环]] —— 阿里云开发者，3 个日志库、334 条测试、三轮重试上限与预发 Trace 验证的生产闭环
