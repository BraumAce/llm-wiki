# 鹅厂面试官：“SELECT * 一定导致索引失效？” 我回：“不一定”，他笑：“那公司为什么还要禁用？”

- 作者: JavaGuide
- 发布时间: 2026年3月9日 14:33
- 原文链接: https://mp.weixin.qq.com/s/6lzPH4u3HnNjVlFrckNDhw

---

刚坐下不到十分钟，鹅厂这位面试官就推了推眼镜，指着我简历上那句“精通 MySQL 调优”，嘴角露出一抹意味深长的微笑。

“既然你提到索引优化，”他抛出了一个看似基础却暗藏杀机的坑，“那你说说，
```
SELECT *
```
到底会不会导致索引失效？”

我心里咯噔一下，这题我会，但我知道，如果只回答“不一定”，那这面基本就凉了。

“在绝大多数八股文里，大家都说
```
SELECT *
```
是万恶之源，会直接导致全表扫描。”我稍微停顿，观察他的反应，“但实际上，MySQL 的优化器比我们想象中要聪明。它不选索引，不是因为你写了星号，而是因为它觉得回表的代价太大了。”

面试官眉头一挑：“既然它能自己权衡成本，不一定会失效，那你为什么还要在公司开发规范里严禁使用
```
SELECT *
```
？”

这篇文章 Guide 就来详细总结一下常见的导致索引失效的情况，非常全面，后端面试经常会问到。

Java 面试 & 后端通用面试指南
（Github 收获
155K+
Star，
600+
位贡献者共同参与维护和完善）：
JavaGuide 网站
（
javaguide.cn
）。

[图片: 图片]

多提一嘴，AI 时代了，建议面试官少问一些这类问题，MySQL 索引相关的面试题准备真的费脑子，建议多考察项目和场景题。


SELECT * 查询（成本权衡）

核心定义
：
```
SELECT *
```
本身
不会直接导致索引失效
。它是一种“非覆盖索引”查询，如果
```
WHERE
```
条件命中了索引，索引依然会被初步考虑。


回表成本决策
：当查询需要的字段不在索引树中时，MySQL 必须拿着主键回聚簇索引查找整行数据（回表）。优化器会对比“索引扫描 + 回表”与“直接全表扫描”的成本。如果查询结果占总数据量的比例较高（通常阈值在 20%~30%），优化器会认为全表扫描的顺序 IO 效率高于回表的随机 IO，从而
主动放弃索引
。


落地建议
：严禁在生产环境无脑使用
```
SELECT *
```
。应遵循
覆盖索引
原则，只查询必要的字段，将
```
Extra
```
列从空值优化为
```
Using index
```
，从而彻底规避回表开销。


注意：后文使用
```
SELECT *
```
仅仅是为了演示方便。

违背最左前缀原则

核心定义
：最左前缀匹配原则指的是在使用联合索引时，MySQL 会根据索引中的字段顺序，从左到右依次匹配查询条件中的字段。如果查询条件与索引中的最左侧字段相匹配，那么 MySQL 就会使用索引来过滤数据。


范围查询的中断效应
：在联合索引中，如果某个字段使用了范围查询（如
、
、
```
BETWEEN
```
、前缀匹配
```
LIKE 'abc%'
```
），该字段之前的列可以正常匹配并用于索引定位，但
该字段之后的列将无法利用索引进行快速定位
。这是因为在 B+Tree 索引结构中，只有当前导列相等时，后续列才是有序的。一旦前导列变成一个范围，后续列在整个扫描区间内就是无序的，因此无法进行二分查找定位。


索引跳跃扫描 (ISS)
：MySQL 8.0.13 引入了
索引跳跃扫描（Index Skip Scan）
，允许在缺失最左前缀时，通过枚举前导列的所有 Distinct 值来跳跃扫描后续索引树。


版本避坑指南
：在
MySQL 8.0.31
中，ISS 存在严重 Bug（
[Bug
#109145
]
[1]
），在跨 Range 读取时未清理陈旧的边界值，会导致查询直接
丢失数据
。


落地建议
：ISS 在前导列基数（Cardinality）极低（如性别、状态枚举）时性能最优，因为优化器需要枚举前导列的所有 distinct 值逐一跳跃扫描——distinct 值越少，跳跃次数越少。但"基数低"本身并非官方限制条件，优化器会综合评估成本决定是否触发 ISS。在生产环境中，
严禁依赖 ISS 来弥补糟糕的索引设计
，必须通过调整联合索引顺序或补齐前导列条件来满足最左前缀。


