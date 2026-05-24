# workflow: batch-ingest

> 批量消化 raw/ 下的未处理素材。

## 触发关键词

「批量」「全部消化」「inbox」「batch-ingest」

## 输入

- `target`（可选）：
  - `_inbox`（默认）：读 `ai-wiki/raw/_inbox.md` 的待办行
  - `<source_type>`：处理 `raw/<source_type>/` 下所有未在 `wiki/sources/` 出现的文件
  - 路径：处理给定路径下所有文件

## 步骤

1. **构建队列**
    - 列出候选文件
    - 排除已存在 `ai-wiki/wiki/sources/<title>.md` 的文件（按文件名去重）
    - 输出预览给用户确认数量后再开始
2. **顺序 ingest**
    - 对每个候选：调用 `ingest` workflow（不重复 lint，留到末尾）
    - 失败时记录但不中断（除非连续 3 个失败 → 中止）
3. **末尾合并 lint**
    - 跑一次完整 `lint`
    - 修复跨 ingest 产生的链接不一致
4. **更新 inbox**
    - 把已处理的 `[ ]` 行改为 `[x]` + 处理日期
5. **生成报告**
    - 处理总数 / 成功 / 失败
    - 新增 entities / topics / sources 数

## 输出

- 大批文件
- 控制台报告

## 验证

- [ ] 全部成功的项目最终 lint 通过
- [ ] `_inbox.md` 状态更新
- [ ] `_meta.json.stats` 与实际文件数一致
