---
title: "聊一聊我是怎么审查 Claude Code 写的代码：记一次复刻 Redis Set 审查随笔"
source_url: "https://mp.weixin.qq.com/s/rAK4T5N-BvFBuVMLGDc0Mw"
author: "写代码的SharkChili"
published_at: "2026-06-27 09:37:52+08:00"
fetched_at: "2026-06-28T23:51:57+08:00"
fetcher: "curl-direct-html-content_noencode"
---

# 聊一聊我是怎么审查 Claude Code 写的代码：记一次复刻 Redis Set 审查随笔

- 作者: 写代码的SharkChili
- 发布时间: 2026-06-27 09:37:52+08:00
- 原文链接: https://mp.weixin.qq.com/s/rAK4T5N-BvFBuVMLGDc0Mw

---

最近关于AI编程要不要review的争议很多：一派主张AI写的代码不必再review，另一派坚持生产代码必须人工评审。

笔者的立场一向明确：要不要审、如何审，由两件事决定——

工程影响面：影响面越大，人工审查就要越深。但AI写的代码默认都得过人眼，没有"小到可以不看"的代码——一行配置就可能让整站挂掉。

一段功能代码设计的学习收益：值得学的框架与工程代码，亲手cr一遍、了解其原理、设计与编码处理细节，收益远大于直接合并了事。

能不能做到这两点——读懂、定位、判断对错——正是现代开发者和纯vibe coding抽卡派的分水岭，也是关键时刻的核心能力。

只有能准确定位到自己负责模块的代码段与细节，后续做全链路设计和实现时，方案审查才能保证准确性。

SharkChili · 禅与计算机程序设计的艺术

开源项目

mini-redis：笔者用Go从零手写的教学级Redis，适合对着源码把缓存与网络底层一行行啃透，欢迎Star和交流 · https://github.com/shark-ctrl/mini-redis

如果想进一步交流，欢迎关注笔者的公众号写代码的SharkChili，发送关键字**【加群】**添加笔者好友、进技术交流群。

### AI时代代码阅读能力分析

写到这里，笔者总会想起AI盛行前学习一套庞大技术体系的方式：

阅读官方文档，了解该技术解决什么问题

快速上手使用

结合步骤1、2的认知，拉取源代码、定位核心模块

熟悉模块的设计与实现，必要时结合调试了解处理细节

复盘、全链路归纳

分享和输出

有了AI之后这套工序被大大压缩了：对于纯业务代码、一次性脚本这类"用完即弃"的部分，强大的AI能快速定位上下文、分析并解决问题，一两句准确的提示词就够了，确实不必再走传统工序。但值得学习的框架与工程代码不在此列——这正是下文要展开的重点。

当然也要两面看。AI让开发者从繁琐工序中抽离、以更高视角把控工程，这无可厚非。但若长期脱离代码细节，就会失去对优秀设计理念的感知，后期维护时容易堆出坏味道的代码和难以偿还的技术债。

举个例子，笔者在复刻SCAN时，就针对redis db的字典底层做过一番取舍。单论遍历性能，go map因为bucket内存连续、对CPU缓存友好，其实是高于dict的。但笔者最终还是选择完全复刻redis的dict作为db基座——原因不在性能，而在SCAN的正确性语义：dict的reverse binary iteration（高位反向迭代）能保证在哈希表rehash扩缩容期间游标遍历不重不漏，这是go map给不了的。再加上它完全自实现，学习价值也远高于go map。（注意这是db基座的选择，后文set底层会基于另一套标准选go map，二者并不矛盾。）

这就是mini-redis设计与实现的日常，也是笔者眼中程序员和现代vibe coding开发者的区别。只有对技术保持足够深入的理解，才能在天马行空的创意之下，构建出真正稳定的系统。

笔者相信未来AI会飞速发展，让开发者无需再纠结过多细节，但`设计`的重要性不会变——这是多年编程思维训练沉淀下来的核心能力：小到实体的设计与封装，中到模块的拆解、复杂业务逻辑的梳理与设计模式的抽象，大到系统瓶颈在既有条件下的优化。