Index Skip Scan 失败路径图：

[图片: 图片]

失效示例：

```
-- 索引：(sname, s_code, address)SELECT * FROM students WHERE s_code = 1;                  -- 跳过最左列 sname，索引失效SELECT * FROM students WHERE sname = 'A' AND address = 'Shanghai'; -- 跳过中间列，仅 sname 走索引（索引下推 ICP 可优化过滤）SELECT * FROM students WHERE sname = 'A' AND s_code > 1 AND address = 'Shanghai'; -- 范围查询后，address 无法用于定位，仅用于过滤
```
在索引列上进行计算、函数或类型转换

核心定义
：索引 B+Tree 存储的是字段的
原始值
。一旦在
```
WHERE
```
条件中对索引列应用了函数（如
```
ABS()
```
、
```
DATE()
```
）或算术运算，该列的值在逻辑上发生了改变。


有序性破坏效应
：由于 B+Tree 是基于原始值排序的，经过函数处理后的结果在索引树中是
无序
的。数据库无法利用二分查找快速定位，只能被迫进行全表扫描。


函数索引
：MySQL 8.0 支持
函数索引
（Functional Index），可针对计算后的值建索引，但使用场景有限，首选还是优化 SQL 写法。


失效示例：

```
SELECT * FROM students WHERE height + 1 = 170;            -- 对索引列进行计算SELECT * FROM students WHERE DATE(create_time) = '2022-01-01'; -- 对索引列使用函数
```
优化建议：

```
SELECT * FROM students WHERE height = 169;                -- 将计算移到等号右边SELECT * FROM students WHERE create_time BETWEEN '2022-01-01 00:00:00' AND '2022-01-01 23:59:59';
```
LIKE 模糊查询以通配符开头

核心定义
：
```
LIKE
```
查询必须以具体字符开头才能利用索引有序性，例如
```
WHERE sname LIKE 'Guide%';
```
。这是因为 B+ 树是从左到右排序的。前缀通配符（
```
%
```
）破坏了有序性，无法定位起始点。


前缀通配符的失效机制
：如果以
```
%
```
开头（如
```
'%abc'
```
），由于索引是按字符从左到右排序的，前缀不确定意味着可能出现在索引树的任何位置，导致无法定位搜索区间的起始点。


落地建议
：


如果必须进行全模糊查询，尽量只查询索引覆盖的列，此时
```
EXPLAIN
```
会显示
```
type: index
```
（
Index Full Scan
），虽然扫描了整棵树，但无需回表，性能仍优于
```
ALL
```
。


核心业务的大规模模糊搜索应通过
ElasticSearch
或其他搜索引擎实现。


失效示例：

```
SELECT * FROM students WHERE sname LIKE '%Guide';          -- 前缀模糊，全表扫描SELECT * FROM students WHERE sname LIKE '%Guide%';         -- 前后模糊，全表扫描
```
OR 连接与 Index Merge

核心定义
：在
```
OR
```
连接的多个条件中，只要有
任意一列没有索引
，MySQL 就会放弃所有索引转而执行全表扫描。


Index Merge 机制
：若
```
OR
```
两侧都有索引，MySQL 5.1+ 可能会触发
索引合并（Index Merge）
优化，分别扫描两个索引后取并集。不过，如果两个索引过滤后的数据量都很大，合并结果集的成本可能高于全表扫描，依然会放弃索引。


落地建议
：


优先将
```
OR
```
改写为
```
UNION ALL
```
。
```
UNION ALL
```
可以让每一段查询独立使用索引，且规避了优化器对
```
OR
```
成本估算不准的问题。


注意：只有当确定结果集不重复时才用
```
UNION ALL
```
，否则需用
```
UNION
```
（涉及临时表去重，有额外开销）。


失效示例：

```
-- 假设 sname 和 address 都有索引，但各匹配 30%+ 数据SELECT * FROM students WHERE sname = '学生 1' OR address = '上海'; -- 可能放弃索引，全表扫描-- 建议改写为SELECT * FROM students WHERE sname = '学生 1'UNION ALLSELECT * FROM students WHERE address = '上海'; -- 各自走索引
```
验证方式
：
```
EXPLAIN
```
中若出现
```
type: index_merge
```
和
```
Extra: Using union; Using where
```
，说明使用了 Index Merge。


```
IN
```
/
```
NOT IN
```
使用不当

