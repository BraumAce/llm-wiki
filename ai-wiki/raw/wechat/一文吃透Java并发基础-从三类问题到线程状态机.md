---
title: "一文吃透Java并发基础：从三类问题到线程状态机"
source_url: "https://mp.weixin.qq.com/s/oWbB59SiWzMyGN4NbNuBog"
author: "码农SharkChili（写代码的SharkChili）"
fetched_at: "2026-06-22T23:41:00+08:00"
fetcher: "cdp"
---

写在文章开头

这也算是笔者一直重构梳理的一篇文章，不同的阶段对于并发编程的禅修都有不一样的理解，而本次的进阶将更多维度是去强调并发编程所需要关注的一些基础问题和本质，希望对你有帮助。

SharkChili · 禅与计算机程序设计的艺术

开源项目

mini-redis：笔者用 Go 从零手写的教学级 Redis，适合对着源码把缓存与网络底层一行行啃透，欢迎 Star 和交流 · https://github.com/shark-ctrl/mini-redis

如果想进一步交流，欢迎关注笔者的公众号，发送关键字 【加群】 添加笔者好友、进技术交流群。




并发编程中的一些核心思想
为什么需要多线程

计算机发展初期都是以进程为维度分配内存、文件句柄以及安全证书等资源，同时多个进程之间采用一些比较粗粒度的通信机制来交换数据，包括：

套接字
信号处理器
共享内存

基于并发编程实战的思想：

高效做事的人，总能在串行性和异步性之间找到一个合理的平衡点，程序也是如此。

于是操作系统就引入多进程运行的调度机制，例如下面这个步骤：

在一个单核的计算机上进程1得到CPU执行权，随后进入IO读取任务阻塞挂起
处于操作系统就绪队列的进程2被唤醒得到CPU时间片执行任务
进程1在IO读取完成后收到中断响应也随后进入就绪队列，等待CPU执行权

基于上述基础上，考虑到每一个进程都独有各自的内存空间和文件句柄等资源，以如此庞大级别的单位处理一些单一的工作而在CPU之间进行频繁切换开销是非常可观的，于是就有了轻量级调度单位——多线程。

以多线程调度为例，假设进程1、进程2分别对应读取定时读取网络数据、定时写入数据到网络系统日志，按照多线程维度将二者合并，最终的进程交由CPU执行，我们就可以得到这样一个场景：

CPU执行到线程1，读取网络数据，IO阻塞，让出CPU。
线程2写入之前的网络系统日志到磁盘，进行write调用时切换到内核态，让出CPU。
线程1完成数据，进程终端输出结果，让出CPU。
线程2write调用返回，继续进行下一次的写入......
多线程有哪些优势

如上面所说，多线程存在如下优势：

轻量：以线程为单位构成进程，共享进程范围内的资源，例如内存、文件句柄等。
发挥多核处理器的强大能力：操作系统以更轻量级的线程为单位进行高效的调度和切换，在设计合理的情况下，可以大大提升CPU的利用率。
建模简单性：利用多线程技术，可以将复杂的异步任务组合的同步工作流(例如JDK8中的CompletableFuture工具类)，并利用多线程分别执行这些任务，在指定时机进行同步交互。
异步事件简化处理：有了多线程的概念之后，早期尝试过用BIO技术即一个线程分配一个客户端socket，好在现代Unix系统提出epoll、io_uring的良好设计，使得多线程技术有了更好的发挥。
并发编程需要关注的问题
安全性问题

首先是线程安全性问题，因为多线程共享了一块进程的数据，如果没有充分的做好线程间的同步，就会出现一些意外的情况，就例如下面这段代码，多线程操作一个num，因为自增操作非复合操作且多线程操作彼此不可见，出现意外结果：

private static int num = 0;

    public static void main(String[] args) throws InterruptedException {

        CountDownLatch countDownLatch = new CountDownLatch(2);
        new Thread(() -> {
            for (int i = 0; i < 100_0000; i++) {
                num++;
            }
            countDownLatch.countDown();
        }).start();

        new Thread(() -> {
            for (int i = 0; i < 100_0000; i++) {
                num++;
            }
            countDownLatch.countDown();
        }).start();

        countDownLatch.await();
        System.out.println(num);//输出1499633

    }


