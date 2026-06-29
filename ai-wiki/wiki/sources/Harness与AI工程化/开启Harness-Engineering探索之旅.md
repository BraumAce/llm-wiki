---
title: "开启Harness Engineering探索之旅"
type: source
date: 2026-06-29
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/uhc7_-0Vm_cw9p17b9VyJA"
author: "腾讯技术工程"
published_at: "2026-06-29 17:36:00+08:00"
ingested_at: 2026-06-29
tags:
  - harness-engineering
  - ai-coding
  - specworker
  - ai-observability
  - knowledge-base
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Context-Engineering]]"
  - "[[Spec-Driven-Development]]"
  - "[[AI可观测性]]"
  - "[[Token成本控制]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# 开启Harness Engineering探索之旅

## 一句话概括

这篇是腾讯技术工程团队把 [[Harness-Engineering]] 落到真实 AI Coding 流水线的实践复盘：用“2 条轨道 + 1 个长期记忆”把需求、设计、实现、测试、部署、归档、线上运营和知识库串成可度量、可回放、可持续改进的工程系统。

## 实践内容

### 总体结构：2 条轨道 + 1 个长期记忆

| 组件 | 作用 |
|---|---|
| 轨道 1：研发端到端交付 | 从 P1 需求到 P6 归档，把 AI Coding 放进阶段化流程 |
| 轨道 2：线上运营 | 告警、trace、日志、数据库和缓存证据链驱动线上修复闭环 |
| 长期记忆：知识库 | 让 AI 复用业务、系统、线上质量和历史变更知识 |

它的目标不是“让 AI 多写代码”，而是“人提需求 -> AI 理解 -> AI 执行 -> 人确认”。文章开头的洞察很硬：AI 出码率提高后，整体交付没有同幅提升，说明瓶颈已经从生成代码转移到理解、对齐、验证、追踪和沉淀。

### 轨道 1：P0-P6 研发交付流水线

| 阶段 | 关键机制 | Harness 含义 |
|---|---|---|
| P0 brainstorming | 可选需求头脑风暴 | 把含混想法转成可进入需求阶段的输入 |
| P1 requirements | TAPD 拉取、AC 可测、requirements / test-cases 同源 | 需求口径和测试口径必须来自同一组验收条件 |
| P2 design | `design.md` 契约、`sandbox_mode`、D-x 改动点、澄清 STOP | 设计文档不是说明书，而是 P3 和 reviewer 的机器可读合同 |
| P3 implementation | D2C、UI 95% 五轮校准、code-reviewer 三档 | 实现必须逐项对照设计契约和视觉标准 |
| P4 e2e-test | 前端自动化、后端 API 测试、自愈 debugger | 测试失败要能自动追 trace、拉日志、查 MySQL / Redis |
| P5 deploy | 评分 >= 95、部署产物落盘、SQL 显式确认 | 上线前最后一道质量闸，灰度和回滚由 SRE 拍板 |
| P6 archive | changes-sync、knowledge-sync、specs-generator | 代码、文档和知识库必须对齐后才算闭环 |

### 协议层：每一步都要有机器可读契约

- P1 的 `requirements.md` 和 `test-cases.md` 共用同一份 AC，避免测试阶段重新“理解需求”。
- P2 的 `design.md` 用接口签名、数据模型、必填字段、Mermaid 图和 D-x 改动列表承接实现。
- P3 的 code-reviewer 按 Critical / Important / Suggestion 分级，并优先读 `git diff` 和关键片段。
- P4 的 API debugger 不是猜 bug，而是按 `trace-id -> CLS -> MySQL -> Redis` 拉证据。
- P6 的 delta spec 用 ADDED / MODIFIED / REMOVED / RENAMED 做增量知识合并。

这套协议层把“我以为说清楚了”变成可检查的文件，把“AI 有没有偷懒”变成可机读的证据。

### 纪律层：五道防线对应五类偷懒模式

| AI 偷懒模式 | 对应纪律 |
|---|---|
| 写代码跳过测试 | TDD / test-cases 强制前置 |
| 遇到 bug 靠猜 | Debug 纪律要求先做根因分析 |
| 没验证就说完成 | Verify 纪律要求运行证据 |
| 实现偏离设计 | Review 纪律逐项对照 design.md |
| 自己给自己高分 | Evaluate 纪律用 SubAgent 和评分卡 |

