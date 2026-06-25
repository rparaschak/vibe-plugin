---
name: vibe-solo-orchestration
description: How a vibe team-lead dispatches work when agent teams are NOT available — the FALLBACK mode (some headless/cron contexts, or the agent-teams experimental flag is off). Driving stateless single-shot subagents, briefing each worker to start from the feature's research.md and resolve the rest via codegraph, and re-spawning instead of resuming. Use in /vibe:plan and /vibe:implement only when SendMessage is unavailable. This skill owns dispatch mechanics only, never the phase algorithm.
---

# Solo orchestration

This is the **fallback** — agent teams are the default (see **vibe-team-orchestration**), and you only land here when `SendMessage` is unavailable in this environment (some headless/cron contexts, or the agent-teams experimental flag is off). With no team messaging, the only way to delegate is an **unnamed** `Agent` spawn: a **stateless, single-shot** subagent that runs once on the brief you give it and returns its result inline. It cannot be paused, resumed, or messaged again. This skill defines how you **dispatch** a unit of work and how each worker gets its **code context** under that constraint. The command owns the algorithm; this skill never repeats it.

## The constraints that shape everything

- **You are the only durable memory.** Hold all state yourself — the Tasks table, accumulated findings, the running picture of the working tree. Every brief is fully self-contained; never assume a worker remembers a prior turn.
- **No resume — only re-spawn.** "Continuing" a worker is a brand-new subagent with zero memory of the last one. A blocker comes back only as a *returned result*, which you answer by spawning a fresh worker — not by replying to the old one.
- **No on-call peers.** There is no architect to message mid-task. The worker resolves its own code context via `codegraph` (below); design-intent calls fall to you.

## Code context — research.md first, then codegraph

The feature's `research.md` (written by `codebase-researcher` at the start of `/vibe:plan`) is the pre-built map: cited facts about the current state of the code. Your brief names its path and tells the worker to **read it before exploring** — then resolve the rest with `codegraph` (primarily `codegraph_explore`, per the project `.claude/CLAUDE.md`): where the relevant slices / entities / routes / components live, the conventions to follow, the contracts to honor, the existing test patterns, and the precise files the change will touch. research.md is a snapshot — the worker verifies load-bearing facts via `codegraph` before relying on them. No research.md (older plans) → the worker explores from scratch.

You still do not read application code yourself, and you do not spawn separate explorers mid-task. You point the worker at its scope (paths, plan section, Task/B IDs) and let it run codegraph from inside its own run. The worker itself, however, **may spawn its own bounded `Explore`/Haiku subagent** for a module-scale survey (subagents carry the `Agent` tool too) — a compression boundary that keeps the deep read out of both its context and yours. Same token discipline: codegraph inline first, a subagent only when the survey warrants it.

**File-producing workers reply terse.** A worker whose deliverable is a file (e.g. the researcher writing research.md) must return only a short done-message — section names and counts, never the findings themselves. Its returned result lands in *your* context; the file is the channel, not the reply.

## Dispatch a unit of work

**"Dispatch to \<role\>"** means:

1. `Agent`-spawn the role with a **self-contained brief** = the command's brief content + the scope + an instruction to explore the code via `codegraph` + everything the worker needs to act without asking.
2. Wait for its returned result.

Spawn one worker at a time for dependent steps; independent units may run in parallel.

## Re-spawn on blocker or fix

- **Returned blocker** (`BLOCKED / NEED: …`): resolve what it needs — a design decision is yours to make; a code fact goes back as a pointer (a cite from research.md's Summary, or an explicit instruction to `codegraph_explore` the named symbol); a genuine research gap means re-spawning the researcher with the refined question first (it appends to research.md) — then spawn a **fresh** worker with the original brief + the answer + any partial work the blocked one reported. Don't try to resume.
- **Fix cycle** (reviewer findings): the prior worker is gone, so spawn a **new** engineer with its original brief + the findings **verbatim** + a one-line note that prior work for this unit is already in the working tree and it should `git diff` / read the listed files (and use `codegraph`) before changing them.
- **Cross-cycle state** (e.g. a plan's critique reconciliation or revise rounds): you carry the accumulated decisions and fold them into each fresh brief.
- **Background worker that ended early** (an async subagent returns a useless/empty result with no done-report): don't assume failure — its work may be complete in the tree. `git status` / `git diff` the tree first, then spawn a fresh verifier with the file list to audit, finish, or build what's there. (from L18 · 2026-06-16)

## No teardown

There is no team to delete. When the command's work is complete, finalize and report.
