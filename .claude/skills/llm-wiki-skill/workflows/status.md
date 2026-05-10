# workflow: status

> 知识库统计快照。

## 触发关键词

「状态」「统计」「status」

## 步骤

1. 调用 `scripts/status.sh`（cwd = 项目根）
2. 同时读 `_meta.json`，把脚本统计与 meta 对比
3. 若不一致，自动同步 meta（不报错，只提示）
4. 把"最近更新"前 10 项写到 `index.md` 的"最近更新"小节

## 输出

```
LLM Wiki Status
===============
实体数:     N
主题数:     N
来源数:     N
总字数:     N
最近 7 天:  N 个文件更新
原始素材:   N 个文件 (raw/)
最后 lint:  YYYY-MM-DD（或"从未"）

Graph 摘要 (生成于 YYYY-MM-DDTHH:MM:SS+TZ)
===============
节点:       N
边:         N
孤儿链接:   N
Top 3 入度:
  W1  node-id-1
  W2  node-id-2
  W3  node-id-3

提示: 有 K 个 .md 文件晚于图谱更新时间，建议重跑 scripts/graph.sh
```

Graph 摘要仅在 `_graph.json` 存在时显示，**只读不写**——status 自身不会触发 graph 重算，避免大库时 status 变慢。需要刷新图谱要主动跑 `graph` workflow。

## 验证

- [ ] 数字与实际文件一致
- [ ] `index.md` 最近更新小节已刷新