同样的，如果没有良好的同步机制，编译器、处理器都可以针对指令进行任意顺序和时间执行，同时在处理器或者寄存器缓存线程变量的情况下的修改操作，其他处理器的线程是无法看到其修改操作，也会导致逻辑运算上的错乱：

活跃性问题

线程活跃性问题即线程未能按照预期的时序执行，导致线程持续的活跃最典型的表现就是无限循环，打满CPU。例如并发环境下两个CPU分别执行线程0和线程1的逻辑，即：

线程0执行无限循环，只要val变为true则终止无限循环，
线程1休眠一段时间后将val修改为true。

对于java并发编程而言，如果没有添加保证可见性的关键字进行修饰，线程1的修改操作对于线程0来说是不可见的，此时线程1的修改对线程0不一定及时可见：在没有volatile或锁建立happens-before关系时，JIT可能把val读进寄存器后不再回读主内存，于是线程0一直看到旧值、陷入无限循环，这就是我们所说的可见性导致的活跃性问题：

对应我们也可以出示例代码，同时笔者也会在后续的文章中来补充说明这一点的解决方案：

 private static  boolean val = false;

    public static void main(String[] args) {
        CountDownLatch countDownLatch = new CountDownLatch(2);
        new Thread(() -> {
            while (!val) {//下方线程操作对于线程1不可见，进行无限循环

            }
            System.out.println("thread-1 executed finished");
            countDownLatch.countDown();
        }).start();


        new Thread(() -> {
            ThreadUtil.sleep(5, TimeUnit.SECONDS);
            val = true;
            System.out.println("设置val为true");
            countDownLatch.countDown();

        }).start();

        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }


上面这个忙等死循环，本质是可见性导致的无限循环。而广义的活跃性问题通常分为以下几类：

死锁：即两个线程互相等待对方持有的资源而进入阻塞
活锁：线程都没有阻塞，一直在重试或改变状态，但因为彼此谦让/响应导致整体始终没有进展，就像两个人在过道里反复互相让路
线程饥饿：因为线程过多或者某些原因导致某个线程长时间未能分配到CPU时间片，导致任务迟迟无法结束，这就是典型的线程饥饿问题

活锁的概念可能稍显抽象，这里笔者简单给一个例子帮助理解。设想两个饥饿的人A和B共用一把勺子，谁拿着勺子谁就能吃饭，本意是各自把饭吃完。但代码写得过于"礼貌"——每个人一旦拿到勺子，只要发现对方还饿着，就立刻把勺子让给对方、自己不吃。于是勺子在两人之间反复横跳，两个线程都没有阻塞、都在不停改变勺子归属（状态一直在变）、CPU也被占满，但谁的吃饭流程都无法推进，整体没有任何进展，这就是活锁。

对应的代码如下：

public class LivelockDemo {

    static class Spoon {                          // 勺子，同一时刻只能一个人持有
        private Diner owner;
        Spoon(Diner d) { owner = d; }
        synchronized void setOwner(Diner d) { owner = d; }
        synchronized Diner getOwner() { return owner; }
    }

    static class Diner {
        private final String name;
        private boolean full = false;             // 是否吃饱
        Diner(String name) { this.name = name; }
        boolean isHungry() { return !full; }

        void eatWith(Spoon spoon, Diner partner) {
            while (isHungry()) {                   // 没阻塞，一直在循环重试
                if (spoon.getOwner() != this) {    // 勺子不在我手上，继续等
                    continue;
                }
                if (partner.isHungry()) {          // 对方还饿 → 我谦让，把勺子让出去
                    System.out.println(name + "：你先吃，" + partner.name);
                    spoon.setOwner(partner);
                    continue;                      // 勺子易主，但我没吃成
                }
                full = true;                       // 真正吃到饭
                System.out.println(name + "：我吃完了");
                spoon.setOwner(partner);
            }
        }
    }

    public static void main(String[] args) {
        Diner a = new Diner("A");
        Diner b = new Diner("B");
        Spoon spoon = new Spoon(a);
        // 两人都"只要对方还饿就把勺子让出去"，勺子反复横跳，谁都吃不上
        new Thread(() -> a.eatWith(spoon, b)).start();
        new Thread(() -> b.eatWith(spoon, a)).start();
    }
}


运行后屏幕会不停打印"你先吃……你先吃……"，两个线程都没有阻塞、却谁都没吃成。这正是活锁与死锁的区别：死锁是大家都卡住不动，活锁是大家都在动、却始终没有进展。

