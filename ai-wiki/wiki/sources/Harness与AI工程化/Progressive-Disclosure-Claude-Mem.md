---
title: "Progressive Disclosure: Claude-Mem's Context Priming Philosophy"
type: source
date: 2026-06-22
source_type: webpage
source_url: "https://docs.claude-mem.ai/progressive-disclosure"
author: "Claude-Mem Documentation"
ingested_at: 2026-06-22
tags: [context-engineering, progressive-disclosure, agent-memory, token-cost, claude-code]
related_entities:
  - "[[Progressive-Disclosure]]"
  - "[[claude-mem]]"
  - "[[Context-Engineering]]"
  - "[[Agent-Memory]]"
  - "[[MCP]]"
related_topics:
  - "[[Agentic-Engineering-主题]]"
---

# Progressive Disclosure: Claude-Mem's Context Priming Philosophy

## 一句话概括

claude-mem 官方文档对「渐进式披露」上下文预热哲学的完整阐述：先给带 token 成本的轻量索引、让 Agent 自行决定取回什么，用三层 MCP 工作流（search→timeline→get_observations）把会话上下文的「相关 token 占比」从 6% 拉到接近 100%。

## 实践内容

**核心原则**：Show what exists and its retrieval cost first. Let the agent decide what to fetch based on relevance and need.

**三层结构**：Layer 1（Index）轻量元数据（标题/日期/类型/token 数）→ Layer 2（Details）按需取回全文 → Layer 3（Deep Dive）必要时读原始源文件。

**索引格式**（SessionStart hook 注入，按文件路径分组）：

```markdown
### Oct 26, 2025

**General**
| ID | Time | T | Title | Tokens |
|----|------|---|-------|--------|
| #2586 | 12:58 AM | 🔵 | Context hook file exists but is empty | ~51 |
| #2589 | ″ | 🟡 | Investigated hook debug output docs | ~105 |

**src/hooks/context-hook.ts**
| ID | Time | T | Title | Tokens |
|----|------|---|-------|--------|
| #2591 | 1:15 AM | ⚖️ | Stderr messaging abandoned | ~155 |
| #2592 | 1:16 AM | ⚖️ | Web UI strategy redesigned | ~193 |
```

**图例系统（Legend，9 类观察类型）**：

```
🎯 session-request  - User's original goal
🔴 gotcha          - Critical edge case or pitfall
🟡 problem-solution - Bug fix or workaround
🔵 how-it-works    - Technical explanation
🟢 what-changed    - Code/architecture change
🟣 discovery       - Learning or insight
🟠 why-it-exists   - Design rationale
🟤 decision        - Architecture decision
⚖️ trade-off       - Deliberate compromise
```

**索引内嵌的渐进式披露指引**：

```markdown
💡 Progressive Disclosure: This index shows WHAT exists and retrieval COST.
- Use MCP search tools to fetch full observation details on-demand
- Prefer searching observations over re-reading code for past decisions
- Critical types (🔴 gotcha, 🟤 decision, ⚖️ trade-off) often worth fetching immediately
```

**三层 MCP 检索工作流**：

```typescript
// Layer 1: Search（拿索引/ID，~50-100 token/条）
search({ query: "hook timeout", limit: 10 })

// Layer 2: Timeline（看某 ID 前后的时序叙事）
timeline({ anchor: 2543, depth_before: 3, depth_after: 3 })

// Layer 3: Get Observations（取选中观察的完整细节）
get_observations({ ids: [2543, 2102] })
```

**get_observations 返回的完整观察结构**：

```
#2543 🔴 Hook timeout: 60s too short for npm install
─────────────────────────────────────────────────
Date: Oct 26, 2025 2:14 PM
Type: gotcha
Project: claude-mem

Narrative:
Discovered that the default 60-second hook timeout is insufficient
for npm install operations, especially with large dependency trees
or slow network conditions. This causes SessionStart hook to fail
silently, preventing context injection.

Facts:
- Default timeout: 60 seconds
- npm install with cold cache: ~90 seconds
- Configured timeout: 120 seconds in plugin/hooks/hooks.json:25

Files Modified:
- plugin/hooks/hooks.json

Concepts: hooks, timeout, npm, configuration
```

**四条实现原则**：① 让成本可见（每条标 token 数）② 语义压缩（好标题≈10 词，具体/可执行/自包含/可搜索/带图标）③ 按上下文分组（日期/文件路径/项目）④ 提供取回工具（MCP search by ID）。

**反模式清单（❌ Anti-Patterns）**：啰嗦标题、隐藏成本（不标 token 数）、没有取回路径、跳过索引层（不 search 直接 get_observations 猜 ID）。

**「上下文即货币」对照表**：

| Approach | Metaphor | Outcome |
|----------|----------|---------|
| Dump everything | 把整月工资买可能用得上的杂货 | 浪费、挤占、买不起真正需要的 |
| Fetch nothing | 拒绝花任何钱 | 饿死、办不成事 |
| Progressive disclosure | 查库存、列清单、只买需要的 | 高效、留余量 |

**成功度量阈值**：相关 token / 总上下文 token > 80%；索引展示 50 条只取 2-3 条（选择性取回）；带索引找到相关上下文约 30s vs 不带约 90s；取回深度随任务复杂度伸缩（简单任务只需索引）。

**自适应索引方向**：`startup`→最近 10 会话；`resume`→仅当前会话（微索引）；`compact`→最近 20 会话。

## 摘录

> Traditional RAG (Retrieval-Augmented Generation) systems fetch everything upfront ... Wastes 94% of attention budget on irrelevant context; User prompt gets buried under mountain of history; Agent must process everything before understanding task; No way to know what's actually useful until after reading. —— 文档把「上下文污染」量化为：35,000 token 注入里只有约 2,000 token（6%）相关。

> LLMs have finite attention: Every token attends to every other token (n² relationships); 100,000 token window ≠ 100,000 tokens of useful attention; Context "rot" happens as window fills; Later tokens get less attention than earlier ones. Claude-Mem's approach: Start with ~1,000 tokens of index; Agent has 99,000 tokens free for task; Agent fetches ~200 tokens when needed; Final budget: ~98,000 tokens for actual work.

> Progressive disclosure treats the agent as an intelligent information forager, not a passive recipient of pre-selected context. The agent knows: The current task context; What information would help; How much budget to spend; When to stop searching. We don't. —— 这是「为自主性设计（Design for Autonomy）」一节的核心论断。

## 涉及实体

- [[Progressive-Disclosure]] —— 本文是该模式最完整的一手阐述
- [[claude-mem]] —— 渐进式披露在其记忆系统中的参考实现
- [[Context-Engineering]] —— 渐进式披露是 JIT 检索原则的信息架构落地
- [[Agent-Memory]] —— 解决记忆系统「低成本暴露历史」的问题
- [[MCP]] —— search / timeline / get_observations 三层检索工具

## 涉及主题

- [[Agentic-Engineering-主题]]

## 我的评注（可选）

文档把「注意力预算」从口号落成了可度量指标（相关 token 占比、取回条数、时延），这点比多数泛谈 context engineering 的文章更可操作。与 [[Headroom]] 对照：Headroom 在运行时做可逆压缩（被动减负），渐进式披露在信息架构层让 Agent 主动取回（主动选择），两者可叠加。其理论引用（Cognitive Load Theory、Information Foraging Theory）也提示这套模式并非 LLM 时代独创，而是人因工程的迁移。
