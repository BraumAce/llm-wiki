---
title: "wechat-cli"
type: entity
date: 2026-05-30
also_known_as:
  - "微信命令行工具"
  - "微信 CLI"
  - "wechat_cli"
tags:
  - cli-tool
  - wechat
  - sqlcipher
  - decryption
  - memory-scanning
  - ai-agent-tool
  - python
  - local-first
  - privacy
sources:
  - "wechat-cli 源码剖析"
related_entities:
  - "wechat-decrypt"
  - "SQLCipher"
  - "Click"
  - "pycryptodome"
  - "Claude Code"
  - "[[OpenClaw]]"
---

# wechat-cli

## 一句话定义

wechat-cli 是一个用 Python 编写的命令行工具，用于只读查询本地微信数据——它通过进程内存扫描提取 SQLCipher 加密密钥，透明解密微信的 SQLite 数据库，并提供 11 个子命令查询联系人、聊天记录、收藏等内容，默认输出结构化 JSON 供 AI Agent 直接调用。

## 摘要

微信桌面客户端将所有本地数据存储在 SQLCipher 4 加密的 SQLite 数据库中，普通用户无法直接读取。wechat-cli 解决了这个问题：它在运行时扫描微信进程内存，定位并提取加密密钥，然后按需解密数据库文件进行查询。整个过程完全在本地完成，数据不会离开用户的设备。

这个工具的核心定位是**只读查询**——不发送、不修改、不删除任何消息，不干扰微信的正常运行。它被精心设计为 AI Agent 的工具：默认输出结构化 JSON，可以被 Claude Code、OpenClaw 等 AI 编程助手直接调用，实现"用自然语言查询微信数据"的能力。wechat-cli 基于上游项目 wechat-decrypt 的核心解密能力，在其基础上构建了完整的 CLI 命令层和 AI 工具化架构。

## 详情

### 起源与背景

微信是中国最主流的即时通讯应用，桌面客户端在本地存储了海量的聊天记录、联系人信息、收藏内容等数据。这些数据以 SQLCipher 4 加密方案存储在 SQLite 数据库中，加密密钥在运行时保存在微信进程的内存空间中。

此前已有多个开源项目尝试解密微信数据库，如 PyWxDump、WeChatMsg 等，但大多侧重于数据导出和可视化分析。wechat-cli 的独特之处在于它专注于**命令行查询**和 **AI Agent 工具化**这两个方向。它基于 wechat-decrypt 项目提供的核心解密能力，后者负责 SQLCipher 4 的页级解密算法实现。

wechat-cli 的设计理念与 Local-First 运动一脉相承：用户的数据属于用户自己，应该可以在本地自由访问和分析。同时，它也反映了 AI Agent 工具化的新趋势——将传统的命令行工具重新设计为可供 AI 调用的结构化接口。

### 核心机制 / 工作原理

wechat-cli 的完整执行流程分为三个阶段：初始化提取密钥、按需解密数据库、查询并格式化输出。

**第一阶段：密钥提取（init 命令）**

这是最核心的技术难点。微信运行时将加密密钥保存在进程内存中，wechat-cli 通过扫描进程内存寻找特定模式的 hex 字符串来提取密钥。扫描器针对三个平台分别实现：

- **Windows**：使用 ctypes 调用 kernel32 的 OpenProcess、VirtualQueryEx、ReadProcessMemory API
- **macOS**：编译为 C 二进制，使用 task_for_pid 获取进程内存
- **Linux**：直接读取 /proc/pid/mem

提取到密钥后，通过 HMAC-SHA512 验证其正确性：从 enc_key 使用 PBKDF2-SHA512 派生 MAC 密钥（2 轮迭代），计算页面数据的 HMAC，与数据库中存储的 HMAC 比对。验证通过后保存到 `~/.wechat-cli/all_keys.json`。

内存扫描支持三种 hex 模式：

| 模式 | hex 长度 | 含义 |
|------|----------|------|
| `x'{64hex}{32hex}'` | 96 字符 | enc_key(32B) + salt(16B) 连续存储 |
| `x'{64hex}'` | 64 字符 | 仅 enc_key，需遍历所有 salt 交叉验证 |
| `x'{64hex}...{32hex}'` | >96 字符 | enc_key + 中间数据 + salt，取首尾 |

**第二阶段：按需解密（DBCache）**

每次查询命令加载配置和密钥后，DBCache 模块负责按需解密数据库。它检查数据库文件的 mtime（修改时间），只有在文件发生变化时才重新解密，避免重复解密的开销。

SQLCipher 4 的页面布局为每页 4096 字节。Page 1 特殊处理：头部 16 字节为 Salt（未加密），需要替换为标准 SQLite 文件头。每个页面的尾部保留 80 字节（IV 16 字节 + HMAC-SHA512 64 字节）。解密使用 AES-256-CBC 算法。

**第三阶段：查询与输出**

解密后的数据库通过标准 sqlite3 库查询，结果通过 formatter 模块格式化输出。默认输出 JSON 格式，也可选择纯文本格式。

### 应用 / 使用场景

