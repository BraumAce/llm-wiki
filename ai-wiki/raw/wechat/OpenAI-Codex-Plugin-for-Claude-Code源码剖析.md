---
title: "OpenAI Codex Plugin for Claude Code 源码剖析"
source_url: "https://mp.weixin.qq.com/s/oOdSoAtitE_ayAfA607HwA"
author: "Agent工程化"
source_type: wechat
fetched_at: 2026-05-29
publish_date: "2026年5月4日 08:53"
---

# OpenAI Codex Plugin for Claude Code 源码剖析

> 作者: Agent工程化
> 来源: https://mp.weixin.qq.com/s/oOdSoAtitE_ayAfA607HwA
> 发布: 2026年5月4日 08:53

本文基于 openai/codex-plugin-cc 仓库源码逐层剖析 Codex Plugin for Claude Code 的内部实现。从入口调度、App Server 通信协议、后台任务管理、Review Gate 审查门禁，到状态持久化和 Broker 代理架构，深入分析每个核心模块的设计决策和实现细节。适合希望理解 Claude Code 插件开发模式、JSON-RPC over stdiolink 协议设计、以及跨 AI 工具集成架构的开发者阅读。

目录
概述
  1.1 项目定位与设计目标
  1.2 技术栈与代码规模
核心架构
  2.1 模块依赖关系
  2.2 数据流全景
源码分析
  3.1 codex-companion.mjs — 入口调度器
  3.2 app-server.mjs — JSON-RPC 通信协议
  3.3 app-server-broker.mjs — 共享连接代理
  3.4 state.mjs — 状态持久化层
  3.5 tracked-jobs.mjs — 任务生命周期管理
  3.6 stop-review-gate-hook.mjs — 审查门禁实现
  3.7 session-lifecycle-hook.mjs — 会话生命周期管理
功能详解
  4.1 Review 标准审查 — 两条路径
  4.2 Adversarial Review 对抗性审查 — Prompt 工程
  4.3 Task 任务委派 — 前台与后台模式
  4.4 任务恢复机制 — resume 与 fresh
技术亮点
  5.1 JSON-RPC over stdiolink 双传输层
  5.2 Broker 代理解决并发复用
  5.3 进程树终止的跨平台处理
  5.4 状态文件的原子更新策略
  5.5 Prompt 模板引擎与变量插值
实践指南
  6.1 插件开发模式总结
  6.2 从源码学到的设计模式
总结
1. 概述
1.1 项目定位与设计目标

codex-plugin-cc 是 OpenAI 官方发布的 Claude Code 插件，核心设计目标是在 Claude Code 会话中无缝调用 Codex CLI 的能力。从源码看，插件不做任何 AI 推理——它是一个纯粹的桥接层，将 Claude Code 的斜杠命令转化为 Codex App Server 的 JSON-RPC 调用。

设计原则：

零推理：插件本身不调用任何 LLM，所有 AI 能力由 Codex 提供
协议桥接：通过 JSON-RPC 协议与 Codex App Server 通信
任务追踪：每个操作（review/task）都有完整的生命周期记录
后台分离：后台任务通过 spawn + unref 实现进程级隔离
1.2 技术栈与代码规模
维度
	
数据


语言
	
JavaScript (ESM)


运行时
	
Node.js 18.18+


依赖
	
零外部依赖（仅 Node 内置模块）


核心脚本
	
4 个入口 + 14 个库模块


通信协议
	
JSON-RPC over stdiolink / Unix socket


测试
	
Node 内置 node --test

零外部依赖是重要的设计选择——插件只使用 node:child_process、node:net、node:fs、node:crypto 等内置模块，确保安装简单、启动快速。

2. 核心架构
2.1 模块依赖关系
codex-companion
.mjs
 (入口，~
600
 行)
├── lib/args
.mjs
           — 命令行参数解析
├── lib/codex
.mjs
—CodexCLI可用性检查、AppServer 封装
├── lib/git
.mjs
            — Git 仓库上下文收集
├── lib/app-server
.mjs
     — JSON-RPC 客户端（直连 + Broker 两种传输）
├── lib/state
.mjs
          — 状态文件读写、Job CRUD
