---
title: "whichllm GitHub"
source_url: "https://github.com/Andyyyy64/whichllm"
author: "Andyyyy64"
fetched_at: "2026-07-05T22:18:46+08:00"
fetcher: "github-api+git-clone"
---

# GitHub API metadata

- full_name: Andyyyy64/whichllm
- description: Find the local LLM that actually runs and performs best on your hardware. Ranked by real, recency-aware benchmarks, not parameter count.
- language: Python
- license: MIT
- default_branch: main
- stars_at_fetch: 5573
- forks_at_fetch: 294
- created_at: 2026-03-04T13:16:00Z
- pushed_at: 2026-07-03T14:55:59Z
- topics: ai, apple-silicon, benchmarks, cli, command-line-tool, gguf, gpu, huggingface, inference, llm, local-llm, ollama, python, vram

# README.md 摘录

Find the best local LLM that actually runs on your hardware. Auto-detects your GPU/CPU/RAM and ranks the top models from HuggingFace that fit your system.

## Quick start

```bash
uvx whichllm@latest
uvx whichllm@latest --gpu "RTX 4090"
uv tool install whichllm
uv tool upgrade whichllm
brew install andyyyy64/whichllm/whichllm
pip install whichllm
```

## Common workflows

```bash
whichllm
whichllm --gpu "RTX 4090"
whichllm --vram 8 --ram-bandwidth 68
whichllm --gpu-only
whichllm --speed usable
whichllm --markdown
whichllm upgrade "RTX 4090" "RTX 5090" "H100"
whichllm plan "llama 3 70b"
whichllm run "qwen 2.5 1.5b gguf"
whichllm snippet "qwen 7b"
whichllm --top 1 --json
```

## How it works excerpts

Data pipeline:

1. Model fetching from HuggingFace API.
2. Benchmark sources: LiveBench, Artificial Analysis, Aider, multimodal / vision index, Open LLM Leaderboard v2, Chatbot Arena ELO.
3. Evidence levels: direct, variant, base_model, line_interp, self_reported.
4. Cache under `~/.cache/whichllm/` or `$XDG_CACHE_HOME/whichllm/`.
5. Ranking: hardware detection, VRAM estimation, compatibility, speed, score, backend filter.

## package / repo observation

```toml
[project]
name = "whichllm"
version = "0.5.15"
description = "Find the best LLM that runs on your hardware"
requires-python = ">=3.11"

[project.scripts]
whichllm = "whichllm.cli:app"
```

Project structure includes `hardware/`, `models/`, `engine/`, and `output/`. The ranker uses benchmark evidence weights, quantization penalties, partial-offload quality factors, MoE active-parameter handling, and speed estimates based on hardware bandwidth.