所以回到本节的话题——AI时代该如何阅读代码。抛开纯业务代码不谈，笔者更想强调的是那些值得学习的框架和工程代码：这种代码笔者还是建议把AI当助手用。代码定位、模块梳理、调试理解都自己先过一遍，输出自己的见解，只在一些细节语法上结合AI做分析。

然后再让AI对这段代码做一轮梳理、探讨与纠错。只有这种主动学习、反馈验收的方式，才能保住开发者在核心实现上的真正收益。

这其实是好事。就拿mini-redis来说，笔者过去梳理redis源码时，最喜欢揣摩作者的设计意图、吸收里面优秀的设计理念，可这一步要翻大量文章，大半时间都耗在无效检索和信息筛选上。有了AI之后，源码阅读、设计意图整理、搜索引擎检索这些活完全可以交给它自主完成，最后再和笔者做一次完整的学习反馈与订正。可以看到，结合AI，我们能更纯粹地回归学习本身——把繁琐的信息过滤与整理丢给AI，自己专注在主动思考与反馈上，高效地走完一次完整的学习。

### 如何审查AI生成代码

无论过去还是现在，开发者最好的学习方式都是阅读源代码，AI时代也不例外。以笔者本次的redis set复刻为例，它跑在claude code的learning模式下——这个模式里AI只搭骨架、写模板代码，核心逻辑留给开发者基于上下文自己填，让你边写边学。所以它绝不是"轻度编码"：AI搭好架子之后，真正的设计取舍和细节审查仍要自己一行行过。

而这只是完成学习闭环的第一步。我们借AI完成的只是最核心的模块实践，整条指令链路还没做过一次完整的复盘与审查。AI时代学习源代码最好的方式，就是和AI做批判式对话：先抛出自己的见解，再让AI用可运行的代码去印证或证伪，不断摩擦，最终把正确的理念建立起来。

审查AI代码的内核，和古法编程时代其实一样：从整体到具体，从思路猜设计意图，从编码细节提疑问，遇到不可取或陌生的概念，就让AI主动编码印证。但有一点是AI时代新增的负担——审AI代码比审人写的更要防"看起来对、实则幻觉"：AI很擅长写出语法漂亮、逻辑自洽却语义错误的代码，读着顺不代表它对，必须用测试和压测把它钉死。

具体审什么？笔者通常盯这几个维度：

正确性与边界：逻辑是否符合预期，空集合、重复元素、类型不符等边界有没有处理。

设计与数据结构选型：底层结构选得对不对（如intset位宽、dict还是go map），有没有性能隐患。

代码整洁度：封装是否语义化、注释是否到位。AI时代写代码的时间变少了，但可读性依然重要——只有足够语义化的封装和注释，才能让人机协作时尽快获取上下文、准确维护系统，这需要一些clean code的知识储备。

下面就按这几个维度，逐一走查本次redis set复刻的核心实现。

### 详解redis set集合复刻代码审查

#### 宏观思路

前面用大量篇幅铺垫了AI时代下代码掌控的核心能力。接下来，我们就以本次的redis set复刻为例，做一次详细的审查。需要说明的是，这个功能模块除了少数核心部分是笔者实现的以外，其他架构搭建、语法转译与指令复刻都是claude code独立完成的。

笔者当时粗略地读了一下，发现其中有不少学习价值，才打算专门写一篇文章，分享审查AI代码时的一些技巧。

对于宏观思路这一环节，因为笔者在古法编程时代就已经奠定了mini-redis的架构，即通过goroutine-per-connection理念，接收客户端的请求，通过channel方式提交到server端进行串行处理，以做到redis单线程的效果。

所以对于指令的复刻也是模板化工序：

命令行模板声明要实现的指令

定义核心数据结构

编写各个指令函数

这一点AI结合上下文完成得很好，如下所示，在命令声明的位置，它准确地把本次要复刻的指令填充到了模板里：

