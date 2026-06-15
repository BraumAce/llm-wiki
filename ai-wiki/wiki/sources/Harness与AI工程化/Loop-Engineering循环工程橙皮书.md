---
title: "别再问我什么是 Loop Engineering（循环工程橙皮书）"
type: source
date: 2026-06-15
source_type: pdf
source_url: "https://github.com/alchaincyf/loop-engineering-orange-book"
author: "花叔 (HuaShu / @AlchainHust)"
ingested_at: 2026-06-15
tags:
  - loop-engineering
  - orange-book
  - ai-engineering
  - agent-orchestration
related_entities:
  - "[[Loop-Engineering]]"
  - "[[Generator-Evaluator]]"
  - "[[Stripe-Minions]]"
  - "[[Addy-Osmani]]"
  - "[[Harness-Engineering]]"
  - "[[Claude-Code]]"
  - "[[MCP]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 别再问我什么是 Loop Engineering（循环工程橙皮书）

## 一句话概括

花叔"橙皮书系列"的第四本，把 2026 年 6 月那一周爆火的 **loop engineering（循环工程）** 一次说清楚：用 4 部分 9 章讲透"别再自己一句句指挥 agent，去设计一个替你指挥它的系统"——是 [[Harness-Engineering]] 橙皮书的"上一层楼"，独立成书。版本 v260615，MIT 许可，含中英双版 PDF。

## 实践内容

**四层栈（每层管一件更大的事）：**

| 层 | 管什么 | 核心问题 |
|----|--------|----------|
| Prompt engineering | 写好一次的提示词 | 我该告诉模型什么 |
| Context engineering | 这一刻窗口里放什么 | 检索/摘要/清掉什么 |
| Harness engineering | 单次运行的武装 | 给哪些工具、什么算完成 |
| Loop engineering | 在 harness 之上调度 | 怎么让它自己一遍遍跑起来 |

**一个循环的五个动作：** 发现（discovery）→ 交付（handoff）→ 验证（verification）→ 持久化（persistence）→ 调度（decide next）。少一个 loop 就转不起来或只是空转。

**六个零件 ↔ 五动作对应表：**

| 零件 | 是什么 | 对应动作 | 一句话原话 |
|------|--------|----------|-----------|
| Automations | 挂时间表/触发器自动跑 | 调度 | make a loop an actual loop |
| Worktrees | 隔离并行 agent 工作目录 | 交付 | same headache as two engineers |
| Skills | 固化项目知识、还意图债 | 发现 | fire $skill-name, not a wall of instructions |
| Connectors | MCP 接外部系统 | 持久化/发现 | only see the filesystem is a tiny loop |
| Sub-agents | 生成者与评判者分离 | 验证 | too nice grading its own homework |
| Memory | 磁盘上的持久状态 | 持久化 | the agent forgets, the repo doesn't |

**Claude Code 的 loop 原语（带版本与示例）：**

```
# /loop —— 按时间间隔重跑（v2.1.72 后可用；时间单位 s/m/h/d，cron 最小 1 分钟）
/loop 5m check the deploy        # 固定 5 分钟一次
/loop check the deploy           # Claude 自己决定节奏（1 分钟～1 小时）
/loop                            # 裸跑：执行内置维护任务或 .claude/loop.md 里的内容
# 关掉所有 cron：环境变量 CLAUDE_CODE_DISABLE_CRON=1
# recurring 任务 7 天后过期（不是某些教程说的 3 天）；session-scoped；机器关了就停

# /goal —— 跑到条件满足为止（v2.1.139 后可用），完成由 fresh 小模型判定，非干活的 agent
/goal all tests in test/auth pass and the lint step is clean

# 并行隔离：给每个后台 agent 开独立 git worktree
--worktree   # 或 -w
```

**调度三种形态对比（睡觉时跑靠什么）：**

| | Cloud Routines | Desktop 定时任务 | /loop |
|---|---|---|---|
| 跑在哪 | Anthropic 云 | 你的机器 | 你的机器 |
| 需要开机吗 | 否 | 是 | 是 |
| 需要开着会话吗 | 否 | 否 | 是 |
| 最小间隔 | 1 小时 | 1 分钟 | 1 分钟 |
| 能看本地文件吗 | 否（fresh clone） | 能 | 能 |

