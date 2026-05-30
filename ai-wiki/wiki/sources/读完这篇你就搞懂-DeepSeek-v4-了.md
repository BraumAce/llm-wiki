---
title: "读完这篇你就搞懂 DeepSeek v4 了"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/MamimcCQj_Hd12T8iFVmKg"
author: "dorian (腾讯技术工程)"
ingested_at: 2026-05-30
tags: [deepseek, deepseek-v4, llm, large-language-model, model-introduction]
related_entities: [DeepSeek]
related_topics: [llm-architecture, model-training]
---

# 读完这篇你就搞懂 DeepSeek v4 了

## 一句话概括
一篇面向大众的 DeepSeek v4 模型介绍文章，旨在帮助读者快速理解 DeepSeek 第四版大语言模型的核心特性与技术亮点。

## 实践内容
DeepSeek V4 模型参数与核心架构：

**模型规格**
- DeepSeek-V4-Pro：1.6T参数，稀疏激活49B，1M上下文
- DeepSeek-V4-Flash：284B参数，稀疏激活13B，1M上下文
- 两个模型均为独立预训练的MoE，非蒸馏关系
- 两档均默认1M上下文，服务端不再区分长/短模型

**架构创新（三项核心机制）**

1. mHC（Manifold-Constrained Hyper-Connections）：多流约束残差连接
   - 标准残差单流直传→HC多流+自由映射→mHC多流+约束映射
   - 残差映射矩阵Hres限制为双随机矩阵（每行和=1、每列和=1、元素非负）
   - 降流/升流矩阵通过sigmoid限制在(0,1)
   - 基于双随机矩阵乘法封闭特性，确保历史层系数均在(0,1)之间，解决梯度消失/爆炸
   - 理论上可达通道数m种函数表示路径，提升网络表达能力

2. CSA（Compressed Sparse Attention）：压缩稀疏注意力
   - 将token分组，每组m个token，通过可学习权重矩阵压缩
   - 连续两组压缩内容拼接保证语义连贯性
   - 闪电索引机制：快速计算token与压缩"纪要"的关联度，选择top-k进行精确计算
   - 公式：压缩权重S由值投影矩阵C和Z计算，W矩阵和偏置B均可学习

3. HCA（Heavily Compressed Attention）：高度压缩注意力
   - 每组m'个token（m'>>m），无需连续两组拼接
   - 与CSA共享KV的注意力计算方式
   - 实践：HCA定位关联度高的"大块信息"→CSA稀疏注意力精确计算

**Infra优化**
- MoE专家网络：更细粒度的计算通信重叠调度，消除气泡
- TileLang：面向tile的高级抽象语言，数据流逻辑与调度策略解耦
- 批无关性（Batch-Invariant）：注意力计算和矩阵乘法保证bit级别一致输出
- 计算确定性（Determinism）：固定浮点累加顺序，使用DeepGEMM矩阵乘法库

**训练优化**
- FP4量化感知训练：MoE专家权重量化为FP4，CSA闪电索引q/K采用FP4，打分保留BF16
- Muon优化器：梯度正交化提升稳定性，QK预RMSNorm解决Logits爆炸
- mHC额外耗时压至6.7%：定制计算内核+选择性重算+调整流水线节奏

**推理优化**
- 异构KV Cache架构：针对CSA/HCA/SWA不同结构设计专用缓存
- KV Cache持久化：system prompt和知识库文档的KV持久化到磁盘，SWA提供三档取舍方案

## 摘录
> V4真正硬核的地方绝不仅仅是1.6T参数+1M上下文，而是从attention到kernel的系统级重构与优化。1M上下文绝不仅仅是"能写更长的prompt"，而是让Agent、整库代码、长文档等任务的执行真正可以高效执行并落地。一个跑30轮的Coding Agent，每轮往上下文里塞用户指令+源文件+shell命令+reasoning trace，30轮下来数十万token起步是常态。

> 传统Transformer架构要突破到1M上下文时代，必须同时解决三个问题：升级为多条稳定可靠的通道且每层可控制前序层贡献值、GPU能在有效时间内算的过来显存也能存的下、万亿参数深度更大的模型网络训练更加稳定与规范化。mHC将残差映射矩阵限制为双随机矩阵，基于乘法封闭特性从根本上解决梯度消失/爆炸问题。

> CSA引入"会议记录员"机制，将token分组压缩并通过可学习权重保留每个token的独到见解，再通过闪电索引选择高关联度纪要进行精确计算。HCA则像"速记员"处理更大分组，两者配合实现"内容海选-内容精选-稀疏采样&精确计算"的三层处理，大幅优化超长上下文的注意力计算量和KV-Cache消耗量。

> FP4量化感知训练的核心思想：与其让模型训练完再被粗暴量化掉一波精度，不如在训练过程中就让模型"预演"低精度计算，提前适应量化带来的数值扰动。MoE专家权重量化为FP4压缩收益最大，但闪电索引打分保留BF16因为排序对数值精度敏感——就像搬家时被子抽真空压缩，但衣服只能叠起来放否则会压坏。

## 涉及实体
- DeepSeek —— 被介绍的大语言模型及其开发团队

## 涉及主题
- LLM Architecture —— DeepSeek v4 的模型架构设计
- Model Training —— DeepSeek v4 的训练策略与方法
