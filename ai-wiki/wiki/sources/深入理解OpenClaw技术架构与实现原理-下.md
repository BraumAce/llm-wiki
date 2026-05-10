---
title: "深入理解OpenClaw技术架构与实现原理（下）"
type: source
date: 2026-05-10
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/FUJEofqbK7vX-J64UX8Nkg"
author: "阿里云开发者 / 踏天"
published_at: "2026-03-26"
ingested_at: 2026-05-10
tags:
  - openclaw
  - architecture
  - sandbox
  - memory
  - skills
related_entities:
  - "[[OpenClaw]]"
  - "[[OpenClaw-SandBox]]"
related_topics: []
---

# 深入理解OpenClaw技术架构与实现原理（下）

## 一句话概括

[[OpenClaw]] 技术架构深度解析续篇，覆盖 SandBox 沙箱、记忆管理、Skills 模块、Session 管理、自进化机制、多代理路由、Nodes、安全策略、配置管理共 9 大模块。文章核心论述了 OpenClaw 如何以"文件即真相"和"Docker 隔离 + 工具策略层级"两套思路，把"AI 帮我跑命令"从赌博式信任问题工程化。

## 实践内容

### SandBox 配置示例（原文 3.8.8）

```json
{
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "non-main",
        "scope": "session",
        "workspaceAccess": "none",
        "docker": {
          "image": "openclaw-sandbox:bookworm-slim",
          "network": "none",
          "memory": "512m",
          "cpus": 1
        },
        "prune": {
          "idleHours": 24,
          "maxAgeDays": 7
        }
      }
    }
  }
}
```

### SandBox CLI（原文 3.8.9）

```bash
openclaw sandbox list        # 列出沙箱容器
openclaw sandbox recreate    # 强制重建容器
openclaw sandbox explain     # 调试当前配置（解释模式合并结果）
```

### SandBox 强约束黑名单（原文 3.8.6）

**禁止的绑定挂载**：

```
/etc  /proc  /sys  /dev  /root  /boot  /run
/var/run/docker.sock
/   （根文件系统）
```

**禁止的网络模式**：

```
host                 （绕过网络隔离）
container:<id>       （命名空间加入）
```

**默认安全配置**：

```
readOnlyRoot: true
network: "none"
capDrop: ["ALL"]
```

### SandBox 三档配置矩阵（原文 3.8.3 / 3.8.4 / 3.8.5）

| 维度 | 档位与默认 |
|---|---|
| 隔离模式 mode | `off` / `non-main`（默认）/ `all` |
| 容器作用域 scope | `session`（默认）/ `agent` / `shared` |
| 工作区访问 workspaceAccess | `none`（默认）/ `ro` / `rw` |

### 记忆系统目录布局（原文 3.9.2）

```
~/.openclaw/workspace/
├── MEMORY.md           # 长期记忆（精选、持久化）
└── memory/
    └── YYYY-MM-DD.md   # 每日记忆日志（append-only）
```

### MemorySearchResult 类型（原文 3.9.3）

```typescript
type MemorySource = "memory" | "sessions";
type MemorySearchResult = {
  path: string;           // 文件路径
  startLine: number;      // 起始行号
  endLine: number;        // 结束行号
  score: number;          // 相关性得分
  snippet: string;        // 文本片段（~700 字符）
  source: MemorySource;   // 来源类型
  citation?: string;      // 引用标注
};
```

### 混合搜索分数融合（原文 3.9.5）

```
finalScore = vectorWeight * vectorScore + textWeight * textScore
```

权重归一化为 1.0，默认 `vectorWeight=0.7`、`textWeight=0.3`。

### MMR 去重算法（原文 3.9.6）

```
score = λ × relevance - (1-λ) × max_similarity_to_selected
```

`λ` 参数：1.0 = 纯相关性（不去重），0.0 = 最大多样性（忽略相关性），默认 0.7 平衡。

### 时间衰减公式（原文 3.9.6）

```
decayedScore = score × e^(-λ × ageInDays)
```

半衰期默认 30 天：今天 100% / 7 天 84% / 30 天 50%。

## 摘录

> Sandbox 是 OpenClaw 的 Docker 隔离层，用于在容器中执行 AI Agent 的工具操作，而非直接在主机上运行。核心目的是限制工具执行（exec、read、write、edit 等）的安全边界，减少模型执行意外操作时的"爆炸半径"，提供可配置的隔离级别。沙箱模式分三档："off"不隔离、"non-main"仅隔离非主会话（默认）、"all"所有会话都隔离；容器作用域分三档："session"每个会话一个容器（默认）、"agent"每个 Agent 一个容器、"shared"所有会话共享一个容器；工作区访问权限分三档："none"完全隔离、"ro"只读挂载、"rw"读写挂载。

> OpenClaw 的记忆系统采用"文件即真相"的设计哲学：存储介质是纯 Markdown 文件（人类可读可编辑），索引机制是 SQLite + 向量嵌入（机器可搜索），工作模式为文件优先、索引辅助。分层设计上，MEMORY.md 是长期记忆，存储决策、偏好、重要事实；memory/YYYY-MM-DD.md 是短期记忆，存储日常笔记、临时上下文。混合搜索同时使用向量搜索（理解语义、容错性强、对精确 token 弱）与 BM25（精确匹配 ID/代码符号/错误字符串），通过加权融合输出 Top-K 结果。

> 为什么需要混合搜索？向量搜索优势：理解语义（"Mac Studio gateway host" ≈ "运行 gateway 的机器"）、容错性强（拼写错误、同义词）；向量搜索劣势：对精确 token 弱（ID、代码符号、错误字符串）。BM25 优势：精确匹配（a828e60、memorySearch.query.hybrid）、高信号 token。

## 涉及实体

- [[OpenClaw]] —— 本文是其下半部分架构总览
- [[OpenClaw-SandBox]] —— 本文 3.8 完整定义了 SandBox 子系统的全部行为

## 涉及主题

（本篇为单文档来源，主题待累计 ≥5 篇同议题来源后聚合）

## 我的评注

- 记忆系统的"文件即真相"是这篇下篇里最值得借鉴的设计——把 SQLite 和向量索引降级为"加速器"，主存仍然是用户能直接打开的 Markdown 文件。这与本知识库（[[OpenClaw]]→llm-wiki 自身）的方向不谋而合
- SandBox 四层策略"只能收紧不能放宽"的单调性是个干净的安全工程模式：审计时只需看最严的那一层是否足够，不必跟着所有合并规则走
- 混合搜索 + MMR + 时间衰减"三件套"是工业级记忆检索的成熟路径，但默认参数（λ=0.7、半衰期 30 天、向量权重 0.7）比较激进偏新——长尾信息可能被时间衰减压得太低，使用时建议按场景调
- 文章下篇没有明确讨论"自进化机制"在出错回滚 / 审计 / 多人协作场景下的边界，这是 [[OpenClaw]] 后续值得继续追的开放问题
