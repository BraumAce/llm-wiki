# LLM Wiki

> 个人 AI 知识库系统：把碎片化信息编译成持续积累、互相链接的百科全书。

## 设计理念

参考 Karpathy 的「AI 知识编译器」思路与 [liangdabiao/llm-wiki](https://github.com/liangdabiao/llm-wiki) 的工程实现：

- **传统 RAG** 每次查询都重新翻找全部资料，效率低、缺乏沉淀
- **本项目** 让 AI 充当编译器，把素材一次性整理成结构化 wiki，后续查询直接翻阅
- **静态站发布** 通过 Quartz v4 输出带双向链接、关系图谱、全文搜索的网站，rsync 到自有 nginx 服务器

## 目录结构

```
llm-wiki/
├── .agents/skills/        # skill 源目录
│   ├── llm-wiki-skill/    # 知识库采集、整理、查询的 skill 定义
│   └── quartz-wiki/       # 静态站构建与部署的 skill 定义
│       ├── scripts/       # sync-content.sh / deploy.sh / nginx-llm-wiki.conf
│       └── references/    # deployment-nginx-vps.md 部署手册
├── .claude/skills         # 指向 ../.agents/skills 的兼容 symlink
├── ai-wiki/
│   ├── raw/               # 原始素材按来源分类（webpage/x/wechat/...）
│   └── wiki/              # 整理后的结构化页面（entities/topics/sources）
├── quartz/                # Quartz v4 静态站（源码已入仓库，npm i 即可）
│   └── content/           # 由 sync-content.sh 从 ai-wiki/wiki/ 同步（gitignore）
├── .env.example
└── README.md
```

## 快速开始

```bash
node -v               # 需要 v22+
cd quartz && npm i    # 装 Quartz 依赖
```

在 Claude Code 中：

- `/llm-wiki-skill` —— 触发知识库工作流（init / ingest / query / digest / lint / status / graph）
- `/quartz-wiki` —— 触发静态站构建与部署

## 日常使用

```bash
# 1) 加内容：在 ai-wiki/raw/ 下放素材，更新 ai-wiki/raw/_inbox.md
#    在 Claude Code 里跑 ingest / batch-ingest

# 2) 健康检查
bash .agents/skills/llm-wiki-skill/scripts/lint.sh
bash .agents/skills/llm-wiki-skill/scripts/status.sh

# 3) 一键发布更新到生产服务器
bash .agents/skills/quartz-wiki/scripts/deploy.sh
```

deploy.sh 会依次：前置检查 → sync 内容 → Quartz build → rsync 到远程 → HTTP 验证。

## 多设备工作流

仓库本身就是单一可信源。任何装了 Node 22+ 和 SSH 权限的设备：

```bash
git clone <repo>
cd <repo>/quartz && npm i && cd ..
```

部署目标通过环境变量提供；真实值不要写入仓库：

```bash
export DEPLOY_HOST=user@server.example.com
export DEPLOY_PATH=/var/www/llm-wiki
export DEPLOY_DOMAIN=wiki.example.com
bash .agents/skills/quartz-wiki/scripts/deploy.sh
```

服务器侧 nginx + Let's Encrypt 一次性准备见 [deployment-nginx-vps.md](.agents/skills/quartz-wiki/references/deployment-nginx-vps.md)。

## 部署架构

```
[本地]  ai-wiki/wiki/  ──sync-content.sh──►  quartz/content/
                                                  │
                                                  ▼
                                            npm run quartz -- build
                                                  │
                                                  ▼
                                            quartz/public/ ──rsync via SSH──┐
                                                                            │
                                                                            ▼
[服务器]                                        /var/www/llm-wiki/
                                                    ▲
                                              nginx :443 (Let's Encrypt + certbot 自动续期)
                                                    ▲
                                                自有域名
```

## 工作流概览

| 意图 | Skill | Workflow | 说明 |
|------|-------|----------|------|
| 初始化 | llm-wiki-skill | `init` | 创建 raw/ wiki/ 目录与索引 |
| 消化单篇 | llm-wiki-skill | `ingest` | 抓取 → 摘要 → 写实体页 → 链接修复 |
| 批量处理 | llm-wiki-skill | `batch-ingest` | 对 raw/ 下未处理素材批量执行 |
| 快速查询 | llm-wiki-skill | `query` | 翻阅 wiki/ 回答问题 |
| 深度综合 | llm-wiki-skill | `digest` | 跨多个实体页生成综合报告 |
| 健康检查 | llm-wiki-skill | `lint` | 链接一致性、占位符、字数、来源完整性 |
| 状态统计 | llm-wiki-skill | `status` | 实体数、主题数、来源数 |
| 知识图谱 | llm-wiki-skill | `graph` | 生成实体—主题—来源关系图 |
| 静态站构建 | quartz-wiki | sync + build | 同步内容、Quartz v4 build |
| 远程部署 | quartz-wiki | deploy | rsync 到自有 nginx 服务器 |

## 路线图

- [x] 项目骨架
- [x] llm-wiki-skill 8 个 workflow 实现
- [x] quartz-wiki 部署脚本（sync + build + rsync + HTTP 验证）
- [x] 部署到独立域名（nginx + HTTPS via Let's Encrypt）
- [ ] Python CLI / FastAPI（可选，参考上游 `7_wiki_writer.py`）
- [ ] 定时任务自动 ingest（暂不做）
- [ ] 接通 Claude Agent SDK 用于自动 ingest / digest（`.env.example` 已留接口）

## 参考

- [liangdabiao/llm-wiki](https://github.com/liangdabiao/llm-wiki) — 本项目设计参考
- [Quartz v4](https://quartz.jzhao.xyz/) — 静态站生成器
- [Karpathy llm-wiki](https://github.com/karpathy/llm-wiki) - llm-wiki 方法论
- [Let's Encrypt](https://letsencrypt.org/) — 免费 HTTPS 证书
- [Claude Agent SDK 文档](https://docs.claude.com/en/api/agent-sdk/python)
- [Claude Agent SDK 教程](https://github.com/kenneth-liao/claude-agent-sdk-intro)
