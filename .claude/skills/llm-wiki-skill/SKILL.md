---
name: llm-wiki-skill
description: 个人 AI 知识库系统的工作流路由器。把碎片化素材（网页/X/公众号/小红书/知乎/YouTube/PDF/本地文件）整理成结构化、互链的 wiki。当用户说「初始化知识库」「采集」「消化」「批量消化」「问知识库」「综合报告」「lint 检查」「知识库状态」「生成图谱」时触发。
---

# llm-wiki: 个人 AI 知识库系统

## 核心理念

**"把碎片化信息变成持续积累、互相链接的知识库"** —— 把 AI 当编译器，一次性把素材编译成结构化百科，而不是每次查询都重新翻找。

## 项目目录约定

```
ai-wiki/
├── raw/                    # 原始素材按来源分类
│   ├── webpage/  x/  wechat/  xiaohongshu/  zhihu/  youtube/  pdf/  local/
│   └── _inbox.md           # 待处理队列（init 创建）
└── wiki/                   # 整理产出
    ├── entities/           # 实体页（人/概念/工具/项目）
    ├── topics/             # 主题页（聚合多个实体）
    ├── sources/            # 来源摘要（每篇素材一份）
    ├── _meta.json          # 元信息（语言/版本/上次 lint）
    └── index.md            # 总入口
```

## 工作流路由器

根据用户意图派发到 `workflows/<name>.md`，**先读对应文件再执行**：

| 用户意图关键词 | 工作流 | 文件 |
|---|---|---|
| 「初始化」「建库」「start」 | **init** | [workflows/init.md](workflows/init.md) |
| 「消化」「加这一篇」「ingest」+ 单个素材 | **ingest** | [workflows/ingest.md](workflows/ingest.md) |
| 「批量」「全部消化」「inbox」 | **batch-ingest** | [workflows/batch-ingest.md](workflows/batch-ingest.md) |
| 「查一下」「问知识库」「找」 | **query** | [workflows/query.md](workflows/query.md) |
| 「综合报告」「digest」「深度分析 X」 | **digest** | [workflows/digest.md](workflows/digest.md) |
| 「检查」「lint」「健康度」 | **lint** | [workflows/lint.md](workflows/lint.md) |
| 「状态」「统计」「status」 | **status** | [workflows/status.md](workflows/status.md) |
| 「图谱」「关系图」「graph」 | **graph** | [workflows/graph.md](workflows/graph.md) |

## 处理模式

按素材字符数分两档：

- **完整处理**（>1000 字）：抽实体 → 写实体页 → 写来源摘要 → 链接修复
- **简化处理**（≤1000 字）：仅写来源摘要，提及实体用 `[[link]]` 但不单独建页

## 质量约束（强制，由 lint 校验）

- 文件名必须与 `[[wikilink]]` 内的名字完全一致（包括大小写、连字符）
- 实体页 ≥ 1500 字，无占位符（`TODO` / `XXX` / `待补充` / `TBD`）
- 每篇 source 摘要含 ≥ 2 段 100 字以上的原文摘录 + "实践内容"段（代码/prompt/教程原样保留）
- frontmatter `sources: []` 字段非空（实体页/主题页）
- 主题页 ≥ 5 个核心要点

## 自动联动

- **每次 ingest / batch-ingest 结束前**强制调用 `lint`，输出问题清单后再决定是否完成
- 出现 3+ 可对比实体（同 type 同 tag）→ 自动建对比小节到主题页
- 同主题来源数 ≥ 5 → 自动建主题页 `wiki/topics/<topic>.md`

## 模板与脚本

- 内容模板：[templates/entity.md](templates/entity.md) [templates/topic.md](templates/topic.md) [templates/source.md](templates/source.md) [templates/index.md](templates/index.md)
- 来源抓取约定：[references/sources/webpage.md](references/sources/webpage.md) [references/sources/local.md](references/sources/local.md)
- 校验脚本：`scripts/lint.sh`、`scripts/status.sh`（必须可执行）

## 多语言

`_meta.json` 中 `lang: zh | en`，默认 `zh`。模板正文使用对应语言。