├── lib/tracked-jobs
.mjs
   — 任务生命周期（创建→运行→完成→失败）
├── lib/job-control
.mjs
    — Job 查询、过滤、排序
├── lib/render
.mjs
         — 输出格式化（文本/JSON）
├── lib/prompts
.mjs
        — Prompt 模板加载与插值
├── lib/process
.mjs
        — 进程树终止
├── lib/workspace
.mjs
      — 工作区根目录解析
└── lib/fs
.mjs
             — 文件系统工具


app-server-broker
.mjs
 (Broker 代理，~
200
 行)
├── lib/app-server
.mjs
     — App Server 客户端
├── lib/args
.mjs
           — 参数解析
└── lib/broker-endpoint
.mjs
 — 端点解析


stop-review-gate-hook
.mjs
 (Review Gate Hook，~
160
 行)
├── lib/codex
.mjs
          — 可用性检查
├── lib/prompts
.mjs
        — Prompt 模板
├── lib/state
.mjs
          — 配置读取
└── codex-companion
.mjs
    — 通过 spawnSync 调用 task 命令


session-lifecycle-hook
.mjs
 (会话管理，~
120
 行)
├── lib/broker-lifecycle
.mjs
 — Broker 会话管理
├── lib/state
.mjs
            — Job 清理
└── lib/process
.mjs
          — 进程终止
2.2 数据流全景

流程执行说明：

斜杠命令触发 codex-companion.mjs 的 main() 入口
通过 lib/codex.mjs 调用 App Server，优先走 Broker 复用连接
Broker 不可用时直连模式 spawn("codex", ["app-server"])
执行结果通过 state.mjs 持久化，支持后续查询
3. 源码分析
3.1 codex-companion.mjs — 入口调度器

这是插件的核心入口文件，约 600 行，实现了命令路由、参数解析、任务调度三大职责。

命令路由通过 main() 函数的 switch 语句实现：

async
 
function
 
main
() {
  
const
 [subcommand, ...argv] = process.
argv
.
slice
(
2
);
  
switch
 (subcommand) {
   
case
"setup"
:
await
handleSetup
(argv);
break
;
   
case
"review"
:
await
handleReview
(argv);
break
;
    
case
 
"adversarial-review"
: 
await
 
handleReviewCommand
(argv, ...); 
break
;
   
case
"task"
:
await
handleTask
(argv);
break
;
    
case
 
"task-worker"
:     
await
 
handleTaskWorker
(argv); 
break
;
   
case
"status"
:
await
handleStatus
(argv);
break
;
   
case
"result"
:
handleResult
(argv);
break
;
   
case
"cancel"
:
await
handleCancel
(argv);
break
;
  }
}

注意 task-worker 不对外暴露——它是后台任务的工作进程入口，由 spawnDetachedTaskWorker() 创建。

模型别名映射：

const
 
MODEL_ALIASES
 = 
new
 
Map
([[
"spark"
, 
"gpt-5.3-codex-spark"
]]);

当用户传入 --model spark 时，normalizeRequestedModel() 将其映射为实际的模型 ID。

后台任务机制的关键实现：

function
 
spawnDetachedTaskWorker
(
cwd, jobId
) {
  
const
 scriptPath = path.
join
(
ROOT_DIR
, 
"scripts"
, 
"codex-companion.mjs"
);
  
const
 child = 
spawn
(process.
execPath
, 
    [scriptPath, 
"task-worker"
, 
"--cwd"
, cwd, 
"--job-id"
, jobId],
    { cwd, 
env
: process.
env
, 
detached
: 
true
, 
stdio
: 
"ignore"
, 
windowsHide
: 
true
 }
  );
  child.
unref
();  
// 父进程不再等待子进程
  
return
 child;
}

detached: true + child.unref() 是关键组合——子进程成为独立进程组，Claude Code 会话可以继续工作而不被阻塞。

3.2 app-server.mjs — JSON-RPC 通信协议

这个模块实现了与 Codex App Server 通信的客户端，使用 JSON-RPC 2.0 over stdiolink 协议。

双传输层设计——两种客户端实现共享同一个基类 AppServerClientBase：

class
 
