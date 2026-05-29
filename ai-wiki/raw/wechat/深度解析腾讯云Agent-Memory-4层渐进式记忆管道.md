---
title: "深度解析腾讯云Agent-Memory：4层渐进式记忆管道如何实现61%的Token节省与76%长期记忆准确率"
source_url: "https://mp.weixin.qq.com/s/FgGPjHlYMM4O_PRfEvk__A"
author: "Agent工程化"
source_type: wechat
fetched_at: 2026-05-29
publish_date: "2026年5月16日 11:10"
---

# 深度解析腾讯云Agent-Memory：4层渐进式记忆管道如何实现61%的Token节省与76%长期记忆准确率

> 作者: Agent工程化
> 来源: https://mp.weixin.qq.com/s/FgGPjHlYMM4O_PRfEvk__A
> 发布: 2026年5月16日 11:10

腾讯云刚开源的 TencentDB Agent Memory 彻底改变了 AI Agent 记忆系统的游戏规则——它不仅将 SWE-bench 通过率从 58.4% 提升至 64.2%，更在 WideSearch 基准上实现了 61.38% 的 Token 缩减。这套 4 层渐进式记忆管道（L0→L1→L2→L3）加符号化上下文卸载的双支柱架构，让 Agent 在连续 50+ 次任务的超长会话中依然保持精准记忆，而无需依赖任何外部 API。本文将深入源码，拆解其向量混合检索、自动化记忆提取调度、以及 Mermaid 图压缩上下文的完整技术实现。

目录
概述
  1.1 项目背景
  1.2 核心指标
核心架构
  2.1 双支柱设计：分层+符号化
  2.2 4 层记忆管道（L0-L3）
  2.3 符号化记忆与上下文卸载
  2.4 混合检索架构
源码分析
  3.1 插件入口与生命周期管理
  3.2 TdaiCore：宿主无关的核心引擎
  3.3 配置系统设计
  3.4 管道调度与并发控制
功能详解
  4.1 自动记忆捕获（L0→L1）
  4.2 场景归纳与用户画像（L2→L3）
  4.3 上下文卸载系统
  4.4 记忆召回与搜索工具
技术亮点
  5.1 渐进式信息披露
  5.2 全链路可追溯性
  5.3 优雅降级策略
  5.4 双后端存储架构
实践指南
  6.1 OpenClaw 集成（零配置）
  6.2 Hermes Gateway 部署（Docker）
  6.3 关键配置调优
  6.4 常见问题与排查
总结
参考文献
1. 概述
1.1 项目背景

AI Agent 面临一个根本性困境：每次对话都像失忆一样从零开始。传统的解决方案要么将原始对话全部塞入上下文窗口（Token 爆炸），要么依赖外部向量数据库进行简单检索（丢失结构化推理路径）。TencentDB Agent Memory 提出了一种全新的思路——将人类记忆的工作机制（短期→长期→归纳→画像）工程化为 4 层渐进式管道，让 Agent 拥有真正的"长期记忆"。

项目自 2026 年 3 月 25 日发布 v0.1.0 以来，58 次提交完成了从"OpenClaw 紧耦合插件"到"框架无关的独立记忆系统"的架构演进。当前最新版本 v0.3.4，TypeScript 实现，MIT 协议开源。

1.2 核心指标

项目在三个标准基准上的实测数据：

基准测试
	
无插件
	
有插件
	
Token 缩减


WideSearch（短期）成功率
	
33%
	
50%
	
−61.38%


SWE-bench（短期）成功率
	
58.4%
	
64.2%
	
−33.09%


AA-LCR（短期）成功率
	
44.0%
	
47.5%
	
−30.98%


PersonaMem（长期）准确率
	
48%
	
76%
	
N/A

值得注意的是，SWE-bench 测试是"连续 50 个任务在同一会话中执行"，并非孤立轮次——这恰恰模拟了真实 Agent 使用场景中上下文不断累积的压力。

