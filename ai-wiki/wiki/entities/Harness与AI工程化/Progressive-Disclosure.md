---
title: "Progressive-Disclosure"
type: entity
date: 2026-06-21
also_known_as: [渐进式披露, 渐进披露, Progressive Disclosure, 渐进式信息披露]
tags: [context-engineering, 信息架构, agent-memory, token-cost, skill]
sources:
  - "[[Progressive-Disclosure-Claude-Mem]]"
related_entities:
  - "[[Context-Engineering]]"
  - "[[claude-mem]]"
  - "[[Agent-Memory]]"
  - "[[RAG]]"
  - "[[OpenClaw-Skills]]"
  - "[[Headroom]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
---

# Progressive Disclosure（渐进式披露）

## 一句话定义

渐进式披露是一种「先给目录、按需取正文」的信息架构模式——先向 Agent 暴露「有什么内容、取回它要花多少 token」，再把是否加载、加载哪些的决定权交给 Agent，而不是开局就把全部上下文塞满。

## 摘要

Progressive Disclosure 原是 Nielsen Norman Group 提出的人机交互原则（逐步揭示复杂度，而非一次性铺开）。在 AI Agent 语境下，它被 [[claude-mem]] 等记忆系统借用为「上下文预热（context priming）哲学」：会话启动时只注入一份轻量索引（标题 + 时间 + 类型图标 + token 估算），让 Agent 像人扫标题、看目录、查文件名一样先扫描全貌，再用检索工具按需取回细节。

它针对的核心病灶是「上下文污染（context pollution）」——传统 RAG 在会话开始就把历史会话、观察记录、文件摘要等几万 token 一次性灌入，真正相关的可能只有 6%，其余 94% 白白消耗注意力预算并把用户的真实诉求埋在历史堆里。渐进式披露把这条曲线反过来：开局约 1000 token 的索引，Agent 自行判断相关性后再花约 200 token 取回单条细节，最终上下文里「相关 token / 总 token」可以逼近 100%。这一模式同时也是 Anthropic Skills「三级加载」（名称+描述 → SKILL.md → 引用文件/脚本）和本知识库 Skill 路由器的底层设计思想。

## 详情

### 起源与背景

渐进式披露脱胎于认知科学与交互设计：人类从不一次性消化全部信息，而是先扫新闻标题再读正文、先看目录再翻章节、先看文件名再打开文件。它背后有三条理论支撑——认知负荷理论（Cognitive Load Theory, Sweller 1988）、信息觅食理论（Information Foraging Theory, Pirolli & Card 1999）以及 Nielsen Norman Group 的渐进式披露原则。

在 Agent 时代，这套人因原则被迁移到「如何给模型喂上下文」。[[claude-mem]] 文档把它总结为一句核心原则：**先展示「存在什么」及其「取回成本」，让 Agent 根据相关性和需要自行决定取回什么。** 这与 [[Context-Engineering]] 中「按需加载 / Just-In-Time 检索」的主张是同一思想的不同表述。

### 核心机制 / 工作原理

**三层结构**：

1. **Layer 1（索引）**：只给轻量元数据——标题、日期、类型、token 数。
2. **Layer 2（细节）**：需要时才取回完整内容。
3. **Layer 3（深挖）**：必要时再读原始源文件 / 代码。

**索引格式**：claude-mem 在每次 SessionStart hook 注入一张紧凑表，每行暴露五类信息——「有什么」（标题给语义）、「何时发生」（时间戳给时序）、「什么类型」（图标给分类）、「取回成本」（token 数给 ROI 判断）、「去哪取」（底部标注 MCP 检索工具）。示例：

```markdown
**src/hooks/context-hook.ts**
| ID | Time | T | Title | Tokens |
|----|------|---|-------|--------|
| #2591 | 1:15 AM | ⚖️ | Stderr messaging abandoned | ~155 |
| #2592 | 1:16 AM | ⚖️ | Web UI strategy redesigned | ~193 |
```

**图标图例（Legend）系统**：用 emoji 对观察分类，便于视觉扫描、语义归类与优先级信号（🔴 gotcha 比一般条目更值得立即取回），且 1 字符比 10 字符的文本标签更省 token、跨语言通用：