```

var redisCommandTable = []redisCommand{
//......
{name: "SADD", proc: saddCommand, arity: -3, sflag: "wmF", flag: 0},
{name: "SREM", proc: sremCommand, arity: -3, sflag: "wF", flag: 0},
{name: "SMEMBERS", proc: smembersCommand, arity: 2, sflag: "r", flag: 0},
{name: "SISMEMBER", proc: sismemberCommand, arity: 3, sflag: "rF", flag: 0},
{name: "SCARD", proc: scardCommand, arity: 2, sflag: "rF", flag: 0},
{name: "SPOP", proc: spopCommand, arity: 2, sflag: "wRs", flag: 0},
{name: "SINTER", proc: sinterCommand, arity: -2, sflag: "rS", flag: 0},
{name: "SINTERSTORE", proc: sinterstoreCommand, arity: -3, sflag: "wm", flag: 0},
{name: "SUNION", proc: sunionCommand, arity: -2, sflag: "rS", flag: 0},
{name: "SUNIONSTORE", proc: sunionstoreCommand, arity: -3, sflag: "wm", flag: 0},
{name: "SDIFF", proc: sdiffCommand, arity: -2, sflag: "rS", flag: 0},
{name: "SDIFFSTORE", proc: sdiffstoreCommand, arity: -3, sflag: "wm", flag: 0},
//......
}

```

指令填充部分，AI也非常准确地结合既有上下文、按redis的理念复刻：所有入参都以`redisClient`指针的方式，把参数和状态传到指令函数处理。这些细节AI都能结合上下文很好地完成，所以针对mini-redis这类工程，笔者都是一笔带过：

```
func saddCommand(c *redisClient) {
//......
}

```

#### 整数集合的设计

我们都知道redis是内存数据库，所有数据结构都存放在宝贵的内存里。结合CPU缓存的设计理念，连续存放的数据结构能更好地利用缓存行(cache line)——一次加载就带进相邻的多个元素，让查找和遍历的cache miss更少，这也是提升redis吞吐量的关键。

查看redis set源码会发现，纯数字的情况下用的是intset这种整数集合数组：借助数组的内存连续性，再结合整数类型占用空间小的特点，优先用数组而非哈希字典，确保添加、查找、删除时数据都连续命中缓存行，提升执行效率。

按照redis对数据结构的极致设计，为让数据尽可能多地缓存在CPU cache里处理，就算是整数集合也分三种位宽：16位、32位、64位。这一点claude code的常量声明确实到位，所以这块审查通过：

```

const (
INTSET_ENC_INT16 = 2
INTSET_ENC_INT32 = 4
INTSET_ENC_INT64 = 8
)

```

然后是数据结构的设计：整体结构、变量名、核心字段都在，针对数组大小不可变的特性，也很好地用go语言的切片做了实现。 唯一的设计不足是contents统一用int64存储——无论数字大小都按int64(8字节)存，对于本可用2、4字节装下的整数，白白浪费了内存，还可能拖累整数集合的处理性能：

```
type intset struct {
encoding int     // 当前最大位宽(INTSET_ENC_INT16/32/64)
length   int     // 元素个数
contents []int64 // 升序整数数组
}

```

于是笔者把这点要求提交给AI：

```
redis整数集合存在3个位宽，默认情况下会根据数字的位宽决定整数集合的类型，确保尽可能避免非必要的内存空间浪费来提升程序的局部性，而我的整数集合则是统一采用int64，这一点我个人认为不符合设计。

我希望你能够参考redis一样，默认情况下设置为int16的数组空间，按需升级位宽。你的看法是什么?给我你的意见,如果不确定,我们也可以尝试把int16数字分别存到int16和int64数组中,压测其添加 删除 查询效率

```

有了AI，这种返工和全局重构的成本大大降低，我们只需保证设计方向是对的。读者可以看看笔者和AI的沟通技巧。除了提出意见、和它对等沟通，为避免主观臆断造成错误改进，笔者还会主动问它的看法。为进一步杜绝幻觉导致的错误推断，还会让它用详细的压测来证明观点。

AI结合自己的推断后，建议用压测来定最终决策：

经过和AI讨论并跑了一轮压测，从以下三个角度做了全方位测试：

build：从空集合批量插入全部元素，建好整个intset。测的是「插入 + 二分定位 + 移位 + 扩容」的综合成本，配合 -benchmem还能反映最终的内存占用。

Churn(搅动)：在已建好的集合上反复Remove(v)紧接Add(v)同一个值，集合大小不变。测的是单次增删的稳态成本——尤其是元素在数组里来回搬移(memmove)的开销。

Search：纯二分查找，只读不改。

