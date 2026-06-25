---
title: "multica-ai GitHub"
type: source
date: 2026-06-26
source_type: webpage
source_url: "https://github.com/multica-ai"
author: "multica-ai"
ingested_at: 2026-06-26
tags:
  - managed-agents
  - coding-agent
  - platform
  - skill
related_entities:
  - "[[Multica]]"
  - "[[Agentic-Engineering]]"
  - "[[Harness-Engineering]]"
  - "[[OpenClaw]]"
related_topics:
  - "[[Agentic-Engineering-主题]]"
  - "[[AI-Skill体系-主题]]"
---

# multica-ai GitHub

## 一句话概括

multica-ai 组织围绕 Multica 平台、Multica CLI Skill 和 Karpathy 风格编码指南，展示了一条把 coding agents 管理成“团队成员”的工程化路线。

## 实践内容

```bash
brew install multica-ai/tap/multica
multica setup
multica daemon start
multica auth status
multica config show
multica issue list --output json
multica issue get <id> --output json
multica issue comment add <id> --content-file ./reply.md
```

```text
/plugin marketplace add multica-ai/multica-cli
/plugin install multica-cli@multica-cli

install-skill-from-github.py --repo multica-ai/multica-cli --path skills/multica-cli
```

## 摘录

> Multica turns coding agents into real teammates. Assign issues to an agent like you'd assign to a colleague — they'll pick up the work, write code, report blockers, and update statuses autonomously. No more copy-pasting prompts. No more babysitting runs.

> This repository does not grant Multica access by itself. Permissions come only from the user's local CLI login, selected profile, active workspace, and explicit approval for any commands the agent runs. The skill teaches how to drive Multica safely; it never bypasses workspace permissions or stores secrets.

## 涉及实体

- [[Multica]] —— 本组织主平台实体，managed agents 工作台。
- [[Agentic-Engineering]] —— Multica 把 agent 从单次工具调用提升到团队任务生命周期。
- [[Harness-Engineering]] —— Multica CLI Skill 明确了读写边界、授权、JSON 输出和 side effect 管理。
- [[OpenClaw]] —— Multica 支持 OpenClaw 作为可接入 runtime。

## 涉及主题

- [[Agentic-Engineering-主题]]
- [[AI-Skill体系-主题]]

## 我的评注

Multica 的独特价值在“管理 agent”而非“单个 agent 更聪明”。它把 issue、status、mention、runtime、skill、autopilot 都变成可治理对象；multica-cli skill 又提醒我们，外部 Agent 操作平台时必须把认证、workspace、写操作授权和 mention 副作用写清楚。
