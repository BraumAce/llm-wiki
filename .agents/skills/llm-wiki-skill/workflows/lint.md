# workflow: lint

> 知识库健康检查。每次 ingest / batch-ingest / digest / project-note 结束前**强制**调用。

## 触发关键词

「lint」「检查」「健康度」（也由其他 workflow 自动触发）

## 步骤

1. 调用 `scripts/lint.sh`（cwd = 项目根；`WIKI_DIR` 默认 `ai-wiki/wiki`）
2. 解析输出：
    - 每条 `✗` 都是阻断性错误
    - 把所有错误汇总后再决定修复优先级
3. **自动修复**（仅以下情况）：
    - 链接大小写/连字符不一致 → 重命名 wikilink
    - 缺失百科实体 → 创建占位实体页（标 `confidence: low`、`tags: [stub]`），但**仍需当前会话补到 1000 字**才算修复
    - 缺失项目卡/笔记目标 → 只在 `private/` 补，禁止为此建百科 stub
4. **不可自动修复**（需用户介入或当前 ingest 补足）：
    - 实体页 < 1000 字（不含 private）
    - 占位符（`TODO` / `XXX` / `待补充` / `TBD`）（不含 private）
    - 主题页 < 5 核心要点
    - frontmatter `sources: []` 缺失（entities + topics）
    - 公开页 `[[wikilink]]` 指向仅存在于 `private/` 的文件
5. **`private/` 豁免**（仍走链接一致性）：不检查实体字数、`sources` 非空、占位符、主题要点
6. 通过后更新 `_meta.json.last_lint = NOW`

## 输出

- 控制台报告
- 退出码（脚本）：0=通过，1=有错

## 验证

- [ ] 退出码 0
- [ ] `_meta.json.last_lint` 更新