2. 核心架构
2.1 双支柱设计：分层+符号化

系统拒绝"扁平向量存储"的传统方案，转而采用两个核心设计原则：

记忆分层（Memory Layering）：信息按抽象层次逐级提炼，高层保留结构和偏好，底层保留证据和可追溯性
符号化记忆（Symbolic Memory）：用高密度 Mermaid 图语法编码任务状态转换，以最少符号承载最大语义

这两大支柱共同支撑起一个核心承诺：每一层抽象都能确定性追溯回原始证据。

2.2 4 层记忆管道（L0-L3）

记忆系统按时间跨度和抽象层次划分为四个层级：

层级
	
名称
	
存储内容
	
存储格式
	
触发条件


L0
	
对话捕获
	
原始对话轮次
	
JSONL 文件
	
每次 Agent 对话结束


L1
	
原子记忆
	
提取的事实/偏好/决策
	
SQLite + 向量库
	
每 N 轮对话触发


L2
	
场景归纳
	
跨对话的模式与场景
	
Markdown 文件
	
L1 累积到阈值后触发


L3
	
用户画像
	
长期偏好与行为画像
	
Markdown 文件
	
每 50 条新记忆触发

存储策略的核心取舍：底层（L0/L1 的事实、日志、执行轨迹）使用数据库存储以支持全文检索；顶层（L2/L3 的场景块、画像、Canvas）使用人类可读的 Markdown 文件，实现"白盒可检查性"——运维人员可以直接打开文件查看 Agent 对用户的理解，而不是面对黑盒的向量打分。

关键的数据流转路径：

流程执行说明：

步骤 1-2：每次 Agent 对话结束触发 agent_end 钩子，L0 层无差别捕获原始对话为 JSONL 文件
步骤 3-6：L1 提取并非每轮都触发，而是受 pipeline.everyNConversations 控制（默认每 5 轮），且同一会话内有最小间隔保护
步骤 5：去重基于向量相似度——新提取的记忆与已有记忆进行余弦相似度比较，超过阈值则判定为重复
步骤 7-10：L2 和 L3 是级联触发——L1 累积量达到 persona.triggerEveryN（默认 50 条新记忆）后才启动 L2 归纳，L2 产生的新场景块再驱动 L3 更新
2.3 符号化记忆与上下文卸载

除了纵向的 4 层记忆管道，系统还提供了横向的上下文卸载（Context Offload）能力，专治"Agent 跑着跑着就把上下文窗口撑爆了"的顽疾。

核心思路：工具调用日志是最大的 Token 消耗源，但它们不需要全部留在上下文中。

卸载系统按四个级别渐进压缩：

级别
	
策略
	
操作
	
触发条件


L1
	
工具结果摘要
	
