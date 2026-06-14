---
title: "OpenClaw Agent与Skill架构详解"
type: source
date: 2026-05-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/7RWpW-wZuDmKuexf8smGGQ"
author: "京东技术 / 京东科技 苗元"
published_at: "2026-04-15"
ingested_at: 2026-05-10
tags:
  - openclaw
  - agent
  - skill
  - subagent
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-Skills]]"
related_topics: []
---

# OpenClaw Agent与Skill架构详解

## 一句话概括

京东技术苗元撰写的 [[OpenClaw]] Agent + Skill 系统源码级深度解析，覆盖"为什么需要 OpenClaw"（多渠道/长时运行/灵活扩展三痛点）、Agent 执行引擎（pi-mono 嵌入 + ReAct 循环 + 单次执行尝试）、Skill 6 源加载与过滤机制、Subagent 设计动机/创建/生命周期、容错层级（认证熔断 / 模型回退 / 上下文恢复 / 智能重试）、工具权限策略八大块。是与上下篇互补的"Skill 视角"深度解析。

## 实践内容

### Skill 数量限制配置（原文 3.2.5）

```typescript
SkillsLimitsConfig = {
  maxCandidatesPerRoot?: number;       // 每个来源目录的最大候选数
  maxSkillsLoadedPerSource?: number;   // 每个来源的最大加载数
  maxSkillsInPrompt?: number;          // Prompt 中的最大 Skill 数
  maxSkillsPromptChars?: number;       // Prompt 中 Skill 段的最大字符数
  maxSkillFileBytes?: number;          // 单个 SKILL.md 文件的最大字节数
}
```

### SkillSnapshot 结构（原文 3.3）

```typescript
SkillSnapshot = {
  prompt: string;                    // 生成的 Skill 菜单 Prompt
  skills: Array<{
    name: string;
    primaryEnv?: string;
    requiredEnv?: string[];
  }>;
  skillFilter?: string[];            // Agent 级别的过滤规则
  resolvedSkills?: Skill[];
  version?: number;                  // 快照版本号
};
```

### Skill 6 源加载优先级（原文 3.2.1）

由 `src/agents/skills/workspace.ts` 的 `loadSkillEntries()` 合并：

```
project-level skills (最高优先级，覆盖同名)
  ↓
plugin skills（来自启用的插件）
  ↓
user-level skills（~/.openclaw/skills/）
  ↓
bundled skills（内置）
  ↓
external skills（特定路径）
  ↓
fallback skills（最低优先级）
```

### Agent 执行的 ReAct 循环

外层迭代由 `MAX_RUN_LOOP_ITERATIONS` 控制——并且**会根据可用的 Auth Profile 数量动态缩放**。意味着配置了更多 API Key → 拥有更大的重试空间。

### 关键约束

> **never read more than one skill up front** —— 每次最多选择一个 Skill，避免不必要的 Token 消耗。

## 摘录

> OpenClaw 中*同时存在两种互补的架构模式：Agent + Skill 架构 —— 通过 SKILL.md 文件为 Agent 注入领域知识，就像给一个人发一本操作手册；主子 Agent（Subagent）架构 —— 通过创建独立子 Agent 实现并行执行和上下文隔离，就像派出多个助手分头干活。两者不是替代关系，而是互补关系。一个 Agent 可以在读取 Skill 获得知识后，再创建多个子 Agent 并行执行任务；子 Agent 自身也可以使用 Skill。

> OpenClaw 的差异化定位体现在三个层面：基础设施层基于 pi-mono（嵌入式 Agent 引擎），提供 ReAct 循环、LLM 调用、工具执行等底层能力；平台层在 pi-mono 之上构建路由、容错、认证管理、Skill 系统等生产级能力；渠道层统一消息抽象，让同一个 Agent 可以同时服务于多个通信平台。

> Skill 是以 SKILL.md 文件形式存在的知识/指令包，告诉 Agent "如何做某类事情"。它不是可执行代码，而是一份结构化的操作指南。Skill 的选择是 Agent（LLM）自主完成的，不是系统硬编码的规则匹配。整个过程是正常的多轮对话——只是 system prompt 的 Skills 段告诉 LLM "你有这些 Skill 可选"，LLM 自己判断何时去 read 它。注入到 Prompt 中的 Skill 菜单只包含 name、description、location，不包含 SKILL.md 的完整内容，有效控制了 Token 消耗。

## 涉及实体

- [[OpenClaw]] —— 父系统
- [[OpenClaw-Skills]] —— 本文是该子模块的最详尽源码级解析

## 涉及主题

（积累 ≥5 篇同议题来源后聚合）

## 我的评注

- 本文最有价值的设计洞察是"Skill 菜单只放 description，不塞全文"。这个看似显然的优化在很多 Agent 框架里被忽略——直接把所有 Skill 全文塞 system prompt 是非常常见的反模式，会极快吃掉上下文窗口
- "MAX_RUN_LOOP_ITERATIONS 根据 Auth Profile 数量动态缩放"这个设计很巧妙：它把"配多少 API Key"和"愿意为重试付出多少耐心"绑在了一起，自然地实现了配置一致性
- "Agent + Skill 互补于 Subagent，而非替代"是个反直觉的论断——很多人下意识会觉得 Subagent 比 Skill 更"高级"，但本文清楚指出二者是不同维度的扩展机制（知识扩展 vs 并行扩展）
- 与 [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]] 中的"模块 6 技能（Agent Skills）—— 条件加载"对应；两篇可对照阅读
