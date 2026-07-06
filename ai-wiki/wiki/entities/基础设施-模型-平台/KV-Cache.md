---
title: "KV-Cache"
type: entity
date: 2026-06-19
also_known_as:
  - "Key-Value Cache"
  - "KV Cache"
  - "注意力缓存"
tags:
  - ai-infra
  - inference
  - cache
  - attention
sources:
  - "[[拆解大模型几项核心操作背后的数学与 Infra 优化逻辑]]"
  - "[[一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制]]"
  - "[[AI-Infra入门干货总结-大模型是如何高效推理的]]"
  - "[[万字入门AI-Infra-深入理解大模型中的数学与Infra优化]]"
  - "[[为什么大模型的缓存命中率能到90-Percent]]"
related_entities:
  - "[[vLLM]]"
  - "[[Prompt-Cache]]"
  - "[[Token成本控制]]"
---

# KV-Cache

## 一句话定义

KV-Cache 是 Transformer 自回归推理中缓存历史 Token 的 Key/Value 张量的机制，使模型生成下一个 Token 时无需为全部历史重新计算注意力投影；在产品计费语境里，它也常被进一步封装为 Prompt Cache / Prefix Cache。

## 摘要

Transformer 的注意力层会把每个 Token 映射成 Query、Key、Value。生成第 N 个 Token 时，当前 Query 需要和历史所有 Key 做点积，再用得到的权重加权历史 Value。历史 Token 的 Key 和 Value 一旦算出，在后续 decode 步骤中不会改变，因此可以缓存下来，下一步只为新增 Token 计算新的 K/V，再把它追加到缓存。这就是 KV-Cache。

KV-Cache 直接决定大模型服务的吞吐、延迟和显存压力：它省掉了重复计算，却把问题转移到显存容量、显存碎片、长上下文访存和多请求调度上。[[vLLM]] 的 PagedAttention、连续批处理、block table、slot mapping 等设计，本质上都围绕"如何更高效地管理 KV-Cache"展开。上层的 [[Prompt-Cache]] / prefix cache 又把这个机制暴露成产品层的成本优化：只要前缀不变，系统就可以复用已计算的 KV 张量或其服务端等价缓存。

## 详情

### 工作原理

自回归生成分为 Prefill 和 Decode 两段。Prefill 阶段一次性处理用户输入的整段上下文，产生每一层的历史 K/V；Decode 阶段每次只新生成一个或少量 Token，当前 Query 需要读取所有历史 K/V。没有 KV-Cache 时，每一步都要把完整历史重新过一遍模型，计算量近似随轮次二次增长；有 KV-Cache 后，每一步只追加新 Token 的 K/V，历史部分变成读取缓存。

从 Attention 公式看，KV-Cache 缓存的是每层每个 head 的 K/V 张量，而不是自然语言文本。缓存内容和模型、权重、tokenizer、上下文前缀严格绑定：换模型、改系统提示、改工具定义或改变前缀顺序，都会让已有 KV 无法复用。

### 与 Prompt Cache 的关系

KV-Cache 是模型内部推理机制；[[Prompt-Cache]] 是产品和 API 层对前缀复用的抽象。用户看到的"cache write / cache read"、"前缀命中 0.1 倍价格"并不要求用户直接管理张量，但其经济学来自同一个事实：前缀对应的 K/V 已经算过，后续轮次可以复用。二者容易混用，区别在于：

- KV-Cache 关注推理引擎内部的 K/V 张量存储、调度和读取。
- Prompt Cache 关注 API 或产品层的前缀匹配、计费、过期时间和命中策略。
- KV-Cache 一般生命周期短，绑定请求或会话；Prompt Cache 可能由服务端做更长时间的前缀复用。

### Prefix Caching 与 90% 命中率

标准 KV-Cache 解决的是“同一次请求生成后续 token 时，不要重算历史 K/V”；Prefix Caching 进一步解决“下一次请求开头与之前完全相同，能不能复用已经算过的前缀 K/V”。Agent 式调用天然适配这个模式：系统提示、工具 schema、Skill 定义和历史对话通常排在前面，每一轮只在末尾追加工具返回和新回复。若一段会话有 `T` 轮、每轮新增量近似相等，累计命中读与新写入的比例可以粗略估为 `(T-1)/(T+1)`，因此 20 轮会话会落到约 90% 命中率。

