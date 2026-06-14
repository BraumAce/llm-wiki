---
title: "Agent Skills：打通可复用专业领域知识的最后一公里"
type: source
date: 2026-05-30
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/PonVlfEFbGLkaDt_1oWfdA"
author: "阿里云开发者"
ingested_at: 2026-05-30
tags:
  - agent
  - skill
  - domain-knowledge
  - reusable-knowledge
  - knowledge-engineering
related_entities:
  - "[[OpenClaw-Skills]]"
related_topics: []
---

# Agent Skills：打通可复用专业领域知识的最后一公里

## 一句话概括

探讨如何通过 Agent Skills 机制将专业领域知识封装为可复用的结构化模块，解决知识从"存在"到"可用"的最后一公里问题。

## 实践内容

### SKILL 文件结构

```
my-skill/
├── SKILL.md          #（必须）主文件: SKILL描述、逻辑编排、核心指令
├── scripts/          #（可选）脚本: 可执行代码，*.py、*.sh等
├── references/       #（可选）参考文档: 规则、规范、参考指南等
└── assets/           #（可选）素材附件: 诸如一些icon、图片等资源
```

### SKILL.MD YAML 元数据字段

| 属性 | 必需 | 含义 | 例如 |
|------|------|------|------|
| name | 是 | 描述SKILL名称，最多64个字符 | `name: pdf` |
| description | 是 | 描述该SKILL的作用以及何时使用 | `description: Comprehensive PDF toolkit for extracting text and tables,merging/splitting documents, and filling-out forms.` |
| license | 否 | 适用于该SKILL的许可证 | `license: Apache 2.0` |
| compatibility | 否 | 该SKILL存在的特定环境要求 | `Requires git, docker, jq, and access to the internet` |
| metadata | 否 | 任意键值映射，用于添加元数据信息 | `metadata: author: "xxx" version: "1.0"` |
| allowed-tools | 否 | 技能可使用的预先批准工具列表 | `allowed-tools: Bash(git:*) Bash(jq:*) Read` |

### 渐进式披露（Progressive Disclosure）

SKILL.MD建议控制在500行，多余的内容以其他文件承载并在SKILL.MD中指出对应引用。SKILL.MD的name和description会在启动时候加载，余下的内容会在模型识别到需要时才加载。

### 实战 Demo：weekly_git_report SKILL

文件目录结构：

```
weekly_git_report/
├── SKILL.md                    # 主文件: SKILL描述、文件引用
├── scripts/
│   └── fetch_git_commits.py    # 脚本: 读取git提交记录
└── references/
    └── weekly_report_template.md  # 模板文件: 周报模板文件
```

**SKILL.md：**

```yaml
---
name: weekly_git_report
description: 获取用户所有本地 Git 仓库中最近两周的 commit messages，用于生成结构化工作周报。
version: 0.0.1
---
```

```markdown
# 概述
本技能用于基于近14天git commit messages的数据，生成每双周的结构化工作周报。

# 用户数据
用户的所有代码父目录在/Users/niexiaolong/Applications/code
所有代码仓库均在该目录下，需要遍历该目录下的所有一级目录，子目录下才有.git文件，才能获取到git commit messages
注意：若用户无该目录/Users/niexiaolong/Applications/code，则询问用户"请输入您的git仓库地址"

# 数据获取
- 基于scripts/fetch_git_commits.py脚本来获取近一周git commit messages的数据
- 周报的样板参见references/weekly_report_template.md文件

# 异常情况
如果获取不到任何数据，周报就直接写"本周我在摸鱼"。
```

**fetch_git_commits.py：**

