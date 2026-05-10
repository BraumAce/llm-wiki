# source_type: local

> 本地已有的 .md / .txt / 粘贴文本。

## 接入方式

1. **已有文件**：用户给出绝对路径，**复制（不移动）**到 `ai-wiki/raw/local/<safe-title>.md`
    - 复制原因：raw/ 是源料区，应自包含；用户原文件可继续在自己的位置
2. **粘贴文本**：用户在对话中给出大段文字
    - 询问标题（或自动生成 `paste-YYYYMMDD-HHMM`）
    - 写入 `ai-wiki/raw/local/<title>.md`，frontmatter 标注 `fetcher: paste`

## frontmatter 模板

```yaml
---
title: "..."
source_url: ""              # 本地无 URL，留空
author: "self"              # 或原作者名
fetched_at: "YYYY-MM-DDTHH:MM:SS+08:00"
fetcher: "local"            # local / paste
original_path: "/Users/.../xxx.md"   # 仅 local
---
```

## 内容清理

- 去除明显的页眉/页脚冗余
- 保留代码块、列表、引用结构
- **不要**改写原作者措辞——这是来源原料
