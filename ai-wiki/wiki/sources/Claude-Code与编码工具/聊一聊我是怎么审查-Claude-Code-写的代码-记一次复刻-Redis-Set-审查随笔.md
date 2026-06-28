---
title: "聊一聊我是怎么审查 Claude Code 写的代码：记一次复刻 Redis Set 审查随笔"
type: source
date: 2026-06-28
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/rAK4T5N-BvFBuVMLGDc0Mw"
author: "写代码的SharkChili"
published_at: "2026-06-27 09:37:52+08:00"
ingested_at: 2026-06-28
tags:
  - claude-code
  - ai-coding
  - code-review
  - redis
  - mini-redis
related_entities:
  - "[[Claude-Code]]"
  - "[[Agentic-Engineering]]"
  - "[[Harness-Engineering]]"
related_topics:
  - "[[Agentic-Engineering-主题]]"
---

# 聊一聊我是怎么审查 Claude Code 写的代码：记一次复刻 Redis Set 审查随笔

## 一句话概括

这篇文章用 Claude Code learning 模式复刻 Redis Set 的案例说明：AI 可以搭骨架、迁移模板和生成候选实现，但真正的工程收益来自人类对数据结构选择、边界条件、性能语义和全链路测试的批判式审查。

## 实践内容

### AI 生成代码审查维度

文章把审查 AI 生成代码的内核拆成三类问题：

- 正确性与边界：逻辑是否符合预期，空集合、重复元素、类型不符等边界有没有处理。
- 设计与数据结构选型：底层结构选得对不对，例如 intset 位宽、dict 还是 Go map，有没有性能隐患。
- 代码整洁度：封装是否语义化、注释是否到位，让人机协作时能快速获得上下文并准确维护系统。

### Redis Set 命令模板

```go
var redisCommandTable = []redisCommand{
//......
{name: "SADD", proc: saddCommand, arity: -3, sflag: "wmF", flag: 0},
{name: "SREM", proc: sremCommand, arity: -3, sflag: "wF", flag: 0},
{name: "SMEMBERS", proc: smembersCommand, arity: 2, sflag: "r", flag: 0},
{name: "SISMEMBER", proc: sismemberCommand, arity: 3, sflag: "rF", flag: 0},
{name: "SCARD", proc: scardCommand, arity: 2, sflag: "rF", flag: 0},
{name: "SPOP", proc: spopCommand, arity: 2, sflag: "wRs", flag: 0},
{name: "SINTER", proc: sinterCommand, arity: -2, sflag: "rS", flag: 0},
{name: "SINTERSTORE", proc: sinterstoreCommand, arity: -3, sflag: "wm", flag: 0},
{name: "SUNION", proc: sunionCommand, arity: -2, sflag: "rS", flag: 0},
{name: "SUNIONSTORE", proc: sunionstoreCommand, arity: -3, sflag: "wm", flag: 0},
{name: "SDIFF", proc: sdiffCommand, arity: -2, sflag: "rS", flag: 0},
{name: "SDIFFSTORE", proc: sdiffstoreCommand, arity: -3, sflag: "wm", flag: 0},
//......
}
```

### SADD 的关键审查点

```go
/* saddCommand: SADD key member [member ...]
* 返回实际新增的成员个数(已存在的不计)。
*/
func saddCommand(c *redisClient) {
set := lookupKeyWrite(c.db, c.argv[1])
// 仅当 key 存在且类型不符时才报错;nil 表示 key 不存在(稍后创建)
// 注意:本项目的 checkType 非 nil 安全,必须先判 set != nil 再调用
if set != nil && checkType(c, set, REDIS_SET) {
return
}
// 不存在则按首个成员类型选择初始编码
if set == nil {
set = setTypeCreate(c.argv[2])
dbAdd(c.db, c.argv[1], set)
}

var added int64
var i uint64
for i = 2; i < c.argc; i++ {
added += int64(setTypeAdd(set, c.argv[i]))
}
addReplyLongLong(c, added)
}
```

### intset 位宽与升级

