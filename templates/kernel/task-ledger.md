---
name: task-ledger
description: The task state discipline every command and agent gates on — plans are a feature→leaf hierarchy where each leaf is evidence-gated through a closed state enum and only the team-lead advances states, never on a self-claim of done.
---
<!-- vibe-template: templates/kernel/task-ledger.md v2 | generated 2026-07-24 | edits below this marker are yours -->

# Task ledger

The plan is the ledger. It holds a two-level hierarchy: **features** (user-visible outcomes) → **leaves** (the unit of work, each sized for a single agent session). The leaf is what gets tracked, gated, and closed.

## The four fields (every leaf carries all four)

- **behavior** — the user-visible outcome, never the implementation step.
- **verification** — executable command(s) or a concrete observable check. Never prose like "works correctly".
- **state** — one of the closed enum below.
- **evidence** — append-only: commit hash + the test/command output a reviewer cited.

## State enum (closed — no other values exist)

`not_started | active | blocked | passing`

`passing` is irreversible except by an explicit team-lead/user decision recorded in the decision log.

## Transitions (hard rules)

- Only the **team-lead** changes states. Never the agent that did the work.
- `active → passing` requires **reviewer-cited evidence**: the reviewer names the commit AND the executed verification output. An engineer's own "done" is never sufficient.
- `blocked` requires a one-line reason + what would unblock it. When the unblock condition is met, the team-lead returns the leaf to `not_started` (re-picked under WIP=1).

## WIP = 1

Exactly **one leaf `active` per ledger**. Parallel worktrees each carry their own ledger and therefore their own single active leaf; within one ledger, never two. No "also fixing" adjacent items mid-leaf. New findings become new `not_started` leaves — not scope creep.

## Stop conditions (numeric)

- Max **3** fix→re-review rounds per leaf.
- **No-progress detection**: if the same findings survive **two consecutive rounds**, stop and **escalate to the team-lead/user** (pull the andon cord): halt work on the leaf and surface the surviving findings for a decision.
- The **team-lead** keeps a compact round log per leaf: round #, what changed, reviewer verdict, next action.

## Skip log (adaptive flows)

- An adaptive command may skip a default step (a research dispatch, a critic pass, a full review) **only by logging it**: one line per skip, format `- skipped <step> — <reason>`, appended to the plan's `## Skip log` section. **Never a silent skip.** Skips are distill fuel — a costly skip becomes a learning at the next distill pass.
- **Invariants cannot be skipped into existence.** A skip line never satisfies an evidence gate — `active → passing` still requires reviewer-cited evidence, and states still move only on the team-lead's verified flip. The Skip log records that a STEP was omitted; it proves nothing about the work.

## Two-level verification

- **Leaf** = command-level check ("endpoint returns 201").
- **Feature** = end-to-end behavior check ("user can register end to end").
- A feature is not done when its leaves pass — it is done when its **own E2E verification** passes.

## Decision log (append-only table in the plan)

| date | decision | reasoning | rejected alternatives |

Write a row when deviating from the plan or resolving an ambiguity. Read on resume — settled decisions are not re-litigated.

## Sentinel-append (lead context diet)

- Lead-owned append-only log sections each end with a fixed sentinel comment: `<!-- /decision-log -->`, `<!-- /skip-log -->`, `<!-- /round-log -->`, `<!-- /learnings -->` — one per section kind, when the section exists.
- **Appending = ONE `Edit`**: old_string is the sentinel, new_string is the new row(s) + the sentinel. **No pre-read of the section, ever** — that's the point.
- **Batch at gates**: log rows (decision, skip, round) are written as one Edit per section per gate — never one Edit per row mid-work. **Never batched, always immediate**: leaf state flips, the WIP=1 active-leaf mark, and the Handoff block on any pause/andon.
- A section absent from a given plan is **bootstrapped on first append** (heading + sentinel), never pre-created.

## Handoff block (team-lead writes when pausing; first thing read on resume)

- **Verified now** — what is confirmed working.
- **Changed this session** — what moved.
- **Broken or unverified** — what is not yet proven.
- **Next best step** — the single next action.

Design-phase variant (a spec/design run with nothing built yet): use **Locked/decided this session** / **First block not yet closed** / **Open Questions** in place of the first three; keep **Next best step**.

## Ledger example (this table doubles as the format spec)

| leaf | behavior | verification | state | evidence |
|---|---|---|---|---|
| L-001 | user registers via API | `curl -X POST /register` → 201 | passing | a1b2c3d; `curl` → `HTTP/1.1 201`, reviewer-run |
| L-002 | duplicate email rejected | `POST /register` dup → 409 | active | — |
| L-003 | welcome email sent | assert queue has 1 job | not_started | — |
