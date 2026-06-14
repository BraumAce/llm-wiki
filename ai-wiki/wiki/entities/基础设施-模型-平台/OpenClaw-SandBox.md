---
title: "OpenClaw-SandBox"
type: entity
date: 2026-05-10
also_known_as:
  - "OpenClaw 沙箱系统"
  - "OpenClaw Sandbox"
tags:
  - security
  - docker
  - sandbox
  - openclaw-module
sources:
  - "[[深入理解OpenClaw技术架构与实现原理-下]]"
related_entities:
  - "[[OpenClaw]]"
---

# OpenClaw-SandBox

## 一句话定义

OpenClaw-SandBox 是 [[OpenClaw]] 的 Docker 隔离子系统，在容器中执行 AI Agent 的工具操作（exec / read / write / edit / browser 等），用配置可调的隔离级别约束 Agent 的"爆炸半径"，避免模型出错时直接污染主机。

## 摘要

SandBox 不是一个单独的产品，而是 [[OpenClaw]] 内部围绕"工具执行安全"构建的一组组件——Docker 容器管理、工具策略、文件系统桥接、安全验证、容器自动清理。它的核心价值是把"让 AI 帮我跑命令"从一个**赌博式的信任问题**变成一个**有刻度的工程问题**：可以选择不隔离、只隔离非主会话、或者全部隔离；每会话一个容器、每 Agent 一个容器、还是共享一个容器；以及工作区是无访问、只读挂载，还是读写挂载。

## 详情

### 核心目的

- **限制工具执行的安全边界**：exec、read、write、edit 等危险操作只能在容器内发生
- **减少"爆炸半径"**：模型执行意外操作时，最多只能搞坏容器，搞不坏主机
- **可配置的隔离级别**：默认安全但不一刀切，按场景松紧

### 关键文件结构

```
src/agents/sandbox/
├── types.ts          # 核心类型定义
├── config.ts         # 配置合并逻辑
├── context.ts        # 入口点 - 解析沙箱上下文
├── docker.ts         # Docker 容器管理
├── browser.ts        # 隔离浏览器容器
├── tool-policy.ts    # 工具允许/拒绝策略
├── validate-sandbox-security.ts  # 安全验证
├── fs-bridge.ts      # 文件系统操作桥接
└── prune.ts          # 容器自动清理
```

### 三档沙箱模式

| 模式 | 行为 |
|---|---|
| `off` | 不隔离，所有工具直接在主机运行 |
| `non-main` | 仅隔离非主会话（**默认**） |
| `all` | 所有会话都隔离 |

`non-main` 是默认选择——既保留了主会话"我自己用"的便利，又把不可信来源（群组、外部频道）默认隔离。

### 容器作用域

| 作用域 | 容器数量 | 适用 |
|---|---|---|
| `session` | 每个会话一个容器（**默认**） | 强隔离，资源占用大 |
| `agent` | 每个 Agent 一个容器 | 平衡 |
| `shared` | 所有会话共享一个容器 | 弱隔离，资源占用小 |

### 工作区访问权限

| 权限 | 挂载行为 |
|---|---|
| `none` | 完全隔离的工作区 `~/.openclaw/sandboxes` |
| `ro` | 只读挂载 Agent 工作区到 `/agent` |
| `rw` | 读写挂载到 `/workspace` |

### 安全限制（强制黑名单）

- **禁止的绑定挂载**：`/etc`、`/proc`、`/sys`、`/dev`、`/root`、`/boot`、`/run`、Docker socket `/var/run/docker.sock`、根文件系统 `/`
- **禁止的网络模式**：`host`（绕过网络隔离）、`container:<id>`（命名空间加入）
- **默认安全配置**：只读根文件系统、`network: "none"`、`capDrop: ["ALL"]`

### 工具策略层级

隔离时工具按以下顺序过滤：

1. **全局工具策略**
2. **Agent 特定策略**
3. **Sandbox 工具策略**（只能进一步限制，不能放宽）
4. **子 Agent 策略**

默认允许：`exec`、`read`、`write`、`edit`、`apply_patch`、`image` 等。
默认禁止：`browser`、`canvas`、`nodes`、`cron`、`gateway`、所有消息通道。

### 配置示例（来自原文）

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

### CLI 命令

- `openclaw sandbox list` —— 列出沙箱容器
- `openclaw sandbox recreate` —— 强制重建容器
- `openclaw sandbox explain` —— 调试当前配置（解释模式合并结果）

### 设计要点

- **只能收紧不能放宽**：四层策略叠加时，下层只能进一步限制上层；这种单调收紧的属性让安全审计变简单
- **默认网络隔离**：`network: "none"` 是 default，不是用户主动开启；想联网必须显式声明
- **容器即"短命资源"**：`prune.idleHours = 24` 让闲置容器自动清理，避免容器堆积造成磁盘膨胀
- **`explain` 命令很用心**：当多层配置叠加导致行为不符预期时，无需手动 diff 配置文件——直接 explain 看合并结果

## 与其他实体的关系

- [[OpenClaw]] —— 父系统；SandBox 的策略受 [[OpenClaw]] 全局工具策略约束

## 参考来源

- [[深入理解OpenClaw技术架构与实现原理-下]]（章节 3.8）

## 相关综合

- [[OpenClaw-digest-20260510]]
