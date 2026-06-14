---
title: "AI-Friendly-API"
type: entity
date: 2026-06-02
also_known_as: [AI Friendly API, LLM-Friendly API, AI可理解API]
tags: [API设计, AI工程, 工具]
sources: [面向LLM的架构设计-什么是真正的AI-Friendly架构]
related_entities: [AI-Friendly架构, MCP, Agentic-Engineering]
related_topics: []
---

# AI Friendly API

## 一句话定义

AI Friendly API是针对大语言模型使用场景优化的接口设计范式，核心思想是让接口的定义从"面向人"转向"面向AI"，使工具调用更加可靠和高效。

## 摘要

AI Friendly API是AI Friendly架构中的关键能力之一。在传统工程中，API设计以人为服务对象，接口名称、入参、出参都隐含大量业务语义，这对人类开发者友好但对大模型极不友好。AI Friendly API通过工具原子化改造、出入参拟人化改造、Error信息改造三个维度，让接口从REST-ful升级为LLM-ful。

## 详情

### 起源与背景

传统工程的接口设计以"人"为服务对象，隐含了很多业务或约定成俗的语义。当工具的使用主体从"人"转向"AI"时，这些隐含语义就成了大模型难以理解的黑盒。嵌套过深的JSON结构、技术命名、字段缩写等问题进一步加剧了这一矛盾。AI Friendly API的核心目标就是让接口的定义从REST-ful（面向人）转向LLM-ful（面向AI）。

### 核心机制 / 工作原理

#### 改造三要素

**1. 工具原子化改造**

将接口按原子能力重新拆分，拆分成适配大模型ReAct推理过程的原子工具。每个工具做一件事、做好一件事，避免工具间耦合导致大模型选择困难。

```
改造前：
- submitMarketingCampaign()   // 一个大接口包含数十个参数

改造后：
- createCampaign()
- addProductsToCampaign()
- setBudgetLimit()
- scheduleCampaign()
- publishCampaign()
```

原子化改造的原则：
- 每个工具只做一件事
- 工具粒度要匹配大模型的推理能力——太粗则参数过多，太细则工具爆炸
- 工具之间解耦，不依赖调用顺序
- 支持组合：多个原子工具可以组合完成复杂任务

**2. 出入参改造**

接口名称和参数的改造是AI Friendly API的核心工作。具体包括：

- **接口命名**：名称清晰、直接体现用途，避免技术缩写
- **参数简化**：仅保留核心参数，去除冗余信息
- **结构扁平化**：平铺KV对，避免深层嵌套
- **枚举值人类化**：用自然语言描述而非代号

```
改造前（面向人）：
{
  "req": {
    "bizScene": "SEC_KILL",
    "prodMeta": {
      "skuList": [
        {"s": "12345", "n": "商品A"}
      ]
    }
  }
}

改造后（面向AI）：
{
  "scene": "秒杀活动",
  "product_name": "商品A",
  "product_sku": "12345"
}
```

**3. Error信息改造**

错误信息的改造直接影响大模型的推理决策能力：

- **预期内错误**：简短、明确的自然语言描述，帮助大模型快速判断下一步行动
- **预期外错误**：保留技术细节和堆栈，帮助大模型诊断问题根源

```
预期内错误：
"商品已审核通过，无法再次提交审核。如需修改请先撤回。"

预期外错误：
"数据库连接超时。错误详情：ConnectionTimeout at
com.alibaba.hsf.util...（附带完整堆栈）"
```

### 与MCP协议的关系

AI Friendly API是工具设计理念，MCP（Model Context Protocol）是实现这一理念的协议标准。MCP将AI Friendly API的设计原则标准化：

- MCP的Tool定义天然要求原子化（每个Tool一个功能）
- MCP的参数Schema（JSON Schema）天然要求结构化
- MCP的Error响应格式为标准化错误处理提供基础

在实践层面，AI Friendly API设计 → MCP Tool定义 → Agent工具调用，是一条完整的链路。

### 应用场景

- Function Calling的工具定义
- MCP Server的Tool设计
- Agent的工具调用层
- 任何AI系统需要自主调用外部接口的场景

### 局限与注意事项

- 工具使用本身在Function Calling/MCP/Skill协议相对完善的今天已不构成门槛
- 核心难点在于工具的"质量"——原子化粒度、参数设计、错误描述
- 过度拆分可能导致工具数量过多，增加大模型的选择负担
- 需要在"原子化"和"实用性"之间找到平衡
- 命名规范化需要团队共识，建议建立工具命名约定文档
