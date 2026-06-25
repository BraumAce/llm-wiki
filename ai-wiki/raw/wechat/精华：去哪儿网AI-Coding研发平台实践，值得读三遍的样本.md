---
title: "精华：去哪儿网AI Coding研发平台实践，值得读三遍的样本"
source_url: "https://mp.weixin.qq.com/s/Ug_fMuGkQmM4tECUbpfXOg"
author: "无处不在的技术"
publish_time: "2026年6月24日 08:07"
fetched_at: "2026-06-25T16:14:13.865Z"
fetcher: "chrome"
---

# 精华：去哪儿网AI Coding研发平台实践，值得读三遍的样本

- 作者: 无处不在的技术
- 发布时间: 2026年6月24日 08:07
- 原文链接: https://mp.weixin.qq.com/s/Ug_fMuGkQmM4tECUbpfXOg

---

去哪儿网AI Coding 研发平台实践：一份值得所有技术管理者读三遍的样本

内容来源：去哪儿旅行基础架构负责人/技术总监 李佳奇的技术大会的分享

主题：从工具试点到范式升级——去哪儿网是如何把 AI Coding 从"个人玩具"做成"组织能力"的


01


为什么我决定把这篇分享"拆开重写"


过去一年，我看过太多关于"AI Coding"的分享：有的在讲 Prompt 技巧，有的在讲 Cursor/Claude Code 的花式用法，有的在晒个人提效多少倍。但
真正让我眼前一亮的，是这次去哪儿旅行李佳奇的分享
——

他几乎不讲"AI 写代码有多爽"，而是把镜头对准了一个更底层的问题：

当一个几千人的研发组织里，100% 的人都在用 AI Coding 时，团队的能力到底发生了什么变化？我们又该如何度量它、引导它、让它不要失控？


这份分享提出了三个让我印象极深的概念：

AI Coding 的"自动驾驶分级"
（L0 - L5），把业界最热门的"AI 写代码"装进了一个可以和自动驾驶对标的成熟框架里；


Harness（驾驭/束带）
——决定 AI Coding 上限的不是模型，而是"约束、隔离、人工审查节点"组成的工程体系；


QunarDevCenter + 天弦 + Qsuperpowers + Skills 体系
——一套把"个人提效"沉淀为"组织能力"的完整工程实现。


下面我把这 49 页的分享，按"为什么—是什么—怎么做—效果—启示"的逻辑，完整还原成一篇值得你在团队里转发的深度长文。

02


背景：去哪儿为什么要"全员 AI Coding"？


[图片: 图片]

去哪儿作为一家典型的大型 OTA（在线旅游）公司，在 2025 年做了一个非常激进的决定——
全面落地 AI Coding
。从分享里可以看到他们在 AI 应用层的布局：

应用层
从 prompt 级别的"帖子评级自动化""改图提示词扩写"，到 workflow 级别的"URS 智能归因""质检运营提效""AI 自动化测试""代理商 AI 助手""漏洞审核 Agent"，再到 AI Agent 级别的"九章 AI""护航 Agents""Deep Research"，一直延伸到 Agentic AI 级别的"AI Coding""数分 Agent"和"通用智能体"。


入口层
Web 端、飞书机器人、API 接口三路打通。


基础能力层
账号管理、成本监控、用户/权限、报警监控、会话管理、Case 集管理、自动化评估、安全控制、审计日志、智能体管理一应俱全。


模型层
Deepseek 系、GPT 系、Gemini 系、Claude 系、GLM 系、Qwen 系、GPT-4o、GPT-4o-mini、aliyun/qvq-max 全部接入；自研了 Embedding 模型和 Rerank 模型。


结果
：
数万 PD 级业务提效、近亿级业务价值
。

但这个"宏大叙事"背后的隐含问题是：
当公司决定 All in AI Coding 时，作为基础架构团队，到底应该先做什么？

李佳奇的回答非常冷静：

先回答"度量"这件事。


03


AI Coding 的过程指标和效果指标——别只盯"AI 写了多少行代码"


[图片: 图片]

这是整场分享最"反共识"的一页。

绝大多数团队在搞 AI Coding 的时候，兴奋地对外宣布"出码率 90% 了！"、"我们的 AI 生成了 100 万行代码！"。但李佳奇把这些都归到了
"过程指标"
的范畴，并在右下角打了一个大大的问号：
"越多就越好吗？"

他反问：
"出码率 90%"背后的质量、安全、长期可维护性，谁来负责？

正确做法是看
效果指标
：

研发效率提升
——而且必须可以
进入计划阶段
（这就是后面"双估时"的伏笔）


业务价值贡献
——AI Coding 不是"写代码更快"，而是要回答"它到底让业务变好了多少？"

[图片: 图片]




于是他们给出了完整的
AI R&D Metrics = Volume × Maturity
度量公式：

量的度量
（Quantity）：

- 出码率（AI code ratio）

- 出码量（AI code volume）

- 团队覆盖率（Team adoption）

- 需求覆盖率（Requirement coverage）

质的度量
（Quality）：

-
Coding 自动化水平
（从辅助编码到端到端自动化，对应 L1 - L3）

-
Harness 等级
（环境、工具链、流程成熟度，对应"Refined"等级）

度量目标：同时衡量 AI 产出规模与研发过程成熟度。


这一页其实给了我们一个非常重要的提醒：
别让 AI Coding 变成一场"出码率 KPI 竞赛"
。没有质的量，最终会让团队付出代价。

04


AI Coding 自动化水平 L0 - L5——把"AI 写代码"装进自动驾驶分级


[图片: 图片]

这是我整场分享里
最想给所有管理者看的一页
。

李佳奇直接借用了自动驾驶分级体系，把 AI Coding 也分成了 L0 - L5 六级。每一级都有明确的"AI Coding 定义"和"自动驾驶类比"，堪称
业界最清晰的一份 AI Coding 阶段定义
：

等级

名称

AI Coding 定义

自动驾驶类比


L0
全手动

研发过程完全由人完成，不依赖 AI 生成代码、补全代码或参与研发流程。

人工驾驶


L1
代码补全与辅助

AI 辅助补全变量、函数、样板代码或局部代码片段；人承担主要编码、判断和最终决策。

辅助驾驶（类似自动跟车、加速减速）


L2
部分自动生成

AI 根据注释、API 文档或上下文，生成函数、类、接口代码等模块内容；人负责监控、调整、测试和组装。

部分自动驾驶（类似 ACC、自适应巡航、车道保持；驾驶者需要随时接管）


L3
有条件自动化

人提供需求、API 规范、编码规范和示例；AI 生成可运行代码并进行功能测试，遇到阻塞时提示人工介入。

有条件自动驾驶（车辆在特定环境中自动驾驶；系统判断无法继续时请求人工接管）


L4
高度自动化

AI 承担大部分编码、测试、集成和交付流水线工作；人负责目标设定、质量验证、架构设计与核心逻辑审核。

高度自动驾驶（驾驶者可以阶段性脱离驾驶任务，但仍保留监督责任）


L5
完全自动化

从需求理解、方案拆解、编码、测试到上线主要由 AI 完成，仅在异常或重大变动时由人介入。

无人驾驶


去哪儿在 2026 年 H1 给自己定的目标，
就是 L3 自动化任务占比 30%+
。

为什么这个分级重要？因为：

让团队有共同的"语言"
以前我们说"我们用 AI 写代码"，每个人脑子里想的等级不一样——有的是 L1（Copilot 补全），有的是 L3（需求到代码）。有了 L0 - L5，大家可以明确说自己团队现在在哪一级、下一阶段要去哪一级。


让"AI Coding"成为可治理的对象
管理者可以根据等级差异，给不同任务配不同的人力审查强度，而不是一刀切。


让"AI Coding 价值"可衡量
L1 → L2 → L3 的跨越，本质上是把"个人效率"变成"组织能力"的过程，每跨一级，对业务价值的贡献都不是线性增长。


05


AI 研发 Harness 水平定义——决定上限的不是模型，是 Harness


[图片: 图片]

如果说上一章是"分阶段定义"（AI 做到了什么），这一章就是"分过程定义"（
AI 是怎么被控制的
）。

李佳奇抛出了一个让我醍醐灌顶的概念：

Harness = AI 研发过程控制能力。衡量 AI 在研发流程中是否被稳定触发、被约束、被隔离、被审查。


他明确说：
"不是只看 AI 是否参与，更关注 AI 参与方式是否可控、可复用、可审计、可规模化。"

目标：安全地提升自动化。在关键节点保留人工判断，避免 AI 直接无约束进入生产链路。

他把核心研发流程的 12 个环节全部拆出来，定义了每个环节的 AI 参与控制点：

需求文档编写
AI Draft → 模板约束 → 人工确认


需求评审
缺口识别 → 评审规则 → 关口审查


方案设计
方案生成 → 架构约束 → 专家 Review


代码编写
Skills 触发 → 编码规范 → 隔离环境


代码测试
测试生成 → 覆盖率门禁 → 沙箱执行


Checklist/Case 编写
Case 生成 → 验收标准 → 人工补充


开发自测
自测助手 → 虚拟环境 → 结果校验


代码 Review
风险扫描 → Review 规则 → 人工合入


QA 测试
缺陷分析 → 测试准入 → QA 判断


自动化回归
回归编排 → 隔离执行 → 失败拦截


灰度验证
指标观察 → 灰度策略 → 人工放量


生产发布
发布辅助 → 变更门禁 → 人工审批


为了把 Harness 做实，他提出了
四把锁
：

AI 触发机制
——在关键环节引入 Skills / Workflow / Agent，让 AI 能力被流程化调用。


约束与门禁
——明确输入模板、编码规范、质量标准、准入条件和失败拦截规则。


安全隔离环境
——为 AI 执行、测试、回归提供沙箱或虚拟环境，避免直接影响生产。


人工审查节点
——在需求、设计、合入、灰度、发布等关键节点保留人工确认权。


我的个人评价
：这一页是整场分享
最被低估的资产
。业内绝大多数团队现在还停留在"模型换更好、Prompt 写得更好"的层面，却没有意识到——
AI Coding 的真正瓶颈是 Harness
。一个没有 Harness 的 AI Coding 系统，就像一辆没有方向盘的车，模型再强也只会撞墙。


