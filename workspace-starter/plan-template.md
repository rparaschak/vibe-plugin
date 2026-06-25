# Plan: [FEATURE NAME]

**Created**: [YYYY-MM-DD]   **Status**: Draft
**Depends on**: — (or: [yymmdd-slug] of a prerequisite plan, comma-separated)
**Input**: "[original request]"

<!--
ONE plan, ONE implement run. This carries both the WHAT (Problem, Behaviors, UX) and the
HOW (Data model, Architecture, Tasks) — there is no separate spec.

A plan is sized for ONE team to build in one pass: roughly one coherent capability per stack
(~3–5 engineering deliverables; test tasks don't count). Work too big for one pass is NOT split
into "parts" — it becomes SEPARATE plans, each its own `.workspace/plans/yymmdd-slug/plan.md` dir and its own run,
wired by `Depends on`. A plan that needs another plan's output names it in `Depends on`; that
prerequisite must be `Implemented` before this plan runs.

Status lifecycle: Draft → Ready for Implement → (Blocked — Open Questions | Blocked — Implement)
→ Implemented. Two side states: `Superseded — by <yymmdd-slug>` (retired by a later plan — set it,
or QA/review findings against this plan are false) and `Parked — Stub` (intent + Open Questions
captured; designed later in its own /vibe:plan pass).

Vocabulary:
- Behavior (B-NNN) — one testable WHAT. IDs are LOCAL to this plan, starting at B-001.
- Task (T-NNN) — one coherent deliverable. Platform T-9xx, BE T-0xx, FE T-1xx. May span files; the
  engineer decomposes internally — never pre-split by artifact.
- Block — Platform / BE / FE. One team builds them in that order, each made green before the next.

Rules:
- Everything is a 1–2 line bullet. No prose paragraphs.
- Each fact has exactly ONE home (UX = user-visible shape · Architecture = decisions ·
  Contracts = the API surface) — cross-reference by B/T/D id, never restate.
- Current-state facts about the code (what exists, where it lives, signatures) belong in this
  dir's research.md — cite it, don't copy it. The plan carries decisions and contracts.
-->

---

## Problem

<!-- 2–3 bullets: what we're solving + who for. No solution. -->

- 

## Behaviors

<!--
The WHAT for this plan — replaces stories + FRs + acceptance scenarios + success criteria.
One observable, testable line each. Priority P1/P2/P3 justified by USER VALUE, not build ease.
-->

- **B-001** (P1): [observable, testable behavior]
- **B-002** (P2): …

## UX structure *(FE — else omit)*

<!-- Designer altitude ONLY: where it lives, screen/flow shape, primitives, edge states.
No hooks, no client calls, no file paths — wiring is the FE Architecture's job. -->

- **Lives in**: [page / section / nav entry]
- **Screens**: [per screen — shape + primary action + key edge state]
- **Components**: reuse […]; new […]
- **States**: empty / loading / error — [one line]

## Data model *(BE — else omit)*

- Table `<name>`: `<col> <type>`, `<col> <type> NOT NULL`, … · FK `<…>` · index `<…>` (serves "<query>")
- *(uses tables owned by [yymmdd-slug] — reference, don't redefine)*

## Architecture

<!--
Decisions + the constitution/platform gate. 1 line each: the decision + its driver.
Name an EXISTING artifact when reuse is load-bearing ("reuse upload-dropzone as-is"); never
pre-name NEW files/components — the engineer owns naming (plan intent binds, naming is advisory).
⚠️ = a choice that needs YOUR call before /vibe:implement (new tool/library/subsystem, or a
constitution deviation) — give options + a recommendation. Any ⚠️ left open → Open Questions.

Platform (the constitution's platform/feature split):
- A NEW subsystem/wrapper → its own Platform task (T-9xx) + a paired platform test task, built and
  green before the BE/FE blocks. Test OUR wrapper, never the installed package. A NEW tool/library
  is ⚠️ (you decide). If it's big enough to blow this plan's budget, it becomes its OWN separate
  plan (a dependency this plan names in `Depends on`).
- A small EXTENSION of an existing subsystem (new method/field/event) → fold inline into the BE/FE
  task that needs it; no separate task, architect decides.
-->

### BE *(architect — backend)*

- [decision — 1-line driver]
- ⚠️ [new tool / library / subsystem, or constitution deviation — options + recommendation]
- **Constitution**: ✅ all clear  (or: ⚠️ <which rule> — why + how it's justified)

### FE *(architect — frontend; append here, never edit BE content)*

- [decision — 1-line driver]

## Test behaviors

<!-- Inventory the implement-phase test engineers write against the built code. Each cites a behavior. -->

### BE *(architect — backend)*

- [what's verified] · B-001

### FE *(architect — frontend)*

- [what's verified] · B-002

## Out of Scope

<!-- Things that sound related but are excluded — the scope-creep guard. 1 bullet each.
A capability deferred to a separate plan goes here, naming that plan. -->

- [excluded thing]

## Assumptions

<!-- Scope/data/environment assumptions. Mark ⚠️ high-impact ones (if wrong, the plan changes) — those
should have been put to the user, or be flagged unconfirmed. -->

- ⚠️ [high-impact assumption — confirmed with user, or flagged unconfirmed]
- [ordinary assumption that shapes the plan]

## Open Questions *(gate — must be "None" before `/vibe:implement`)*

<!--
Park anything you can't decide. `/vibe:implement` refuses to start if this has entries.
Format: - **Q-NNN · [question]** — *Asked by*: [agent] · *Context*: [≤2 lines]
-->

None

## Tasks

<!--
Flat list, sized so ONE team builds this plan in one pass. Order: Platform (T-9xx) → BE (T-0xx) →
FE (T-1xx). The team builds each block and makes it green before the next; an engineer consuming a prior
block's contracts runs its domain's codegen/client-regen step (project-supplied) first. This table
is the ONLY thing /vibe:implement mutates.

- A Task is ONE coherent deliverable (a CRUD endpoint group; a page WITH its hooks + sub-components).
- A Task CELL is 1–2 lines: the deliverable + what it Delivers. Design detail (pipelines, wiring,
  copy) lives in Architecture — cross-reference it, never restate it here; new files stay unnamed
  (the engineer owns naming, same rule as Architecture).
- One test task per block, owned by the test engineer (a fresh context) — NOT counted toward budget.
- Owner ∈ { platform, be-eng, be-test, fe-eng, fe-test }. Status ∈ { Todo, In Progress, In Review, Done, Blocked }.
- Budget ≈ 3–5 engineering deliverables per stack. Over budget → carve the overflow into a SEPARATE plan.
-->

| ID | Block | Task | Delivers | Owner | Status |
|---|---|---|---|---|---|
| T-901 | Platform | [new wrapper/subsystem — only if needed] | — | platform | Todo |
| T-902 | Platform | Tests for the platform subsystem (our wrapper, not the package) | — | be-test | Todo |
| T-001 | BE | [coherent BE deliverable] | B-001 | be-eng | Todo |
| T-002 | BE | Integration tests for the BE block | B-001, B-002 | be-test | Todo |
| T-101 | FE | [page + hooks + components] | B-003 | fe-eng | Todo |
| T-102 | FE | Component tests for the FE block | B-003 | fe-test | Todo |

## Contracts & wiring *(optional — omit by default; include only if the architect decides it adds value, e.g. a platform API surface)*

- `<METHOD> /<path>` — `<InBody> → <OutBody>` · [≤1 line on a non-obvious field]
- Hook `use<Thing>` → `apiClient.<module>.<call>()` · invalidates `['<key>']`

## Decision Log *(optional — non-obvious choices not already captured in Architecture)*

- **D-001** — [decision] · [driver] · [alternative rejected]
