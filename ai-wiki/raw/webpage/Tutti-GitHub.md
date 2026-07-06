---
title: "Tutti-GitHub"
source_url: "https://github.com/tutti-os/tutti"
author: "tutti-os"
fetched_at: "2026-07-06T23:44:48+08:00"
fetcher: "github-api-and-raw"
---

# GitHub Metadata

```json
{
  "full_name": "tutti-os/tutti",
  "description": "Where people and agents build in tune.",
  "html_url": "https://github.com/tutti-os/tutti",
  "default_branch": "main",
  "latest_commit": "8f7bbdf110bf604c7906bf507ee3e7efd46a1603",
  "latest_commit_date": "2026-07-06T15:24:51Z",
  "latest_commit_message": "Merge pull request #833 from tutti-os/docs/readme-contributors\n\ndocs: add Contributors section to READMEs",
  "stars": 446,
  "forks": 36,
  "open_issues": 91,
  "license": "Apache-2.0",
  "language": "TypeScript",
  "pushed_at": "2026-07-06T15:24:51Z"
}
```

# README.zh-CN.md

<div align="center">

<img src="docs/assets/banner.jpg" alt="Tutti" width="100%" />

**人与 Agent「同频」协作的地方。**

[官网](https://tutti.sh/?tc=25q) · [文档](docs/README.md) · [参与贡献](CONTRIBUTING.zh-CN.md)

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md)

