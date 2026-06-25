---
title: "multica-ai GitHub"
source_url: "https://github.com/multica-ai"
author: "multica-ai"
fetched_at: "2026-06-26T00:15:16+08:00"
fetcher: "github-api"
---

# multica-ai GitHub

Public organization snapshot from GitHub API: 5 public repositories as of this ingest. Focus repositories: multica-ai/multica (managed agents platform), multica-ai/multica-cli (portable agent skill for the Multica CLI), multica-ai/andrej-karpathy-skills (CLAUDE.md coding guidelines).

# multica/README.md

<p align="center">
  <img src="docs/assets/banner.jpg" alt="Multica — humans and agents, side by side" width="100%">
</p>

<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/assets/logo-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="docs/assets/logo-light.svg">
  <img alt="Multica" src="docs/assets/logo-light.svg" width="50">
</picture>

# Multica

**Your next 10 hires won't be human.**

The open-source managed agents platform.<br/>
Turn coding agents into real teammates — assign tasks, track progress, compound skills.

[![CI](https://github.com/multica-ai/multica/actions/workflows/ci.yml/badge.svg)](https://github.com/multica-ai/multica/actions/workflows/ci.yml)
[![GitHub stars](https://img.shields.io/github/stars/multica-ai/multica?style=flat)](https://github.com/multica-ai/multica/stargazers)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2?logo=discord&logoColor=white)](https://discord.gg/W8gYBn226t)

[Website](https://multica.ai) · [Cloud](https://multica.ai) · [Discord](https://discord.gg/W8gYBn226t) · [X](https://x.com/MulticaAI) · [Self-Hosting](SELF_HOSTING.md) · [Contributing](CONTRIBUTING.md)

**English | [简体中文](README.zh-CN.md)**

</div>

## What is Multica?

Multica turns coding agents into real teammates. Assign issues to an agent like you'd assign to a colleague — they'll pick up the work, write code, report blockers, and update statuses autonomously.

No more copy-pasting prompts. No more babysitting runs. Your agents show up on the board, participate in conversations, and compound reusable skills over time. Think of it as open-source infrastructure for managed agents — vendor-neutral, self-hosted, and designed for human + AI teams. Works with **Claude Code**, **Codex**, **GitHub Copilot CLI**, **OpenClaw**, **OpenCode**, **Hermes**, **Gemini**, **Pi**, **Cursor Agent**, **Kimi**, **Kiro CLI**, and **Qoder CLI**.

For larger teams, Squads add a stable routing layer: assign work to a group led by an agent, and the leader delegates to the right member.

<p align="center">
  <img src="docs/assets/hero-screenshot.png" alt="Multica board view" width="800">
</p>

## Why "Multica"?

Multica — **Mul**tiplexed **I**nformation and **C**omputing **A**gent.

The name is a nod to Multics, the pioneering operating system of the 1960s that introduced time-sharing — letting multiple users share a single machine as if each had it to themselves. Unix was born as a deliberate simplification of Multics: one user, one task, one elegant philosophy.

We think the same inflection is happening again. For decades, software teams have been single-threaded — one engineer, one task, one context switch at a time. AI agents change that equation. Multica brings time-sharing back, but for an era where the "users" multiplexing the system are both humans and autonomous agents.

In Multica, agents are first-class teammates. They get assigned issues, report progress, raise blockers, and ship code — just like their human colleagues. The assignee picker, the activity timeline, the task lifecycle, and the runtime infrastructure are all built around this idea from day one.

Like Multics before it, the bet is on multiplexing: a small team shouldn't feel small. With the right system, two engineers and a fleet of agents can move like twenty.

## Features

Multica manages the full agent lifecycle: from task assignment to execution monitoring to skill reuse.

- **Agents as Teammates** — assign to an agent like you'd assign to a colleague. They have profiles, show up on the board, post comments, create issues, and report blockers proactively.
- **Squads** — group agents (and humans) under a leader agent and assign work to the *squad*. The leader decides who should pick it up, so routing stays stable as the team grows. `@FrontendTeam` instead of `@alice-or-bob-or-carol`.
- **Autonomous Execution** — set it and forget it. Full task lifecycle management (enqueue, claim, start, complete/fail) with real-time progress streaming via WebSocket.
- **Autopilots** — schedule recurring work for agents. Cron triggers, webhooks, or manual runs — each autopilot creates the issue and routes it to an agent automatically, so daily standups, weekly reports, and periodic audits run themselves.
- **Reusable Skills** — every solution becomes a reusable skill for the whole team. Deployments, migrations, code reviews — skills compound your team's capabilities over time.
- **Unified Runtimes** — one dashboard for all your compute. Local daemons and cloud runtimes, auto-detection of available CLIs, real-time monitoring.
- **Multi-Workspace** — organize work across teams with workspace-level isolation. Each workspace has its own agents, issues, and settings.

---

## Quick Install

### macOS / Linux (Homebrew - recommended)

```bash
brew install multica-ai/tap/multica
```

Use `brew upgrade multica-ai/tap/multica` to keep the CLI current.

### macOS / Linux (install script)

```bash
curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash
```

Use this if Homebrew is not available. The script installs the Multica CLI on macOS and Linux by using Homebrew when it is on `PATH`, otherwise it downloads the binary directly.

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.ps1 | iex
```

Then configure, authenticate, and start the daemon in one command:

```bash
multica setup          # Connect to Multica Cloud, log in, start daemon
```

> **Self-hosting?** Add `--with-server` to deploy a full Multica server on your machine:
>
> ```bash
> curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash -s -- --with-server
> multica setup self-host
> ```
>
> This pulls the official Multica images from GHCR (latest stable by default). Requires Docker. See the [Self-Hosting Guide](SELF_HOSTING.md) for details.
> If the selected GHCR tag has not been published yet, fall back to `make selfhost-build` from a checkout.

---

## Getting Started

### 1. Set up and start the daemon

```bash
multica setup           # Configure, authenticate, and start the daemon
```

The daemon runs in the background and auto-detects agent CLIs (`claude`, `codex`, `copilot`, `openclaw`, `opencode`, `hermes`, `gemini`, `pi`, `cursor-agent`, `kimi`, `kiro-cli`, `agy`, `qodercli`) on your PATH.

### 2. Verify your runtime

Open your workspace in the Multica web app. Navigate to **Settings → Runtimes** — you should see your machine listed as an active **Runtime**.

> **What is a Runtime?** A Runtime is a compute environment that can execute agent tasks. It can be your local machine (via the daemon) or a cloud instance. Each runtime reports which agent CLIs are available, so Multica knows where to route work.

### 3. Create an agent

Go to **Settings → Agents** and click **New Agent**. Pick the runtime you just connected and choose a provider (Claude Code, Codex, GitHub Copilot CLI, OpenClaw, OpenCode, Hermes, Gemini, Pi, Cursor Agent, Kimi, Kiro CLI, Antigravity, or Qoder CLI). Give your agent a name — this is how it will appear on the board, in comments, and in assignments.

### 4. Assign your first task

Create an issue from the board (or via `multica issue create`), then assign it to your new agent. The agent will automatically pick up the task, execute it on your runtime, and report progress — just like a human teammate.

---

## CLI

The `multica` CLI connects your local machine to Multica — authenticate, manage workspaces, and run the agent daemon.

| Command | Description |
|---------|-------------|
| `multica login` | Authenticate (opens browser) |
| `multica daemon start` | Start the local agent runtime |
| `multica daemon status` | Check daemon status |
| `multica setup` | One-command setup for Multica Cloud (configure + login + start daemon) |
| `multica setup self-host` | Same, but for self-hosted deployments |
| `multica workspace list` | List your workspaces (current is marked with `*`) |
| `multica workspace switch <id\|slug>` | Switch the default workspace for this profile |
| `multica issue list` | List issues in your workspace |
| `multica issue create` | Create a new issue |
| `multica update` | Update to the latest version |

See the [CLI and Daemon Guide](CLI_AND_DAEMON.md) for the full command reference.

---

## Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────────┐
│   Next.js    │────>│  Go Backend  │────>│   PostgreSQL     │
│   Frontend   │<────│  (Chi + WS)  │<────│   (pgvector)     │
└──────────────┘     └──────┬───────┘     └──────────────────┘
                            │
                     ┌──────┴───────┐
                     │ Agent Daemon │  runs on your machine
                     └──────────────┘  (Claude Code, Codex, GitHub Copilot CLI,
                                        OpenCode, OpenClaw, Hermes, Gemini,
                                        Pi, Cursor Agent, Kimi, Kiro CLI, Qoder CLI)
```

| Layer | Stack |
|-------|-------|
| Frontend | Next.js 16 (App Router) |
| Backend | Go (Chi router, sqlc, gorilla/websocket) |
| Database | PostgreSQL 17 with pgvector |
| Agent Runtime | Local daemon executing Claude Code, Codex, GitHub Copilot CLI, OpenClaw, OpenCode, Hermes, Gemini, Pi, Cursor Agent, Kimi, Kiro CLI, or Qoder CLI |

## Development

For contributors working on the Multica codebase, see the [Contributing Guide](CONTRIBUTING.md).

**Prerequisites:** [Node.js](https://nodejs.org/) v20+, [pnpm](https://pnpm.io/) v10.28+, [Go](https://go.dev/) v1.26+, [Docker](https://www.docker.com/)

```bash
make dev
```

`make dev` auto-detects your environment (main checkout or worktree), creates the env file, installs dependencies, sets up the database, runs migrations, and starts all services.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full development workflow, worktree support, testing, and troubleshooting.

An iOS mobile client lives in [`apps/mobile/`](apps/mobile/) — see its [README](apps/mobile/README.md) for how to build it onto your own iPhone.

---

# multica-cli/README.md

# Multica CLI Skill

> Built for [Multica](https://github.com/multica-ai/multica) — an open-source platform for running and managing coding agents with reusable skills.

A portable skill that teaches any local coding agent — Claude Code, Codex, Cursor,
and others — how to operate [Multica](https://github.com/multica-ai/multica)
through the authenticated `multica` CLI: read and triage issues, reply to
comments safely, manage metadata, and handle mention/status side effects.

English | [简体中文](./README.zh.md)

## What it does not do

This repository does **not** grant Multica access by itself. Permissions come
only from the user's local CLI login, selected profile, active workspace, and
explicit approval for any commands the agent runs. The skill teaches *how* to
drive Multica safely; it never bypasses workspace permissions or stores secrets.

## What it covers

- Checking CLI auth, profile, and workspace state (and how to log in)
- Reading issues, comments, metadata, projects, agents, squads, runtimes, repos,
  skills, autopilots, and attachments
- Writing safe issue comments with `--content-file`
- Creating or updating issues and high-signal metadata
- Handling mention, status, assignment, rerun, and sub-issue side effects
- Linking pull requests back to Multica issues

## Install

The skill lives at `skills/multica-cli/`. Pick the path for your tool.

### Claude Code (plugin marketplace)

```text
/plugin marketplace add multica-ai/multica-cli
/plugin install multica-cli@multica-cli
```

### Codex (skill installer)

```bash
install-skill-from-github.py --repo multica-ai/multica-cli --path skills/multica-cli
```

Restart Codex after installing new skills.

### Cursor

Copy the skill into your personal Cursor skills directory:

```bash
mkdir -p ~/.cursor/skills/multica-cli
cp -R skills/multica-cli/* ~/.cursor/skills/multica-cli/
```

Or drop the project rule [`.cursor/rules/multica-cli.mdc`](.cursor/rules/multica-cli.mdc)
into a project's `.cursor/rules/` directory. See [CURSOR.md](./CURSOR.md) for details.

### Any other agent

Copy [`skills/multica-cli/SKILL.md`](skills/multica-cli/SKILL.md) into wherever
your tool loads skills or instructions from.

## Requirements

- The `multica` CLI is installed locally.
- The user has run `multica login` (or `multica setup`) to authenticate.
- The intended workspace/profile is selected, or passed explicitly with
  `--workspace-id` and `--profile`.

## Usage

Ask your agent to work with Multica once the skill is installed, for example:

```text
Read MUL-123 with the multica CLI and draft a reply for me to review.
```

For write operations (comments, status changes, mentions, new issues), the agent
should ask before making state changes unless you have already clearly
authorized that exact action. See [EXAMPLES.md](./EXAMPLES.md) for more.

## License

[MIT](./LICENSE)

---

# multica-cli/skills/multica-cli/SKILL.md

---
name: multica-cli
description: "Use when a local coding agent (Codex, Claude Code, Cursor, or similar) needs to operate Multica through the authenticated `multica` CLI: reading or updating issues, comments, metadata, projects, agents, squads, runtimes, repos, skills, autopilots, attachments, or workspace state; replying to a Multica issue from an external agent; creating or triaging issues; checking linked pull requests; or safely handling Multica mention/status side effects without relying on the Multica hosted agent runtime."
---

# Multica CLI

Use the local `multica` CLI as the source of truth. This skill teaches an
external agent how to drive Multica safely; it does not grant permissions.
Permissions come only from the user's installed CLI, selected profile,
workspace, and explicit approval to run commands.

## Start Safely

1. Verify the CLI and account state before doing work:

```bash
multica version
multica auth status
multica config show
```

If `multica auth status` reports no active session, the CLI is not logged in.
Stop and have the user authenticate; do not try to fake credentials:

```bash
multica login        # interactive auth + workspace setup
multica setup        # alternative: configure CLI, authenticate, start daemon
```

2. Use the correct workspace and profile. Discover what is available, then
prefer explicit flags when the user names them:

```bash
multica workspace list --output json                 # which workspaces exist
multica workspace switch <workspace-id>              # set the default for this profile
multica --profile <profile> --workspace-id <workspace-id> issue list --output json
```

3. Prefer `--output json` whenever a command supports it. Parse JSON rather than
scraping tables.

4. Never expose or store tokens, cookies, API keys, or CLI config secrets. Do
not bypass workspace permissions by calling private HTTP APIs directly.

## Command Reference

The flags below are the common ones for the issue workflow you will use most.
You do not need `--help` for these. Run `--help` only to confirm a rejected flag
or to explore the long-tail namespaces (`project`, `agent`, `squad`, `runtime`,
`repo`, `skill`, `autopilot`, `attachment`), whose shapes vary and are not
duplicated here. `[ ]` marks optional flags; `|` marks mutually exclusive ones.

```bash
# Read
multica issue get <id> --output json
multica issue list [--status <s>] [--assignee <name> | --assignee-id <uuid>] [--project <id>] [--priority <p>] [--limit N] [--metadata key=value] --output json
multica issue children <id> --output json
multica issue pull-requests <id> --output json
multica issue metadata list <id> --output json

# Comments (read)
multica issue comment list <id> --recent N --output json                    # N most active threads
multica issue comment list <id> --thread <comment-id> [--tail N] --output json  # one thread (root + replies)
multica issue comment list <id> --roots-only [--summary] --output json       # triage top-level threads
#   also: --since <RFC3339>, --before/--before-id <cursor> for pagination

# Create / update
multica issue create --title "..." [--description-file <path>] [--priority <p>] [--status <s>] [--assignee <name> | --assignee-id <uuid>] [--parent <id>] [--stage N] [--project <id>] [--due-date YYYY-MM-DD] [--attachment <path>] --output json
multica issue update <id> [--title "..."] [--description-file <path>] [--status <s>] [--priority <p>] [--assignee-id <uuid>] [--parent <id> | --parent ""] [--stage N] [--due-date YYYY-MM-DD]

# Status / assignment  (status values: backlog | todo | in_progress | in_review | done | blocked | cancelled)
multica issue status <id> <status>
multica issue assign <id> --to <name> | --to-id <uuid> | --unassign

# Comment (write) — body always via file, see Write Workflow below
multica issue comment add <id> [--parent <comment-id>] --content-file <path> [--attachment <path>]

# Metadata
multica issue metadata set <id> --key <k> --value <v> [--type string|number|bool]
multica issue metadata delete <id> --key <k>
```

Note `issue assign` uses `--to` / `--to-id` (not `--assignee`), while `issue
create` / `issue update` use `--assignee` / `--assignee-id`.

## Read Workflow

Use read commands first, then decide whether a write is needed.

```bash
multica issue get <issue-id-or-key> --output json
multica issue comment list <issue-id-or-key> --recent 10 --output json
multica issue metadata list <issue-id-or-key> --output json
multica issue pull-requests <issue-id-or-key> --output json
```

For large comment histories, prefer focused reads:

```bash
multica issue comment list <issue-id> --thread <comment-id> --tail 30 --output json
multica issue comment list <issue-id> --recent 10 --output json
```

For other resources, inspect the relevant namespace:

```bash
multica project --help
multica agent --help
multica squad --help
multica runtime --help
multica repo --help
multica skill --help
multica autopilot --help
multica attachment --help
```

## Write Workflow

Treat writes as side-effecting. If the user did not clearly ask for the write,
ask before running it. This includes creating comments, issues, status changes,
assignments, reruns, agent mentions, squad mentions, webhook/autopilot changes,
and repo checkout operations.

### Issue Comments

For agent-authored comments, always write the body to a UTF-8 file and pass it
with `--content-file`. Do not use inline `--content` for structured comments:
shells can rewrite backticks, `$()` expressions, variables, quotes, and
newlines before the CLI receives them.

```bash
# Create reply.md with real newlines first, then:
multica issue comment add <issue-id> --parent <comment-id> --content-file ./reply.md
rm ./reply.md
```

Keep the same `--parent` value as the comment being answered when replying to a
thread. Do not write literal `\n` escapes to fake line breaks.

### Issues and Metadata

Use files for long issue descriptions:

```bash
multica issue create --title "..." --description-file ./description.md
multica issue update <issue-id> --description-file ./description.md
```

Metadata is durable issue state, not a log. Read it on entry, but only write
high-signal facts future runs will re-read, such as `pr_url`, `pr_number`,
`pipeline_status`, `deploy_url`, `external_issue_url`, `waiting_on`,
`blocked_reason`, or `decision`.

```bash
multica issue metadata set <issue-id> --key pr_url --value <url>
multica issue metadata delete <issue-id> --key stale_key
```

## Mention Side Effects

Mention links are actions, not decoration:

```text
[@Name](mention://agent/<agent-id>)   # enqueues that agent
[@Name](mention://squad/<squad-id>)   # enqueues the squad leader
[@Name](mention://member/<user-id>)   # renders a person link
[MUL-123](mention://issue/<issue-id>) # renders an issue link
[@all](mention://all/all)             # broadcast, no specific agent run
```

Only `agent` and `squad` mentions enqueue agent work. A `member` mention is a
person link; an `issue` mention is a safe cross-reference.

Look up real UUIDs with JSON output before constructing mentions:

```bash
multica agent list --output json
multica squad list --output json
multica workspace member list --output json
```

Do not mention an agent just to thank, acknowledge, or sign off. Re-mentioning
an agent in a reply can trigger another run and create loops.

## Status and Assignment Side Effects

Status changes are not cosmetic. They can enqueue or stop work.

- `backlog` parks an agent-assigned issue.
- Moving `backlog` to `todo` or another active status can enqueue the assignee.
- `done` and `cancelled` are terminal states.
- `in_review` is useful while a PR or human review is pending, but it is still a
  write.

When creating sub-issues for ordered work, use stages and `backlog` for later
steps:

```bash
multica issue create --title "Research" --parent <id> --assignee <agent> --stage 1 --status todo
multica issue create --title "Build" --parent <id> --assignee <agent> --stage 2 --status backlog
multica issue children <id> --output json
```

## Pull Requests

When code changes are made for a Multica issue, include the routable issue key
in the PR title, body, or branch so Multica can link it.

```text
MUL-123: fix login redirect
```

Use close intent only when merging the PR should close the issue:

```text
Closes MUL-123
Fixes MUL-123
Resolves MUL-123
```

Read linked PR state from Multica rather than guessing from GitHub search or
metadata:

```bash
multica issue pull-requests <issue-id> --output json
```

## External Agent Boundaries

External agents do not receive Multica runtime context automatically. If the
user asks for work on a specific issue or comment, require or derive:

- issue id or issue key
- trigger comment id and parent thread, if replying
- intended workspace/profile, if more than one is configured
- whether writes are allowed
- whether mentions, status changes, reruns, or assignments are allowed

If any of these are missing and the operation would write state, ask before
proceeding. For read-only investigation, gather context with JSON output and
report what else is needed.

---

# andrej-karpathy-skills/README.md

# Karpathy-Inspired Claude Code Guidelines

> Check out my new project [Multica](https://github.com/multica-ai/multica) — an open-source platform for running and managing coding agents with reusable skills.
>
> Follow me on X: [https://x.com/jiayuan_jy](https://x.com/jiayuan_jy)

A single `CLAUDE.md` file to improve Claude Code behavior, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

English | [简体中文](./README.zh.md)

## The Problems

From Andrej's post:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

## The Solution

Four principles in one file that directly address these issues:

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Leverage through tests-first, verifiable success criteria |

## The Four Principles in Detail

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

LLMs often pick an interpretation silently and run with it. This principle forces explicit reasoning:

- **State assumptions explicitly** — If uncertain, ask rather than guess
- **Present multiple interpretations** — Don't pick silently when ambiguity exists
- **Push back when warranted** — If a simpler approach exists, say so
- **Stop when confused** — Name what's unclear and ask for clarification

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

Combat the tendency toward overengineering:

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it

**The test:** Would a senior engineer say this is overcomplicated? If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

**The test:** Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform imperative tasks into verifiable goals:

| Instead of... | Transform to... |
|--------------|-----------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after" |

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let the LLM loop independently. Weak criteria ("make it work") require constant clarification.

## Install

**Option A: Claude Code Plugin (recommended)**

From within Claude Code, first add the marketplace:
```
/plugin marketplace add forrestchang/andrej-karpathy-skills
```

Then install the plugin:
```
/plugin install andrej-karpathy-skills@karpathy-skills
```

This installs the guidelines as a Claude Code plugin, making the skill available across all your projects.

**Option B: CLAUDE.md (per-project)**

New project:
```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

Existing project (append):
```bash
echo "" >> CLAUDE.md
curl https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md >> CLAUDE.md
```

## Using with Cursor

This repository includes a committed Cursor project rule ([`.cursor/rules/karpathy-guidelines.mdc`](.cursor/rules/karpathy-guidelines.mdc)) so the same guidelines apply when you open the project in Cursor. See **[CURSOR.md](CURSOR.md)** for setup, using the rule in other projects, and how this relates to Claude Code.

## Key Insight

From Andrej:

> "LLMs are exceptionally good at looping until they meet specific goals... Don't tell it what to do, give it success criteria and watch it go."

The "Goal-Driven Execution" principle captures this: transform imperative instructions into declarative goals with verification loops.

## How to Know It's Working

These guidelines are working if you see:

- **Fewer unnecessary changes in diffs** — Only requested changes appear
- **Fewer rewrites due to overcomplication** — Code is simple the first time
- **Clarifying questions come before implementation** — Not after mistakes
- **Clean, minimal PRs** — No drive-by refactoring or "improvements"

## Customization

These guidelines are designed to be merged with project-specific instructions. Add them to your existing `CLAUDE.md` or create a new one.

For project-specific rules, add sections like:

```markdown
## Project-Specific Guidelines

- Use TypeScript strict mode
- All API endpoints must have tests
- Follow the existing error handling patterns in `src/utils/errors.ts`
```

## Tradeoff Note

These guidelines bias toward **caution over speed**. For trivial tasks (simple typo fixes, obvious one-liners), use judgment — not every change needs the full rigor.

The goal is reducing costly mistakes on non-trivial work, not slowing down simple tasks.

## License

MIT

---

# andrej-karpathy-skills/CLAUDE.md

# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

---
