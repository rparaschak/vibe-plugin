---
name: vibe-task-ledger
description: The task state discipline every command and agent gates on — plans are a feature→leaf hierarchy where each leaf is evidence-gated through a closed state enum and only the orchestrator advances states, never on a self-claim of done.
---
<!-- vibe-template: kernel/task-ledger v1 | generated 2026-07-13 | edits below this marker are yours -->

# Task ledger

The plan is the ledger. It holds a two-level hierarchy: **features** (user-visible outcomes) → **leaves** (the unit of work, each sized for a single agent session). The leaf is what gets tracked, gated, and closed.

## The four fields (every leaf carries all four)

- **behavior** — the user-visible outcome, never the implementation step.
- **verification** — executable command(s) or a concrete observable check. Never prose like "works correctly".
- **state** — one of the closed enum below.
- **evidence** — append-only: commit hash + the test/command output a reviewer cited.

## State enum (closed — no other values exist)

`not_started | active | blocked | passing`

`passing` is irreversible except by an explicit orchestrator/user decision recorded in the decision log.

## Transitions (hard rules)

- Only the **orchestrator (team-lead)** changes states. Never the agent that did the work.
- `active → passing` requires **reviewer-cited evidence**: the reviewer names the commit AND the executed verification output. An engineer's own "done" is never sufficient.
- `blocked` requires a one-line reason + what would unblock it. When the unblock condition is met, the orchestrator returns the leaf to `not_started` (re-picked under WIP=1).

## WIP = 1

Exactly **one leaf `active` per ledger**. Parallel worktrees each carry their own ledger and therefore their own single active leaf; within one ledger, never two. No "also fixing" adjacent items mid-leaf. New findings become new `not_started` leaves — not scope creep.

## Stop conditions (numeric)

- Max **3** fix→re-review rounds per leaf.
- **No-progress detection**: if the same findings survive **two consecutive rounds**, stop and **escalate to the orchestrator/user** (pull the andon cord): halt work on the leaf and surface the surviving findings for a decision.
- The **orchestrator** keeps a compact round log per leaf: round #, what changed, reviewer verdict, next action.

## Two-level verification

- **Leaf** = command-level check ("endpoint returns 201").
- **Feature** = end-to-end behavior check ("user can register end to end").
- A feature is not done when its leaves pass — it is done when its **own E2E verification** passes.

## Decision log (append-only table in the plan)

| date | decision | reasoning | rejected alternatives |

Write a row when deviating from the plan or resolving an ambiguity. Read on resume — settled decisions are not re-litigated.

## Handoff block (orchestrator writes when pausing; first thing read on resume)

- **Verified now** — what is confirmed working.
- **Changed this session** — what moved.
- **Broken or unverified** — what is not yet proven.
- **Next best step** — the single next action.

## Ledger example (this table doubles as the format spec)

| leaf | behavior | verification | state | evidence |
|---|---|---|---|---|
| L-001 | user registers via API | `curl -X POST /register` → 201 | passing | a1b2c3d; `curl` → `HTTP/1.1 201`, reviewer-run |
| L-002 | duplicate email rejected | `POST /register` dup → 409 | active | — |
| L-003 | welcome email sent | assert queue has 1 job | not_started | — |
