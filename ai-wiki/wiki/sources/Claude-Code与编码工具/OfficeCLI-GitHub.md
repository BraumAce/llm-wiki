---
title: "OfficeCLI GitHub"
type: source
date: 2026-06-26
source_type: webpage
source_url: "https://github.com/iOfficeAI/OfficeCLI"
author: "iOfficeAI"
ingested_at: 2026-06-26
tags:
  - office
  - cli
  - agent-tool
  - document-automation
related_entities:
  - "[[OfficeCLI]]"
  - "[[Claude-Code]]"
  - "[[OpenClaw]]"
  - "[[Ponytail]]"
related_topics:
  - "[[Claude-Code源码解析-主题]]"
  - "[[AI-Skill体系-主题]]"
---

# OfficeCLI GitHub

## 一句话概括

OfficeCLI 把 Word、Excel、PowerPoint 的创建、读取、编辑、渲染和校验统一成 AI-friendly CLI，使 Agent 能用结构化路径操作 Office 文件并通过 HTML/PNG 预览做闭环修正。

## 实践内容

```bash
curl -fsSL https://officecli.ai/SKILL.md
curl -fsSL https://raw.githubusercontent.com/iOfficeAI/OfficeCLI/main/install.sh | bash
officecli install
officecli --version

officecli create deck.pptx
officecli add deck.pptx / --type slide --prop title="Q4 Report" --prop background=1A1A2E
officecli view deck.pptx outline
officecli get deck.pptx '/slide[1]/shape[1]' --json
officecli watch deck.pptx
```

```bash
officecli help
officecli help docx
officecli help docx paragraph
officecli help docx set paragraph
officecli help docx paragraph --json

officecli open report.docx
officecli set report.docx / --find draft --replace final
officecli close report.docx
```

## 摘录

> OfficeCLI's built-in HTML rendering engine reproduces documents with high fidelity — and that's what gives AI eyes. It renders `.docx` / `.xlsx` / `.pptx` to HTML or PNG, closing the render → look → fix loop.

> When unsure about property names, value formats, or command syntax, ALWAYS run help instead of guessing. One help query beats guess-fail-retry loops. Format aliases: `word`→`docx`, `excel`→`xlsx`, `ppt`/`powerpoint`→`pptx`.

## 涉及实体

- [[OfficeCLI]] —— 本项目实体，Office 文档结构化操作工具。
- [[Claude-Code]] —— README 和 SKILL 均强调可安装到 Claude Code。
- [[OpenClaw]] —— README 列出 OpenClaw 作为支持宿主。
- [[Ponytail]] —— 两者都把复杂任务压缩为更少、更可验证的工程动作。

## 涉及主题

- [[Claude-Code源码解析-主题]]
- [[AI-Skill体系-主题]]

## 我的评注

OfficeCLI 是典型“CLI 接管确定性、Agent 做判断”的路线：属性、路径、渲染和校验交给工具，模型不要猜 OpenXML。它也提示了 Skill 设计要点：帮助系统、resident mode、稳定 ID、浏览器选择和截图验证，比单纯给模型一段“怎么写 python-pptx”可靠得多。
