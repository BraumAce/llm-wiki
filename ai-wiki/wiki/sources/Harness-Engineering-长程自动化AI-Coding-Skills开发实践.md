---
title: "Harness Engineering：长程自动化 AI Coding / Skills 开发实践"
type: source
date: 2026-06-08
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/mSjb20PDsfiK88C9AQB7og"
author: "胡韶山"
ingested_at: 2026-06-10
tags: [harness-engineering, ai-coding, context-firewall, feedback-loop, group-intelligence, hiclaw, cli-anything]
related_entities:
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Harness-Engineering-主题]]"
---

# Harness Engineering：长程自动化 AI Coding / Skills 开发实践

## 一句话概括
从 Prompt Engineering → Context Engineering → Harness Engineering 的三阶段演进切入，用 4 个真实案例（编辑工具、技术债放大、上下文防火墙、反馈回路重设计）论证 Harness 是 Agent 时代的护城河，并介绍 CLI-Anything 和 HiClaw 两个群体智能基础设施。

## 摘录

> Harness 一词来源于马具。马是强大的 AI 模型，但因其黑盒属性具有不可控性；Harness 是指缰绳、马鞍和护具等，是工程管理学；骑手是人类工程师，明确意图、设计环境和构建反馈回路。

> 当好的实践占主导时，Agent 放大好的实践；当捷径占主导时，Agent 放大捷径。

> "你在怪飞行员，但问题出在起落架上。" —— Can Duruk，编辑工具设计直接影响模型编码成功率

> "成功应该是沉默的，只有失败才应该发出声音。" —— HumanLayer，反馈回路设计原则

> 同一个模型，不同的 Harness，截然不同的结果。Agent 竞争优势除了在你用了哪个模型，也在于你构建了怎样的 Harness。

## 核心案例
1. **Hashline 编辑方案**：每行加哈希标签替代文本复现，Grok Code Fast 1 成功率 6.7% → 68.3%
2. **技术债指数级放大**：Agent 把坏模式当合法方案系统性复用，OpenAI 用自动化规则编码"品味"
3. **子 Agent 上下文防火墙**：隔离上下文窗口防止"笨蛋区"，父 Agent 用贵模型规划，子 Agent 用便宜模型执行
4. **反馈回路重设计**：成功静默 + 失败精炼 + LoopDetection，LangChain Terminal Bench 从前 30 升至前 5

## 群体智能基础设施
- **CLI-Anything**（港大）：自动分析软件源码生成 CLI + SKILL.md，Agent 可调用 GIMP/Blender/Audacity
- **HiClaw**（阿里）：Manager-Workers 架构 + 独立记忆存储 + Higress AI Gateway + MinIO 共享文件系统

## 涉及实体
- [[Harness-Engineering]] —— 三阶段演进的最终形态
- HiClaw —— 阿里开源的群体智能操作系统
- CLI-Anything —— 港大的群体智能基础设施
- [[OpenClaw]] —— Harness Engineering 的载体之一

## 涉及主题
- [[Harness-Engineering-主题]] —— 4 个真实案例 + 群体智能方向
