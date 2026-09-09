# workflow: project-note

> 把项目设计思路、决策、笔记写入 `wiki/private/projects/`。禁止走 ingest。

## 触发关键词

「项目笔记」「记项目知识」「Nova 设计」「can_gateway 笔记」「project-note」

## 输入

- `project`：必填。`private/projects/` 下目录名，与仓库目录名一致（如 `Nova`、`can_gateway`）
- `title`：笔记标题（不含项目前缀）；若只建项目卡可省略
- `body`：笔记正文，或「先建项目卡片」

## 步骤

1. **禁止走百科编译**：不得写入 `entities/` `topics/` `sources/`，不得当 wechat/webpage/local 素材 ingest，不得更新 `sync-index.sh` 的实体/来源计数。
2. **禁止泄密**：不写 API Key、password、token、credential master key、服务器密码。不把 `AGENTS.md` / `CLAUDE.md` 全文搬进来；实现真相留在仓库。
3. **落盘路径**（文件名 = `[[wikilink]]` 名，含大小写与连字符）：
    - 入口：`ai-wiki/wiki/private/项目知识.md`（无则按本约定建，并挂上本项目）
    - 项目卡：`ai-wiki/wiki/private/projects/<project>/<project>.md`（无则用 `templates/project.md`）
    - 笔记：`ai-wiki/wiki/private/projects/<project>/<project>-<safe-title>.md`（用 `templates/project-note.md`）
4. **命名**：笔记文件名强制项目前缀，避免和百科实体撞名。新项目只加目录，不改 7 个 AI 域。
5. **链接**：笔记可以 `[[wikilink]]` 到百科实体；百科页与公开 `index.md` **默认不反向链接**（静态站不发布 private，公开页链过去是死链）。
6. **更新入口**：把本项目/本笔记挂到 `private/项目知识.md` 与项目卡「笔记」列表。同一天可并入，不重复。
7. **lint**：调用 `lint` workflow。`private/` 豁免字数 / sources / 占位符；孤儿 `[[wikilink]]` 仍须修好。

## 不要做

- 把项目笔记追加到公开 `index.md`「最近更新」
- 把项目笔记 digest 成 `wiki/topics/` 主题页
- 为了「有来源」伪造 `sources:` 或编造外链

## 输出

- `ai-wiki/wiki/private/projects/<project>/<project>.md`（项目卡，可已存在）
- `ai-wiki/wiki/private/projects/<project>/<project>-<slug>.md`（有 title 时）
- 更新后的 `ai-wiki/wiki/private/项目知识.md`

## 验证

- [ ] 文件都在 `wiki/private/` 下，百科树无新文件
- [ ] 笔记文件名带项目前缀
- [ ] 公开 `index.md` 无指向本笔记的 `[[wikilink]]`
- [ ] lint 通过
