# source_type: webpage

> 普通网页文章的抓取与归类约定。

## 抓取方式

优先级：**Jina r.jina.ai** > **WebFetch** > **CDP 浏览器**

1. **Jina（默认）**：访问 `https://r.jina.ai/<original_url>`，得到 Markdown 正文，token 友好。限 20 RPM。
2. **WebFetch**：原网页有反爬或 Jina 提取失败时
3. **CDP 浏览器**：登录态、强反爬（小红书等）；走 `web-access` skill 的 CDP 模式

## 文件命名

- 路径：`ai-wiki/raw/webpage/<safe-title>.md`
- safe-title：原标题去掉特殊字符、空格转 `-`、最长 60 字符
- 同名冲突 → 末尾加 `-2`、`-3`

## frontmatter 模板

```yaml
---
title: "原标题"
source_url: "https://example.com/path"
author: "作者名"
fetched_at: "YYYY-MM-DDTHH:MM:SS+08:00"
fetcher: "jina"   # jina / webfetch / cdp
---
```

## 提取要点

- 保留正文的代码块、引用、列表结构
- 去掉广告、相关推荐、评论区、页脚
- 图片：保留 `![](url)`，不下载
- 视频：仅留链接 + 字幕（如有）

## 归档后下一步

文件落入 `raw/webpage/`，由 ingest 或 batch-ingest 接管。
