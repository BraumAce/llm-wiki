# LLM Wiki

> 个人 AI 知识库系统：把碎片化信息编译成持续积累、互相链接的百科全书。

## 设计理念

参考 Karpathy 的"AI 知识编译器"思路与 [liangdabiao/llm-wiki](https://github.com/liangdabiao/llm-wiki) 的工程实现：

- **传统 RAG** 每次查询都重新翻找全部资料，效率低、缺乏沉淀
- **本项目** 让 AI 充当编译器，把素材一次性整理成结构化 wiki，后续查询直接翻阅
- **静态站发布** 通过 Quartz v4 输出带双向链接、关系图谱、全文搜索的网站

与本人技术博客 ByteLighting 解耦：博客是人写的长文，本项目是 AI 沉淀的零散卡片，两边独立演进。

## 目录结构

```
llm-wiki/
├── .claude/skills/
│   ├── llm-wiki-skill/    # 知识库采集、整理、查询的 skill 定义
│   └── quartz-wiki/       # 静态站发布流程的 skill 定义
├── ai-wiki/
│   ├── raw/               # 原始素材按来源分类（webpage/x/wechat/...）
│   └── wiki/              # 整理后的结构化页面（实体页/主题页/来源摘要）
├── quartz/                # Quartz v4 静态站（待 npm i 初始化）
├── .env.example           # API key 与站点配置模板
└── README.md
```

## 快速开始

### 1. 准备环境

```bash
# Node.js 22+（Quartz 必需）
node -v

# 复制环境变量模板
cp .env.example .env
# 填入你的 API key
```

### 2. 初始化 Quartz（首次部署前）

```bash
cd quartz
git clone --depth 1 --branch v4 https://github.com/jackyzha0/quartz.git .
npm i
```

### 3. 使用 skill

在 Claude Code 中：

- `/llm-wiki-skill` 触发知识库工作流（init / ingest / query / digest / lint / status / graph 等）
- `/quartz-wiki` 触发静态站构建与部署

## 工作流概览

| 意图 | 工作流 | 说明 |
|------|--------|------|
| 初始化知识库 | `init` | 创建 raw/ wiki/ 目录与索引 |
| 消化单篇素材 | `ingest` | 抓取 → 摘要 → 写实体页 → 链接修复 |
| 批量处理文件夹 | `batch-ingest` | 对 raw/ 下未处理素材批量执行 |
| 快速查询 | `query` | 翻阅 wiki/ 回答问题 |
| 深度综合 | `digest` | 跨多个实体页生成综合报告 |
| 健康检查 | `lint` | 链接一致性、占位符、字数、来源完整性 |
| 状态统计 | `status` | 实体数、主题数、来源数 |
| 知识图谱 | `graph` | 生成实体—主题—来源关系图 |

## 路线图

- [x] 项目骨架
- [ ] llm-wiki-skill 8 个 workflow 的具体实现
- [ ] quartz-wiki 部署脚本
- [ ] Python CLI / FastAPI（可选，参考上游 `7_wiki_writer.py`）
- [ ] 定时任务自动 ingest（暂不做）
- [ ] 部署到独立域名

## 参考

- [liangdabiao/llm-wiki](https://github.com/liangdabiao/llm-wiki) — 本项目设计参考
- [Quartz v4](https://quartz.jzhao.xyz/) — 静态站生成器
- Karpathy 关于 AI 知识库的方法论讨论
