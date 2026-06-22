---
title: "一文吃透Java并发基础：从三类问题到线程状态机"
type: source
date: 2026-06-22
source_type: wechat
source_url: "https://mp.weixin.qq.com/s/oWbB59SiWzMyGN4NbNuBog"
author: "码农SharkChili（写代码的SharkChili）"
published_at: "2026-06-22"
ingested_at: 2026-06-22
tags:
  - java
  - concurrency
  - jvm
  - 通用工程实践
related_entities: []
related_topics: []
---

# 一文吃透Java并发基础：从三类问题到线程状态机

## 一句话概括

SharkChili 的并发编程基础梳理：从「为什么需要多线程」讲起，系统拆解并发编程必须关注的三类问题——安全性、活跃性（死锁/活锁/线程饥饿）、性能，再辨析并发 vs 并行、同步 vs 异步、JVM 视角下进程与线程的资源划分（程序计数器/虚拟机栈/本地方法栈为何线程私有、栈封闭技术），最后对比两种建线程方式 Thread vs Runnable。

## 实践内容

### 安全性问题：自增竞态

自增非复合操作且多线程操作彼此不可见，结果小于预期：

```java
private static int num = 0;

public static void main(String[] args) throws InterruptedException {
    CountDownLatch countDownLatch = new CountDownLatch(2);
    new Thread(() -> {
        for (int i = 0; i < 100_0000; i++) {
            num++;
        }
        countDownLatch.countDown();
    }).start();

    new Thread(() -> {
        for (int i = 0; i < 100_0000; i++) {
            num++;
        }
        countDownLatch.countDown();
    }).start();

    countDownLatch.await();
    System.out.println(num);//输出1499633
}
```

### 活跃性问题：可见性导致的忙等死循环

在没有 `volatile` 或锁建立 happens-before 关系时，JIT 可能把 `val` 读进寄存器后不再回读主内存，线程 0 一直看到旧值、陷入无限循环：

```java
private static boolean val = false;

public static void main(String[] args) {
    CountDownLatch countDownLatch = new CountDownLatch(2);
    new Thread(() -> {
        while (!val) {//下方线程操作对于线程1不可见，进行无限循环

        }
        System.out.println("thread-1 executed finished");
        countDownLatch.countDown();
    }).start();

    new Thread(() -> {
        ThreadUtil.sleep(5, TimeUnit.SECONDS);
        val = true;
        System.out.println("设置val为true");
        countDownLatch.countDown();
    }).start();

    try {
        countDownLatch.await();
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
}
```

广义活跃性问题分三类：**死锁**（两个线程互相等待对方持有的资源而阻塞）、**活锁**（线程都没阻塞、一直重试或改变状态，但因彼此谦让/响应导致整体没有进展）、**线程饥饿**（某线程长时间分不到 CPU 时间片）。

### 活锁示例：两人共用一把勺子反复谦让

```java
public class LivelockDemo {

    static class Spoon {                          // 勺子，同一时刻只能一个人持有
        private Diner owner;
        Spoon(Diner d) { owner = d; }
        synchronized void setOwner(Diner d) { owner = d; }
        synchronized Diner getOwner() { return owner; }
    }

    static class Diner {
        private final String name;
        private boolean full = false;             // 是否吃饱
        Diner(String name) { this.name = name; }
        boolean isHungry() { return !full; }

        void eatWith(Spoon spoon, Diner partner) {
            while (isHungry()) {                   // 没阻塞，一直在循环重试
                if (spoon.getOwner() != this) {    // 勺子不在我手上，继续等
                    continue;
                }
                if (partner.isHungry()) {          // 对方还饿 → 我谦让，把勺子让出去
                    System.out.println(name + "：你先吃，" + partner.name);
                    spoon.setOwner(partner);
                    continue;                      // 勺子易主，但我没吃成
                }
                full = true;                       // 真正吃到饭
                System.out.println(name + "：我吃完了");
                spoon.setOwner(partner);
            }
        }
    }

    public static void main(String[] args) {
        Diner a = new Diner("A");
        Diner b = new Diner("B");
        Spoon spoon = new Spoon(a);
        // 两人都"只要对方还饿就把勺子让出去"，勺子反复横跳，谁都吃不上
        new Thread(() -> a.eatWith(spoon, b)).start();
        new Thread(() -> b.eatWith(spoon, a)).start();
    }
}
```