AppServerClientBase
 {
  
// 共享逻辑：请求/响应匹配、通知处理、错误处理
  
request
(
method, params
) {
    
const
 id = 
this
.
nextId
++;
    
return
 
new
 
Promise
(
(
resolve, reject
) =>
 {
      
this
.
pending
.
set
(id, { resolve, reject, method });
      
this
.
sendMessage
({ id, method, params });
    });
  }
}


// 直连模式：spawn codex app-server 子进程
class
 
SpawnedCodexAppServerClient
 
extends
 
AppServerClientBase
 {
  
async
 
initialize
() {
    
this
.
proc
 = 
spawn
(
"codex"
, [
"app-server"
], { 
stdio
: [
"pipe"
, 
"pipe"
, 
"pipe"
] });
    
// stdin/stdout 作为 JSON-RPC 通道
    
this
.
readline
 = readline.
createInterface
({ 
input
: 
this
.
proc
.
stdout
 });
    
this
.
readline
.
on
(
"line"
, 
(
line
) =>
 
this
.
handleLine
(line));
  }
  
sendMessage
(
message
) {
    
this
.
proc
.
stdin
.
write
(
`${JSON.stringify(message)}\n`
);
  }
}


// Broker 模式：通过 Unix socket 连接共享代理
class
 
BrokerCodexAppServerClient
 
extends
 
AppServerClientBase
 {
  
async
 
initialize
() {
    
this
.
socket
 = net.
createConnection
({ 
path
: target.
path
 });
    
this
.
socket
.
on
(
"data"
, 
(
chunk
) =>
 
this
.
handleChunk
(chunk));
  }
  
sendMessage
(
message
) {
    
this
.
socket
.
write
(
`${JSON.stringify(message)}\n`
);
  }
}

连接选择逻辑在 CodexAppServerClient.connect() 中：

static
 
async
 
connect
(
cwd, options = {}
) {
  
let
 brokerEndpoint = 
null
;
  
if
 (!options.
disableBroker
) {
    
// 优先使用环境变量中的 Broker 端点
    brokerEndpoint = process.
env
[
BROKER_ENDPOINT_ENV
] ?? 
null
;
    
// 其次创建新的 Broker 会话
    
if
 (!brokerEndpoint && !options.
reuseExistingBroker
) {
      
const
 session = 
await
 
ensureBrokerSession
(cwd);
      brokerEndpoint = session?.
endpoint
 ?? 
null
;
    }
  }
  
// Broker 可用则走 Broker，否则直连
  
const
 client = brokerEndpoint
    ? 
new
 
BrokerCodexAppServerClient
(cwd, { ...options, brokerEndpoint })
    : 
new
 
SpawnedCodexAppServerClient
(cwd, options);
  
await
 client.
initialize
();
  
return
 client;
}

JSON-RPC 消息处理在 handleLine() 中实现：

handleLine
(
line
) {
  
const
 message = 
JSON
.
parse
(line);
  
if
 (message.
id
 !== 
undefined
 && message.
error
) {
    
// 响应（错误）
    
const
 pending = 
this
.
pending
.
get
(message.
id
);
    pending.
reject
(
createProtocolError
(message.
error
.
message
, message.
error
));
  } 
else
 
if
 (message.
id
 !== 
undefined
) {
    
// 响应（成功）
    
const
 pending = 
this
.
pending
.
get
(message.
id
);
    pending.
resolve
(message.
result
 ?? {});
  } 
else
 
if
 (message.
method
) {
    
// 通知（服务端主动推送）
    
this
.
notificationHandler
?.(message);
  }
}

这种设计使得请求-响应匹配完全通过 id 字段实现，支持异步并发请求。

3.3 app-server-broker.mjs — 共享连接代理

Broker 解决了一个关键问题：多个 Claude Code 插件组件需要共享同一个 Codex App Server 连接。

流程执行说明：

Broker 作为中间代理，监听 Unix socket
Review 命令和 Review Gate Hook 通过同一 Broker 连接
流式方法（turn/start、review/start）独占连接，但允许 turn/interrupt 打断

核心的并发控制逻辑：

// 流式方法需要独占连接
const
 
STREAMING_METHODS
 = 
new
 