这个数字不是某家模型的魔法能力，而是“只追加 + 前缀一致”的工作负载结果。它也有反面：中途切换模型、改变工具集、修改系统提示、插入时间戳或把请求轮询到不共享缓存的后端，都会从变动点之后打断缓存链。对 [[Token成本控制]] 来说，稳定前缀、少改工具 schema、绑定单一模型和 cache-aware 路由，比单纯压短 prompt 更关键。

### vLLM 与 PagedAttention

KV-Cache 的最大工程难题是显存。传统做法为每个请求预分配连续显存，容易因为不同请求长度差异造成浪费和碎片。[[vLLM]] 借鉴操作系统虚拟内存，把 KV-Cache 切成固定大小的 block，通过 block table 把逻辑 token 位置映射到物理 block。这样不同请求的 KV 可以非连续存放，按需分配和回收。

PagedAttention 的价值不是改变注意力数学，而是改变缓存管理方式：模型计算时通过页表指针从 HBM gather 离散 KV block 到片上 SRAM，再完成当前 Query 与历史 Key/Value 的计算。长上下文和多请求并发下，这比连续大块分配更能提升显存利用率。

### 与 FlashAttention / Online Softmax 的关系

KV-Cache 管历史 K/V，FlashAttention 管单次 attention 计算如何少写 HBM。Prefill 阶段通常面对完整序列，可以用 FlashAttention 把 QK、Softmax、PV 融合为 tile 流式计算，避免写出巨大的注意力矩阵。Decode 阶段 Query 长度通常为 1，计算瓶颈更多转为读取历史 KV；这时 Flash-Decoding、Split-K、LSE 合并和 block 调度会影响长上下文延迟。

### 应用 / 使用场景

- 在线 LLM Serving：降低每步 decode 重复计算，提升首轮后续 token 的生成效率。
- 长上下文 Agent：多轮会话、工具调用和系统前缀稳定时，缓存命中直接影响成本。
- 批量推理：结合 Continuous Batching，把短请求完成后释放的 KV block 复用给新请求。
- 多卡推理：在张量并行或序列并行下，KV 分片、跨卡通信和局部归约决定扩展效率。

### 局限与争议

- 显存压力大：上下文越长，KV-Cache 线性增长，长上下文场景很快被显存容量卡住。
- 前缀脆弱：系统提示、工具 schema、规则、记忆、历史消息任一处变动，都可能打断缓存链。
- 读取瓶颈：Decode 阶段大量读取历史 KV，常常从算力瓶颈转为访存瓶颈。
- 近似优化有代价：KV Quant、滑动窗口、稀疏注意力、MLA/DSA/CSA/HCA 等方案都在容量、速度和精度之间取舍。

## 与其他实体的关系

- [[vLLM]] —— 以 PagedAttention 和 Continuous Batching 管理 KV-Cache，是生产推理框架代表。
- [[Prompt-Cache]] —— 产品层前缀缓存，经济学基础来自 KV 复用。
- [[Token成本控制]] —— AI Coding 成本控制的关键是保护稳定前缀、减少重算和无效历史膨胀。

## 参考来源

- [[拆解大模型几项核心操作背后的数学与 Infra 优化逻辑]] —— 从 Online Softmax、FlashAttention、Gumbel-Max 和 KV 优化解释 Infra 的数学等价变换。
- [[一文搞懂Token经济学：同样额度多干3倍活，只需理解消耗机制]] —— 从 API 调用和缓存命中解释 KV/Prompt Cache 对成本的影响。
- [[AI-Infra入门干货总结-大模型是如何高效推理的]] —— vLLM、PagedAttention、KV block 和调度机制。
- [[万字入门AI-Infra-深入理解大模型中的数学与Infra优化]] —— 大模型推理优化的数学与系统背景。
- [[为什么大模型的缓存命中率能到90-Percent]] —— Agent 会话中 KV Cache、Prefix Caching、PagedAttention 和 90% 命中率的工程解释。