输出报告如下。综合来看，笔者的审查意见确实成立，于是让AI做了深度重构，并结合之前的单元测试做回归。

等待片刻，AI结合审查结果完成了代码修改。笔者这里直接挑出核心代码段，可以看到，所有整数升级都严格按位宽动态调整：

```
/* intsetUpgrade 把底层存储升级到更宽的 newenc。
* 逐个把现有元素从旧切片搬到新切片(预留 +1 容量,紧接着的插入免再次扩容),
* 旧切片置 nil 交给 GC。升级后再走正常的二分插入,无需 Redis 那种
* 「prepend/append 端点捷径」—— Go 切片插入已足够简洁,正确性优先。
*/
func intsetUpgrade(is *intset, newenc int) {
switch newenc {
case INTSET_ENC_INT64:
nc := make([]int64, is.length, is.length+1)
for i := 0; i < is.length; i++ {
nc[i] = intsetGet(is, i)
}
is.c64, is.c32, is.c16 = nc, nil, nil
case INTSET_ENC_INT32:
nc := make([]int32, is.length, is.length+1)
for i := 0; i < is.length; i++ {
nc[i] = int32(intsetGet(is, i))
}
is.c32, is.c16 = nc, nil
}
is.encoding = newenc
}

```

这里还要补充一个容易被忽略的细节：intset转哈希表其实有两个触发条件，一个是成员里出现了非整数，另一个是元素个数超过阈值（对应redis的`set-max-intset-entries`，默认512）。前者好理解，后者的原因是intset的查找是有序数组二分、复杂度O(log n)，元素越多越慢，而哈希表是O(1)。

这两个触发条件在`setTypeAdd`里都落了地——插入的是整数就走intset，一旦元素数越过`REDIS_SET_MAX_INTSET_ENTRIES`（512）就转哈希表，而成员一旦不是整数，则直接整体转HT再走插入：

```
/* setTypeAdd 向集合添加成员,返回 1=新增 0=已存在。
* 内部处理编码升级:intset 下若成员非整数、或元素数超阈值,自动转 HT。
*/
func setTypeAdd(subject *robj, value *robj) int {
if subject.encoding == REDIS_ENCODING_HT {
m := (*subject.ptr).(map[string]struct{})
key := setMemberKey(value)
if _, exists := m[key]; exists {
return 0
}
m[key] = struct{}{}
return 1
}

/* intset 编码 */
if llval, ok := setObjectGetIntegerValue(value); ok {
is := (*subject.ptr).(*intset)
added := intsetAdd(is, llval)
// 元素数超过阈值 → 升级成 HT
if added == 1 && is.length > REDIS_SET_MAX_INTSET_ENTRIES {
setTypeConvert(subject)
}
return added
}

/* 成员非整数,intset 容不下 → 先整体转 HT,再走 HT 分支插入 */
setTypeConvert(subject)
return setTypeAdd(subject, value)
}

```

需要强调的是，512并不是一个精确的"性能拐点"，而是redis在内存与查找速度之间取的经验阈值——intset紧凑省内存，哈希表查找快但更占空间。笔者顺手写了个二分查找vs哈希定位的规模压测来印证这件事（代码在mini-redis的`intset_vs_hash_bench_test.go`）：

```
规模n     intset二分      map[int64]      map[string](真实HT)
64        9.9 ns         3.8 ns         6.8 ns
512       15.0 ns        3.8 ns         9.9 ns
1024      16.8 ns        4.0 ns         8.4 ns
4096      23.2 ns        3.8 ns         8.0 ns
16384     27.5 ns        3.9 ns         8.2 ns
65536     26.7 ns        4.3 ns         7.9 ns

```

可以看到，intset二分的耗时随规模一路上涨（9.9→27.5 ns），而哈希定位基本恒定。规模越大，哈希表的优势越明显。所以元素一多就转哈希表，是用一点内存换查找的稳定性。

#### 字典的实现

上文提到set本质是不重复的元素集合，所以在非整数类型时一律用哈希表实现，此时就涉及dict和go map之间的抉择。结合笔者对这两个数据结构的理解：原生dict通过数组+链表(拉链法)再配合渐进式rehash，保证良好的散列与读写效率，但顺序、范围遍历只能低效地逐桶扫描。

