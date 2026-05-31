---
title: "MiniCPM5-1B"
type: entity
date: 2026-05-31
also_known_as:
  - "MiniCPM 5 1B"
  - "端侧文本小钢炮"
  - "MiniCPM5"
tags:
  - llm
  - small-language-model
  - on-device
  - open-source
  - openbmb
  - modelbest
  - tsinghua
sources:
  - "[[MiniCPM5-1B-GitHub]]"
related_entities:
  - "[[vLLM]]"
---

# MiniCPM5-1B

## 一句话定义

MiniCPM5-1B 是面壁智能联合清华大学、OpenBMB 开源社区发布的 1B 参数端侧文本基座模型，在 AA-Index 榜单上超越所有 2B 以下模型，INT4 量化后仅 0.5GB，可运行在手机、浏览器甚至纯 CPU 环境中。

## 摘要

MiniCPM5-1B 是 2026 年 5 月面壁智能（ModelBest）联合清华大学 THUNLP、OpenBMB 开源社区发布的端侧文本基座大模型。作为 MiniCPM 系列的最新成员，它以仅 1B 参数规模在全球权威榜单 Artificial Analysis（AA-Index）上取得 17.9 分，超越参数量翻倍的 Qwen3.5-2B（16.3 分），成为 2B 以下参数规模综合能力最强的开源基座模型。模型采用标准 LlamaForCausalLM 架构，无自定义内核，支持混合推理（Think/No-Think 模式切换），INT4 量化后权重仅 0.5GB。配套生态覆盖 7 种推理后端（Transformers、SGLang、vLLM、llama.cpp、Ollama、MLX、ArcLight）和 5 种微调框架（TRL+PEFT、LLaMA-Factory、ms-swift、unsloth、xtuner），并适配英伟达、华为昇腾等多芯片平台。其 Base Model 由全球首个完全由 AI 编写的训练框架 ForgeTrain 预训练完成，训练速度比英伟达 Megatron 快 10%，验证了"AI 制造 AI"的递归自改进（RSI）路径。

## 详情

### 起源与背景

MiniCPM5-1B 由面壁智能（ModelBest Inc.）联合清华大学自然语言处理实验室（THUNLP）和 OpenBMB 开源社区共同开发。面壁智能是中国领先的大模型创业公司，持续推动端侧大模型的智能密度提升。MiniCPM 系列从 MiniCPM 1.0 到 MiniCPM4/4.1 再到 MiniCPM5-1B，一直专注于在极小参数规模下追求极致性能。

MiniCPM5-1B 的发布是"端侧大模型开源周"（2026 年 5 月 25-29 日）的第二弹活动。面壁智能提出了"密度定律"：大模型的智能密度正在以约每 3.5 个月翻一番的速度持续提升。MiniCPM5-1B 进一步验证了这一趋势——相比 3 个月前发布的 Qwen3.5-2B，参数量减少一半，效果反而更优。

### 核心机制 / 工作原理

**模型架构**

MiniCPM5-1B 采用标准 `LlamaForCausalLM` 架构——无自定义内核、无模型代码分叉，确保与主流推理框架的完全兼容。

**三阶段训练流程**

```
Stage 1: Base Training
  → Stable + decay 训练，建立核心语言能力

Stage 2: Mid-Training
  → 使用 Ultra-FineWeb 数据集进行目标能力强化

Stage 3: Post-Training
  → SFT (200B deep-thinking + 200B hybrid-thinking tokens)
  → RL 强化学习
  → On-Policy Distillation (OPD) 在策略蒸馏
  → RL + OPD 组合提升平均分 ↑16 分，减少 max-tokens 预算命中 ↓29%
```

**分级数据治理体系（UltraData）**

预训练数据按质量从低到高划分为 L0 至 L4 五个等级，每一级对应不同的清洗、筛选和质量控制标准。针对三个关键语料方向开展大规模高质量合成：
- 高知识密度中文网页语料
- 高知识密度英文网页语料
- 高质量数学合成语料

配套开源的高质量合成数据集 Ultra-FineWeb-L3 供社区使用。

**混合推理（Hybrid Reasoning）**

内置 `<think>` 聊天模板，通过 `enable_thinking` 参数切换：
- **Think 模式**：深度推理，适合数学、代码等复杂任务（temperature=0.9, top_p=0.95）
- **No-Think 模式**：快速响应，适合日常对话（temperature=0.7, top_p=0.95）

**端侧部署**

INT4 量化后权重仅 0.5GB，支持多种运行环境：
- GPU 环境：直接跑 FP16
- 纯 CPU 环境：使用自研推理框架 ArcLight（github.com/OpenBMB/ArcLight）
- 浏览器环境：直接在浏览器中运行，零安装零配置

### 应用 / 使用场景

- **端侧 AI 桌宠**：MiniCPM-Desk-Pet 项目基于 MiniCPM5-1B 驱动本地桌面宠物，支持 LoRA 人格切换，可感知 Cursor/Claude Code/Codex 等编程工具的活动状态
- **手机端 AI 助手**：0.5GB 体积可在手机上流畅运行，断网也能使用
- **浏览器端 AI**：直接在网页中运行，无需安装任何软件
- **纯 CPU 推理**：配合 ArcLight 框架，无显卡设备也能流畅对话
- **Agent 工具调用**：支持 XML 风格工具调用，通过 SGLang 解析器转换为 OpenAI 兼容格式
- **代码生成与数学推理**：在同级参数中代码和数学能力最优
- **多平台微调**：支持 LLaMA-Factory、ms-swift 等 5 种微调框架，适配特定领域需求

### 局限与争议

- **参数规模限制**：1B 参数在复杂推理、长文本理解等任务上仍与大模型有明显差距，适合轻量级场景
- **ForgeTrain 未完全开源**：文章提及 ForgeTrain 是"全球首个完全由 AI 编写的训练框架"，但其代码尚未正式开源，可复现性待验证
- **密度定律的普适性**：面壁智能提出的"智能密度每 3.5 个月翻一番"的规律是否能持续成立，尚需更多数据验证
- **RSI 叙事的边界**：将 ForgeTrain 训练 MiniCPM5-1B 定义为"递归自改进"（RSI），但训练框架和被训练模型是两个不同的系统，与严格意义上的 RSI（同一系统改进自身）有区别
- **端侧应用场景有限**：桌宠等 demo 虽有趣，但真正的商业化落地场景仍需探索
- **与 Qwen3 系列的竞争**：阿里 Qwen3 系列在小模型领域同样强势，MiniCPM5-1B 的领先优势可能短暂

## 与其他实体的关系

- [[vLLM]] —— MiniCPM5-1B 支持的 7 种推理后端之一，用于高性能批量推理
- MiniCPM-Desk-Pet —— 基于 MiniCPM5-1B 的桌面宠物应用，支持 LoRA 人格切换和编程工具状态感知
- ForgeTrain —— 预训练 MiniCPM5-1B Base Model 的 AI 训练框架，全球首个完全由 AI 编写的生产级训练框架，训练速度比 Megatron 快 10%
- ArcLight —— 面壁智能自研的 CPU 推理框架，为 MiniCPM5-1B 提供纯 CPU 环境下的流畅推理能力
- OpenBMB —— MiniCPM 系列的开源社区，联合清华大学 THUNLP 和面壁智能共同维护
- 面壁智能（ModelBest）—— MiniCPM5-1B 的核心开发团队，中国领先的大模型创业公司

## 参考来源

- [[MiniCPM5-1B-GitHub]] —— OpenBMB 官方 GitHub 仓库，包含模型架构、训练流程、Benchmark 评测、部署方案和推理后端适配的完整文档
