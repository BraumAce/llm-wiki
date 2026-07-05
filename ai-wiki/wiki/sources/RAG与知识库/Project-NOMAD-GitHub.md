---
title: "Project-NOMAD GitHub"
type: source
date: 2026-07-05
source_type: webpage
source_url: "https://github.com/Crosstalk-Solutions/project-nomad"
author: "Crosstalk-Solutions"
ingested_at: 2026-07-05
tags:
  - offline-knowledge
  - rag
  - local-ai
  - qdrant
  - ollama
  - docker
  - kiwix
related_entities:
  - "[[Project-NOMAD]]"
  - "[[RAG]]"
  - "[[whichllm]]"
  - "[[OmniRoute]]"
related_topics:
  - "[[AI-Infra推理优化-主题]]"
---

# Project-NOMAD GitHub

## 一句话概括

Project N.O.M.A.D. 是一个离线优先的知识与教育服务器，用 Docker 编排 Kiwix、Kolibri、ProtoMaps、Ollama、Qdrant 等工具，把离线内容库、本地 AI Chat、文档 RAG、地图和应用目录整合到浏览器访问的 Command Center。

## 实践内容

```bash
sudo apt-get update && \
sudo apt-get install -y curl && \
curl -fsSL https://raw.githubusercontent.com/Crosstalk-Solutions/project-nomad/refs/heads/main/install/install_nomad.sh \
  -o install_nomad.sh && \
sudo bash install_nomad.sh
```

```text
http://localhost:8080
http://DEVICE_IP:8080
```

```yaml
services:
  admin:
    image: ghcr.io/crosstalk-solutions/project-nomad:latest
    container_name: nomad_admin
    ports:
      - "8080:8080"
    volumes:
      - /opt/project-nomad/storage:/app/storage
      - /var/run/docker.sock:/var/run/docker.sock
  mysql:
    image: mysql:8.0
  redis:
    image: redis:7-alpine
  updater:
    image: ghcr.io/crosstalk-solutions/project-nomad-sidecar-updater:latest
  disk-collector:
    image: ghcr.io/crosstalk-solutions/project-nomad-disk-collector:latest
```

```text
CONTENT_COLLECTION_NAME = nomad_knowledge_base
EMBEDDING_DIMENSION = 768
MODEL_CONTEXT_LENGTH = 2048
MAX_SAFE_TOKENS = 1600
TARGET_TOKENS_PER_CHUNK = 1500
PREFIX_TOKEN_BUDGET = 10
CHAR_TO_TOKEN_RATIO = 2
SEARCH_DOCUMENT_PREFIX = search_document:
SEARCH_QUERY_PREFIX = search_query:
EMBEDDING_BATCH_SIZE = 8
```

```bash
sudo bash /opt/project-nomad/start_nomad.sh
sudo bash /opt/project-nomad/stop_nomad.sh
sudo bash /opt/project-nomad/update_nomad.sh
curl -fsSL https://raw.githubusercontent.com/Crosstalk-Solutions/project-nomad/refs/heads/main/install/uninstall_nomad.sh -o uninstall_nomad.sh && sudo bash uninstall_nomad.sh
```

## 摘录

> Project N.O.M.A.D. is described as a self-contained, offline-first knowledge and education server packed with critical tools, knowledge, and AI. The README says it is a management UI and API, called Command Center, that orchestrates containerized tools and resources through Docker. Built-in capabilities include local AI chat powered by Ollama or OpenAI-compatible software such as LM Studio or llama.cpp, document upload and semantic search via Qdrant, offline Wikipedia and medical references through Kiwix, Kolibri courses, ProtoMaps regional maps, CyberChef, FlatNotes, benchmark scoring, Supply Depot, automatic updates, and an easy setup wizard.

> The project is designed for offline usage: internet is required during initial installation and when the user decides to download additional tools or resources, but otherwise the system does not require internet and has zero built-in telemetry. The README also states that the project currently includes no authentication, recommends network-level access control for LAN exposure, and strongly advises against exposing an instance directly to the internet unless the operator understands the security risks and has taken appropriate measures.

## 涉及实体

- [[Project-NOMAD]] —— 本项目实体，离线知识库、本地 AI 与容器化应用管理平台。
- [[RAG]] —— Project N.O.M.A.D. 的 Knowledge Base 使用 Qdrant 语义搜索和本地 AI Chat 形成文档感知问答。
- [[whichllm]] —— 两者都服务本地 AI 部署决策；whichllm 偏模型/硬件选型，Project N.O.M.A.D. 偏离线服务集成。
- [[OmniRoute]] —— 两者都位于 AI 使用基础设施层；OmniRoute 管 provider 路由，Project N.O.M.A.D. 管离线内容和本地服务编排。

## 涉及主题

- [[AI-Infra推理优化-主题]]

## 我的评注

Project N.O.M.A.D. 把 RAG 从企业知识库场景拉到“断网也能用”的个人/家庭/远程站点场景：内容预下载、知识库索引、本地模型、地图和教育资源同等重要。它的关键工程取舍是把 Docker socket、内容管理、RAG、地图、更新和应用目录交给一个本地 Command Center；这降低了普通用户搭建离线知识系统的门槛，但也带来明确的安全边界，尤其是无内置认证和 Docker socket 管理能力不适合公网暴露。