对照原生C语言dict的实现可以看到，它的顺序迭代就是不断推进、遍历非空桶里的链表元素，直到走完：

```
dictEntry *dictNext(dictIterator *iter)
{
while (1) {
//如果entry为空,就基于数组索引定位到非空的
if (iter->entry == NULL) {
//......
//指向自增后的index,不断循环得到非空元素
iter->entry = ht->table[iter->index];
} else {
//如果元素不为空,则说明该元素迭代过,直接指向下一个元素
iter->entry = iter->nextEntry;
}
//迭代器指向输出元素的后继元素,并返回输出元素
if (iter->entry) {
/* We need to save the 'next' here, the iterator user
* may delete the entry we are returning. */
iter->nextEntry = iter->entry->next;
return iter->entry;
}
}
return NULL;
}

```

而go map底层是一整块连续的bucket数组。这样即便出现和dict类似的未命中，靠内存连续性，CPU也能直接在缓存里取到相邻bucket继续扫描，而不必像dict那样顺着指针去内存里取非连续的下一个元素：

```
/go:linkname mapiternext
func mapiternext(it *hiter) {
h := it.h
//......省略 race 检测
if h.flags&hashWriting != 0 {
fatal("concurrent map iteration and map write") //遍历中并发写直接 panic
}
t := it.t
bucket := it.bucket
b := it.bptr
i := it.i

next:
if b == nil {
//......grow 期间还要判定走 old 还是 new bucket,此处省略
//bucket 数组整块连续,直接按索引定位下一个 bucket
b = (*bmap)(add(it.buckets, bucket*uintptr(t.BucketSize)))
bucket++
//......走到末尾则回绕
i = 0
}
//在当前 bucket 内联的 8 个槽位里连续扫描
for ; i < abi.MapBucketCount; i++ {
offi := (i + it.offset) & (abi.MapBucketCount - 1)
if isEmpty(b.tophash[offi]) {
continue //跳过空槽
}
//......按偏移取出 key、elem(含 grow 期间搬迁判定,略)
it.bucket = bucket
it.i = i + 1
return //找到一个就返回,下次从这里续扫
}
b = b.overflow(t) //本桶扫完,顺着溢出桶链继续
i = 0
goto next
}

```

所以在set底层的技术选型上，笔者也用AI跑了一轮压测，结果如下。可以看到：散列良好时，两者的读(IsMember)性能相差无几。但写入(Add)上，dict每个元素都要单独分配链表节点、还要分摊渐进式rehash的成本，而go map把元素内联存在bucket里、分配次数少得多，所以写入明显更快。遍历(Iterate)上，go map以bucket为单位连续加载进CPU cache，局部性更好。两方面叠加，go map整体优于dict，所以set底层笔者最终选了go map：

```
goos: darwin
goarch: arm64
pkg: mini-redis
cpu: Apple M4
BenchmarkSet
BenchmarkSet/Add/dict
BenchmarkSet/Add/dict-10                61   20419942 ns/op
BenchmarkSet/Add/gomap
BenchmarkSet/Add/gomap-10              171    6888581 ns/op
BenchmarkSet/IsMember/dict
BenchmarkSet/IsMember/dict-10     23638764         49.47 ns/op
BenchmarkSet/IsMember/gomap
BenchmarkSet/IsMember/gomap-10    25525194         45.56 ns/op
BenchmarkSet/Iterate/dict
BenchmarkSet/Iterate/dict-10          1452     746189 ns/op
BenchmarkSet/Iterate/gomap
BenchmarkSet/Iterate/gomap-10         2000     595200 ns/op
PASS

```

set类型的创建函数如下，即创建一个key为string、value为空结构体的map：

```
/* createSetObject 创建一个空 set 对象,底层用 go 原生 map 作哈希表编码。
* key 存成员,value 用空结构体 struct{}(零字节),只靠 key 表达"在不在"。
*/
func createSetObject() *robj {
m := map[string]struct{}{}       // 成员集合:key=成员, value=空结构体
i := interface{}(m)              // 包成 interface{} 以便塞进 robj.ptr
o := createObject(REDIS_SET, &i) // 对象类型标记为 REDIS_SET
o.encoding = REDIS_ENCODING_HT   // 编码标记为哈希表(HT)
return o
}

```