- **个人数据查询**：用户可以通过命令行快速查找历史聊天记录、联系人信息、群成员列表等
- **AI Agent 工具**：作为 Claude Code、OpenClaw 等 AI 编程助手的工具，实现"用自然语言查询微信数据"——例如问 AI "上周和张三聊了什么"，AI 调用 wechat-cli 的 search 命令获取结果
- **数据导出与备份**：将聊天记录导出为 Markdown 或 TXT 格式，便于长期存档
- **聊天统计分析**：统计特定联系人或群聊的消息频率、活跃时段等
- **未读消息管理**：查看所有未读会话，或获取增量新消息

### 局限与争议

- **仅支持只读**：wechat-cli 严格限定为只读工具，不能发送、修改或删除任何消息，这既是设计选择也是安全边界
- **平台依赖**：密钥提取依赖于各操作系统的进程内存读取能力，在某些安全策略严格的环境下可能无法工作
- **版本敏感**：微信客户端更新可能改变内存布局或加密方案，导致密钥提取失效
- **隐私争议**：虽然数据完全在本地处理，但此类工具的存在本身可能引发关于用户数据访问边界的讨论
- **微信协议风险**：使用此类工具可能违反微信的服务条款，存在账号被限制的风险
- **密钥有效期**：微信进程重启后密钥可能变化，需要重新执行 init 命令

## 与其他实体的关系

- wechat-decrypt —— wechat-cli 所基于的上游项目，提供 SQLCipher 4 的核心解密能力；wechat-cli 在其基础上构建了完整的 CLI 命令层和 AI 工具化架构
- SQLCipher —— 微信本地数据库使用的加密方案（SQLCipher 4，AES-256-CBC 页级加密），wechat-cli 的核心工作就是破解这一层加密
- Click —— wechat-cli 使用的 Python CLI 框架（8.1+），负责命令行参数解析和 11 个子命令的注册与调度
- pycryptodome —— 用于实现 AES-256-CBC 页级解密的 Python 加密库，是 wechat-cli 解密流程的核心依赖
- Claude Code —— AI 编程助手，可以直接调用 wechat-cli 的 JSON 输出，实现自然语言查询微信数据
- [[OpenClaw]] —— AI Agent 框架，wechat-cli 可作为其 Tool 系统中的一个工具被调用

## 参考来源

- wechat-cli 源码剖析 —— 对 wechat-cli 完整源码的深度剖析，涵盖项目结构、SQLCipher 4 解密算法、跨平台内存扫描实现、11 个查询命令设计与 AI Agent 工具化架构

## 技术栈

| 组件 | 技术 | 用途 |
|------|------|------|
| CLI 框架 | Click 8.1+ | 命令行参数解析、子命令注册 |
| 加密解密 | pycryptodome | AES-256-CBC 页级解密 |
| 内容解压 | zstandard | zstd 压缩的消息内容解压 |
| 数据库 | sqlite3（标准库） | 查询解密后的 SQLite 数据库 |
| XML 解析 | xml.etree.ElementTree | 解析 appmsg、voip 等 XML 内容 |
| HMAC 验证 | hashlib + hmac | HMAC-SHA512 密钥正确性校验 |
| 内存扫描 | ctypes（Windows）/ C 二进制（macOS）/ procfs（Linux） | 进程内存读取提取密钥 |

## 项目结构

```
wechat_cli/
├── main.py                    # CLI 入口，Click 命令组
├── commands/                  # 11 个子命令实现
│   ├── init.py                # 初始化（密钥提取 + 配置生成）
│   ├── sessions.py            # 最近会话
│   ├── history.py             # 聊天记录
│   ├── search.py              # 消息搜索
│   ├── export.py              # 导出（markdown/txt）
│   ├── stats.py               # 聊天统计
│   ├── favorites.py           # 微信收藏
│   ├── unread.py              # 未读会话
│   ├── new_messages.py        # 增量新消息
│   ├── contacts.py            # 联系人搜索
│   └── members.py             # 群成员查询
├── core/                      # 核心逻辑
│   ├── config.py              # 配置加载与路径自动检测
│   ├── context.py             # AppContext 单例（全局状态）
│   ├── crypto.py              # SQLCipher 4 解密（AES-256-CBC）
│   ├── db_cache.py            # 解密缓存（mtime 增量）
│   ├── key_utils.py           # 密钥路径匹配工具
│   ├── messages.py            # 消息查询引擎（最大模块，~600 行）
│   └── contacts.py            # 联系人管理
├── keys/                      # 平台适配的密钥提取
│   ├── common.py              # 跨平台共享：HMAC 验证、hex 匹配
│   ├── scanner_windows.py     # Windows: ReadProcessMemory
│   ├── scanner_macos.py       # macOS: C 二进制 + task_for_pid
│   └── scanner_linux.py       # Linux: /proc/pid/mem
└── output/
    └── formatter.py           # JSON/Text 输出格式化
```

<!-- 写作要点：
1. 字数 ≥ 1500（中文字符）
2. 不允许出现 "TODO" / "XXX" / "待补充" / "TBD"
3. 至少 1 个 related、≥ 1 个 sources，frontmatter sources 与正文一致
4. 多次 ingest 同一实体时合并扩展，不覆盖
-->
