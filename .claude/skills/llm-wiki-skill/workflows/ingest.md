# workflow: ingest

> 消化单篇素材：raw → entities + sources（+ 可能的 topics）。

## 触发关键词

「消化这一篇」「加这个」「ingest」+ 单个文件路径或 URL

## 输入

- `source`：必填。可以是
  - 已存在的 `ai-wiki/raw/<source_type>/<file>.md`
  - 一条 URL（自动归类到对应 `<source_type>/` 子目录后再处理）
  - 一段直接粘贴的文本（写入 `raw/local/<auto-title>.md`）

## 步骤

### 1. 准备 raw 文件

- **URL 输入**：调用 `web-access` skill 抓取
  - 推断 source_type（推特链接 → `x/`，公众号 → `wechat/`，等等）
  - 抓取后存到 `ai-wiki/raw/<source_type>/<safe-title>.md`，带 frontmatter `{title, source_url, author, fetched_at}`
  - 抓取规则见 `references/sources/<source_type>.md`
- **本地文件输入**：直接读
- **文本粘贴**：写入 `ai-wiki/raw/local/<title>.md`

### 2. 字数判断

- 中文有效字符（去空白与标点）`>1000` → **完整处理**（步骤 3）
- 否则 → **简化处理**（步骤 4）

### 3. 完整处理

1. **抽实体**（人 / 概念 / 工具 / 项目 / 公司），过滤掉一次性提及的边角实体
2. 对每个实体：
    - 检查 `ai-wiki/wiki/entities/<name>.md` 是否存在
    - **存在**：合并新内容到对应小节（详情/应用/局限），扩展但不覆盖；frontmatter `sources` 追加本 source
    - **不存在**：基于 `templates/entity.md` 创建。**字数必须 ≥ 1500**——单篇素材撑不到 1500 字时，从该素材已有信息出发主动补背景知识填到 1500 字（标注哪些来自 source、哪些是补充的常识）
3. **写来源摘要**：基于 `templates/source.md` 创建 `ai-wiki/wiki/sources/<title>.md`
    - 必须含 ≥ 2 段 100 字摘录、"实践内容"段（代码/prompt 原样）
    - `related_entities`、`related_topics` 填齐
4. **主题判断**：
    - 检查现有 topics 是否覆盖此 source 的核心议题；如覆盖，仅追加到 topic 的 `sources`
    - 若不覆盖且**该议题已有 ≥ 5 个 sources**，新建 `ai-wiki/wiki/topics/<topic>.md`
5. **链接修复**：扫描本次新增/改动文件的所有 `[[link]]`，确保每个对应文件存在；不存在则同步建实体页（占位 + 标记 `low-confidence`）

### 4. 简化处理

- 仅生成 `ai-wiki/wiki/sources/<title>.md`
- 文中提到的实体用 `[[entity]]` 链接，但**不**单独建实体页
- 在 source frontmatter 加标签 `tags: [light]` 便于后续聚合

### 5. 强制 lint

调用 `lint` workflow。如有失败：
- **链接缺失** → 自动补占位实体页或修正大小写
- **实体页 < 1500 字** → 报错并要求当前会话补足，不允许"留待下次"
- **占位符** → 阻断性错误

## 输出

- `ai-wiki/wiki/sources/<title>.md`（必有）
- `ai-wiki/wiki/entities/*.md`（完整处理时）
- `ai-wiki/wiki/topics/<topic>.md`（命中规则时）
- `_meta.json` 的 `stats` 更新

## 验证

- [ ] lint 通过
- [ ] 新增文件均含完整 frontmatter
- [ ] 完整处理至少 1 个实体页 ≥ 1500 字
- [ ] source 摘要含"实践内容"段与 ≥ 2 段摘录