LLM 摘要替换原始结果，原文存入 refs/*.md
	
每 5 对工具调用/结果触发


L1.5
	
任务边界检测
	
LLM 判断对话是新任务还是延续
	
每次用户输入变更


L2
	
Mermaid Canvas 生成
	
将工具调用映射为知识图谱节点
	
定时轮询（可配阈值+超时）


L3
	
Token 预算压缩
	
三级递进压缩（MILD→AGGRESSIVE→EMERGENCY）
	
上下文组装时根据预算触发

L3 的三级压缩是最精妙的部分：

流程执行说明：

MILD 压缩（替换）保留对话结构，仅将工具结果替换为 LLM 生成的摘要存根，原文保存在外部文件中可通过 node_id 检索
AGGRESSIVE 压缩（删除+注入）移除整对工具调用/结果，但会注入结构化的 MMD 摘要告知 Agent 删除了什么
EMERGENCY 压缩（截断）是最后手段，从会话末尾剥离消息；用户消息受保护不被删除
三级压缩统一使用 tiktoken o200k_base 编码进行 Token 计量，确保跨模型一致性
2.4 混合检索架构

记忆召回不是简单的向量相似度搜索，而是结合了三路信号：

向量语义检索：基于 OpenAI 兼容 Embedding API，默认使用 sqlite-vec 本地扩展
BM25 关键词检索：基于 jieba 中文分词 + 稀疏向量编码
RRF 融合排序：Reciprocal Rank Fusion 将两路结果合并排序

召回策略可通过 recall.strategy 配置为 keyword、embedding 或 hybrid（推荐）。整个召回过程设 5 秒超时——超时则跳过记忆注入并打印警告日志，绝不阻塞 Agent 的主流程。

3. 源码分析
3.1 插件入口与生命周期管理

index.ts 是整个插件的"薄壳"——它只做编排，不包含任何业务逻辑。源码结构清晰展示了 OpenClaw 插件模型的最佳实践：

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
// index.ts 核心结构（简化）
export
 
default
 
function
 
register
(
api: OpenClawPluginApi
) {
  
// 1. 解析配置
  
const
 cfg = 
parseConfig
(api.
pluginConfig
);
  
  
// 2. 创建宿主适配器（解耦 OpenClaw）
  
const
 hostAdapter = 
new
 
OpenClawHostAdapter
(api);
  
  
// 3. 实例化核心引擎
  
const
 core = 
new
 
TdaiCore
(hostAdapter, cfg);
  
const
 coreReady = core.
initialize
();
  
  
// 4. 注册 Agent 工具
  api.
registerTool
(
'tdai_memory_search'
, 
/* ... */
);
  api.
registerTool
(
'tdai_conversation_search'
, 
/* ... */
);
  
  
// 5. 注册生命周期钩子
  api.
onBeforePromptBuild
(handleBeforeRecall);
  api.
onAgentEnd
(handleTurnCommitted);
  api.
onGatewayStop
(handleShutdown);
}

四个钩子的职责分离非常干净：

before_prompt_build：注入召回的记忆到上下文前缀，利用 Prompt Cache 友好位置
before_message_write：从持久化的用户消息中剥离 <relevant-memories> XML 块，避免重复存储
agent_end：触发 L0 捕获和管道处理，附带完整的性能指标上报
gateway_stop：有序关闭——先停清理器，再调 core.destroy()，3 秒超时保护
3.2 TdaiCore：宿主无关的核心引擎

TdaiCore 是整个系统最关键的抽象。它仅依赖两个接口：

1
2
3
4
5
6
7
// TdaiCore 构造函数（简化）
constructor
(
  hostAdapter: HostAdapter,    
// 日志、数据目录、LLM Runner 工厂
  config: MemoryTdaiConfig,
  sessionFilter?: SessionFilter,
  instanceId?: 
string
)

HostAdapter 接口屏蔽了 OpenClaw 和 Hermes Gateway 的差异，使得同一套记忆逻辑可以同时服务两种宿主环境。核心方法一览：

initialize()：初始化目录结构、向量存储、Embedding 服务、管道管理器
handleBeforeRecall(userText, sessionKey)：对话前自动召回相关记忆
handleTurnCommitted(turn)：对话后触发捕获和管道处理
searchMemories(params)：Agent 主动调用的 L1 记忆搜索工具
searchConversations(params)：Agent 主动调用的 L0 对话搜索工具
destroy()：排空后台任务（5 秒超时）、关闭数据库连接、重置状态

initialize() 中的并发安全设计值得注意：

1
2
3
4
5
6
7
8
9
10
11
12
13
// ensureSchedulerStarted 的并发安全实现
private
 
schedulerStartPromise
: 
Promise
<
void
> | 
null
 = 
null
;


private
 
async
 
ensureSchedulerStarted
(): 
Promise
<
void
> {
  
if
 (
this
.
schedulerStartPromise
) 
return
 
this
.
schedulerStartPromise
;
  
  
this
.
schedulerStartPromise
 = (
async
 () => {
    
await
 
this
.
storeReady
;
    
// ... 初始化调度器
  })();
  
  
return
 
this
.
schedulerStartPromise
;
}