Set
([
"turn/start"
, 
"review/start"
, 
"thread/compact/start"
]);


// 允许 interrupt 打断正在进行的流
const
 allowInterruptDuringActiveStream =
  
isInterruptRequest
(message) && activeStreamSocket && activeStreamSocket !== socket;


// 其他请求在忙时返回错误码
if
 ((activeRequestSocket || activeStreamSocket) && !allowInterruptDuringActiveStream) {
  
send
(socket, { 
id
: message.
id
, 
    
error
: 
buildJsonRpcError
(
BROKER_BUSY_RPC_CODE
, 
"Shared Codex broker is busy."
) 
  });
}

Broker 的生命周期由 session-lifecycle-hook.mjs 管理——会话结束时发送 broker/shutdown 并清理 Unix socket 文件。

3.4 state.mjs — 状态持久化层

状态管理使用文件系统实现，不依赖数据库。每个工作区有独立的状态目录。

状态目录解析：

function
 
resolveStateDir
(
cwd
) {
  
const
 workspaceRoot = 
resolveWorkspaceRoot
(cwd);
  
// 用工作区路径的 SHA256 前 16 位作为唯一标识
  
const
 hash = 
createHash
(
"sha256"
)
    .
update
(fs.
realpathSync
.
native
(workspaceRoot))
    .
digest
(
"hex"
).
slice
(
0
, 
16
);
  
const
 slug = path.
basename
(workspaceRoot)
    .
replace
(
/[^a-zA-Z0-9._-]+/g
, 
"-"
) || 
"workspace"
;
  
// 存储在 CLAUDE_PLUGIN_DATA/state/ 或临时目录
  
const
 stateRoot = pluginDataDir 
    ? path.
join
(pluginDataDir, 
"state"
) 
    : path.
join
(os.
tmpdir
(), 
"codex-companion"
);
  
return
 path.
join
(stateRoot, 
`${slug}-${hash}`
);
}

状态文件结构（state.json）：

{
  
"version"
:
 
1
,
  
"config"
:
 
{
    
"stopReviewGate"
:
 
false
  
}
,
  
"jobs"
:
 
[
    
{
      
"id"
:
 
"review-lq3f2a-abc123"
,
      
"kind"
:
 
"review"
,
      
"kindLabel"
:
 
"review"
,
      
"title"
:
 
"Codex Review"
,
      
"status"
:
 
"completed"
,
      
"phase"
:
 
"done"
,
      
"sessionId"
:
 
"..."
,
      
"threadId"
:
 
"..."
,
      
"createdAt"
:
 
"2025-06-01T10:00:00.000Z"
,
      
"updatedAt"
:
 
"2025-06-01T10:02:30.000Z"
,
      
"completedAt"
:
 
"2025-06-01T10:02:30.000Z"
    
}
  
]
}

Job 数量限制：

const
 
MAX_JOBS
 = 
50
;


function
 
pruneJobs
(
jobs
) {
  
return
 [...jobs]
    .
sort
(
(
a, b
) =>
 
String
(b.
updatedAt
 ?? 
""
).
localeCompare
(
String
(a.
updatedAt
 ?? 
""
)))
    .
slice
(
0
, 
MAX_JOBS
);
}

saveState() 每次写入时自动裁剪到最近 50 个 Job，并清理被裁剪 Job 的独立文件（{jobId}.json 和 {jobId}.log）。

双写策略：每个 Job 同时存在于 state.json 的 jobs 数组中和独立的 {jobId}.json 文件中。state.json 中的是摘要信息（用于列表查询），独立文件中是完整数据（用于结果获取）。

3.5 tracked-jobs.mjs — 任务生命周期管理

这个模块管理 Job 从创建到完成（或失败）的完整生命周期。

状态机：

created → queued → 
running
 → completed
   → failed
   → cancelled

核心函数 runTrackedJob()：

async
 
function
 
