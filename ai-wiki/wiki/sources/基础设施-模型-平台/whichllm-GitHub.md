---
title: "whichllm GitHub"
type: source
date: 2026-07-05
source_type: webpage
source_url: "https://github.com/Andyyyy64/whichllm"
author: "Andyyyy64"
ingested_at: 2026-07-05
tags:
  - local-llm
  - hardware-detection
  - gpu
  - benchmark
  - gguf
  - vram
related_entities:
  - "[[whichllm]]"
  - "[[vLLM]]"
  - "[[KV-Cache]]"
related_topics:
  - "[[AI-Infra推理优化-主题]]"
---

# whichllm GitHub

## 一句话概括

whichllm 是一个本地 LLM 选型 CLI，根据实际硬件、VRAM/RAM、量化、速度估算和基准证据，推荐“跑得动且更值得跑”的 HuggingFace 模型。

## 实践内容

```bash
uvx whichllm@latest
uvx whichllm@latest --gpu "RTX 4090"
uv tool install whichllm
uv tool upgrade whichllm
brew install andyyyy64/whichllm/whichllm
pip install whichllm
```

```bash
whichllm
whichllm --gpu "RTX 4090"
whichllm --vram 8 --ram-bandwidth 68
whichllm --gpu-only
whichllm --fit gpu
whichllm --speed usable
whichllm --speed fast
whichllm --markdown
whichllm upgrade "RTX 4090" "RTX 5090" "H100"
whichllm plan "llama 3 70b"
whichllm run "qwen 2.5 1.5b gguf"
whichllm snippet "qwen 7b"
whichllm --top 1 --json
```

```text
src/whichllm/
├── cli.py
├── data/
├── hardware/
├── models/
├── engine/
└── output/
```

```text
size_score = 4.2 * log2(params_b) + 9
```

```text
direct: 0.62
base_model: 0.55
variant: 0.50
line_interp: 0.40
self_reported: 0.30
none: 0.00
```

## 摘录

> whichllm does not pick the largest model that fits. It ranks candidates by a composite score that tries to answer a more practical question: of the models that can run here, which one is likely to be the best usable choice? Inputs include model metadata from HuggingFace, detected or simulated hardware, estimated VRAM/RAM fit, estimated tokens per second, quantization type, benchmark evidence, downloads and likes, source organization, model lineage, and generation. The score is capped to 0..100.

> The request flow validates CLI flags, detects hardware, loads or fetches model and benchmark caches, groups related model repos into families, flattens families into rankable candidates, ranks every candidate variant, backfills missing published dates for top results, and prints a Rich table or JSON. Hardware detection covers NVIDIA, AMD, Intel, Apple Silicon, CPU cores, RAM, and disk. VRAM estimation includes weights, KV cache, activation, and framework overhead, while compatibility distinguishes full GPU, partial offload, and CPU-only execution.

## 涉及实体

- [[whichllm]] —— 本项目实体，本地 LLM 推荐与硬件规划 CLI。
- [[vLLM]] —— 同属本地/自托管推理生态，whichllm 关注模型选型，vLLM 关注 serving runtime。
- [[KV-Cache]] —— whichllm 的 VRAM 估算显式包含 KV cache 与 context length。

## 涉及主题

- [[AI-Infra推理优化-主题]]

## 我的评注

whichllm 把“本地模型能不能跑”从参数量猜测改成硬件、量化、证据和速度的多因素排序。它对个人和小团队的价值在采购、模型下载和本地部署前置决策上：先用 `--gpu`、`plan`、`upgrade` 和 JSON 输出做可复现判断，再决定是否下载模型或买显卡。它也提醒 AI Infra 讨论不能只看 serving 框架，模型选择和硬件预算本身就是推理工程的一部分。
