# workflow: query

> 翻阅已整理的 wiki 回答用户问题。**不要去翻 raw/，那是原料。**

## 触发关键词

「查一下」「问知识库」「找」「关于 X 我知道什么」

## 输入

- `question`：自然语言问题

## 步骤

1. **入口**：先读 `ai-wiki/wiki/index.md` 与 `_meta.json`，了解当前规模与语言；若存在 `ai-wiki/wiki/private/项目知识.md`，记下已有项目名（`private/projects/` 下目录名）
2. **检索**（按优先级，先精确后泛化）
    - **项目树**（问题点名已有项目，或含「项目笔记 / 设计决策 / 铁律」）：先搜 `ai-wiki/wiki/private/projects/<repo>/`（项目卡 + 前缀笔记），再搜百科。引用标「项目笔记」。未点名项目时**不要**把 private 当默认语料
    - **精确实体匹配**：`find ai-wiki/wiki/entities -name '<question_keyword>.md'`（递归查分类子目录）；项目名同时 `find ai-wiki/wiki/private -name '<name>.md'`
    - **frontmatter 命中**：grep `tags:` / `also_known_as:` / `related_entities:` / `project:`
    - **正文 grep**：百科搜 `entities/` `topics/` `sources/`；命中项目树时再搜 `private/projects/`
    - **wikilink 反向**：找出哪些页面 `[[link]]` 指向已命中的实体（公开页不应反向链到 private）
3. **读取**：把命中的文件**完整读取**，不要只看摘要
4. **综合作答**
    - 给出结论性回答
    - 每个事实点附引用：`（见 [[entity_name]]）`、`（来源 sources/<title>）` 或 `（项目笔记 [[Nova-…]]）`
    - 项目笔记与百科冲突时分开陈述，不要把仓库决策写成行业通识
    - 若信息不足或冲突，明确说"知识库覆盖不足"或"两源说法矛盾"，不要瞎补
5. **追问引导**：若问题无法答全，提示用户：
    - 项目设计/决策 → `project-note`
    - 跨多源整合 → `digest`（禁止把 private 笔记写成公开 `topics/`）
    - 外部分片 → `ingest`

## 输出

- 答案 + 来源引用
- 如发现覆盖盲区，列出建议补充的素材方向

## 验证

- [ ] 每个引用对应文件存在
- [ ] 答案不包含未在 wiki 中出现的事实（否则用 `（库外补充）` 标注）

## 反模式

- 不要做"全文喂 LLM 让它回答"——那是 RAG，违背本项目理念
- 不要去翻 `ai-wiki/raw/`——已整理过的内容不必再回到原料层
- 未点名项目时不要把 `private/` 当默认语料；不要把项目决策写成行业通识
