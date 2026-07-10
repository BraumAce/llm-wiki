---
title: "Harness 工程实践：如何让 Agent 完成自主迭代"
source_url: "https://mp.weixin.qq.com/s/c8BymWxcopweHr11u7zY-Q"
author: "肖汉松（阿里技术）"
published_at: "2026-07-08T19:37:00+08:00"
fetched_at: "2026-07-10T00:00:00+08:00"
fetcher: "in-app-browser"
---

# Harness 工程实践：如何让 Agent 完成自主迭代

## 原文要点摘取

作者面向线上业务 Agent 的 prompt 优化，发现人工一次评测需要两三个小时，每天只能进行一轮迭代；Harness 化后，AI 可连续运行 17 小时完成 16 轮实验，并由人工复核后上线其中一轮改进。核心是把“人定义问题与验收，Agent 提方案、开发、测试、发布”的边界做成可执行闭环。

第一关是将部署、发起评测、查询进度、下载结果等原有 GUI 能力改造成 Agent 可调用的 Skill 或工具。第二关解决长任务早停、空转与上下文溢出：禁止向用户提问，遇到重复异常先分析，不要机械重试，一次只做一件事；父 Agent 负责循环与状态，复杂评测分析由加载专用 Skill 的子 Agent 执行，避免主会话持续膨胀。

第三关是评测闭环。训练集向 Agent 提供问题、答案与扣分原因，验证集只暴露分数，避免模型把单个 badcase 硬编码到 prompt 里。每轮 challenger 都从未过拟合的历史 champion 出发，只有在验证集中全方位超过冠军才替换；判断时还要分析得分行、badcase 模式、样本噪声和异常过滤比例，从而避免 reward hacking 与策略退化。
