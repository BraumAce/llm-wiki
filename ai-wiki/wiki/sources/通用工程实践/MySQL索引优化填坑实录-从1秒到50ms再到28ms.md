---
title: "MySQL索引优化填坑实录-从1秒到50ms再到28ms"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/7zKMzKueDTeYRXiQ_jy5fg"
author: ""
ingested_at: 2026-05-29
tags:
  - mysql
  - indexing
  - optimization
  - sql
related_entities: []
related_topics: []
---

# MySQL索引优化填坑实录-从1秒到50ms再到28ms

## 一句话概括

一次生产慢 SQL 的三段式优化——从全表扫描 1s 起步，加单列索引降到 50ms 但 filtered 仅 5.56%，换成复合索引把 filtered 拉到 55.55%、耗时压到 28ms。

## 摘录

> 要点是"别只看耗时要盯 filtered"，复合索引遵循等值在前、范围在后。从全表扫描 1s 起步，加单列索引降到 50ms 但 filtered 仅 5.56%，换成复合索引把 filtered 拉到 55.55%、耗时压到 28ms。

## 涉及实体

（无直接关联的 wiki 实体）

## 涉及主题

（无直接关联的 wiki 主题）

## 我的评注

独立的 MySQL 优化实战，与 AI 工程主题无直接关联，作为通用技术参考入库。
