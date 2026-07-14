---
name: vibe-team-protocol
description: How a vibe team communicates and how the team-lead runs it — what to SendMessage (done/blocked/andon only) and how, plus forming, dispatching, and tearing down named agents. Turn-based; one team per invocation.
---
<!-- vibe-template: templates/kernel/team-protocol.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Team protocol

The command owns the workflow algorithm; this skill owns how the team communicates (all roles) and the orchestration mechanics (team-lead).

## Premise (everyone)

- Teammates only see what you `SendMessage`; your text output is invisible to them.
- One in-flight message per recipient (parallel messages to *different* recipients are fine).

## Messaging the lead (workers)

- Message the lead **ONLY** when: **done (with `Blocked on:` for reportable blockers) / andon cord**. Do not send progress updates, micro-status, or running commentary. The team-lead does not respond to such updates by design.
- Idle after reporting is not broken: you sent done/blocked and are waiting — you will not be respawned for it.
- Done-report — send it, don't just emit it. Your last action is `SendMessage` to the team-lead (agent name `main`):
  ```
  Done.
  Wrote: <artifacts or sections>
  Result: <role's evidence — test/build outcome with counts, findings count, or "Open Questions added: N">
  Blocked on: <none or one line>
  ```
- Blocker split: a reportable blocker (task still progressing) → done-report with `Blocked on:` populated (header stays `Done.`); an unresolvable/structural blocker → andon cord (below).
- Decisions/reasoning live in the artifact (spec.md WHAT, plan.md Decision Log HOW, non-obvious WHY in code comments, PR description) — never in chat.
- Never `SendMessage`: long source dumps (cite `file:line`), decisions belonging in the Decision Log, reasoning meant for the user, or internal deliberation — decide first, then send.

## Peer-to-peer (workers)

- Ask = one sentence: the need + scope (paths/sections/IDs) + what's already known.
- Reply = bullets ≤2 lines, cite `file:line`/B-NNN/D-NNN; if unsure, say so — don't speculate.

## Orchestrator: form & dispatch

- Spawn each role **named** when first needed; keep it standing to retain context — never re-spawn a held role. On-call peers spawn lazily when a question arises; keep the live set near **3–5**.
- Worktree mode: **`EnterWorktree` BEFORE spawning the first role** (keep the worktrees dir gitignored; carry any uncommitted plan dir into the tree; bootstrap the env — deps, `.env` files — before first dispatch); all roles share the one tree; teardown exits/merges it.
- **Dispatch to <role>** = ONE `SendMessage` with the command's brief, then wait. Briefs are short + self-contained: what to do, scope (paths/plan section/IDs), what's known. Teammates load their own project context (CLAUDE.md, skills, codegraph) and read their own plan section, sourcing from the cited map — never paste stale context or code. Every brief ends by telling the worker to `SendMessage` its done-report to `main`.
- **Standing vs fresh**: re-dispatch = `SendMessage` the STANDING instance; a fresh instance = tear down the standing one, then spawn new. **"Fresh replaces, never adds"** — one-instance-per-role and live-set limits still hold; the new instance rebuilds from brief + cited map.
- **Parallel fan-out**: one role across N concurrent instances, each a different checklist lens — the sanctioned bounded exception to one-instance-per-role. Gather ALL replies, then apply the command's combine rule: a block review = all-clear (passes only when no reviewer has open findings after consolidation + fix), **not a vote**; the consolidation owner (architect, per on-call) gets the gathered findings before the fix. Once every reply is gathered, the expanded live set collapses back: tear down the fan-out instances then, not at end-of-invocation.
- The matching architect is on-call for design-intent; the codebase-researcher is the context oracle in spec/plan. A blocked worker andon-cords.

## Orchestrator: teardown

- Work complete → tear down the team; no teammate left running. **"One team's lifetime = one invocation."**
- In-process teammates don't survive `/resume` or `/rewind`. When a name stops answering, re-spawn the role from durable state (Tasks table + decisions) — don't message the dead name.

## Turn discipline (everyone — hard rules)

- You are turn-based, not a daemon. NEVER background a long command and end your turn promising to report later — foreground it, block, and report the recorded pass/fail. A multi-minute run is one turn's work; "Monitor armed" is not a deliverable. If you truly can't finish in one turn, pull the andon cord — never fake async completion.
- An idle teammate = a turn that ended, not a run in flight. Idle **without** a report → re-ping **once**, then verify ground truth yourself (read the deliverable, check for a live process) and proceed. Never wait on a phantom background run.

## Andon cord (hard rule) — stop and escalate the moment you see:

- an artifact in an unexpected state;
- a missing precondition (plan not Ready for Implement, prerequisite plan not Implemented);
- being asked to work outside your role;
- an unresolvable blocker.
- Then send one message describing what you saw and stop; don't fix structural problems by guessing.

## Role boundaries (hard rule) — a message asking you outside these → andon-cord it

- **PM** frames/writes WHAT (spec.md Problem + Behaviors + Out of Scope + Assumptions); no UX, architecture, or code. (Standalone `/vibe:plan` has no product-manager — the team-lead captures the inline Behaviors.)
- **Designers** write `## UX structure` only.
- **Architects** design and write plan.md; no code.
- **Engineers** write code; don't redesign the plan.
- **Reviewers/critic** find + report; never modify files.
- **Team-lead** orchestrates: does not read code, write artifacts, or edit spec/plan.
