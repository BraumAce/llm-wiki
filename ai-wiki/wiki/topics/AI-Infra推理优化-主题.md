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
  - "[[Agent-Memory]]"
sources:
  - "[[万字入门AI-Infra-深入理解大模型中的数学与Infra优化]]"
  - "[[AI-Infra入门干货总结-大模型是如何高效推理的]]"
  - "[[RAG全链路技术详解]]"
  - "[[腾讯云Agent-Memory节省61-Percent-Token提升52-Percent成功率]]"
  - "[[深度解析腾讯云Agent-Memory-4层渐进式记忆管道]]"
  - "[[AI记忆的Git版本控制-Memoir-分层路径替代向量数据库]]"
  - "[[Spring-AI-Session-API-大多数人用ChatMemory用错了场景]]"
---

# AI Infra 推理优化主题

## 主题定义

AI Infra 推理优化涵盖大模型推理服务的完整技术栈——从底层的数学原理到工程实现，再到上层的 RAG 检索增强生成和 Agent Memory 系统。

## 核心要点

1. **Infra 优化的本质是数学等价变换**：RMSNorm 砍掉均值计算将两次全局规约简化为一次，是数学简化而非工程 trick
2. **Paged Attention 是 OS 虚拟内存在 GPU 上的重演**：借鉴分页思想把 KV Cache 切成固定大小 Block，显存利用率提升 2-4 倍
3. **Continuous Batching 消除短请求被长请求拖累**：每个 step 结束后动态调度
4. **vLLM 已成为 LLM Serving 的事实标准**：Flattened 布局 + slot_mapping + cu_seqlens
5. **RAG 全链路已形成完整工程方法论**：Meta-Chunking、HyDE、Graph RAG、Ragas 评估
6. **Agent Memory 的三种哲学**：渐进式压缩（腾讯云）、结构化组织（Memoir）、双层分离（Spring AI）
7. **记忆即版本控制**：Memoir 把 Git 的 branch/commit/merge/rollback 搬进记忆层

## 涉及实体

- [[vLLM]] —— LLM 推理框架的事实标准
- [[RAG]] —— 检索增强生成
- [[Agent-Memory]] —— Agent 记忆系统

## 对比矩阵

| 维度 | vLLM | TensorRT-LLM | SGLang |
|------|---|---|---|
| 开源 | 是 | 部分 | 是 |
| 核心技术 | Paged Attention | TRT 优化 | RadixAttention |

| 维度 | 传统 RAG | LLM Wiki | Graph RAG |
|------|---|---|---|
| 知识更新 | 实时 | 需重新编译 | 实时 |
| 查询延迟 | 高 | 低 | 高 |

## 关键来源

- [[AI-Infra入门干货总结-大模型是如何高效推理的]] —— vLLM 源码解读
- [[万字入门AI-Infra-深入理解大模型中的数学与Infra优化]] —— 数学原理
- [[RAG全链路技术详解]] —— RAG 全链路