这解释了为什么 Harness 不是“给 AI 加一堆文档”，而是为每种高频失败模式安装对应闸门。

### 可观测性

文章提出三类可观测对象：

- **阶段流水账**：`.phase-metrics.jsonl` 记录 phase、action、duration、input/output tokens、response_count、行数变化、文件变化和估算成本。
- **阶段评估**：`evaluation.md` 记录评分项、失败点、整改轮次和是否达到 >= 95 的门槛。
- **Report API**：把 `event_type=post:phase:end` 的结构化 payload 上报，失败时本地 jsonl 仍可离线补传。

这让 Harness 的收益和风险都能被追踪：不仅知道有没有完成，还能知道用了多少 token、花了多久、重试几次、改了多少代码、每行代码大约花了多少 AI 成本。

### 知识库：长期记忆的运作逻辑

团队把知识库拆成两层：

1. **项目级 `specs/`**：长期稳定知识，按 `business/`、`frontend/`、`backend/`、`common/`、`changes/` 组织，并配 `archives/` 和 `issues/`。
2. **变更级 `knowledge-spec/`**：每个 change 独立保存 requirements、design、planning、test-cases、delta-spec 和 archive。

两层通过 `index.md` 互通。P1 可以从当前 change 跳到历史相似 specs，P6 则把本次反复用到的契约、坑和约定增量沉回 specs。文章明确反对全局 `**/*.md` 暴力扫描，主张“索引 -> 相关 spec -> 片段”的两级查找。

### 上下文与成本治理

- session-start hook 只注入索引和当前阶段所需入口，不塞满仓库。
- SubAgent 不是免费上下文隔离，读全文件会另起一份 token 账。
- code-reviewer、api-test-debugger、changes-sync 都统一优先读 `git diff` 和关键片段。
- token、阶段耗时、失败重试、成本和代码改动量集中进可观测体系。

这对 [[Context-Engineering]] 和 [[Token成本控制]] 都是很好的实践样本：上下文治理从“尽量压缩”推进到“每一步只送它该看见的那一片，并把账记下来”。

## 摘录

> 我们的目标，用一句话说就是：「AI 驱动研发全链路 · 人提需求 → AI 理解 → AI 执行 → 人确认」。从 P1 需求澄清 → P2 方案 → P3 实现 → P4 测试 → P5 部署 → P6 归档，前端 / 后端并行，覆盖 DEV / TEST / OPS 三段，及线上运营告警闭环。

> token 双层结算（父 Skill / SubAgent 独立计费）：我们最初把 code-reviewer 设计为"读全文件做契约 review"，看似合理。直到核对 token 消耗才发现：SubAgent 的上下文是独立计费的——它每读一遍全文件，主 Agent 端毫无感知，但成本照样产生。

## 涉及实体

- [[Harness-Engineering]] —— 本文提供了阶段化流水线、纪律层、协议层和知识库回写的完整工程样本。
- [[Context-Engineering]] —— 两级查找、session-start hook、SubAgent token 独立计费都属于上下文工程的生产约束。
- [[Spec-Driven-Development]] —— P1/P2/P6 的 requirements、design、test-cases、delta-spec 本质上是 SDD 在 Harness 中的落地。
- [[AI可观测性]] —— `.phase-metrics.jsonl`、`evaluation.md`、Report API 把 AI 交付过程变成可审计事件流。
- [[Token成本控制]] —— 阶段级 token / 成本记录和 SubAgent 读 diff 策略说明成本治理必须进入流程设计。

## 涉及主题

- [[Harness-Engineering-主题]]

## 我的评注

这篇比一般 Harness 文章更像一份生产系统设计稿。它真正有启发的地方不是 P1-P6 名字，而是把每个阶段的输入、输出、停止点、评分、证据和知识回写都文件化。换句话说，Harness 的核心不是“多写规则”，而是把研发链路上原本靠人脑记忆和团队默契维持的东西，变成 AI 一定看得见、系统一定查得到、下次一定能复用的协议。
