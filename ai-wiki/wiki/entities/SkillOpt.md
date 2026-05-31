---
title: "SkillOpt"
type: entity
date: 2026-05-30
also_known_as:
  - "Microsoft SkillOpt"
  - "Skill Optimizer"
tags:
  - agent
  - open-source
  - self-evolving
  - prompt-optimization
  - skill-optimization
  - microsoft
  - harness-engineering
  - context-engineering
sources:
  - "[[SkillOpt-GitHub]]"
related_entities:
  - "[[Hermes-Agent]]"
  - "[[Harness-Engineering]]"
---

# SkillOpt

## 一句话定义

SkillOpt 是微软开源的文本空间优化器，通过轨迹驱动编辑、验证门控更新和可部署的 `best_skill.md` 工件，为冻结的 LLM Agent 训练可复用的自然语言 Skill——无需修改模型权重，仅优化 Skill 文件本身即可显著提升 Agent 表现。

## 摘要

SkillOpt 是微软于 2026 年开源的 Skill 自动优化框架，其核心理念是将 Skill 文件视为 Agent 的"可训练状态"，借鉴深度学习中的训练范式（epoch、batch size、learning rate、validation gate）对其进行系统化优化。框架采用双模型协作架构：一个目标模型负责执行任务，另一个优化模型负责分析执行轨迹并生成 Skill 编辑。在六个基准测试、七个目标模型、三种执行环境（直接对话、Codex CLI、Claude Code CLI）共 52 个评估单元中，SkillOpt 全部取得第一或并列第一。在 GPT-5.5 上，优化后的 Skill 平均提升 23.5 分，其中表格类任务提升接近 39 分。训练产出的 `best_skill.md` 文件仅 300–2000 token，部署时零推理成本，可跨模型规模、跨执行环境、跨基准测试迁移。

## 详情

### 起源与背景

SkillOpt 由微软研究院开发，论文编号 arXiv: 2605.23904，作者包括 Yifan Yang、Ziyang Gong、Weiquan Huang、Qihao Yang 等。项目以 MIT 许可证开源，GitHub 仓库地址为 `https://github.com/microsoft/SkillOpt`。

SkillOpt 要解决的核心问题是：在不修改模型权重的前提下，如何系统化地优化 Agent 的 Skill 文件。当前 AI Agent 开发中，Skill（即 System Prompt 中指导 Agent 行为的指令文件）的编写高度依赖人工经验——开发者不断试错、添加约束、调整措辞，但缺乏可验证、可回退、可迭代的优化机制。SkillOpt 将这一"凭经验调参"的过程变成了一个有训练循环、有验证门控、有失败记录的自动化流程。

### 核心机制 / 工作原理

SkillOpt 的训练循环借鉴了深度学习的经典范式，但操作对象是自然语言 Skill 文件而非模型权重：

**双模型协作架构**

系统维护两个角色分明的模型：
- **目标模型（Target Model）**：按照当前 Skill 文件执行一批任务，记录完整的执行轨迹（成功/失败）
- **优化模型（Optimizer Model）**：分析目标模型的执行轨迹，识别成功模式和失败规律，生成对 Skill 文件的编辑操作

**训练循环**

```
for epoch in range(num_epochs):
    for batch in dataloader:
        # 1. 目标模型按当前 Skill 执行任务
        trajectories = target_model.execute(batch, current_skill)
        
        # 2. 评分：成功/失败判定
        scores = evaluate(trajectories, ground_truth)
        
        # 3. 优化模型分析轨迹，生成 Skill 编辑
        edits = optimizer_model.reflect(trajectories, scores, current_skill)
        
        # 4. 限制每次编辑数量（约 4 处），防止步子迈太大
        edits = bounded_edits(edits, max_changes=4)
        
        # 5. 验证门控：新 Skill 必须在未见过的任务上表现更好
        new_skill = apply_edits(current_skill, edits)
        val_score = evaluate(new_skill, validation_set)
        if val_score > best_score:
            current_skill = new_skill  # 保留改动
        else:
            rejected_buffer.append(edits)  # 记入失败档案
```

**关键设计**

