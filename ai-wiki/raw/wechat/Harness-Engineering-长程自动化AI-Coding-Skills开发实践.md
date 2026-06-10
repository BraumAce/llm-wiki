# Harness Engineering：长程自动化 AI Coding / Skills 开发实践

- 作者: 胡韶山
- 发布时间: 2026年6月8日
- 原文链接: https://mp.weixin.qq.com/s/mSjb20PDsfiK88C9AQB7og
- 来源: 阿里技术

---

## Harness Engineering 是什么

Harness 一词来源于马具。马是强大的 AI 模型，Harness 是缰绳、马鞍和护具等工程管理学，骑手是人类工程师。

工程演进三阶段：
- Prompt Engineering（2023-2024）：怎么跟模型说话？单次交互、无状态、高度依赖个人经验
- Context Engineering（2025）：模型应该看到什么？Karpathy 明确表态比提示工程重要得多
- Harness Engineering（2026）：整个环境应该如何运作？约束、反馈回路、自动验证、熵管理、生命周期治理

AI 主权从模型厂商转移到用户侧，权责对等——拥有了调解 Agent 的权利，也需要学会 Harness。

## 案例一：编辑工具的改变，让 15 个模型同时变强

来源：Can Duruk, "I Improved 15 LLMs at Coding in One Afternoon", 2026.02

Agent 修改代码文件的编辑工具本身就是巨大的失败源。Grok 4 使用 patch 格式的失败率高达 50.7%。

Hashline 方案：模型读取文件时每一行附带 2-3 字符的内容哈希标签，编辑时引用标签而非复现原始文本。Grok Code Fast 1 成功率从 6.7% 飙升至 68.3%，十倍提升。Grok 4 Fast 输出 token 下降 61%。

"你在怪飞行员，但问题出在起落架上。"

## 案例二：技术债的指数级放大效应

来源：AgentsMesh 开发者, "52 Days, 350K Lines Solo", Reddit, 2026.03

传统开发中技术债是线性累积的。Agent 协作开发中，技术债变成自我复制的病毒：一个坏模式可以在几小时内被 Agent 复制到代码库的每一个角落。

当好的实践占主导时，Agent 放大好的实践；当捷径占主导时，Agent 放大捷径。

OpenAI 做法：把"品味"编码为自动化规则，定期运行后台 Codex 任务扫描偏差、更新质量等级、发起有针对性的重构 PR。人类的品味一旦被捕捉，就会持续应用于每一行代码。

## 案例三：子 Agent 作为"上下文防火墙"

来源：HumanLayer, "Skill Issue: Harness Engineering for Coding Agents", 2026.03

Agent 的上下文窗口会随着工作推进而"腐烂"。当上下文膨胀到一定程度，Agent 进入"笨蛋区"。18 个模型在 Terminal Bench 2.0 上的表现随上下文长度增加而显著下降。

解法：父 Agent 负责规划（高推理模型），子 Agent 在隔离上下文中执行（便宜快速模型），只返回高度压缩的结果 + 源引用。父 Agent 始终保持在"聪明区"。

阿里 HiClaw 项目的 Manager-Workers 架构也是"上下文防火墙"。

## 案例四：反馈回路的重新设计

"成功应该是沉默的，只有失败才应该发出声音。"

完整测试套件的 4000 行通过输出涌入上下文窗口会导致 Agent 产生幻觉。Hook 脚本：一切通过则完全静默，失败则只输出错误信息。

LangChain 设计 PreCompletionChecklistMiddleware（交卷前强制验证）+ LoopDetectionMiddleware（追踪重复编辑次数）。Terminal Bench 2.0 从前 30 跃升至前 5。

## 群体智能：CLI-Anything + HiClaw

CLI-Anything（港大）：分析任意软件源码自动生成 CLI + SKILL.md，让 Agent 能调用 GUI 软件（GIMP、Blender、Audacity 等）。

HiClaw（阿里开源）：Manager-Workers 架构，每个 Worker 的 Skills 和记忆独立存储避免污染，引入 Higress AI Gateway 做鉴权/限流/安全审计，引入 MinIO 共享文件系统降低 Token 消耗。

## 核心结论

同一个模型，不同的 Harness，截然不同的结果。Agent 竞争优势在于你构建了怎样的 Harness。Harness 成了护城河——不只是 Agent Builder 的护城河，更是 Agent User 的护城河。
