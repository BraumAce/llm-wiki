---
title: "Claude Code Skills 的技术实现和运行方式"
source_url: "https://mp.weixin.qq.com/s/EChuGeLSUlZdPI0GrapqVg"
author: "小G（JavaGuide）"
published_at: "2026-07-07T14:19:00+08:00"
fetched_at: "2026-07-10T00:00:00+08:00"
fetcher: "in-app-browser"
---

# Claude Code Skills 的技术实现和运行方式

## 原文要点摘取

文章从 CLAUDE.md 与 Skill 的分工开始：前者容纳每轮都必须知道的项目事实、目录与长期规则；Skill 容纳只在特定任务发生时需要的多步骤流程。Skill 平时只暴露名称与 description，命中后才加载正文，脚本、清单和长参考资料再按需披露，因此不会把所有操作手册常驻塞入上下文。

标准文件系统 Skill 位于 `<skill-name>/SKILL.md`，可附带 `scripts/`、`references/` 等 supporting files。YAML frontmatter 常见字段包括 description、when_to_use、allowed-tools、model、user-invocable、disable-model-invocation、paths、context 与 agent；正文是渲染给模型的操作说明。作者强调大多数 Skill 不应堆满字段，description、allowed-tools 与清晰正文已经足够。

加载来源包括用户级 `~/.claude/skills/`、项目级 `.claude/skills/`、managed、bundled、plugin 与 MCP Skills。调用时，Claude Code 先用 name、description、when_to_use 作为发现索引；显式 `/skill-name` 或模型匹配后，再渲染正文、展开 `$ARGUMENTS`、`${CLAUDE_SKILL_DIR}` 等变量。长内容应继续留在 supporting files，形成“元数据 → SKILL.md → 具体文件”的渐进式披露。

动态上下文命令在 Skill prompt 发送前执行，适合只读的 `git status`、`git diff --name-only` 与项目脚本；不应执行改文件、提交或删除操作。远端 MCP Skill 会跳过内嵌 shell 以避免远程代码执行风险；即使是本地 Skill，也应以 allowed-tools 收窄权限并在安装前审查 SKILL.md、脚本与参考资料。
