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
  - "[[AI-Infra入门干货总结-大模型是如何高效推理的]]"
  - "[[万字入门AI-Infra-深入理解大模型中的数学与Infra优化]]"
related_entities:
  - "[[RAG]]"
---

# vLLM

## 一句话定义

vLLM 是一个开源的大模型推理和服务框架，以 Paged Attention 和 Continuous Batching 两大核心技术实现高吞吐、低延迟的 LLM 推理，是当前生产环境中最广泛使用的 LLM Serving 方案之一。

## 摘要

vLLM 由 UC Berkeley 的 SkyLab 团队开发，最初以 Paged Attention 论文（2023）闻名。它解决了大模型推理中的核心矛盾：**GPU 显存有限 vs 推理请求的 KV Cache 需求巨大**。传统方案为每个请求预分配最大长度的连续显存，导致大量浪费。vLLM 借鉴操作系统虚拟内存的分页思想，把 KV Cache 切成固定大小的 Block，按需分配、动态回收，显存利用率提升 2-4 倍。

Continuous Batching 则解决了另一个问题：传统 Static Batching 要等一个 batch 全部完成才能处理下一批，短请求被长请求拖累。vLLM 实现了请求级别的动态调度——短请求完成后立即让出资源给新请求，GPU 利用率显著提升。

## 详情

### 核心机制 / 工作原理

**Paged Attention（分页注意力）**：

传统 Attention 要求 KV Cache 在显存中连续存储。Paged Attention 借鉴 OS 的虚拟内存分页机制，每个 Block 存储固定数量的 token 的 KV Cache，Block 可以不连续，通过 Page Table 映射到逻辑位置。

**Continuous Batching（连续批处理）**：

传统 Static Batching 要等整批完成；Continuous Batching 在每个 step 结束后动态调度——完成的请求移出，新请求移入，保持 GPU 持续忙碌。

**Flattened 布局与 slot_mapping**：

vLLM 内部用 Flattened 布局管理所有请求的 KV Cache Block，通过 `slot_mapping` 映射逻辑位置到物理位置，`cu_seqlens` 累积序列长度用于请求隔离。

### 应用 / 使用场景

- **生产 API 服务**：为 ChatBot、Agent 等应用提供高吞吐推理
- **批量推理**：数据处理、内容生成等离线任务
- **多模型服务**：同一集群服务多个不同规模的模型

### 局限与争议

- **显存开销**：Page Table 本身需要额外显存，对小模型可能不划算
- **调度复杂度**：Continuous Batching 的调度器增加了系统复杂度
- **与其他框架竞争**：TensorRT-LLM（NVIDIA）、SGLang 等方案在特定场景下可能更优

## 与其他实体的关系

- [[RAG]] —— RAG 系统的底层推理通常由 vLLM 提供服务
- [[Harness-Engineering]] —— AI Infra 是 Harness 的基础设施层

## 参考来源

- [[AI-Infra入门干货总结-大模型是如何高效推理的]] —— vLLM 源码深度解读
- [[万字入门AI-Infra-深入理解大模型中的数学与Infra优化]] —— 大模型核心操作的数学原理
