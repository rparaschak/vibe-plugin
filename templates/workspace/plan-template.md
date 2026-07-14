<!-- vibe-template: templates/workspace/plan-template.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Plan: [FEATURE NAME]

**Created**: [YYYY-MM-DD]   **Status**: Draft
**Depends on**: — (or: [yymmdd-slug] of a prerequisite plan, comma-separated)
**Input**: "[original request]"

<!--
The HOW for one feature: Current State, Data model, Architecture, Tasks, Test behaviors.
The WHAT — Problem, Behaviors (B-NNN), UX — lives in this dir's spec.md (produced by /spec,
this command's companion). This plan references behaviors by id; it never restates them. Spec and plan
are SEPARATE documents. (For a purely technical run with no spec, the Behaviors section below is
filled inline with a lightweight Goal + B-NNN — see its note.)

A plan is sized for ONE team to build in one pass: roughly one coherent capability per stack
(~3–5 engineering deliverables; test tasks don't count). Sizing/decomposition is /spec's job —
work too big became SEPARATE specs, each fed to its own plan, wired by `Depends on`. A prerequisite
named in `Depends on` must be `Implemented` before this plan runs.

Status lifecycle: Draft → Ready for Implement → (Blocked — Open Questions | Blocked — Implement)
→ Implemented. Two side states: `Superseded — by <yymmdd-slug>` (retired by a later plan) and
`Parked — Stub`.

Vocabulary:
- Behavior (B-NNN) — one testable WHAT, defined in spec.md (or inline, standalone). LOCAL to this
  feature, starting at B-001. Tasks and Test behaviors reference these by id.
- Task (T-NNN) — one coherent deliverable. Platform T-9xx, BE T-0xx, FE T-1xx. May span files; the
  engineer decomposes internally — never pre-split by artifact.
- Block — Platform / BE / FE. One team builds them in that order, each made green before the next.

Rules:
- Everything is a 1–2 line bullet. No prose paragraphs.
- Each fact has exactly ONE home (Current State = what exists · Architecture = decisions ·
  Contracts = the API surface) — cross-reference by B/T/D id, never restate.
- Behaviors and UX live in spec.md — reference by B-id, never copy them here.
-->

---

## Behaviors

<!--
The WHAT this plan delivers — defined elsewhere, referenced here:
- Spec-fed: a single reference line to the locked spec, e.g. `→ spec.md B-001…B-007`. Do NOT copy.
- Standalone (no spec): the team-lead writes a lightweight Goal + inline B-NNN here —
  observable lines for test traceability; priorities optional. No UX, no Out-of-Scope ceremony.
-->

→ spec.md B-001…B-NNN

## Current State *(technical research — written by codebase-researcher)*

<!-- The technical landscape for building this: module/slice structure, data model, integration
points, patterns + platform subsystems to build on, constraints + migration landmines. Facts only,
every claim cited `file:line`. This is the architects' window into the code — they start here. -->

- 

## Data model *(BE — else omit)*

- Table `<name>`: `<col> <type>`, `<col> <type> NOT NULL`, … · FK `<…>` · index `<…>` (serves "<query>")
- *(uses tables owned by [yymmdd-slug] — reference, don't redefine)*

## Architecture

<!--
Decisions + the constitution/platform gate. 1 line each: the decision + its driver.
Name an EXISTING artifact when reuse is load-bearing ("reuse upload-dropzone as-is"); never
pre-name NEW files/components — the engineer owns naming (plan intent binds, naming is advisory).
⚠️ = a choice that needs YOUR call before /implement (new tool/library/subsystem, or a
constitution deviation) — give options + a recommendation. Any ⚠️ left open → Open Questions.

Platform (the constitution's platform/feature split):
- A NEW subsystem/wrapper → its own Platform task (T-9xx) + a paired platform test task, built and
  green before the BE/FE blocks. Test OUR wrapper, never the installed package. A NEW tool/library
  is ⚠️ (you decide). If it's big enough to blow this plan's budget, it should have been its OWN spec.
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

## Out of Scope *(optional — standalone plans; else lives in spec.md)*

<!-- Technical exclusions for a standalone run. Spec-fed plans leave this out — Out of Scope is in spec.md. -->

- [excluded thing]

## Assumptions *(optional — technical assumptions; product/scope ones live in spec.md)*

<!-- Architecture/environment assumptions this design rests on. Mark ⚠️ high-impact ones. -->

- ⚠️ [high-impact technical assumption — confirmed, or flagged unconfirmed]

## Open Questions *(gate — must be "None" before `/implement`)*

<!--
Park anything you can't decide. `/implement` refuses to start if this has entries.
Format: - **Q-NNN · [question]** — *Asked by*: [agent] · *Context*: [≤2 lines]
-->

None

## Tasks

<!--
Flat list, sized so ONE team builds this plan in one pass. Order: Platform (T-9xx) → BE (T-0xx) →
FE (T-1xx). The team builds each block and makes it green before the next; an engineer consuming a prior
block's contracts runs its domain's codegen/client-regen step (project-supplied) first. This table
IS the task ledger — the ONLY thing /implement mutates.

- Each row is a leaf: ONE coherent deliverable sized for a single agent session (a CRUD endpoint group;
  a page WITH its hooks + sub-components). Design detail (pipelines, wiring, copy) lives in Architecture —
  cross-reference it, never restate it here; new files stay unnamed (the engineer owns naming).
- Every leaf carries the four fields: **behavior** (the user-visible outcome + the B-NNN it delivers,
  never an implementation step) · **verification** (an executable command or concrete observable check,
  never prose like "works correctly") · **state** (the closed enum below) · **evidence** (append-only:
  commit hash + the reviewer-cited verification output).
- **state** ∈ `not_started | active | blocked | passing` (no other values exist). State semantics, WIP=1,
  and transition rules (who advances state, the evidence gate for `active → passing`, `blocked` reasons):
  see the task-ledger protocol — not restated here.
- One test leaf per block, owned by the test engineer (a fresh context) — NOT counted toward budget.
- Owner ∈ { platform, be-eng, be-test, fe-eng, fe-test }.
- Budget ≈ 3–5 engineering deliverables per stack. Over budget → it should have been a separate spec.
-->

| ID | Block | Behavior | Verification | Owner | State | Evidence |
|---|---|---|---|---|---|---|
| T-901 | Platform | [new wrapper/subsystem — only if needed] | [executable check] | platform | not_started | — |
| T-902 | Platform | Tests for the platform subsystem (our wrapper, not the package) | [test cmd → green] | be-test | not_started | — |
| T-001 | BE | [coherent BE deliverable] · B-001 | [executable check] | be-eng | not_started | — |
| T-002 | BE | Integration tests for the BE block · B-001, B-002 | [test cmd → green] | be-test | not_started | — |
| T-101 | FE | [page + hooks + components] · B-003 | [executable check] | fe-eng | not_started | — |
| T-102 | FE | Component tests for the FE block · B-003 | [test cmd → green] | fe-test | not_started | — |

## Contracts & wiring *(optional — omit by default; include only if the architect decides it adds value, e.g. a platform API surface)*

- `<METHOD> /<path>` — `<InBody> → <OutBody>` · [≤1 line on a non-obvious field]
- Hook `use<Thing>` → `apiClient.<module>.<call>()` · invalidates `['<key>']`

## Decision Log *(optional — non-obvious choices not already captured in Architecture)*

- **D-001** — [decision] · [driver] · [alternative rejected]

## Handoff *(written at Finalize by whichever command drives this ledger, per `vibe-task-ledger`)*

- **Verified now** — 
- **Changed this session** — 
- **Broken or unverified** — 
- **Next best step** — 