```
🎯 session-request  - 用户原始目标
🔴 gotcha          - 关键边界 / 陷阱
🟡 problem-solution - bug 修复 / 变通
🔵 how-it-works    - 技术解释
🟢 what-changed    - 代码 / 架构变更
🟣 discovery       - 学习 / 洞察
🟠 why-it-exists   - 设计动机
🟤 decision        - 架构决策
⚖️ trade-off       - 主动取舍
```

**三层检索工作流**：索引层之外必须配检索工具，否则索引无用。claude-mem 提供 `search`（拿索引/ID）→ `timeline`（看 ID 周边的时序叙事）→ `get_observations`（取完整细节）三层 MCP 工具，对应 index → context → details。

### 四条实现原则

1. **让成本可见**：每条都标 token 数，Agent 才能做 ROI 决策（~50 token 便宜，~500 token 需更强理由）。
2. **语义压缩**：好标题把一条观察压成约 10 个词，要求具体、可执行、自包含、可搜索、带类型图标。反例「Observation about a thing」，正例「🔴 Hook timeout issue: 60s default too short for npm install」。
3. **按上下文分组**：按日期（时序）、文件路径（空间局部性）、项目（逻辑）分组——在改 `X` 文件时，关于 `X` 的观察已聚在一起。
4. **提供取回工具**：索引底部标注「用 MCP search 按 ID 取记录」。

### 哲学：上下文即货币

文档用「把 token 预算当钱花」的心智模型：全量灌入 = 把整月工资买了可能用得上的杂货（浪费、挤占）；一概不取 = 拒绝花钱（饿死、办不成事）；渐进式披露 = 查库存、列清单、只买需要的（高效、留余量）。其底层事实是注意力预算有限——每个 token 都要与其他所有 token 建立 n² 关系，10 万 token 窗口 ≠ 10 万 token 的有效注意力，窗口越满越「上下文腐烂（context rot）」，靠后的 token 拿到的注意力更少。

更深一层是「为自主性设计」：渐进式披露把 Agent 当作有判断力的「信息觅食者」，而非被动接收预筛上下文的容器。因为「当前任务上下文、什么信息有用、该花多少预算、何时停止搜索」这些只有 Agent 自己最清楚，系统不该越俎代庖去预取。

### 反模式

- **啰嗦标题**：把一句话拆成长描述，浪费扫描成本。
- **隐藏成本**：索引行不标 token 数，Agent 无法做取回 ROI 判断。
- **没有取回路径**：只给一堆观察却不说明如何取回完整细节。
- **跳过索引层**：不先 `search` 拿索引就直接 `get_observations` 猜一批 ID 全取——等于放弃渐进式披露。

### 应用 / 使用场景

- Agent 记忆系统的会话预热（claude-mem 的 SessionStart 索引）。
- [[OpenClaw-Skills]] / Anthropic Skills 的三级渐进加载（先元数据，再 SKILL.md，再引用文件），避免一次性把所有技能正文塞进系统提示。
- 知识库 / RAG 的「索引优先、细节按需」检索，替代 top-K 全量召回。
- 本地文件、工具输出、长会话历史的按需取回（与 [[Headroom]] 的可逆压缩 + 子集检索目标一致）。

### 局限与争议

- 索引质量决定成败：标题写不好（语义压缩失败），Agent 扫不出相关性，整套机制失效。
- 比预取慢：JIT 式取回需要额外往返，对「静态、必读」内容反而不如预先加载。
- 依赖 Agent 判断力：模型若不会按图例和成本做选择，可能漏取关键 gotcha 或过度取回。
- token 数是估算而非精确值（~155 而非 155），刻意牺牲精度换「规模直觉」，不适合做严格预算核算。

## 与其他实体的关系

- [[Context-Engineering]] —— 渐进式披露是上下文工程「按需加载 / Just-In-Time」原则的具体信息架构实现。
- [[claude-mem]] —— claude-mem 是渐进式披露在 Agent 记忆系统中的参考实现（索引 + 图例 + 三层 MCP 工作流）。
- [[Agent-Memory]] —— 渐进式披露解决记忆系统「如何低成本地把历史暴露给当前会话」的问题。
- [[RAG]] —— 对传统 RAG「开局全量召回」的反向设计，强调索引优先、细节按需。
- [[OpenClaw-Skills]] —— Skill 体系的三级加载是渐进式披露的另一落地形态。
- [[Headroom]] —— 同属「减少无效 token 进入上下文」的治理思路，Headroom 偏运行时压缩，渐进式披露偏信息架构。

## 参考来源

- [[Progressive-Disclosure-Claude-Mem]]
