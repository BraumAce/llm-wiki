---
title: "Skill开发最佳实践"
type: topic
date: 2026-06-06
tags:
  - skill
  - agent
  - best-practice
  - prompt-engineering
sources:
  - "[[如何写好Skill-一份终极实战经验手册]]"
  - "[[Claude-Code-Skills-完全指南]]"
  - "[[Skills开发技能指南-别脱离具体场景谈方案]]"
  - "[[一文搞懂爆火的Skills原理及实践案例]]"
  - "[[Claude-Code-工程师亲授-OpenClaw-调教指南-Skills的工程化心法]]"
related_entities:
  - "[[OpenClaw-Skills]]"
  - "[[Harness-Engineering]]"
  - "[[MCP]]"
---

# Skill 开发最佳实践

## 核心要点

1. **Description 是 Skill 的触发器**——写得太笼统 AI 不知道啥时候该用，写得太窄很多该触发的场景会漏。用"触发评估"方法（准备 20 个问题，一半该触发一半不该触发）来校准。

2. **Skill 不是免费的**——每加载一个 Skill 都占上下文窗口。Level 1（name + description）约 50-150 Token/个，Level 2（SKILL.md 正文）约 2,000-5,000 Token。装 20 个 Skill 光元数据就吃 1,000-3,000 Token。

3. **三层渐进式加载机制**——Level 1 元数据常驻、Level 2 正文按需加载、Level 3 脚本/参考资料按需引用。核心原则：Level 1 越精准越好，Level 2 越精简越好，Level 3 放心放。

4. **SKILL.md 控制在 500 行以内**——超过就拆成主 Skill + 子 Skill。一个 Skill 只管一件事，多件事用模块化架构编排。

5. **Few-Shot 比文字描述有效得多**——3-5 个高质量示例（覆盖典型、变化、边界场景），AI 表现会稳定很多。先放最典型的，AI 更倾向模仿前面的示例。

6. **用祈使句下指令，解释"为什么"**——"必须使用参数化查询"不如"使用参数化查询而非字符串拼接，因为字符串拼接会导致 SQL 注入漏洞"。AI 理解了背后的道理，遇到未预见的情况也能合理判断。

7. **工程化评估是质量分水岭**——Skill Creator 支持触发评估（Precision/Recall）和效果评估（有 Skill vs 无 Skill 对比），从"凭感觉"升级到"跑数据"。

8. **六大反模式要避免**：大杂烩 Skill、Description 黑话、没有示例、没有验证点、写死数值、当 Wiki 写。

9. **安全是底线**——绝不硬编码敏感信息、危险操作必须确认、数据库操作先备份、防范 Prompt 注入。

10. **MCP vs HTTP 的选择**——已有 MCP Server → 优先用 MCP；需要多平台复用 → 封装 MCP；简单一次性调用 → 脚本直接 HTTP。
