---
title: "OpenClaw-Skills"
type: entity
date: 2026-05-10
also_known_as:
  - "OpenClaw Skills 系统"
  - "Agent Skills"
tags:
  - skills
  - openclaw-module
  - knowledge-pack
sources:
  - "[[深入理解OpenClaw技术架构与实现原理-下]]"
  - "[[OpenClaw-Agent与Skill架构详解]]"
  - "[[玩转OpenClaw-核心架构-运作原理-Agent部署步骤]]"
  - "[[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]"
related_entities:
  - "[[OpenClaw]]"
---

# OpenClaw-Skills

## 一句话定义

OpenClaw-Skills 是 [[OpenClaw]] 的"知识/指令包"扩展系统：一个 Skill = 一份 `SKILL.md` 文件，告诉 Agent **如何做某类事情**——它不是可执行代码，而是一份结构化的操作指南。Skill 的菜单（name + description + location）按需注入 system prompt，**SKILL.md 全文不预读**，Agent 自主决定何时打开哪一份。

## 摘要

Skills 是 OpenClaw "知识扩展"维度的核心机制。它解决的问题是：同一个 Agent 面对"帮我创建 GitHub PR"和"帮我查今天的天气"需要截然不同的操作知识，如何在不修改核心代码、也不爆掉上下文窗口的前提下灵活注入？

OpenClaw 的答案是 6 源加载 + 优先级覆盖 + 多层过滤 + 菜单注入 + 自主选择，加上"never read more than one skill up front"的关键约束，让 50+ 内置 Skill 协同工作而不爆 token。

## 详情

### Skill 的本质

- 一份带 frontmatter 的 Markdown 文件，文件名固定为 `SKILL.md`
- 描述"如何做某类事情"——例如怎么创建 PR、怎么发邮件、怎么操作浏览器
- **不是代码**，是给 LLM 看的操作指南
- OpenClaw 项目内置 50+ 个 Skill，覆盖开发工具、知识管理、通信平台等

### 6 源加载（按优先级，高覆盖低）

由 `src/agents/skills/workspace.ts` 的 `loadSkillEntries()` 合并：

1. **project-level skills**（最高优先级）—— 项目目录内的 Skill 覆盖同名内置
2. **plugin skills** —— 已启用插件提供的 Skill（每个插件通过 `openclaw.plugin.json` 的 `skills` 字段声明）
3. **user-level skills** —— `~/.openclaw/skills/` 用户级目录
4. **bundled skills** —— OpenClaw 内置 Skill 库（约 50+）
5. **external skills** —— 通过环境变量等额外路径注入
6. **fallback skills**（最低优先级）

### 内置 Skill 目录解析顺序

`src/agents/skills/bundled-dir.ts` 按顺序查找：

1. 环境变量 `OPENCLAW_BUNDLED_SKILLS_DIR`（最高）
2. 可执行文件同级的 `skills/` 目录（适用 `bun --compile`）
3. 从包根向上查找含 `SKILL.md` 的 `skills` 目录

### 多层过滤

`shouldIncludeSkill()` 的过滤链：

1. **配置禁用**：`skillConfig.enabled === false` → 排除
2. **内置白名单**：bundled Skill 必须在 `allowBundled` 列表中
3. **运行时资格**：检查 OS 兼容、必要二进制工具、必要环境变量

### 数量限制（防膨胀）

```typescript
SkillsLimitsConfig = {
  maxCandidatesPerRoot?: number;       // 每个来源目录的最大候选数
  maxSkillsLoadedPerSource?: number;   // 每个来源的最大加载数
  maxSkillsInPrompt?: number;          // Prompt 中的最大 Skill 数
  maxSkillsPromptChars?: number;       // Prompt 中 Skill 段的最大字符数
  maxSkillFileBytes?: number;          // 单个 SKILL.md 最大字节数
}
```

### 菜单注入（关键设计）

由 `src/agents/system-prompt.ts` 的 `buildSkillsSection()` 完成。注入到 system prompt 的 **Skills** 段只包含每个 Skill 的：

- `name`
- `description`
- `location`

**不包含 SKILL.md 的完整内容**。Agent 看到的是一份"我有什么 Skill 可选"的菜单，而非全文。这是一个克制但有效的优化——常见反模式是把所有 SKILL.md 全文塞进 prompt，会迅速吃掉上下文窗口。

### 自主选择 + 关键约束

Skill 的选择由 LLM 自主完成，是"正常的多轮对话"——不是规则匹配。

> **never read more than one skill up front** —— 关键约束：每次最多选择一个 Skill，避免不必要的 token 消耗。

需要细读时再 `read SKILL.md`，类似"图书馆的目录卡片 vs 书本本身"。

### SkillSnapshot 缓存

```typescript
SkillSnapshot = {
  prompt: string;                    // 已生成的 Skill 菜单 Prompt
  skills: Array<{
    name: string;
    primaryEnv?: string;
    requiredEnv?: string[];
  }>;
  skillFilter?: string[];            // Agent 级过滤
  resolvedSkills?: Skill[];
  version?: number;
};
```

子 Agent 启动时复用父 Agent 的 SkillSnapshot，避免重复加载。

### 与 Subagent 的互补

- **Skills** = 知识扩展（给 Agent 一本操作手册）
- **Subagent** = 并行扩展（派出多个 Agent 分头干活）

二者不是替代关系而是互补——Agent 可以读取 Skill 获得知识后，再创建多个子 Agent 并行执行。

### CLI 实操

```bash
openclaw skill install <name>   # 安装
openclaw skill list             # 列出
openclaw skill update           # 更新（建议离线）
openclaw skill sync             # 同步并备份
```

## 与其他实体的关系

- [[OpenClaw]] —— 父系统；Skills 是 [[OpenClaw]] 16 大模块之一（章节 3.10）
- [[OpenClaw-SandBox]] —— 平行子系统；SandBox 的工具策略可以禁用某些 Skill 触发的工具
- [[OpenClaw-双源记忆系统]] —— 平行子系统；都用"文件即真相"的设计哲学（一个用 SKILL.md，一个用 MEMORY.md）

## 参考来源

- [[深入理解OpenClaw技术架构与实现原理-下]]（章节 3.10）
- [[OpenClaw-Agent与Skill架构详解]]（最详尽源码级解析）
- [[玩转OpenClaw-核心架构-运作原理-Agent部署步骤]]（CLI 实操段）
- [[深度解析OpenClaw在Prompt-Context-Harness三个维度中的设计哲学与实践]]（System Prompt 第 6 个模块）

## 相关综合

- [[OpenClaw-digest-20260510]]
