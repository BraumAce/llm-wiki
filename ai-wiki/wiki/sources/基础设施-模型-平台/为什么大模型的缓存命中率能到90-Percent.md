---
title: "为什么大模型的缓存命中率能到 90%？"
type: source
date: 2026-07-06
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/bsSBfvWyLUEdFHFZmFOckQ"
author: "阿里技术"
ingested_at: 2026-07-06
tags:
  - kv-cache
  - prefix-caching
  - llm-inference
  - token-cost
related_entities:
  - "[[KV-Cache]]"
  - "[[Prompt-Cache]]"
  - "[[vLLM]]"
  - "[[Token成本控制]]"
related_topics:
  - "[[AI-Infra推理优化-主题]]"
---

# 为什么大模型的缓存命中率能到 90%？

## 一句话概括

这篇文章解释了 Agent 会话中缓存命中率常见 90% 左右的根因：自回归推理的 [[KV-Cache]] 只在请求内生效，而跨请求 [[Prompt-Cache]] / prefix caching 利用了 Agent 多轮“只追加、不插改”的前缀结构，让历史大上下文反复命中缓存。

## 实践内容

核心判断公式：

```text
设一次会话共 T 轮，每轮新增内容量大致相当为 d：

累计命中读 ≈ d × [0 + 1 + ... + (T-1)] = d·T(T-1)/2
累计新写入 ≈ d × T

命中率 ≈ (T - 1) / (T + 1)

T = 10 -> 81.8%
T = 20 -> 90.5%
T = 40 -> 95.1%
```

工程规则：

```text
让缓存命中：
- 稳定内容放前面：系统提示、工具定义、常用模板、稳定背景文档
- 易变内容放后面：用户新问题、时间戳、检索结果、工具返回
- 已缓存内容后只追加，不在前缀中间插改
- 长会话尽量绑定单一模型、稳定工具集、cache-aware 路由

让命中率塌方：
- 中途切换模型
- 改动工具集或系统提示
- 会话太短
- 请求被轮询到不共享缓存的后端
```

文章列出的技术路线：

```text
1. KV Cache：请求内复用历史 Key/Value，避免每步重算整段历史。
2. Prefix Caching：跨请求复用相同前缀的 KV Cache，跳过 prefill。
3. vLLM Automatic Prefix Caching：定长 block + 父块哈希 + 本块内容的链式哈希，哈希表管理，LRU 淘汰。
4. RadixAttention：用前缀树表达请求间共享前缀，结合缓存感知调度。
5. Prompt Cache / CacheBlend / EPIC：试图突破“必须是前缀、必须逐字一致”的限制。
```

## 摘录

> Prefix Caching（前缀缓存）就是把这部分“公共前缀”的 KV Cache 留下来、跨请求复用：新请求进来，先看它的前缀是不是已经被算过、缓存过；命中了就直接读，跳过最昂贵的“预填充（prefill）”环节。为什么必须逐字完全一致？前缀从第一处不一致开始、往后就无法复用，分歧点之前的完整块仍然命中，之后的缓存才失效。

> vLLM 的 PagedAttention 借鉴了操作系统管理内存的经典思路：把 KV Cache 切成固定大小的「页（block）」，像虚拟内存分页一样按需分配、灵活共享，把浪费压到 4% 以下，吞吐量提升 2–4 倍。这一步看似只是省显存，也大大降低了跨请求共享 KV 的工程成本，把 KV 拆成可独立管理的小块后，多个请求才好共享其中几块。

> 一次典型的 agent 编码会话往往要跑十几到几十轮工具调用，命中率就容易落到 90% 上下。这大致解释了不同厂商主力模型的命中率为何都在这个区间——主要是「只追加对话 + 前缀缓存」这种工作负载的结果，而非某家模型的特殊能力；实际数值还受系统提示大小、块粒度、TTL、路由等因素影响。

## 涉及实体

- [[KV-Cache]] —— 底层机制，请求内缓存历史 Key/Value，减少自回归生成中的重复计算。
- [[Prompt-Cache]] —— 产品/API 层的前缀缓存抽象，解释为什么稳定前缀、只追加和模型绑定会影响成本。
- [[vLLM]] —— Automatic Prefix Caching 使用 block 哈希链和 LRU 管理前缀缓存。
- [[Token成本控制]] —— 高命中率不等于成本最低；真正的降本杠杆在于稳定前缀、减少未缓存流量和避免模型/工具抖动。

## 涉及主题

- [[AI-Infra推理优化-主题]]

## 我的评注

这篇文章补上了一个很容易混淆的点：90% 命中率既说明缓存机制有效，也说明 Agent 每轮都在重发大上下文。工程上不能只盯命中率，而要同时看 cache read、cache write、uncached input 的绝对 token 量。对 AI Coding Agent，最实用的建议仍然是保持系统提示、工具 schema、Skill 前缀和模型路由稳定，把动态内容后置。
