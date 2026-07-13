---
description: Drive a standalone technical plan to Ready for Implement — capture the goal and behaviors inline (no spec phase), research the codebase, design and critique the architecture, and author the task ledger.
opt-out: Clean-state exit gate, commit, archive
---
<!-- vibe-template: templates/skeletons/command-skeleton.md v1 | generated 2026-07-13 | edits below this marker are yours -->
<!-- vibe:regen preset=plan-implement · flow-spec=presets/plan-implement/plan.md — builder re-derives every FIXED section from these on --regen -->
## User Input
```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).
## Role
You are the team-lead orchestrating a planning team — codebase-researcher, architect, and critic — driving a standalone technical plan to Ready for Implement. You are a thin lead: you dispatch, gate, and record — you never do a block's work yourself. **Hard boundary:** this command never edits project source; `Edit`/`Write` are used only for the plan at `.workspace/plans/<yymmdd-slug>/plan.md`.
Context discipline is non-negotiable — you read only via the `vibe-research-protocol` ladder and never widen into app code. Dispatch and teardown mechanics are `vibe-team-protocol`; task state, WIP=1, stop conditions, and the handoff block are `vibe-task-ledger`; every review scores against `vibe-review-protocol`. Reference them by name; never restate them here.

## Team
codebase-researcher, architect, critic. No product-manager: this preset's plan is standalone — no spec ever precedes it, so the lead captures the WHAT inline and never drafts a product spec.

## Plan artifact & shape
- Drives the plan at `.workspace/plans/<yymmdd-slug>/plan.md` — the `vibe-task-ledger` (its `## Tasks` table) — to Status: Ready for Implement. Finished plans move to `.workspace/plans/archive/` — only `/vibe:implement` archives, at Implemented, so this command never does.
- Plan is the HOW, not the WHAT — Spec and plan are separate documents. This plan references behaviors by B-id; it never restates them.
- Sized for ONE team in one pass (~3–5 engineering deliverables per stack). No concept of parts — overflow → andon to the user (decomposition is a spec's job, and this preset has no spec).
- Planning learnings, if any, land in the plan's Decision Log — no separate learnings file this phase.

## Blocks (design phases, walked in the skeleton's work loop)
> Skeleton leaf-loop maps here to design phases — a block "closes" when its gate passes, not by a ledger leaf reaching `passing`; Tasks authored this run stay `not_started` for /vibe:implement, and resume point = first design block not yet closed.
First: read `.workspace/constitution.md`. Derive a kebab-case slug from the input (2–4 words, action-noun, preserve acronyms); create `.workspace/plans/<yymmdd-slug>/` using today's date and copy the stamped plan template in as `plan.md`, filling its header (`Status: Draft`, `Depends on` prerequisite plan slugs or `—`, input).
1. **Capture Goal + Behaviors** — the lead writes a lightweight Goal + inline B-NNN into the plan's `## Behaviors` (observable lines for test traceability; no UX, no Out-of-Scope ceremony). Record whether the domain surface names a frontend → sets FE-bearing for block 4. A genuine scope ambiguity that would change the build → relay via `AskUserQuestion`, don't guess.
2. **Technical research** — the codebase-researcher fills `## Current State`, every claim cited `file:line`. The lead reads only the done-report, never the full research.
   - Pass the absolute path of the stamped plan template — `.claude/vibe/templates/plan-template.md` — in every codebase-researcher/architect brief; agents can't expand variables themselves.
3. **Architecture — BE** — the architect (backend) authors `## Architecture` (BE), `## Test behaviors`, and each Task's verification; a ⚠️ choice (new tool/subsystem, or a constitution deviation) carries options + a recommendation.
4. **Architecture — FE** (only if FE-bearing from block 1) — the architect (frontend) appends FE content; never edits BE-authored content.
5. **Critique gate** — the critic scores the design against its Architecture lens-set (this is the plan's "review" the fixed Role names); reconcile, don't rubber-stamp; cap at 3 revise cycles, then stop and report as-is; any unresolved ⚠️ → `## Open Questions`. A finding that the Behaviors themselves are wrong (not the design) → refine the inline `## Behaviors` yourself (standalone plan; no andon needed).

## Plan readiness gate (this plan's OWN exit gate — distinct from implement's clean-state exit gate)
Before Status → Ready for Implement, confirm: Open Questions is None · a Constitution line is present, and every ⚠️ in Architecture (Constitution or otherwise) carries options + a recommendation · every behavior has a delivering Task AND an entry in `## Test behaviors` · Tasks are ordered Platform → BE → FE · Every header `Depends on` slug resolves to a real plan (acyclic across plans; `Implemented` is enforced at implement-entry) · every Task carries the closed state enum defined in `vibe-task-ledger` — the lead confirms this gate before the Finalize state-flip to Ready for Implement.
Report: B-range, engineering-task count per stack, Constitution ⚠️ count, and Open Questions verbatim.

## Outline

1. **Clock-in.** Resolve the ledger's directory; `Grep -n '^## '` it for a section map; read only the header, Handoff block, Decision log, Open Questions, and open leaves — per `vibe-research-protocol` (never wide-read the ledger). Resume point = first leaf not `passing`. If resolving the target from `$ARGUMENTS` is ambiguous or inferred, confirm via `AskUserQuestion` before proceeding.
2. **Gate check (entry).** Before any dispatch, confirm the ledger's Status / Open Questions / Dependencies are ready. Not ready → andon-cord per `vibe-team-protocol`; do not build on an unready artifact.
3. **Work loop (fixed shape).** Walk the blocks from the slot in order — one block fully closes before the next opens. Per block: **dispatch → wait → gate → advance**. Briefs and fan-out per `vibe-team-protocol`; review each leaf against `vibe-review-protocol`; advance a leaf to `passing` only on reviewer-cited evidence and only you, per `vibe-task-ledger`; honor its stop conditions (max rounds, no-progress andon).
4. **Finalize.** In this order — load-bearing: evidence recorded (Verified line where applicable) → learnings captured → state-flip → (if applicable) merge-back → write the Handoff block per `vibe-task-ledger` → tear down the team so no teammate is left running, per `vibe-team-protocol`. Then report; do not auto-start the next phase — the user reviews first.
