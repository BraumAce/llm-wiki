---
title: "AI研发自动化：Wiki知识库+技能包"
type: source
date: 2026-06-04
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/6hDDkU2z31K67y8Z9dcqhw"
author: "哥伦"
ingested_at: 2026-06-04
tags:
  - ai-engineering
  - knowledge-base
  - agent-skill
  - evaluation-system
  - enterprise-ai
  - claude-code
  - wiki
  - automation
  - harness
related_entities:
  - "[[Agentic-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[AI-Skill体系全解-企业级AI能力标准化可插拔可审计]]"
related_topics:
  - AI 研发自动化
  - Wiki 知识库
  - Agent Skill 评测
  - 企业级 AI 工程
  - Harness 规则体系
---

# AI研发自动化：Wiki知识库+技能包

## 一句话概括

阿里内部实践：用 Wiki 知识库（Markdown 结构化存储）+ Skills 技能包（分研发阶段的专用 Skill）增强 AI 编码助手，配合 LLM Judge 评测系统验证效果，实现企业级研发自动化。

## 核心架构

### 知识库（KB）

- **存储格式**：Markdown，结构化为 entity（实体）、concept（概念）、query 等类型
- **内容来源**：代码仓库自动学习 + 人工维护
- **版本管理**：git，crontab 定时同步
- **健康指标**：lint 健康分、死链/孤岛/重复/短页检测

### 技能包（Skills）

| Skill | 用途 |
|-------|------|
| `kb-tech-solution` | 技术方案编写 |
| `kb-tech-review` | 技术评审 |
| `kb-just-coding` | 编码实现 |
| `kb-test-pre` | 测试准备 |
| `kb-problem-solve` | 问题排查 |

## 评测体系

### 1. KB 健康体检

- **评测集**：15 条黄金评测集，预先标注好评分标准
- **评分方式**：LLM Judge 双 seed 打分（同一 Judge prompt 跑 2 遍）
- **噪声基线**：σ₀ = 0.236（随机 5 条任务在 KB 不变下跑 3 轮的标准差中位数）
- **真变化判断**：|Δ| ≥ 3σ₀ = 0.71 → 99.7% 置信为真变化

### 2. 横向对比评测

**A 组（KB+Skills）vs B 组（Baseline）**

| 阶段 | A 组 | B 组 | 差值 |
|------|------|------|------|
| 技术方案 | 83.7 | 68.0 | +15.7 |
| 技术评审 | 83.7 | 76.0 | +7.7 |
| 编码实现 | 80.3 | 69.3 | +11.0 |
| 测试准备 | 83.0 | 70.7 | +12.3 |
| **主流程加权** | **82.5** | **70.5** | **+12.0** |
| **问题排查加权** | **81.0** | **76.7** | **+4.3** |

### 3. 迭代评测（Skill 优化验证）

| 阶段 | A 组（v2） | B 组（v1） | 差值 |
|------|-----------|-----------|------|
| 技术方案 | 81.3 | 72.7 | +8.7 |
| 技术评审 | 82.0 | 82.7 | -0.7 |
| **综合** | **81.7** | **77.7** | **+4.0** |

### 4. 防作弊机制

- **脱敏盲评**：删除 KB 引用、Skill 阶段标识，用随机 Submission ID 替代组别
- **模型分离**：Opus 4.6 生成，Opus 4.7 评分（避免自我偏好）
- **平台分离**：Claude Code 生成，Aone-Copilot 评分

## 关键发现

1. **证据驱动 vs 流程驱动**：新版 Skill（给方向性指引）发现力强但覆盖不稳定；旧版 Skill（12 维度 × 100+ checklist）覆盖稳定但深度有限
2. **技术评审需平衡**：适当补充 checklist + 反编造规则，减少漏判或过度指控
3. **KB 问题分类**：死链、实体字段缺失、风险/边界缺失、source 摄入残缺、概念页缺失、摘要错误/过期/编造

## 评分标准设计

### 主流程

- **技术方案（30%）**：业务覆盖度 25、设计合理性 25、详细设计粒度 20、风险与回滚 15、反编造与待确认 15
- **技术评审（20%）**：维度全面性 25、高优问题识别 25、编造检测 20、修订建议可操作性 15、立场独立性 15
- **编码实现（30%）**：修改位置正确性 20、业务逻辑正确性 27、项目风格一致性 13、编译/静态检查 17、兼容回归风险 13、变更说明清晰度 10
- **测试准备（20%）**：场景覆盖 30、用例可执行性 25、数据需求清晰度 20、异常与边界 15、回归点识别 10

### 问题排查

- SLS 查询有效性 25
- 代码定位与证据链完整性 25
- 根因可信度 25
- 修复建议合理性 15
- 复现/验证步骤 10

## 未来方向

1. **Harness 规则体系**：LLM 是执行者，Harness 是导演 — 编排、门禁、护栏、回滚
2. **SKILL 自动优化**：评测系统 + 用户反馈 → LLM 定期给出优化建议 → 评测验证正向
3. **跨多知识库发展**：mkt-link-kb、tmc-datacube-kb、mkt-gemini-kb、mkt-zelda-kb
4. **全自动化研发**：基于 Harness 的 LLM 全托管式研发系统

## 实践要点

### 知识库更新管理
- crontab 本地定时任务：每周远程代码仓库 diff
- kb-sync 技能：开发方 push，使用方 pull
- 后续增加 CR 审核

### SKILL 用户体验
- MCP 工具收拢至单一服务
- 多平台兼容：Claude-code、Aone-Copilot、OpenClaw
- SLS 日志通过阿里云 SDK + Python 脚本 + AK/SK 配置

### 自动化测试
- MCP 服务新增查询 odps、holo、igraph、oceanBase、mySql 工具
- LLM 自主写 SQL 查询测试数据
- 子 agent 分析不符预期原因，按 SOP 执行代码修复

### 问题排查
- a1-CLI 获取最近一周发布内容
- 结合报错判断是否由发布导致
- 非发布问题再结合 KB 和代码仓库分析
