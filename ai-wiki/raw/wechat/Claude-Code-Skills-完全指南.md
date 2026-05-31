# Claude Code Skills 完全指南：从零打造你的生产级别 AI 编程助理工作流

- 作者: 码哥跳动
- 发布时间: 2026年3月30日 09:00
- 原文链接: https://mp.weixin.qq.com/s/M-K8cDwLhpID1gkcZOdUkQ

---




你好，我是《Redis 高手心法》畅销书作者码哥，可以叫我靓仔。

我用了三个月的 Claude Code，有一个时期非常难受：每天都在重复同样的 Prompt。

"Review 这个 PR，检查安全问题、性能问题、代码规范……" 打了无数遍。"帮我修这个 GitHub Issue，先看 issue 描述，然后找相关文件……" 又打了无数遍。

每次都想着"等有空了把这些整理成模板"，结果永远没空。

然后有一天，我真正搞懂了 Skills 系统，意识到自己浪费了多少时间。

说白了：
**Skills 不是"自定义命令"，而是一套工作流编程语言**。它能记住你的工作模式、自动感知上下文触发、控制 AI 的调用权限、注入动态数据，甚至启动独立的子 Agent 并行工作。

你一次写好，之后每个项目、整个团队都可以直接用。

这篇文章把我踩过的坑、查过的文档、真正用起来的经验全写进来了。

从最基础的 Skill 创建，到高级的调用控制、动态注入、子 Agent 模式，再到团队共享的最佳实践。

Skills、CLAUDE.md、Hooks 到底有什么区别？

很多人刚上手时会把这三个混用，结果发现效果都不好。坦白讲，官方文档在这件事上解释得也不够清楚。

我用了一段时间后总结出来的区分方式是：
**按"触发时机"和"强制程度"来选**。

```
graph TD    A[我想让 Claude 记住某件事] --> B{这件事每次都需要吗？}    B -- 是，每次开 session 就要用 --> C[CLAUDE.md]    B -- 不是，只在特定场景触发 --> D{需要强制执行吗？}    D -- 是，不能让 Claude 自己决定要不要做 --> E[Hooks]    D -- 不是，AI 判断即可 --> F{有固定工作流步骤吗？}    F -- 是，多个步骤的可复用流程 --> G[Skills]    F -- 不是，只是上下文知识 --> C
```
图：选择 CLAUDE.md、Skills、Hooks 的决策树

三者的本质差异：



CLAUDE.md

Skills

Hooks


**加载时机**每次 session 开始全量加载

按需加载（相关时自动 or 手动
```
/invoke
```
）

工具事件触发（写文件前/后、commit 前等）


**消耗 Token**是，每次都消耗

只在使用时消耗

否（Shell 脚本）


**强制程度**建议性（Claude 可能忽略）

建议性

强制执行（绕不过去）


**适合场景**项目规范、架构背景、开发偏好

可复用工作流、领域知识、团队规范

安全检查、自动格式化、质量门禁



**CLAUDE.md 有一个很容易踩的坑**：官方文档明确说了，文件超过 200 行，Claude 对里面规则的遵从度会明显下降。我见过有人把所有规范塞进 CLAUDE.md，写了 500 行，然后抱怨"Claude 不听话"——这是必然的结果。

**Skills 的核心价值在于按需加载**。你的团队有 30 个常用工作流，不需要每次 session 都全部加载进 context，只在真正需要的时候才触发，既省 Token 又不干扰 Claude 的注意力。

创建你的第一个真正有用的 Skill

网上很多教程写的都是"Hello World"级别的 Skill，用了两天就放弃了。我直接用一个真实场景：
**修复 GitHub Issue 的标准工作流**。

这是我们团队每天都要做的事，固定步骤，固定检查项，非常适合做成 Skill。

第一步：确定 Skill 的存放位置

Skills 有三个层级：

