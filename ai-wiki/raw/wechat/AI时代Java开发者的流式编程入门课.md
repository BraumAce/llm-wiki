---
title: "AI时代Java开发者的流式编程入门课"
source_url: "https://mp.weixin.qq.com/s/iD9uAGqK5WcrUBKIlJwnxw"
author: "写代码的SharkChili"
published_at: "2026-06-28 12:33:58+08:00"
fetched_at: "2026-06-28T23:51:57+08:00"
fetcher: "curl-direct-html-content_noencode"
---

# AI时代Java开发者的流式编程入门课

- 作者: 写代码的SharkChili
- 发布时间: 2026-06-28 12:33:58+08:00
- 原文链接: https://mp.weixin.qq.com/s/iD9uAGqK5WcrUBKIlJwnxw

---

写过「三层嵌套 for 循环 + 匿名 Comparator」做筛选排序的人，都懂那种繁琐：定义临时集合、手写比较器、再一个个塞进结果列表，业务逻辑被淹没在样板代码里。Java8 的 Stream 把「筛选 → 排序 → 取字段 → 收集」串成一条流水线，一行链式调用就能表达清楚。这篇从一个菜肴筛选的例子入手，带你入门 Stream 的几个核心心智模型：惰性求值、逐元素流水线、流只能消费一次。

考官在考什么：Stream 入门最常被追问的是「中间操作为什么不立即执行」「Stream 和 for 循环到底差在哪」「parallelStream 用的是哪个线程池」，这几点会贯穿全文。

SharkChili · 禅与计算机程序设计的艺术

开源项目

mini-redis：笔者用 Go 从零手写的教学级 Redis，适合对着源码把缓存与网络底层一行行啃透，欢迎 Star 和交流 · https://github.com/shark-ctrl/mini-redis

关注公众号 写代码的SharkChili ，发送关键字 【加群】 添加笔者好友、进技术交流群。

### 流的基础示例

#### 需求描述

假设我们在做一个餐厅的菜单查询功能。手头有一份菜单，每道菜都带有名称、是否素食、热量（卡路里）、类型（肉类/鱼类/其他）这几个属性。本案例的需求是：从菜单里挑出所有热量低于 400 卡的菜，按热量从低到高排序，最后只取这些菜的名称。需求的输入与输出如下图所示：

为了表示一道菜肴，我们先定义一个菜肴类，用 lombok 简化掉 getter 和构造器（项目需引入 lombok 依赖），其定义如下：

```
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class Dish {

private final String name;        //名称
private final boolean vegetarian; //是否素食
private final int calories;       //卡路里
private final Type type;          //类型

//类型枚举，分别是肉类、鱼类、其他
public enum Type {MEAT, FISH, OTHER}

//保留手写 toString，让菜肴直接打印成名称（后文多处输出依赖这一点）
@Override
public String toString() {
return name;
}
}

```

基于这个类，我们准备一份菜肴测试数据 `menu`。下文所有示例都写在 `StreamDemo` 这个类里，把 `Dish` 类和 `StreamDemo` 类一起粘进 IDEA 即可直接运行：

```
import java.util.Arrays;
import java.util.List;

public class StreamDemo {

static final List menu = Arrays.asList(
new Dish("pork", false, 800, Dish.Type.MEAT),
new Dish("beef", false, 700, Dish.Type.MEAT),
new Dish("chicken", false, 400, Dish.Type.MEAT),
new Dish("french fries", true, 530, Dish.Type.OTHER),
new Dish("rice", true, 350, Dish.Type.OTHER),
new Dish("season fruit", true, 120, Dish.Type.OTHER),
new Dish("pizza", true, 550, Dish.Type.OTHER),
new Dish("prawns", false, 400, Dish.Type.FISH),
new Dish("salmon", false, 450, Dish.Type.FISH));

//下文各示例的 main 方法都写在这个类里
}

```

我们希望筛选出400卡以下的菜肴名，并按照热量升序排列。

#### 使用java8之前的做法

使用java8之前版本的写法步骤比较繁琐，但逻辑很清晰，整体步骤为:

筛选出400卡以下的菜肴。

创建一个匿名比较器，并基于这个比较器对菜肴进行升序排列。

将排列后的菜肴集合的名字存入字符串列表。

输出结果。

```
//放进 StreamDemo 类，并在类顶补充：
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
public static void main(String[] args) {
List lowCaloricDishes = new ArrayList<>();

//筛选出400卡以下的菜肴
for (Dish d : menu) {
if (d.getCalories() < 400) {
lowCaloricDishes.add(d);
}
}

//按照热量升序排序
Collections.sort(lowCaloricDishes, new Comparator() {
public int compare(Dish d1, Dish d2) {
return Integer.compare(d1.getCalories(), d2.getCalories());
}
});

//输出
for (Dish d : lowCaloricDishes) {
System.out.println(d);
}
}

```

