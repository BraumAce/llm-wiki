---
title: "MySQL 的 SELECT * 一定导致索引失效？"
type: source
date: 2026-05-31
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/6lzPH4u3HnNjVlFrckNDhw"
author: "未知"
published_at: "2026-03-11"
ingested_at: 2026-05-31
tags:
  - mysql
  - database
  - performance
related_entities: []
related_topics: []
---

# MySQL 的 SELECT * 一定导致索引失效？

## 一句话概括

从优化器回表成本权衡切入，系统梳理 7 类索引失效场景——SELECT * 非必然失效但因回表占比超 20%~30% 会被放弃。

## 实践内容

### 7 类索引失效场景

1. **SELECT * 非必然失效** —— 但因回表占比超 20%~30% 会被放弃
2. **违背最左前缀** —— 含 8.0.13 Index Skip Scan 在 8.0.31 的 Bug #109145
3. **索引列函数运算** —— 对索引列使用函数
4. **LIKE '%xx' 前缀通配** —— 前缀通配符
5. **OR 与 Index Merge** —— OR 条件
6. **IN 超 eq_range_index_dive_limit=200** —— IN 列表过长
7. **隐式类型转换发生在索引列侧** —— 类型不匹配

### ORDER BY 触发 Using filesort

ORDER BY 也可能触发 filesort。

## 摘录

> 从优化器回表成本权衡切入，系统梳理 7 类索引失效场景——`SELECT *` 非必然失效但因回表占比超 20%~30% 会被放弃、违背最左前缀（含 8.0.13 Index Skip Scan 在 8.0.31 的 Bug #109145）。

> 索引列函数运算、`LIKE '%xx'` 前缀通配、OR 与 Index Merge、`IN` 超 `eq_range_index_dive_limit=200`、隐式类型转换发生在索引列侧、ORDER BY 触发 `Using filesort`。

## 涉及实体

- []

## 涉及主题

- []

## 我的评注

虽然不是 AI 相关的，但这些 MySQL 索引优化知识对任何后端开发者都很重要。"SELECT * 非必然失效"这个观点纠正了很多人的误解。
