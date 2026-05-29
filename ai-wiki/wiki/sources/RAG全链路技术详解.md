---
title: "RAG全链路技术详解"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/aA2PFaabKNlDq96jhAdDkQ"
author: "大淘宝技术"
ingested_at: 2026-05-29
tags: [rag, retrieval, chunking, reranking]
related_entities: [RAG, vLLM]
related_topics: [AI-Infra推理优化-主题]
---

# RAG全链路技术详解

## 一句话概括
本文是一份 RAG 技术实战指南，覆盖从文档加载、智能切分、索引构建、检索优化（Query 改写、HyDE、重排序）、生成调优到 Graph RAG 和 Ragas 自动化评估的全链路技术详解。

## 摘录
> 在 Agent 的开发过程中，RAG 技术的应用水平直接决定了 Agent 的业务上限。在跟进品牌行业AI运营战役时，架构组发现部分团队在RAG落地中面临共性挑战：知识库构建缺乏标准、检索召回精度达不到预期，以及缺乏量化评测体系。

> Meta-Chunking: 该论文给出了一个基于逻辑和语义的chunking的方法。计算文章中各句子的PPL（困惑度），以此判断哪些句子应该被划分在一个文档块中。PPL 反映了语言模型在看到一段文本时有多"困惑"。低 PPL：模型觉得这段话很通顺、逻辑连贯；高 PPL：模型觉得这段话很突兀、逻辑断层。

> HyDE（Hypothetical Document Embeddings）：不是直接用"问题"去搜"答案"，而是先让 AI 编一个"假答案"，再用这个"假答案"去搜"真内容"。本质是将"问题-文档匹配"转换成了"文档-文档匹配"。在传统的向量检索中，用户的问题通常很短，知识库里的文档通常很长，在向量空间里，"问题"和"答案"的语义特征并不完全对等。

> 重排序（ReRank）利用交叉编码器（Cross-Encoder），把问题和候选文档拼在一起塞进模型。模型可以同时看到问题和文档的每一个字，通过自注意力机制捕捉极细微的匹配关系。针对华为手机的例子，强行检查：是不是华为？是不是低于2000？有没有提到续航？如果缺了一项，得分会大幅跳水。

## 涉及实体
- [[RAG]] —— 本文全面解析 RAG 全链路技术
- [[vLLM]] —— RAG 系统中的推理引擎选型

## 涉及主题
- [[AI-Infra推理优化-主题]]