runTrackedJob
(
job, runner, options = {}
) {
  
// 1. 标记为 running
  
const
 runningRecord = { ...job, 
status
: 
"running"
, 
startedAt
: 
nowIso
(), 
pid
: process.
pid
 };
  
writeJobFile
(job.
workspaceRoot
, job.
id
, runningRecord);
  
upsertJob
(job.
workspaceRoot
, runningRecord);


  
try
 {
    
// 2. 执行实际任务
    
const
 execution = 
await
 
runner
();
    
// 3. 标记为 completed/failed
    
const
 completionStatus = execution.
exitStatus
 === 
0
 ? 
"completed"
 : 
"failed"
;
    
writeJobFile
(job.
workspaceRoot
, job.
id
, { ...runningRecord, 
status
: completionStatus, ... });
    
upsertJob
(job.
workspaceRoot
, { 
id
: job.
id
, 
status
: completionStatus, ... });
    
return
 execution;
  } 
catch
 (error) {
    
// 4. 异常时标记为 failed
    
writeJobFile
(job.
workspaceRoot
, job.
id
, { ...existing, 
status
: 
"failed"
, errorMessage, ... });
    
upsertJob
(job.
workspaceRoot
, { 
id
: job.
id
, 
status
: 
"failed"
, ... });
    
throw
 error;
  }
}

进度更新机制：

function
 
createJobProgressUpdater
(
workspaceRoot, jobId
) {
  
let
 lastPhase = 
null
, lastThreadId = 
null
, lastTurnId = 
null
;
  
return
 
(
event
) =>
 {
    
// 仅在状态变化时写入（去抖）
    
if
 (event.
phase
 && event.
phase
 !== lastPhase) {
      lastPhase = event.
phase
;
      
upsertJob
(workspaceRoot, { 
id
: jobId, 
phase
: event.
phase
 });
      
// 同步更新独立 Job 文件
      
const
 storedJob = 
readJobFile
(
resolveJobFile
(workspaceRoot, jobId));
      
writeJobFile
(workspaceRoot, jobId, { ...storedJob, ...patch });
    }
  };
}

通过闭包缓存上一次状态，仅在变化时才触发文件写入，减少 I/O 开销。

3.6 stop-review-gate-hook.mjs — 审查门禁实现

Review Gate 作为 Claude Code 的 Stop Hook 运行，在每次 Claude 响应后自动触发。

决策逻辑：

function
 
main
() {
  
const
 input = 
readHookInput
();  
// 从 stdin 读取 Hook 输入
  
const
 config = 
getConfig
(workspaceRoot);


  
// 1. 检查是否启用了 Review Gate
  
if
 (!config.
stopReviewGate
) { 
logNote
(runningTaskNote); 
return
; }


  
// 2. 检查 Codex 是否可用
  
const
 setupNote = 
buildSetupNote
(cwd);
  
if
 (setupNote) { 
logNote
(setupNote); 
return
; }


  
// 3. 执行审查
  
const
 review = 
runStopReview
(cwd, input);
  
if
 (!review.
ok
) {
    
emitDecision
({ 
decision
: 
"block"
, 
reason
: review.
reason
 });
    
return
;
  }
}

审查执行通过 spawnSync 同步调用 codex-companion.mjs task：

function
 
runStopReview
(
cwd, input = {}
) {
  
const
 prompt = 
buildStopReviewPrompt
(input);
  
const
 result = 
spawnSync
(process.
execPath
, 
    [scriptPath, 
"task"
, 
"--json"
, prompt],
    { cwd, 
timeout
: 
STOP_REVIEW_TIMEOUT_MS
 }  
// 15 分钟超时
  );
  
const
 payload = 
JSON
.
parse
(result.
stdout
);
  
return
 
parseStopReviewOutput
(payload?.
rawOutput
);
}

结果解析从 Codex 输出的第一行提取决策：

function
 
parseStopReviewOutput
(
rawOutput
) {
  
const
 firstLine = text.
split
(
/\r?\n/
, 
1
)[
0
].
trim
();
  
if
 (firstLine.
startsWith
(
"ALLOW:"
)) 
return
 { 
ok
: 
true
 };
  
if
 (firstLine.
startsWith
(
"BLOCK:"
)) 
return
 { 
ok
: 
false
, 
reason
: ... };
  
// 无法识别时默认 block
  
return
 { 
ok
: 
false
, 
reason
: 
"unexpected answer"
 };
}