06


整体落地路径——从"工具使用"到"端到端交付"


[图片: 图片]

讲完了"度量"和"水平定义"，李佳奇给出了
去哪儿实际跑通的整体落地路径
，分四步走：

Step 1：AI Coding 工具引入和推广
- 引入头部工具：Claude Code、Codex、Cursor - 工具引入：面向团队提供可选工具组合，降低 AI Coding 使用门槛 - 实践沉淀：输出 Prompt、Workflow、代码生成、Review 等最佳实践 - 案例推广：挖掘高价值场景和优秀团队样板，形成可复制方法

Step 2：基建建设与 AI 接入适配
- 围绕研发基础平台和 Skills 网关，建立统一接入、治理和分发能力 - Skills 网关：对研发流程中的基础平台进行 AI 接入适配改造 - 统一仓库：建立统一 Rules 与 Skills 仓库，支持复用和治理 - 安全治理：支持安全审核准入、统一分发、实时更新等能力

Step 3：研发自动化平台建设
- 自研研发自动化平台"天弦"（Qunar Dev Orchestrator，简称 QDO），支撑多 Agent、多 Skills、全链路编排 - Multi-Agent、Multi-Skills - 多 Coding Agent：统一调度不同 Agent，适配不同研发任务 - 多研发环节编排：覆盖需求、设计、编码、测试、发布等环节 - 端到端交付：从局部提效走向自动化编排与自动交付

Step 4：全流程数字化采集和分析
- 建设 QunarDevCenter，形成 AI 研发全流程数据采集、上报与分析闭环 - 多端采集：支持主流 AI Coding 工具的数据采集与上报 - 标准协议：制定统一上报数据标准协议，保证可比、可聚合 - 洞察分析：Insight 出码率、自动化水平、覆盖率和质量变化

底层的闭环逻辑
：

从"工具使用"到"流程接入"
先让 AI Coding 被用起来，再让 AI 能力进入研发基础设施和标准流程。


从"单点提效"到"端到端交付"
以自动化平台承接流程编排，以数据采集分析驱动持续优化。


AI 研发落地闭环
```
Tool → Infra → Automation → Insight
```


我的解读
：这四步不是"四条平行线"，而是
严格的依赖关系
。没有 Step 1 的工具普及，就不会有 Step 2 的接入适配需求；没有 Step 2 的基建，就支撑不了 Step 3 的自动化平台；没有 Step 3 的全链路编排，Step 4 的数据洞察就没有意义。
这是一个典型的"先打地基，再盖楼"的故事
。


07


QunarDevCenter——给"AI Coding 写代码"做埋点


[图片: 图片]

进入 PART 02 的核心内容：
AI Coding 数据体系建设
。

为什么必须先做数据体系？李佳奇在 page 14 给了清晰的因果链：

2025 H1 做了
研发全流程数字化落地
——覆盖任务、测试、发布、监控等平台的前后端研发行为埋点，并完成链路串联；最初用于分析研发效率瓶颈和机会点。


2026 在此基础上形成
AI Coding 数据体系
——利用研发全流程数字化底座，采集并分析研发各环节中的 AI 参与情况，形成可度量、可洞察、可优化的数据体系。


具体四步：

采集 AI 参与情况
——识别 AI 在需求、设计、编码、测试、发布等环节的参与深度。


接入多端工具数据
——汇聚 Claude Code、Codex、Cursor 等工具行为数据。


打通研发链路分析
——将 AI 数据与任务、测试、发布、监控链路关联。


支撑管理洞察
——洞察出码率、自动化水平、覆盖率和效率变化。


AI Coding 数据体系的四类核心分析能力
：

效率瓶颈识别


AI 参与度分析


自动化水平洞察


数据体系闭环

[图片: 图片]




7.1 QunarDevCenter：客户端长什么样


这是 QunarDevCenter 的客户端界面，左侧有"概览/模型/会话/Cursor/设置"五个 Tab，主体显示"本地会话"——总记录 360 条、已上传 215 条、待上传 0、失败 0、已过滤 145。

它的
核心定位
是：

面向 AI Coding 落地的数据采集、CLI 代理管理与公司大模型接入工具

Codex 与 Claude Code 均需安装：请首先安装此代理，它是 AI Coding 数据采集与公司模型接入的入口组件。


统一管理 CLI 端代理
让 Claude Code、Codex 等 CLI 工具走公司的大模型，并统一管理模型配置。


四大能力
：

Session 数据采集
——采集 Claude Code、Codex 的本地会话记录，用于个人出码率计算与 AI 研发数据分析。


多端数据接入
——同步接入 Cursor、Copilot、OpenCode 等使用数据，补齐 IDE 与 CLI 两类 AI Coding 行为。


本地过滤上报
——上报前在本地过滤，仅上传 git remote url 为公司 GitLab 的项目相关会话记录（
安全合规红线
）。


模型与 Thinking 支持
——持续支持 DeepSeek、GLM、Qwen、Kimi、MiniMax 等模型，支持思考级别与 1M 上下文。


数据来源
：Claude Code / Codex / Cursor / Copilot / OpenCode / IDE 行为数据
目录模式
：单项目模式、Workspace 模式、Qunar Workspace、VSCode Remote、Git Worktree

高频迭代主线
：从 Session 采集到多端、多模型、多模式支持——1.3.0 基础能力成型、1.4.x/1.5.x 代理与模型增强、1.6.x 本地会话与稳定性、1.7.x Cursor 与远程场景、1.8.0/1.8.4 Workspace 与配额、1.8.5/1.8.6 OpenCode 与 1M 上下文。

[图片: 图片]



7.2 跨多端 Session 数据采集：发现 → 扫描过滤 → 调度上传


整个处理流程被设计为三段式：

阶段一：发现 Session 文件（Discovery）


- Claude Code：扫描
```
~/.claude/projects/**/*.jsonl
```


- Codex：扫描
```
~/.codex/sessions/**/*.jsonl
```


- Windows：额外支持 WSL 路径

- OpenCode：读取 SQLite 的 session / message / part，拼装等价 jsonl artifact

阶段二：扫描 & 过滤（Scan）


- 快速路径：mtime + size 未变、且有 git/workspace cache，则复用缓存跳过解析

- 内容解析：读取文件计算 sha1，解析 git remote 或 workspace 信息

- 过滤：按 gitRemoteAllow 白名单过滤，非命中标记为 filtered

- 去重：已上传且内容未变的 session 直接跳过

阶段三：调度上传（Upload）


- 触发：通过定时器轮询触发上传，上传时逐个处理

- 限速：支持 rate limit，控制 IO 与网络压力

- 错误策略：4xx 不计连续失败数；5xx / 网络错误累计，默认 3 次后跳过剩余文件

- 持久化：结果写入 SQLite upload_state 表

上报数据格式（原始 jsonl artifact + 严格校验元数据）
：

```
clientId          string   · 客户端标识os                string   · 操作系统appVersion        string   · 应用版本sessionSource     enum     · 'claude' | 'codex' | 'opencode'relativePath      string   · 相对路径 / 虚拟 locatorfileName          string   · 文件名mtimeMs           number   · 修改时间size              number   · 文件大小sha1              string   · 40 位内容指纹username          string   · 用户名git.remoteUrl     optional · 仓库地址context.repos[]   workspace 模式：name / relativePath / remoteUrl
```

ClaudeCode / Codex / OpenCode 多端兼容
：通过
统一 Provider 抽象
（
```
listSessions()
```
/
```
loadArtifact()
```
/
```
source registry
```
/
```
upper pipeline
```
）屏蔽底层的 jsonl/SQLite 差异，最终都归一化为
上传内容
= session 文件原始内容（即 jsonl artifact）+ 上述 metadata，所有字段在上传前进行严格校验。

[图片: 图片]



7.3 三张核心表


```
-- session_upload_objects：上传内容 + 元数据CREATE TABLE session_upload_objects (  id                BIGINT       PRIMARY KEY,  session_source    VARCHAR(32)  -- claude / codex / opencode,  object_key        VARCHAR(128) -- object storage key,  username          VARCHAR(64)  -- upload user,  client_id         VARCHAR(512) -- local client id / path,  relative_path     VARCHAR(1024)-- local session relative path,  file_name         VARCHAR(256) -- jsonl file name,  mtime_ms          BIGINT       -- file modified timestamp in ms,  size_bytes        BIGINT       -- original file size,  sha1              CHAR(40)     -- content fingerprint,  os                VARCHAR(32)  -- darwin / win32 / linux,  app_version       VARCHAR(64)  -- QunarDevCenter version,  git_remote_url    VARCHAR(1024)-- repo attribution,  content_encoding  VARCHAR(32)  -- gzip / none,  content_bytes     BLOB         -- uploaded artifact content,  raw_bytes         BIGINT       -- raw artifact bytes,  compressed_bytes  BIGINT       -- compressed artifact bytes,  metadata_json     JSON         -- original client metadata,  create_time       TIMESTAMP    -- record create time,);-- session_meta_info：会话级元信息CREATE TABLE session_meta_info (  id                BIGINT       PRIMARY KEY,  session_id        VARCHAR(128) -- parsed session id,  session_source    VARCHAR(32)  -- claude / codex / opencode,  object_key        VARCHAR(128) -- source artifact object key,  username          VARCHAR(64)  -- upload user,  client_type       VARCHAR(64)  -- client application type,  client_version    VARCHAR(64)  -- client application version,  os                VARCHAR(32)  -- darwin / win32 / linux,  git_url           VARCHAR(1024)-- repository remote url,  input_tokens      BIGINT       -- prompt / input token count,  output_tokens     BIGINT       -- completion / output token count,  cached_tokens     BIGINT       -- cached token count,  upload_time       TIMESTAMP    -- artifact upload time,  session_begin_time TIMESTAMP   -- session start time,  session_end_time  TIMESTAMP    -- session end time,  create_time       TIMESTAMP    -- record create time,  update_time       TIMESTAMP    -- record update time);-- ai_gen_code_change：AI 代码变更记录CREATE TABLE ai_gen_code_change (  id                BIGINT       PRIMARY KEY,  session_id        VARCHAR(128) -- source AI session id,  change_type       VARCHAR(32)  -- ADD / MODIFY / DELETE,  file_name         VARCHAR(1024)-- changed file path,  code_add_num      BIGINT       -- added code line count,  code_delete_num   BIGINT       -- deleted code line count,  change_content    JSON         -- addlines / removelines detail,  git_branch        VARCHAR(256) -- branch name when generated,  gen_time          TIMESTAMP    -- AI generation time,  create_time       TIMESTAMP    -- record create time,  update_time       TIMESTAMP    -- record update time);
```