```
~/.claude/skills/           # 个人级：所有项目都能用<项目根>/.claude/skills/    # 项目级：只在当前项目可用（提交到 Git 可团队共享）<插件目录>/skills/          # 插件级：通过插件分发
```
修复 Issue 这个工作流是个人习惯，放在
```
~/.claude/skills/
```
下，所有项目都能用：

```
mkdir -p ~/.claude/skills/fix-issue
```
第二步：写 SKILL.md

每个 Skill 都是一个目录，里面必须有
```
SKILL.md
```
：

```
# ~/.claude/skills/fix-issue/SKILL.md---name:fix-issuedescription:分析并修复GitHubIssue，自动读取issue详情、定位相关代码、实现修复、写测试、提PR。当用户说"修这个issue"、"fixissue"或提到issue编号时触发。disable-model-invocation:trueallowed-tools:Bash(gh*),Read,Grep,Glob,Edit---分析并修复GitHubIssue#$ARGUMENTS，遵循以下步骤：1.**读取Issue详情**   运行`ghissueview$ARGUMENTS`获取完整描述、标签、评论2.**理解问题**   -从issue描述中提取核心问题和复现步骤   -判断影响范围（UIbug/逻辑错误/性能问题/安全问题）3.**定位相关代码**   -搜索issue中提到的关键词、函数名、文件名   -阅读相关文件，理解当前实现4.**实现修复**   -先写一个能复现问题的失败测试   -然后修改代码让测试通过   -确保不影响已有测试5.**提交和PR**   -`gitadd`相关文件（不要用`gitadd.`）   -写清楚commitmessage，格式：`fix:[issue#号] 问题简述`   -运行`ghprcreate`创建PR，body里close#$ARGUMENTS**注意**：如果修复需要数据库migration，暂停并告知用户，不要自动执行。
```
几个关键配置解释一下：

**
```
disable-model-invocation: true
```
**：这是说"只有我手动输入
```
/fix-issue 123
```
才触发，Claude 不能自己决定触发"。这很重要——涉及 git 操作的工作流，绝对不能让 AI 自行判断要不要跑。


**
```
allowed-tools: Bash(gh *)
```
**：只允许
```
gh
```
开头的 Bash 命令不需要额外确认，其他 Bash 命令还是会问我。这是权限精细控制，不是"所有 Bash 都放行"。


**
```
$ARGUMENTS
```
**：调用时传入的参数。
```
/fix-issue 123
```
里的
```
123
```
会替换掉它。


第三步：测试

```
# 在任意项目里/fix-issue 456
```
Claude 会按照 Skill 里定义的步骤，依次用
```
gh issue view 456
```
读取 issue，搜索代码，实现修复，最后提 PR。整个过程不需要你再写一个字。

你可能不知道的 5 个高级特性

基础用法大家都会，这里重点说那些文档里藏得比较深、但非常有用的特性。

[图片: image-20260329193704079]
image-20260329193704079
1. 基于描述的自动触发

Skills 的
```
description
```
字段不只是说明文字，它直接决定了 Claude 会在什么时候自动加载这个 Skill。

官方的限制是：description
**前 250 个字符**决定触发关键词，超出部分在 Skill 列表里会被截断。整个 session 里所有 Skill 的 description 加起来有一个 token 预算（约 8000 字符，随上下文窗口动态调整）。

写好 description 的原则：
**把用户实际会说的话放在前面**，技术术语放后面。

```
# 差的 description：description: 代码审查工具，用于检查代码质量、安全性和性能问题# 好的 description：description: 审查代码。当用户说"review 一下"、"帮我看看这段代码"、"code review" 时触发。检查安全漏洞、性能问题、代码规范，给出可操作的改进建议。
```
两者的区别在于：差的 description 描述的是"这个工具是什么"，好的 description 描述的是"用户会在什么情况下用这个工具"。

2. 调用控制：谁能触发，谁不能触发

两个 frontmatter 字段，很多人搞混：

字段

设为 true 时的效果

适用场景


```
disable-model-invocation: true
```
只有用户手动
```
/invoke
```
才能触发，Claude 不能自动触发

有副作用的操作：deploy、commit、发消息


```
user-invocable: false
```
用户看不到这个 Skill，不能手动触发，只有 Claude 能用

背景知识型：legacy 系统说明、内部 API 规范



```
graph LR    A[Skill 被触发] --> B{disable-model-invocation?}    B -- false默认 --> C{user-invocable?}    B -- true --> D[只能用户手动 /invoke]    C -- true默认 --> E[用户和 Claude 都能触发]    C -- false --> F[只有 Claude 能自动触发\n用户不可见]
```
图：Skills 调用控制逻辑

实际例子：我有一个 Skill 叫
```
legacy-payment-system
```
，里面是我们老支付系统的架构说明和踩坑记录。这个 Skill 不需要用户手动调用（
```
user-invocable: false
```
），但每次 Claude 在处理支付相关代码时，它会自动把这些背景知识加载进来，避免 Claude 犯那些已经踩过的坑。

3. 动态上下文注入：让 Skill 在运行时获取真实数据

这是我认为最被低估的特性。Skill 里可以用
```
!`command`
```
语法执行 Shell 命令，
**命令输出会在 Skill 内容发送给 Claude 之前替换掉占位符**。

注意：这是预处理，不是 Claude 执行的命令，Claude 只会看到最终替换后的结果。

一个真实有用的例子——自动注入当前 PR 的代码变更：

```
---name:pr-reviewdescription:审查当前PR的代码变更，重点检查安全问题、边界条件、与现有代码风格的一致性context:forkagent:Exploreallowed-tools:Read,Grep,Glob---## 当前 PR 信息**PR标题和描述：**!`ghprview--jsontitle,body-q'.title + "\n\n" + .body'`**变更文件列表：**!`ghprdiff--name-only`**完整Diff：**!`ghprdiff`**相关PR评论：**!`ghprview--comments--jsoncomments-q'.comments[] | "[\(.author.login)]: " + .body'`---请按以下维度审查这个PR：1.**安全性**：是否有SQL注入、XSS、不安全的直接对象引用等问题2.**边界条件**：空值处理、类型检查、并发安全3.**可维护性**：是否与现有代码风格一致，函数复杂度，注释质量4.**测试覆盖**：关键路径有没有对应的测试每个问题给出：问题位置（文件+行号）、问题描述、建议改法。
```
运行
```
/pr-review
```
时，三个
```
!`gh ...`
```
命令会先执行，把真实的 PR 数据注入到 Skill 内容里，然后 Claude 拿到的是包含完整 PR 上下文的提示词，不需要你手动粘贴任何东西。

4. 子 Agent 执行：在隔离环境里跑 Skill

```
context: fork
```
这个配置会让 Skill 在独立的子 Agent 上下文里运行，和你当前的主对话完全隔离。

为什么需要这个？两个原因：

一是
**保护主对话的 context**。如果你让 Skill 读大量文件（比如全量代码审查），这些文件内容会塞满 context window，影响后续对话质量。用子 Agent 跑，它自己用自己的 context，完成后只把结果摘要返回给你。

二是
**并行执行**。多个
```
context: fork
```
的 Skill 可以同时跑，互不干扰。

```
agent
```
字段指定用哪种子 Agent：

```
Explore
```
：只读工具，适合代码调查、分析


```
Plan
```
：分析 + 规划，适合设计方案


```
general-purpose
```
：完整工具集


上面的
```
pr-review
```
例子里就用了
```
context: fork
```
+
```
agent: Explore
```
，PR review 需要读很多文件，放在子 Agent 里跑不会污染主 context。

5. 支持文件：让复杂 Skill 保持可读性

当 Skill 的内容越来越多时，可以把详细参考资料拆分到独立文件里：

```
~/.claude/skills/api-designer/├── SKILL.md          # 主文件，保持在 500 行以内├── examples.md       # 15 个 API 设计示例（只在需要时加载）├── anti-patterns.md  # 常见反模式和错误示例└── checklist.md      # 上线前自检清单
```
在
```
SKILL.md
```
里引用它们：

```
## 附加资源设计 API 时，参考 [examples.md](examples.md) 里的标准示例。遇到设计决策时，先查 [anti-patterns.md](anti-patterns.md) 确认不是已知坏模式。设计完成后，运行 [checklist.md](checklist.md) 做最终自检。
```
Claude 不会一次性读所有文件，而是在真正需要的时候才去读对应文件。这样 SKILL.md 本身保持简洁，复杂的参考资料按需加载。

内置 Skills：你可能一直忽略的"杀手锏"

Claude Code 自带了 5 个内置 Skill，直接用
```
/
```
就能调出来，但我发现大多数人只知道
```
/help
```
。

[图片: image-20260329193917765]
image-20260329193917765
**/batch <指令>**— 大规模并行代码迁移

这个是真正的"重武器"。它会把任务自动分解成 5-30 个独立单元，每个单元在隔离的 Git worktree 里跑一个独立的 Agent，全部并行执行，每个 Agent 完成后各自提 PR。

```
/batch 把 src/ 目录下所有用 CommonJS require() 的文件迁移到 ES Modules import
```
我用它迁移过一个 200+ 文件的老项目，整个过程大约 20 分钟跑完，如果手动迁移至少要两天。每个 Agent 只负责一个文件或一个模块，出错了也只影响那一个 PR，不会把整个仓库搞乱。

**/simplify [聚焦点]**— 代码质量自动优化

它会同时启动三个并行 review Agent，从不同角度检查你刚写的代码，汇总发现的问题后直接修复。

```
/simplify focus on memory efficiency and unnecessary re-renders
```
我的习惯是：每完成一个功能就跑一次
```
/simplify
```
，相当于有三个同事帮你做 code review，而且他们不会因为你刚写完很累了就客气。

**/loop [间隔] <指令>**— 轮询和监控

```
/loop 3m check if the staging deploy finished and Slack me the result
```
等待 CI、等待部署、等待某个条件满足，都可以用
```
/loop
```
代替你一遍遍刷页面。

**/debug [描述]**— 开启调试模式

开启 session 的详细日志，然后让 Claude 分析 debug 日志来定位问题。对付那种"明明看起来配置对了但就是不工作"的玄学问题很有用。

团队共享 Skills 的最佳实践

个人 Skills 放在
```
~/.claude/skills/
```
，团队共享的 Skills 放在项目的
```
.claude/skills/
```
并提交到 Git。

这里有一个优先级机制要注意：如果个人 Skills 和项目 Skills 同名，
**项目 Skills 的优先级更高**。这意味着：团队可以强制覆盖个人习惯。当你需要统一团队工作流时，这是好事；但如果你有自定义的同名 Skill 被项目的覆盖了，可能会让你困惑一下。

一个合理的团队 Skills 目录结构：

```
.claude/skills/├── review-pr/          # PR 审查标准工作流│   ├── SKILL.md│   └── checklist.md    # 项目特有的审查清单├── create-component/   # 新建组件的标准步骤│   ├── SKILL.md│   └── templates/      # 组件模板文件├── deploy-staging/     # 部署到测试环境│   └── SKILL.md        # disable-model-invocation: true└── legacy-context/     # 老系统背景知识    ├── SKILL.md        # user-invocable: false    └── architecture.md
```
**关键原则**：

有副作用的 Skill（deploy、数据库操作、发通知）必须设
```
disable-model-invocation: true
```


背景知识型 Skill 设
```
user-invocable: false
```
，让 Claude 自动加载，用户不用关心


把常用检查清单放在 Skills 的支持文件里，而不是塞进 CLAUDE.md


踩坑记录

**坑一：description 写成技术文档，结果 Skill 从不自动触发**
刚开始我的 description 是"本 Skill 提供代码审查功能，支持安全性检查……"。Claude 从来不会自动触发它，因为这段话没有任何用户会说的关键词。

改成"当用户说'帮我 review'、'看看这段代码'、'code review' 时触发"之后，自动触发率明显提高。

**坑二：把 CLAUDE.md 当 Skills 用，导致 context 爆满**
有一段时间我把所有团队规范塞进 CLAUDE.md，结果 session 开始就消耗大量 token，而且 Claude 经常"忘记"后面的规则。

正确做法：CLAUDE.md 只保留"每次都需要"的 10-20 条核心规则，其余的按场景做成 Skills，按需触发。

**坑三：context: fork 的 Skill 里写了条件判断逻辑**
子 Agent 的 Skill 没有主对话的历史，你在主对话里说的"这次只检查安全问题"，子 Agent 根本不知道。

解决方法：要么不用
```
context: fork
```
，要么用
```
$ARGUMENTS
```
把参数显式传进去：
```
/pr-review security-only
```
。

**坑四：allowed-tools 设置后以为"完全沙盒化"了**
```
allowed-tools
```
只是说这些工具不需要额外确认，
**不是说其他工具被禁止了**。其他工具还是会触发正常的权限确认流程。真正要限制工具访问，需要在权限设置里单独配置。

Skills 和 obra/superpowers 是什么关系？

今天 GitHub Trending 第一是
```
obra/superpowers
```
（121,691 ⭐，今天单日新增 2,292 stars）。很多人问：这和官方的 Skills 系统是竞品吗？

坦白说：它就是一套基于 Claude Code Skills 系统构建的大型 Skills 框架，本质上是别人写好的、可以直接安装使用的 Skill 集合。

你用本文的方式完全可以自己写同类的东西，差别在于 superpowers 提供了更多开箱即用的 Skill，以及一套管理约定。

如果你只是想快速上手，可以直接用 superpowers；如果你想定制团队工作流，自己写 Skills 会更灵活。

常见问题

**Q：Skills 和 CLAUDE.md 里的指令，Claude 更听哪个？**
A：两者没有优先级之分，都是 context，Claude 都会"参考"但不会强制执行。区别在于加载时机：CLAUDE.md 每次 session 开始全量加载，Skills 只在相关时才加载。如果你的指令需要绝对强制执行，应该用 Hooks，那是 Shell 脚本级别的保证。

**Q：Skill 描述加了关键词，但 Claude 还是不自动触发，怎么排查？**
A：先运行
```
What skills are available?
```
看 Claude 能否列出这个 Skill。如果能列出但不触发，大概率是 description 里的关键词和你实际说的话差距太大。如果列不出来，检查 SKILL.md 文件路径是否正确（必须在
```
skills/<name>/SKILL.md
```
，不是
```
skills/<name>.md
```
）。另外，如果你有大量 Skills，description 预算可能已经超出，考虑精简或提高
```
SLASH_COMMAND_TOOL_CHAR_BUDGET
```
环境变量。

**Q：context: fork 的子 Agent 跑完后，结果会出现在哪里？**
A：子 Agent 的工作结果会以摘要形式返回到你的主对话里，你和主 Claude 可以继续基于这个摘要交流。子 Agent 的工作过程（读了哪些文件、中间输出）不会出现在主对话里，这正是它的价值所在——保持主 context 干净。

**Q：Skills 可以用在 Claude Code 的 VS Code 插件里吗？**
A：可以。Skills 系统和具体运行环境无关，终端、VS Code 插件、JetBrains 插件里都能用，
```
~/.claude/skills/
```
下的个人 Skills 在所有环境里都有效。

**Q：我有 30 个 Skills，会不会导致每次 session 都很慢？**
A：不会。只有 description 被加载到 context（每条最多 250 字符，总预算约 8000 字符），Skill 的完整内容只在触发时才加载。30 个 Skills 的 description 加起来也就是很小的 token 开销，不会明显影响 session 启动速度。

如果你现在还没有自己的 Skills 库，今天可以先做一件事：把你最近一周重复过 3 次以上的 Prompt，写成一个 Skill。

**就这一个，用一周，感受一下差别。**
很多人犯难了，这个 skill 也太难写了，我下不了手......别急，由于篇幅有限，
码哥下一篇教你如何快速的写出一套完美的 skill。