对应输出结果如下，`season fruit`为120卡，`rice`为350卡，符合预期：

```
season fruit
rice

```

#### jdk8的做法

`jdk8`的写法相较于之前版本要简洁很多，它将集合视作一个流，并基于这个集合的流实现筛选、排序、映射等组合操作。

```
//放进 StreamDemo 类，并在类顶补充：
//import static java.util.Comparator.comparing;
//import static java.util.stream.Collectors.toList;
public static void main(String[] args) {
menu.stream()
//找出低于400卡的菜肴
.filter(d -> d.getCalories() < 400)
//按照升序排列
.sorted(comparing(Dish::getCalories))
//得到这些菜肴的名称
.map(Dish::getName)
//组成list
.collect(toList())
//输出结果
.forEach(m -> System.out.println(m));
}

```

### 流的优势

声明性：流式编程的所有操作都是语义化的，我们完全可以通过方法名大致猜出操作目的。

可复合：流式编程无需像jdk8之前的版本为了实现组合操作而取创建各种临时集合，取而代之的是基于一段连续的流自顶而下的实现组合操作。

可并行：当我们需要提高计算密集型任务的性能时，只需将`stream`改为`parallelStream`，就可以开启并行流让多个线程一起工作。

流水线：流式编程会将组合操作构成一个大的流水线，这使得我们代码能够更进一步优化，例如延迟和短路操作，使得代码可以实现类似于数据库式的查询。

内部迭代：流式编程将迭代操作封装起来，对开发者透明，如此一来，开发者专注与对流内部的元素的操作，而无需关注繁琐的非业务代码。

下图用一段简单代码对比传统命令式写法和声明式的流式写法，直观感受上面这几条优势：

### 流的两种操作

在看具体操作之前，先从编程学习的角度点一句：Stream 这套操作之所以好用，很大程度上是因为它足够语义化——`filter` 就是过滤、`map` 就是映射、`limit` 就是截取，光看方法名就能猜出它在做什么。这种语义化在审查 AI 代码的时代格外重要：方法名表达的意图越清晰，人和 AI 都能越快读懂代码的上下文，少踩坑、少误读。

#### 中间操作

例如`filter`、`map`、`limit`、`sorted`等只涉及元素的流水线单一步骤且最终会返回`stream`类型的方法都是中间操作，它们只有在调用终端操作(即真正要结果的方法)才会开始工作：

`filter`:过滤出符合预期的元素，如果不符合预期就不会走到流水线的下一步。

`map`:映射，将流水线的A元素转为B元素，例如上文示例中基于`Menu`的`name`字段将`Menu`对象转为`String`对象。

`limit`:截取前n个对象，例如上文`limit(3)`，这意味着流水线收集到3个元素之后就停止工作。

`sorted`:排序操作，将流水线的元素按照指定顺序排序。

`distinct`:去重，收集当前流水线上不重复的元素。

#### 终端操作

终端操作通俗的理解就是将中间操作得到的元素放到流水线的终点开始真正的输出，一旦中间操作得到的元素都经过终端操作后，这个流就会被关闭。例如上文中经过`filter`、`map`、`limit`得到的元素都走到`collect`这个收集元素的终端操作后，流就关闭了，一旦我们再次使用这个流就会报错。

`java8`而对应的终端操作有:

`forEach`:将中间操作得到的元素进行一次遍历。

`count`:统计中间操作得到的元素个数，个数的类型为long类型。

`collect`:将中间操作得到的元素归为一个集合。

### 流与集合的关系

#### 每一个集合的流只能使用一次

如下代码所示，每一个集合对应的流只能操作一次，每次操作完成之后这个流就会被关闭，这意味着用户再次使用这个流就会报错：

```
//可单独放进一个类的 main 方法运行，类顶补充：
//import java.util.Arrays;
//import java.util.List;
//import java.util.stream.Stream;
List strings = Arrays.asList("java8", "in", "action");
Stream stream = strings.stream();
stream.forEach(System.out::println);
stream.forEach(System.out::println);

```

输出结果如下，可以看到对于同一个流的多次操作抛出`IllegalStateException`错误：

```
java8
Exception in thread "main" java.lang.IllegalStateException: stream has already been operated upon or closed
in
action
at java.util.stream.AbstractPipeline.sourceStageSpliterator(AbstractPipeline.java:279)
at java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:580)
at com.sharkChili.lambda.Main.main(Main.java:27)

```

这里有个容易误读的细节，异常信息看似插在`java8`和`in`之间，像是第一次`forEach`只打印了`java8`就抛异常。实际上第一次`forEach`已经完整打印了`java8`、`in`、`action`三行，异常来自第二次`forEach`。控制台里`System.out`(标准输出)和`System.err`(标准错误)是两个独立的流，刷新时机不同，异常栈才会插在正常输出中间，这只是视觉上的交错，并非程序打印一半就崩了。

