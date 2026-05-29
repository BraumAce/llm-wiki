---
title: "vLLM"
type: entity
date: 2026-05-29
also_known_as:
  - "Virtual LLM"
tags:
  - ai-infra
  - inference
  - serving
  - open-source
  - gpu
sources:
  - "[[ByteLighting-2026年5月技术阅读合集]]"
related_entities:
  - "[[RAG]]"
---

# vLLM

## 一句话定义

vLLM 是一个开源的大模型推理和服务框架，以 Paged Attention 和 Continuous Batching 两大核心技术实现高吞吐、低延迟的 LLM 推理，是当前生产环境中最广泛使用的 LLM Serving 方案之一。

## 摘要

vLLM 由 UC Berkeley 的 SkyLab 团队开发，最初以 Paged Attention 论文（2023）闻名。它解决了大模型推理中的核心矛盾：**GPU 显存有限 vs 推理请求的 KV Cache 需求巨大**。传统方案为每个请求预分配最大长度的连续显存，导致大量浪费。vLLM 借鉴操作系统虚拟内存的分页思想，把 KV Cache 切成固定大小的 Block，按需分配、动态回收，显存利用率提升 2-4 倍。

Continuous Batching 则解决了另一个问题：传统 Static Batching 要等一个 batch 全部完成才能处理下一批，短请求被长请求拖累。vLLM 实现了请求级别的动态调度——短请求完成后立即让出资源给新请求，GPU 利用率显著提升。

2026 年的 vLLM 已经成为 LLM 推理的事实标准之一，支持 Llama、Qwen、DeepSeek 等主流模型，被广泛用于生产环境的 API 服务。

## 详情

### 起源与背景

大模型推理面临两个核心挑战：显存管理和批处理效率。以 Llama 3 70B 为例，单个请求的 KV Cache 可能占用数 GB 显存，而一个 80GB 的 A100 GPU 同时服务的请求数受限于显存容量。传统方案的显存碎片化问题严重——预分配的最大长度往往远超实际使用量。

2023 年，UC Berkeley 的 Woosuk Kwon 等人提出 Paged Attention，发表论文 "Efficient Memory Management for Large Language Model Serving with PagedAttention"。vLLM 作为论文的开源实现迅速获得关注，并在 2024-2025 年间成为生产环境的主流选择。

### 核心机制 / 工作原理

**Paged Attention（分页注意力）**：

传统 Attention 要求 KV Cache 在显存中连续存储。Paged Attention 借鉴 OS 的虚拟内存分页机制：

```
传统方案（连续分配）:
请求 A: [KV Cache 0-7] [空闲 8-15]  ← 预分配 16 个 slot，只用了 8 个
请求 B: [KV Cache 16-19] [空闲 20-23] ← 预分配 8 个 slot，只用了 4 个

Paged Attention（分页分配）:
物理 Block Pool: [B0][B1][B2][B3][B4][B5]...
请求 A: Page Table → B0, B1, B2       ← 按需分配
请求 B: Page Table → B3, B4           ← 无碎片
```

每个 Block 存储固定数量的 token 的 KV Cache（如 16 个 token）。Block 可以不连续，通过 Page Table 映射到逻辑位置。

**Continuous Batching（连续批处理）**：

```
Static Batching:
时间 → [请求A,B,C 同时处理] [等待A完成] [请求D,E,F]...

Continuous Batching:
时间 → [A,B,C] [A完成,D加入,B,C继续] [B完成,E加入,C,D继续]...
```

**Flattened 布局与 slot_mapping**：

vLLM 内部用 Flattened 布局管理所有请求的 KV Cache Block：
- `slot_mapping`：每个 token 对应的物理 Block 位置
- `cu_seqlens`：累积序列长度，用于请求隔离
- 每次 forward pass 前更新映射关系

### 应用 / 使用场景

- **生产 API 服务**：为 ChatBot、Agent 等应用提供高吞吐推理
- **批量推理**：数据处理、内容生成等离线任务
- **多模型服务**：同一集群服务多个不同规模的模型
- **边缘部署**：配合量化模型在消费级 GPU 上运行

### 局限与争议

- **显存开销**：Page Table 本身需要额外显存，对小模型可能不划算
- **调度复杂度**：Continuous Batching 的调度器增加了系统复杂度
- **与其他框架竞争**：TensorRT-LLM（NVIDIA）、SGLang 等方案在特定场景下可能更优
- **版本迭代快**：API 和配置项变化频繁，升级成本不低

## 与其他实体的关系

- [[RAG]] —— RAG 系统的底层推理通常由 vLLM 提供服务
- [[Harness-Engineering]] —— AI Infra 是 Harness 的基础设施层，vLLM 的性能直接影响 Agent 的响应速度

## 参考来源

- [[ByteLighting-2026年5月技术阅读合集]] —— vLLM 源码深度解读、AI Infra 入门等文章
