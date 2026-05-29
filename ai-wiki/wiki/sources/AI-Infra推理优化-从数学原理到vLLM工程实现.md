---
title: "AI Infra 推理优化：从数学原理到 vLLM 工程实现"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://blog.bytelighting.cn/program/reading/2026/2026.5.html"
author: "多作者综合"
ingested_at: 2026-05-29
tags:
  - ai-infra
  - inference
  - vllm
  - optimization
related_entities:
  - "[[vLLM]]"
  - "[[RAG]]"
related_topics:
  - "[[AI-Infra推理优化-主题]]"
---

# AI Infra 推理优化：从数学原理到 vLLM 工程实现

## 一句话概括

综合 3 篇 AI Infra 文章，从大模型核心操作的数学原理出发，到 vLLM 的 Paged Attention 和 Continuous Batching 工程实现，系统梳理大模型推理优化的完整知识体系。

## 实践内容

### RMSNorm 优化原理

```
传统 LayerNorm:
  x → 减均值 → 除标准差 → γ缩放 + β偏移
  两次全局规约（均值 + 方差）

RMSNorm:
  x → 除 RMS(root mean square) → γ缩放
  砍掉均值计算，一次全局规约

效果：访存开销降低 ~15%，精度损失可忽略
公式：RMSNorm(x) = x / √(mean(x²) + ε) · γ
```

### Softmax 与 Causal Mask

```
Softmax: 将 logits 转为概率分布
  softmax(x_i) = e^(x_i) / Σe^(x_j)
  Infra 优化：在线 softmax（一次遍历完成，无需先求 max）

Causal Mask: 因果注意力掩码
  确保位置 i 只能看到位置 ≤ i 的 token
  实现：将 mask 矩阵的上三角设为 -∞
  Infra 优化：利用三角矩阵特性减少计算量
```

### Sampling 策略

```
Temperature Sampling: T 控制随机性
  T→0: 贪心（确定性）
  T→1: 标准概率
  T>1: 更随机

Top-K: 只从概率最高的 K 个 token 中采样
Top-P (Nucleus): 从累积概率达到 P 的最小 token 集合中采样
```

### vLLM Paged Attention 工程细节

```
Flattened 布局：
  所有请求的 KV Cache Block 存储在一块连续显存中
  通过 slot_mapping 映射逻辑位置到物理位置

slot_mapping 寻址：
  token_position → logical_block → physical_block
  每次 forward pass 前更新映射

cu_seqlens 请求隔离：
  累积序列长度数组，标记每个请求在 batch 中的边界
  [0, len_A, len_A+len_B, ...]
  用于 Flash Attention 的高效计算
```

### Continuous Batching 实现

```
Static Batching:
  batch = [req_A, req_B, req_C]
  等全部完成 → 下一批
  短请求被长请求拖累

Continuous Batching:
  调度器维护 running queue 和 waiting queue
  每个 step 结束后：
    - 完成的请求移出 running
    - waiting 中的新请求移入 running
    - 保持 GPU 持续忙碌
```

## 摘录

> Infra 优化本质是用数学等价变换或精度妥协换取更高硬件利用率和极致推理速度。RMSNorm 通过砍掉均值计算将两次全局规约简化为一次，显著降低访存开销——这不是工程 trick，而是数学上的等价简化。（万字入门AI Infra）

> 通过深入阅读 vLLM 源码，以 Llama 3 为例系统梳理大模型推理核心原理。围绕 Continuous Batching 和 Paged Attention 两大关键概念，详细追踪推理各环节的张量维度变化，以及 vLLM 中 Flattened 布局、slot_mapping 寻址、cu_seqlens 请求隔离等工程实现细节。（AI Infra入门干货总结）

## 涉及实体

- [[vLLM]] —— 本文的核心分析对象，Paged Attention 和 Continuous Batching 的工程实现
- [[RAG]] —— RAG 系统的底层推理依赖 vLLM 等推理框架

## 涉及主题

- [[AI-Infra推理优化-主题]]

## 我的评注

这两篇文章的组合阅读效果很好：一篇从数学原理入手（为什么这么做），一篇从工程实现入手（怎么做的）。核心洞察是：大模型推理优化的每一步都是"数学等价变换 → 减少访存 → 提升硬件利用率"的循环。Paged Attention 的 OS 虚拟内存类比特别优雅——把一个系统编程的经典思想搬到了 GPU 显存管理上。