这个小例子其实点出了一件事：只有理解流的底层工作机制——流消费一次就关闭、中间操作惰性、终端操作才真正触发——才能正确地使用它，遇到上面这种「看着像崩了一半」的现象也能一眼看穿是怎么回事。在 AI 时代这一点只会更重要：哪怕越来越多的代码不再由我们逐行手写、而是交给 AI 生成，我们依然需要对语言有足够深入的理解和掌握，才能看懂、审查、纠正这些代码。把底层机制吃透，才是人在 AI 时代不被代码牵着走的底气。

#### 集合的外部迭代和流的内部迭代

流式编程将循环操作内置，对于用户是无感的，如下代码所示，我们使用peek方法打印经过这个组合操作的元素有哪些：

```
public static void main(String[] args) {
List menuNameList = menu.stream()
//找到大于300卡的菜肴
.filter(d -> d.getCalories() > 300)
.peek(d -> System.out.println("步骤1:" + d))
//取出这个菜肴的名称
.map(Dish::getName)
.peek(d -> System.out.println("步骤2:" + d))
//取前3个
.limit(3)
.peek(d -> System.out.println("步骤3:" + d))
//存入list中
.collect(Collectors.toList());

}

```

我们就会得到这样一个结果，可以看到每一个元素都会依次经过`filter`、和`map`、`limit`，这就是`jdk8`流式编程的循环合并技术：

```
步骤1:pork
步骤2:pork
步骤3:pork
步骤1:beef
步骤2:beef
步骤3:beef
步骤1:chicken
步骤2:chicken
步骤3:chicken

```

这里要专门说一下 peek。peek 是一个无副作用的消费型操作，它接收一个 Consumer，只是顺手看一眼流过的每个元素、并不改变它们，元素会原样继续往下走。理解它这个定位，就知道 peek 最适合的场景是调试和观察流水线——在中间操作之间插一脚，把元素打印出来，看流到底是怎么走的。在 AI 时代这点尤其实用：当我们面对一段复杂、一时看不明白的流式代码时，与其干读，不如让 AI 在关键节点插上 peek 把中间结果打出来，流的走向就一目了然了。

### 流的工作原理

这个例子的目的是从菜肴中找到前三个菜肴大于300卡的菜名：

```
public static void main(String[] args) {
List menuNameList = menu.stream()
//找到大于300卡的菜肴
.filter(d -> d.getCalories() > 300)
//取出这个菜肴的名称
.map(Dish::getName)
//取前3个
.limit(3)
//存入list中
.collect(Collectors.toList());
//输出结果
System.out.println(menuNameList);
}

```

流式编程的工作原理非常高效，它将组合操作作为一条工作的流水线，将集合中的每一个元素都放到这个流水线上进行工作，所以对于上面的代码，它的工作过程是这样的：

拿到`pork`，进入`filter`操作，因为其热量大于300卡，继续走到流水线下一个步骤。

进入`map`操作，拿到pork对象的name。

进入`limit`操作，pork还在limit限定范围，继续走到下一个操作。

进入`toList`操作，将`pork`存入`list`中。

同理对`beef`和`chicken`完成同样的操作，然后limit达到上限，停止流水线。

所以和命令式编程比较起来，流式操作更像是在线观看流媒体视频，只有用户观看到某一分钟时才会去加载需要的数据。而`jdk8`之前的集合操作更像是`DVD`加载视频，必须将整张光盘数据都加载完成了，用户才能按需跳到需要的片段。

### 并行流与线程模型

上面第 3 条提到的「可并行」，这里单独展开一下，因为它直接关系到什么任务该不该用并行流。把 stream 换成 parallelStream 就开启了并行，对应代码示例如下：

```
//放进 StreamDemo 类，并在类顶补充：
//import static java.util.Comparator.comparing;
//import static java.util.stream.Collectors.toList;
public static List getLowCaloricDishesNamesInJava8(List dishes) {
return dishes.parallelStream()
//找出低于400卡的菜肴
.filter(d -> d.getCalories() < 400)
//按照升序排列
.sorted(comparing(Dish::getCalories))
//得到这些菜肴的名称
.map(Dish::getName)
//组成list
.collect(toList());
}

```

并行流默认使用公共的`ForkJoinPool`(`ForkJoinPool.commonPool()`)，其并行度默认为「CPU核心数 - 1」，再加上提交任务的主线程也会参与计算，活跃的计算线程数大致等于核心数。

