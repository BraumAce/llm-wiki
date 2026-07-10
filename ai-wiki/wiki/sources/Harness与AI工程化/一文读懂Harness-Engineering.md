---
title: "一文读懂 Harness Engineering！"
type: source
date: 2026-07-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/VKiTUsqiVxHA70IyptVG6g"
author: "Yousa 博阳（腾讯云开发者）"
published_at: "2026-07-09"
ingested_at: 2026-07-10
tags:
  - harness-engineering
  - long-running-agents
  - context-reset
  - external-memory
  - verification
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Context-Engineering]]"
  - "[[Claude-Code]]"
  - "[[Agent-Skill]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 一文读懂 Harness Engineering！

## 一句话概括

腾讯云开发者从长程 Agent 失败模式解释 [[Harness-Engineering]] 的必要性：外部记忆只能解决“存不住”，结构化进度、强制唤醒、独立验证、Git 可回滚历史和 Context Reset 才能把模型的长任务执行约束成可恢复的管理制度。

## 实践内容

### 把外部记忆升级为可验证工作制度

```text
初始化 Agent：生成机器可读 JSON 功能清单
编码 Agent：不可删除功能或改描述；只能把任务标为 passing / failing
标记 passing 前：必须有实际测试通过的证据

每个新 Session 的唤醒：
1. pwd          # 确认工位
2. git log      # 确认已发生的改变
3. progress.txt # 确认下一项任务

错误恢复：Git 存档 → git revert 回到已知可运行状态
上下文失焦：Context Reset，用结构化交接文件启动新 Agent
```

### 失败模式与对应控制

```text
提前交卷       → JSON 任务清单 + 完成状态硬约束
环境盲区       → 实际运行与端到端验证
虚标完成       → 运动员和裁判分离、测试后才可标通过
失忆实习生     → Git + progress.txt 的外置交接
超长上下文失焦 → 清空并重启新上下文，而非只做历史压缩
```

## 摘录

> 文章把 Harness 比作让车真正可以上路的制动器、变速箱和仪表盘：模型是引擎，Prompt 是方向盘，但任务怎样拆、进度怎样记录、完成怎样判、错误怎样回滚才共同决定 Agent 是否可靠。它特别区分了 Context Engineering 与 Harness：前者解决信息往哪存、怎么取、怎么精简，后者还必须确保 Agent 会读、会按流程执行，并且有外部证据证明任务真的完成。

> 长程 Web 应用实验即使使用外化记忆，仍然出现四类失败：做少量功能便提前宣布完成、环境问题导致代码跑不起来却不自知、清单标 done 但端到端不可用、每次新 session 都重新摸索项目。对应的 Harness 不让编码 Agent 任意修改任务定义，而以结构化 JSON 作为进度物理锁，并要求成功状态必须由实际测试支持，减少“看起来差不多”的自我判断。

> 为避免新 Session 变成失忆实习生，文章要求启动时依次检查当前目录、Git 历史和进度文件；每次改动经 Git 存档，死胡同时回退到已知干净状态。更激进的 Context Reset 会清空旧上下文，交给新 Agent 一份结构化交接文件，而不是继续在被压缩过、仍可能失焦的长历史中挣扎。状态放在仓库与交接文件里，才让多轮运行具有可恢复性。

## 涉及实体

- [[Harness-Engineering]] —— 用结构化状态、验证和可恢复流程管理长程 Agent。
- [[Context-Engineering]] —— 管信息效率但不能单独保证执行纪律的相邻层。
- [[Claude-Code]] —— CLAUDE.md、scratchpad 与长程 Agent 实践的代表环境。
- [[Agent-Skill]] —— 可将唤醒、验证、交接等固定 SOP 封装为按需工作流。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

文章的关键提醒是“外置记忆不是自动可靠”：如果状态允许 Agent 随意改写、没有真正的运行验证，也没有能恢复到已知正确状态的 Git 证据，长程任务只会更快地积累错误。对于工程团队，结构化的交接与完成条件往往比继续扩充 prompt 更优先。