[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![Website](https://img.shields.io/badge/website-tutti.sh-black.svg)](https://tutti.sh/?tc=25q)

</div>

---

如果你喜欢 Tutti，欢迎给我们一个 Star，或者 Fork 仓库、提交 Issue、发起 PR。

也欢迎感兴趣的朋友加入我们的微信群，分享反馈、提出问题，一起定义人与 Agent 协作的未来。

<img src="docs/assets/zh/wechat-group.png" alt="扫码加入 Tutti 微信群" width="240" />

**Tutti，现已开源。**

**Tutti · VM 正在路上，有兴趣的各位，欢迎到官网加入我们的 Waitlist：**

**[tutti.sh →](https://tutti.sh/?tc=25q)**

## Tutti 是什么？

你的 Claude Code 很强，Codex 也很强，Canvas 很强，Claude Design 也很强。

可涉及到真实的工作流，需要互相依赖、彼此接力的时候。

这其中，最忙的常常是你。

Claude 写完接口，Codex 要接前端，你复制接口文档、补充当前进度，再解释刚才为什么这么写。前端之前，想要页面好看还涉及到设计、做图，总结一下再用生图应用出了图。又下载、上传、贴给下一个 Agent，再去描述一下需求。

说好是让 Agents 帮你干活，最后你成了它们之间的传话筒。

### Tutti 提供了一个实时共享的工作空间：上下文、文件、应用、任务，全部打通

![Tutti 的实时共享工作空间](docs/assets/zh/workspace-hero.jpg)

Codex 能无缝使用 Claude 的产出，彼此不丢任何上下文，一致得像「共脑」。

不仅如此，Tutti 还有自己的应用生态：生图、UI/UX 设计、写文档、做 PPT；你能用，Agent 也能用。

Codex 调用原型设计应用做好了设计，就像拥有了 Claude Design 的能力；Claude Code 可以直接拿去做页面开发，不用你来回复制粘贴。

**一切在 Tutti 中彼此可见、互相依赖。任何产物，包括应用生成的输出，都能在不同 Agent 之间流转、传递，直接用于下一步。**

## 如果这是你，欢迎你来用用！

- 同时用多个 AI Agent（Codex、Claude Code、Canvas 等等）
- 不止一次在 Agent 之间复制过上下文，甚至自己搭了个 Markdown 文档交接的工作流
- 什么事都想让 AI 做，却总觉得还没那么顺手，换个新 Agent 上下文都得从头再来
- 尝试过订阅其他 AI 产品，却又觉得不够划算
- 面对更复杂的工作流时：不同产品之间是孤岛，来回搬运同步的步骤只会变得更多

**Tutti 不是替代你的 coding agent，而是 Agent-Agent 实时共享的工作空间。**

<p align="center">
  <img src="docs/assets/zh/why-tutti.jpg" alt="Tutti 是 Agent 与 Agent 实时共享的工作空间" width="70%" />
</p>

## 三大核心功能

### 1）实时共享的工作空间

Agent 不再简单交接摘要，而是共享同一个实时工作空间：共享上下文、文件、在跑的任务、应用。你的 Codex 能看到 Claude 改了什么、正在运行什么、项目当前处于什么状态。

所以你解锁了三项能力：

#### Big「@」

- 你可以在 Codex 中 @ 历史对话、文件、应用、任务；无需反复粘贴、上传。
- 你也可以在 Codex 中 @ Claude Code 的历史对话、文件、应用、任务，并在此基础上构建，无需手动搬运上下文。
- 你也可以在 Codex 中，让 Codex 指挥、@ Claude Code（应用）干活。

<p align="center">
  <img src="docs/assets/zh/at-history.jpg" width="32%" />
  <img src="docs/assets/zh/at-claude.jpg" width="32%" />
  <img src="docs/assets/zh/at-command.jpg" width="32%" />
</p>

#### 引用「+」

在 Agent 对话框点击「+」：引用本地文件、引用应用生成的产物。

<p align="center">
  <img src="docs/assets/zh/plus-reference.jpg" width="60%" />
</p>

#### 任务编排与多项目构建

各 Agent 彼此「可见」，因此可以自动回避或处理冲突，自己判断该并行还是串行。跨不同服务提供方的 Agent，比如 Claude 和 Codex、Gemini 和 Hermes（Kimi），一样不打架。

**Tutti · VM 中：**

- 「@」流动在协同者之间，你可以 @ 朋友与他任意 Agent 的对话、文件、任务，也可以点击「+」引用朋友调用应用生成的产物。

### 2）人-Agent 共用的「应用」

完整的工作很少只靠一个 Agent。

做一个页面，可能要先出原型，再写代码，再补图。写一篇文章，也可能要配图、排版、导出。这些能力都有很强大的 Agent 承接，你挨个付费，然后来回打开、下载、上传、截图、粘贴。工作还没变难，搬东西先搬烦了。

Tutti 里有自己的应用中心，也实时共享整个工作空间。这些应用你可以自己使用，也可以被你的 Agent 调用。

<img src="docs/assets/zh/apps-1.jpg" width="49%" /> <img src="docs/assets/zh/apps-2.jpg" width="49%" />

<img src="docs/assets/zh/apps-3.jpg" width="49%" /> <img src="docs/assets/zh/apps-4.jpg" width="49%" />

**比如：**

- 在 Codex @ 原型设计应用生成 UI 稿，让 Codex 长出 Claude Design 的能力，生成好的东西再让 Codex 拿去开发。
- 你自己用生图应用（AI Canvas）生成了配图，让 Claude Code 或 Codex 帮你放进页面里。
- 讨论好文章框架，@ Codex 用文档应用起草、整理，再帮你生成一个 HTML。
- 过几天要做个 Pre？有个产品介绍想对外发一发？@ Claude Code 用 PPT 应用生成演示文稿。几处细节想手动调一调？不用担心，这里的 AI PPT 支持你自由拖拽模块、编辑文案。

<img src="docs/assets/zh/ppt-1.jpg" width="49%" /> <img src="docs/assets/zh/ppt-2.jpg" width="49%" />

<img src="docs/assets/zh/ppt-3.jpg" width="49%" /> <img src="docs/assets/zh/ppt-4.jpg" width="49%" />

应用产物都会留在同一个工作空间里。下一步需要时，一个「+」引用一下，就能接上。

这些应用也都复用你已有的 Agent 订阅，不把这些能力包一层再卖给你。你可以使用官方、社区创建的应用，也可以自己创建。

### 3）少操作，多产出（Less work about work）

#### 从目标到任务

不用手动拆分、规划每一步。你只需要描述目标，比如「我想做一个网页」。Tutti 会把它拆解为清晰的子任务。你只需要审核，再分配给合适的 Agent。

<p align="center">
  <img src="docs/assets/zh/goal-to-tasks.jpg" width="60%" />
</p>

#### 控制中心

不用在多个 Tab 中来回切换。一个视图看全局：所有 Agent 对话、待你审批的操作、正在运行的任务。需要你确认的地方，快速定位，一键处理。

<p align="center">
  <img src="docs/assets/zh/control-center.jpg" width="60%" />
</p>

#### GUI 界面

无需命令行。打开 Tutti，就能使用 Agents、应用、任务和文件。重度 AI 用户可以少折腾几步，不想碰终端的产品、设计、内容创作者也能直接上手。

## 复用你原有的订阅

直接接入你已有的 Claude、Codex、Gemini 订阅。所有应用和 Agent 都在此基础上运行，零额外费用。

<img src="docs/assets/zh/subscriptions-1.jpg" width="49%" /> <img src="docs/assets/zh/subscriptions-2.jpg" width="49%" />

## Tutti vs Tutti · VM

|              | Tutti（开源）                                                                                               | Tutti · VM（即将上线）                                                                                                                                                                                                           |
| ------------ | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **适合谁**   | 一个人，多个 Agent                                                                                          | 一个人，多个 Agent<br>一个人，多台设备<br>两人及以上，各自带着自己的 Agent                                                                                                                                                       |
| **跑在哪**   | Agent 跑在本地，工作态在本地                                                                                | 采用多层虚拟机技术，把你的本地 Agent 虚拟化进一个实时共享的云端工作空间。<br><br>Agent 仍然跑在本地，工作态实时进云端：正在聊的、正在跑的、做好了的……于是你能跨设备、跨人、跨 Agent 协作，彼此不丢任何上下文，一致得像「共脑」。 |
| **共享什么** | 多个 Agent 之间共享上下文、应用、产物、任务和运行状态                                                       | 包含本地版的全部内容，另外支持在多人、多设备之间共享                                                                                                                                                                             |
| **订阅**     | 你自己的 Claude、Codex 等订阅<br>（目前仅支持 Claude Code、Codex；OpenClaw、Gemini、Hermes 正在开发接入中） | 你自己的 Claude、Codex 等订阅<br>（目前仅支持 Claude Code、Codex；OpenClaw、Gemini、Hermes 正在开发接入中）                                                                                                                      |

### Tutti：你可以用它来做什么？

- 让 Codex 接着 Claude 的工作继续做，不用重新说明上下文。
- 让 Claude 写完 PRD 后，直接调用设计应用生成图片。
- 用你已有的 Agent 订阅，调用 Tutti 内的所有应用。
- 描述一个目标，让 Tutti 拆成多个子任务，再把每个分配给合适的 Agent 执行。

### Tutti · VM：你可以用它来做什么？

**包含 Tutti 的全部能力，额外实现：**

- 开一个云端房间，让多台设备在里面工作，就像在用同一台电脑。
- 和朋友协作时，不用互相发文件、贴进度、复述 Agent 刚做了什么。只要在同一个云端房间，就能看到彼此在房间里的对话、文件、产物、任务进展和应用生成的结果。
- 用「@」引用同事的文件、与 Agent 的对话等，让你的 Agent 在此基础上继续构建。
- 你本地跑起来的网站（localhost），不用先部署上线，朋友就能在云端房间里直接打开预览，给你提意见、帮你改。
- 当一件事需要多人，把任务分配给同事的 Agent 执行。

> ⚠️ 以上共享以房间为维度：邀请人与受邀人需加入同一房间，只有在同一房间内产出的内容才会被共享，其余内容都保持私密。

## Tutti 适合谁？

任何用 AI Agent 来 build 的人：只要你受够了在不同 Agent、应用之间来回切换，受够了反复重新交代背景、手动搬运产物，受够了为每份订阅单独花钱，Tutti 就是为你设计的。

- **独立开发者**：让 Claude 出方案，Codex 接力开发，不用再重复解释项目背景。
- **设计师**：用设计应用出设计稿，直接让 Codex 拿去开发落地。
- **产品经理**：让 Codex 写完 PRD 后，自动调用 UI/UX 设计应用出原型，不用再打开 Figma。
- **内容创作者**：脚本、配图，在同一个工作空间里一站式产出。

无论你是什么角色，都能在这里找到各环节里摩擦最低的使用组合。全 GUI 界面，无需终端命令行，打开就能用。

### Tutti · VM 呢？

Tutti 先解决你和你的 Agents。

Tutti · VM 要解决的是：当工作往外走，不同人、不同设备、彼此的 Agents 怎么待在同一个实时共享空间里 —— 即多人的 Agent-Agent 协作。

**通过多层虚拟机技术，把你的本地 Agent 虚拟化进一个实时共享的云端工作空间。**

在这里，Agent 仍然跑在你的本地，继续使用你自己的订阅和配置。但工作态会在神奇的云端：正在聊的、正在做的、已经做好的，都会留在同一个 Room 里。网站、图片、文档、PPT 不需要再上传下载，复制链接就能分享。

你和朋友进入同一个 Room，你可以「@」他昨晚做到一半的任务，也可以把一段工作交给他的 Agent 接着跑。

**Room 在这里，是边界，也是绿洲。**

## FAQ

### 我需要另外购买一个 Agent 订阅吗？

不需要。Tutti 可以使用你已经在用的 Claude、Codex、Gemini 以及其他订阅。

### 如果我没有 Agent 订阅怎么办？

你可以在 Tutti 内使用 Tutti Agent。Tutti Agent 在 Early Access 期间免费，之后可能会采用按用量计费。

### Tutti 和 Tutti · VM 有什么区别？

如果你想和团队成员协作、跨多台设备工作，或者希望把产物保存在一个共享的云端工作空间里，可以使用 Tutti · VM。

### 在 Tutti · VM 版本里，我的团队成员能看到我的私人工作内容吗？

只有在 Tutti · VM 的房间内创建的内容，才会被你邀请进该空间的人看到。其他内容都会保持私密。

### Tutti 会替代我的 coding agent 吗？

不会。Tutti 是围绕你的 agents 构建的工作空间。你仍然可以继续使用你已经信任的 Claude Code、Codex、Gemini 和其他 agents。

### Tutti 只适合 coding 吗？

不是。Tutti 适用于 coding、设计、内容创作、应用工作流，以及任何需要多个 agents 或团队成员共享同一上下文和产物的工作场景。

## Star 趋势

<a href="https://www.star-history.com/?repos=tutti-os%2Ftutti&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=tutti-os/tutti&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=tutti-os/tutti&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=tutti-os/tutti&type=date&legend=top-left" />
 </picture>
</a>

## 贡献者

[![Contributors](https://contrib.rocks/image?repo=tutti-os/tutti)](https://github.com/tutti-os/tutti/graphs/contributors)

## 快速开始

### 下载

<!-- TODO: Tutti · 本地版下载链接 -->

[下载 Tutti · Local](https://tutti.sh/desktop/download?platform=macos&arch=universal&format=dmg)

<!-- TODO: Tutti · VM waitlist 链接 -->

加入 [Tutti · VM waitlist](https://tutti.sh/waitlist) —— 即将开放。

完整开发指南见 [CONTRIBUTING.zh-CN.md](CONTRIBUTING.zh-CN.md)。

## 社区与贡献

欢迎参与贡献——请先阅读[贡献指南](CONTRIBUTING.zh-CN.md)，并了解我们的[行为准则](CODE_OF_CONDUCT.md)。

报告安全漏洞请参见 [SECURITY.md](SECURITY.md)。

## 协议

Tutti 基于 [Apache License 2.0](LICENSE) 开源。

> 注：本代码库使用内部代号 `tutti`，你会在目录和二进制命名中看到它（如 `services/tuttid`）。

> 翻译说明：本文档与英文版内容同步，如有出入，以 [英文版](README.md) 为准。

# AGENTS.md

# AGENTS.md

## Shape

`tutti` is a local-first desktop monorepo.

- `services/tuttid`: business rules, durable local state, daemon workflows
- `apps/desktop`: Electron shell, preload, renderer UI, desktop integration
- `packages/clients/*`: generated and hand-written domain clients
- `packages/configs/*`: shared TypeScript and formatting config
- `config`: sources used to generate runtime defaults

Keep business logic in `services/tuttid`. Do not let `apps/desktop` become a second business core. Do not create vague packages such as `shared`, `common`, `utils`, or `client-sdk`.

## Routing

Read the closest `AGENTS.md` before editing:

- `apps/desktop/*` -> `apps/desktop/AGENTS.md`
- `services/tuttid/*` -> `services/tuttid/AGENTS.md`
- `packages/agent/gui/*` -> `packages/agent/gui/AGENTS.md`
- `packages/ui/*` -> `packages/ui/AGENTS.md`
- `packages/*` -> `packages/AGENTS.md`

Use this root file for repository-wide defaults only. Area-specific files win.

Also route by module name, not only by path. If a request mentions AgentGUI,
AgentGuiNode, Agent GUI, the agent conversation module, agent composer,
workspace agent timeline, agent approvals, or interactive agent prompts, read
`docs/architecture/agent-gui-node.md` first, then
`packages/agent/gui/AGENTS.md`, before planning or editing, even when no file
path is supplied.

## Contribution Workflow

Before preparing commits or pull requests, read `CONTRIBUTING.md` and follow it
for repository-wide contribution requirements, including Conventional Commits,
DCO sign-off, PR workflow, review gates, and multilingual documentation updates.

## Hard Rules

- Published workspace packages use `@tutti-os/*`; keep manifests, imports, docs, and release config aligned.
- User-visible copy must go through the relevant i18n layer. Do not hardcode UI text, dialog text, status labels, empty states, or user-facing errors.
- Change `services/tuttid/api/openapi/tuttid.v1.yaml` before daemon HTTP request/response contracts.
- Document new supported runtime/env overrides in the matching durable convention doc.
- Business-code files should stay at or below `800` lines. Prefer decomposition before adding more logic.
- When changing repository-managed checks, hooks, or static analysis, update `docs/conventions/local-git-hooks.md` or `docs/conventions/static-analysis.md`.
- When a fix captures a recurring debugging trap, add the durable note to `docs/conventions/troubleshooting.md`.

## Self-Evolution Notes

After any code change, run a documentation impact check. If the change affects
module ownership, data flow, user-visible interaction, public API/CLI behavior,
runtime/config/env overrides, validation commands, troubleshooting paths, or
directory responsibility, update the corresponding durable documentation in the
same change.

When proposing a durable lesson from a completed fix or implementation, use the
AutoSkill-style decision set: `discard`, `improve`, `merge`, or `create`.
Record only reusable patterns backed by real implementation/debugging evidence.
Prefer improving or merging an existing note over creating duplicates, and
remove secrets, personal data, local paths, customer names, tokens, and one-off
issue details before writing any prompt, architecture, or troubleshooting
update. For `improve`, `merge`, or `create`, update the matching durable doc:
architecture docs for ownership/data-flow/interaction rules, convention docs
for repository-wide practices, README/package docs for usage or public
contracts, or troubleshooting docs for recurring symptom playbooks. Final
responses should mention which durable docs were updated, or state that no
documentation impact was found.

## Toolchain

- Package manager: `pnpm@10.11.0`
- TypeScript lint: `pnpm lint:ts` -> Oxlint
- TypeScript format: Oxfmt for TS/JS, Prettier for JSON/MD/YAML/CSS/HTML
- Typecheck: `pnpm typecheck` -> compact incremental native TypeScript `tsgo`
- Changed-aware local validation: `pnpm check:changed`
- Full local/CI validation: `pnpm check:full`
- Go lint requires the pinned `golangci-lint`; install with `pnpm install:golangci-lint`

## Common Checks

- Local iteration: `pnpm check:changed`
- TS/desktop/shared changes: `pnpm lint:ts` and `pnpm typecheck`
- Desktop-facing behavior: also `pnpm --filter @tutti-os/desktop build`
- UI-system exports, CSS, SVG/icon rules: `pnpm check:ui-boundaries`
- Renderer feature boundaries: `pnpm check:renderer-boundaries`
- User-visible copy or locale resources: `pnpm check:i18n`
- Defaults source under `config/tutti.defaults.json`: `pnpm generate:defaults` and `pnpm check:defaults-generated`
- Daemon changes: `pnpm lint:go` and `cd services/tuttid && go test ./... && go build ./...`
- TypeScript + Go surface changes: `pnpm lint`

## Hooks

Local hooks use Husky.

- `pre-commit`: `lint-staged`, staged Electron/UI/renderer boundary checks
- `pre-push`: `pnpm check:full`

Prefer `pnpm check:changed` before broader validation during normal AI iteration. It runs selected lanes concurrently, prints compact summaries, and stores full logs under `.tmp/check-runs`; use `--tail-lines <n>` to tune failure tails.

## Conflict Workflows

For merge, rebase, cherry-pick, or manual conflict resolution, inspect both branch intents and never resolve source conflicts with `--ours` or `--theirs` unless explicitly asked. Review high-risk desktop, daemon API, generated contract, release, and shared test harness files manually. After conflicts, run `git diff --name-only --diff-filter=U` and targeted checks for the affected surface.

## Docs

Start from:

- `docs/conventions/README.md`
- `docs/architecture/README.md`
- nearest area `AGENTS.md`

## Logs

dev (when the feature is not in remote): ~/.tutti-dev/tuttid.db

prod: ~/.tutti/tuttid.db

# CONTEXT.md

# Context

## Terms

### Workspace Catalog

Desktop renderer concept that owns the local workspace list, the current
workspace summary, workspace-window startup context, daemon health shown beside
workspace navigation, and catalog actions such as create, open, rename, delete,
and show-dashboard.

### Workspace Catalog Session

One workspace-scoped renderer module interface for Workspace Catalog behavior.
Dashboard and workspace-window views both consume this module. Workbench node
layout persistence is not part of this module.

### Workspace Workbench Session

Renderer concept that owns workbench node layout, snapshot load/save, and node
open/reveal behavior for one workspace window. It depends on Workspace Catalog
for the current workspace context but does not own catalog actions.

### Browser Node

Reusable workspace workbench node capability for embedding HTTP and HTTPS browser
surfaces inside a desktop workspace. The Browser Node owns browser lifecycle,
navigation state, session/profile behavior, guest bridge mechanics, and webview
security policy. Product-specific actions exposed to guest pages are host
adapters, not Browser Node business logic.

# package.json

{
  "name": "tutti",
  "private": true,
  "packageManager": "pnpm@10.11.0+sha512.6540583f41cc5f628eb3d9773ecee802f4f9ef9923cc45b69890fb47991d4b092964694ec3a4f738a420c918a333062c8b925d312f42e4f0c263eb603551f977",
  "workspaces": [
    "apps/*",
    "packages/*/*",
    "services/tuttid/builtin-apps/tutti-onboarding",
    "tools/fixtures/*"
  ],
  "engines": {
    "node": ">=24",
    "pnpm": "10.11.0"
  },
  "pnpm": {
    "overrides": {
      "@radix-ui/react-slot": "1.2.5",
      "yauzl": "3.4.0"
    }
  },
  "scripts": {
    "build": "pnpm -r --if-present build && pnpm generate:builtin-apps && cd packages/appcli/core && go build ./... && cd ../../workspace/files && go build ./... && cd ../../workbench/service && go build ./... && cd ../../../services/tuttid && go build ./... && cd ../../apps/cli && go build ./...",
    "build:go": "pnpm generate:builtin-apps && cd packages/appcli/core && go build ./... && cd ../../workspace/files && go build ./... && cd ../../workbench/service && go build ./... && cd ../../../services/tuttid && go build ./... && cd ../../apps/cli && go build ./...",
    "build:npm-packages": "node ./tools/scripts/build-npm-packages.mjs",
    "check:api-generated": "node ./tools/scripts/generate-openapi.mjs --check",
    "check:agent-activity-runtime-boundaries": "node ./tools/scripts/check-agent-activity-runtime-boundaries.mjs",
    "check:codexproto-generated": "node ./tools/scripts/check-codexproto-generated.mjs",
    "check:defaults-generated": "node ./tools/scripts/generate-defaults.mjs --check",
    "check:changed": "node ./tools/scripts/run-check-changed.mjs",
    "check:electron-runtime-boundaries": "node ./tools/scripts/check-electron-runtime-boundaries.mjs",
    "check:electron-runtime-boundaries:staged": "node ./tools/scripts/check-electron-runtime-boundaries.mjs --staged",
    "check:event-protocol-generated": "node ./tools/scripts/generate-event-protocol.mjs --check",
    "check:full": "node ./tools/scripts/run-check-full.mjs",
    "check:golangci-version": "node ./tools/scripts/setup-dev.mjs --only=golangci-lint",
    "check:i18n": "node ./tools/scripts/check-i18n.mjs",
    "check:tutti-names": "node ./tools/scripts/check-tutti-names.mjs",
    "check:workbench-go-contract": "node ./tools/scripts/generate-workbench-go-contract.mjs --check",
    "check:ui-boundaries": "node ./tools/scripts/check-ui-boundaries.mjs",
    "check:ui-boundaries:staged": "node ./tools/scripts/check-ui-boundaries.mjs --staged",
    "check:workbench-openapi-schema": "node ./tools/scripts/sync-workbench-openapi-schema.mjs --check",
    "check:renderer-boundaries": "node ./tools/scripts/check-renderer-feature-boundaries.mjs",
    "check:renderer-boundaries:staged": "node ./tools/scripts/check-renderer-feature-boundaries.mjs --staged",
    "dev": "pnpm dev:desktop",
    "dev:cli": "node ./tools/scripts/install-dev-cli.mjs",
    "dev:desktop": "pnpm --filter @tutti-os/desktop dev",
    "dev:web": "node ./tools/scripts/dev-web.mjs",
    "dev:ui-storyboard": "pnpm --filter @tutti-os/ui-storyboard dev",
    "preview:desktop": "pnpm --filter @tutti-os/desktop preview",
    "push:checked": "node ./tools/scripts/push-checked.mjs",
    "generate:api": "node ./tools/scripts/generate-openapi.mjs",
    "generate:builtin-apps": "pnpm --filter @tutti-os/builtin-tutti-onboarding package:builtin",
    "generate:defaults": "node ./tools/scripts/generate-defaults.mjs",
    "generate:event-protocol": "node ./tools/scripts/generate-event-protocol.mjs",
    "install:golangci-lint": "node ./tools/scripts/setup-dev.mjs --install=golangci-lint",
    "lint": "pnpm lint:ts && pnpm lint:go",
    "lint:go": "pnpm generate:builtin-apps && node ./tools/scripts/check-http-client-funnel.mjs && node ./tools/scripts/run-golangci-lint.mjs",
    "lint:ts": "oxlint . --deny-warnings",
    "lark:logs": "node ./tools/scripts/lark-log-tool.mjs",
    "format": "pnpm format:code && pnpm format:assets",
    "format:code": "oxfmt --write \"**/*.{ts,tsx,js,jsx,mjs,cjs}\"",
    "format:assets": "prettier --write --config packages/configs/prettier/base.mjs \"**/*.{json,md,yml,yaml,css,html}\"",
    "format:check": "oxfmt --check \"**/*.{ts,tsx,js,jsx,mjs,cjs}\" && prettier --check --config packages/configs/prettier/base.mjs \"**/*.{json,md,yml,yaml,css,html}\"",
    "migrate:local-state": "node ./tools/scripts/migrate-local-state-layout.mjs",
    "prepare": "husky",
    "release:beta": "node ./tools/scripts/release-beta.mjs",
    "release:packages:apply-version": "node ./tools/scripts/apply-ci-package-release-version.mjs",
    "release:packages:next-version": "node ./tools/scripts/next-package-release-version.mjs",
    "release:pack:check": "pnpm build:npm-packages && node ./tools/scripts/check-package-packs.mjs",
    "release:packages": "node ./tools/scripts/publish-packages.mjs",
    "review:architecture": "node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --format summary",
    "review:architecture:package": "node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --format json --output-temp",
    "review:architecture:test": "node --test ./.codex/skills/tutti-architecture-review/scripts/plan-review.test.mjs ./.codex/skills/tutti-architecture-review/scripts/build-review-scope.test.mjs",
    "patch:claude-agent-acp": "node ./services/tuttid/service/agentstatus/assets/patch-claude-agent-acp.mjs",
    "setup:dev": "node ./tools/scripts/setup-dev.mjs",
    "smoke:desktop-transport": "node ./tools/scripts/smoke-desktop-transport.mjs",
    "sync:workbench-openapi-schema": "node ./tools/scripts/sync-workbench-openapi-schema.mjs",
    "sync:workbench-go-contract": "node ./tools/scripts/generate-workbench-go-contract.mjs",
    "test:tools": "node --test ./tools/scripts/check-tutti-names.test.mjs ./tools/scripts/check-renderer-feature-boundaries.test.mjs ./tools/scripts/check-electron-runtime-boundaries.test.mjs ./tools/scripts/check-i18n.test.mjs ./tools/scripts/desktop-build-version.test.mjs ./tools/scripts/desktop-dmg-notarization.test.mjs ./tools/scripts/desktop-release-changelog.test.mjs ./tools/scripts/desktop-release-config.test.mjs ./tools/scripts/desktop-release-download-links.test.mjs ./tools/scripts/desktop-release-feishu-card.test.mjs ./tools/scripts/desktop-release-latest.test.mjs ./tools/scripts/desktop-release-reservation.test.mjs ./tools/scripts/desktop-release-summary.test.mjs ./tools/scripts/desktop-release-versioning.test.mjs ./tools/scripts/generate-defaults.test.mjs ./tools/scripts/lark-log-tool.test.mjs ./tools/scripts/migrate-local-state-layout.test.mjs ./tools/scripts/npm-release-packages.test.mjs ./tools/scripts/package-release-version.test.mjs ./tools/scripts/publish-packages.test.mjs ./tools/scripts/build-tutti-app-release.test.mjs ./tools/scripts/build-tutti-app-runtime-catalog.test.mjs ./tools/scripts/run-check-changed-targets.test.mjs",
    "test:go": "pnpm generate:builtin-apps && cd packages/appcli/core && go test ./... && cd ../../workspace/files && go test ./... && cd ../../workbench/service && go test ./... && cd ../../../services/tuttid && go test ./... && cd ../../apps/cli && go test ./...",
    "test:ts": "pnpm --filter @tutti-os/desktop test && pnpm --filter @tutti-os/browser-node test && pnpm --filter @tutti-os/client-tuttid-ts test && pnpm --filter @tutti-os/workbench-snapshot test && pnpm --filter @tutti-os/workbench-surface test && pnpm --filter @tutti-os/workspace-file-preview test && pnpm --filter @tutti-os/workspace-file-manager test && pnpm test:tools",
    "typecheck": "node ./tools/scripts/run-typecheck.mjs"
  },
  "lint-staged": {
    "*.{ts,tsx,js,jsx,mjs,cjs}": [
      "oxfmt --write",
      "oxlint --fix --deny-warnings --no-error-on-unmatched-pattern"
    ],
    "*.{json,md,yml,yaml,css,html}": [
      "prettier --write --config packages/configs/prettier/base.mjs"
    ],
    "*.go": [
      "gofmt -w"
    ]
  },
  "devDependencies": {
    "@changesets/cli": "2.31.0",
    "@hey-api/openapi-ts": "0.97.2",
    "@tutti-os/ui-system": "workspace:*",
    "@typescript/native-preview": "7.0.0-dev.20260617.2",
    "husky": "^9.1.7",
    "lint-staged": "^17.0.5",
    "oxfmt": "0.55.0",
    "oxlint": "1.70.0",
    "prettier": "^3.8.3",
    "tsup": "8.5.1",
    "yaml": "^2.9.0"
  }
}

# docs/architecture/project-structure.md

# Project Structure

This document defines the current repository structure for `tutti`.

It explains what belongs in each top-level area and how new directories should be introduced.

## Top-Level Layout

```text
tutti/
  apps/
  config/
  services/
  packages/
  tools/
  docs/
```

## Top-Level Responsibilities

### `apps/`

`apps/` contains product entrypoints and user-facing shells.

Current area:

- `apps/cli`: bundled terminal entrypoint for the local daemon capability protocol
- `apps/desktop`: Electron desktop application

Rules:

- app directories may own presentation, runtime integration, and entrypoint-specific behavior
- app directories must not duplicate business logic already owned by `services/`
- do not materialize future app ideas as empty directories; keep them in docs until the module has a real interface and implementation

### `services/`

`services/` contains long-running product backends.

Current area:

- `services/tuttid`: local daemon and primary business core

Rules:

- service directories own business workflows, durable state, and persistence ownership
- if a feature requires domain decisions or state transitions, it should usually land in `services/tuttid`

### `config/`

`config/` contains repository-owned default sources that are consumed by generation or tooling.

Current area:

- `config/tutti.defaults.json`: single-source default names and budgets for local state, transport, and logging

Rules:

- keep `config/` focused on repository defaults, not per-user settings or secrets
- prefer generating runtime-specific code from `config/` rather than reading these files ad hoc inside packaged applications
- do not turn `config/` into a second `docs/` directory; only keep machine-consumable sources here

### `packages/`

`packages/` contains shared boundaries, not default implementation code.

Current grouping:

```text
packages/
  browser/
  clients/
  configs/
  events/
  ui/
  workbench/
  workspace/
```

Rules:

- organize packages by responsibility, not by language alone
- use `clients/*` for domain-specific client access
- use `events/*` for schema-first shared business event protocol contracts, validators, and generated transport metadata that multiple hosts consume
- use `browser/*` for reusable browser/workbench node mechanics that are shared by desktop hosts without carrying product-specific bridge methods
- use `configs/*` for shared engineering configuration
- use `ui/*` for shared frontend foundation packages such as visual-system boundaries, host-agnostic React hooks, and host-agnostic i18n runtime support
- use `workbench/*` for the shared workbench snapshot contract and reusable workbench interaction surface intended to be shared by the open-source desktop and TSH
- use `workspace/*` for narrow reusable workspace-domain contracts and feature surfaces intended to be shared by the open-source desktop, TSH, and TACH
- do not create vague packages such as `shared`, `common`, or `client-sdk`
- do not pre-create package directories for future domains; add the package only when a real multi-consumer seam exists
- documentation alone does not make a package seam real; the package must expose
  a narrow interface that a current consumer can use without learning its
  implementation layout

### `tools/`

`tools/` contains repository support code such as:

- build helpers
- packaging helpers
- generation entrypoints
- validation or maintenance scripts

Core product behavior should not permanently live in ad hoc scripts when it belongs in a first-class application or service.

### `docs/`

`docs/` contains persistent repository documentation.

Current sub-areas:

- `docs/architecture`: structure notes and technical design context
- `docs/conventions`: coding, layering, naming, and storage rules

Rules:

- `docs/architecture` and `docs/conventions` are the long-lived source of truth
- temporary planning notes should not become the primary source of current repository rules
- once a design has landed and stabilized, durable rules should be promoted into `docs/architecture` or `docs/conventions`

## Current Structure Decisions

### `apps/cli`

`apps/cli` is responsible for:

- terminal argument parsing
- local daemon endpoint discovery and bearer authentication
- invoking the daemon-owned CLI capability protocol
- rendering daemon command output for terminal users

It must not become a second business core. Command metadata, workspace resolution, edition/context filtering, and command execution stay in `services/tuttid`.

### `apps/desktop`

`apps/desktop` is responsible for:

- renderer UI
- Electron main-process lifecycle
- preload bridge and IPC exposure
- native desktop integration
- supervising `tuttid`

It must not become a second business core.

Desktop keeps four top-level source areas:

```text
apps/desktop/src/
  main/
  preload/
  renderer/
  shared/
```

Desktop summary:

- `main/` owns Electron lifecycle, daemon/runtime composition, host access, transport, IPC, update integration, and window creation
- `preload/` owns the typed bridge surface exposed to renderer
- `renderer/src/app/windows/*` owns renderer window composition shells such as `dashboard` and `workspace`
- `renderer/src/features/*` owns reusable renderer feature modules
- `renderer/src/features/*/services/*` owns feature service public surfaces, while `services/internal/**` stays private to the owning feature
- `renderer` consumes shared visual foundations from `packages/ui/system` instead of growing its own token or primitive layer
- `shared/` stays narrow and desktop-local
- desktop-owned i18n resources stay under `shared/i18n/*`, while reusable package default i18n resources stay with the owning package and are merged by the renderer app-level i18n runtime
- `main/bootstrap.ts` stays a top-level coordinator; service assembly belongs in `desktopAppServices.ts`, `desktopDaemonRuntime.ts`, `desktopHostServices.ts`, and `desktopAppLifecycle.ts`

The authoritative desktop directory shape and ownership rules live in [docs/conventions/desktop-layering.md](../conventions/desktop-layering.md). Keep this repository-level document as a summary, not a second full desktop structure spec.

### `services/tuttid`

`services/tuttid` is the primary business core.

It owns:

- business rules
- domain workflows
- local persistence
- long-running daemon behavior

### `packages/clients/*`

Client packages provide domain-specific access helpers for consumers.

They should remain focused, named by responsibility, and free of hidden business rules.

### `packages/events/*`

Event packages define shared business event protocol boundaries.

Current package:

- `packages/events/protocol`: repository-owned JSON Schema and event-definition source files for the business event stream, plus generated TypeScript protocol contracts and daemon transport registry output

Rules:

- keep schema-first source files in the package and keep those files as the only shared source of truth for business event topics
- keep generated TypeScript exports narrow and protocol-oriented
- keep WebSocket lifecycle management, daemon orchestration, and renderer feature behavior outside `events/*`

### `packages/browser/*`

Browser packages define reusable Browser Node mechanics for hosts that need to
embed web content in the shared Workbench.

Current packages:

- `packages/browser/workbench-node`: `@tutti-os/browser-node`, the shared
  Workbench Browser Node package. It owns generic HTTP/HTTPS navigation,
  session partition resolution, runtime state, bridge shape, Electron webview
  guest management, and package-local i18n defaults. Host adapters own product
  globals, backend-token access, preview proxy behavior, and business bridge
  methods.

Rules:

- keep Browser Node mechanics in this package and host/product-specific methods
  in the consuming app or integration
- require hosts to provide bridge namespaces; the package must not assume
  `__tutti`, `__tsh`, or any other product global
- keep preview proxy interfaces inert until a host intentionally implements
  route resolution
- keep daemon contracts out of Browser Node v1; the desktop host persists layout
  through the existing Workbench snapshot

### `packages/configs/*`

Config packages exist to keep engineering defaults centralized and reusable.

They should stay small and boring.

### `packages/ui/*`

UI packages define shared frontend foundations.

Current packages:

- `packages/ui/system`: shared tokens, icons, styles, and primitives for renderer consumers; also the repository-owned host package for shared shadcn CLI and Radix primitive acquisition
- `packages/ui/i18n-runtime`: host-agnostic i18n runtime helpers for shared frontend packages and app-level runtime composition
- `packages/ui/react-hooks`: host-agnostic React hook helpers for shared frontend packages, including external-store snapshot and selector patterns

Rules:

- keep scope limited to frontend foundation concerns such as visual-system primitives, token-backed styles, host-agnostic i18n runtime composition, and host-agnostic React subscription helpers
- allow `ui/*` to own host-agnostic React hook foundations when the hook pattern is shared across packages and stays free of product workflows
- prefer routing shared `useSyncExternalStore` wiring through `packages/ui/react-hooks` instead of rebuilding new subscription wrappers in feature packages
- do not move business components, product workflows, or domain orchestration into `ui/*`
- prefer consuming `ui/*` from app renderers and reusable frontend packages rather than recreating the same foundations locally
- prefer narrow, stable package entrypoints over exporting internal file layout as public API

### `packages/workbench/*`

Workbench packages define the shared workbench boundary for the open-source
desktop and TSH.

Current packages:

- `packages/workbench/snapshot`: canonical TypeScript workbench snapshot types,
  migrations, normalization, validation, and JSON Schema. The daemon OpenAPI
  `WorkbenchSnapshot*` component schemas are synchronized from this package.
- `packages/workbench/service`: shared Go Workbench snapshot service, validation,
  canonicalization, and persistence seam for daemon hosts.
- `packages/workbench/surface`: reusable workbench controller, reducer,
  placement, stacking, `WorkbenchHost`, React surface primitives, shell snapshot
  wiring, intent resolution, external-state render plumbing, and host/session
  lifecycle mechanics for projected presence, launch requests, transient
  activation, explicit close policy, and shell snapshot sanitation.

Rules:

- keep snapshot compatibility behavior in `snapshot`, not in app renderers
- keep shared Go Workbench validation, canonicalization, and storage seams in
  `service`, not in host daemons
- keep reusable workbench interaction mechanics in `surface`, not in
  product-specific feature UI
- when `surface` exposes derived external-store snapshots through
  `getSnapshot()`, unchanged source snapshots must preserve reference identity;
  prefer the package-local derived-snapshot helper instead of rebuilding fresh
  objects or arrays on every read
- keep product-specific node bodies, routing, and persistence adapters in the
  owning app or service
- allow `surface` to own narrow default copy for generic workbench interaction
  mechanics such as window chrome labels; keep product-specific workbench copy
  in the owning app
- do not widen `workbench/*` into a generic desktop shell package
- keep package root exports intentionally small; root exports are the public
  interface, not an index of every internal module
- do not export test fixtures, demo data, stack internals, reducer internals, or
  low-level hooks from a package root unless an existing consumer needs that as a
  stable interface
- keep adapter-specific durable state behind generic contract fields such as
  `Record<string, unknown>` unless the adapter detail is itself part of the
  shared snapshot contract

Host reuse model:

1. Keep generic workbench interaction mechanics, structural styles, and narrow
   default copy in `packages/workbench/*`.
2. Keep host-specific node bodies, routing, persistence adapters, and
   product-owned workbench copy in the consuming app or service.
3. Let the consuming host create one app-level i18n runtime that merges:
   - host-owned i18n resources
   - reusable package default i18n resources
4. Scope that runtime into package namespaces such as workbench window chrome
   instead of reconstructing per-package message objects by hand.

### `packages/workspace/*`

Workspace packages define reusable workspace-domain contracts that are intended
to support a real multi-consumer boundary or a documented external contract as
additional hosts adopt them.

Current packages:

- `packages/workspace/files`: Go domain kernel for logical workspace file
  semantics, path normalization, search scoring, and host-owned file adapters.
- `packages/workspace/file-manager`: TypeScript state, actions, adapter
  contract, and optional React UI for a workspace file manager.
- `packages/workspace/terminal`: shared terminal node contract and frontend
  surface for workbench hosts.
- `packages/workspace/issue-manager`: reusable issue-manager contracts, OpenAPI
  fragment, i18n defaults, React surface, and workbench registration helpers
  for workspace-scoped issue, task, and run workflows.

Release rule:

- npm package release participation is defined in the npm release conventions,
  not by repeating package rosters in architecture docs
- shared non-npm modules follow their owning language and module conventions
  unless a separate release contract is introduced

Rules:

- keep host-specific adapters in the owning host, such as `services/tuttid` or
  an app renderer feature
- a reusable frontend workspace package may still own shared session state,
  interaction flow, and optional React UI when those behaviors form the shared
  workspace-domain surface rather than a product-specific host integration
- a reusable frontend workspace package may also own narrow default copy for its
  shared UI surface; hosts should override through their app-level i18n runtime
  rather than duplicating package strings locally
- keep shared state and UI on logical workspace paths such as `/workspace`, not
  host absolute paths or VM mount paths
- do not move tuttid storage lookup, desktop preload calls, TSH room mapping, or
  TACH-specific integration into `packages/workspace/*`

Host reuse model:

1. Reuse the shared package for session orchestration, view-model derivation,
   interaction flow, and optional UI when those behaviors are truly host-neutral.
2. Implement host-specific transport and capability adapters in the consuming
   host, for example preload calls, daemon clients, room bridges, or local file
   selection surfaces.
3. Keep shared workspace UI copy defaults in the owning package and merge them
   through the host's app-level i18n runtime instead of copying those strings
   into the host.
4. Keep product-specific wording, shell integration, and user-facing host
   behaviors in the consuming host.

## Adding New Directories

### Add a new top-level directory only when

- the new area has a distinct deployment or ownership boundary
- it cannot be described as part of an existing `apps/`, `services/`, `packages/`, `tools/`, or `docs/` area

### Add a new app directory when

- there is a new user-facing entrypoint with its own runtime shell

Examples:

- a desktop app
- a CLI app

Keep future app ideas in docs until they become real modules. Do not reserve them as empty directories.

### Add a new service directory when

- there is a new backend process with its own lifecycle and state ownership

### Add a new package when

- there is a real multi-consumer boundary
- the extracted API can be named narrowly by responsibility
- the shared code is not just convenience reuse
- the public entrypoint can stay much smaller than the implementation tree

Keep code local by default:

- desktop-only TypeScript stays in `apps/desktop`
- daemon-only Go stays in `services/tuttid`

Keep future packages in docs, not in placeholder directories:

- a README-only package is usually a shallow module
- a package name should appear in the tree only when contributors can follow it to a real interface and implementation

## Structure Review Questions

When reviewing a new directory or package, ask:

1. Which existing top-level area already owns this responsibility?
2. Is this a real boundary or just an attempt to spread code out?
3. Would keeping this code local be simpler and clearer?
4. Is the new name based on responsibility instead of a vague shared label?
5. Does the new structure reduce confusion, or just increase file count?
6. Can a caller use the module through a small interface, or does the package
   root expose the implementation layout?

# .codex/skills/tutti-architecture-review/SKILL.md

---
name: tutti-architecture-review
description: Review tutti git diffs for project structure, layering, module ownership, and duplicate event-center infrastructure by planning focused architecture review tasks, then having the main agent orchestrate sub-agents for only the changed areas.
---

# Tutti Architecture Review

Use this skill when reviewing a `tutti` change or a named module for repository structure, module ownership, or layering compliance. This is a focused architecture review, not a general bug hunt.

## Vocabulary

Use the architecture vocabulary consistently:

- **Module**: anything with an interface and an implementation.
- **Interface**: everything a caller must know to use the module correctly.
- **Implementation**: the code inside a module.
- **Depth**: leverage at the interface; deep modules hide useful behavior behind a small interface.
- **Seam**: where an interface lives.
- **Adapter**: a concrete thing satisfying an interface at a seam.
- **Leverage**: what callers get from depth.
- **Locality**: what maintainers get from depth.

Prefer these words in findings. Avoid vague substitutes such as "component", "service", "utility", or "boundary" when a vocabulary term fits.

## Workflow

1. Resolve the user's review intent:
   - plain `git diff` review for the current change
   - module-focused diff review when the user names a module inside the current change
   - static module review when the user wants a named module inspected even without current diff overlap

   Use light natural-language guidance when the request is ambiguous. Do not force the user through a fixed mode menu.

2. When the user names a module, let the main agent infer a few candidate path keywords and gather candidate paths. Then normalize those paths into a scope file:

   ```bash
   node ./.codex/skills/tutti-architecture-review/scripts/build-review-scope.mjs \
     --input /tmp/tutti-review-candidates.json \
     --output /tmp/tutti-review-scope.json
   ```

   Candidate input is agent-produced. The script does not invent module keywords or search the repository itself; it only normalizes candidate paths into a stable scope contract for the planner.

   Read `references/scope-contract.md` when changing or consuming the candidate input, normalized scope output, or planner scope metadata.

3. Run the review planner from the repository root:

   ```bash
   pnpm review:architecture:package
   ```

   For module-focused review, pass the generated scope file:

   ```bash
   node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs \
     --scope-file /tmp/tutti-review-scope.json \
     --format json \
     --output-temp
   ```

   The planner remains `git diff` first. With `--scope-file`, it reviews `scope ∩ diff` when there is overlap, and falls back to scoped-file review only when there is no diff overlap.

   For explicit static module review, force scope-only planning:

   ```bash
   node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs \
     --scope-file /tmp/tutti-review-scope.json \
     --scope-mode static-only \
     --format json \
     --output-temp
   ```

4. Read the generated JSON task package from `workflowEntry.packagePath`. Each task includes `riskLevel`, `spawnRecommendation`, `summaryForMainAgent`, `matchedFiles`, `preflightSignals`, and a ready-to-use `prompt`.

5. Spawn `explorer` sub-agents according to `spawnRecommendation`:
   - `required`: spawn unless the user explicitly asked for a narrower review
   - `recommended`: spawn when the review is not trivially small
   - `optional`: the main agent may review locally

   Do not ask sub-agents to edit files. Their job is to inspect the relevant diff and report architecture findings.

6. Continue local work while sub-agents run only if there is non-overlapping review or summarization work. Do not duplicate a sub-agent's assigned scope.

7. Merge sub-agent reports into a code-review style answer:
   - findings first, ordered by severity
   - cite file paths and line numbers when possible
   - explain the violated rule and why it matters for locality, leverage, or dependency direction
   - include "No architecture findings" when a reviewer found no issues

## Reviewer Expectations

Every sub-agent should:

- read `AGENTS.md` and the closest area `AGENTS.md` for its changed files
- read only the reference files listed in the task package, plus files needed to understand the diff
- inspect the relevant git diff directly instead of relying only on file names
- report only actionable architecture issues, not taste preferences
- distinguish hard rule violations from speculative deepening opportunities
- avoid proposing new interfaces unless the changed code already creates pressure for a real seam
- when eventing, pub-sub, or bidirectional coordination appears, check whether the shared business event stream's `global`, `desktop`, or `workspace` scope modules already own the seam before accepting new event-center infrastructure

## Task Planner

The planner is deterministic and repository-local:

- `scripts/plan-review.mjs` reads `git diff`, optional untracked files, and an optional normalized scope file
- `scripts/build-review-scope.mjs` normalizes agent-produced candidate paths into a stable scope contract
- `references/review-rules.json` declares reviewer tasks, path rules, and regex-style preflight signals
- the script maps changed paths to architecture reviewer tasks
- it adds lightweight preflight signals for suspicious imports, generated-contract drift, possible hardcoded copy, and cross-area seams
- it assigns task risk and spawn recommendations for the main agent
- it emits JSON or Markdown for the main agent to orchestrate
- it never starts sub-agents itself

Useful options:

```bash
pnpm review:architecture
pnpm review:architecture:package
pnpm review:architecture:test
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --format markdown
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --format summary
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --base origin/main
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --staged
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --no-untracked
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --scope-file /tmp/tutti-review-scope.json --format summary
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --scope-file /tmp/tutti-review-scope.json --scope-mode static-only --format summary
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --task desktop-layering --format markdown
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --output /tmp/tutti-review-tasks.json
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --output-temp
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --from-package /tmp/tutti-review-tasks.json --format markdown
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --from-package /tmp/tutti-review-tasks.json --task desktop-layering --format summary
```

## Task Package Entry

A task package file is a stable workflow entrypoint. Prefer creating one before spawning sub-agents, especially for large reviews:

```bash
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --format json --output-temp
```

Then use `workflowEntry.packagePath` as the source of truth for the review. If the conversation resumes later, reload the same package instead of recomputing the plan:

```bash
node ./.codex/skills/tutti-architecture-review/scripts/plan-review.mjs --from-package /tmp/tutti-architecture-review-YYYYMMDDTHHMMSSZ.json --format markdown
```

Use `--format summary` before spawning agents when you need a compact orchestration view. Use `--task <id>` to inspect or rerender one reviewer from either the current diff or an existing task package.

Run the planner self-test after changing task matching, risk rules, output formats, or task-package behavior:

```bash
node --test ./.codex/skills/tutti-architecture-review/scripts/plan-review.test.mjs ./.codex/skills/tutti-architecture-review/scripts/build-review-scope.test.mjs
```

Read `references/tutti-layering.md` when a task needs the compact project rules.
Read `references/scope-contract.md` when changing the scope-file contract or the main-agent handoff around module review.
Read `docs/architecture/business-event-stream.md` when reviewing event-center modules, typed pub-sub, or WebSocket-based product coordination. Do not use the architecture review to enforce generated event-protocol drift; that belongs to `pnpm check:event-protocol-generated`.

Read or edit `references/review-rules.json` when changing:

- reviewer task titles, focus, references, or path matching
- simple preflight regex rules
- task assignment for preflight signals

Keep combination logic in `scripts/plan-review.mjs`, such as cross-cutting trigger reasons, generated-source pairing, risk calculation, spawn recommendations, and output rendering.

Keep module-phrase interpretation in the main agent, not in `build-review-scope.mjs` or `plan-review.mjs`. Those scripts should stay deterministic and repository-local.

# .codex/skills/tutti-architecture-review/references/tutti-layering.md

# Tutti Layering Reference

This is a compact reference for architecture reviewers. The durable source of truth remains the repository docs under `docs/architecture` and `docs/conventions`.

## Repository Shape

- `apps/desktop` owns Electron shell, renderer UI, preload bridge, OS integration, and daemon supervision.
- `services/tuttid` owns business rules, durable local state, domain workflows, and persistence.
- `packages/*` exists only for real shared seams with narrow names.
- `config` contains machine-consumable repository defaults, not user settings or documentation.
- `tools` contains repository support scripts, not permanent product behavior.
- Do not create vague packages such as `shared`, `common`, `utils`, or `client-sdk`.

Review questions:

- Does the change put business logic in `services/tuttid` rather than `apps/desktop`?
- Does a new package have multiple real consumers and a narrow interface?
- Does a new directory represent durable ownership, or is it speculative structure?
- Does a helper module have depth, or is it a shallow pass-through?
- When a workspace package includes frontend orchestration, is it still host-reusable rather than coupled to one concrete product integration?

## Desktop Layering

Authoritative docs:

- `docs/conventions/desktop-layering.md`
- `apps/desktop/AGENTS.md`
- `docs/conventions/desktop-visual-language.md`
- `docs/conventions/ui-system.md`

Allowed ownership:

- `src/main`: Electron-specific capabilities, app bootstrap, windows, IPC registration, transport endpoint resolution, daemon supervision, updates, logging.
- `src/preload`: renderer-facing typed desktop SDK; hides IPC channel names.
- `src/renderer`: consumes typed preload APIs; owns React UI and renderer-local feature services.
- `src/shared`: narrow desktop-local bridge contracts and i18n resources.

Hard checks:

- `main` must not implement business workflows or durable domain state.
- `preload` must not expose a generic `invoke(channel, payload)` surface.
- `renderer` must not import Electron APIs, construct daemon clients, or resolve transport endpoints.
- renderer UI must not import another feature's `services/internal/**`.
- renderer must use `@tutti-os/ui-system` instead of recreating design tokens, icons, or primitives locally.
- user-visible copy belongs in the i18n layer.

Preferred renderer feature shape:

```text
renderer/src/features/<feature>/
  index.ts
  services/
    <feature>Service.interface.ts
    <feature>Types.ts
    register<Feature>Services.ts
    internal/
      <feature>Service.ts
      <feature>Store.ts
      <feature>Model.ts
      adapters/
  ui/
```

## Tuttid Layering

Authoritative docs:

- `docs/conventions/tuttid-layering.md`
- `services/tuttid/AGENTS.md`
- `docs/conventions/api-contracts.md`
- `docs/conventions/local-state-storage.md`

Ownership:

- `main.go`: process bootstrap only.
- `wiring.go`: composition root; may know concrete implementations.
- `app`: process lifecycle around HTTP server.
- `server`: HTTP server assembly and middleware.
- `api`: request decoding, response encoding, HTTP status selection, route dispatch, generated DTOs.
- `service`: use-case orchestration, domain validation, DTO translation, collaborator calls.
- `biz`: small transport-agnostic domain models/rules shared across layers.
- `data`: concrete persistence adapters, SQLite, migrations, file-backed repositories.
- `integration`: cross-layer black-box tests.
- `types`: cross-domain support only.

Dependency direction:

```text
main -> wiring -> app/server/api -> service -> data -> biz
```

Hard checks:

- `data` must not depend on `api`.
- `biz` must not depend on `api`, `service`, or `data`.
- `api` should not know concrete persistence details except narrow sentinel error mapping.
- `service` should not perform direct SQL or HTTP response writing.
- simple behavior should not be split into a full domain slice before the seam is real.

Important exception:

- `WorkbenchSnapshot*` is a repository-owned shared contract synchronized from
  `packages/workbench/snapshot`.
- Reusing the synchronized Go snapshot contract in `service/workspace` for
  validation and canonicalization is allowed when it avoids a parallel
  hand-maintained mirror.
- The exception does not move HTTP decoding, status-code mapping, or route-local
  validation ownership out of `api`.

## Contract And Generated Source Rules

- Change `services/tuttid/api/openapi/tuttid.v1.yaml` before changing daemon HTTP request or response contracts.
- `WorkbenchSnapshot*` is the main exception: change
  `packages/workbench/snapshot/src/schema.json` first, then sync the OpenAPI and
  Go generated artifacts that depend on it.
- Before adding local event buses, event centers, product pub-sub routes, or
  duplicate WebSocket coordination, check whether the shared business event
  stream and its `global`, `desktop`, or `workspace` scope modules already own
  the seam.
- Shared default-source changes under `config/tutti.defaults.json` require generated outputs to be refreshed.
- Supported environment override growth must be documented in `docs/conventions/runtime-overrides.md`.
- User-visible copy and locale-resource changes should go through the relevant i18n layer.
- Repository-managed checks and hooks should update the durable convention docs when their rules change.

## Review Severity

- `P0`: architecture break that blocks the change from working or shipping.
- `P1`: hard layering or contract violation that will spread business logic or break callers.
- `P2`: real maintainability issue: shallow module, misplaced ownership, test locality loss, or likely future duplication.
- `P3`: speculative deepening opportunity; useful but not required for this change.
