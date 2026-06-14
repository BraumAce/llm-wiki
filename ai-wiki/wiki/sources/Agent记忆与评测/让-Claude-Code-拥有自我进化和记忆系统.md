---
title: "让 Claude Code 拥有自我进化和记忆系统"
type: source
date: 2026-06-12
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/PGT49KORSVZYpJxykWnwOw"
author: "得物技术"
ingested_at: 2026-06-12
tags: [Claude-Code, Agent-Memory, Hook, 自我学习, 向量检索]
related_entities: [Claude-Code, Agent-Memory, Hook-机制, Instinct-Engine, Qdrant]
related_topics: [Agent架构演进-主题]
---

# 让 Claude Code 拥有自我进化和记忆系统

## 一句话概括

为 Claude Code 构建持久化记忆与自我学习系统：行为观测层（Hook 机制 100% 捕获工具调用）→ 模式提炼层（统计 + AI 语义双路径提炼 Instinct 规则）→ 记忆注入层（向量检索 + 上下文注入），实现跨会话知识复用。

## 实践内容

### Hook 机制配置（确定性触发）

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/observe.sh pre" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/observe.sh post" }]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "~/.claude/bin/auto-analyze-instincts.py && ~/.claude/bin/auto-evolve.py" }
        ]
      }
    ]
  }
}
```

### Observation 数据格式（JSONL）

```json
{
  "session_id": "abc123",
  "ts": "2026-05-26T10:30:00Z",
  "phase": "post",
  "tool": "Edit",
  "input": { "file_path": "/src/app.ts", "old_string": "...", "new_string": "..." },
  "bash_desc": null
}
```

### Instinct 数据模型（Markdown 文件）

```yaml
---
id: read-before-edit-pattern
trigger: "when about to edit a file that hasn't been read in this session"
confidence: 0.78
domain: workflow
source: session-observation
deprecated: false
observed_at: "2026-05-20"
---
## Action
在 Edit 文件前，先用 Read 工具读取该文件的当前内容。
## Evidence
在过去多次 Edit 操作中，绝大多数之前有对应的 Read 调用。
```

### 语义去重算法（Jaccard + Union-Find）

```python
def deduplicate_instincts(instincts, sim_threshold=0.5):
    """提取英文关键词，计算 Jaccard 相似度，相似的合并为一组"""
    tokens = [tokenize(i["trigger"] + " " + i["action"]) for i in instincts]
    n = len(instincts)
    parent = list(range(n))
    for i in range(n):
        for j in range(i + 1, n):
            if jaccard(tokens[i], tokens[j]) >= sim_threshold:
                union(i, j)
    return [max(group, key=lambda x: x["confidence"]) for group in groups.values()]
```

### 记忆召回链路（四阶段）

```
阶段一：触发时机 —— SessionStart Hook 自动注入
阶段二：查询构造 —— $PWD + 最近 3 条 git commit message
阶段三：向量检索 —— Top-5 余弦相似度
阶段四：上下文注入 —— 结构化 Markdown 格式注入系统提示
```

### 置信度演化机制

```
首次发现：confidence = 0.5
重复验证：confidence += 0.05（上限 0.9）
长期未触发：confidence -= 0.05（低于 0.55 标记为 deprecated）
```

### 数据分片与生命周期管理

```
防膨胀设计：
- Observations：超 5MB 或 8000 行自动按月归档
- Instinct：低置信度（< 0.55）标记 deprecated
- Memory raw：按类型 TTL 管理（60-90 天）
- MEMORY.md：超 160 行按优先级裁剪
- auto-evolved.md：每次会话结束覆盖重写
```

## 摘录

> 每次打开 Claude Code 开始新对话，它都是一张白纸。昨天你花了 10 分钟解释的项目架构、你反复纠正的代码风格偏好、你建立的特殊开发规范——全部归零。能不能给 Claude Code 装上一套"长期记忆"系统？更进一步，不只是被动记忆，而是主动学习：观察我的行为模式、项目架构，提炼行为规律、项目知识，下次自动应用。

> Hook 是 Claude Code 在工具调用生命周期中的回调点。早期版本用 Skill 来触发学习，但 Skill 依赖模型主动调用，触发率不稳定。v2 版本改用 Claude Code 原生 Hook 机制，彻底解决了这个问题。

## 涉及实体

- [[Claude-Code]] —— 被增强的 AI Coding 工具
- [[Agent-Memory]] —— 持久化记忆系统设计
- [[Hook-机制]] —— 确定性触发的关键，替代 Skill 依赖模型调用
- [[Instinct-Engine]] —— 模式提炼层，统计 + AI 语义双路径
- Qdrant —— 本地向量数据库，存储记忆嵌入

## 涉及主题

- [[Agent架构演进-主题]]
