---
title: "Generator-Evaluator"
type: entity
date: 2026-06-15
also_known_as:
  - "生成器与评判器"
  - "生成者-评判者"
  - "maker-checker"
  - "Generator-Evaluator 模式"
tags:
  - ai-engineering
  - verification
  - multi-agent
  - evaluation
  - harness
sources:
  - "[[Loop-Engineering循环工程橙皮书]]"
  - "[[AI-Agent-Skill-测评方案及落地实践]]"
related_entities:
  - "[[Loop-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[Claude-Code]]"
  - "[[Anthropic]]"
  - "[[Prompt评估体系]]"
---

# Generator-Evaluator

## 一句话定义

Generator-Evaluator（生成器与评判器）是一种把"写东西的 agent"和"评判东西的 agent"在结构上彻底分开的验证模式——因为写代码的那个 agent 给自己的作业打分时太手软，必须由另一个 instructions 不同、有时连模型都不同的 agent 来专门挑刺，loop 才有一个真正"能说不"的环节。

## 摘要

这是 [[Loop-Engineering]] 里最难、也最不能省的一环。一个 loop 之所以值钱，是因为它能无人值守地跑很多轮；可如果每轮"这一版行不行"都由刚写完的 agent 自己拍板，它就每一轮都在给自己点头——跑得越久，攒下的自我表扬越多，离真实质量越远。[[Anthropic]] 工程师 Prithvi Rajasekaran 在官方博客里给出了稳定观察：让 agent 评价自己产出的东西，它往往会自信地夸一通，哪怕在人看来质量明显很一般。

关键洞察是**区别在结构，不在措辞**：你没法靠一句"请严格一点"让作者跳出自己的视角，但你可以换一个 agent，给它完全不同的指令，让它从零开始看这段代码——它没参与写，就没有那套自我说服。Rajasekaran 的原话："tuning a standalone evaluator to be skeptical turns out to be far more tractable than making a generator critical of its own work."

## 详情

### 起源与背景

这套思路借鉴自 GAN（生成对抗网络）：一个网络负责造，一个网络负责挑刺，两个对着干，造的那个越来越像真的。Rajasekaran 把它搬到 agent 上——"I designed a multi-agent structure with a generator and evaluator agent."。它同时也是 [[Harness-Engineering]] 里"能说不的检查"在零件层面的落地，对应 Addy Osmani 六零件框架中的 Sub-agents 那一格。Addy 的说法更不留情面："The model that wrote the code is way too nice grading its own homework. A second agent with different instructions and sometimes a different model catches the stuff the first one talked itself into."

它的底层不是 AI 发明：银行里转一笔大额，录入的人和复核的人必须是两个人，maker-checker 原则存在几十年了，原因一模一样——经手的人会信任自己的操作，复核才有意义。

### 核心机制 / 工作原理

让一个 loop 长出"说不"的能力，是四步：

1. **结构上分开生成和评判**：generator 写，evaluator 审，不共用同一个上下文。
2. **把评判器调成怀疑论者**：社区常见措辞是让评判器默认"这段代码是坏的，除非被证明能跑"（assume the code is broken until proven otherwise）。生成器已经够信任自己了，评判器再客气，loop 就等于自己跟自己点头。
3. **让评判器会动手验证，而不只是读**：Rajasekaran 在前端任务里给 evaluator 接上 Playwright MCP，自己打开页面、点按钮、截图、查 DOM，像真人 QA 一样去用——判断依据从"我觉得这段 JSX 没问题"变成"我点了登录按钮，页面跳转了，截图在这"。一个会动手的评判器看的是行为，不是意图。
4. **判定权交给一个没参与干活的 fresh 模型**：Addy 还顺手换了模型（sometimes a different model）——同一个模型哪怕换了指令，思维盲区往往还在原地。

### 评分器形态

在生产级 Agent/Skill 测评里，Generator-Evaluator 不一定只表现为另一个 Agent，也可以拆成三类评分器共同承担独立评判：

```
确定性评分器：负责所有能用代码判断的事，例如文件存在、JSON Schema、工具调用序列、Token 和耗时阈值
Rubric 评分器：负责开放式语义判断，例如推理是否合理、报告是否完整、建议质量是否接近基线
人工评分器：负责校准、诊断和高风险兜底，例如通过率 0%/100% 异常、红队测试、医疗/金融/安全场景复核
```

这个结构延续了 maker-checker 原则：被测 Agent 负责执行，评分器负责判定。尤其在 Skill 测评里，负向触发用例、工具调用顺序和异常容错都不能交给被测 Skill 自报，否则最容易出现"结果看起来对，过程已经跑偏"的假阳性。

### 落到产品：/goal 的停止条件

[[Claude-Code]] 的 `/goal` 命令把这个结构做成了产品原语：给 agent 一个条件，让它一直跑到满足为止。

```
/goal all tests in test/auth pass and the lint step is clean
```

官方文档：每跑完一轮，一个又小又快的 fresh 模型来检查条件成立没有，不成立就再跑一轮，而不是把控制权交还给你——"completion is decided by a fresh model rather than the one doing the work."。底层是一个基于 prompt 的 Stop hook，每轮拦一下，判定不通过就不放行。这正是 maker-checker：干活的 agent 是 maker，fresh model 是 checker。

### 应用 / 使用场景

- loop 的验证环节（[[Loop-Engineering]] 五动作里的"验证"）
- 长程自主任务的停止条件判定（Claude Code `/goal`；Codex 走 Automations + agents 配置实现同类能力）
- 前端任务的行为级验证（evaluator 接 Playwright MCP 实际操作页面）

### 局限与争议

- 多养一个 agent 意味着额外 token 成本，但实践下来"把独立评判者调挑剔"比"让生成器自我批判"性价比高得多。
- 别把 `/goal`（跑到条件满足）和 `/loop`（按时间间隔重跑）搞混——前者是验证/停止条件，后者是调度。
- 评判器的质量决定 loop 的下限：generator 的水平决定 loop 能产出什么，evaluator 的水平决定 loop 不会产出什么。

## 与其他实体的关系

- [[Loop-Engineering]] —— 本模式是 loop"验证"动作的落地结构，是循环里"能说不的东西"
- [[Harness-Engineering]] —— 对应 harness/loop 六零件中的 Sub-agents 验证层
- [[Claude-Code]] —— `/goal` 把 maker-checker 做成停止条件原语
- [[Anthropic]] —— 工程师 Prithvi Rajasekaran 在官方博客提出 generator-evaluator 多 agent 结构

## 参考来源

- [[Loop-Engineering循环工程橙皮书]] —— 花叔，§05 生成器与评判器
- [[AI-Agent-Skill-测评方案及落地实践]] —— 腾讯技术工程，三类评分器 + Trace + 基线的 Agent/Skill 测评框架
