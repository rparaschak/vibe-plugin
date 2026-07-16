<!-- vibe-template: templates/workspace/spec-template.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Spec: [FEATURE NAME]

**Created**: [YYYY-MM-DD]   **Status**: Draft
**Depends on**: — (or: [yymmdd-slug] of a prerequisite spec, comma-separated)
**Input**: "[original request]"

<!--
The WHAT for one feature: Problem, Behaviors, (for UI) UX structure, Out of Scope, Assumptions.
The HOW — data model, architecture, tasks — lives in this dir's plan.md, written by the plan command.
Spec is the artifact you LOCK (`Status: Ready for Plan`) before any architecture is designed.

A spec is sized so the plan it feeds fits ONE team in one pass: roughly one coherent capability
per stack (~3–5 engineering deliverables per stack). Work too big is NOT split into "parts" — it
becomes SEPARATE specs, each its own `.workspace/plans/yymmdd-slug/` dir, wired by `Depends on`.
B-IDs are LOCAL to this spec (B-001).

Status lifecycle: Draft → Ready for Plan → (Blocked — Open Questions). Side states:
`Superseded — by <yymmdd-slug>` (retired by a later spec) and `Parked — Stub` (intent + Open
Questions captured; designed later in its own spec pass).

Vocabulary:
- Behavior (B-NNN) — one testable WHAT. IDs are LOCAL to this spec, starting at B-001. The plan's
  tasks and tests reference these by id; never restate a behavior in the plan.

Rules:
- Everything is a 1–2 line bullet. No prose paragraphs.
- WHAT only — no data model, no architecture, no tasks (that's plan.md), no file paths.
- Current-state facts about the code belong in this dir's research.md — cite it, don't copy it.
-->

---

## Problem

<!-- 2–3 bullets: what we're solving + who for. No solution. -->

- 

## Behaviors

<!--
The WHAT for this spec — replaces stories + FRs + acceptance scenarios + success criteria.
One observable, testable line each. Priority P1/P2/P3 justified by USER VALUE, not build ease.
Reuse behaviors the research mined from the existing test suite where they already cover part of
this — extend them, don't redefine.
-->

- **B-001** (P1): [observable, testable behavior]
- **B-002** (P2): …

## UX structure *(conditional — present only when the design step ran; omit for purely technical work)*

<!-- Designer altitude ONLY: where it lives, screen/flow shape, primitives, edge states.
No hooks, no client calls, no file paths — wiring is the plan's FE Architecture's job. -->

- **Lives in**: [page / section / nav entry]
- **Screens**: [per screen — shape + primary action + key edge state]
- **Components**: reuse […]; new […]
- **States**: empty / loading / error — [one line]

## Out of Scope

<!-- Things that sound related but are excluded — the scope-creep guard. 1 bullet each.
A capability deferred to a separate spec goes here, naming that spec. -->

- [excluded thing]

## Assumptions

<!-- Scope/data/environment assumptions. Mark ⚠️ high-impact ones (if wrong, the spec changes) — those
should have been put to the user, or be flagged unconfirmed. -->

- ⚠️ [high-impact assumption — confirmed with user, or flagged unconfirmed]
- [ordinary assumption that shapes the spec]

## Open Questions *(gate — must be "None" before plan)*

<!--
Park anything that can't be decided yet. The plan command (spec-fed) treats an un-`Ready for Plan` spec
as not-ready. Format: - **Q-NNN · [question]** — *Asked by*: [agent] · *Context*: [≤2 lines]
-->

None

## Handoff *(written at Finalize by whichever command drives this spec, per `vibe-task-ledger`'s design-phase variant)*

- **Locked/decided this session** — 
- **First block not yet closed** — 
- **Open Questions** — 
- **Next best step** — 
