---
title: "Project-NOMAD GitHub"
source_url: "https://github.com/Crosstalk-Solutions/project-nomad"
author: "Crosstalk-Solutions"
fetched_at: "2026-07-05T22:45:00+08:00"
fetcher: "github-api+git-clone"
---

# GitHub API metadata

- full_name: Crosstalk-Solutions/project-nomad
- description: Project N.O.M.A.D, is a self-contained, offline survival computer packed with critical tools, knowledge, and AI to keep you informed and empowered—anytime, anywhere.
- language: TypeScript
- license: Apache-2.0
- default_branch: main
- stars_at_fetch: 32852
- forks_at_fetch: 3282
- created_at: 2025-06-24T15:35:01Z
- pushed_at: 2026-06-25T18:19:00Z

# README.md 摘录

Project N.O.M.A.D. means Node for Offline Media, Archives, and Data.

Project N.O.M.A.D. is a self-contained, offline-first knowledge and education server packed with critical tools, knowledge, and AI to keep you informed and empowered — anytime, anywhere.

## Quick install

```bash
sudo apt-get update && \
sudo apt-get install -y curl && \
curl -fsSL https://raw.githubusercontent.com/Crosstalk-Solutions/project-nomad/refs/heads/main/install/install_nomad.sh \
  -o install_nomad.sh && \
sudo bash install_nomad.sh
```

Open `http://localhost:8080` or `http://DEVICE_IP:8080`.

## How it works

N.O.M.A.D. is a management UI ("Command Center") and API that orchestrates a collection of containerized tools and resources via Docker. Built-in capabilities include:

- AI Chat with Knowledge Base: local AI chat powered by Ollama or OpenAI API compatible software such as LM Studio or llama.cpp, with document upload and semantic search via Qdrant.
- Information Library: offline Wikipedia, medical references, ebooks, and more via Kiwix.
- Education Platform: Khan Academy courses with progress tracking via Kolibri.
- Offline Maps: downloadable regional maps via ProtoMaps.
- Data Tools: CyberChef.
- Notes: FlatNotes.
- System Benchmark and Supply Depot app catalog.

## Device and privacy notes

Minimum specs: 2 GHz dual-core processor, 4GB RAM, 5 GB free disk, Debian-based OS. Optimal AI specs: Ryzen 7 / Core i7, 32 GB RAM, NVIDIA RTX 3060 or AMD equivalent, 250 GB SSD.

Project N.O.M.A.D. is designed for offline usage. Internet is required during initial installation and when downloading additional tools/resources. It has zero built-in telemetry. It includes no authentication and is not designed to be exposed directly to the internet.

# Code / config observations

`admin/app/services/rag_service.ts` uses Qdrant, Ollama, TokenChunker, PDF parsing, OCR through tesseract.js, and file processing. Constants include:

```text
CONTENT_COLLECTION_NAME = nomad_knowledge_base
EMBEDDING_DIMENSION = 768
MODEL_CONTEXT_LENGTH = 2048
MAX_SAFE_TOKENS = 1600
TARGET_TOKENS_PER_CHUNK = 1500
SEARCH_DOCUMENT_PREFIX = search_document:
SEARCH_QUERY_PREFIX = search_query:
EMBEDDING_BATCH_SIZE = 8
```

`install/management_compose.yaml` defines `admin`, `dozzle`, `mysql`, `redis`, `updater`, and `disk-collector` services. The admin container binds `/var/run/docker.sock` and stores project data under `/opt/project-nomad/storage` by default.
