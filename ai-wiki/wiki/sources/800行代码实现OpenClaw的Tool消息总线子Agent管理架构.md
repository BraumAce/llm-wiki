---
title: "800行代码实现 Open Claw 的 Tool 消息总线 子Agent管理架构"
type: source
date: 2026-05-30
source_type: webpage
source_url: "https://mp.weixin.qq.com/s/7dkGfGUsr3UNHSwZ0EoI9g"
author: ""
ingested_at: 2026-05-30
tags:
  - openclaw
  - agent
  - tool-system
  - message-bus
  - subagent
  - typescript
  - architecture
related_entities:
  - "[[OpenClaw]]"
  - "Anthropic-Claude-API"
related_topics:
  - "[[Agent架构演进-主题]]"
---

# 800行代码实现 Open Claw 的 Tool 消息总线 子Agent管理架构

## 一句话概括

基于 Anthropic Claude API 用 TypeScript 从零实现一个最小可运行的 Agent 框架（约 800 行），覆盖 Tool 系统、消息总线、子 Agent 管理、REPL 主循环四个核心模块，论证"薄抽象、显式控制流、贴近模型 API"的实现方式比引入多层中间件更容易获得工程确定性。

## 实践内容

### Tool 抽象类

一个工具由四个要素组成：name、description、input_schema、execute。input_schema 类型直接取自 `@anthropic-ai/sdk` 的 Tool 类型定义，没有中间层转换：

```typescript
export abstract class Tool {
  abstract readonly name: string;
  abstract readonly description: string;
  abstract readonly input_schema: AnthropicTool["input_schema"];
  abstract execute(args: Record<string, unknown>): Promise<unknown>;
  toSchema(): AnthropicTool {
    return {
      name: this.name,
      description: this.description,
      input_schema: this.input_schema,
    };
  }
}
```

schema 使用运行时普通对象定义，而非 Zod 等库——零额外依赖、直接对齐 SDK 类型。代价是没有运行时参数校验，LLM 传入的参数类型错误只能靠 execute 内部的 as 断言兜底。

### ToolRegistry

注册表是 `Map<string, Tool>`，提供 register、execute、getToolDefinition、exclude 四个方法。`exclude()` 为子 Agent 设计——从主 Agent 工具集中排除特定工具（如 spawn、message），返回新的 ToolRegistry 实例，不修改原注册表：

```typescript
export class ToolRegistry {
  private tools = new Map<string, Tool>();
  register(tool: Tool) {
    this.tools.set(tool.name, tool);
  }
  async execute(name: string, args: Record<string, unknown>) {
    const tool = this.tools.get(name);
    if (!tool) throw new Error(`Tool "${name}" not found`);
    return tool.execute(args);
  }
  getToolDefinition(): AnthropicTool[] {
    return Array.from(this.tools.values()).map((tool) => tool.toSchema());
  }
  exclude(names: string[]): ToolRegistry {
    const excludeSet = new Set(names);
    const filtered = new ToolRegistry();
    for (const [name, tool] of this.tools) {
      if (!excludeSet.has(name)) {
        filtered.register(tool);
      }
    }
    return filtered;
  }
}
```

### EditFileTool 强制唯一匹配

出现 0 次报错，超过 1 次拒绝写入并要求提供更精确的文本片段，防止 LLM 给出模糊替换目标导致意外修改多处代码：

```typescript
const occurrences = content.split(oldText).length - 1;
if (occurrences === 0) {
  return `Error: old_text not found in ${filePath}`;
}
if (occurrences > 1) {
  return `Warning: old_text found ${occurrences} times in ${filePath}. Please provide a more unique text snippet. No changes made.`;
}
const updated = content.replace(oldText, newText);
```

### ExecTool 三层防护

第一层，危险命令正则黑名单：

```typescript
const DANGEROUS_PATTERNS: RegExp[] = [
  /rm\s+(-[a-zA-Z]*f[a-zA-Z]*\s+)?(-[a-zA-Z]*r[a-zA-Z]*\s+)?\/($|\s)/,
  /rm\s+-[a-zA-Z]*rf?\s+~($|\/|\s)/,
  /mkfs\b/,
  /dd\s+if=/,
  /:\(\)\s*\{\s*:\|:\s*&\s*\}\s*;/,   // fork bomb
  />\s*\/dev\/[sh]d[a-z]/,              // 写入裸设备
  /chmod\s+-R\s+777\s+\//,
];
```

第二层，资源限制：默认 30 秒超时，2MB maxBuffer。第三层，输出截断——超过 10,000 字符时取首尾各 5,000 字符，保留首尾是因为命令输出的末尾通常包含最有价值的信息（错误信息、统计摘要等）：

```typescript
function truncateOutput(text: string): string {
  if (text.length <= MAX_OUTPUT_LENGTH) return text;
  const half = Math.floor(MAX_OUTPUT_LENGTH / 2);
  return (
    text.slice(0, half) +
    `\n\n--- truncated (${text.length} chars total) ---\n\n` +
    text.slice(-half)
  );
}
```

### WebFetchTool 纯正则 HTML 转文本

没有使用 DOM 解析库（如 cheerio、jsdom），纯正则处理，内容超过 20,000 字符时截断：

```typescript
function htmlToText(html: string): string {
  return html
    .replace(/<script[\s\S]*?<\/script>/gi, "")
    .replace(/<style[\s\S]*?<\/style>/gi, "")
    .replace(/<(br|\/p|\/div|\/li|\/tr|\/h[1-6])[^>]*>/gi, "\n")
    .replace(/<[^>]+>/g, "")
    // HTML 实体解码...
    .replace(/[ \t]+/g, " ")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}
```