```python
#!/usr/bin/env python3
import os
import subprocess
import sys
from datetime import datetime, timedelta

CODE_PARENT_DIR = "/Users/niexiaolong/Applications/code"

def is_git_repo(path):
    return os.path.isdir(os.path.join(path, ".git"))

def get_commits_last_2week(repo_path):
    try:
        one_week_ago = (datetime.now() - timedelta(days=14)).strftime("%Y-%m-%d")
        result = subprocess.run(
            ["git", "log", f"--since={one_week_ago}", "--pretty=format:%s", "----no-merges"],
            cwd=repo_path, capture_output=True, text=True, check=True
        )
        messages = result.stdout.strip().split("\n") if result.stdout.strip() else []
        return [msg.strip() for msg in messages]
    except subprocess.CalledProcessError:
        print(f"跳过仓库 {repo_path}（Git 命令失败）", file=sys.stderr)
        return []
    except Exception as e:
        print(f"跳过仓库 {repo_path}（错误: {e}）", file=sys.stderr)
        return []

def main():
    all_commits = []
    repos_found = 0
    for item in os.listdir(CODE_PARENT_DIR):
        full_path = os.path.join(CODE_PARENT_DIR, item)
        if os.path.isdir(full_path) and is_git_repo(full_path):
            repos_found += 1
            commits = get_commits_last_2week(full_path)
            if commits:
                all_commits.append(f"### 项目: {item}\n")
                for c in commits:
                    all_commits.append(f"- {c}")
                all_commits.append("")
    if not all_commits:
        print("过去两周没有找到任何 Git 提交记录。")
    else:
        print("\n".join(all_commits))

if __name__ == "__main__":
    main()
```

### SKILL 存储位置（Qoder CLI 示例）

| 类型 | 路径 | 作用范围 |
|------|------|----------|
| 个人 skill | `~/.qoder/skills/<skill-name>/` | 所有项目可用 |
| 项目 skill | `.qoder/skills/<skill-name>/` | 仅当前仓库可用 |

## 摘录

> Skills are organized collections of files that package composable procedural knowledge for agents -- Anthropic Don't Build Agents, Build Skills Instead。Skills是一种约定标准，可通过专业知识和工作流程扩展 AI 代理的功能。本质来说SKILLS就是一个包含元数据、脚本、模板、参考指令等的文件夹。当我们泛泛而用时，大模型很聪明，但深入某个领域要解决具体问题时，又觉得大模型好像不懂我们。通过不断沉淀专业领域的skills，结合大模型的理解能力，形成针对某个领域的技术专家。因为skills的存在，让专家不再如过去顾问一般只是提供建议，而是实实在在的帮我们把具体的事情做完。

> Skills ≠ Prompt 的替代品，而是 Prompt 的容器。一个 Skill 必然包含精心设计的 Prompt（通常在 SKILL.MD 或指令模板中），但还额外包含脚本、依赖声明、测试用例等。Skills ≠ MCP 的替代品，而是 MCP 的消费者。Skill 中的执行脚本（如 Python/JS）会通过 MCP 协议去调用外部工具。三者协同工作：Prompt 告诉模型"当前任务是什么"，模型匹配到合适的 Skill，Skill 加载后其内部逻辑通过 MCP 调用所需工具，完成闭环。Skills 的本质，是把"AI 工作流"产品化、标准化、资产化。

## 涉及实体

- Anthropic —— Agent Skills 标准的发起方，2025年10月推出 Skills 功能
- Agent-Skills-Specification —— 2025年12月开源的 Agent Skills Specification V1.0
- [[Claude-Code]] —— Skills 运行的底座平台，终端形态的 AI 编程助手
- MCP —— Model Context Protocol，与 Skills 互补的工具调用协议
- Qoder-CLI —— 阿里系产品，兼容 Claude Code 的 SKILL 标准

## 涉及主题

- Agent-Skills —— AI Agent 的技能/能力扩展机制
- Domain-Knowledge-Engineering —— 专业领域知识的结构化与复用
- Knowledge-Reusable —— 知识可复用性的设计与实践

## 我的评注

- 本文标题"最后一公里"的比喻很精准：很多 Agent 框架解决了"知识注入"的问题，但没有解决"知识如何被高效选择和使用"的问题
- Skills ≠ Prompt 的替代品，而是 Prompt 的容器；Skills ≠ MCP 的替代品，而是 MCP 的消费者——这个定位关系讲得很清楚
- "渐进式披露"（Progressive Disclosure）机制是关键设计：SKILL.MD 控制在500行，name/description 启动时加载，其余按需加载，避免过多无效内容进入上下文
- 文章用"数学天才与财务专家"的比喻说明 Skills 的价值：大模型 + 财务 skills = 财务专家，专业知识沉淀为可复用模块
- Skills 被 TechCrunch 称为"AI 领域的 Dockerfile"——可移植、可组合、可版本控制
