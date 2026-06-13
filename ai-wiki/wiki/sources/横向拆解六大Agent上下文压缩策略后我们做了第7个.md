---
title: "横向拆解六大Agent上下文压缩策略后我们做了第7个"
type: source
date: 2026-06-08
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/BQwyvE2qIfguwKk63F3LZw"
author: "mervynyang（腾讯技术工程）"
ingested_at: 2026-06-08
tags: [context-compaction, agent, context-engineering, prompt-cache, cloud-agent]
related_entities: [Context-Engineering, Agent-Memory, Claude-Code, Prompt-Cache]
related_topics: [Agentic-Engineering-主题]
---

# 横向拆解六大 Agent 上下文压缩策略后，我们做了第 7 个

## 一句话概括
横向拆解 Claude Code、Codex CLI、OpenCode、Cline、Cursor、Amp、MemGPT/Letta 七种 Agent 上下文压缩方案，提炼六条共识原则，并面向云端多用户 Agent（MUR AI）落地四级水位线 + 增量摘要 + 跨轮缓存方案。

## 摘录

> 六家产品，六种哲学。说明这件事没有显而易见的最优解，每一种选择背后都是取舍。

> 第一代做法的根本问题：它把压缩当突发事件处理，而不是一种持续维护的能力。

> stub 决策必须单调推进——只能大跳，不能滑窗。一个 part 一旦被标成 stub，后续所有 turn、所有 step 里都保持 stub 不变，绝不因为"又老了一步"而反复触发。

> Context 压缩的目标从来不是省 token。省钱是顺带的。它要解决的问题是保护模型的注意力。

## 实践内容

### 第一代压缩的五条痛点

1. **悬崖式触发** — 不溢出不动，溢出全量出手，触发时质量已塌
2. **全量摘要丢细节** — 几十轮压成几百字，变量名/函数签名/错误堆栈全丢
3. **Token 估算粗糙** — text.length/3 在中英混合场景误差 30-50%
4. **不区分信息价值** — 5000 行 grep 输出和 5000 token 关键诊断被同等对待
5. **用户内容被一刀切** — 用户贴的代码代表输入意图，和工具输出性质不同

### 七种方案横向对比

| 产品 | 核心策略 | 哲学 |
|------|---------|------|
| Claude Code | 五段流水线按成本递增 | 便宜的本地操作先上，LLM 摘要兜底 |
| Codex CLI | 保留近期用户消息，其余替换为 handoff 摘要 | 用户说的话最准确，模型说的可以重写 |
| OpenCode | 时间戳标记隐藏 + 结构化摘要 + 回放最后一条用户消息 | 不真删，理论上可恢复 |
| Cline | /smol + Auto-Compact 双模式 | 自动 + 手动双模式，Focus Chain 穿越压缩 |
| Cursor | 自动摘要 + 提示开新对话 + 历史可搜索 | 压缩后仍能回溯原始历史 |
| Amp | 不做递归压缩，用 /handoff 开新线程 | 长对话本身就是问题，换线程比压缩好 |
| MemGPT/Letta | 上下文 = RAM，历史 = 磁盘，Agent 自主换入换出 | 操作系统级的内存调度 |

### Claude Code 五段流水线细节

1. Budget Reduction — 调整工具输出截断预算
2. Snip — 截短老工具输出，留摘要行
3. Microcompact — 局部内联压缩
4. Context Collapse — 更久远历史粒度更细的折叠
5. Auto-Compact — 兜底调 LLM 生成结构化摘要（九章节）

更激进路径：cached_microcompact（服务端 cache_edits 指令，客户端字节不改）和 apiMicrocompact（调 Anthropic context_management API）

### 滑窗式 stub 替换陷阱

每 step 都重算 stub 决策 → 每 step 缓存前缀失效 → 实测 177 step 会话 83% 成本全是 cache_write（$64.8/$77.3）

### 六条共识原则

1. 分层渐进，不一刀切
2. 成本严格递增（便宜的先做）
3. 增量摘要优于全量摘要
4. 用真实 token 别估算
5. 用户消息有特权
6. 保护近端（最近几轮不动）
7. 单调边界，绝不滑窗

### MUR AI 四级水位线方案

| Tier | 阈值 | 操作 | LLM 调用 |
|------|------|------|---------|
| 0 | <60% | 不做 | 无 |
| 1 Snip | 60-80% | 截短老工具输出和代码块 | 无 |
| 2 Prune | 80-95% | 替换为占位符，裁短 assistant 旧文本 | 无 |
| 3 Summarize | ≥95% | 增量摘要（上次摘要 + delta → 合并摘要） | 有 |

### 云端多用户额外三层

**存储分离**：完整输出落盘到 _internal/truncated-outputs/{callId}.log，对话只留截断版 + 回取路径。模型看到"前几行 + [截断] + 完整日志路径"。前端按需取读，解耦模型工作记忆和用户审计需求。

**工具差异化**：
- 完全保护：Skill、Task（任何 Tier 不动）
- 微压缩豁免：Task、AskUserQuestion
- 白名单可压：bash/read/grep/websearch
- 差异化存储预算：Read 30KB、Bash 50KB、WebSearch 15KB

**跨轮缓存 ReplacementCache**：按 part ID 存 Redis（key: msgOptCache:{sessionId}，TTL 30min），跨实例跨重启复用压缩决策，保证消息前缀稳定和 Prompt Cache 友好。

### 红线（任何 Tier 都不能动）

- 保护区内的所有消息
- 用户消息的纯文本部分
- PROTECTED_TOOLS 的输出（Skill / Task）
- MICRO_COMPACTION_EXEMPT 的工具（Task / AskUserQuestion）
- 带 compactionProtected 标记的 Part

## 涉及实体

- [[Context-Engineering]] —— 上下文工程，压缩是其核心子领域
- [[Agent-Memory]] —— Agent 记忆管理
- Prompt Cache —— Prompt Cache 命中率优化