所有调用者 await 同一个 in-flight Promise，避免了"多个调用者同时通过 null 检查，分别触碰未就绪的调度器"的竞态条件。这个 Bug 在测试用例 P0-1 中被发现并修复。

3.3 配置系统设计

config.ts（约 535 行）定义了完整的配置类型体系和解析逻辑。配置分组设计体现了系统的模块化程度：

1
2
3
4
5
6
7
8
9
10
11
12
13
interface
 
MemoryTdaiConfig
 {
  
storeBackend
: 
'sqlite'
 | 
'tcvdb'
;
  
capture
: 
CaptureConfig
;       
// L0 捕获配置
  
extraction
: 
ExtractionConfig
; 
// L1 提取配置
  
persona
: 
PersonaConfig
;       
// L2/L3 画像配置
  
pipeline
: 
PipelineTriggerConfig
; 
// 管道调度配置
  
recall
: 
RecallConfig
;         
// 召回策略配置
  
embedding
: 
EmbeddingConfig
;   
// 向量服务配置
  
bm25
:
BM25Config
; 
// 稀疏向量配置
  
offload
: 
OffloadConfig
;       
// 上下文卸载配置
  
llm
: 
StandaloneLLMOverrideConfig
; 
// 独立 LLM 配置
  
report
: 
ReportConfig
;         
// 指标上报配置
}

parseConfig() 函数实现了多层校验逻辑：

Embedding 提供商为 none 时显式禁用向量搜索
远程提供商缺少必填字段时自动降级为非向量模式并记录 configError
保留天数低于 3 天时拒绝（除非显式允许激进清理）
离线模式下自动检测 backendUrl 切换模式

这种"解析即校验"的单次遍历设计避免了运行时分散的配置检查。

3.4 管道调度与并发控制

管道调度器（MemoryPipelineManager）是 L1→L2→L3 级联触发的核心。关键调度参数：

L1 空闲超时 600 秒：会话无新消息超过此时间视为"对话段结束"
预热模式：新会话初期以更高频率触发提取，随后逐步降至常规间隔，加速冷启动阶段的记忆建立
L2 延迟与最小/最大间隔：防止高频触发，确保场景归纳质量
24 小时活跃窗口：超时未活动的会话自动退出调度队列

后台任务使用 bgTasks Set 追踪，destroy() 时先排空所有后台任务再关闭数据库连接，防止写入丢失。

4. 功能详解
4.1 自动记忆捕获（L0→L1）

捕获流程全自动、零配置（使用默认值即可）：

Agent 对话结束后，agent_end 钩子将完整对话写入 ~/.openclaw/memory-tdai/conversations/ 下的 JSONL 文件
管道调度器判断是否满足 L1 触发条件（默认每 5 轮对话、最小间隔保护）
LLM 从对话中提取原子事实，输出结构化 JSON
新记忆与已有记忆进行向量相似度去重
通过去重检查的记忆存入 SQLite + 向量索引

去重是保证记忆质量的关键环节。LLM 提取的"用户喜欢用 TypeScript"和向量库中已存的"用户偏好 TypeScript 语言"语义相同但措辞不同——向量相似度比较能够在语义层面识别重复。

4.2 场景归纳与用户画像（L2→L3）

当 L1 新记忆累积到 persona.triggerEveryN（默认 50 条）时触发 L2 场景归纳：

L2：LLM 扫描新增的 L1 记忆，识别跨对话的模式（如"用户在多个项目中都使用 PostgreSQL 并关注查询性能"），生成场景块 Markdown 文件
L3：基于更新后的场景块，LLM 生成或更新用户画像（如"后端工程师，偏好 PostgreSQL，关注性能优化，习惯使用 Docker 部署"）

L2/L3 产物以 Markdown 格式存储在 ~/.openclaw/memory-tdai/scene_blocks/ 和 ~/.openclaw/memory-tdai/records/ 下，运维人员可以直接阅读，不需要任何工具。

