---
title: "Project-NOMAD"
type: entity
date: 2026-07-05
also_known_as:
  - "Project N.O.M.A.D."
  - "Node for Offline Media, Archives, and Data"
  - "Crosstalk-Solutions/project-nomad"
tags:
  - offline-knowledge
  - local-ai
  - rag
  - docker
  - kiwix
  - qdrant
sources:
  - "[[Project-NOMAD-GitHub]]"
related_entities:
  - "[[RAG]]"
  - "[[whichllm]]"
  - "[[OmniRoute]]"
---

# Project-NOMAD

## 一句话定义

Project-NOMAD 是一个离线优先的知识与教育服务器，用浏览器 Command Center 管理离线内容、容器化应用、本地 AI Chat、文档 RAG、地图、教育课程和系统更新。

## 摘要

[[Project-NOMAD-GitHub]] 将 Project N.O.M.A.D. 展开为 “Node for Offline Media, Archives, and Data”，核心口号是 “Knowledge That Never Goes Offline”。它不是单一 RAG 应用，也不是单纯的本地模型前端，而是一个面向断网、远程地点、教育和隐私场景的离线知识服务器。安装后用户通过浏览器访问 `http://localhost:8080` 或设备局域网 IP，使用 Command Center 下载和管理 Kiwix 离线百科、Kolibri 教育内容、ProtoMaps 离线地图、CyberChef、FlatNotes、Ollama/Qdrant AI Assistant、Supply Depot 应用目录和系统 benchmark。

它在知识库体系里的价值，是把 [[RAG]] 放进完整离线信息系统中。许多 RAG 项目默认有云端 embedding、在线检索或企业文档后台，而 Project-NOMAD 的假设是网络可能不可用，所以更重视“预先下载内容、保存在本地、通过浏览器访问、用本地模型回答、用 Qdrant 做语义检索、用 Docker 编排依赖”。这种方向适合应急准备、家庭教育、远程工作站、旅行、医疗参考、学术研究和隐私敏感查询。它让知识库不再只是“文档问答”，而是包含内容获取、存储预算、离线 UI、地图、教育、更新窗口和硬件基准的一套系统。

## 详情

### 起源与背景

Project-NOMAD 来自 Crosstalk Solutions，仓库在 GitHub API 抓取时显示为 TypeScript 项目，Apache-2.0 许可证。README 描述它是 self-contained、offline-first 的知识与教育服务器，初始安装需要联网下载依赖和资源，之后正常使用不依赖互联网，并声称没有内置 telemetry。它推荐 Debian-based OS，Ubuntu 为首选；WSL2 是社区支持路径；ARM 和非 Debian 发行版并非官方优化目标。

### 核心机制 / 工作原理

系统主体是 Command Center：一个 AdonisJS + TypeScript + React/Inertia 的管理应用，通过 Docker outside of Docker 模式管理宿主机上的容器。`install/management_compose.yaml` 定义了 `admin`、`mysql`、`redis`、`dozzle`、`updater`、`disk-collector` 等服务。admin 容器绑定 `/var/run/docker.sock`，默认把数据写入 `/opt/project-nomad/storage`，用 MySQL 存储管理状态，用 Redis 支撑缓存、队列和定时任务。

```bash
sudo apt-get update && \
sudo apt-get install -y curl && \
curl -fsSL https://raw.githubusercontent.com/Crosstalk-Solutions/project-nomad/refs/heads/main/install/install_nomad.sh \
  -o install_nomad.sh && \
sudo bash install_nomad.sh
```

RAG 相关实现集中在 `RagService`：Qdrant collection 名为 `nomad_knowledge_base`，embedding dimension 为 768，模型上下文长度按 2048 token 处理，目标 chunk 为 1500 token，查询和文档分别加 `search_query:` 与 `search_document:` 前缀，批量 embedding 默认为 8。服务还处理 PDF、OCR、ZIP/HTML、ZIM 内容抽取、上传文件索引、Qdrant payload index 和知识库健康检查。这个实现说明它采用的是“本地文件处理 + 本地 embedding + 向量数据库 + 本地/兼容模型问答”的标准 RAG 路线。

### 应用 / 使用场景

- 应急准备：离线医疗、急救、灾害、地图、无线电、求生和操作手册。
- 家庭教育：Kolibri/Khan Academy、Wikipedia for Schools、Project Gutenberg 和 AI tutor。
- 远程工作站：上传 SOP、技术手册、法规和项目文档，让本地 AI 在断网环境回答。
- 隐私搜索：搜索 Wikipedia 和本地文档，不把问题、上传文件或对话发给第三方服务。
- 学术/个人研究：预加载资料，在没有校园网或互联网时继续检索、摘要和交叉引用。

### 局限与争议

Project-NOMAD 的边界同样明确。首先，它没有内置认证，README 建议用网络层控制访问，并不建议直接暴露到互联网；考虑到 admin 容器可以通过 Docker socket 管理服务，这个安全提醒不是形式问题。其次，AI 功能可选，但如果要跑本地模型，硬件需求会明显上升，README 建议 32GB RAM、RTX 3060 或同级 GPU、250GB SSD 才能获得更好的体验。再次，它依赖预下载内容，真正断网前必须完成资源选择、下载、索引、更新和功能测试，否则离线时很难补救。

## 与其他实体的关系

- [[RAG]] —— Project-NOMAD 的 Knowledge Base 用 Qdrant 和本地模型实现文档感知 AI Chat，是离线 RAG 的典型应用。
- [[whichllm]] —— whichllm 帮用户判断本地模型和硬件，Project-NOMAD 则把本地 AI 能力整合进离线知识服务器。
- [[OmniRoute]] —— OmniRoute 解决多 provider gateway，Project-NOMAD 解决离线内容与本地服务编排，二者都属于 AI 使用前后的基础设施层。

## 参考来源

- [[Project-NOMAD-GitHub]]
