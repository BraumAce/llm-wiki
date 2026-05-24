# workflow: init

> 初始化知识库。仅在 `ai-wiki/wiki/_meta.json` 不存在时执行；已存在则改走 status。

## 触发关键词

「初始化知识库」「建库」「init」「start」

## 输入

- `lang`（可选，默认 `zh`，仅支持 `zh` / `en`）

## 步骤

1. **预检**：若 `ai-wiki/wiki/_meta.json` 已存在，停止并提示用户改用 `status`。
2. **创建 raw 子目录**：`ai-wiki/raw/{webpage,x,wechat,xiaohongshu,zhihu,youtube,pdf,local}`，每个放一个 `.gitkeep`。
3. **创建 wiki 子目录**：`ai-wiki/wiki/{entities,topics,sources}`，每个放一个 `.gitkeep`。
4. **生成 `ai-wiki/wiki/_meta.json`**：
    ```json
    {
      "version": "1.0",
      "lang": "zh",
      "created_at": "YYYY-MM-DDTHH:MM:SS+08:00",
      "last_lint": null,
      "stats": { "entities": 0, "topics": 0, "sources": 0 }
    }
    ```
5. **生成 `ai-wiki/wiki/index.md`**：复制 `templates/index.md`，把 `{{date}}` 替换为今天。
6. **生成 `ai-wiki/raw/_inbox.md`**：待处理队列，初始内容：
    ```markdown
    # Inbox

    > 待 ingest 的素材列表。每行一个：`[ ] 路径或 URL —— 备注`。
    > batch-ingest 会读取此文件并依次处理。

    ```
7. **跑 lint**：应该通过（空库无错），把 `last_lint` 写回 `_meta.json`。

## 输出

- 完整目录结构
- `_meta.json`
- `index.md`
- `_inbox.md`

## 验证

- [ ] `ai-wiki/wiki/_meta.json` 可被 `jq .` 解析
- [ ] `lint.sh` 退出码 0
- [ ] `index.md` 含 frontmatter `type: index`
