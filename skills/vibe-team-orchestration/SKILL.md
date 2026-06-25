---
name: vibe-team-orchestration
description: How a vibe team-lead dispatches work using a persistent agent team — forming it, dispatching via SendMessage, how workers get code context, and teardown. Use in /vibe:plan and /vibe:implement. Pairs with vibe-team-communication-protocol. Owns dispatch mechanics only, never the phase algorithm.
---

# Team orchestration

You run a **persistent named-agent team**. You already know how agent teams work; this skill only pins the vibe conventions. The command owns the algorithm (which roles, what each brief says, in what order); this never repeats it.

## Form the team

- Spawn each role as a **named** `Agent` **when the algorithm first needs it**, and keep it standing so it retains context across messages — never re-spawn a role you already have.
- On-call peers (the architects a command marks "on-call") wait until a design question actually arises — don't pre-spawn idle teammates; keep the live set near 3–5.
- Give each a self-contained first brief; teammates load their own project context (`CLAUDE.md`, skills, codegraph).

## Dispatch

- **"Dispatch to \<role\>"** = one `SendMessage` with the command's brief, then wait. Briefs are short and self-contained: what to do, scope (paths / plan section / IDs), what's already known. Workers read their own plan section and source themselves — never paste code.
- **Every brief must end by telling the worker to `SendMessage` its done-report to `main`** — a worker's final-turn text is not delivered to you (see `vibe-team-communication-protocol`).
- **An idle teammate is a turn that ended, not a run still in flight.** If one goes idle without its report, re-ping once, then get ground truth yourself (read the deliverable, check for a live process). Never wait on a phantom background run.

## Context

You stay out of the code. Each worker starts from the feature's `research.md` (path in its brief), then its own plan section, resolving the rest per `vibe-research-protocol`. The matching architect is on-call for design-intent questions; in `/vibe:plan`, `codebase-researcher` is the context oracle. A blocked worker andon-cords you — you never read code to answer.

## Teardown

When the command's work is complete, **tear down the team** — no teammate left running. One team's lifetime = one invocation.

**Resume caveat:** in-process teammates don't survive `/resume` or `/rewind`. If a name stops answering, re-spawn that role from durable state (Tasks table + decisions) rather than messaging the dead name.
