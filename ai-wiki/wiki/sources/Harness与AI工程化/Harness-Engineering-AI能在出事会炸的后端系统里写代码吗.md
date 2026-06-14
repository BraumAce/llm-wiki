---
title: "Harness Engineering：AI 能在出事会炸的后端系统里写代码吗"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/VJgVPeJ5GZhVwbRtneEk_Q"
author: "lancelotluo"
ingested_at: 2026-05-30
tags: [ai-coding, backend-engineering, reliability, production-systems, harness]
related_entities: Harness
related_topics:
  - AI Code Generation
  - Backend Reliability
---

# Harness Engineering：AI 能在出事会炸的后端系统里写代码吗

## 一句话概括
探讨 AI 在高风险后端系统中编写代码的可行性与工程实践。

## 实践内容
### 项目背景
腾讯CDN LEGO项目：100万行核心代码、300万行深度改造的第三方库，服务亿级用户，理论组合路径高达 13,824 × N 种。

### nonstop项目（20天AI零人工代码开发）
- 1人+AI开发团队，交付规模：L4/L7代理、HTTP/3 QUIC、内置WAF纵深防御、V8 JS Workers边缘计算
- 实测：42,052 QPS / 5000并发0错误 / P50延迟1.1ms / 6层纵深防御

### Harness Engineering五层架构
核心理念：将AI harness在单个模块、单个文件、单个函数内实现，围绕"上下文、约束和反馈"三大要素构建闭环系统。

### 三大实践抓手
1. **上下文建设**：四层递进上下文体系（Agent.md项目宪法 → 安全纪律 → 领域知识 → 专业Skill），建立竞品调研Agent团队
2. **约束**：三层约束架构（权限安全基座 → 代码规则即编译器 → 流程约束），五条核心约束来自真实踩坑
3. **反馈**：三条并行反馈通道（自动采集Hook → 踩坑日志 → 内联反馈），多模型多Agent对抗式CR

### 对抗式CR
- 3模型并行独立审查 → 汇总问题交叉验证 → 辩论式讨论 → 全员无新发现自动收敛
- 解决单模型的知识盲区、注意力盲区和确认偏差三大问题

### 阶段性收益
综合效率提升20%：竞品调研3人天→1天、方案设计2-3人天→1天、协议安全测试3-5人天→1天、代码审查等待1-3天→30分钟

### 识别的问题
- 误报率36%：9个代码问题中真实P0仅1个
- 文档爆炸：8个需求生成99个文件
- AI的"自信"会传染：格式工整的文档反而降低审查意愿
- 团队能力退化风险

## 摘录
> 腾讯CDN LEGO项目就是这样一个系统。100万行核心代码、300万行深度改造的第三方库，服务亿级用户，承担流量调度、协议解析、安全防护、缓存加速等关键职责。它面对的不是确定性的输入输出，而是不可控的客户端、不可控的源站、多协议、多配置、公网全量攻击面——这些因素维度的叠加不是简单相加，而是乘积式的复杂度爆炸，理论组合路径高达 13,824 × N 种。在这样的复杂的系统里让 AI 写代码，一行失误就可能是一场全网事故。

> Harness Engineering 不是简单地"给 AI 加规则"，而是构建一套系统——让 AI在有边界、有约束、有反馈的环境中持续、可靠、高质量地交付代码。

> 工程体系才是核心资产，而不是某个模型或 prompt。Skill 每天在更新，大模型在进化，但工程体系的价值持续积累。

> AI Coding 不是"让 AI 替你写代码"，而是重新定义人与 AI 协作的工程范式。LEGO Harness Engineering 的价值不在于某次效率提升的数字，而在于：每一个踩坑变成规则，每一条规则内化进 Skill，每一个 Skill 让下一个人少走弯路——这是一套可持续进化的工程体系。

## 涉及实体
- Harness —— AI 辅助工程平台

## 涉及主题
- AI Code Generation
- Backend Reliability
