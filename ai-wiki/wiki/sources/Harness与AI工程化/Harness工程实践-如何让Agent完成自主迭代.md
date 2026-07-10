---
title: "Harness 工程实践：如何让 Agent 完成自主迭代"
type: source
date: 2026-07-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/c8BymWxcopweHr11u7zY-Q"
author: "肖汉松（阿里技术）"
published_at: "2026-07-08"
ingested_at: 2026-07-10
tags:
  - harness-engineering
  - agent-evaluation
  - champion-challenger
  - reward-hacking
  - subagent
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Agent-Skill]]"
  - "[[Generator-Evaluator]]"
  - "[[Loop-Engineering]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
  - "[[Agent评测方法论]]"
---

# Harness 工程实践：如何让 Agent 完成自主迭代

## 一句话概括

阿里技术将业务 Agent 的 prompt 优化做成 [[Harness-Engineering]] 自主迭代：把部署、评测和结果分析工具化，父子 Agent 协同运行 17 小时完成 16 轮实验，并通过训练/验证集隔离与 champion-challenger 机制抑制 reward hacking 和策略退化。

## 实践内容

### 一轮自主优化的执行约束

```text
固定环境、用户、代码库与分支；部署/评测/结果分析均由工具或 Skill 提供。

长程执行规则：
- 不向用户提问，需自行判断并持续执行
- 禁止早停
- 同一异常反复出现时先分析，禁止机械重试
- 一次只专注一个目标

父 Agent：部署、白名单、评测、轮次控制、commit & continue
子 Agent：加载结果分析 Skill，比对当前轮和 champion，给出策略建议
```

### 防过拟合的评测与晋级协议

```text
训练集：可见问题、答案、扣分原因和得分
验证集：仅可见得分

champion：未过拟合的历史最佳策略
challenger：当前轮改动
替换条件：验证集上全面超过 champion，且检查
  - 总分与各指标变化
  - case + 指标粒度的升降原因
  - 训练/验证一致性与 badcase 模式
  - 小样本噪声、异常过滤比例（>35% 需警惕）
```

## 摘录

> 在业务 Agent 优化场景中，人工评测需要两三个小时，badcase 的进入速度又远快于人工修复。文章将 Harness 的分工概括为“人定义问题和验收，Agent 提方案、开发、测试、发布”，让原本由人点击串联的部署、评测、结果分析与实验环节成为 Agent 可调用能力。最终系统连续运行 17 小时、完成 16 轮迭代，并将通过人工复核的一轮改进上线。

> 长程任务的风险不只在上下文耗尽，也在早停和空转。文章明确要求模型不要向用户请示、持续执行直到任务完成、遇到重复异常先分析而不是轮询重试、一次只处理一项工作。复杂结果分析被委托给专门子 Agent，父 Agent 只传递必要的轮次和冠军信息；这一隔离既避免主会话失焦，也确保分析器使用正确的角色视角和专用 Skill。

> 若让模型不断根据 badcase 改 prompt，它会把单一 case 的扣分理由硬编码成规则，形成 reward hacking。解决办法是训练集与验证集隔离：验证集不暴露题目和原因；每轮 challenger 从 champion 出发，只有在验证集多维度确实胜出才能晋级。这个机制让策略回滚、比较与泛化判断都有基准，避免系统沿着偶然得分或错误方向一路走到底。

## 涉及实体

- [[Harness-Engineering]] —— 将部署、评测、发布与验收改造成 Agent 运行环境的一部分。
- [[Agent-Skill]] —— 为部署、评测、结果分析等不同环节封装可调用能力。
- [[Generator-Evaluator]] —— 训练/验证隔离与独立分析避免生成策略自证有效。
- [[Loop-Engineering]] —— champion-challenger 为跨轮优化保存状态并决定下一轮。

## 涉及主题

- [[Harness-Engineering-主题]]
- [[Agent评测方法论]]

## 我的评注

这是一篇把“Agent 自进化”落到实验设计的案例：长时间运行本身不构成自主迭代，真正的控制点是评测信息隔离、每次策略变化的可比基线，以及能够拒绝微小噪声改进的晋级规则。
