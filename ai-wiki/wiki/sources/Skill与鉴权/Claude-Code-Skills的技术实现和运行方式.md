---
title: "Claude Code Skills 的技术实现和运行方式"
type: source
date: 2026-07-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/EChuGeLSUlZdPI0GrapqVg"
author: "小G（JavaGuide）"
published_at: "2026-07-07"
ingested_at: 2026-07-10
tags:
  - claude-code
  - agent-skill
  - progressive-disclosure
  - allowed-tools
  - skill-security
related_entities:
  - "[[Agent-Skill]]"
  - "[[Claude-Code]]"
  - "[[Progressive-Disclosure]]"
  - "[[MCP]]"
related_topics:
  - "[[AI-Skill体系-主题]]"
  - "[[Claude-Code源码解析-主题]]"
---

# Claude Code Skills 的技术实现和运行方式

## 一句话概括

JavaGuide 从运行机制拆开 [[Agent-Skill]]：CLAUDE.md 保存常驻项目事实，Skill 用 `description` 被发现、以 `SKILL.md` 在命中后加载，supporting files 继续按需读取；同时用 `allowed-tools` 和远端 MCP Skill 禁止内嵌 shell 等边界约束降低执行风险。

## 实践内容

### 最小 Skill 与按需资源目录

```text
.claude/skills/
└── pr-summary/
    ├── SKILL.md
    ├── scripts/collect-pr-info.sh
    └── references/review-checklist.md
```

```yaml
---
name: pr-summary
description: Summarize a pull request and list key risks
allowed-tools: Bash(gh *)
---
```

常用 frontmatter 为 `description`、`when_to_use`、`allowed-tools`、`model`、`user-invocable`、`disable-model-invocation`、`paths`、`context`、`agent`。长参考、模板和脚本不应全塞入正文，而是由正文说明何时读取。

### 加载与动态上下文边界

```text
发现索引：name / description / when_to_use
命中方式：/skill-name 或模型语义匹配
调用时才处理：$ARGUMENTS、${CLAUDE_SKILL_DIR}、${CLAUDE_SESSION_ID}

只读动态上下文：!`git status --short`、!`git diff --name-only`
不适合动态上下文：改文件、提交、删除、外部写操作
```

## 摘录

> CLAUDE.md 与 Skill 的差异首先是加载策略。前者适合构建命令、目录约定、架构说明等每轮都要知道的事实；Skill 适合代码审查清单、线上排障、PR 总结、UI 验收和 TDD 这类有明确触发条件的流程。启动时只暴露 Skill 的名称和描述，真正命中才读取正文，长材料再延后读取，因此 Skill 的价值不是“换个目录堆更长规则”，而是避免无关流程占据常驻上下文。

> 标准 Skill 采用目录加 SKILL.md 的形态，来源可以是用户级、项目级、组织 managed、内置 bundled、Plugin 或 MCP Server。调用发生后，系统展开参数和变量，再渲染最终 prompt；只有被真正调用时才执行这一过程。嵌套的 `.claude/skills` 可以表达局部工作流，但不应只是为了分类而滥用，否则同名冲突和过度层级会抵消按需加载的收益。

> 动态上下文是发送 prompt 前的预处理，模型只能看到已渲染的结果。它适合采集 Git 状态和只读资料，不应承担修改任务。文章特别指出远端 MCP Skill 默认跳过内嵌 shell，因为允许远端服务返回动态命令并在本机执行会形成远程代码执行风险；本地第三方 Skill 也应先审查 SKILL.md、scripts 与 references，并用 allowed-tools 最小化授权范围。

## 涉及实体

- [[Agent-Skill]] —— Skill 目录、frontmatter、渐进披露和权限边界的核心抽象。
- [[Claude-Code]] —— Skill 发现、渲染、变量替换与来源加载的运行环境。
- [[Progressive-Disclosure]] —— 从元数据到正文再到 supporting files 的三层按需加载模式。
- [[MCP]] —— MCP 来源 Skill 因可信边界而禁用内嵌 shell 的典型案例。

## 涉及主题

- [[AI-Skill体系-主题]]
- [[Claude-Code源码解析-主题]]

## 我的评注

这篇文章最有价值的补充是把“Skill 很省 token”落到了加载时机和预处理边界：description 的路由质量、正文的流程骨架、supporting files 的延后读取，以及远程来源不执行本地命令，缺一项都可能把便利的能力包变成隐蔽的上下文或安全债务。
