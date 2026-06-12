---
title: "Agent-Skill-Auth"
type: entity
date: 2026-06-12
also_known_as:
  - "Agent Skill 鉴权"
  - "Skill 认证体系"
tags: [Agent-Skill, security, authentication]
sources: [面向-Agent-Skill的-CLI-SSO-鉴权体系]
related_entities: [Agent-Skill, sso-cli, Credential-Brokering, OpenClaw]
---

# Agent-Skill-Auth

## 一句话定义

Agent-Skill-Auth 是面向 Agent Skill 调用企业内部系统场景的鉴权体系，通过三层设计（登录层、存储层、隔离层）解决 Agent 无法完成浏览器交互式 SSO 登录、Token 安全存储、多用户隔离等核心安全问题。

## 摘要

当 AI Agent 通过 Skill 调用企业内部业务系统时，最大的阻碍往往不是接口能力，而是鉴权。传统的 Web SSO 鉴权流程依赖"人在浏览器前"完成交互式登录，但 Agent 无法完成这一步骤。早期实践中常采用预置长期 Token 的方式，但导致 Agent 无独立身份、Token 大面积暴露、多用户身份覆盖等严重安全问题。

Agent-Skill-Auth 体系通过三层设计解决这些问题：登录层（Agent 轮询授权模式）、存储层（keychain 主密钥 + 密文文件）、隔离层（加密临时环境变量）。这套体系实现了 Token 不落盘、不对外暴露、多用户隔离、登录过程无感的目标，是企业内部 Agent Skill 能力开放的基础设施。

## 详情

### 起源与背景

2026 年 3 月底，飞书开源了飞书 CLI，将 Agent CLI 概念带到面前。企业内部开始尝试将业务系统能力通过 Agent CLI 方式开放给 Agent 框架（如 OpenClaw、Claude Code）。但 SSO 鉴权成为最大障碍——Agent 无法完成浏览器交互式登录，导致大量业务能力无法对智能体开放。

### 核心机制 / 工作原理

```
三层递进式挑战与解决方案：

挑战一：登录缺失
问题：Agent 无浏览器交互能力，只能靠预置 Token
方案：Agent 轮询授权模式（poll）
- sso-cli 向 SSO 平台申请一次性 code
- 通过飞书卡片让用户授权
- 按间隔时间轮询 SSO 平台换取 Token
- Token 获取后加密存储

挑战二：隔离缺失
问题：共享沙箱内用户身份互相覆盖，审计与权限控制失效
方案：加密临时环境变量
- 每个用户有独立的加密标识
- 请求通过加密标识关联到正确的用户 Token
- 防止用户间身份覆盖和越权访问

挑战三：存储缺失
问题：明文 Token 仍使凭据极易被窃取
方案：keychain + 密文文件
- 主密钥存储在系统 keychain 中
- Token 加密后存储在本地文件
- 没有主密钥无法解密
```

### 应用 / 使用场景

- OpenClaw 中调用企业内部 API 的 Skill
- Claude Code 中需要 SSO 鉴权的业务 CLI
- 共享沙箱环境下的多用户 Agent 场景
- 企业内部智能体能力开放平台

### 局限与争议

- 依赖特定 SSO 平台的 poll 授权模式支持
- keychain 在某些环境下（如 Docker 容器）不可用
- 飞书 Hook 登录需要飞书平台支持
- Token 加密增加了每次调用的延迟
- 跨平台兼容性需要额外处理

## 与其他实体的关系

- [[Agent-Skill]] —— Agent-Skill-Auth 是 Skill 调用企业系统的鉴权保障
- [[sso-cli]] —— Agent-Skill-Auth 的核心 CLI 工具
- [[Credential-Brokering]] —— 凭据代理模式的实现
- [[OpenClaw]] —— 支持 Agent-Skill-Auth 的 Agent 框架

### 安全性分析

```
安全保证：
- Token 不落盘：加密存储在内存中，不写入明文文件
- 不对外暴露：不提供直接读取 Token 的接口
- 多用户隔离：加密标识区分不同用户
- 登录过程无感：Agent 自动完成轮询授权
```

## 参考来源

- [[面向-Agent-Skill的-CLI-SSO-鉴权体系]]