作为一个写过埋点系统的工程师，我对这套表设计有强烈共鸣
：原始 artifact 与元数据分离、会话与代码变更分离、token / 时间 / 路径分门别类，
几乎是为后续做 AI Coding 数据分析"量身定做"的
。


[图片: 图片]






7.4 出码率怎么算——它其实比你想的复杂得多

分享里给出了一张"出码率计算"流程图，
这条链值得仔细读
：

数据源采集
Claude / Cursor / Codex 三个工具的 session 通过定时器清洗后入库
```
session-upload-object
```
；


会话元数据入库
从 session 中提取元信息（session_id、git_url、username、time_range 等）写入
```
session_meta_info
```
；


代码变更记录
```
ai-gen-code-change
```
表里记录了每次 AI 在某个 session_id 下的
```
change_content
```
（addlines / removelines）、
```
timestamp
```
；


生产发布消息
监听 IC（集成中心）的发布消息，落库
```
prod-release-payload
```
；


关联 Git 地址
通过
```
git_url
```
匹配到对应发布 tag；


匹配 session_id
把 session 落到对应发布版本上；


AI 代码改动
在
```
ai-gen-code-change
```
表中查得到具体改动；


两次 tag 之间的时间周期
——根据分支创建时间优化；


两次 tag 期间所有 commit
——是否在 AI session 提交范围内？判断逻辑是
```
用户修改代码行，是否可被通过 Git Blame 化
```
；


代码 diff 结果
——从两次 tag 之间拉 diff 出来；


出码率计算
——分母是基于 git_url、tag、pmoId 等聚合出来的"用户实际写的代码量"，分子是 AI 在同一个时间窗口内生成的代码量。


我看到这张图时笑了
——这不就是经典的"
生产基线对比
"思路吗？先确定基线版本，再确定目标版本，然后对比两版本间的所有 commit 中，AI 贡献了多少行。

但这套流程里藏着几个非常工程化的细节：

-
Git Blame 化处理
：区分"用户自己改的" vs "AI 改的"，避免把用户后续的微调也算成 AI 产出；

-
PMO 信息查询
：要拿到 dev/fe/qa 的人员标识；

-
失败拦截
：4xx 不算连续失败，但 5xx/网络错误累计到 3 次就跳过剩余文件——这是非常真实的"分布式系统"经验。




[图片: 图片]




7.5 出码率可视化报告

上图是一个完整的出码率可视化报告：

顶部卡片
提交者、Source Branch、Target Branch、项目、Git URL、生成时间、查询时间范围


左侧命中 Session 列表
62 个 session，含 Session ID、来源、用户、创建时间


右侧文件详情
每个文件的"AI 命中 X/Y"展示


右侧统计
总代码行数、AI 代码行数、用户代码行数、AI 占比 47.4%


这一页给我的启发是：
出码率必须做到"可下钻"
。光给一个公司级的 47.4% 是没有用的，必须能下钻到部门、下钻到项目、下钻到人、下钻到 session、下钻到文件。否则就是"自欺欺人的数字"。




7.6 自动化水平 Insight：把 AI 参与方式拆成三个可量化维度


[图片: 图片]

为了把 L1 - L3 的等级定义变成可观测的指标，他们定义了三个核心维度：

T 绝对时长
（duration）：该队伍所有有效会话中，最早开始时间到最晚结束时间的跨度，体现整体推进效率。可用于观察需求从开始 coding 到发布合并 master 的整体周期。
评分趋势：越小越好
。


M 用户消息数
（messages）：用户消息总条数，即交互次数，体现人工介入频次。消息越多通常意味着需要更多澄清、纠偏、重试或人工拆解。
评分趋势：越小越好
。


C 用户输入字符数
（chars）：所有用户消息文本长度之和，体现需求表达精炼程度。输入越长，往往说明上下文补充、约束说明、人工指导成本更高。
评分趋势：越小越好
。


从完整 Session 还原 Coding 全过程
：

需求关联
通过分支 / git_url / session_id 关联到某个需求。识别需求从开发开始到合并 master 的周期。


AI Coding 使用
解析用户消息、assistant 输出、tool_use、tool_result。识别 AI 在设计、编码、测试中的参与方式。


人工介入
通过消息数、用户输入量、重试轮次观察人工介入频次。识别澄清、纠偏、补充上下文和手动调整。


输出调整
对比 AI change_content 与后续 diff。识别 AI 输出被修改、替换或保留的程度。


独立完成
观察 AI 是否完成整个功能、测试、case、回归脚本。判断人工是否仅做验收或关键审查。


发布闭环
关联 rTag、release_time、commit、PMO 信息。形成需求级自动化水平 insight。


自动化水平 L1 - L3 映射
：

L1 辅助编码
AI 参与局部代码生成。人工输入多、交互频繁，AI 主要完成片段补全、函数修改、局部解释或小范围代码生成。


L2 半自动交付
AI 完成模块级开发。AI 能完成较完整功能模块，人工主要负责需求拆解、约束补充、结果校验和少量修正。


L3 高自动化
AI 端到端推进任务。AI 能连续完成编码、测试、回归和交付准备，人工主要在关键节点审查和验收。


最终 Insight 输出
：

自动化水平
基于 T/M/C、AI 改动占比、人工调整程度，生成需求级 L1 - L3 评估。


人工介入点
定位在哪些环节人工输入最多、反复纠偏最多、上下文补充最多。


瓶颈与卡点
识别需求表达、环境准备、测试回归、发布联动中的效率瓶颈。


改进机会
反推需要沉淀的 skills、模板、上下文、约束和自动化工具链能力。


这一页是整场分享里"技术含量最高"的一页
。它把"AI Coding 自动化水平"从抽象定义变成了可观测、可计算、可改进的数据指标。

更重要的是，它把"AI 写代码"这件事
从模型能力问题变成了工程问题
——你的 T/M/C 三个指标如果都下降，那说明你的 Skills 沉淀、上下文管理、约束机制在起作用；反之则说明 AI 还在"乱撞"。




7.7 公司级看板：三级部门维度的出码率与需求覆盖率



[图片: 图片]

三级部门维度-AI 出码率-周维度
每条线代表一个三级部门，从 2026W01 到 2026W18 的出码率变化趋势。可以看到大部分部门从年初的 0.1-0.2 涨到了 W18 的 0.6-0.9，其中峰值 1.00 出现在某个部门 W07。


三级部门维度-需求覆盖率-周维度
每条线代表一个三级部门，从 2026W01 到 2026W18 的需求覆盖率变化。可以看到大部分部门的需求覆盖率从年初的 0 涨到了 W18 的 0.6-1.0。


这张图最值得说的不是"我们涨了多少"，而是"我们敢把这种图贴出来"
。一个三级部门维度的周维度公开看板，意味着内部已经形成了一种
"被看见的研发透明文化"
。这种文化反过来又会驱动各团队"看齐"和"内卷"，是组织级 AI Coding 落地的隐形加速器。


08


天弦（QDO）——把 AI Coding 编排成可调度的工作流


[图片: 图片]

进入 PART 03，开始讲
典型案例
。但比起"案例"，我更想说的是：
去哪儿是怎么把零散的"AI Coding 任务"变成一个"可被调度的工作流"的
。答案就是他们自研的
天弦（Qunar Dev Orchestrator，简称 QDO）
。

[图片: 图片]





8.1 天弦的主界面与场景


QDO 主界面左侧菜单
：

- 一句话需求

- 异常修复

- workflow 需求

- 线上诊断

- JDK 升级

- 新建场景

- 任务看板

- Skill 市场

- 平台设置

主区
显示任务列表，每条记录包含：用户输入的需求描述、状态（已完成 / 失败 / 等待中 / 运行中）、claude-code 执行代理、消耗的 token 数（如 24.84、0.306、4.894、3.948、6.4、1.016 等）、来源项目、提交时间。

场景示例
（截图里看到的真实需求）：

"使用 checklist-pipeline skill，根据测试主题：五一活动优化，文件：skills/checklist-pipeline/checklist..." — 已完成


"写一个 checklist" — 已完成


"order.barter.service.action.NewConfirmBarterActionService
#handleHighPr
..." — 等待中


"在这个目录下写一个定时任务，每小时打印一条日志，内容是你好" — 运行中


"删除 SwiftConfig" — 已完成


"先使用 feishu-doc-smart-recognition，处理以下飞书文档 prd：https://..." — 失败


"修改空指针" — 等待中


"使用 checklist-pipeline skill，根据以下 prd 生成 checklist 并生成 km 格式的 checklist，需求变更日志变更时间变更人变更内..." — 等待中


"BudgetUsageService 中的 defaultPrice 修改为 0.028，并且改为从 qconfig 中读取" — 已完成


"componentManage.jsp 页面中的列表项删除按钮增加弹框二次确认，免误操作删除" — 已完成


看到这些"一句话需求"列表，我的第一反应是：这就是 L3 自动化的"作业现场"
。每一个需求都很具体、很真实，但又足够复杂，AI 完全可以代劳。这种"业务场景清单"，本身就是 AI Coding 落地最难沉淀的资产。




8.2 案例一：JDK 自动升级——把"老旧系统迁移"变成"流水线产品"


[图片: 图片]

AI-based JDK Auto Upgrade
累计成功升级应用
211 个
，
编译通过率 93%
。

方案核心：规则 + Agent + 流水线

OpenRewrite 规则升级
——基于已有规则能力完成 JDK API、依赖、配置、语法层面的批量迁移，提供确定性改造基础。


AI Coding Agent 自动开发
——Agent 承接规则无法覆盖的编译错误、兼容性问题、业务代码适配和测试修复。


开发测试流水线自动化
——自动拉取分支、执行编译、分析日志、修改代码、重新测试，直到交付可编译通过版本。