这个设计巧妙地复用了 task 命令——Review Gate 本质上就是让 Codex 执行一个特殊的 task，该 task 的 Prompt（stop-review-gate.md）要求 Codex 只输出 ALLOW: 或 BLOCK:。

3.7 session-lifecycle-hook.mjs — 会话生命周期管理

这个 Hook 处理 Claude Code 会话的开始和结束事件。

SessionStart：将 session_id 写入环境变量文件，后续所有任务可以关联到同一个会话。

function
 
handleSessionStart
(
input
) {
  
appendEnvVar
(
SESSION_ID_ENV
, input.
session_id
);
  
appendEnvVar
(
PLUGIN_DATA_ENV
, process.
env
[
PLUGIN_DATA_ENV
]);
}

SessionEnd：清理所有资源。

async
 
function
 
handleSessionEnd
(
input
) {
  
// 1. 向 Broker 发送 shutdown
  
await
 
sendBrokerShutdown
(brokerEndpoint);
  
// 2. 终止本会话的所有运行中任务
  
cleanupSessionJobs
(cwd, sessionId);
  
// 3. 清理 Broker 的 socket/PID/log 文件
  
teardownBrokerSession
({ endpoint, pidFile, logFile, sessionDir, pid });
  
// 4. 清除 Broker 会话记录
  
clearBrokerSession
(cwd);
}

cleanupSessionJobs() 遍历所有属于当前会话且仍在 running/queued 状态的 Job，调用 terminateProcessTree() 终止进程树。

4. 功能详解
4.1 Review 标准审查 — 两条路径

Review 命令有两条执行路径，取决于是否支持原生审查：

async
 
function
 
executeReviewRun
(
request
) {
  
if
 (reviewName === 
"Review"
) {
    
// 路径 1：原生审查（直接调用 Codex 内置 reviewer）
    
const
 reviewTarget = 
validateNativeReviewRequest
(target, focusText);
    
const
 result = 
await
 
runAppServerReview
(request.
cwd
, { 
target
: reviewTarget });
    
return
 { ...result, 
rendered
: 
renderNativeReviewResult
(result) };
  }
  
// 路径 2：对抗性审查（构造自定义 Prompt，走通用 turn 接口）
  
const
 context = 
collectReviewContext
(request.
cwd
, target);
  
const
 prompt = 
buildAdversarialReviewPrompt
(context, focusText);
  
const
 result = 
await
 
runAppServerTurn
(context.
repoRoot
, { prompt, 
sandbox
: 
"read-only"
 });
  
return
 { ...result, 
rendered
: 
renderReviewResult
(parsed) };
}
维度
	
原生 Review
	
Adversarial Review


API
	review/start	turn/start

Sandbox
	
自动只读
	
显式 read-only


Prompt
	
内置
	
自定义模板


输出格式
	
纯文本
	
结构化 JSON + Schema 校验


自定义焦点
	
不支持
	
支持 focus text
4.2 Adversarial Review 对抗性审查 — Prompt 工程

对抗性审查使用模板引擎构建 Prompt：

function
 
buildAdversarialReviewPrompt
(
context, focusText
) {
  
const
 template = 
loadPromptTemplate
(
ROOT_DIR
, 
"adversarial-review"
);
  
return
 
interpolateTemplate
(template, {
    
TARGET_LABEL
: context.
target
.
label
,
    
USER_FOCUS
: focusText || 
"No extra focus provided."
,
    
REVIEW_COLLECTION_GUIDANCE
: context.
collectionGuidance
,
    
REVIEW_INPUT
: context.
content
  });
}

模板文件 adversarial-review.md 使用 XML 标签组织结构（<role>、<task>、<attack_surface>、<review_method> 等），通过 interpolateTemplate() 替换 {{VARIABLE}} 占位符。

关键设计：模板中定义了 <finding_bar> 门槛（"Report only material findings"）和 <grounding_rules>（"Every finding must be defensible"），确保审查输出质量可控。

4.3 Task 任务委派 — 前台与后台模式

Task 命令的执行路径在 handleTask() 中分叉：

async
 
function
 
