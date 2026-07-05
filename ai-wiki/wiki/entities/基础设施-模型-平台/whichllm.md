---
title: "whichllm"
type: entity
date: 2026-07-05
also_known_as:
  - "Andyyyy64/whichllm"
tags:
  - local-llm
  - hardware-detection
  - gpu
  - benchmark
  - gguf
  - vram
sources:
  - "[[whichllm-GitHub]]"
related_entities:
  - "[[vLLM]]"
  - "[[KV-Cache]]"
  - "[[OmniRoute]]"
---

# whichllm

## 一句话定义

whichllm 是一个本地 LLM 推荐与硬件规划 CLI，根据当前或模拟硬件、VRAM/RAM、量化、速度、benchmark evidence 和模型新旧程度，推荐更可能“跑得动且值得跑”的 HuggingFace 模型。

## 摘要

[[whichllm-GitHub]] 解决的是本地模型部署前一个很具体但高频的问题：显卡或 CPU 能跑什么模型，哪个模型不是最大但更好，换显卡是否值得，某个模型需要多少 VRAM。README 明确反对“最大参数量能 fit 就推荐”的简单逻辑，而是把 HuggingFace 模型元数据、硬件探测、GGUF/AWQ/GPTQ/FP16 等格式、量化质量、benchmark evidence、模型 lineage、generation recency、下载量、likes、source trust、预计 tok/s 和运行 fit 类型合并成一个 0 到 100 的排序分数。

它在 AI Infra 知识库中的价值，是把推理部署讨论从 serving runtime 往前推到“选型与硬件预算”。[[vLLM]]、[[KV-Cache]] 等实体关注推理时的批处理、显存管理和 serving 效率；whichllm 关注的是运行前决策：根据机器条件先判断模型是否 full GPU、partial offload 或 CPU-only，再估算速度和质量，避免下载一个理论上能跑但实际很慢、证据很弱或被过时 benchmark 高估的模型。对个人开发者和小团队来说，这类 CLI 能减少试错下载、采购误判和模型榜单误读。

## 详情

### 起源与背景

本地 LLM 生态在 2025 到 2026 年变得更复杂：同一模型家族可能有 official safetensors、GGUF community quant、AWQ/GPTQ 版本、MoE active/total parameter 差异、不同 context length、不同硬件 backend。仅用参数量、显存或下载量判断容易出错。whichllm 把这个问题转成一个可执行命令：先 auto-detect 当前硬件，也可以用 `--gpu "RTX 4090"`、`--vram`、`--ram-bandwidth`、`--gpu-only` 模拟目标机器或约束，再给出排序表、Markdown 或 JSON。

### 核心机制 / 工作原理

默认请求流是：校验 CLI flags，检测硬件，加载或抓取 HuggingFace 模型和 benchmark cache，按 family 聚合相关 repo，再展开为 candidate variants，逐个 rank，最后输出 Rich table 或 JSON。硬件探测覆盖 NVIDIA、AMD、Intel、Apple Silicon、CPU、RAM 和 disk；模型抓取覆盖 text-generation、GGUF、recently modified GGUF、trending repos、curated frontier IDs 和 vision candidates。benchmark 来源分 current 和 frozen tiers，包含 LiveBench、Artificial Analysis、Aider、Vision、Open LLM Leaderboard v2 与 Chatbot Arena ELO。

```bash
uvx whichllm@latest
whichllm --gpu "RTX 4090"
whichllm plan "llama 3 70b"
whichllm upgrade "RTX 4090" "RTX 5090" "H100"
whichllm --top 1 --json
```

评分层面，benchmark evidence 有 `direct`、`base_model`、`variant`、`line_interp`、`self_reported`、`none` 等权重；size score 使用 `4.2 * log2(params_b) + 9` 并封顶；低 bit 量化有质量惩罚；full GPU、partial offload、CPU-only 有不同 runtime fit multiplier；速度是 usability gate 而不是唯一质量指标。MoE 模型还区分 active parameters 和 total parameters，避免用 dense 模型逻辑误判速度与质量。

### 应用 / 使用场景

- 买显卡前用 `whichllm upgrade` 比较当前机器与候选 GPU。
- 部署本地模型前用 `plan` 估算不同量化和 context length 的 VRAM 需求。
- 在脚本中用 `--json` 取 top model ID，再交给 Ollama、llama.cpp 或其他本地运行时。
- 用 `--gpu-only`、`--speed usable`、`--vram-headroom` 获得更保守的 LM Studio 式推荐。

### 局限与争议

whichllm 的速度是估算，不是实时 benchmark；README 和 docs 也标注 speed confidence 与 range。HuggingFace metadata、第三方榜单和 community quant 信息都会滞后，虽然项目通过 cache TTL、benchmark snapshot、recency demotion 和 evidence confidence 缓解，但不能替代本地实际压测。另一个边界是“最佳模型”依赖任务：通用、coding、vision、math profile 可以切换，但业务数据、中文质量、工具调用能力和推理格式仍需要自己的评测集验证。

## 与其他实体的关系

- [[vLLM]] —— whichllm 帮助选择模型和硬件，vLLM 负责服务化推理执行。
- [[KV-Cache]] —— whichllm 的 VRAM 估算包括 context length 对 KV cache 的影响。
- [[OmniRoute]] —— OmniRoute 管多 provider 路由，whichllm 管本地模型候选与硬件可行性，二者都是模型使用前的决策基础设施。

## 参考来源

- [[whichllm-GitHub]]