可交付代码产物
——自动产出升级分支、代码 diff、执行状态、耗时、版本信息，支持查看详情与 Diff。


6 步任务闭环
：

新建 JDK 升级任务（任务创建）


任务提交与调度（submitted）


Agent 执行升级 Workflow（AI Workflow）


自动编译与错误修复（compile loop）


查看代码变更 Diff（Diff Review）


升级成功并交付分支（success）


效果与平台通用性
：

从"规则批改"升级为"自动交付"
OpenRewrite 解决可规则化改造，AI Coding Agent 解决长尾代码适配与编译修复，流水线负责环境执行与结果闭环。


可观测任务结果
任务列表沉淀 appCode、Git 仓库、源/目标版本、分支、状态、耗时、创建人、更新时间、code diff。


可审查代码改动
通过详情页查看每个文件的改动，包括 import 替换、依赖升级、配置调整和 AI 修复内容。


通用场景扩展

一句话需求自动开发：从需求输入到代码产物自动生成


线上异常自动修复：基于日志、配置、代码上下文定位并修复问题


线上性能分析自动化：结合监控、日志与代码分析生成优化方案


AI 研发自动化平台能力链
：

```
任务输入（需求 / appCode / Git / 版本 / 分支）→ 任务编排（生命周期管理、策略管控、任务分发）→ Agent 执行（Claude Code / Codex 多 Agent 执行引擎）→ 基础 Skills（部署、日志、配置、环境检测、执行工具）→ 验证闭环（编译、测试、Review、回归、重试）→ 代码交付（升级分支、Diff、可编译通过产物）
```

我的评价
：JDK 升级这个场景的精妙之处在于——
它是一个"看起来无聊、但价值巨大"的需求
。每个 Java 公司的技术债清单里，JDK 升级都排在前列，但谁都不敢轻易动。AI Coding + OpenRewrite 规则 + 流水线，把这个"高风险低收益"的任务变成了"低风险高确定性"的批处理。

更重要的是，
它把 AI Coding 从"个人技能"沉淀成了"平台能力"
。任何工程师只要在 QDO 上点"新建 JDK 升级任务"，剩下的事情就交给平台——这是 L3 自动化的标准动作。


[图片: 图片]

JDK21 升级管理界面
包含：

任务列表：appCode、git 仓库、源 Java 版本、目标 Java 版本、源分支、目标分支、执行状态、执行耗时（秒）、成本、创建人、创建时间、最后更新时间、详情、查看 Diff、重试


新建 JDK 升级任务：appCode、git 仓库、原 Java 版本、源分支、新分支


JDK 自动升级-代码变更预览：OpenRewrite 修改 / Claude 修改 切换、切换到并排视图、展开全部、折叠全部




8.3 案例二：一句话需求开发


[图片: 图片]

这是去哪儿把"自然语言需求 → 真实代码改动"做成产品的最佳示范。

任务详情界面
：

- 任务 ID：18

- 状态：成功

- AppCode、Git 仓库、源分支、目标分支、部署环境、AI 代理（claude-code）

- 需求描述：一段完整的产品需求描述

[图片: 图片]

任务执行摘要
：

- 应用代码、部署环境、目标分支、修复状态、部署状态、总耗时：约 10 分钟

需求分析
：需求背景是优化行李配置信息更新流程，减少不必要的 QConfig 更新。主要优化点：

1. DB 更新触发 QMQ 发送优化：只有行李类型配置变更时才发送同步消息

2. QConfig 更新优化：

- 上传前的内容中，内容一致则跳过更新

- 使用 TreeMap 保证 JSON 序列化顺序稳定

- 分布式锁实现：通过 Redis 冷 key 控制更新频率

实现说明
：

1.
```
buildJsonConfig
```
使用 TreeMap 保证顺序稳定

- 使用
```
datasource
```
替代
```
HashMap
```
，按 row key 排序

- columns 和 item 也使用 TreeMap 保证字段顺序稳定

- 避免因 Map 顺序抖动导致校验不一直

2.
```
uploadToQConfig
```
内容 Diff 逻辑

- 通过
```
Snapshot#getContent()
```
获取当前 QConfig 内容

- 与新构建的 jsonConfig 进行严格 equality 比较

- 内容一致时记录返回且不调用 uploadAtVersion，不抛 NeedRetryException

3. 分布式限流（Redis 冷即 key）

- 上传成功后在 Redis 写入冷却 key（
```
luggage:dispatch:config:qconfig:cooldown
```
）

- 冷却期内（默认 60 秒）有更新请求时直接 NeedRetryException

- 冷却时间通过 QConfig 配置

4. asyncConfig 行李判断

-
```
skipOptimize
```
新增参数判断是否含行李类型

- 只有
```
subServiceType == 3
```
（Luggage）时才调用
```
sendLuggageAsyncMessage
```


- 批量导入场景也做了相应适配

修改文件清单
：

-
```
src/main/java/com/.../config/.../luggageDispatchConfigSyncListener.java
```
（修改）—— 添加冷却 key 常量，修改 buildJsonConfig 使用 TreeMap，添加内容 Diff 和限流逻辑

-
```
src/main/java/com/.../service/.../tMcAgentDispatchConfigManageService.java
```
（修改）—— 添加 SubServiceType 导入，添加 asyncConfig 批量处理，修改批量导入场景的 asyncConfig 调用

-
```
src/main/java/com/.../service/.../tMcAgentDispatchConfigService.java
```
（修改）—— 添加 SubServiceType 导入，修改批量导入场景的 asyncConfig 调用

部署信息
：部署时间、构建编号、部署主机、控制器链接

提交记录
：提交哈希、提交信息、修改文件数（3 个）

注意事项
：

1. 影响范围

- 行李配置同步流程

- QConfig 更新频率

- 最终一致性收敛时间可能延长（冷却期内变更会被延迟）

2. 测试建议

看到这一页，我必须说：如果这不是"AI 写代码"，我不知道什么是 AI 写代码
。

用户输入的只是一段产品需求描述，AI 自动完成了： - 需求分析（识别出 4 个优化点） - 实现方案设计（按 TreeMap、Redis 冷即 key 等技术方案） - 代码改动（3 个文件，含具体修改说明） - 部署上线 - 注意事项（影响范围 + 测试建议）

整个过程只用了 10 分钟
。这就是 L3 自动化的威力。


[图片: 图片]

代码 diff 界面
：左侧显示 3 个文件变更（+90 / -10），中间是具体的代码改动。例如：

```
tMcAgentDispatchConfigService.java
```
```
@ -2,6 +2,7 @@ package ...service;
```
之后是 import 块的调整，新增了
```
import com....constant.SubServiceType;
```


类的修改：
```
@@ -50,7 +51,7 @@ public class ...ConfigService {
```
显示了
```
prepareConfig(config);
```
→
```
saveConfig(config);
```
→
```
saveOperatorLog(config, "新增配置");
```
→
```
- asyncConfig();
```
→
```
+ asyncConfig(config);
```
→
```
return true;
```
→
```
}
```




8.4 Workflow & Skills 自定义


[图片: 图片]

天弦平台还支持用户
自定义 workflow
：

新建任务
任务列表、新建任务、新建 Workflow、workflow 管理


WORKFLOW 需求
自定义流程执行


Section 01 需求描述
workflow-dev 处理的需求


Section 02 任务创建模式
通过名称引入 workflow（搜索已有 workflow）/ 手动添加 workflow（用子流程文本级文件，直接补齐任务参数）


公共 Skills 列表
（截图里展示的）：


cm/backend_dev


flight/auto_coding


flight/code-quality-subagent


flight/implementer-subagent


flight/spec-reviewer-subagent


flight/tdd


tcdev/automate-skill


tcdev/doc-gap-checker


tcdev/mod_doc


tcdev/noah_deploy


tcdev/observability


tcdev/skill-creator


tcdev/watcher_alert


cm/spec_generator


flight/auto_cpu_profiler


flight/code-standards


flight/solution-generator


flight/task-splitter


flight/tech-solution-executor


tcdev/code_reviewer


tcdev/java_coding_guideline


tcdev/noah_auto_debug


tcdev/noah_log


tcdev/qconfig


tcdev/skills_guide


自定义 Skills
添加自定义 Skill


Skills 市场的存在，意味着"个人经验"可以变成"组织资产"
。任何一个工程师沉淀的好 Skills，都可以发布到市场，让全公司复用——这才是 AI Coding 的"飞轮效应"。




8.5 天弦的系统设计——为什么它不是"另一个 CI/CD 平台"


[图片: 图片]

天弦的系统设计给我最大的启发是：
它把"传统研发流程"和"AI 自动化流程"并排放出来，让你看到 AI 把哪些步骤压缩了
。

传统研发流程（人工）
——11 步、总耗时
数小时~数天
：

1. 产品提需求文档

2. RDQA 方案 & 评审

3. 技术方案拆解细化

4. 手动编码实现

5. 本地编译调试

6. git 提交 & push

7. 部署测试环境

8. 等待部署 & 查看结果

9. 部署失败 → 人工查日志 → 修复

10. 执行测试 / Code Review

11. 人工整理结果与交付物

人工流程痛点
：

- 等待多

- 切换多

- 重复排错多

- 上下文丢失

平台自动化流程（AI Agent）
——11 步、总耗时
分钟~小时级
：

1. 技术需求输入

2. AI Agent 自动编码

3. 自动编译，错误时修复

4. 自动 git commit & push

5. 自动调用部署 API

6. 自动轮询部署状态

7. 部署失败 → AI 查日志 → 自动修复 → 重试

8. 自动化测试

9. 自动生成 diff + 执行报告

10. 人工只做关键 Review 与验收

11. 交付可部署上线的代码产物

自动化关键能力
：

- 任务输入

- Agent 执行

- Skills 调用

- 报告输出

天弦平台核心能力
：

- 任务编排：把需求理解、编码、编译、部署、测试、报告串成可执行 workflow

- AI Coding Agent：支持 Claude Code / Codex 等 Agent 自动执行研发任务

- 基础 Skills：连接部署、日志、配置、状态检测、测试验证等研发基础能力

- 自修复闭环：编译失败、部署失败、测试失败后自动分析原因并重试

