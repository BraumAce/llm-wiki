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
```

## 验证

- [ ] 数字与实际文件一致
- [ ] `index.md` 最近更新小节已刷新
