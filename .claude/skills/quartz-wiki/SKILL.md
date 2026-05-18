---
name: quartz-wiki
description: 把 ai-wiki/wiki/ 下的 Markdown 知识库部署为 Quartz v4 静态网站。当用户说「部署 wiki」「发布网站」「quartz 构建」时触发。支持双向链接、全局关系图谱、全文搜索、暗色模式。
---

# Quartz Wiki — 静态站部署器

把 `ai-wiki/wiki/` 下整理好的 Markdown 知识库，输出为带双向链接、关系图谱、全文搜索的 Quartz v4 网站。

## 前置条件

- Node.js v22+
- npm v10.9+
- `ai-wiki/wiki/` 已通过 `llm-wiki-skill` 整理过，frontmatter 干净

## 五阶段流程

### Phase 1: 初始化 Quartz（首次）

```bash
cd quartz
git clone --depth 1 --branch v4 https://github.com/jackyzha0/quartz.git .
npm i
```

> `npx create-quartz` 不存在，必须 `git clone v4` 分支。

### Phase 2: 内容接入

把 `ai-wiki/wiki/` 接入 `quartz/content/`：

| 方式 | 适用 | 说明 |
|------|------|------|
| symlink | 开发 | `ln -s ../../ai-wiki/wiki content`，改一份生效。Windows 缓存有坑 |
| copy | 部署 | `cp -r ../ai-wiki/wiki content`，每次构建前同步 |
| git submodule / CI 拉取 | 生产 | 推荐 |

`quartz.config.ts` 必须排除：`raw`、`templates`、`private`、`.obsidian`。

### Phase 3: Frontmatter 修复（关键）

Quartz YAML 解析严格，部署前先扫一遍：

| 问题 | 症状 | 修复 |
|------|------|------|
| `aliases:` 字段 | 构建报错 ENOTEMPTY | 改名为 `also_known_as:` |
| YAML `#` 注释 | "missed comma" | 去掉 `#` 或加引号 `"#6539"` |
| 内联列表 `[a, b]` | 偶发解析失败 | 改成 `- a\n- b` |
| 空值字段 | 解析异常 | 删除或设空字符串 |

### Phase 4: 构建与本地预览

```bash
# 必清缓存
rm -rf .quartz-cache public

# 构建
npx quartz build

# 本地预览（不要用 --serve，会清 public）
python -m http.server 8080 -d public
```

**验证清单**：
- [ ] 首页正常
- [ ] 侧边栏导航
- [ ] `[[wikilink]]` 跳转正确
- [ ] Global Graph 关系图谱可弹出
- [ ] 全文搜索可用
- [ ] 图片加载
- [ ] 暗色模式切换

### Phase 5: 远程部署（nginx VPS）

```bash
# 一行完成: sync → build → rsync → HTTP 验证
bash .claude/skills/quartz-wiki/scripts/deploy.sh
```

可选参数：`--skip-build`（仅 rsync 已有 `public/`）、`--dry-run`（rsync 干跑）。
环境变量覆盖：`DEPLOY_HOST` / `DEPLOY_PATH` / `DEPLOY_DOMAIN`。

完整流程（含服务器侧 nginx 配置、certbot HTTPS、多设备维护、排错）见
[references/deployment-nginx-vps.md](references/deployment-nginx-vps.md)。

部署前置检查：
- [ ] `ai-wiki/wiki/` 已 lint 通过（用 llm-wiki-skill 的 `lint` workflow）
- [ ] 没有未 commit 的内容修改（脚本会提示）
- [ ] 服务器 SSH 可达，部署目录已存在

**其他平台**: Cloudflare Pages / Vercel / GitHub Pages 待补 `references/deployment-<platform>.md`。

## quartz.config.ts 关键配置

```typescript
{
  configuration: {
    pageTitle: process.env.SITE_TITLE ?? "LLM Wiki",
    locale: process.env.SITE_LOCALE ?? "zh-CN",
    baseUrl: process.env.SITE_BASE_URL,  // 必填，否则 404 页构建崩溃
    ignorePatterns: ["raw", "private", "templates", ".obsidian"],
  },
  plugins: {
    transformers: [
      Plugin.ObsidianFlavoredMarkdown(),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({ markdownLinkResolution: "shortest" }),
      // Plugin.Latex(),  // 需公式时启用
    ],
  },
}
```

## 内容文件 frontmatter 规范

```yaml
---
title: "页面标题"        # 必填
date: 2026-05-05        # 排序用
tags:
  - wiki
  - concept
---
```

**禁用字段**（与 Quartz 冲突）：
- `aliases:` → 用 `also_known_as:`
- `slug:` → 由文件名决定 URL
- `publish:` → 用 `draft: true`

## 常见问题速查

| 问题 | 解决 |
|------|------|
| `git clone` 慢 | 加 `--depth 1` |
| "missed comma" | YAML `#` 注释问题 |
| "ENOTEMPTY" | `aliases:` 冲突 |
| "Invalid URL" | `baseUrl` 为空 |
| 内容不更新 | 清 `.quartz-cache`；symlink 在 Win 改 copy |
| 图片不显示 | 检查路径，外链可直接用 |
| 中文乱码 | `locale: "zh-CN"` + 文件 UTF-8 |

## 脚本与配置

| 路径 | 用途 |
|------|------|
| `scripts/sync-content.sh` | `ai-wiki/wiki/` → `quartz/content/` 同步 |
| `scripts/deploy.sh` | 一键远程部署（build + rsync + HTTP 验证） |
| `scripts/nginx-llm-wiki.conf` | nginx server block 模板 |
| `references/deployment-nginx-vps.md` | VPS 部署完整手册 |

## TODO

- [ ] `references/quartz-setup.md` 完整初始化指南
- [ ] `references/quartz-troubleshooting.md` 修复脚本
- [ ] `references/deployment-cloudflare.md` CF Pages 部署细节
- [ ] `scripts/fix-frontmatter.sh` 批量修复 frontmatter
- [ ] GitHub Actions 自动 rsync