关机/睡觉也要跑 → Cloud Routines 或 GitHub Actions 的 schedule 触发；要频繁、要看本地文件 → 本地 /loop。

**Claude Code vs Codex 能力对照（2026-06）：** 定时调度 `/loop` ↔ Automations 标签页；跑到条件满足 `/goal` ↔ 靠 automation 重跑+判断；并行隔离 `--worktree` ↔ 专用 background worktree（结果进 Triage 收件箱）；子 agent `.claude/agents/` ↔ `.codex/agents/` TOML；外部连接 MCP+Plugins ↔ MCP connector；显式调技能 Skills(SKILL.md) ↔ `$skill-name`；关机也跑 Cloud Routines ↔ 云端 Codex Jobs（规划中）。**注意：`/loop`、`/goal` 是 Claude Code 的命令，不是 Codex 的。**

**第一个 loop 检查清单（6 条）：** ① 发现源（定时去读 CI/issue/commit/收件箱）② 状态文件（跨轮记忆落在哪个磁盘文件）③ evaluator（有没有独立的、会说"不"的检查）④ 隔离（并行 agent 各自一个 worktree）⑤ token 上限（设没设花费天花板）⑥ 人工复核点（哪一步停下来等你看一眼）。前两条决定能不能跑，后四条决定跑起来会不会闯祸。

## 摘录

> 命名这个词、把它写成文章的人，是 Addy Osmani，Google Chrome 团队的工程师。原文：Loop engineering is replacing yourself as the person who prompts the agent. You design the system that does it instead. 翻成中文：循环工程，就是把"那个负责 prompt agent 的人"从你自己换成一套系统。你不再亲自一句句喂，而是设计那套替你喂的系统。这句话的重心，在"替换你自己"——不是把提示词写得更好，也不是把上下文管得更精，是把你这个人从那个位置上挪走。

> 一个 loop 最难的地方，不是让 agent 跑起来，而是放一个能说"不行"的东西进去。可写代码的那个 agent，恰恰是最不会说"不行"的。Anthropic 的工程师 Prithvi Rajasekaran 在官方博客里观察到：when asked to evaluate work they've produced, agents tend to respond by confidently praising the work—even when, to a human observer, the quality is obviously mediocre。调一个独立的评判器让它变得怀疑，比让生成器自我批判要容易得多——区别在结构，不在措辞。

> 循环替你干活，听着全是好处，但它也在悄悄替你欠债。四笔账：验证债（产出堆着没人验，错误安静积累）、理解腐烂（loop 交付你没写的代码越快，"实际存在"和"你真正理解"的差距越大）、认知投降（循环跑顺了人就懒得有意见，执行可外包、拿主意不行）、token 失控（用量剧烈波动，取决于你是 token 富人还是穷人）。这四笔账有个共同点：它们都不会在循环跑的当下报警。

## 涉及实体

- [[Loop-Engineering]] —— 全书主题概念
- [[Addy-Osmani]] —— 命名者，全书框架的奠基一手来源
- [[Generator-Evaluator]] —— §05 专章，loop 里"能说不的东西"
- [[Stripe-Minions]] —— §06 企业级案例，每周 1300+ PR
- [[Harness-Engineering]] —— loop 的"下一层楼"，本书前传
- [[Claude-Code]] —— 提供 `/loop`、`/goal`、`--worktree` 等 loop 原语
- [[MCP]] —— 六零件里的 Connector 技术底座

## 涉及主题

- [[Harness-Engineering-主题]] —— Prompt→Context→Harness→Loop 的 AI 工程范式演进

## 我的评注

橙皮书把一手来源（Addy 奠基文、Anthropic harness 博客、Stripe Minions 播客、Claude Code/Codex 官方文档）整理得很克制，对"九成 Claude Code 由 AI 自写""Nubank 提效 12 倍"这类二手大数字明确标注"姑且当参照"。最值得带进知识库的不是炫目数字，而是那张"四层栈 + 五动作 + 六零件"的骨架，以及"loop 的下限是它的 evaluator"这条判断——它把 [[Harness-Engineering]] 里"能说不的检查"上升成了循环时代的核心矛盾。可进一步追：英文完整版（Complete Guide）相比中文橙皮书是否有额外章节或一手出处链接。