handleTask
(
argv
) {
  
if
 (options.
background
) {
    
// 后台模式：创建 Job → 入队 → spawn detached worker
    
const
 job = 
buildTaskJob
(workspaceRoot, taskMetadata, write);
    
const
 request = 
buildTaskRequest
({ cwd, model, effort, prompt, write, resumeLast });
    
const
 { payload } = 
enqueueBackgroundTask
(cwd, job, request);
    
outputCommandResult
(payload, 
renderQueuedTaskLaunch
(payload), options.
json
);
    
return
;
  }
  
// 前台模式：创建 Job → 直接执行
  
const
 job = 
buildTaskJob
(workspaceRoot, taskMetadata, write);
  
await
 
runForegroundCommand
(job, 
(
progress
) =>
 
executeTaskRun
({ ... }), options);
}

后台任务入队流程：

function
 
enqueueBackgroundTask
(
cwd, job, request
) {
  
// 1. 创建日志文件
  
const
 { logFile } = 
createTrackedProgress
(job);
  
// 2. spawn 分离的 worker 进程
  
const
 child = 
spawnDetachedTaskWorker
(cwd, job.
id
);
  
// 3. 写入 Job 记录（status: "queued"）
  
const
 queuedRecord = { ...job, 
status
: 
"queued"
, 
pid
: child.
pid
, request };
  
writeJobFile
(job.
workspaceRoot
, job.
id
, queuedRecord);
  
upsertJob
(job.
workspaceRoot
, queuedRecord);
  
return
 { 
payload
: { 
jobId
: job.
id
, 
status
: 
"queued"
, ... } };
}

Worker 进程（handleTaskWorker）从存储的 Job 文件中读取请求参数并执行：

async
 
function
 
handleTaskWorker
(
argv
) {
  
const
 storedJob = 
readStoredJob
(workspaceRoot, options[
"job-id"
]);
  
const
 request = storedJob.
request
;  
// 恢复请求参数
  
await
 
runTrackedJob
(storedJob, 
() =>
 
executeTaskRun
({ ...request }));
}
4.4 任务恢复机制 — resume 与 fresh

--resume 和 --fresh 控制任务是否继续上一次的 Codex 会话：

let
 resumeThreadId = 
null
;
if
 (request.
resumeLast
) {
  
// 查找本仓库最近的可恢复任务
  
const
 latestThread = 
await
 
resolveLatestTrackedTaskThread
(workspaceRoot);
  
if
 (!latestThread) {
    
throw
 
new
 
Error
(
"No previous Codex task thread was found."
);
  }
  resumeThreadId = latestThread.
id
;
}


const
 result = 
await
 
runAppServerTurn
(workspaceRoot, {
  resumeThreadId,          
// 非空时恢复旧线程
  
prompt
: request.
prompt
,
  
defaultPrompt
: resumeThreadId ? 
DEFAULT_CONTINUE_PROMPT
 : 
""
,
  
persistThread
: 
true
,     
// 持久化线程，供后续恢复
  
threadName
: resumeThreadId ? 
null
 : 
buildPersistentTaskThreadName
(request.
prompt
)
});

恢复逻辑优先在当前 Claude 会话中查找可恢复任务，找不到时再搜索全局任务列表。

5. 技术亮点
5.1 JSON-RPC over stdiolink 双传输层

app-server.mjs 通过基类 + 两个子类实现了传输层抽象：

SpawnedCodexAppServerClient：通过 spawn("codex", ["app-server"]) 的 stdin/stdout 通信
BrokerCodexAppServerClient：通过 Unix socket 连接到共享 Broker

两者共享完全相同的 JSON-RPC 协议处理逻辑（handleLine()、request()、notify()），仅在 sendMessage() 和连接建立方式上有差异。这是经典的策略模式应用。

5.2 Broker 代理解决并发复用

Broker（app-server-broker.mjs）作为独立进程运行，通过 Unix socket 接受多个客户端连接，复用同一个 Codex App Server 实例。

关键设计：

请求排队：同时只允许一个活跃请求，其他返回 BROKER_BUSY_RPC_CODE
流式支持：turn/start 等方法在响应后继续接收通知
中断特权：turn/interrupt 可以打断正在进行流式传输的其他请求
通知路由：Codex 推送的通知（如 turn/completed）自动路由到正确的客户端
5.3 进程树终止的跨平台处理

