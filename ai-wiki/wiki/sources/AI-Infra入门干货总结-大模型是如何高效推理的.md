---
title: "AI-Infra入门干货总结-大模型是如何高效推理的"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/gCRMjGry2EmBmv1CFfCzVQ"
author: "腾讯技术工程"
ingested_at: 2026-05-29
tags: [ai-infra, vllm, paged-attention]
related_entities: [vLLM, RAG]
related_topics: [AI-Infra推理优化-主题]
---

# AI-Infra入门干货总结-大模型是如何高效推理的

## 一句话概括
本文以 vLLM 源码为蓝本，以 Llama 3 为例深入追踪大模型推理全流程中每个计算环节的张量维度变化，系统讲解 Continuous Batching、Paged Attention、FlashAttention 等核心 AI Infra 优化技术的原理与工程实现。

## 摘录
> 有没有可能将调度的从request level下沉到token level呢？恭喜你发明了continuous batching。那每个请求的KV Cache显存申请是不是应该也是token level，不要一次申请所有的显存。搞一个地址数组(block table)来维护每个请求的KV Cache地址就好？恭喜你发明了Paged Attention。没错，以上两个概念是当今大模型得以高性能运行的关键。

> PagedAttention 的虚拟页表机制解决了显存碎片的问题，极大地提升了 GPU 的显存利用率，是支撑 Continuous Batching 高性能推理的基础。然而PagedAttention 引入的 block_table 间接寻址机制，打破了一个请求在物理显存上的绝对连续性。当 Attention Kernel 跨越 block 读取历史 KVCache 时，会触发离散访存（Uncoalesced Access），这在底层对 Memory Controller 是非常不友好的。

> Prefill阶段：QKV_Proj、Attention、O_Proj、MLP 本质上都是稠密矩阵乘法（GEMM），其实就是通过请求内token-level计算复用模型权重，因此算术强度极高，使得 GPU 在 Prefill 阶段主要受限于 Tensor Cores 的物理算力峰值，属于计算密集型（Compute-bound）。Decode阶段：由于自回归特性，每次只处理一个 Token（query_lens = 1），若无优化，此时QKV_Proj、Attention、O_Proj、MLP全都退化为矩阵向量乘法（GEMV）。虽然计算量不大，但需要把巨大的 KV Cache和模型权重 从 HBM 搬运到 SRAM，非常吃显存带宽，因此Decode阶段是典型的访存密集型（Memory-bound）。

## 涉及实体
- [[vLLM]] —— 本文以 vLLM 源码为蓝本解析推理全流程
- [[RAG]] —— 文末提及 RAG 等应用方向

## 涉及主题
- [[AI-Infra推理优化-主题]]