4.3 上下文卸载系统

卸载系统（src/offload/）在 v0.3.0 引入，独立于记忆管道运行。其核心价值在于解决长对话场景下的上下文窗口溢出问题。

L1 工具结果摘要：每 5 对工具调用/结果触发，LLM 生成摘要替换原始结果。失败后重试 3 次，全部失败则生成本地截断回退条目。

L1.5 任务边界检测：每次用户输入变更时，LLM 判断当前对话是"延续已有任务"、"开启新任务"还是"任务完成"。这个判断直接影响后续 MMD Canvas 的创建和选择。

L2 Mermaid Canvas：将工具调用映射为 Mermaid 知识图谱的节点。未分配节点的条目按批（≤30 条）送入后端 LLM 生成/修补 MMD 文件。回退逻辑处理降级响应——本地分配节点 ID。

L3 上下文组装压缩：详见 2.3 节的三级递进压缩。

4.4 记忆召回与搜索工具

系统为 Agent 暴露了两个搜索工具：

tdai_memory_search：搜索 L1 结构化记忆

参数：query（查询文本）、limit（返回数量）、type（记忆类型过滤）、scene（场景过滤）
返回：格式化的记忆文本 + 匹配总数 + 使用的检索策略

tdai_conversation_search：搜索 L0 原始对话

参数：query、limit、session_key（会话过滤）
返回：格式化的对话片段 + 匹配总数

两个工具都内置了速率限制（每轮最多 3 次调用），防止 Agent 过度依赖搜索陷入循环。

5. 技术亮点
5.1 渐进式信息披露

系统遵循"先给高层结构，按需下钻"的原则。Agent 的上下文前缀只注入 L2/L3 的高层摘要——L1 的原子事实和 L0 的原始对话不在默认注入范围内。当 Agent 需要更详细的信息时，它主动调用 tdai_memory_search 或 tdai_conversation_search 工具下钻。

这与人类记忆的工作方式高度一致：你不会在每次思考前回忆所有记忆，而是根据当前任务关联性地检索相关信息。

5.2 全链路可追溯性

每一层抽象都可以透过 node_id 确定性追溯回原始证据：

1
2
Persona → 
Scenario
 → Atom → Conversation
  L3L2L1 L0

这解决了"Agent 为什么得出这个结论"的审计难题。画像中的每条偏好都能追溯到具体的对话场景，场景中的每个模式都来源于具体的原子事实，原子事实可以在原始对话中找到原文上下文。

5.3 优雅降级策略

系统在多个层面实现了优雅降级：

召回超时：5 秒超时后跳过记忆注入，打印警告但不阻塞 Agent
Embedding 不可用：自动降级为纯关键词检索模式
配置不完整：记录 configError 但继续运行
LLM 提取失败：重试后转本地回退，不会丢失对话数据
向量库故障：initStores() 捕获异常，系统继续运行但向量搜索不可用
5.4 双后端存储架构

支持两种存储后端，通过 storeBackend 一键切换：

SQLite + sqlite-vec（默认）：零配置、全本地、适合单机部署
Tencent Cloud Vector DB：托管服务、支持 BM25 + 向量的服务端混合检索、适合生产集群

同时在 storeBackend 为 tcvdb 时，BM25 的稀疏向量编码在服务端执行（使用 bge-large-zh 中文模型），以降低客户端计算开销。

6. 实践指南
6.1 OpenClaw 集成（零配置）
1
2
3
4
5
# 安装插件
openclaw plugins install @tencentdb-agent-memory/memory-tencentdb


# 重启 Gateway
openclaw gateway restart

在 ~/.openclaw/openclaw.json 中启用：

1
2
3
4
5
6
7
{
  
"plugins"
:
 
{
    
"memory-tencentdb"
:
 
{
      
"enabled"
:
 
true
    
}
  
}
}

