---
title: "面向 Agent Skill 的 CLI/SSO 鉴权体系：安全、无感、可追溯"
type: source
date: 2026-06-12
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/iyYw5PG8csCYOEoKsC9wxQ"
author: "货拉拉技术"
ingested_at: 2026-06-12
tags: [Agent-Skill, SSO, CLI, 鉴权, 安全]
related_entities: [Agent-Skill-Auth, sso-cli, Credential-Brokering, OpenClaw]
related_topics: [Skill开发最佳实践]
---

# 面向 Agent Skill 的 CLI/SSO 鉴权体系：安全、无感、可追溯

## 一句话概括

为 Agent Skill 调用企业内部系统设计的 SSO 鉴权方案，通过 keychain 主密钥 + 密文文件 + 飞书 Hook 登录 + Agent 轮询授权，实现 token 不落盘、多用户隔离、登录过程无感。

## 实践内容

### 核心架构组件

```
三个核心组件：
- sso-cli：独立命令行工具，负责 SSO 登录流程编排、凭证安全存储、多用户隔离
- 业务 CLI：封装企业内部 HTTP API，面向 Agent 友好
- sso-sdk：私有 SDK 包，供业务 CLI 集成鉴权能力
```

### 安全存储设计（keychain + 密文文件）

```
安全模型：
1. 主密钥存储在系统 keychain 中（macOS Keychain / Linux Secret Service）
2. 仅在需要加解密时从 keychain 取出主密钥，用完即从内存中擦除
3. Token 加密后存储在本地文件中
4. 没有主密钥，即使拿到密文文件也无法解密
5. 文件内通过 key 粒度隔离多用户，而非每个用户一个文件
```

### Agent 轮询授权模式（poll）

```
登录流程：
1. sso-cli 启动登录流程，向 SSO 平台申请一次性 code
2. 通过飞书卡片让用户授权
3. 按间隔时间轮询 SSO 平台换取 Token
4. Token 获取后加密存储
```

### 多用户隔离与临时环境变量

```
隔离机制：
- 使用加密的临时环境变量标识用户身份
- 共享沙箱中每个用户有独立的加密标识
- 请求通过加密标识关联到正确的用户 Token
- 防止用户间身份覆盖和越权访问
```

### Agent Skill 集成

```
在 OpenClaw / Claude Code 等框架中的集成方式：
1. Skill 配置中声明需要的 CLI 工具
2. Agent 调用 Skill 时，自动触发 sso-cli 登录（如未登录）
3. 登录完成后，Token 通过环境变量注入到业务 CLI
4. 业务 CLI 使用 sso-sdk 从环境变量获取 Token 并调用 API
```

## 摘录

> 在智能体（Agent）通过 Skill 调用企业内部业务系统时，最大的阻碍往往不是接口能力，而是"鉴权"。本文介绍一套面向 Agent 场景的 CLI/SSO 鉴权方案，围绕 sso-cli、业务 CLI 以及一个私有的 sso-sdk 包，构建起一套 token 不落盘、不对外暴露、多用户隔离、登录过程无感的安全鉴权体系。

> 在极不安全假设（沙箱环境可能被任何人读取）下，安全地存储用户的 SSO Token，并支持多用户隔离。它的设计思想是"本地不留存可用明文，即使拿到密文和源码也难以解密"。主密钥存储在系统 keychain 中，仅在需要加解密时取出，用完即从内存中擦除。

## 涉及实体

- [[Agent-Skill-Auth]] —— 面向 Agent Skill 的鉴权体系设计
- [[sso-cli]] —— SSO 登录流程编排与凭证安全存储的 CLI 工具
- [[Credential-Brokering]] —— 凭据代理模式，安全传递 Token 给 Agent
- [[OpenClaw]] —— Agent 框架之一，支持 Skill 集成

## 涉及主题

- [[Skill开发最佳实践]]