> 死锁是大家都卡住不动，活锁是大家都在动、却始终没有进展。

### 栈封闭技术：局部变量天然线程安全

共享变量 `globalVariable` 位于多线程共享的堆中，并发自增有竞争；`neverGoOut` 是方法内局部变量，存放在各自线程私有的虚拟机栈帧里，互不干扰、天然线程安全：

```java
public class StackConfinement implements Runnable {

    //全局变量，多线程操作会有线程安全问题
    int globalVariable = 0;

    public void inThread() {
        //栈封闭：变量定义在方法内部，属于每个线程私有的虚拟机栈，天然线程安全
        int neverGoOut = 0;
        for (int i = 0; i < 10000; i++) {
            neverGoOut++;
        }
        System.out.println("栈内保护的数字是线程安全的：" + neverGoOut);//10000
    }

    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            globalVariable++;
        }
        inThread();
    }
}
```

### 同步 vs 异步（代码对照）

```java
// 同步：必须等 compute() 算完返回，才会执行下一行
int result = compute();
System.out.println(result);

// 异步：submit 立即返回 Future，主线程先做别的，需要结果时再 get
Future<Integer> future = executor.submit(() -> compute());
doSomethingElse();
int result = future.get(); // 真正需要结果时再取，此时才可能阻塞
```

### 创建线程：Thread vs Runnable

```java
// 方式一：继承 Thread
class MyThread extends Thread {
    @Override public void run() { /* 任务逻辑 */ }
}
new MyThread().start();

// 方式二：实现 Runnable（工程上更推荐）
class MyTask implements Runnable {
    @Override public void run() { /* 任务逻辑 */ }
}
new Thread(new MyTask()).start();
```

Runnable 更被推荐的三个原因：① 不占用单继承名额（Java 单继承，已 `extends` 业务基类就无法再 `extends Thread`）；② 把「任务」和「线程」解耦，同一任务可交给不同线程甚至线程池；③ 多个线程可共享同一个 Runnable 实例，方便共享数据。

## 摘录

> 线程活跃性问题即线程未能按照预期的时序执行……对于 java 并发编程而言，如果没有添加保证可见性的关键字进行修饰，线程1的修改操作对于线程0来说是不可见的：在没有 volatile 或锁建立 happens-before 关系时，JIT 可能把 val 读进寄存器后不再回读主内存，于是线程0一直看到旧值、陷入无限循环，这就是我们所说的可见性导致的活跃性问题。

> 并发(Concurrency)指的是同一段时间内多个任务交替推进。在单核 CPU 上，同一时刻其实只有一个线程在执行，操作系统靠时间片轮转快速切换……并行(Parallelism)则是同一时刻多个任务真的在同时执行，这必须依赖多核 CPU。所以可以这样记：并发强调的是任务的切换与调度，单核也能并发；并行强调的是物理上的同时执行，必须有多核。并行一定是并发，但并发不一定是并行。

> 程序计数器私有：有了程序计数器才能保证在多线程的情况下，这个线程被挂起再被恢复时，可以根据程序计数器找到下一次要执行的指令位置。虚拟机栈私有：每个 Java 线程执行方法时都会创建栈帧保存局部变量、常量池引用、操作数栈等信息。在任务可充分并行、忽略同步与上下文切换开销的理想情况下，执行时间才接近「单线程时间/核心数」，若存在串行部分则受 Amdahl 定律约束，加速比会明显低于核心数。

## 涉及实体

- []

## 涉及主题

- []

## 我的评注

非 AI 主题，归入「通用工程实践」。文章把并发的三类问题（安全性/活跃性/性能）讲得很扎实，活锁的「两人共用勺子」例子和栈封闭技术是亮点。标题中的「线程状态机」在本文正文中并未展开（应为系列后续或以配图呈现），本次仅消化文字部分。对 AI Agent 工程的迁移价值：Amdahl 定律、可见性/happens-before 等同样适用于多 Agent 并行与共享状态设计。
