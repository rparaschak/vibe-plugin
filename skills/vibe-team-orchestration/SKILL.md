---
name: vibe-team-orchestration
description: How a vibe team-lead dispatches work using an agent team — the DEFAULT mode. Forming the team by spawning named teammates, dispatching via SendMessage, how workers get code context, and tearing down. Use in /vibe:plan and /vibe:implement whenever SendMessage is available. Pairs with vibe-team-communication-protocol. Owns dispatch mechanics only, never the phase algorithm.
---

# Team orchestration

`SendMessage` is available, so you run a **persistent team** — the vibe default. You already know how agent teams work; this skill only pins down the vibe conventions and the two non-obvious gotchas. The command owns the algorithm (which roles, what each brief says, in what order); this never repeats it.

## Form the team — spawn each role as a *named* Agent

- A **named** `Agent` is a standing, addressable teammate; the first named spawn auto-creates the shared team + task list (there is no `TeamCreate`).
- Spawn each role **when the algorithm first needs it** — a named teammate can be added at any point in the session (there is no "formation turn" lock-in). Spawn a role **once** and keep it standing so it retains context across messages; never re-spawn a role you already have. On-call peers (the architects a command marks "on-call") can wait until a design question actually arises — don't pre-spawn idle teammates you may never message (it wastes tokens and bloats the panel; keep the live set near the recommended 3–5).
- Give each its `subagent_type`, the `model` if the command names one, and a self-contained first brief. Teammates load the project `CLAUDE.md`, skills, and MCP themselves.

## Dispatch

**"Dispatch to \<role\>"** = one `SendMessage` to that role with the command's brief, then wait. Briefs are short and self-contained (what to do; scope = paths / plan section / IDs; what's already known). Workers read their own plan section and source themselves — never paste code.

**Gotcha — the worker must send its deliverable.** A teammate's final-turn text is NOT delivered to you; on finish you get only an idle notification. So **every brief must end by telling the worker to `SendMessage` its done-report back to `main`** in the protocol's done-format — even a file-producing worker sends a terse reply (sections + counts).

**Gotcha — idle without a report is a turn that ended empty, not a run still in flight.** An idle teammate executes nothing; it is never "still running the tests in the background" (it can't — see the protocol's "Long-running work finishes inside your turn"). So when a worker goes idle without its report: re-ping **once** to ask it to resend; if it's idle again with no report, **stop waiting and get ground truth yourself** — read the deliverable it should have produced (the recorded test result, the file, the build output) and check for a live process. Never wait passively on a teammate that "armed a monitor" or "backgrounded the run" and went idle: that run is dead or orphaned and no message is coming — re-dispatch it to run **in the foreground** and report on completion. Don't assume failure, but never assume a phantom run is progressing either.

## Context — workers pull their own

You stay out of the code. Each worker reads the feature's `research.md` (path named in the brief) first, then its own plan section, resolving residual lookups with `codegraph` and verifying load-bearing research facts before relying on them. The matching architect is on-call for design-intent questions; in `/vibe:plan`, `codebase-researcher` stays on-call as the context oracle. A blocked worker resolves via codegraph/peers or andon-cords you — you never read code to answer.

**A worker can spawn its own subagents.** The harness gives teammates a working `Agent` tool, so when a lookup outgrows inline `codegraph` — a module-scale survey, or breadth that would bloat the worker's own context — the worker should spawn a **bounded `Explore` (or Haiku) subagent as a compression boundary** and work from the returned summary, rather than round-tripping a pure *research* gap back through you. Project `CLAUDE.md` token rules still apply: codegraph inline first, subagents only when the survey genuinely warrants it, and never re-explore what `research.md` already covers. Reserve the andon-cord for design/structural problems — not for "I need to read more code."

## Teardown — no `TeamDelete`

When the command's work is complete (plan finalized / Implemented / Blocked), ask each teammate to shut down (a graceful shutdown request the teammate acknowledges). The team itself needs **no explicit deletion** — there is no `TeamDelete`, and the team's files are cleaned up automatically when the session ends. The lead's only teardown action is dismissing the teammates. One team's lifetime = one invocation.

**Resume caveat:** in-process teammates don't survive `/resume` or `/rewind`. If a name stops answering, re-spawn that role with a brief reconstructed from durable state (Tasks table + decisions) rather than messaging the dead name.
