# workflow: digest

> 跨多个实体/来源生成深度综合报告。比 query 更重，比 topic 页更细。

## 触发关键词

「综合报告」「digest」「深度分析 X」「写一篇关于 Y 的总结」

## 输入

- `subject`：综合的对象，可以是实体、主题、或一个用户提的开放题
- `style`（可选）：
  - `report`（默认）：结构化报告
  - `essay`：长文叙事
  - `compare`：对比分析

## 步骤

1. **收集**：用 query 流程拉到所有相关 entities / topics / sources
2. **去重 & 排序**：相同事实的多源合并；按时间或重要性排序
3. **结构化输出**（按 style）：
    - **report**：发展脉络 → 核心机制对比 → 应用案例 → 争议与开放问题 → 引用清单
    - **essay**：从一个具体问题/故事切入，自然展开
    - **compare**：维度矩阵 + 每维度横向叙述
4. **写入文件**：`ai-wiki/wiki/topics/<subject>-digest-YYYYMMDD.md`
    - frontmatter `type: topic`、`tags: [digest]`
    - 至少引用 5 个 sources / entities
5. **链接回写**：在被引用的 entity / source 页底部加 `相关综合：[[<subject>-digest-YYYYMMDD]]`
6. **lint**

## 输出

- `ai-wiki/wiki/topics/<subject>-digest-YYYYMMDD.md`

## 验证

- [ ] ≥ 5 个引用
- [ ] 所有 `[[link]]` 有效
- [ ] 不重复堆砌已存在 entity 页内容，要有"综合"价值（对比、抽象、新结论）
