---
title: "wechat-cli 源码剖析"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/ijH6SizUBxim5OLHXUtV8g"
author: "Agent工程化"
ingested_at: 2026-05-30
tags: [wechat, cli, source-code-analysis, wechat-api]
related_entities: [[wechat-cli]]
related_topics: 命令行工具开发, 微信接口逆向
---

# wechat-cli 源码剖析

## 一句话概括
对 wechat-cli 项目源码的深度解读与架构分析，涵盖其与微信交互的核心实现机制。

## 实践内容

wechat-cli 是一个命令行工具，用于查询本地微信数据。它直接读取微信在本地存储的 SQLCipher 加密数据库，通过进程内存扫描提取加密密钥，实现透明解密和查询。所有操作完全在本地完成，数据不会离开本机。核心定位是只读查询——不发送、不修改、不删除任何消息，不干扰微信的正常运行。它被设计为 AI Agent 的工具：默认输出结构化 JSON，可直接被 Claude Code、OpenClaw 等 AI 编程助手调用。

### 核心架构

wechat-cli 采用分层架构，从上到下分为 CLI 命令层、核心逻辑层和平台适配层：

- `main.py` — CLI 入口，Click 命令组
- `commands/` — 11 个子命令实现（init、sessions、history、search、export、stats、favorites、unread、new-messages、contacts、members）
- `core/` — 核心逻辑（config、context、crypto、db_cache、key_utils、messages、contacts）
- `keys/` — 平台适配的密钥提取（common、scanner_windows、scanner_macos、scanner_linux）
- `output/formatter.py` — JSON/Text 输出格式化

### 技术栈

| 组件 | 技术 | 用途 |
|------|------|------|
| CLI 框架 | Click 8.1+ | 命令行参数解析、子命令注册 |
| 加密解密 | pycryptodome | AES-256-CBC 页级解密 |
| 内容解压 | zstandard | zstd 压缩的消息内容解压 |
| 数据库 | sqlite3（标准库） | 查询解密后的 SQLite 数据库 |
| XML 解析 | xml.etree.ElementTree | 解析 appmsg、voip 等 XML 内容 |
| HMAC 验证 | hashlib + hmac | HMAC-SHA512 密钥正确性校验 |
| 内存扫描 | ctypes（Windows）/ C 二进制（macOS）/ procfs（Linux） | 进程内存读取提取密钥 |

### 核心实现机制

**初始化与密钥提取（init 命令）**：自动检测微信数据目录、提取加密密钥、生成配置文件。auto_detect_db_dir() 根据平台在默认路径中搜索微信数据目录（macOS: `~/Library/Containers/com.tencent.xinWeChat/`，Windows: `%APPDATA%/Tencent/xwechat/`，Linux: `~/Documents/xwechat_files/`）。

**SQLCipher 4 数据库解密（crypto.py）**：微信使用 SQLCipher 4 对本地数据库进行加密。每页 4096 字节，Page 1 前 16 字节是 Salt（未加密），每页保留 80 字节：16 字节 IV + 64 字节 HMAC-SHA512。full_decrypt() 函数逐页读取加密文件，调用 decrypt_page() 解密后写入明文 SQLite 文件。

**进程内存扫描与密钥匹配（keys/）**：微信运行时将加密密钥保存在进程内存中，wechat-cli 通过扫描进程内存寻找特定模式的 hex 字符串来提取密钥。Windows 使用 ctypes 调用 Win32 API（OpenProcess + ReadProcessMemory），macOS 使用预编译的 C 二进制，Linux 通过 /proc/pid/mem 和 /proc/pid/maps 读取。通过 HMAC-SHA512 校验密钥正确性。

**消息数据库发现与查询（messages.py）**：最大模块（约 600 行），微信将消息存储在多个数据库文件中（message_0.db、message_1.db...），每个数据库内按用户的 MD5 哈希建表。支持 zstd 内容解压、XML 格式富媒体消息解析（引用消息、文件消息、链接消息、小程序消息、通话消息）。

**联系人管理与模糊匹配（contacts.py）**：实现联系人加载、缓存和模糊匹配，匹配策略按优先级：直接匹配 wxid 或 chatroom 格式的 username → 显示名精确匹配（不区分大小写）→ 显示名模糊匹配（子串包含）。

**解密缓存与 mtime 增量更新（db_cache.py）**：DBCache 通过文件修改时间检测数据库变化，避免重复解密。缓存目录位于 `%TEMP%/wechat_cli_cache/`，缓存元信息持久化到 `_mtimes.json`，跨会话复用。

### 11 个查询命令