- 交付报告：自动输出 diff、执行过程、失败原因、修复动作与最终结果

右侧架构图
：

-
接入层
：Dashboard、飞书、API

-
调度层
：任务分发、策略管控、生命周期管理

-
运行实例层
：

-
编排 workflow
：需求理解 → 计划任务 → 代码改动 → 规范检查 → 代码提交 → 编译运行 → 测试验证 → 结果输出 -

AI Coding Agent 执行引擎
：Claude Code、Codex

-
基础能力 skills
：Noah 部署、启动状态检测、日志分析、配置获取、灰度执行 -

编译环境
：代码仓库、环境配置、编译工具链

-
任务输入
：需求任务、任务扩展 skills

这一页是整场分享里"信息密度最高"的一页
。它用一张图说清楚了：

AI Coding 不是"取代"传统研发流程，而是"重写"它
——11 步流程在 AI 介入后，总耗时从"数小时到数天"压缩到"分钟到小时级"，同时
保留了人工 Review 节点
；


AI Coding 的核心能力是"自修复闭环"
——遇到编译失败、部署失败、测试失败时，AI 能自己查日志、分析原因、修复重试，这是 L3 自动化的关键能力；


Skills 体系是 AI Coding 的"操作系统"
——没有 Skills，AI 就只能写代码；有了 Skills，AI 才能真正完成"从需求到交付"的端到端工作流。



09


Qsuperpowers——让 AI 啃下"3pd 复杂业务需求"


进入分享中
最有冲击力
的部分：
如何用 AI Coding 处理复杂业务需求
。

[图片: 图片]

李佳奇先抛出了一个非常现实的问题：

"通用 superpowers 提供流程标准化能力，但不包含企业个性化需求、内部系统集成、工程规范落地。所以我们需要 Qsuperpowers。"


Qsuperpowers 是什么？
它是一个"工程搭档"框架，区别于通用 AI 的"助手"角色：

核心概念

助手：AI 工程流程纪律


搭档：减少偏差、瞎猜、无验证，非随意发挥


SUPERPOWERS FLOW

BRAINSTORM
明确需求（目标/约束/验收）


PLAN
小规格说明（文件模块清单、每步做什么、如何验证成功、关键！）


IMPLEMENT
严格执行 PLAN，小范围验证


REVIEW + VERIFY
自查代码，跑测试，验证证据（日志/构建）


SHIP
交付任务，有规律的结果


实操建议

强制验证方案（Plan 必写）


统一验证模板（格式/单测/集成/场景）


固化小 SPEC（输入/输出/边界/Checklist）


这一页用漫画风格画出来，恰恰说明"AI Coding 落地复杂需求的本质是流程纪律"
。在通用 superpowers（社区版）上跑得好，不代表在你的企业里能跑好——因为企业内部有飞书文档、Noah 部署、灰霸测试、Idea MCP / AST 等特有工具链，AI 必须被"嫁接"到这些工具链上才能产生业务价值。




9.1 Qsuperpowers 核心介绍


[图片: 图片]

Complex Business Requirement AI Development · Qsuperpowers
：

面向
2pd+ 复杂需求
：把需求澄清、任务拆解、AI 编码、部署测试和质量验证收敛为企业级全流程 AI Coding 框架


关键数据：
典型复杂需求 3pd、AI 实际耗时 1pd、案例提效 66%


Qsuperpowers 定制化设计
：

为什么不是通用 superpowers
——通用 superpowers 提供流程标准化能力，但不包含企业个性化需求、内部系统集成、工程规范落地。


与 auto-coding 深度整合
——承接一句话需求自动编程的企业适配能力，并把复杂需求的 AI task 生成、编码、部署、测试串成闭环。


企业工具链接入
——集成飞书文档、Noah 部署、灰霸测试、Idea MCP / AST 访问能力，让 AI 能按公司流程使用公司工具。


场景 SOP 内置
——内置需求澄清模板、任务拆解、灰霸 Diff 分析流程等 SOP，降低复杂需求 AI Coding 的使用门槛。


解决复杂需求核心问题
——复杂需求 AI Coding 的关键是任务结构化能力；AI Task 越清晰，AI Coding 上限越高。


全流程 AI Coding 闭环
：

AI Task Generation
（brainstorming + writing-plans）：自动解析飞书需求文档，提取业务信息，完成需求澄清、需求拆解和技术方案生成。


AI Coding
（subagent + executing-plans）：依托 AI Task 指导 Claude Code / Codex 自动编写代码，结合 AST / IDE 上下文提升代码质量。


AI Deployment
（Noah CI/CD）：自动编译校验、打包部署、采集部署日志并定位异常，闭环反馈至代码修复。


AI Testing
（automate TDD）：接入灰霸测试模块，自动分析 case 结果，对比需求与测试结果，识别漏测与偏差。


典型案例：复杂需求落地
——FD-396503：最低价逻辑优化·政策管理页面增加配置

人工估时：3pd


AI 实际：1pd


结果：无 bug 上线


提效：66%


5 步实施：

1.
需求文档 → AI Task
：通过飞书文档集成解析需求，生成头脑风暴与实施计划，形成可执行 AI Task。

2.
自动编程启动
：Claude Code 通过插件安装，Codex 通过自然语言加载安装指令，进入自动编程流程。

3.
AI 编码与代码改动
：AI 根据实施计划改动业务代码，结合代码上下文和 AST 访问能力完成复杂逻辑实现。

4.
部署成功
：自动编译部署，部署异常可回流至编码环节，形成自动修复闭环。

5.
灰霸测试通过
：等待并分析灰霸测试结果，最终验证业务诉求全部实现，无 bug 上线。

案例证明了什么
：

-
流程闭环
——需求梳理、编码、编译部署、测试验证不再割裂，形成端到端 AI Coding 闭环。

-
任务结构化
——飞书需求文档转 AI Task，把复杂需求变成 AI 可理解、可执行的任务单元。

-
工具协同
——Noah、灰霸、Idea MCP 等工具被纳入 AI 执行上下文，减少信息损耗。

-
质量保障
——通过部署日志分析、测试结果比对和 SOP 标准化，提升 AI 代码交付性。



9.2 Qsuperpowers 闭环流程


[图片: 图片]

四个核心环节的循环：

ai-task-generation
需求文档 → 技术文档 → AI-task


ai-coding
获取 AI-task → 识别约束 → 自动编写


ai-deployment
自动提交 → 自动编译 → 自动部署


ai-testing
自动测试 → 自动分析 → 自动修复


中心是 auto-coding 全流程闭环



9.3 Qsuperpowers 执行过程


[图片: 图片]

四个阶段的详细任务：

ai-task-generation
brainstorming（需求澄清）


writing-plans（任务拆解）

ai-coding


subagent-driven-development（子代理开发）


executing-plans（计划执行）


ai-deployment

test-driven-development（测试驱动）


requesting-code-review（双轮审查）


ai-testing

finishing-a-development-branch（交付闭环）




9.4 Qsuperpowers 的四大定制化方向





[图片: 图片]


飞书文档集成：降低信息损耗率

语法树 AST 集成：提高理解准确率

CI/CD 集成：提升交付效率

灭霸集成：保障交付可靠性

这四个集成点，恰好对应了"AI Coding 落地复杂业务需求的四大拦路虎"
： -
信息损耗
——需求从产品到 AI 手上要"过五关斩六将"（飞书 → 文档解析 → AI 理解），每一步都可能丢信息；

-
理解偏差
——AI 读不懂代码上下文，AST 集成让 AI 拥有"程序员的眼睛"；

-
交付效率
——AI 写完代码后还要手动部署、测试、回滚，CI/CD 集成让 AI 完成最后一公里；

-
质量保障
——AI 写的代码怎么测？灰霸集成让 AI 拥有"测试员的能力"。




9.5 Qsuperpowers 使用案例：复杂业务配置改造（脱敏版）


[图片: 图片]

Qsuperpowers · 复杂业务配置改造真实案例（脱敏版）

人工估时 3pd，AI 实际耗时 1pd，效率提升 66%


保留真实工程复杂度与执行链路，脱敏需求号、业务域、项目名、包路径、Git 地址、人员与内部系统标识


案例背景与脱敏需求
：

需求类型
——某业务"最低价逻辑优化"：在后台配置页面新增布尔配置字段，启用后过滤报价。


真实复杂度保留
——需求涉及 3 个系统协作：配置 UI、策略数据模型、搜索报价计算逻辑。需要同时完成字段存储、导入模板、API 参数、缓存编码、核心计算逻辑和校验器改造。


Qsuperpowers 介入点
——先把需求文档转为 AI Task 和实施计划，再由 AI 依据分任务执行编码、编译、部署和测试验证，形成复杂需求端到端闭环。


脱敏字段映射
——真实字段 useMinPrintPrice 脱敏展示为 useFloorPriceOutput；真实项目名、包路径、本地路径统一替换为 project-policy / project-search / project-admin。


交付结果
——AI 生成实施计划，覆盖 8 个任务、多个项目、多个文件类型；最终完成代码改造、部署验证和自动化测试，业务诉求全部实现。


从需求文档到代码交付的执行闭环
：

需求解析
（AI Task）：读取需求文档，识别"新增配置字段 + 改变报价过滤逻辑 + 支持导入/导出 API"的核心目标。


任务拆解
（Plan）：按项目拆成数据模型、搜索逻辑、配置 UI、导入模板、API 支持、Setter 与 Validator 等任务。


跨项目编码
（Coding）：在策略模型中新增字段，在搜索侧缓存 boolean bit，在计算器中增加低价报出分支。


入口能力补齐
（Integration）：配置导入字段、Excel 模板、API 可选参数、Setter 与 Validator，保证运营侧可配置。


编译部署
（Deploy）：按依赖顺序编译部署：先数据模型，再搜索计算，最后配置 UI，避免跨项目依赖失配。


验证闭环
（Test）：验证模板字段、API 参数、报价逻辑、编译通过与自动化测试结果，最终形成无 bug 上线结论。


脱敏后的实施计划证据
（伪代码风格）：

```
goal: 新增 userFloorPriceOutput 布尔配置behavior: 修改报价过滤逻辑projects: [project-policy, project-search, project-admin]tech_stack: Java 17+, Spring, Lombokexecution: qsuperpowers: executing-plans / subagent-driven-development// 所有真实需求号、项目名、包路径、Git 地址已脱敏
```

