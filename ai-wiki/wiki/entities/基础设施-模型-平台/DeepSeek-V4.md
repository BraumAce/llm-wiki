---
title: "DeepSeek-V4"
type: entity
date: 2026-05-30
also_known_as:
  - "DeepSeek V4"
  - "DeepSeek-V4-Pro"
  - "DeepSeek-V4-Flash"
  - "深度求索 V4"
tags:
  - llm
  - moe
  - open-source
  - ai-infra
  - long-context
  - reasoning
  - chinese-ai
sources:
  - "[[串讲LLM和Agent的核心原理以及各种术语]]"
  - "[[AI-Infra入门干货总结-大模型是如何高效推理的]]"
related_entities:
  - "[[vLLM]]"
  - "[[RAG]]"
  - "[[Harness-Engineering]]"
---

# DeepSeek-V4

## 一句话定义

DeepSeek-V4 是深度求索（DeepSeek）于 2026 年 4 月发布的第四代开源大语言模型系列，采用混合专家（MoE）架构，包含 1.6 万亿参数的 Pro 版和 2840 亿参数的 Flash 版，支持 100 万 token 上下文窗口，以 MIT 许可证开源。

## 摘要

DeepSeek-V4 是中国 AI 公司深度求索在 V3（2024 年底）和 V3.2（2025 年底）之后推出的第四代旗舰模型。该系列在架构上实现了多项关键创新：混合注意力架构（CSA + HCA）解决了超长上下文的效率瓶颈，流形约束超连接（mHC）增强了深层网络的信号传播稳定性，FP4 + FP8 混合精度训练大幅降低了显存占用。在推理能力上，V4 引入了三档思考模式（Non-think / Think High / Think Max），在 LiveCodeBench、Codeforces 等编程竞赛基准上达到了与 GPT-5.4、Gemini 等前沿模型并驾齐驱的水平。

V4 的发布标志着开源大模型在参数规模（1.6T）、上下文长度（1M tokens）和推理能力三个维度上首次同时逼近甚至超越闭源前沿模型，对全球 AI 产业格局产生了深远影响。华为、寒武纪等芯片厂商已率先采用 V4 系列模型。

## 详情

### 起源与背景

深度求索由量化基金幻方量化于 2023 年创立，总部位于杭州。公司从成立之初就确立了"以开源推动 AGI"的技术路线，在 V1（2024 年初）到 V3（2024 年底）的快速迭代中逐步建立了"高性价比开源大模型"的品牌认知。V3 以 671B 参数、37B 激活参数的 MoE 架构在业界引起广泛关注，其 MLA（Multi-head Latent Attention）机制成为后续模型的重要参考。

2025 年底，DeepSeek 发布了 V3.2 系列（685B 参数），引入了 DSA（Lightning Indexer + Top-K 稀疏选择）等优化。V3.2 的成功为 V4 的架构创新奠定了基础。2026 年 4 月 24 日，DeepSeek 正式发布 V4 预览版，包含 Pro 和 Flash 两个变体，均以 MIT 许可证开源。同一时期，投资者开始与 DeepSeek 接触进行 3 亿美元融资，估值达 100 亿美元。

### 核心机制 / 工作原理

**1. 混合专家（MoE）架构**

V4 延续并强化了 DeepSeek 的 MoE 路线：

| 模型 | 总参数量 | 激活参数量 | 上下文长度 | 精度 |
|------|---------|-----------|-----------|------|
| DeepSeek-V4-Pro | 1.6T | 49B | 1M | FP4 + FP8 |
| DeepSeek-V4-Flash | 284B | 13B | 1M | FP4 + FP8 |

MoE 的核心思想是"大容量、小激活"——模型总参数量巨大以存储丰富的知识，但每次推理只激活少量专家（expert），从而在保持模型能力的同时控制计算成本。V4 的 MoE 路由采用了 DeepSeek 自研的 auxiliary-loss-free 负载均衡策略，避免了传统 MoE 中辅助损失对主任务性能的干扰。

**2. 混合注意力架构（CSA + HCA）**

这是 V4 最重要的架构创新之一。传统 Transformer 的标准注意力机制在超长上下文中面临二次复杂度瓶颈。V4 引入了两种压缩注意力机制：

- **CSA（Compressed Sparse Attention）**：压缩稀疏注意力，通过稀疏化注意力矩阵减少计算量，同时保留关键位置的精确注意力
- **HCA（Heavily Compressed Attention）**：重度压缩注意力，对远距离上下文进行更激进的压缩，进一步降低长序列的计算和显存开销

这一设计使得 V4 在 100 万 token 上下文下，单 token 推理 FLOPs 仅为 V3.2 的 27%，KV Cache 显存占用仅为 V3.2 的 10%。

**3. 流形约束超连接（mHC）**

