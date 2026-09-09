---
title: "Prompting guidance for GPT-5.6 Sol"
source_url: "https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6"
author: "OpenAI"
fetched_at: "2026-07-15T19:00:00+08:00"
fetcher: "jina"
---

# Prompting guidance for GPT-5.6 Sol

Use this guide when adapting prompts, tool descriptions, agent instructions, or prompt stacks to GPT-5.6 Sol or the GPT-5.6 family. Pair it with the current GPT-5.6 model guide for API details, limits, pricing, and feature availability.

GPT-5.6 works best when prompts define the outcome, important constraints, available evidence, and completion bar, then leave room for the model to choose an efficient path. Removing repeated instructions and examples and simplifying tool descriptions can improve task performance and token efficiency. In a sample of internal coding-agent eval runs, configurations with leaner system prompts improved evaluation scores by roughly 10–15% while reducing total tokens by 41–66% and cost by 33–67%. Results will vary by workload, so treat these ranges as directional and validate changes on representative tasks from your own application.

## Simplify prompts first

Start with a prompt and tool set that already works. Remove one group of instructions, examples, or tools at a time, then rerun the same evals. Trim repeated statements of the same rule; repeated style or process instructions that do not change behavior; examples that do not change behavior; process instructions for behavior the model already performs reliably; and tools and tool descriptions unrelated to the task. Keep the user-visible outcome; success criteria and stopping conditions; safety, business, evidence, and permission constraints; tool-routing rules when the route depends on context; and required output shape and validation requirements. Review the remaining instructions for contradictions. GPT-5-class models follow prompt contracts closely, so conflicting rules can create more instability than missing detail.

## Outcome-first prompts and stopping conditions

Describe the destination rather than prescribing every step. GPT-5.6 can usually choose an efficient search, tool, or reasoning path when the prompt states what good looks like.

```text
Resolve the customer's issue end to end.

Success means:
- make the eligibility decision from available policy and account evidence
- complete any allowed action before responding
- return completed_actions, customer_message, and blockers
- if required evidence is missing, ask for the smallest missing field
```

Avoid unnecessary absolute rules. Use ALWAYS, NEVER, must, and only for true invariants such as safety rules, required fields, or actions that should never happen. For judgment calls, such as when to search, ask, use a tool, or keep iterating, prefer decision rules. Preserve explicit user values. When the correct value is implicit, provide decision criteria and let the model reason from context or schema. Avoid universal defaults, keyword maps, and broad semantic shortcuts.

```text
Resolve the request in the fewest useful tool loops, but do not let loop minimization outrank correctness, required evidence, calculations, or required citations.

After each result, ask whether the core request can now be answered with useful evidence. If yes, answer. If required evidence is still missing, name the missing fact and use the smallest useful fallback.
```

## Personality, collaboration, and response length

GPT-5.6 tends to be more concise by default than GPT-5.5. For more consistent control, use `text.verbosity` at low, medium, or high, then specify task-specific length, structure, or required content in the prompt. For customer-facing assistants and collaborative products, define both personality and collaboration style, but keep them short. Neither should replace clear goals, success criteria, tool rules, or stopping conditions. For a short response, state what information must survive trimming: lead with the conclusion, include evidence, caveat, and next action, and omit secondary detail and repetition.

For editing, rewriting, summaries, and customer-facing drafts, preserve the requested artifact, length, structure, genre, and factual claims first; improve clarity, flow, and correctness without adding new claims, sections, or a more promotional tone unless requested.

## Define autonomy and approval boundaries

GPT-5.6 can be proactive and persistent on multi-step tasks. Define what level of action each request authorizes, so it can continue safe in-scope work without unnecessary pauses while stopping before external, destructive, costly, or scope-expanding actions. The guide distinguishes answer, explain, review, diagnose, and plan work from change, build, and fix work. It recommends confirmation for external writes, destructive actions, purchases, or a material expansion of scope, while allowing requested in-scope local changes and non-destructive validation.

## Tool routing, PTC, and retrieval

Expose only task-relevant tools. Tool descriptions should state what the tool does, when to use it, important return fields, and error behavior. If correctness depends on a prerequisite lookup, state that prerequisite rather than allowing the agent to skip it because the intended final state looks obvious. Independent reads can run in parallel, but a result that determines the next step should remain sequential. Synthesize parallel retrieval before acting, and try one or two meaningful fallbacks for empty or suspiciously narrow results.

Programmatic Tool Calling (PTC) is for bounded workflows where code filters, joins, sorts, ranks, deduplicates, aggregates, batches, or repeatedly validates results before returning a much smaller structured output. It is not justified merely by multiple calls. Prefer direct calls when results affect the next decision, an action needs approval, the answer must preserve citations, or semantic judgment is needed.

For grounded answers, define what needs support, what counts as enough evidence, and what happens when evidence is missing. For research and synthesis, cite only retrieved sources, attach citations to the claims they support, label inference separately, state conflicts, and narrow the answer rather than guessing.

## Reasoning effort and migration

Establish a baseline with the current reasoning effort before changing it. Test the same setting and one level lower on representative tasks. Use high or xhigh only when evals show a meaningful gain; first check whether the prompt lacks a success criterion, dependency rule, tool-routing rule, or verification loop. For migration, switch the model while preserving current reasoning effort, run representative evals before changing prompts, remove obsolete scaffolding and irrelevant tools, add only the smallest targeted instruction that fixes a measured regression, and rerun the evals after every prompt or reasoning change. Do not rewrite a working stack all at once; inspect real traces to make surgical changes when it regresses.
