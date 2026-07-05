---
title: "给野马套上缰绳：Agent Harness 工程实践 ——从范式理论到钉钉AI招聘的真实落地"
type: source
date: 2026-07-01
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/0w_xMwto4sLx6J_85OhWQw"
author: "阿里云开发者"
ingested_at: 2026-07-01
tags:
  - harness-engineering
  - agent-os
  - subagent
  - enterprise-agent
related_entities:
  - "[[Harness-Engineering]]"
  - "[[Agent-Skill]]"
  - "[[Claude-Code]]"
  - "[[Generator-Evaluator]]"
  - "[[AI可观测性]]"
  - "[[MCP]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
  - "[[AI-Skill体系-主题]]"
---

# 给野马套上缰绳：Agent Harness 工程实践 ——从范式理论到钉钉AI招聘的真实落地

## 一句话概括

这篇文章把 Harness Engineering 解释为“Agent = Model + Harness”的工程范式，并用钉钉悟空 AI 招聘系统说明为什么 2 Agent + N Skill + Workspace + Linter 护栏比全能 Agent 更可靠。

## 实践内容

核心公式：

```text
Agent = Model + Harness
```

四条反直觉铁律：

```text
信息越多决策越准 -> 上下文越少越好，稀缺资源要精挑
一个超级 Agent 全包 -> 专才 Agent 永远赢过通才 Agent
让 Agent "记住"任务进展 -> 状态要写文件，不要塞上下文
把规则写进 AGENTS.md 读给它 -> 能写成 Linter 的约束，别停留在文档
```

双阶段架构：

```text
InitializerAgent：理解任务 → 制定计划 → 写入 plan.md → 退出
↓
Executor Agent ：读取 plan.md → 按步执行 → 跨 Context Window 接力
```

上下游反压模式：

```text
上游：给确定性设置 + 一致上下文
│
▼
Agent 执行
│
▼
下游：测试 / 类型检查 / Lint / CI 拒绝无效工作
│
▼
错误信号回传 → 上游调整
```

全能招聘 Agent 反例：

```python
# 第一版：全能招聘 Agent
recruit_agent = Agent(
system_prompt="""
你是一个全能招聘助手，你会：
- 从 xxx 系统抓取简历
- OSS解析 PDF / Word 简历，提取教育背景、工作经历、技能
- 做人岗匹配评分（JD vs 简历）
- 在xx里和候选人聊天、要简历、约面试
- 调用日历查面试官闲忙、订会议室
- 给 HR 发提醒、生成日报
- 跟踪候选人状态、超时预警
- 触发 RPA 在招聘工作台做批量操作
- 给候选人发预约AI面试
...（Prompt 写了 600+ 行）
""",
tools=[
fetch_resume, parse_pdf, parse_docx, score_match,
send_dingtalk_msg, query_calendar, book_room,
create_todo, send_email, trigger_rpa,
upload_file, download_file, query_db,
...# 一共 13 个工具
]
)
```

2 Agent + N Skill 架构：

```text
┌────────────────────────────────────────┐
│ 悟空（DingTalk 企业级 Agent） │
│ ───── Orchestrator / 上下文调度 ──── │
│ · 拆任务 · 分发 · 维护 Workspace │
│ · 跨会话记忆（候选人状态写文件） │
└────┬─────────────────────────────┬─────┘
│ │
┌──────────────▼──────────────┐ ┌────────────▼─────────────┐
│ 人岗匹配 Agent（RPA 专才） │ │ 招聘沟通 Agent（聊天专才）│
│ 职责：招聘工作台 RPA 操作、JD ↔ 简历语义匹配评分 │ │ 职责：监听候选人聊天、自动对话要简历、协商面试时间 │
│ Prompt: 80 行（聚焦） │ │ Prompt: 90 行（聚焦） │
│ Tools: 4 个 │ │ Tools: 5 个 │
└──────────────┬───────────────┘ └────────────┬─────────────┘
▼
┌─────────────────────────────────────────┐
│ N 个原子化 Skill │
│ parse_resume / score_match / query_calendar / book_room / send_dingtalk / extract_field / ... │
└──────────────────┬──────────────────────┘
▼
┌─────────────────────────────────────────┐
│ Workspace（真相之源） │
│ /candidates/{id}/state.json │
│ /candidates/{id}/chat_history.log │
│ /jobs/{id}/jd.md │
│ /rpa_lock/{batch_id}.json │
└─────────────────────────────────────────┘
```

RPA 事务文件：

```text
RPA 开始 → 写 workspace/rpa_lock/{batch_id}.json (state: running)
每完成一条 → 追加进度
RPA 结束 → 标记 state:done

任何中断 → 下次启动时读 lock 文件，从断点续传，绝不重头跑
```

外发消息三层硬护栏：

```text
第 1 层：白名单工具，只能调 send_dingtalk_text / send_dingtalk_template，禁用撤回 / 群发
第 2 层：Linter 拦截，所有外发消息先过敏感词 / 合规规则 Linter
第 3 层：第二个 Agent 审稿，Reviewer 用独立 Context 判断是否冒犯候选人 / 暴露薪资 / 暗示录用
```

## 摘录

> 这个公式后来被 LangChain 官方在《Improving Deep Agents with Harness Engineering》一文中作为标题级别的论断：模型负责推理，Harness 负责"剩下的所有事情"——工具系统、上下文管理、权限控制、反馈回路、记忆与协作。这个公式的颠覆性在于它彻底改变了优化方向。过去几年大量精力放在"换更强的模型"上，但真正的杠杆位置一直在模型之外。

> 成熟的 Agent 系统遵循一个简单原则：Workspace 是真相，Context Window 只是当前工位。任务中间结果、Agent 间协作、跨会话延续、审计回放，全部走文件系统。启示：把 Workspace 当成"Agent 的 Git 仓库"——每一步操作都可回放、可审计、可断点续传。

## 涉及实体

- [[Harness-Engineering]] —— 文章的主线，提出四条铁律、六大工程模式和 Agent OS 判断。
- [[Agent-Skill]] —— 悟空招聘案例把大量能力下沉为原子化 Skill，避免新增过多 Agent。
- [[Claude-Code]] —— 文章把 Claude Code 视为把 Harness 当产品而非附属的标杆。
- [[Generator-Evaluator]] —— “智能体审智能体”要求 Reviewer 换 Context 审查 Main Agent 产出。
- [[AI可观测性]] —— 失败日志、Linter、CI、workspace 文件和审计回放都是可观测性基础。
- [[MCP]] —— 文章把 MCP 视为 Agent 与外部世界接口标准化的一部分。

## 涉及主题

- [[Harness-Engineering-主题]]
- [[AI-Skill体系-主题]]

## 我的评注

这篇最有价值的是把 Harness 从抽象概念落到“全能 Agent 为什么失败”的结构性原因：工具选择空间太大、上下文混杂、状态放在易失窗口、错误不可复现。悟空招聘案例给出一个非常实用的判断：Agent 数量本身也是上下文成本，能沉成 Skill 的能力不要拆成新 Agent；凡是对外说话或动用户数据的地方，先上硬护栏。
