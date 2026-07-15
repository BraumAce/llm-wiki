---
title: "阿里荣膺 ACL 2026 最佳资源论文 | HSCodeComp 揭开智能体「分层规则应用」的能力鸿沟"
source_url: "https://mp.weixin.qq.com/s/Lec1nRrWVgj50PYR0DxKlg"
author: "兰天，阿里技术"
fetched_at: "2026-07-15T19:00:00+08:00"
fetcher: "agent-browser"
---

# 阿里荣膺 ACL 2026 最佳资源论文 | HSCodeComp 揭开智能体「分层规则应用」的能力鸿沟

过去两年，大模型 Agent 在深度搜索（Deep Search）方向进展飞速。但在法律、医疗、税务、跨境电商等高价值垂类场景中，Agent 不能只靠模型内部知识，必须像专家一样逐级调用工具、检索并严格应用人类专家编写的层次化规则，才能得出可靠结论。

作者介绍 HSCodeComp：首个面向这一能力的真实且专家级 Deep Search Agent 基准；论文标题为 *HSCodeComp: A Realistic and Expert-level Agent Benchmark for Hierarchical Rule Application*，文章称其被 ACL 2026 接收并获最佳资源论文奖。

## 背景：HS Code 与专家级深度搜索

HS Code（Harmonized System Code，商品名称及编码协调制度）是跨境货物申报的商品编码。实际申报需把商品依据专家规则树，逐级归类到唯一的 10 位编码：2 位章（Chapter）→ 4 位品目（Heading）→ 6 位子目（Sub-heading）→ 8/10 位国别码（Country-specific）。例如 AirPods 硅胶保护套的材质、是否属于表面覆盖物、是否是配件或零件等判断，都会影响路径；每层判定都正确，最终编码才成立。

文章把任务形式化为：在含噪声的多模态商品档案 X 上，Agent 逐级调用工具检索并应用分层规则 R 与领域知识 K，得到唯一 10 位编码 Y。商品档案含标题、结构化属性、平台类目、图片、价格和币种；R 包含官方层级关税规则与专家决策规则；K 为美国 CROSS 历史裁定库。任务不是一次性分类，而是“检索—推理—回溯”循环：抽取物理属性、检索候选规则、核对例外和交叉引用，必要时检索历史裁定并以专家决策规则裁决优先级。

文章将 Agent 所需的知识复杂度分为三层：Level 1 开放域数据（BrowseComp、WebArena、GAIA），Level 2 结构化数据（如数据库和知识图谱，MedBrowseComp、FinSearchComp），Level 3 分层规则数据。Level 3 的三类难点是：层级推理中上层错误的级联放大；“除……以外”“其他”“主要用于”等语义边界的模糊性；以及例外条款、交叉引用造成的规则逻辑耦合。文章认为这一结构也出现在 ICD-10 医疗编码、法律合规和税务审计中。

## 基准构建

数据来自真实全球电商平台，保留冗长标题、错误属性和误导关键词等真实噪声，并经语义去重以覆盖长尾。团队由 26 位平均从业 5 年以上的关务专家标注，采用六步流程：两位专家浏览商品信息；抽取核心结构化特征；检索 CROSS 历史裁定并校验；对无先例商品应用专家决策规则；校验最终编码；两人独立标注一致才接收，分歧由资深专家仲裁，再由独立专家抽样复标。文章称最终数据集有 632 个真实商品，横跨 32 个大类，专家分歧率约 2%。

评估以 Exact Match Accuracy 为主，分别报告 2/4/6/8/10 位准确率，其中 10 位编码衡量端到端层级推理。文章还以 bootstrap 95% 置信区间讨论 632 样本的统计稳定性。

## 评测和分析

文章称测试了 28 个系统，覆盖 GPT-5.5、Claude-Opus-4.8、GLM-5.2、DeepSeek-V4-Pro、Qwen3.7-Max，以及多个开源 Agent 框架和商业深度研究系统。按文中报告，最强 Agent 的 10 位准确率约 49.4%，关务专家约 95%；基于大量人工规则的决策树约 45.0%。在 6k 条专家标注数据上做 SFT 与 Agentic RL 后，Qwen Agent 约 65%，仍低于人类专家。

文章指出两类常见 Test-Time Scaling 策略没有填补差距：Voting@K 从 1 增至 16 基本无提升；自我反思增益很小且可能将正确样本改错。增加 reasoning effort 在报告的 GPT-5 实验中从 40.82% 降至 35.44%，被解释为“推理漂移”：当关键事实在规则和外部知识中时，缺少准确工具反馈的自由推演会编造约束或忽略有效规则。

作者列出三类有效信息的相对作用：接入 CROSS 历史裁定库，GLM-5.2、DeepSeek-V4-Pro、Qwen3.7-Max 的 10 位准确率分别增加 9.65、7.76、5.38 个百分点；视觉信息对强视觉模型有边际帮助，例如 GPT-5 从 42.72% 到 46.83%，但对较弱模型增益接近零；将裸模型放入可检索并应用规则/知识的 Agent Harness，六个 GPT-5 骨干 Agent 的平均 10 位准确率从 28.96% 到 37.42%，即 +8.5 个百分点。文中结论是规则/知识检索是地基，历史裁定是稳定的先例，视觉是补充；规则不能只塞入上下文，必须被 Agent 主动检索、按优先级裁决并逐层应用。

## 从基准到落地与开源

文章建议先评测、后优化，重点增强错误回溯、规则优先级动态判定，以及将推理锚定在专家规则和动态知识上。其开源链接：GitHub https://github.com/ATH-MaaS/Marco-DeepResearch ，Hugging Face 数据集 https://huggingface.co/datasets/ATH-MaaS/HSCodeComp ，论文 https://aclanthology.org/2026.acl-long.937 。