- `sessions` — 查询 session/session.db 中的 SessionTable，返回按最后消息时间排序的会话列表
- `history` — 最常用的命令之一，支持分页、时间范围过滤和消息类型过滤（text/image/voice/video/sticker/location/link/file/call/system）
- `search` — 支持三种搜索范围：全局搜索、单聊搜索和多聊搜索，使用 LIKE '%keyword%' SQL 模糊匹配
- `stats` — 聚合统计聊天数据，返回消息总数、类型分布、发送者排行和 24 小时活跃分布
- `export` — 将聊天记录导出为 Markdown 或纯文本格式，默认导出最近 500 条
- `favorites` — 查询 favorite/favorite.db 中的 fav_db_item 表，支持按类型过滤和关键词搜索
- `unread` — 查询 SessionTable 中 unread_count > 0 的会话
- `new-messages` — 增量消息追踪，通过时间戳对比实现，状态持久化到 `~/.wechat-cli/last_check.json`
- `contacts` — 支持搜索和详情查询，详情返回昵称、备注、微信号、简介、头像 URL、账号类型等信息
- `members` — 查询群聊成员列表，通过 contact.db 的 chatroom_member 关联表查询
- `init` — 初始化（密钥提取 + 配置生成）

### 技术亮点

- **HMAC-SHA512 密钥验证机制**：提取时验证 + 交叉验证，mac_salt = salt XOR 0x3A，再用 PBKDF2-SHA512 派生 MAC 密钥
- **跨平台内存扫描策略**：Windows（ReadProcessMemory）、macOS（预编译 C 二进制，自动 re-sign 微信添加调试权限）、Linux（/proc/pid/mem，需 root 或 CAP_SYS_PTRACE）
- **zstd 内容解压与 XML 解析**：部分消息以 zstd 压缩存储（WCDB_CT_message_content == 4），XML 安全解析使用白名单过滤防止 XXE 攻击
- **增量状态持久化（new-messages）**：状态文件记录每个会话的最后消息时间戳，每次调用对比当前状态和上次记录，只返回新增的消息

### 安装与初始化

```bash
# npm（推荐，无需 Python 环境）
npm install -g @canghe_ai/wechat-cli

# pip（需要 Python >= 3.10）
pip install wechat-cli
```

初始化：确保微信正在运行且已登录，macOS 需要授予终端"完全磁盘访问"权限，执行 `wechat-cli init`（macOS/Linux 需 sudo）。

### 作为 AI Agent 工具使用

在项目的 CLAUDE.md 中添加配置，让 AI 助手能主动查询微信数据来辅助工作。常用命令包括 sessions、history、search、contacts、unread、new-messages 等。

### 适用场景

AI Agent 集成（让 AI 助手查询微信消息）、聊天记录备份导出、消息搜索和统计分析。不适合需要写操作（发消息、发朋友圈）的场景——这是刻意的设计选择，确保工具的安全性和合规性。

## 摘录
> wechat-cli 是一个命令行工具，用于查询本地微信数据。它直接读取微信在本地存储的 SQLCipher 加密数据库，通过进程内存扫描提取加密密钥，实现透明解密和查询。所有操作完全在本地完成，数据不会离开本机。该工具的核心定位是只读查询——不发送、不修改、不删除任何消息，不干扰微信的正常运行。它被设计为 AI Agent 的工具：默认输出结构化 JSON，可直接被 Claude Code、OpenClaw 等 AI 编程助手调用。

> wechat-cli 的密钥提取采用了 HMAC-SHA512 双重验证机制：提取时验证，在内存中找到候选 hex 字符串后，用对应数据库 Page 1 的 HMAC 校验密钥正确性；交叉验证，对于未找到密钥的 salt，用已确认的密钥尝试解密（不同数据库可能共享同一密钥）；mac_salt 派生，mac_salt = salt XOR 0x3A，再用 PBKDF2-SHA512 派生 MAC 密钥。这套机制确保了密钥提取的可靠性——即使内存中存在大量 hex 模式的干扰数据，也能精确识别出正确的密钥。

> wechat-cli 是一个设计精良的本地微信数据查询工具，核心亮点包括：纯本地、只读，不与微信服务器通信，不发送/修改/删除任何数据，不违反微信服务条款；透明解密，通过进程内存扫描提取密钥，AES-256-CBC 页级解密，用户无感知；跨平台，Windows（ReadProcessMemory）、macOS（C 二进制）、Linux（/proc/pid/mem）三种扫描策略共享验证逻辑；AI 友好，默认 JSON 输出，专为 LLM Agent 工具调用设计；增量查询，new-messages 命令通过时间戳对比实现增量消息追踪，适合自动化场景。

> macOS 使用预编译的 C 二进制进行内存扫描（因为 Python 的 task_for_pid 调用需要特殊权限）。如果 task_for_pid 失败，自动对 WeChat.app 重新签名（保留原有 entitlements，仅添加 com.apple.security.get-task-allow）。需要授予终端"完全磁盘访问"权限。

## 涉及实体
- [[wechat-cli]] —— 被剖析的目标项目

## 涉及主题
- 命令行工具开发
- 微信接口逆向
