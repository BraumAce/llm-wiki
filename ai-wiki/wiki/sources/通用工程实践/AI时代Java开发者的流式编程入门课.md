---
title: "AI时代Java开发者的流式编程入门课"
type: source
date: 2026-06-28
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/iD9uAGqK5WcrUBKIlJwnxw"
author: "写代码的SharkChili"
published_at: "2026-06-28 12:33:58+08:00"
ingested_at: 2026-06-28
tags:
  - java
  - stream
  - functional-programming
  - parallelstream
  - ai-code-review
  - 通用工程实践
related_entities: []
related_topics: []
---

# AI时代Java开发者的流式编程入门课

## 一句话概括

这篇文章用菜单筛选案例讲清 Java Stream 的声明式流水线、惰性求值、一次性消费和 `parallelStream` 线程模型，并落到“如何审查 AI 生成的 Stream 代码”这一生产实践。

## 实践内容

### 示例数据

```java
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class Dish {

private final String name;        //名称
private final boolean vegetarian; //是否素食
private final int calories;       //卡路里
private final Type type;          //类型

//类型枚举，分别是肉类、鱼类、其他
public enum Type {MEAT, FISH, OTHER}

//保留手写 toString，让菜肴直接打印成名称（后文多处输出依赖这一点）
@Override
public String toString() {
return name;
}
}
```

### Java 8 之前的筛选、排序、输出

```java
//放进 StreamDemo 类，并在类顶补充：
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
public static void main(String[] args) {
List lowCaloricDishes = new ArrayList<>();

//筛选出400卡以下的菜肴
for (Dish d : menu) {
if (d.getCalories() < 400) {
lowCaloricDishes.add(d);
}
}

//按照热量升序排序
Collections.sort(lowCaloricDishes, new Comparator() {
public int compare(Dish d1, Dish d2) {
return Integer.compare(d1.getCalories(), d2.getCalories());
}
});

//输出
for (Dish d : lowCaloricDishes) {
System.out.println(d);
}
}
```

### Java Stream 写法

```java
//放进 StreamDemo 类，并在类顶补充：
//import static java.util.Comparator.comparing;
//import static java.util.stream.Collectors.toList;
public static void main(String[] args) {
menu.stream()
//找出低于400卡的菜肴
.filter(d -> d.getCalories() < 400)
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

### Stream 只能消费一次

```java
//可单独放进一个类的 main 方法运行，类顶补充：
//import java.util.Arrays;
//import java.util.List;
//import java.util.stream.Stream;
List strings = Arrays.asList("java8", "in", "action");
Stream stream = strings.stream();
stream.forEach(System.out::println);
stream.forEach(System.out::println);
```

对应异常：

```text
java8
Exception in thread "main" java.lang.IllegalStateException: stream has already been operated upon or closed
in
action
at java.util.stream.AbstractPipeline.sourceStageSpliterator(AbstractPipeline.java:279)
at java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:580)
at com.sharkChili.lambda.Main.main(Main.java:27)
```

### 审查 AI 生成的 parallelStream 代码

```java
//AI 生成的"批量统计已支付订单金额"
List orders = orderMapper.listAll();
List amounts = new ArrayList<>();
orders.parallelStream()
.filter(o -> o.getStatus() == OrderStatus.PAID)
.forEach(o -> {
//逐个订单远程查一次实付金额
BigDecimal amt = orderService.queryPaidAmount(o.getId());
amounts.add(amt);
});
BigDecimal total = amounts.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
```

更稳妥的顺序流写法：

```java
List orders = orderMapper.listAll();
BigDecimal total = orders.stream()
.filter(o -> o.getStatus() == OrderStatus.PAID)
.map(o -> orderService.queryPaidAmount(o.getId()))
.reduce(BigDecimal.ZERO, BigDecimal::add);
```

本文给出的审查结论是：`parallelStream` 默认使用公共 `ForkJoinPool`，适合 CPU 密集型任务，不适合直接包住远程调用；`ArrayList` 不是线程安全容器，不能在并行 `forEach` 里并发 `add`；收集结果应优先使用 `map` + `collect`/`reduce`，而不是外部可变集合。

## 摘录

> Java8 的 Stream 把「筛选 → 排序 → 取字段 → 收集」串成一条流水线，一行链式调用就能表达清楚。这篇从一个菜肴筛选的例子入手，带你入门 Stream 的几个核心心智模型：惰性求值、逐元素流水线、流只能消费一次。考官在考什么：Stream 入门最常被追问的是「中间操作为什么不立即执行」「Stream 和 for 循环到底差在哪」「parallelStream 用的是哪个线程池」，这几点会贯穿全文。

> 了解这个默认线程模型，在审查AI生成的代码时尤其重要。AI经常无脑给集合操作套上`parallelStream`来显得「高性能」，但并不是所有任务都适合并行流。公共`ForkJoinPool`的线程数只有核心数级别，它适合的是CPU密集型任务，也就是纯计算、能把每个核都吃满的场景。如果流里干的是IO密集型的活，比如逐个元素去查库、调远程接口，线程大部分时间都阻塞在等待上，这点线程数根本盖不住IO等待，吞吐反而上不去。

## 涉及实体

- （无直接关联的 wiki 实体）

## 涉及主题

- （无直接关联的 wiki 主题）

## 我的评注

这篇属于通用工程实践，但很适合和 AI 代码审查语境一起读：AI 很容易把“看起来高级”的 `parallelStream` 套在不合适的 IO 场景里，也容易在并行流中操作外部可变集合。真正可复用的是审查框架：先判断任务类型，再判断线程模型，再检查副作用和收集方式。它和线程池那篇一样，都在提醒后端开发者不要让 AI 生成代码绕过语言与运行时基本功。