实施计划的 5 个具体验证项
：

- 数据模型字段：在策略扩展对象中新增布尔字段、getter/setter、equals/hashCode。

- 缓存编码支持：扩展 boolean bit 数组，增加新配置读取方法，保证搜索侧可消费。

- 核心报价逻辑：在最低逻辑面价限制分支中新增"启用配置则按最低面价报出"的逻辑。

- 配置与导入支持：新增页面字段映射、Excel 模板字段、API 可选参数、Setter 和 Validator。

- 验证清单：覆盖三项目编译、模板字段、API 参数、报价逻辑和自动化测试结果。

可以对外展示的真实结论
：

-
复杂需求可结构化
——AI 将 3pd 需求拆成跨项目、可执行、可验证的任务计划。

-
企业链路可闭环
——从需求文档、编码、部署到测试验证，均进入 Qsuperpowers 标准流程。

-
工程真实性保留
——保留字段、项目协作、依赖顺序、验证清单等真实工程复杂度。

-
敏感信息已脱敏
——需求号、项目名、业务域、包路径、Git 地址、人员、本地路径全部替换。

这一页让我非常激动
。它展示了一个
3pd 的真实复杂业务需求
（涉及 3 个系统、8 个任务、多种文件类型），
AI 实际只用了 1pd 就完成了，且无 bug 上线
。

这不是"AI 写个 Hello World"的玩具 demo，而是
真实的、跨项目的、需要理解业务上下文、还需要保证质量的复杂需求
。而且它给出了完整的脱敏实施计划，让读者可以学习如何把自己的需求结构化。

这是 L3 自动化真正落地的样子
：AI 不是"辅助"工程师，而是"主导"一个 3pd 复杂需求，工程师只做关键节点审查和验收。


10


AI Coding Skills 沉淀与治理——从"个人经验"到"组织资产"


[图片: 图片]

PART 03 最后的部分，主题是
AI Coding Skills 沉淀
。这是把"个人 AI 经验"变成"组织 AI 资产"的关键一步。

AI Coding Skills 体系整理
：

公司沉淀的 skills 已从"单点工具"演化为覆盖需求、编码、部署、日志、数据、测试、质量与观测的 AI 研发能力栈


关键数据：
50 个 Skills、4 个 Domain、2 个主干能力


能力分层地图
：

通用研发能力层
覆盖需求调研、代码调研、技术方案、后端开发、规格生成、代码质量、Sonar、Langfuse 观测等基础研发活动。


product-research、code-research、tech-design、backend_dev、local-sonar


业务域开发层
按不同业务域沉淀专属技能包，包括 Flight、TCDev、FE 等，包含代码规范、任务拆解、方案执行、TDD、CR、性能分析等。


flight/auto_coding、fe_auto_coding、tcdev/code_reviewer、task-splitter、tdd


企业工具链接入层
将公司内部系统封装成 AI 可调用工具，解决 AI coding 从本地代码走向真实研发环境的"最后一公里"。


Noah、QConfig、QSchedule、灭霸、飞书、Redis/MySQL


Agent 角色与治理层
通过 arch、backend-dev、bugfix-dev、test-dev、publish-check、spec-gen 等 agent 角色，沉淀分工、审查和发布门禁。


arch、backend-dev、bugfix-dev、test-dev、publish-check


重点一：Auto Dev / Auto Coding 编排中枢

从"一次编码"升级为"端到端开发循环"——auto_dev 是纯编排型 skill：不替代编码，而是治理 AI 何时读取文档、何时部署、何时看日志、何时执行 E2E，直到目标或验收标准达成。

cm/auto_dev：证据驱动的端到端编排
——核心规则是"不要按固定流程硬走"，而是根据最新证据决定下一步：继续读代码、读飞书、部署 Noah、查日志、改配置、跑 E2E 或再次修改代码。


tcdev/auto-dev：平台化自动开发任务
——通过 Skills Gateway 提交自动开发任务，参数包括 appCode、deployEnv、requirement、agent、model 等；适合目标明确的小型需求自动执行。


flight/auto_coding：业务域自动编程入口
——以"开启自动编程"为入口，动态拉取企业侧 skill 内容，支持 Normal / Help / Yolo 模式，承担业务域定制化研发规范。


编排价值
——把需求、代码、部署、日志、配置、数据、测试和 CR 串联起来，让 AI coding 不停在"代码改完"，而是走到"验证通过"。


重点二：Noah 能力族·真实环境执行底座

noah_deploy_auto_dev
从当前仓库或显示参数解析 appCode、envCode、branch、userId，触发 Noah beta 部署并查询任务状态。


auto_dev_noah_log / noah_log
列出和下载 Noah beta 机器日志，可自动识别 appCode / envCode，并通过 CMAPI 解析真实机器。


e2e_noah_test
解析 Noah 端名，复用项目 E2E 资产，通过 Playwright / requests 执行部署后页面验证。


noah_auto_debug
结合部署、监控、日志下载、错误分析和修复报告，形成部署失败或启动异常的自动调试工作流。


noah-mysql / noah-redis
从 Noah beta 环境变量解析 MySQL / Redis 连接信息，支持连通性检查和受控查询/操作。


noah-hotswap
对运行中的 Java 进程做单文件类批热部署，适合快速验证小改动，降低完整部署等待成本。


Noah + QConfig + QSchedule
围绕 beta 环境建立配置修改、定时任务、部署验证、日志排错的完整操作闭环。


Noah 的定位
——它不是单个部署 skill，而是 AI coding 进入真实运行环境、获得反馈、继续自修复的关键执行面。


端到端 AI Coding 生命周期
：

- 需求输入（飞书 / 文档 / 需求澄清 / 规格生成）→ 方案拆解（技术方案 / task split / agent 分工）→ 编码实现（auto coding / backend / FE / TDD）→ 部署验证（Noah deploy / hotswap / beta E2E）→ 环境操作（QConfig / MySQL / Redis / QSchedule）→ 质量测试（灭霸 / Sonar / CR / code standards）→ 观测闭环（日志 / alert / observability / Langfuse）

这一页的关键洞察是：Skills 体系不是"工具集合"，而是"组织记忆"
。

当一个工程师发现"用 tdd 方式拆解需求、配合 auto_dev 编排、再用 noah_deploy_auto_dev 部署、最后用 noah_auto_debug 排查问题"是最高效的 AI Coding 工作流时，他应该把这个"工作流"沉淀成 Skills，让其他工程师也能复用。

这正是 AI Coding 时代"组织能力建设"的核心：
把个人摸索的最佳实践变成全团队可复用的资产
。




10.1 Skills 市场：让组织资产可被检索


[图片: 图片]

QDO · 天弦 Skill 市场
：

左侧菜单：一句话需求、异常修复、workflow 需求、线上诊断、JDK 升级、新建场景、任务看板、Skill 市场、平台设置


搜索 Skill 框 + 全部 / 开发 / 运维 / 测试 Tab


Skill 卡片示例：


atomic-dev
—— 基于需求描述自动生成代码变更的开发助手，支持复杂多文件联动修改


标签：全局、代码生成、需求开发、Java


共享方：platform-team


下载量：128


版本：v2.1.0


分类：development


exception-fix
—— 自动分析异常堆栈，定位根因，生成修复代码并验证


标签：全局、异常处理、自动修复、稳定性


共享方：platform-team


下载量：95


版本：v1.3.2


分类：operations


online-diagnosis
—— 结合监控指标和日志，诊断线上问题（部分可见）


Skill 详情侧边栏
：

- 作者

- 版本：2.1.0

- GitLab 地址

- 共享范围：全局

- 分类：development

- 参数列表：

- repo：代码仓库（string，必填，默认值 -）

- branch：目标分支（string，必填，默认值 main）

- autoCommit：自动提交（boolean，非必填，默认值 false）

Skills 市场的精妙之处在于：它把"AI Coding 能力"做成了"可发现、可评估、可复用"的资产
。

任何工程师都可以在市场里搜索"代码生成""异常处理"等关键词，找到最适合自己场景的 Skill；同时通过下载量、版本号、共享范围等元信息，快速判断 Skill 的成熟度。

这就像 App Store 之于移动应用——把 AI Coding 能力"产品化"
。




10.2 Skills 的全流程管理


[图片: 图片]

Skills 的全流程管理
：把 skills 从"零散沉淀"升级为"有仓库、有审核、有网关、有上下文感知能力"的统一治理体系

Standard Repo、PR Review、Skills Gateway、Seed Context

Skills 资产沉淀与流转
：

A. 标准 Skills Git 仓库
（official）—— 作为全公司通用高价值 skills 的标准沉淀仓，保证可复用、可审计、可统一分发。


T. 各技术团队私有仓库
（private）—— 每个技术团队可以根据业务域和技术栈维护自己的私有 skills，先在团队内快速验证价值。


PR. 验证后提交标准仓库
（submit）—— 团队将验证过的高价值 skills 提交到标准仓库并发起 PR，让局部经验沉淀为全局能力。


∞. 形成持续演进闭环
（loop）—— 标准仓库吸纳优秀实践，私有仓库持续创新，最终形成"创新在线，标准化在平台"的循环。


Governance Workflow 基础研发团队负责审核、合并与统一治理
：

团队私有验证
——业务团队先在私有仓库内验证 skills 的稳定性、效果和适用边界。


提交 PR
——将已验证的高价值 skills 向标准仓库发起 PR，进入统一治理流程。


基础研发团队审核
——审核技能边界、安全性、通用性、命名规范、依赖关系与复用价值。


合并与统一分发
——合并后通过统一 Skills Gateway 管理下发、执行、观测和后续版本演进。


统一 Skills Gateway 与"种子上下文"
：

Skills Gateway：统一收口下发与执行
——不只是分发入口，更是统一执行、治理和观测平面


统一下发：对各类 skills 进行统一分发和版本管理。


统一执行：对 skills 的调用入口、参数、依赖与执行行为统一治理。


统一观测：记录 skills 被谁、在什么场景、以什么效果使用。


统一分析：沉淀 usage、成功率、复用率、失效点和高价值技能画像。


