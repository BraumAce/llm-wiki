# workflow: lint

> 知识库健康检查。每次 ingest / batch-ingest / digest 结束前**强制**调用。

## 触发关键词

「lint」「检查」「健康度」（也由其他 workflow 自动触发）

## 步骤

1. 调用 `scripts/lint.sh`（cwd = 项目根；`WIKI_DIR` 默认 `ai-wiki/wiki`）
2. 解析输出：
    - 每条 `✗` 都是阻断性错误
    - 把所有错误汇总后再决定修复优先级
3. **自动修复**（仅以下情况）：
    - 链接大小写/连字符不一致 → 重命名 wikilink
    - 缺失目标实体 → 创建占位实体页（标 `confidence: low`、`tags: [stub]`），但**仍需当前会话补到 1500 字**才算修复
4. **不可自动修复**（需用户介入或当前 ingest 补足）：
    - 实体页 < 1500 字
    - 占位符（`TODO` / `XXX` / `待补充` / `TBD`）
    - 主题页 < 5 核心要点
    - frontmatter `sources: []` 缺失
5. 通过后更新 `_meta.json.last_lint = NOW`

## 输出

- 控制台报告
- 退出码（脚本）：0=通过，1=有错

## 验证

- [ ] 退出码 0
- [ ] `_meta.json.last_lint` 更新