### MessageTool 出站消息通道

通过构造时注入的 sendCallback 向外部发送消息。REPL 场景下 sendCallback 就是 console.log；Bot 场景下替换为向 Telegram、Discord 等平台发送消息的函数。工具本身不关心消息最终去向：

```typescript
export class MessageTool extends Tool {
  constructor(private sendCallback: SendCallback) {
    super();
  }
  async execute(args: Record<string, unknown>): Promise<string> {
    const content = args.content as string;
    const channel = (args.channel as string) ?? "repl";
    const chatId = (args.chat_id as string) ?? "default";
    await this.sendCallback({ channel, chatId, content });
    return `Message sent to ${channel}:${chatId}`;
  }
}
```

### CronTool + CronService 定时任务

CronService 基于 setInterval 实现，支持 every_seconds 和 cron_expr 两种定时方式。cron 表达式解析是简化版本，只处理 `*/N`、每小时、每天等常见模式，复杂表达式静默降级为每分钟执行一次：

```typescript
private parseCronInterval(expr: string): number {
  const parts = expr.trim().split(/\s+/);
  if (parts.length !== 5) return 60_000;
  const [minute, hour] = parts;
  if (minute?.startsWith("*/") && hour === "*") {
    const n = parseInt(minute.slice(2), 10);
    if (!isNaN(n) && n > 0) return n * 60_000;
  }
  if (minute === "0" && hour?.startsWith("*/")) {
    const n = parseInt(hour.slice(2), 10);
    if (!isNaN(n) && n > 0) return n * 3600_000;
  }
  if (minute === "*" && hour === "*") return 60_000;
  if (minute === "0" && hour === "*") return 3600_000;
  if (minute === "0" && hour === "0") return 86400_000;
  return 60_000;
}
```

### MessageBus 入站消息总线

处理从子系统或外部流向主 Agent 的入站消息。两种消费模式：subscribe（注册实时回调，消息到达时立即调用 handler）和 drain（从队列中取出并清空消息，适合轮询式同步消费）。路由规则：有订阅者走回调，无订阅者入队列，消息只走一条路径：

```typescript
export class MessageBus {
  private listeners = new Map<string, Set<MessageHandler>>();
  private queue: InboundMessage[] = [];

  subscribe(channel: string, handler: MessageHandler): () => void {
    if (!this.listeners.has(channel)) {
      this.listeners.set(channel, new Set());
    }
    this.listeners.get(channel)!.add(handler);
    return () => { this.listeners.get(channel)?.delete(handler); };
  }

  async publish(message: InboundMessage): Promise<void> {
    const handlers = this.listeners.get(message.channel);
    if (handlers && handlers.size > 0) {
      for (const handler of handlers) {
        await handler(message);
      }
    } else {
      this.queue.push(message);
    }
  }

  drain(channel?: string): InboundMessage[] {
    if (!channel) {
      const msgs = [...this.queue];
      this.queue = [];
      return msgs;
    }
    const matched = this.queue.filter((m) => m.channel === channel);
    this.queue = this.queue.filter((m) => m.channel !== channel);
    return matched;
  }
}
```

InboundMessage 数据结构包含四个字段：channel（消息通道）、sender（发送者标识）、chat_id（关联会话，格式为 channel:chat_id）、content（消息内容）。

### SubagentManager 子 Agent 管理

单进程并发模型。每个子 Agent 是一个 Promise，共享同一个 Node.js 事件循环，没有多进程、没有 Worker。每个子 Agent 拥有独立的 AgentLoop 实例，有自己的 ReAct 循环，没有历史上下文——每次从零开始，处理完一个任务就结束。子 Agent 的工具集是主 Agent 的受限子集（通过 ToolRegistry.exclude() 实现）。

## 摘录

> 这是一个基于 Anthropic Claude API 的 Agent 框架，用 TypeScript 编写，运行在单进程 Node.js 环境中。本文记录其中四个核心模块的实现：工具系统（Tool layer）、消息总线（MessageBus）、子 Agent 管理（SubagentManager）、REPL 主循环。不涉及上层 Bot 接入层、持久化、Context / Memory 系统。框架不依赖 LangChain 或其他 Agent 框架，直接基于 Anthropic SDK 构建。选择这条路的原因很简单：中间层越薄，调试越容易，对 API 行为的控制越精确。

> 本文想说明的技术观点是对于 Tool 调用、消息分发、子 Agent 管理这三类 Agent 系统里的核心组件，优先采用薄抽象、显式控制流和贴近模型 API 的实现方式，往往比引入多层中间件更容易获得工程上的确定性。系统边界更清晰，运行路径更容易追踪，问题更容易定位，也更适合作为后续扩展 Memory、调度和持久化能力的基础。

> MessageTool 负责出站（Agent → 外部），MessageBus 负责入站（外部/子系统 → Agent）。两者没有直接的代码耦合，方向相反。

## 涉及实体

- [[OpenClaw]] —— 本文研究的 Agent 框架系统，覆盖其中 Tool、消息总线、子 Agent 管理三个核心模块的实现
- Anthropic-Claude-API —— 框架底层依赖的 LLM API，input_schema 类型直接取自 @anthropic-ai/sdk

## 涉及主题

- [[Agent架构演进-主题]] —— 薄抽象 vs 多层中间件的架构取舍、Tool 消息总线子 Agent 管理三大核心组件的最小实现范式