```
IN
```
列表长度
：

```
eq_range_index_dive_limit
```
（默认
200
）并不直接导致索引失效，而是影响
行数估算策略
：


<= 200
：MySQL 使用
Index Dive
（深入索引树探测）精确估算行数，成本估算准确，索引大概率有效。


> 200
：当
```
IN
```
列表长度超过
```
eq_range_index_dive_limit
```
（MySQL 5.7.4+ 默认为 200）时，优化器从精确的 Index Dive 切换为基于
```
index_statistics
```
的估算。若表数据的基数（Cardinality）统计陈旧，可能导致估算成本异常，从而放弃走范围扫描（Range Scan）而选择全表扫描。


可通过调大
```
eq_range_index_dive_limit
```
或改写为
```
JOIN
```
临时表来规避。


```
NOT IN
```
：

常量列表
（如
```
NOT IN (1,2,3)
```
）：通常全表扫描，因需遍历整个 B+ 树证明"不在集合中"。


子查询关联索引列
：
```
WHERE id NOT IN (SELECT user_id FROM orders WHERE user_id > 1000)
```
可用
```
orders
```
表的
```
user_id
```
索引。


推荐替代
：优先使用
```
NOT EXISTS
```
或
```
LEFT JOIN / IS NULL
```
，性能更优且语义更清晰。


失效示例：

```
SELECT * FROM students WHERE s_code IN (1, 2, 3, ..., 500); -- 列表过长，可能改用统计估算导致误判SELECT * FROM students WHERE s_code NOT IN (1, 2, 3);     -- 常量列表，全表扫描
```
隐式类型转换

这是开发中最隐蔽的坑，
转换的方向决定了索引的生死
。

场景

示例

转换方向

索引是否有效


字符串列 + 数字值
```
varchar_col = 123
```
字符串转数字（发生在索引列）

❌ 失效


数字列 + 字符串值
```
int_col = '123'
```
字符串转数字（发生在常量）

✅ 有效



关键点
：

只有当
转换发生在索引列上
时，索引才会失效。


当字符串与数字进行比较时，MySQL 默认将字符串转换为
浮点数（DOUBLE）
进行比较（详见
MySQL 官方文档规则 7
[2]
）。对索引列发生隐式类型转换等同于在索引列上应用了不可逆的转换函数，破坏了 B+ 树的有序性，导致只能走全表扫描。


```
int_col = '123'
```
会被转换为
```
int_col = CAST('123' AS DOUBLE)
```
，转换发生在常量侧，不影响索引使用。


详细介绍
：
MySQL 隐式转换造成索引失效
[3]

```
ORDER BY
```
排序优化陷阱

即使
```
WHERE
```
条件精准，如果
```
ORDER BY
```
处理不好，依然会出现慢查询。

触发
```
Using filesort
```
的条件
：

排序字段不在索引中


索引顺序与
```
ORDER BY
```
不一致（如索引
```
(a,b)
```
但
```
ORDER BY b,a
```
）


```
WHERE
```
与
```
ORDER BY
```
分别使用不同索引


排序列包含
```
SELECT *
```
中非索引列（需回表排序）


优化方案
：

利用
覆盖索引
同时满足
```
WHERE
```
和
```
ORDER BY
```
。例如索引为
```
(name, age)
```
，查询
```
SELECT name, age FROM users WHERE name = 'A' ORDER BY age
```
。


调整索引顺序以匹配
```
ORDER BY
```
。


验证方式
：
```
EXPLAIN
```
中
```
Extra
```
列出现
```
Using filesort
```
即表示触发了排序。

参考资料

[1]
[Bug
#109145
]:
https://bugs.mysql.com/bug.php?id=109145

[2]
MySQL 官方文档规则 7:
https://dev.mysql.com/doc/refman/8.0/en/type-conversion.html

[3]
MySQL 隐式转换造成索引失效:
https://javaguide.cn/database/mysql/index-invalidation-caused-by-implicit-conversion.html



[图片: 图片]


⭐️推荐阅读
:

比 iTerm2 更好用的 Claude Code 终端诞生了！！


JavaGuide 后端面试网站沉浸式阅读模式发布！


面试官：“你连Claude Code都没用过吗？”，我怼回去：“就没用过又怎么了？”


鹅厂面试官：“一致性哈希算法都不知道？”，我反问：“那你就知道吗？”


RuoYi 全栈 AI 平台开源了！真香！！


对标MinIO！全新一代分布式文件系统诞生！





