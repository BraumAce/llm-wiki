---
title: "SkillOpt GitHub"
type: source
date: 2026-05-31
source_type: github
source_url: "https://github.com/microsoft/SkillOpt"
author: "Microsoft"
ingested_at: 2026-05-31
tags:
  - skill-optimization
  - agent
  - open-source
  - microsoft
related_entities:
  - "[[SkillOpt]]"
related_topics: []
---

# SkillOpt GitHub

## 一句话概括

微软开源的 SkillOpt 框架，将 Skill 文件视为 Agent 的可训练状态，借鉴深度学习范式（epoch、batch、learning rate、validation gate）对其进行系统化优化，无需修改模型权重。

## 实践内容

### 安装

```bash
# 克隆仓库
git clone https://github.com/microsoft/SkillOpt.git
cd SkillOpt

# 安装（Python 3.10+）
pip install -e .

# 可选：安装 ALFWorld 兼容支持
pip install -e ".[alfworld]"

# 可选：安装 WebUI
pip install -e ".[webui]"
```

### 环境变量配置

复制 `.env.example` 为 `.env`，配置以下任一模型提供商：

```bash
# Azure OpenAI（推荐）
AZURE_OPENAI_ENDPOINT=...
AZURE_OPENAI_API_KEY=...

# OpenAI 兼容端点
OPENAI_API_KEY=...

# Anthropic Claude
ANTHROPIC_API_KEY=...

# Qwen（本地 vLLM）
QWEN_CHAT_BASE_URL=...
QWEN_CHAT_MODEL=...

# MiniMax
MINIMAX_BASE_URL=...
MINIMAX_API_KEY=...
MINIMAX_MODEL=...
```

### 训练

```bash
# SearchQA 基准测试
python scripts/train.py \
  --config configs/searchqa/default.yaml \
  --split_dir data/searchqa/split \
  --optimizer_model gpt-5.5 \
  --target_model gpt-5.5 \
  --num_epochs 4 \
  --batch_size 40 \
  --workers 8 \
  --out_root outputs/searchqa

# LiveMathematicianBench
python scripts/train.py \
  --config configs/livemathematicianbench/default.yaml \
  --split_dir data/livemathematicianbench/split \
  --optimizer_model gpt-5.5 \
  --target_model gpt-5.5

# ALFWorld
python scripts/train.py \
  --config configs/alfworld/default.yaml \
  --split_dir data/alfworld/split \
  --optimizer_model gpt-5.5 \
  --target_model gpt-5.5
```

### 仅评估（不重新训练）

```bash
python scripts/eval_only.py \
  --skill_path outputs/searchqa/best_skill.md \
  --split valid_unseen
```

可选 `--split` 值：`valid_unseen`、`valid_seen`、`train`、`all`

### WebUI 启动

```bash
python -m skillopt_webui.app
```

### 输出结构

每次运行输出：
- `config.json` — 运行配置
- `history.json` — 训练历史
- `runtime_state.json` — 恢复检查点
- `best_skill.md` — 最终优化的 Skill 文件（300–2000 token）
- 每步 Skill 快照、步骤工件、slow-update 日志、meta-skill 日志

重新运行同一命令自动从最后完成的步骤恢复。

### 预训练工件

`ckpt/` 目录提供 GPT-5.5 优化 Skill 的参考工件，可直接评估无需重新训练。

## 摘录

> SkillOpt is a text-space optimizer that trains reusable natural-language skills for frozen LLM agents through trajectory-driven edits, validation-gated updates, and deployable best_skill.md artifacts.

> The core idea: treat a skill document as the trainable state of an agent, then optimize it using discipline inspired by deep-learning training — epochs, batch sizes, learning rates, and validation gates — without modifying model weights.

> Across six benchmarks, seven target models, and three execution harnesses (direct chat, Codex CLI, Claude Code CLI), SkillOpt achieved best or tied-best results on all 52 evaluated cells. On GPT-5.5 it lifts average no-skill accuracy by +23.5 points in direct chat, +24.8 inside the Codex agentic loop, and +19.1 inside Claude Code.

## 涉及实体

- [[SkillOpt]] —— 微软开源的 Skill 自动优化框架，本仓库的核心项目

## 涉及主题

（无）

## 我的评注（可选）

SkillOpt 的设计哲学与深度学习训练高度同构：Skill 文件 = 可训练权重，验证集 = held-out 评估，rejected-edit buffer = 梯度裁剪，slow update = 学习率衰减。这种"用 NLP 操作替代梯度更新"的思路，是 Harness Engineering 领域的一个重要实践——证明了不改模型、只优化 Harness 层也能获得显著收益。