了解这个默认线程模型，在审查AI生成的代码时尤其重要。AI经常无脑给集合操作套上`parallelStream`来显得「高性能」，但并不是所有任务都适合并行流。公共`ForkJoinPool`的线程数只有核心数级别，它适合的是CPU密集型任务，也就是纯计算、能把每个核都吃满的场景。如果流里干的是IO密集型的活，比如逐个元素去查库、调远程接口，线程大部分时间都阻塞在等待上，这点线程数根本盖不住IO等待，吞吐反而上不去。更要命的是这个公共池被整个JVM共享，一旦被IO阻塞占满，还会连累其他依赖公共池的并行任务。所以审查代码时看到`parallelStream`，要先判断任务是CPU密集还是IO密集，再决定它该不该用、要不要换成自定义线程池。

### 面试真题：审一段 AI 写的 Stream 代码

现在面试，面试官越来越喜欢甩一段 AI 生成的代码，让候选人快速审一遍、指出问题。下面这段「批量统计已支付订单的金额」乍看能跑，你能看出几个坑？

```
//AI 生成的"批量统计已支付订单金额"
List orders = orderMapper.listAll();
List amounts = new ArrayList<>();
orders.parallelStream()
.filter(o -> o.getStatus() == OrderStatus.PAID)
.forEach(o -> {
//逐个订单远程查一次实付金额
BigDecimal amt = orderService.queryPaidAmount(o.getId());
amounts.add(amt);
});
BigDecimal total = amounts.stream().reduce(BigDecimal.ZERO, BigDecimal::add);

```

先自己想一想，问题都标在下面这张图里：

答案：这段代码至少有三个问题。

parallelStream 里干 IO 密集的活。`queryPaidAmount` 是远程调用，属于典型的 IO 密集型任务。parallelStream 默认跑在公共 `ForkJoinPool` 上，线程数只有核心数级别，盖不住远程调用的等待，吞吐上不去。更糟的是公共池被整个 JVM 共享，一旦这里的远程调用把池占满，会连累其它依赖公共池的并行任务。

forEach 里往非线程安全的 ArrayList 并发 add。parallelStream 是多个线程同时跑 `forEach`，它们同时往普通 `ArrayList` 里 `add`，而 `ArrayList` 不是线程安全的，轻则丢数据，重则抛 `ArrayIndexOutOfBoundsException`。

用 forEach + 外部可变集合做收集，违背了流的设计。想把流里的元素收集成结果，正确做法是 `map` + `collect`/`reduce` 让流自己管收集，而不是在 `forEach` 里操作一个外部的可变 `amounts`。

一个更稳妥的写法是去掉外部可变集合、用 `map` 接 `reduce`，对应代码示例如下：

```
List orders = orderMapper.listAll();
BigDecimal total = orders.stream()
.filter(o -> o.getStatus() == OrderStatus.PAID)
.map(o -> orderService.queryPaidAmount(o.getId()))
.reduce(BigDecimal.ZERO, BigDecimal::add);

```

如果确实想并行加速这批远程调用，应该把任务提交到自定义线程池(例如 `ThreadPoolExecutor`，或 `CompletableFuture` 配合自定义 `Executor`)，而不是直接套 `parallelStream`。

### 小结

回顾一下这篇的几个核心点：

中间操作（filter、map、sorted、limit 等）是惰性的，只负责搭建流水线、并不立即执行，直到遇到终端操作（collect、forEach、count 等）才真正触发计算。

Stream 是逐元素走流水线，而不是逐操作批处理，一个元素依次穿过 filter→map→limit 全程，再轮到下一个，配合 limit 这类短路操作还能提前结束、避免无谓计算。

一个流只能消费一次，终端操作之后流就关闭，再次使用会抛 IllegalStateException。

parallelStream 默认借公共 ForkJoinPool 并行，并行度约等于核心数，适合 CPU 密集型任务，IO 密集型则要另寻线程池。

把这几点想清楚，Stream 的「声明式、可组合、可并行」就不再是口号，而是能落到代码里的判断依据。

最后说点这篇之外的话。技术迭代越来越快，今天的开发者已经有相当一部分精力，从逐行手写代码转移到了做方案设计和审查 AI 生成的代码上。但笔者依然希望读者能保持对语言细粒度的把控力——这是程序员的护城河，也是在「AI 写大部分代码」这个趋势下，我们仍然能守住系统质量的核心能力。就拿这篇的流式编程来说，只有真正了解流的各种操作、它们的底层执行原理，才能在面对不同的数据处理需求时，对流的搭配、并行调优、以及出问题时的逻辑排查有清晰的判断，也才能写出高质量的提示词、把好 AI 交付的质量关。

SharkChili · 禅与计算机程序设计的艺术

开源项目

mini-redis：笔者用 Go 从零手写的教学级 Redis，适合对着源码把缓存与网络底层一行行啃透，欢迎 Star 和交流 · https://github.com/shark-ctrl/mini-redis

关注公众号 写代码的SharkChili ，发送关键字 【加群】 添加笔者好友、进技术交流群。

### 参考

Java 8 in Action:https://book.douban.com/subject/25912747/
