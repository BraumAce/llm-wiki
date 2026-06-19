---
title: "拆解大模型几项核心操作背后的数学与 Infra 优化逻辑"
type: source
date: 2026-06-19
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/V727TpGvRjo5RvYRGZl6oA"
author: "腾讯技术工程"
ingested_at: 2026-06-19
tags:
  - ai-infra
  - inference
  - flashattention
  - softmax
  - kv-cache
  - vllm
related_entities:
  - "[[vLLM]]"
  - "[[KV-Cache]]"
  - "[[Token成本控制]]"
related_topics:
  - "[[AI-Infra推理优化-主题]]"
---

# 拆解大模型几项核心操作背后的数学与 Infra 优化逻辑

## 一句话概括

这篇从 RMSNorm、Softmax、Causal Mask、Online Softmax、FlashAttention、LSE、Flash-Decoding Split-K、Gumbel-Max Sampling 等操作入手，说明 AI Infra 优化常常是用数学等价变换、数值稳定重写或可接受的架构简化换取访存局部性、并行度和 Kernel 融合空间。

## 实践内容

### RMSNorm vs LayerNorm

- LayerNorm 做平移（减均值）+ 缩放（除标准差），能约束特征尺度，但需要维护均值相关统计量。
- RMSNorm 基于"缩放比平移更关键"的经验判断，去掉均值，只保留 RMS 尺度归一化。
- 工程收益主要来自减少寄存器/SRAM 占用、少一次均值相关状态、少大量 element-wise 减法和 bias load。

### Attention 的数值稳定处理

| 操作 | 作用 | 生命周期 | 维度 |
|---|---|---|---|
| Safe Softmax `-M` | 防止指数上溢 | 训练 + 推理 | 硬件数值范围 |
| Causal Mask | 阻止看到未来 token | 训练 + Prefill | 序列长度 |
| `1/sqrt(d_k)` | 防止 logits 方差随维度膨胀 | 训练 + 推理 | head hidden size |
| Temperature | 控制生成随机性 | 仅推理 | 词表 |
| Online Softmax | 把 3 Pass 访存降为流式计算 | 训练 + 推理 | tile/block |

### FlashAttention Online Softmax 状态

```text
for kv_block in KV_Cache:
    S_local = Q @ kv_block.K.T
    m_new = max(m_old, max(S_local))
    scale = exp(m_old - m_new)
    l_new = l_old * scale + sum(exp(S_local - m_new))
    O_new = O_old * scale + exp(S_local - m_new) @ kv_block.V
    m_old = m_new

O_final = O_new / l_new
```

FlashAttention 把 QK、Safe/Online Softmax、PV 三段融合进一次 tile 流水线，让注意力矩阵不写回 HBM，只写最终输出和 LSE。

### vLLM 中的 Gumbel-Max Sampling

```python
q = torch.empty_like(probs)
probs = logits.softmax(dim=-1)
q.exponential_()
probs.div_(q).argmax(dim=-1)
```

Gumbel-Max 把传统需要前缀和的 Multinomial Sampling 转成 element-wise 噪声 + argmax。它适合 GPU 并行，并且在词表被张量并行切到多卡时，只需要各卡本地最大值加一次全局 max-with-index 规约。

## 摘录

> Infra 优化，本质上就是在用数学上的等价变换，或者对精度的适度妥协，去换取更高的硬件利用率和极致的推理速度。无论是 Normalization、Softmax 还是 Gumbel-Max 相关操作，核心逻辑始终如一。

> 过去实现 Causal Mask 需要在显存中生成一个庞大的 N x N 掩码矩阵并与注意力分数相加，在长文本下会引发灾难性的访存瓶颈。如今的 FlashAttention 等高性能算子直接在底层引入块稀疏机制，根据当前分块的行列索引分类处理，不再在全局显存中生成掩码。

## 涉及实体

- [[vLLM]] —— 文章用 vLLM 的 Gumbel-Max 采样实现说明 Serving 框架如何把概率抽样改写成 GPU 友好的规约。
- [[KV-Cache]] —— Attention 推理阶段围绕历史 K/V 的存储、分块、Gather 和 Split-K 展开。
- [[Token成本控制]] —— 从 Infra 层解释 KV Cache 与 Prompt Cache 省成本的根源。

## 涉及主题

- [[AI-Infra推理优化-主题]]

## 我的评注

这篇适合补强 AI Infra 主题的"为什么"：很多推理优化并非工程黑魔法，而是把全局依赖改成可分块、把除法改成减法/指数、把串行前缀和改成并行 argmax。它也提醒上层 Agent/Harness 工程师，Token 成本和延迟最终受底层 attention、cache、sampling 与并行调度约束。