种子上下文
——在技能执行前注入任务背景、目标、历史进展、当前阶段、上下游依赖等上下文，减少 skills "只看当前输入"的盲区。


感知与分析能力
——通过网关感知任务背景、任务进展、任务完成度和技能使用轨迹，为后续 insight、优化和自动编排提供基础。


全流程管理带来的价值
：

创新与标准化并存
——一线团队继续快速创新，基础研发团队负责沉淀组织共性能力。


高价值 skills 可复用
——经过验证的高价值 skills 不再只留在局部团队，而能服务更多团队。


执行过程可观测
——通过 Gateway 统一记录 skills 调用与任务过程，为优化提供数据依据。


任务感知能力增强
——借助种子上下文，skills 能更好感知任务背景、进度和完成度，提升自动化质量。


这一页把"Skills 治理"提升到了"组织能力建设"的高度
。它明确告诉所有技术管理者：

Skills 不能再"野蛮生长"
——必须经过私有验证 → PR 提交 → 基础研发团队审核 → 合并 → 统一分发 → 全流程观测的完整闭环；


Skills Gateway 是 AI Coding 的"流量网关"
——所有 skills 调用必须经过它，才能被统一治理、观测、分析；


"种子上下文"是 Skills 智能化的关键
——没有上下文的 skills 是"死"的；有上下文的 skills 才能真正融入业务流程。


这是一个非常成熟的企业级 AI 治理方案
。它让我想起了微服务治理里的 Service Mesh——所有流量都过 Sidecar，所有调用都可观测，所有变更都可回滚。Skills 治理，也应该走同样的路。


11


成果——100% 覆盖、75% 出码、3000+ 任务、90%+ 测试通过


进入 PART 04：
Qunar AI Coding 当前成果
。

[图片: 图片]



11.1 四个关键指标


研发团队人员覆盖：100%
——覆盖前端、后端、QA、以及部分产品角色。


全司出码率：75%+
——AI 产出代码已成为研发交付中的主流组成部分。


L3 自动化水平占比：30%+
——高自动化任务占比持续提升，AI 开始端到端推进交付。


天弦自动化任务：3000+
——平台化自动化任务已形成规模化运行。




11.2 覆盖规模：从研发到协作角色


FE 前端研发
（covered）—— 页面开发、组件改造、联调支持、前端自动化任务。


BE 后端研发
（covered）—— 业务逻辑、接口开发、代码修复、性能优化与部署验证。


QA 测试
（covered）—— 测试用例、回归验证、自动化测试、质量分析。


PM 部分产品角色
（covered）—— 需求表达、验收标准、任务拆解和 AI 协伴输入。




11.3 自动化水平：从 L1/L2 走向 L3


整体 L3 占比 30%+
——L3 代表 AI 能端到端推进编码、验证和交付准备，人工主要做关键审查。


1-2pd 规模需求 L3 占比 80%+
——中小型需求已经成为 AI 高自动化交付的优势场景。


全司出码率 75%+
——AI 代码贡献已从个人尝试变成组织级稳定产出。




11.4 天弦平台：自动化任务规模化


自动化任务总量 3000+
——覆盖自动开发、自动修复、自动测试、自动部署、JDK 升级等多类任务。


测试通过率 90%+
——平台任务稳定性进入可规模化使用阶段。


成果含义
——AI Coding 不再只是代码生成工具，而是进入
数据可度量、流程可编排、结果可验证
的工程化阶段。


这些数字是惊人的
。但更让我关注的是它们的
组合
——

100% 覆盖
说明 AI Coding 已经不是"先锋队"的专利，而是全员基础设施；


75% 出码率
说明 AI 已经深度参与代码生产；


30% L3 占比
说明每 10 个需求中就有 3 个能让 AI 端到端完成；


3000+ 自动化任务
说明已经走过了"试点"阶段，进入"规模化"阶段；


90%+ 测试通过率
说明 AI Coding 的"质量底线"是稳的。


当这五个数字同时出现时，意味着"AI Coding 落地"已经不是一个实验，而是一个工程成果
。




11.5 AI Coding 黑客松：150 人 1 天 3 个真实复杂需求 90%+ 出码率


[图片: 图片]

AI Coding Infra & Team Capability Large-scale Validation
：

通过 AI Coding 黑客松完成一次真实复杂业务需求的组织级极限压测，验证基建、skills、平台和团队协作能力


关键数据：
150 人、1 天、3 个真实复杂需求、90%+ 完赛出码率


极限测试场景
：

AI Coding 黑客松
—— 不是演示 Demo，而是在真实复杂业务需求中验证"组织能否规模化使用 AI 完成交付"。


技术团队规模 150
——多人、多队伍同时参赛，验证培训、工具、平台和协作体系能否支撑规模化使用。

真实复杂需求 3
——跨业务、全部署需求，覆盖客户端、网页端、后端三类工程形态。

交付周期 1 天
——在一天内完成需求理解、方案拆解、编码实现、测试验证和结果提交。

完赛出码率 90%+
——整体完赛队伍达到高强度 AI 代码贡献，证明工具链具备规模化产出能力。

验证对象：不是工具，而是体系能力
：

AI Coding 基建可用性
——验证 Claude Code、Codex、Cursor、QunarDevCenter、数据采集、模型代理。


Skills 与自动化流程有效性
——验证 auto_coder、Noah、测试、日志、部署、回归等 skills 能否帮助团队真。


团队 AI 协作成熟度
——验证团队能否把需求拆给 AI、管理上下文、审查 AI 输出、处理失败反馈，并。


度量体系有效性
——通过出码率、自动化水平、完赛结果、代码质量和人工介入情况，反向验证 AI。


挑战设计：真实、跨端、高压
：

覆盖多端工程形态
——客户端、网页端、后端同时覆盖，验证 AI Coding 不是单一技术栈试点，而是跨工程体系能力。


全新真实业务需求
——需求不是历史重放或样例练习，而是需要理解业务、拆解方案、编写代码并完成验证的真实复杂需求。


1 天极限交付窗口
——在时间强约束下压测 AI 对需求澄清、代码实现、调试修复、测试验证和团队协作的实际放大效果。


验证结果：出现 L3 级自动化队伍
：

头部队伍达到 L3 自动化水平
——头部队伍能够让 AI 端到端推进需求实现：从任务拆解、代码生成、测试修复到测试验证，人工主要承担方向控制、关键 Review 和最终验收。


整体完赛队伍出码率 90%+
——高出地率说明 AI 在真实复杂需求中已经"辅助补全"进入"主要产出"阶段。


跨业务需求一天内完善
——说明基建、skills、平台和团队操作方法已经具备短周期高强度作战能力。


这次黑客松证明了什么
：

基建可规模化
——150 人规模真实使用，验证工具链和采集链路能支撑组织级落地。


方法可复制
——跨端、跨业务、跨队伍完成，说明 AI Coding 不依赖单个高手。


高自动化可达成
——头部队伍达到 L3，证明复杂需求中存在端到端自动化交付空间。


数据可验证
——通过出码率与自动化水平指标，把主观比赛结果变成可度量洞察。


看到这一页，我笑了
——这不是一场黑客松，这是一场
对 AI Coding 体系的"压力测试"
。

150 人、1 天、3 个真实复杂需求、90%+ 出码率——这些数字背后是
整个 AI Coding 体系的协作能力
： - 工具链能不能支撑 150 人同时用？（QunarDevCenter 扛住了） - Skills 库够不够丰富？（atomic-dev / exception-fix / auto_dev / noah_deploy_auto_dev / noah_auto_debug 等都派上用场） - 平台能不能稳定运行？（天弦扛住了 3000+ 任务） - 团队会不会用 AI？（150 人都能上手） - 数据体系能不能实时采集？（QunarDevCenter 上报链路扛住了）

如果你的 AI Coding 体系能扛住这种极限压测，那才是真的"组织能力"
。否则只是"几个先锋队的个人秀"。


12


总结与展望——AI Coding 的上限，取决于你为它重写了多少


最后是李佳奇的总结页。
这是整场分享的"思想高潮"
。

[图片: 图片]



12.1 核心观点


这次落地的核心不是"用了 AI 写代码"，而是建立了一套可度量、可编排、可验证、可规模化的 AI 研发体系。




12.2 四个核心论点


1. 先把研发过程数字化
——没有数据，就没有 AI 研发管理 - 全流程数字化是 AI Coding 数据体系的底座，覆盖任务、测试、发布、监控和本地 AI session。 - 通过 QunarDevCenter 采集 Claude Code、Codex、Cursor 等多端数据，形成可分析的 session 资产。

2. 既看量，也看质
——出码率只是起点

-
量
：出码率、出码量、团队覆盖率、需求覆盖率，回答"AI 写了多少"。

-
质
：Coding 自动化水平、Harness 等级，回答"AI 到底独立完成了多少"。

3. 用平台把能力工程化
——天弦是自动化承载层

- 天弦把需求输入、Agent 编码、编译、部署、日志、测试、Diff 和报告串成可执行 workflow。

- Noah、auto_coder、性能优化等 skills，让 AI 能进入真实研发环境并形成自修复闭环。

4. 复杂需求靠结构化任务突破
——AI Task 决定上限 - Qsuperpowers 将需求澄清、任务拆解、编码、部署、测试整合为企业定制化流程。 - 复杂业务案例 3pd → 1pd、提效 66%、无 bug 上线，说明复杂需求也可以 AI 化交付。



12.3 Core Message（核心信息）


AI Coding 的上限，取决于研发系统是否为 AI 重新设计。


单点工具只能提升个人效率；真正的组织级 AI Coding，需要把
数据采集、skills、平台编排、质量门禁、自动化验证、团队方法论
放在一起建设。


关键数据：


100% 研发团队人员覆盖

75%+ 全司出码率

3000+ 天弦自动化任务

90%+ 完赛队伍出码率

从 JDK 自动升级、Qsuperpowers 复杂需求开发，到 150 人黑客松极限验证，已经证明：AI Coding 可以从"个人工具"走向"组织级交付能力"。




12.4 下一阶段重点


深化 L3 场景
——优先放大 1-2pd 需求、升级类任务、修复类任务和自动测试类任务。


沉淀 Skills 资产
——持续把高频研发动作沉淀为标准 skills，并纳入安全准入和统一分发。


