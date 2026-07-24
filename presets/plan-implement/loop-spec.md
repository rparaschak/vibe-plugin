---
loop: roadmap
description: Drain the roadmap queue chunk by chunk — one disposable planner session then one implementer session per chunk, each verified against artifacts before its workspace is killed.
---
<!-- vibe-template: presets/plan-implement/loop-spec.md v2 | generated 2026-07-24 | edits below this marker are yours -->
<!-- Preset LOOP SPEC for the plan-implement harness. build-harness stamps this to `HARNESS_ROOT/loops/roadmap.md` when the cmux loop opt-in is taken; the user fills the {{...}} Discover slots, then `/vibe:build-loop roadmap` compiles it. -->

## Queue
Chunks live in `.workspace/roadmap.md` — one `## Chunk: <slug>` section each, in priority order, user-maintained. Seeding: on first run the loop writes each chunk as two leaves (`<slug>·plan`, `<slug>·implement`) into `.workspace/loops/roadmap/ledger.md`. Roadmap edits are picked up at the next clock-in, never mid-rotation.

## Stages
1. **plan** — flow: `{{CMD_PLAN}}` · cli: `{{WORKER_CLI}}` <!-- Discover: the worker CLI + flags — binary, model, permission mode, e.g. `claude --model opus --permission-mode acceptEdits` --> · verify: `.workspace/plans/<yymmdd-slug>/plan.md` exists and its header reads `Status: Ready for Implement` (read the header lines only) · gate: plan approval happens IN the planner session — its `done` signal MEANS user-approved; a drafted-but-unapproved plan keeps the leaf `active`.
2. **implement** — flow: `{{CMD_IMPLEMENT}}` · cli: `{{WORKER_CLI}}` · verify: the plan dir moved to `.workspace/plans/archive/` · `git log --oneline -5` shows the block commits · `{{PUSH_CHECK}}` <!-- Discover: the push-reached-remote check if this project pushes, e.g. `git status -sb` shows no `ahead` marker; a local-only project fills `:` (skip) --> · gate: none beyond the flow's own Finalize — the user reviews per chunk at the loop board.

## Standing decrees
{{DECREES}}
<!-- Discover: the standing project rules every brief must carry by reference — branch + push targets, freeze rules, "leave pre-existing dirty files alone", debt-goes-to-triage. Seeded into the ledger's `## Standing decrees`; briefs cite that path. -->

## Policy
Serial, WIP=1 — one live worker session; the loop is repo-read-only while one is live. Wait timeout `{{WAIT_TIMEOUT}}`s per rotation <!-- Discover: ~2× the slowest expected stage, e.g. 3600 -->, then a `read-screen` liveness judgment per `loop-protocol`. Batching: two roadmap chunks share ONE planner session only when the roadmap marks `batch-with: <slug>` — a stated rule, never improvised.

<!-- build-loop, compiling this spec: DESCRIPTION → command `description`; QUEUE + STAGES + DECREES + POLICY → the {{STAGES}} slot; SLUG `roadmap` → named artifacts `.workspace/loops/roadmap/ledger.md` + `briefs/`; LOOP_SPEC = `HARNESS_ROOT/loops/roadmap.md`. -->