#### SADD指令实现

dict结构已经理清了，这里就不赘述，直接从set的常见指令看起。第一个是添加指令SADD——支持一次添加一个或多个不重复元素，整体思路为：

参数解析

查看set是否存在，不存在则按第一个元素的类型，选择整数集合或哈希表两种编码之一来创建

添加元素，返回实际新增的个数（有些元素之前可能已存在）

整体逻辑清晰，以现有的模型能力，这种跨语言的功能迁移很容易做到：

```

/* saddCommand: SADD key member [member ...]
* 返回实际新增的成员个数(已存在的不计)。
*/
func saddCommand(c *redisClient) {
set := lookupKeyWrite(c.db, c.argv[1])
// 仅当 key 存在且类型不符时才报错;nil 表示 key 不存在(稍后创建)
// 注意:本项目的 checkType 非 nil 安全,必须先判 set != nil 再调用
if set != nil && checkType(c, set, REDIS_SET) {
return
}
// 不存在则按首个成员类型选择初始编码
if set == nil {
set = setTypeCreate(c.argv[2])
dbAdd(c.db, c.argv[1], set)
}

var added int64
var i uint64
for i = 2; i < c.argc; i++ {
added += int64(setTypeAdd(set, c.argv[i]))
}
addReplyLongLong(c, added)
}

```

整体思路没问题。具体看实现：判断首个成员类型这一步，AI用的是"能否解析成int64"，作为整数判断是没问题的。

```

/* setObjectGetIntegerValue 尝试从成员 robj 中取出 int64。
* 成员可能是 EMBSTR 字符串(ptr 为 string)或 INT 编码整数(ptr 为 int64)。
* 成功返回 (值, true);否则 (0, false)。
*/
func setObjectGetIntegerValue(o *robj) (int64, bool) {
switch v := (*o.ptr).(type) {
case int64:
return v, true
case string:
if n, err := strconv.ParseInt(v, 10, 64); err == nil {
return n, true
}
}
return 0, false
}

```

我们要关心的是：判定为整数、创建整数集合后，有没有按指定位宽存储元素——这种细节往往是AI容易遗漏的。它不会造成逻辑错误，但会让原本该有的性能优化丢失。

笔者很快定位到整数类型的添加操作，仔细审查了一下。判断数字用的是能否解析成int64，这能覆盖intset支持的全部整数范围（intset最宽也就是int64）。超出int64的数会被当字符串、走哈希表编码，这正是我们想要的。

笔者细看了intsetValueEncoding，它能准确地按取值范围确定位宽，后面的switch分支也正确地按位宽把元素存进整数集合，所以这段逻辑审查通过：

```
/* intsetAdd 向 intset 添加 val。
* 返回 1=新增成功,0=已存在(幂等,集合语义)。
*/
func intsetAdd(is *intset, val int64) int {
// 新值需要更宽编码时,先整体升级位宽,再按统一编码插入
if newenc := intsetValueEncoding(val); newenc > is.encoding {
intsetUpgrade(is, newenc)
}
found, pos := intsetSearch(is, val)
if found {
return 0
}
// 在 pos 处插入并保持升序:先扩容一位,再把 [pos:] 后移
switch is.encoding {
case INTSET_ENC_INT64:
is.c64 = append(is.c64, 0)
copy(is.c64[pos+1:], is.c64[pos:])
is.c64[pos] = val
case INTSET_ENC_INT32:
is.c32 = append(is.c32, 0)
copy(is.c32[pos+1:], is.c32[pos:])
is.c32[pos] = int32(val)
default:
is.c16 = append(is.c16, 0)
copy(is.c16[pos+1:], is.c16[pos:])
is.c16[pos] = int16(val)
}
is.length++
return 1
}

```

其余指令也都是严格按这套数据结构做搜索、添加、删除，我们都能通过代码调测的方式验收和审查，所以SREM、SMEMBERS、SCARD、SPOP这些基础指令就不再赘述了。

#### SINTER实现审查

对于集合运算，set的sunion、sdiff等都是基于哈希表的O(1)命中、或整数集合的二分查找来判断元素是否存在，再据此构建最终的运算结果。了解哈希算法的读者对这块应该不陌生。

