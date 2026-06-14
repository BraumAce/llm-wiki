---
title: "sso-cli"
type: entity
date: 2026-06-12
also_known_as:
  - "SSO CLI 工具"
  - "SSO 命令行工具"
tags: [CLI, SSO, security, Agent]
sources: [面向-Agent-Skill的-CLI-SSO-鉴权体系]
related_entities: [Agent-Skill-Auth, Credential-Brokering]
---

# sso-cli

## 一句话定义

sso-cli 是一个独立的命令行工具，负责 SSO 登录流程的编排、凭证的安全存储、多用户隔离，是 Agent-Skill-Auth 体系的核心组件，设计目标是在极不安全假设下安全地存储用户的 SSO Token。

## 摘要

sso-cli 的设计目标是"在极不安全假设下安全地存储用户的 SSO Token"——即使沙箱环境可能被任何人读取，也要确保 Token 安全。它的核心设计思想是"本地不留存可用明文，即使拿到密文和源码也难以解密"。

sso-cli 不提供 Token 直接读取的接口给外部，所有操作都通过命令行接口完成。它支持 Agent 场景的 poll 授权模式，能够下发一次性 code 并由客户端轮询换取 Token，这是整套方案能够运转的基础通用能力。sso-cli 的安全模型基于三层防护：系统 keychain 存储主密钥、加密文件存储 Token、加密临时环境变量标识用户。

## 详情

### 核心机制 / 工作原理

```
安全存储架构三层防护：

第一层：主密钥生成与存储
- 首次运行时生成随机主密钥（256-bit AES 密钥）
- 存储在系统 keychain 中（macOS Keychain / Linux Secret Service）
- 仅在需要加解密时从 keychain 取出
- 用完即从内存中擦除（memset_s 或显式清零）

第二层：加密文件存储
- Token 使用主密钥加密后存储在本地文件
- 加密算法：AES-256-GCM（认证加密，防篡改）
- 文件内通过 key 粒度隔离多用户（而非每个用户一个文件）
- 没有主密钥，即使拿到密文文件也无法解密

第三层：多用户隔离
- 使用加密的临时环境变量标识用户身份
- 共享沙箱中每个用户有独立的加密标识
- 请求通过加密标识关联到正确的用户 Token
- 防止用户间身份覆盖和越权访问
```

### 命令行接口

```
sso-cli 主要命令：
- sso-cli login：启动登录流程
  - 向 SSO 平台申请一次性 code
  - 通过飞书卡片让用户授权
  - 轮询换取 Token
  - Token 获取后加密存储

- sso-cli status：检查登录状态
  - 显示当前登录用户
  - 显示 Token 过期时间

- sso-cli logout：登出
  - 清除本地加密的 Token

- sso-cli token：获取当前 Token
  - 内部使用，不对外暴露
  - 从加密文件解密后通过环境变量传递
```

### 安全假设与威胁模型

```
假设：沙箱环境可能被任何人读取（共享服务器、容器逃逸等）
保护目标：用户的 SSO Token 不被窃取
威胁分析：
- 攻击者可以读取文件系统 → 密文文件无法解密（无主密钥）
- 攻击者可以获取源码 → 主密钥不在源码中
- 攻击者无法获取系统 keychain 的内容（除非 root）
- 攻击者无法获取进程内存（除非 root）
```

### 应用 / 使用场景

- Agent Skill 调用需要 SSO 鉴权的企业 API
- 共享开发环境下的多用户隔离
- CI/CD 流水线中的安全 Token 管理
- 多租户 Agent 沙箱环境

### 局限与争议

- 依赖系统 keychain，某些环境（如 Docker 容器）不可用，需要降级方案
- 主密钥的安全性依赖系统 keychain 的安全性，如果系统被 root 攻击则无法保护
- poll 授权模式需要 SSO 平台支持，不是所有企业 SSO 都提供此接口
- Token 加密增加了每次调用的延迟（通常在毫秒级，可接受）
- 跨平台兼容性需要额外处理（macOS/Linux/Windows 的 keychain API 不同）

## 与其他实体的关系

- [[Agent-Skill-Auth]] —— sso-cli 是 Agent-Skill-Auth 体系的核心工具
- [[Credential-Brokering]] —— sso-cli 实现了凭据代理模式

## 参考来源

- [[面向-Agent-Skill的-CLI-SSO-鉴权体系]]