零配置启动即可使用 SQLite 本地后端的完整功能。如需启用 Embedding 向量搜索，需要配置 embedding 段：

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
{
  
"plugins"
:
 
{
    
"memory-tencentdb"
:
 
{
      
"enabled"
:
 
true
,
      
"config"
:
 
{
        
"embedding"
:
 
{
          
"provider"
:
 
"openai"
,
          
"baseUrl"
:
 
"https://api.openai.com/v1"
,
          
"apiKey"
:
 
"${OPENAI_API_KEY}"
,
          
"model"
:
 
"text-embedding-3-small"
,
          
"dimensions"
:
 
1536
        
}
      
}
    
}
  
}
}
6.2 Hermes Gateway 部署（Docker）
1
2
3
4
5
6
7
docker run -d \
  -e MODEL_API_KEY=your_key \
  -e MODEL_BASE_URL=https://api.openai.com/v1 \
  -e MODEL_NAME=gpt-4o \
  -e MODEL_PROVIDER=openai \
  -v ~/.openclaw/memory-tdai:/data \
  ghcr.io/tencent/tencentdb-agent-memory:latest

Docker 镜像内置了完整依赖，默认使用腾讯云 DeepSeek-V3.2 作为提取 LLM。

6.3 关键配置调优
场景
	
配置项
	
建议值
	
原因


高频交互 Agent
	pipeline.everyNConversations	
3
	
更快建立记忆


低交互 Agent
	pipeline.everyNConversations	
10
	
减少 LLM 调用开销


中文为主
	bm25.language	zh	
启用 jieba 分词


对召回精度要求高
	recall.scoreThreshold	
0.5
	
减少噪音记忆


需要更多记忆上下文
	recall.maxResults	
10
	
更多候选记忆


长对话场景
	offload.enabled	
true
	
防止上下文溢出


隐私/离线场景
	storeBackend	sqlite	
全本地存储
6.4 常见问题与排查
Embedding 配置了但不生效：检查 provider 是否设为 none，以及 apiKey、baseUrl、model、dimensions 四个字段是否全部填写——任一缺失都会导致静默降级为非向量模式
记忆没有被提取：检查 capture.enabled 和 extraction.enabled 是否都为 true，以及 capture.excludeAgents 是否误排除了目标 Agent
向量搜索返回空结果：确认 recall.enabled 为 true，且 recall.scoreThreshold 未设置过高（默认 0.3）
数据存储位置：所有数据在 ~/.openclaw/memory-tdai/ 下，包含 conversations/（L0）、records/（L1/L3）、scene_blocks/（L2）、vectors.db（向量索引）
7. 总结

TencentDB Agent Memory 为 AI Agent 的记忆问题提供了一个工程上非常成熟的解决方案：

4 层渐进式记忆管道让 Agent 拥有了类似人类的"短期→长期→归纳→画像"记忆形成机制
符号化上下文卸载用 Mermaid 图 + 三级递进压缩解决了长对话的 Token 爆炸问题，实测节省 61.38% Token
TdaiCore + HostAdapter 的架构设计使其从 OpenClaw 插件进化为框架无关的独立系统
全链路可追溯性（Persona→Scenario→Atom→Conversation）让 Agent 记忆从黑盒变为白盒
多层次的优雅降级策略保证了生产环境的可靠性

对于需要让 Agent 在长期交互中保持上下文连续性的开发者，这套系统提供了从零配置本地部署到生产集群的全覆盖方案。项目仍在快速迭代中，路线图上的跨框架便携记忆、自动技能生成和可视化调试面板值得持续关注。

参考文献

[1] TencentDB-Agent-Memory GitHub 仓库：https://github.com/Tencent/TencentDB-Agent-Memory

[2] OpenClaw Agent Framework：https://github.com/openclaw/openclaw

[3] sqlite-vec 向量扩展：https://github.com/asg017/sqlite-vec

[4] Jieba 中文分词：https://github.com/fxsjy/jieba

[5] 腾讯云向量数据库：https://cloud.tencent.com/product/tcvdb