考虑到篇幅，这里挑一个能覆盖集合运算核心操作的sinter指令，它用于找出多个set的共有元素。

例如：set1包含a、b、c，set2包含b、c，set3包含c、d、e、f，sinter的工作步骤为：

选出最小的集合set2

以小表驱动的方式遍历其他集合

如果其他set都包含该元素，就存入结果集

对应代码输出结果如下，整体实现基本保留了redis的原汁原味，可以看到它也很好地做了"任一集合为空就直接返回空交集"的提前短路判断。

以最小集合为驱动遍历元素，判断其他set是否包含元素，然后存入结果集中，整体思路和数据结构使用都是正确的：

```

/* sinterGenericCommand 计算 argv[begin..argc) 的交集。
* dstkey != nil 时存入 dstkey 并回复元素数(SINTERSTORE);否则 multibulk 回复(SINTER)。
*
* 关键优化:以最小集合为"驱动"遍历 —— 交集大小 ≤ 最小集合大小,
* 从最小集合出发才能让逐元素查其他集合的次数最少。
*/
func sinterGenericCommand(c *redisClient, dstkey *robj, begin uint64) {
sets := collectSetObjects(c, begin)
if sets == nil {
return // WRONGTYPE already replied
}
// 任意一个集合不存在/为空 → 交集必为空
for _, s := range sets {
if s == nil {
replyOrStoreEmptyResult(c, dstkey)
return
}
}
// 选最小集合作为驱动
driverIdx := 0
for i := 1; i < len(sets); i++ {
if setTypeSize(sets[i]) < setTypeSize(sets[driverIdx]) {
driverIdx = i
}
}

result := map[string]struct{}{}
it := setTypeInitIterator(sets[driverIdx])
for {
ele, ok := setTypeNext(it)
if !ok {
break
}
//如果另外的set都包含该元素,则存入结果集中
if isMemberOfAll(sets, driverIdx, ele) {
result[setMemberKey(ele)] = struct{}{}
}
}
outputSetResult(c, dstkey, result)
}

```

### 指令全流程测试与复刻技巧

代码复刻完成后，人工验收是AI编码的最后一道闸门。笔者看到网上很多工程师用harness或各种手段让AI自动完成功能验收，但笔者还是会亲手补一道人工闸门——围绕完整的功能链路，构建一套充分覆盖的测试用例，通过终端在真实业务环境里逐条操作验收。这么做有三层收益。一是辅助自己调测、真正搞清这个需求到底要验收什么。二是保证后续能从功能维度快速定位、排查问题。三是顺手发现一些交互上可以优化的点。

下面是笔者这次的测试清单，原始是随手写的草稿，这里整理成可复核的形式。

### 小结

这次复刻走完了一条完整的链路：完整读源码、调测核心逻辑、从宏观到细节走查验收并优化。回头看，AI没有让笔者的能力退化，反而成了把理解推得更深的杠杆——前提是自己始终在审、在判断，而不是把代码丢给它就完事。

这背后其实有个朴素的道理：自动化最大的反讽，是它接管得越多，你越容易丢掉那些"它搞不定时才真正救命"的能力。所以越是AI时代，笔者越看重"自己先读、先怀疑、再让AI印证"这套古法习惯。它前期慢，但会复利在你的判断力上——而判断力，恰恰是AI替不了你的那部分。

SharkChili · 禅与计算机程序设计的艺术

开源项目

mini-redis：笔者用Go从零手写的教学级Redis，适合对着源码把缓存与网络底层一行行啃透，欢迎Star和交流 · https://github.com/shark-ctrl/mini-redis

如果想进一步交流，欢迎关注笔者的公众号写代码的SharkChili，发送关键字**【加群】**添加笔者好友、进技术交流群。

### 参考

mini-redis（笔者手写的教学版Redis）： https://github.com/shark-ctrl/mini-redis

Redis整数集合源码intset.c： https://github.com/redis/redis/blob/unstable/src/intset.c

Redis字典源码dict.c： https://github.com/redis/redis/blob/unstable/src/dict.c

Redis集合类型源码t_set.c： https://github.com/redis/redis/blob/unstable/src/t_set.c

Go runtime map源码runtime/map.go： https://github.com/golang/go/blob/master/src/runtime/map.go