强化质量门禁
——把测试、Review、回归、发布验证作为 AI 自动交付的必要闭环。


从效率到能力升级
——目标不是替代开发者，而是让团队具备更高杠杆的 AI Native 研发能力。

[图片: 图片]






12.5 实现研发效率和业务价值


真正体现 AI 研发价值
——AI Coding 的价值不能只看"写代码更快"，而要同时证明研发效率提升与业务价值更早兑现

研发效率视角：核心是"双估时"
——保留原始估时 + 增加 AI 结合估时


原始估时：不用 AI 时，人工完成需求需要的 pd，作为复杂基线、AI 价值衡量基线和历史可比口径。


AI 结合估时：结合 AI 后完成需求预计需要的 pd，用于实际排期，体现工作压缩和装载能力提升。


核心原则：原始估时用于衡量价值；AI 结合估时用于指导排期。AI 的价值要进入计划阶段，而不是只做事后复盘。


AI 估时压缩率
= (原始估时 - AI 结合估时) / 原始估时


AI 估时兑现率
= (原始估时 - 实际工时) / (原始估时 - AI 结合估时)


AI 输出效率
= 周期内人均完成需求的原始估时总和 / 周期工作目数


Measurement Loop 让 AI 进入研发计划、资源安排和交付管理体系
：


保留原始估时：作为需求复杂度基线，衡量 AI 价值。


增加 AI 结合估时：让 AI 效率收益进入计划阶段。


按 AI 结合估时排期：团队装载能力体现在迭代计划中。


采集实际开发工时：用真实耗时校验提效是否兑现。


复盘效率和价值：形成可比较、可管理、可持续优化的闭环。


关键变化：AI 不再只是编码辅助工具，而是进入研发管理体系。


业务价值视角：看三类价值
：


风险规避价值：提前发现需求缺陷、逻辑漏洞、合规风险、性能风险和资质风险，提前规避业务损失。


方案优化价值：优化业务运营方案、收益方案、用户体验方案和低成本实现方案，让方案本身更优。


收益加速价值：让重点项目更快上线、更早反馈、更早获得收益，也更早发现问题并补救。


完整衡量逻辑
：


单需求工作量下降：通过原始估时、AI 估时、实际工时验证真实提效。


同周期排入更多需求：通过 AI 排期饱和度观察团队装载能力提升。


单位时间产出提升：通过 AI 输出效率衡量组织级研发吞吐变化。


业务价值更早兑现：通过风险规避、方案优化、收益加速连接业务结果。


这是"AI Coding 价值衡量"的终极答案
：不是"出码率"、不是"提效倍数"，而是
"AI Coding 是否进入了研发管理体系"。


这一页是整场分享的"压轴之作"
。

它提出了一个让所有 AI Coding 团队都该反思的问题：
你的 AI Coding 进入了"计划阶段"吗？

很多团队的 AI Coding 还停留在"事后复盘"——做完一个需求后说"这次 AI 帮我们省了 2pd"。但李佳奇认为这种衡量方式
不够
，因为它
没有进入计划阶段
。真正成熟的 AI Coding，应该是：

做需求时就要估算"不用 AI 需要多久"和"用 AI 需要多久"
——形成"双估时"机制；


把"AI 结合估时"纳入排期
——让团队知道"AI 能让我们多接多少需求"；


采集实际工时，反向校验"AI 估时的兑现率"
——让"提效"从口号变成数据；


把 AI 价值分三类（风险规避 / 方案优化 / 收益加速）
——让 AI Coding 与业务价值挂钩。



13


我读完这份分享后的 5 个核心启发


最后，作为这篇深度解读的作者，我也想分享我读完这份分享后的 5 个核心启发——这些启发可能对正在搞 AI Coding 的团队更有价值。



启发 1：AI Coding 不是"工具问题"，是"研发范式问题"


李佳奇反复强调：
"这次落地的核心不是用了 AI 写代码，而是建立了一套可度量、可编排、可验证、可规模化的 AI 研发体系。"

这意味着： - 如果你的团队还在为"Cursor vs Claude Code vs Codex"哪个更好而争论，那你已经输了——它们都会被淘汰，关键是
谁能用好它们
。 - 如果你的团队还在为"出码率从 30% 涨到 60%"而欢呼，那你也要警惕——
没有 Harness 的高出码率是定时炸弹
。 - 如果你的团队还没有把 AI Coding 纳入"研发管理体系"（计划、排期、度量、复盘），那你还在"AI Coding 1.0 阶段"。



启发 2：Harness 才是决定 AI Coding 上限的真正瓶颈


这是我整场分享
最大的收获
。

我们花太多时间讨论"哪个模型更强"、"哪个 IDE 更好用"，却很少讨论
如何"约束"AI Coding
。但李佳奇告诉我们：

Harness = AI 研发过程控制能力。决定上限的不是模型，是 Harness。


具体来说，就是"AI 触发机制 + 约束与门禁 + 安全隔离环境 + 人工审查节点"组成的四把锁。没有这四把锁，AI Coding 越强越危险。



启发 3：把"个人 AI 经验"变成"组织 AI 资产"的关键是 Skills 治理


很多团队有个误区：觉得"AI Coding 经验"是个人技能，无法被组织化。

但李佳奇和他的团队告诉我们：
AI Coding 经验完全可以被组织化
，方法是
Skills 沉淀与治理
：

私有仓库验证
——让一线团队先在私有仓库里试；


PR 提交标准仓库
——把验证过的高价值 Skills 提 PR；


基础研发团队审核
——统一审核 Skill 边界、安全性、通用性；


合并与统一分发
——通过 Skills Gateway 统一下发；


种子上下文注入
——让 Skill 在执行时拿到任务背景；


全流程观测
——记录 Skill 调用情况，反向优化。


这就是 AI Coding 时代的"组织能力建设"——把个人摸索的最佳实践变成全团队可复用的资产
。



启发 4：AI Coding 的价值衡量必须进入"计划阶段"


最后这一启发，我觉得对所有 AI Coding 团队都至关重要。

李佳奇提出的"双估时"机制让我眼前一亮：

原始估时
=不用 AI 时，人工完成需求需要的 pd


AI 结合估时
= 用 AI 后，预计需要的 pd


AI 估时压缩率
= (原始估时 - AI 结合估时) / 原始估时


AI 估时兑现率
= (原始估时 - 实际工时) / (原始估时 - AI 结合估时)


这套指标体系让"AI 提效"从口号变成了可量化、可排期、可复盘的数据
。

更重要的是，它把 AI Coding 与"业务价值"挂钩——
风险规避价值 + 方案优化价值 + 收益加速价值
——让 AI Coding 不再只是"研发部门的事"，而是"全公司的事"。



启发 5：AI Coding 的真正护城河是"组织学习速度"


最后，也是我觉得最深刻的启发：

AI Coding 的上限，取决于研发系统是否为 AI 重新设计。


模型会越来越强，工具会越来越普及，但
你的研发系统（流程、平台、Skills、组织文化）能不能跟上 AI 的进化速度
，才是真正的护城河。

去哪儿这次分享最让我敬佩的，不是他们做到了 100% 覆盖、75% 出码率、3000+ 自动化任务、90%+ 测试通过率，而是
他们愿意把整个体系"打开"给所有人看
——从 QunarDevCenter 的表结构，到天弦的系统设计图，到 Qsuperpowers 的脱敏案例，到 Skills 治理的全流程。

这种"开放"本身就是一种"组织学习速度"的体现
。

当你的团队还在为"AI Coding 是不是要上"而争论时，去哪儿已经在用 150 人 1 天 3 个真实需求的黑客松，验证 AI Coding 的"组织极限"了。

差距，不在工具，在组织能力
。

14


写在最后


这份分享从"度量"开始，到"分级"展开，到"Harness 落地"，到"全流程数字化"，到"自动化平台天弦"，到"复杂需求框架 Qsuperpowers"，到"Skills 治理"，最后到"成果与展望"——
它给出了一个完整的 AI Coding 落地路线图
。

如果让我用一句话总结这份分享，那就是：

AI Coding 不是"工具升级"，而是"研发范式升级"。它要求我们重新设计度量、流程、平台、治理、组织文化——而这一切的起点，是承认"AI 已经在重写研发"。


愿我们都能成为这个时代的"组织能力建设者"，而不只是"工具使用者"。

关于作者
：本文是作者对李佳奇分享的深度解读，旨在提炼分享的核心观点、还原技术细节、分享个人思考。所有数据、案例、技术方案均来自原始分享，解读过程中可能存在主观判断，欢迎读者结合原始材料进行交叉验证。

喜欢的也可以关注我的公众号：
无处不在的技术
，与我一起学习成长、共同进步，在技术的道路上越走越远。


最近也看到有人问如何学习AI，这里分享几个资料如下：



1、通往AGI之路的知识库飞书云文档

https://waytoagi.feishu.cn/wiki/QPe5w5g7UisbEkkow8XcDmOpn8e

2、掘金的AI知识库的飞书云文档

https://agijuejin.feishu.cn/wiki/UvJPwhfkiitMzhkhEfycUnS9nAm?table=blk3RfZtR7Nh73tO

3、极客时间的AI知识库的飞书云文档

https://geek-agi.feishu.cn/wiki/B9rYwwg6xidZYJkbrlscxTQFnOc

4、LangGPT社区的飞书云文档（结构化提示词等等）

https://langgptai.feishu.cn/wiki/RXdbwRyASiShtDky381ciwFEnpe

5、一站式AI产品经理飞书知识库

https://v11enp9ok1h.feishu.cn/wiki/KiIvwdFOciiqqNkwKzTcmn88ndL

6、微软网站分享的AI指南说明知识

https://learn.microsoft.com/zh-cn/azure/databricks/generative-ai/guide/introduction-generative-ai-apps

7、赋范空间的飞书AI知识库：

https://kq4b3vgg5b.feishu.cn/wiki/ETqzwH4THiTY8kkGqAucYbSonPt

8、Marked的AI产品经理知识库

https://qqs7y1hozd1.feishu.cn/wiki/KVLtwsHdsiCLBfkumZpclY8ansd






- END -


喜欢就点个
在看
呗 👇1
