# workflow: graph

> 解析 wiki 内的 [[wikilink]] 关系，输出结构化图谱数据。

## 触发关键词

「图谱」「关系图」「graph」

## 输入

- `center`（可选）：以某实体为中心，只输出 N 跳邻域（默认全图）
- `depth`（可选）：默认 2

## 步骤

1. 扫描 `ai-wiki/wiki/{entities,topics,sources}/*.md`
2. 节点：每个 md 文件是一个节点（id = 文件名去 .md）
    - 属性：`type`（entity/topic/source）、`title`、`tags`
3. 边：每个 `[[target]]` 出现 = 一条 (source_file → target) 边
    - 边权 = 该 [[link]] 在源文件中出现次数
4. 写出 `ai-wiki/wiki/_graph.json`：
    ```json
    {
      "generated_at": "...",
      "nodes": [{"id": "...", "type": "...", "title": "...", "tags": []}],
      "edges": [{"from": "...", "to": "...", "weight": 1}]
    }
    ```
5. **可选**：生成 mermaid 摘要片段（前 N 个高度数节点），输出到对话；不写入文件

## 输出

- `ai-wiki/wiki/_graph.json`
- 控制台 mermaid 片段（可选）

## 验证

- [ ] `_graph.json` 可被 `jq` 解析
- [ ] 节点数 = 实体页 + 主题页 + 来源页 总数
- [ ] 所有 edge 的 `to` 都对应存在的节点（孤儿链接由 lint 提前拦截）
