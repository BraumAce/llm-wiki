---
title: "MiniCPM5-1B GitHub"
type: source
date: 2026-05-31
source_type: github
source_url: "https://github.com/OpenBMB/MiniCPM"
author: "OpenBMB"
ingested_at: 2026-05-31
tags:
  - llm
  - small-language-model
  - on-device
  - open-source
  - openbmb
related_entities:
  - "[[MiniCPM5-1B]]"
related_topics: []
---

# MiniCPM5-1B GitHub

## 一句话概括

OpenBMB 开源的 MiniCPM 系列最新端侧文本基座模型，以 1B 参数在 AA-Index 榜单超越所有 2B 以下模型，支持混合推理、多后端部署和多芯片适配。

## 实践内容

### 安装与推理

```bash
# vLLM
pip install "vllm>=0.21"

# SGLang
pip install "sglang[srt]>=0.5.12"

# Transformers
pip install -U "transformers>=5.6" accelerate torch
```

### Quick Start（Transformers）

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

model_id = "openbmb/MiniCPM5-1B"
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(
    model_id, torch_dtype="auto", device_map="auto"
)

# Think 模式
messages = [{"role": "user", "content": "9.11 and 9.8, which is greater?"}]
text = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True, enable_thinking=True)
inputs = tokenizer(text, return_tensors="pt").to(model.device)
outputs = model.generate(**inputs, max_new_tokens=1024, temperature=0.9, top_p=0.95)
print(tokenizer.decode(outputs[0], skip_special_tokens=True))
```

### 推理后端

| 后端 | 安装 |
|------|------|
| Transformers | `pip install -U "transformers>=5.6" accelerate torch` |
| SGLang | `pip install "sglang[srt]>=0.5.12"` |
| vLLM | `pip install "vllm>=0.21"` |
| llama.cpp | 使用 GGUF 格式 |
| Ollama | `ollama run openbmb/MiniCPM5-1B-GGUF` |
| MLX | Apple Silicon 原生 |
| ArcLight | 自研 CPU 推理框架 |

### 微调框架

支持 TRL+PEFT、LLaMA-Factory、ms-swift、unsloth、xtuner 共 5 种微调框架。

### 采样参数

- **Think 模式**：temperature=0.9, top_p=0.95
- **No-Think 模式**：temperature=0.7, top_p=0.95

### 模型下载

- HuggingFace：`openbmb/MiniCPM5-1B`
- ModelScope：`OpenBMB/MiniCPM5-1B`
- GitCode / 魔乐社区

### 量化

INT4 量化后权重仅 0.5GB，支持 BF16、GGUF、MLX 格式。

## 摘录

> MiniCPM5-1B 再次刷新模型的智能密度上限：仅以 1B 参数规模，在国际知名榜单 AA-Index 上超越了所有 2B 参数以下模型。相比 3 个月前发布的 Qwen3.5-2B，MiniCPM5-1B 不仅效果更优，参数量还减少了一半。这一结果进一步验证了我们持续观察到的密度定律：大模型的智能密度正在以约每 3.5 个月翻一番的速度持续提升。

> ForgeTrain 是全球首个完全由 AI 编写的生产级大模型预训练框架，零人类程序员参与编写框架代码，训练速度比英伟达 Megatron 还要快 10%。一个由 AI 亲手锻造的框架，训出了 2B 规模综合性能全球最强的文本基座模型。这表明，「AI 制造 AI」的递回归智能（RSI）不是天方夜谭，而是正在发生的现实。

> MiniCPM5-1B 采用标准 LlamaForCausalLM 架构——无自定义内核、无模型代码分叉。RL + OPD 组合提升平均分 ↑16 分，减少 max-tokens 预算命中 ↓29 个百分点。

## 涉及实体

- [[MiniCPM5-1B]] —— 面壁智能开源的 1B 参数端侧文本基座模型，本文的核心项目

## 涉及主题

（无）

## 我的评注（可选）

MiniCPM5-1B 的亮点不仅在于模型本身，更在于其背后的"AI 制造 AI"叙事：ForgeTrain（AI 编写的训练框架）训练出 MiniCPM5-1B（AI 模型），形成闭环。虽然 ForgeTrain 尚未开源，但这个方向值得关注。

配套的 MiniCPM-Desk-Pet 桌宠项目（github.com/OpenBMB/MiniCPM-Desk-Pet）是一个有趣的端侧 AI 应用 demo——0.5GB 模型驱动本地桌面宠物，支持 LoRA 人格切换，还能感知编程工具活动状态。