性能问题

这一点是老生常态了，应对并发安全的手段就是保证可见性和互斥，这涉及CPU缓存更新和临界资源维度的把控和并发运算技巧，一般来说导致多线程性能瓶颈的几种原因可分为：

同步机制抑制了某些编译器的优化，例如synchronized关键字。
共享变量在多处理器之间不同线程执行，线程切换时处理器的缓存数据局部性失效，使得开销大部分时间都在处理线程调度而非运算，这也会导致程序的执行性能下降。
多线程并发处理时切换线程时产生保存和恢复上下文的开销。
JVM视角下的进程和线程

如下图所示，可以看出线程是比进程更小的单位，进程是独立的，彼此之间不会干扰，但是线程在同一个进程中共享堆区和方法区，虽然开销较小，但是资源之间管理和分配处理相对于进程之间要更加小心。

多线程常见问题
并发和并行的区别是什么？

这两个词经常被混用，但区别其实很清晰，关键就一句话：是不是同一时刻真的在同时跑。

并发(Concurrency)指的是同一段时间内多个任务交替推进。在单核CPU上，同一时刻其实只有一个线程在执行，操作系统靠时间片轮转快速切换，让多个线程轮流占用CPU，由于切换足够快，宏观上看就像它们在"同时"进行，但微观上是先后交替的。

并行(Parallelism)则是同一时刻多个任务真的在同时执行，这必须依赖多核CPU——每个核各跑一个线程，才谈得上真正的并行。

所以可以这样记：并发强调的是任务的切换与调度，单核也能并发。并行强调的是物理上的同时执行，必须有多核。并行一定是并发，但并发不一定是并行。

同步和异步是什么意思？

同步和异步描述的是"发起调用方在拿到结果之前要不要一直等"。

同步调用是指调用方发起调用后，必须等到结果返回才能继续往下走，期间一直处于等待状态。最典型的就是一个普通的方法调用：

int result = compute();      // 必须等 compute() 算完返回，才会执行下一行
System.out.println(result);


异步调用则是调用方发起调用后立即返回，不在原地等结果，结果通过回调、Future等方式在将来某个时刻再拿。例如用线程池提交任务，submit会立刻返回一个Future，主线程可以先去做别的事，需要结果时再通过get获取：

Future<Integer> future = executor.submit(() -> compute()); // 立即返回，不阻塞
doSomethingElse();                                         // 主线程继续做别的事
int result = future.get();                                 // 真正需要结果时再取，此时才可能阻塞


需要注意，同步/异步关注的是"调用方等不等结果"，而阻塞/非阻塞关注的是"线程等待期间能不能被释放去做别的"，两组概念经常一起出现，但并不等价。

多线程到底解决了什么问题（从单核与多核视角看）

从宏观角度来看:线程可以理解为轻量级进程，切换开销远远小于进程，所以在多核CPU的计算机下，使用多线程可以更好的利用计算机资源从而提高计算机利用率和效率来应对现如今的高并发网络环境。

从微观场景下来说: 单核场景,在单核CPU情况下，假如一个线程需要进行IO才能执行业务逻辑，若只有单线程，这就意味着IO期间发生阻塞线程却只能干等。假如我们使用多线程的话，在当前线程IO期间，我们可以将其挂起，让出CPU时间片让其他线程工作。

多核场景下，假如我们有一个很复杂的任务需要进程各种IO和业务计算，假如只有一个线程的话，无论我们有多少个CPU核心，因为单线程的缘故他永远只能利用一个CPU核心，假如我们使用多线程，那么这些线程就会映射到不同的CPU核心上，做到最好的利用计算机资源，提高执行效率。在任务可充分并行、忽略同步与上下文切换开销的理想情况下，执行时间才接近 单线程时间/核心数，若存在串行部分则受Amdahl定律约束，加速比会明显低于核心数。

程序计数器、虚拟机栈、本地方法栈为什么线程中是各自独立的
程序计数器私有的原因:学过计算机组成原理的小伙伴应该都知晓，程序计数器用于记录当前下一条要执行的指令的单元地址，JVM也一样，有了程序计数器才能保证在多线程的情况下，这个线程被挂起再被恢复时，我们可以根据程序计数器找到下一次要执行的指令的位置。
虚拟机栈私有的原因：每一个Java线程在执行方法时，都会创建一个栈帧用于保存局部变量、常量池引用、操作数栈等信息，在这个方法调用到完成前，它对应的信息都会基于栈帧保存在虚拟机栈上。
本地方法栈私有的原因:和虚拟机栈类似，只不过本地方法栈保存的native方法的信息。