process.mjs 中的 terminateProcessTree() 需要处理 Windows 和 Unix 的差异：

// Windows: 使用 taskkill /T /F 终止整个进程树
// Unix: 使用进程组 kill

在 app-server.mjs 的 close() 方法中，Windows 使用 terminateProcessTree() 而 Unix 使用 SIGTERM，确保进程清理在两个平台上都可靠。

5.4 状态文件的原子更新策略

state.mjs 使用 writeFileSync 覆盖写入 + pruneJobs 裁剪策略：

function
 
saveState
(
cwd, state
) {
  
const
 nextJobs = 
pruneJobs
(state.
jobs
);  
// 裁剪到 MAX_JOBS
  
// 清理被裁剪的 Job 文件
  
for
 (
const
 removedJob 
of
 previousJobs) {
    
if
 (!retainedIds.
has
(removedJob.
id
)) {
      
removeJobFile
(
resolveJobFile
(cwd, removedJob.
id
));
      
removeFileIfExists
(removedJob.
logFile
);
    }
  }
  
// 覆盖写入
  fs.
writeFileSync
(
resolveStateFile
(cwd), 
JSON
.
stringify
(nextState, 
null
, 
2
));
}

虽然不是严格的原子写入（没有 write-then-rename），但对于单进程写入场景足够安全。

5.5 Prompt 模板引擎与变量插值

prompts.mjs 实现了一个轻量模板引擎：

function
 
interpolateTemplate
(
template, variables
) {
  
return
 template.
replace
(
/\{\{(\w+)\}\}/g
, 
(
match, key
) =>
 {
    
return
 variables[key] ?? match;
  });
}

使用 {{VARIABLE}} 占位符语法，与模板文件中的 XML 标签结构配合，实现 Prompt 的参数化组装。

6. 实践指南
6.1 插件开发模式总结

从这个仓库可以提取 Claude Code 插件的开发模式：

入口：scripts/ 目录下的 .mjs 文件作为可执行入口
命令定义：commands/ 目录下每个 .md 文件定义一条斜杠命令
代理定义：agents/ 目录下定义子代理
技能定义：skills/ 目录下用 SKILL.md 定义内部技能
Hook 注册：hooks/hooks.json 注册生命周期钩子
状态管理：使用 $CLAUDE_PLUGIN_DATA 目录存储持久化数据
6.2 从源码学到的设计模式
模式
	
源码体现


策略模式
	AppServerClientBase
 + 两个传输子类


命令模式
	main()
 的 switch 路由到独立 handler


观察者模式
	
进度更新通过回调链传递


模板方法
	runTrackedJob()
 定义骨架，runner() 由调用者提供


代理模式
	
Broker 作为 Codex App Server 的并发代理


状态机
	
Job 的 created → queued → running → completed/failed/cancelled
7. 总结

从源码层面看，codex-plugin-cc 的核心设计思想是桥接而非实现：

零 AI 推理：插件本身不调用任何 LLM，纯粹是协议桥接层
JSON-RPC over stdiolink：与 Codex App Server 的通信基于标准 JSON-RPC 2.0 协议
双传输层：直连（spawn 子进程）和 Broker（Unix socket 共享代理）两种模式自动切换
文件系统状态管理：不依赖数据库，使用 JSON 文件 + 独立 Job 文件的双写策略
进程级隔离：后台任务通过 spawn + unref + detached 实现真正的进程隔离

代码量约 2000 行 JavaScript（含 14 个库模块），零外部依赖，展示了如何用最少的代码构建一个功能完整的跨 AI 工具集成插件。

参考文献

[1] OpenAI Codex Plugin for Claude Code GitHub 仓库：https://github.com/openai/codex-plugin-cc

[2] Codex App Server 官方文档：https://developers.openai.com/codex/app-server

[3] Codex CLI 配置参考：https://developers.openai.com/codex/config-reference

[4] JSON-RPC 2.0 规范：https://www.jsonrpc.org/specification

[5] Node.js child_process 文档：https://nodejs.org/api/child_process.html

[6] Node.js net 模块文档：https://nodejs.org/api/net.html
