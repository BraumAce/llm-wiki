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