- **文本学习率（Textual Learning Rate）**：控制每次 Skill 修改的幅度，支持余弦衰减
- **严格硬验证门控（Strict Hard Validation Gating）**：候选编辑只有在 held-out 验证集上严格提升分数时才被接受
- **失败记录缓冲区（Rejected Edit Buffer）**：被拒绝的编辑存入档案，避免后续优化重复试错
- **Slow Update + Meta Skill**：每轮训练结束后进行全局复盘，重新审视整份 Skill 文件，防止越跑越偏
- **Epoch 级别的元更新**：在 epoch 结束时对 Skill 进行整体审查和微调

**支持的基准测试**

| 基准测试 | 类型 | 配置文件 |
|---------|------|---------|
| SearchQA | 问答 | `configs/searchqa/default.yaml` |
| ALFWorld | 具身智能体 | `configs/alfworld/default.yaml` |
| DocVQA | 文档问答 | `configs/docvqa/default.yaml` |
| LiveMathematicianBench | 数学 | `configs/livemathematicianbench/default.yaml` |
| SpreadsheetBench | 代码生成 | `configs/spreadsheetbench/default.yaml` |
| OfficeQA | 工具增强问答 | `configs/officeqa/default.yaml` |

**训练产出**

每个运行输出：`config.json`、`history.json`、`runtime_state.json`、`best_skill.md`（最终优化的 Skill 文件）、每步 Skill 快照、步骤工件、slow-update 日志和 meta-skill 日志。重新运行时自动从最后完成的步骤恢复。

### 应用 / 使用场景

- **Agent Skill 自动优化**：将人工编写的初始 Skill 交给 SkillOpt 训练，获得经过验证的最优 Skill 文件，适用于各类 AI Agent 场景
- **跨模型迁移**：在一个模型上优化的 Skill 可直接迁移到其他模型使用，无需重新训练
- **跨环境部署**：同一份 `best_skill.md` 可在直接对话、Codex CLI、Claude Code CLI 等不同执行环境中使用
- **Benchmark 追求极致性能**：针对特定 Benchmark 进行 Skill 优化，适用于 AI 研究人员追求 SOTA 结果
- **Skill 迭代方法论**：为 Skill 编写提供系统化的优化思路——小步修改、验证门控、失败记录、全局复盘

### 局限与争议

- **无开箱即用安装包**：目前仅提供源码安装方式（`git clone` + `pip install -e .`），没有 PyPI 包或 Docker 镜像，对快速试用不够友好
- **依赖模型 API**：需要配置目标模型和优化模型的 API 密钥，支持 OpenAI、Anthropic、Qwen 等主流提供商，但对本地模型的支持需要额外配置 vLLM 等推理服务
- **训练成本**：每个 epoch 需要大量 API 调用（目标模型执行任务 + 优化模型分析轨迹），对于大规模 Benchmark 训练成本不低，尤其使用 Claude Opus 或 GPT-5.5 等高端模型时
- **Skill 文件长度限制**：最优 Skill 通常仅 300–2000 token，对于需要复杂指令的场景（如多步骤工作流、条件分支逻辑）可能表达能力不足
- **验证集依赖**：需要准备带答案的训练集和验证集，对于开放性任务（如创意写作、自由对话、主观评价）难以构建客观的验证标准
- **优化模型能力瓶颈**：Skill 优化的质量高度依赖优化模型的分析能力，弱模型可能无法从轨迹中提取有效的改进建议，导致优化陷入局部最优
- **论文可复现性**：配置文件中 `optimizer.slow_update_gate_with_selection` 有两个模式（`false` 为当前默认的强制接受，`true` 为论文复现的验证门控），默认配置与论文实验设置不完全一致
- **Benchmark 覆盖偏学术**：当前六个基准测试偏向标准化任务，对真实生产环境中的复杂 Agent 工作流验证不足

## 与其他实体的关系

- [[Hermes-Agent]] —— 同为 Skill 自动化领域的工具，但路径不同：Hermes 通过 Skill Generation（外挂式进化）从执行轨迹中自动沉淀 Skill，而 SkillOpt 通过训练循环系统化优化单份 Skill 文件；Hermes 还提供 RL 训练闭环改变模型权重，SkillOpt 则完全不修改模型
- [[Harness-Engineering]] —— SkillOpt 是 Harness 理念的另一种实现：不改模型、只优化 Skill（即 Harness 的一部分），验证了"Agent = Model + Harness"中 Harness 层的优化空间

## 参考来源

- [[SkillOpt-GitHub]] —— 微软官方 GitHub 仓库，包含完整的安装、训练、评估文档和预训练工件
