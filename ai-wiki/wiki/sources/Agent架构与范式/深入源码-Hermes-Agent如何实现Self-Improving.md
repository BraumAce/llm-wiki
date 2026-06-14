---
title: "深入源码：Hermes Agent 如何实现 Self-Improving"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/Qi68ptxQRyiA932JU49SYQ"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags: [agent, self-improving, source-code-analysis, llm-agent, hermes-agent]
related_entities: Hermes Agent
related_topics:
  - Self-Improving Agent
  - Agent Architecture
---

# 深入源码：Hermes Agent 如何实现 Self-Improving

## 一句话概括
从源码层面解析 Hermes Agent 如何通过自我反思与经验积累实现 Agent 的自我改进能力。

## 实践内容

### 三个子系统构成一个闭环

Hermes Agent 的 Self-Improving 由三个子系统支撑：Memory（记忆）、Skill（技能）、Nudge Engine（推动引擎）。

### Memory 系统

两个纯文本文件用 § 分隔条目：
- `~/.hermes/memories/MEMORY.md` — Agent 的个人笔记（环境事实、项目约定、工具怪癖），限 2200 chars
- `~/.hermes/memories/USER.md` — Agent 对用户的认知（偏好、沟通风格、工作习惯），限 1375 chars

容量限制迫使 Agent 做信息压缩，过时的自然被挤掉。超限时 add 直接失败并返回所有条目，由模型自主决定哪些该删、哪些该合并。

**冻结快照机制**：每次会话启动时加载后立刻捕获快照，系统提示词使用快照内容。新写入只改磁盘，下一个会话才刷新，保护前缀缓存节省 API 计费。

**提示词引导**：Memory 要求写成声明式事实（"User prefers concise responses"），而非命令式指令（"Always respond concisely"）。工具 Schema 明确边界："If you've discovered a new way to do something, save it as a skill."

### Skill 系统

每个 Skill 是一个目录，核心是 SKILL.md 文件，包含 name、description、version、When to use、Steps、Pitfalls 等结构。Pitfalls 节不是预先写好的，而是 Agent 踩坑后追加的。

**创建触发**：工具调用超过 5 次才值得创建、踩过坑再修复的经验才有价值、用户纠正过的做法要铭记。

**自我修补**：Agent 按已有 Skill 执行但中途发现遗漏或新坑时，完成任务后做精确局部 patch（模糊匹配），修改后自动安全扫描，不通过则回滚。

**渐进式加载**：默认上下文只放轻量索引（名字+一句话描述），Agent 判断相关时才通过 skill_view 加载完整内容。

### Nudge Engine

运行时维护两个计数器定时触发审查：
- Memory 计数器：每 10 个用户回合触发一次（按回合计，信息来自用户输入）
- Skill 计数器：每 10 个迭代触发一次（按迭代计，经验来自工具使用）

触发后在后台 fork 独立 Agent 实例做审查，输出重定向到 /dev/null 用户无感知，最多 8 次工具调用，review agent 自身的 nudge 被禁用避免无限递归。

### 安全机制

**Memory 内容扫描**：检测 prompt injection、deception、system prompt override、凭证泄露等威胁模式。

**Skill 安全扫描**：自创和从 Hub 安装的 Skill 走同一套扫描，不通过就回滚。

### 效果数据

K8s 部署场景三次会话对比：
- 会话 1（冷启动）：12 次工具调用，2 个错误
- 会话 2（Skill 复用）：9 次工具调用，1 个错误，自动 patch Skill
- 会话 3（全协同）：6 次工具调用，0 个错误

## 摘录
> OpenClaw 的 Skill 是手写的 Markdown 文件——你写多少它会多少，你不写它就不会。Hermes 做了一件 OpenClaw 架构上做不了的事：Agent 干完活之后，会自动把踩坑经验提炼成可复用的 Skill，下次遇到同类问题直接调用。用得越久，能力越强。这不是功能差异，是设计哲学的分野——一个靠人喂，一个自己长。

> 字符上限故意设得很紧：MEMORY 限 2200 chars，USER 限 1375 chars。容量有限就迫使 Agent 挑重要的记，不重要的自然被挤掉。对比 OpenClaw——它的 MEMORY.md 是纯追加模式，用几个月就膨胀成几万行的怪兽文件。Hermes 的做法反过来：容量有限就倒逼 Agent 做信息压缩，过时的自然被挤掉，留下的都是高密度事实。

> 错误信息里一句 "Replace or remove existing entries first" 就把模型引导到了 replace 和 remove 操作上。同时返回 current_entries，让模型能看到现有的所有条目，自己决定哪些过时了该删、哪些可以合并压缩。模型不是被动地执行淘汰规则，而是主动做信息整理——这本身就是一次"自我反思"。

> HN 上有个帖子叫"Data Is the Final Moat"——当模型智能被商品化、Agent 框架被开源，真正的护城河是 Agent 在工作中积累的领域知识。OpenClaw 的 Skill 是手写的配置文件，用了一年还是那份手写的配置文件；Hermes 的 Skill 是越用越厚的经验资产——每一次踩坑都在加固护城河。

> 系统提示词里还有一句"Skills that aren't maintained become liabilities"——通过提示词给 Agent 灌输责任感，防止它只管创建不管维护。

> Nudge 触发后不会在主对话中插一条"让我想想有没有什么该记的"——那样太打扰用户了。而是在后台 fork 一个独立的 Agent 实例，拿着主对话的快照去做审查。输出重定向到 /dev/null，用户完全无感知。

> 如果你现在还在手写 Skill、手动维护 MEMORY.md、每次升级前先做好心理建设——不妨想想：你的时间应该花在给 Agent 做运维上，还是让 Agent 自己学会做事上？

## 涉及实体
- Hermes Agent —— 被分析的 self-improving agent 系统

## 涉及主题
- Self-Improving Agent —— agent 通过经验积累和自我反思持续改进的核心机制
- Agent Architecture —— agent 系统的源码架构设计