所以为了保证局部变量不被别的线程访问到，虚拟机栈和本地方法栈都是私有的，这就是我们解决某些线程安全问题时，常会用到一个叫栈封闭技术。

关于栈封闭技术如下所示，将变量放在局部，每个线程都有自己的虚拟机栈，线程安全。如下图：共享变量globalVariable位于多线程共享的堆中，并发自增会有竞争，而neverGoOut是方法内局部变量，分别存放在各自线程私有的虚拟机栈帧里，互不干扰、天然线程安全。

public class StackConfinement implements Runnable {

    //全局变量，多线程操作会有线程安全问题
    int globalVariable = 0;

    public void inThread() {
        //栈封闭：变量定义在方法内部，属于每个线程私有的虚拟机栈，天然线程安全
        int neverGoOut = 0;
        for (int i = 0; i < 10000; i++) {
            neverGoOut++;
        }

        System.out.println("栈内保护的数字是线程安全的：" + neverGoOut);//栈内保护的数字是线程安全的：10000

    }

    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            globalVariable++;
        }
        inThread();
    }

    public static void main(String[] args) throws InterruptedException {
        StackConfinement r1 = new StackConfinement();
        Thread thread1 = new Thread(r1);
        Thread thread2 = new Thread(r1);
        thread1.start();
        thread2.start();
        thread1.join();
        thread2.join();
        
        System.out.println(r1.globalVariable); //13257
    }
}

创建线程方式有哪些

直接继承Thread启动运行：

public static void main(String[] args) {
        new Task().start();
    }

    /**
     * 继承thread重写run方法
     */
    private static class Task extends Thread {
        @Override
        public void run() {
            Console.log("{} is running", Thread.currentThread().getName());
        }
    }



通过继承Runable实现run方法并提交给thread运行：

public static void main(String[] args) {
       new Thread(new Task()).start();
    }

    /**
     * 继承Runnable重写run方法
     */
    private static class Task implements Runnable {
        @Override
        public void run() {
            Console.log("{} is running", Thread.currentThread().getName());
        }
    }

为什么需要Runnable接口实现多线程

前面提到继承Thread也能创建线程，那为什么还需要Runnable接口？根本原因在于Java为了避免多继承带来的菱形问题，只支持单继承，一个类最多只能继承一个父类。

这就带来一个现实问题：如果某个类已经继承了别的父类，它就没办法再继承Thread了。例如一个业务类已经继承了某个基类，此时还想让它具备多线程执行的能力，继承Thread这条路就被堵死了：

// 已经继承了业务基类，无法再 extends Thread
public class OrderService extends BaseService {
    // ...
}


这种情况下，实现Runnable接口就成了唯一可行的方式——接口可以实现多个，不占用那唯一的继承名额：

public class OrderService extends BaseService implements Runnable {
    @Override
    public void run() {
        // 多线程要执行的逻辑
    }
}
// 把任务交给 Thread 去跑
new Thread(new OrderService()).start();


所以Runnable的价值不只是"另一种写法"，它把"任务"和"线程"解耦开，让任何一个类都能在不影响自身继承结构的前提下获得并发执行的能力。

Thread和Runnable使用的区别

两者最终都是把要执行的逻辑写在run方法里，再由线程去跑，区别主要体现在使用方式和适用场景上。

继承Thread时，线程逻辑直接写在Thread子类的run方法里，启动时new出对象调用start即可：

class MyThread extends Thread {
    @Override public void run() { /* 任务逻辑 */ }
}
new MyThread().start();


实现Runnable时，逻辑写在Runnable实现类里，它本身不是线程，需要再包一层Thread才能执行：

class MyTask implements Runnable {
    @Override public void run() { /* 任务逻辑 */ }
}
new Thread(new MyTask()).start();


看起来Runnable多写了一步，但它在工程上更被推荐，原因有三：一是不占用单继承名额，二是把"任务"和"线程"解耦，同一个任务可以交给不同的线程甚至线程池去执行，三是多个线程可以共享同一个Runnable实例，方便在它们之间共享数据：

MyTask task = new MyTask();   // 同一个任务实例
new Thread(task).start();