```go
/* intsetAdd 向 intset 添加 val。
* 返回 1=新增成功,0=已存在(幂等,集合语义)。
*/
func intsetAdd(is *intset, val int64) int {
// 新值需要更宽编码时,先整体升级位宽,再按统一编码插入
if newenc := intsetValueEncoding(val); newenc > is.encoding {
intsetUpgrade(is, newenc)
}
found, pos := intsetSearch(is, val)
if found {
return 0
}
// 在 pos 处插入并保持升序:先扩容一位,再把 [pos:] 后移
switch is.encoding {
case INTSET_ENC_INT64:
is.c64 = append(is.c64, 0)
copy(is.c64[pos+1:], is.c64[pos:])
is.c64[pos] = val
case INTSET_ENC_INT32:
is.c32 = append(is.c32, 0)
copy(is.c32[pos+1:], is.c32[pos:])
is.c32[pos] = int32(val)
default:
is.c16 = append(is.c16, 0)
copy(is.c16[pos+1:], is.c16[pos:])
is.c16[pos] = int16(val)
}
is.length++
return 1
}
```

### SINTER 的小表驱动

```go
/* sinterGenericCommand 计算 argv[begin..argc) 的交集。
* dstkey != nil 时存入 dstkey 并回复元素数(SINTERSTORE);否则 multibulk 回复(SINTER)。
*
* 关键优化:以最小集合为"驱动"遍历 —— 交集大小 <= 最小集合大小,
* 从最小集合出发才能让逐元素查其他集合的次数最少。
*/
func sinterGenericCommand(c *redisClient, dstkey *robj, begin uint64) {
sets := collectSetObjects(c, begin)
if sets == nil {
return // WRONGTYPE already replied
}
// 任意一个集合不存在/为空 -> 交集必为空
for _, s := range sets {
if s == nil {
replyOrStoreEmptyResult(c, dstkey)
return
}
}
// 选最小集合作为驱动
driverIdx := 0
for i := 1; i < len(sets); i++ {
if setTypeSize(sets[i]) < setTypeSize(sets[driverIdx]) {
driverIdx = i
}
}
}
```

## 摘录

> 审查AI代码的内核，和古法编程时代其实一样：从整体到具体，从思路猜设计意图，从编码细节提疑问，遇到不可取或陌生的概念，就让AI主动编码印证。但有一点是AI时代新增的负担——审AI代码比审人写的更要防"看起来对、实则幻觉"：AI很擅长写出语法漂亮、逻辑自洽却语义错误的代码，读着顺不代表它对，必须用测试和压测把它钉死。

> 代码复刻完成后，人工验收是AI编码的最后一道闸门。笔者看到网上很多工程师用harness或各种手段让AI自动完成功能验收，但笔者还是会亲手补一道人工闸门——围绕完整的功能链路，构建一套充分覆盖的测试用例，通过终端在真实业务环境里逐条操作验收。这么做有三层收益。一是辅助自己调测、真正搞清这个需求到底要验收什么。二是保证后续能从功能维度快速定位、排查问题。三是顺手发现一些交互上可以优化的点。

## 涉及实体

- [[Claude-Code]] —— 本文案例运行在 Claude Code learning 模式下，强调 AI 编码工具适合承担骨架、模板和迁移工作，但不能替代设计判断。
- [[Agentic-Engineering]] —— 文章把验证能力、源码阅读和人类判断力放在 AI 生成能力之上，是 Agentic Engineering 中“验证瓶颈”的具体案例。
- [[Harness-Engineering]] —— 自动化测试、压测和人工闸门共同构成审查闭环，与 Harness 的工程化约束目标一致。

## 涉及主题

- [[Agentic-Engineering-主题]]

## 我的评注

这篇的价值不在 Redis Set 本身，而在它把“AI 写得很顺”与“代码真的站得住”分开了：命令表、跨语言模板迁移、SADD/SINTER 这些 AI 可以做得很快，但 intset 位宽、dict 与 Go map 的取舍、集合运算的小表驱动、功能链路测试这些仍然要求人能读懂并提出可证伪的问题。它补上了知识库里偏工具架构文章之外的另一类证据：Agentic Engineering 的核心护城河不是生成速度，而是审查、验证和形成判断。
