---
title: "让Skill自己训练自己-8阶段Loop-3层评测-5维AND门控"
type: source
date: 2026-05-29
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/dDkVA9mfNbJWTwkVKN1AOQ"
author: "腾讯云开发者"
ingested_at: 2026-05-29
tags: [skill, self-evolution, training-loop]
related_entities: [OpenClaw-Skills, Harness-Engineering]
related_topics: [Agent架构演进-主题]
---

# 让Skill自己训练自己-8阶段Loop-3层评测-5维AND门控

## 一句话概括
Skill-Evolver将深度学习的训练范式应用于Skill优化，通过8阶段Loop（Review-Ideate-Modify-Commit-Verify-Gate-Log-Loop）、3层评测（快速门卫/Dev Eval/Strict Eval）和5维AND门控，实现Skill的自进化——19轮零回滚迭代中发现了14个之前完全看不见的问题。

## 摘录
> Skill 最容易让人误会的一点，是它看起来像 prompt，实际上更像 harness。写一个能跑的 skill 不难，你随手糊一个 SKILL.md，模型就能照着做事了。但你要让它稳定干活，那就是另一回事了。触发边界怎么定？安全规则怎么加？references 之间的一致性谁来管？脚本版本兼容谁来保证？

> Meta-evolution 最有价值的不是自动化节省时间，是它在替一个你还没见过的用户，跑一遍你自己永远跑不到的路径。你自己测你的工具，只能在你熟悉的 regime 里测。19 轮就是 19 个不同的 regime。每一次 rebaseline 都会暴露一类你之前想不到的失败。

> Skill-Evolver = AutoResearch 的 loop 骨架 + Creator 的评测引擎 + Meta-Harness 的诊断大脑。与其写更长的 prompt 来"说服"它守规矩，不如把规矩写进代码——门控函数不通过就 git revert HEAD，没有商量余地。程序掌握控制流，LLM 只管单点生成。

## 涉及实体
- [[OpenClaw-Skills]] —— Skill是Skill-Evolver的训练对象
- [[Harness-Engineering]] —— Skill本质是harness，训练循环体现了Harness工程思想

## 涉及主题
- [[Agent架构演进-主题]]