Manifold-Constrained Hyper-Connections 是对传统残差连接（residual connection）的增强。在深层 Transformer 中，残差连接虽然缓解了梯度消失问题，但在非常深的网络中信号传播仍会退化。mHC 通过流形约束确保连接的表达能力，同时提升跨层信号传播的稳定性。

**4. Muon 优化器**

V4 采用了 Muon 优化器替代传统的 Adam/AdamW，实现了更快的收敛速度和更好的训练稳定性。这对于 1.6T 参数规模的模型训练至关重要。

**5. FP4 + FP8 混合精度**

V4 在训练和推理中采用混合精度策略：MoE 专家参数使用 FP4 精度以节省显存，其他参数使用 FP8 精度。这种混合精度设计在不显著损失模型质量的前提下大幅降低了显存需求，使得 1.6T 参数模型的部署变得更加可行。

**6. 三档推理模式**

V4 引入了灵活的推理模式切换：

| 模式 | 描述 | 适用场景 |
|------|------|---------|
| Non-think | 快速直觉式响应 | 日常对话、简单任务 |
| Think High | 有意识的逻辑分析，较慢但更准确 | 复杂推理、代码编写 |
| Think Max | 推理能力最大化（建议上下文 ≥ 384K） | 竞赛级编程、数学证明 |

### 训练流程

V4 的后训练采用两阶段流程：

1. **独立培养阶段**：通过 SFT（监督微调）和 GRPO（Group Relative Policy Optimization）强化学习，分别培养各领域专家
2. **统一整合阶段**：通过 on-policy 蒸馏将各领域专家的能力整合到单一模型中

预训练数据量超过 32 万亿 token，涵盖多语言、多领域的高质量数据。

### 应用 / 使用场景

- **代码生成与编程竞赛**：V4-Pro 在 LiveCodeBench 上达到 93.5 分，Codeforces Rating 达到 3206，与 GPT-5.4 并列第一
- **长文档处理**：100 万 token 上下文窗口支持整本书籍、大型代码库的分析
- **数学推理**：在 HMMT 2026 数学竞赛基准上达到 95.2 分
- **Agent 与工具调用**：V4 的推理模式切换使其适合作为 AI Agent 的底层模型
- **企业级部署**：Flash 版本（284B / 13B 激活）适合资源受限的生产环境
- **芯片适配**：华为、寒武纪等国产芯片厂商已率先完成 V4 的适配和优化

### 局限与争议

- **数据合规争议**：2026 年 2 月，Anthropic 指控 DeepSeek 使用数千个欺诈账户与 Claude 生成数百万条对话用于训练数据，引发行业对训练数据合规性的广泛讨论
- **模型规模与部署成本**：Pro 版 1.6T 参数对推理基础设施要求极高，即使采用 FP4 + FP8 混合精度，仍需要大量 GPU 资源
- **Think Max 模式的资源消耗**：最大推理模式建议 384K 以上上下文窗口，实际使用中 token 消耗巨大
- **开源许可证的商业影响**：MIT 许可证虽然宽松，但 V4 的巨大规模意味着实际部署成本仍然高昂，"开源但难以本地运行"的矛盾依然存在
- **与闭源模型的差距**：在 GPQA Diamond（90.1 vs 94.3）和 MMLU-Pro（87.5 vs 91.0）等知识密集型基准上，V4 仍略逊于 Gemini 等前沿闭源模型

## 与其他实体的关系

- [[vLLM]] —— V4 的推理部署可通过 vLLM 框架实现，vLLM 的 Paged Attention 和 Continuous Batching 是 V4 高效推理的基础设施支撑
- [[RAG]] —— V4 的 100 万 token 上下文窗口使传统 RAG 的"检索 + 拼接"模式面临重新审视，超长上下文可能替代部分 RAG 场景
- [[Harness-Engineering]] —— V4 的三档推理模式为 Harness 设计提供了新的控制维度，Harness 可以根据任务复杂度动态切换推理模式
- [[OpenClaw]] —— OpenClaw 等 Agent 框架支持 DeepSeek 系列模型作为后端 LLM

## 参考来源

- [[串讲LLM和Agent的核心原理以及各种术语]] —— 介绍了 DeepSeek V3 与 R1 的关系，以及推理模型与普通对话模型的区别
- [[AI-Infra入门干货总结-大模型是如何高效推理的]] —— 提及 DeepSeek MLA/DSA 等注意力优化技术的发展脉络

## 相关阅读

- [DeepSeek-V4-Pro Hugging Face 模型卡](https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro)
- [DeepSeek-V4-Flash Hugging Face 模型卡](https://huggingface.co/deepseek-ai/DeepSeek-V4-Flash)
- [DeepSeek 官方 GitHub](https://github.com/deepseek-ai)
- [DeepSeek 官方网站](https://www.deepseek.com)
