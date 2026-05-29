---
title: "AI Infra 推理优化主题"
type: topic
date: 2026-05-29
tags:
  - ai-infra
  - inference
  - optimization
  - gpu
  - vllm
related_entities:
  - "[[vLLM]]"
  - "[[RAG]]"
sources:
  - "[[AI-Infra推理优化-从数学原理到vLLM工程实现]]"
  - "[[ByteLighting-2026年5月技术阅读合集]]"
---

# AI Infra 推理优化主题

## 主题定义

AI Infra 推理优化涵盖大模型推理服务的完整技术栈——从底层的数学原理（RMSNorm、Softmax、Causal Mask、Sampling）到工程实现（Paged Attention、Continuous Batching、显存管理），再到上层的 RAG 检索增强生成。不包括模型训练、微调或数据处理。

## 核心要点

1. **Infra 优化的本质是数学等价变换**：用数学等价变换或精度妥协换取更高硬件利用率和极致推理速度。RMSNorm 砍掉均值计算将两次全局规约简化为一次，是数学简化而非工程 trick
2. **Paged Attention 是 OS 虚拟内存在 GPU 上的重演**：借鉴分页思想把 KV Cache 切成固定大小 Block，按需分配、动态回收，显存利用率提升 2-4 倍
3. **Continuous Batching 消除短请求被长请求拖累**：传统 Static Batching 要等整批完成；Continuous Batching 在每个 step 结束后动态调度，短请求完成即让出资源
4. **vLLM 已成为 LLM Serving 的事实标准**：支持 Llama、Qwen、DeepSeek 等主流模型，Flattened 布局 + slot_mapping + cu_seqlens 的工程实现精巧高效
5. **RAG 全链路已形成完整工程方法论**：Meta-Chunking 语义切分、HyDE 假设性文档嵌入、Graph RAG 多跳推理、Ragas 四维评估体系——从"能用"到"好用"的工程化闭环
6. **LLM Wiki 挑战 RAG 的"每次检索"模式**：用 AI 一次性把素材编译成结构化 Wiki，后续查询直接翻阅——"一次学习、永久可用"vs"每次从头检索"
7. **Sampling 策略直接影响输出质量**：Temperature / Top-K / Top-P 的选择不是超参调优问题，而是应用场景决定的工程决策

## 涉及实体

- [[vLLM]] —— LLM 推理框架的事实标准，Paged Attention + Continuous Batching
- [[RAG]] —— 检索增强生成，全链路工程实践

## 演进时间线

- 2020：Meta 提出 RAG 概念
- 2023：Paged Attention 论文发表，vLLM 开源
- 2024：RAG 工程化（LangChain / LlamaIndex），vLLM 成为主流
- 2025：Graph RAG、Meta-Chunking 等进阶技术成熟
- 2026-Q1：LLM Wiki / GBrain 等"知识编译"方案挑战传统 RAG
- 2026-05：推理优化深入到数学原理层面，AI Infra 入门文章大量涌现

## 对比矩阵

| 维度 | vLLM | TensorRT-LLM | SGLang |
|------|---|---|---|
| 开源 | 是 | 部分 | 是 |
| 核心技术 | Paged Attention | TRT 优化 | RadixAttention |
| 适用场景 | 通用 Serving | NVIDIA 极致优化 | 结构化生成 |
| 生态 | 最活跃 | NVIDIA 绑定 | 快速增长 |
| 部署复杂度 | 中 | 高 | 低 |

| 维度 | 传统 RAG | LLM Wiki | Graph RAG |
|------|---|---|---|
| 知识更新 | 实时 | 需重新编译 | 实时 |
| 查询延迟 | 高（每次检索） | 低（直接翻阅） | 高（多跳） |
| 知识结构 | 扁平 | 层次化 | 图谱 |
| 适用场景 | 频繁更新的知识库 | 稳定知识 | 复杂关系推理 |

## 关键来源

- [[AI-Infra推理优化-从数学原理到vLLM工程实现]] —— 3 篇文章的综合技术解析
- [[ByteLighting-2026年5月技术阅读合集]] —— 原始阅读合集
