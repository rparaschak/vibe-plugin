<!-- vibe-template: templates/workspace/plan-template.md v1 | generated 2026-07-14 | edits below this marker are yours -->

# Plan: Add --shout flag to greet CLI

**Created**: 2026-07-14   **Status**: Implemented
**Depends on**: —
**Input**: "add a --shout flag to the greet CLI (uppercase the greeting)"

<!--
The HOW for one feature: Current State, Data model, Architecture, Tasks, Test behaviors.
The WHAT — Problem, Behaviors (B-NNN), UX — lives in this dir's spec.md (produced by /vibe:spec,
this command's companion). This plan references behaviors by id; it never restates them. Spec and plan
are SEPARATE documents. (For a purely technical run with no spec, the Behaviors section below is
filled inline with a lightweight Goal + B-NNN — see its note.)

A plan is sized for ONE team to build in one pass: roughly one coherent capability per stack
(~3–5 engineering deliverables; test tasks don't count). Sizing/decomposition is /vibe:spec's job —
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

**Goal**: users can pass a `--shout` flag to the greet CLI to get the greeting uppercased; default (no flag) behavior is unchanged.

- **B-001** — `--shout` present with a name → greeting prints uppercased (`node src/greet.js Ada --shout` → `HELLO, ADA!`).
- **B-002** — `--shout` present with no name → stranger greeting prints uppercased (`node src/greet.js --shout` → `HELLO, STRANGER!`).
- **B-003** — `--shout` absent → greeting prints exactly as today, unchanged case (`node src/greet.js Ada` → `Hello, Ada!`).
- **B-004** — `--shout` accepted regardless of argument order relative to the name (`node src/greet.js --shout Ada` behaves the same as `node src/greet.js Ada --shout`).

## Current State *(technical research — written by codebase-researcher)*

<!-- The technical landscape for building this: module/slice structure, data model, integration
points, patterns + platform subsystems to build on, constraints + migration landmines. Facts only,
every claim cited `file:line`. This is the architects' window into the code — they start here. -->

- Single-file component: `src/greet.js` exports `greet(name)` (`src/greet.js:3-8`) and has a `require.main === module` CLI guard that calls `console.log(greet(process.argv[2]))` (`src/greet.js:12-14`). Per `.claude/skills/backend-architecture/SKILL.md` (Data flow), this is the entire pipeline: `process.argv[2]` → `greet(name)` → `console.log`, no handler/usecase/persistence layers.
- `greet(name)` signature takes exactly one positional arg; case logic is internal — `name.trim() === ''` (or non-string) returns `'Hello, stranger!'` (`src/greet.js:4-5`), else returns `` `Hello, ${name.trim()}!` `` (`src/greet.js:7`). No second parameter or options object exists today.
- **No argument-parsing layer at all.** `process.argv[2]` is read positionally and passed straight through (`src/greet.js:13`) — no flag/option parser (no `minimist`/`yargs`/`commander`/manual `argv` loop) exists anywhere in the repo. A `--shout` flag needs its own hand-rolled parsing; there is no existing pattern to reuse for flag detection, only the bare positional read.
- `package.json` declares zero dependencies and no `devDependencies` (`package.json:1-10`) — confirms `.claude/skills/backend-architecture/SKILL.md` (Integration points: "no external service... zero dependencies"). Adding a CLI-parsing library would be a new dependency, not an extension.
- `package.json` has a `main` field (`src/greet.js`, `package.json:5`) but **no `bin` field** — contradicts the architecture skill's "Where things go" note that "`package.json`'s `main` and `bin` fields are the only wiring point" (`.claude/skills/backend-architecture/SKILL.md`); in practice only `main` is wired, invocation is `node src/greet.js <name>` (per plan Behaviors B-001…B-004), not a linked `bin` command.
- Test file `test/greet.test.js` uses `node:test` + `node:assert`, requires `{ greet }` from `../src/greet` (`test/greet.test.js:3-5`) and asserts on the return value of `greet()` directly — it never spawns the CLI as a subprocess, so existing tests only exercise the exported function, not `process.argv` or console output.
- Two existing tests cover: named user → `'Hello, Ada!'` (`test/greet.test.js:7-9`) and empty/missing name → `'Hello, stranger!'` (`test/greet.test.js:11-13`). No test currently touches CLI flags, `process.argv`, or stdout capture.
- `package.json`'s `test` script is `node --test test/*.test.js` (`package.json:7`) — any new test file matching `test/*.test.js` is picked up automatically, no registration step needed.
- Per `.claude/skills/backend-architecture/SKILL.md` (Where things go / Naming conventions), new CLI behavior is expected as a **new** `src/<verb>.js` file mirroring `greet.js`'s shape (pure function + CLI guard); this feature instead **extends** the existing `greet.js`/`greet()` rather than adding a new file, since `--shout` modifies the same greeting output rather than introducing a new command — no precedent in the skill covers extending vs. adding new for a flag on an existing command.
- No `.workspace/learnings.md` and no prior plans exist in `.workspace/plans/` (only this plan's own dir) — no rejected decisions or env traps on record for this feature.

## Data model *(BE — else omit)*

- Omitted — no data store; the component is a pure function + CLI wrapper (see `## Current State`).

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
  is ⚠️ (you decide). If it's big enough to blow this plan's budget, it should have been its OWN spec.
- A small EXTENSION of an existing subsystem (new method/field/event) → fold inline into the BE/FE
  task that needs it; no separate task, architect decides.
-->

### BE *(architect — backend)*

- Extend the existing `greet()` in `src/greet.js` with an optional second options argument (shout flag, default off) — `--shout` modifies the same greeting output, so extend-in-place beats a new `src/<verb>.js` command file (see D-001); keeps the pure-function-plus-CLI-guard shape mandated by `.claude/skills/backend-architecture/SKILL.md` (Exemplar files).
- Uppercase inside `greet()` (applied to the full returned greeting), not in the CLI guard — keeps case logic in the pure function so unit tests assert on return values, matching the existing test pattern (`test/greet.test.js:7-13`).
- Hand-roll flag detection in the existing `require.main === module` guard: scan `process.argv.slice(2)`, treat `--shout` at any position as the flag (B-004), pass the first non-flag arg as `name` — no parsing library, preserving the zero-dependency stance (`package.json:1-10`); not ⚠️ — small extension of an existing subsystem, architect decides (Constitution V).
- Existing calls `greet(name)` stay valid — options arg defaults to no-shout, so B-003 (unchanged default) holds with no change to current tests.
- **Constitution**: ✅ all clear — no new tool/library/subsystem (V), no datastore so IV/VI vacuous; tests run via `./.claude/scripts/test-run.sh` and must be observed green before done (VII).

## Test behaviors

<!-- Inventory the implement-phase test engineers write against the built code. Each cites a behavior. -->

### BE *(architect — backend)*

- Unit: `greet` with shout option on returns fully uppercased named greeting · B-001
- Unit: `greet` with shout option on and empty/missing name returns uppercased stranger greeting · B-002
- Unit: `greet` without the shout option returns exactly today's mixed-case output (named + stranger) · B-003
- CLI (subprocess, `node src/greet.js …`, assert stdout): `Ada --shout` → `HELLO, ADA!` · B-001
- CLI (subprocess): `--shout` alone → `HELLO, STRANGER!` · B-002
- CLI (subprocess): `Ada` (no flag) → `Hello, Ada!` unchanged · B-003
- CLI (subprocess): `--shout Ada` and `Ada --shout` each print exactly `HELLO, ADA!` (expected literal pinned in both orders — order-equivalence alone would pass on a shared wrong string) · B-004

## Out of Scope *(optional — standalone plans; else lives in spec.md)*

- No general flag-parsing framework, no other flags (`--help`, `--version`, short `-s` alias), no unknown-flag error handling.
- No `bin` field / linked command in `package.json` — invocation stays `node src/greet.js` (see `## Current State`).

## Assumptions *(optional — technical assumptions; product/scope ones live in spec.md)*

- `--shout` uppercases the entire greeting (`HELLO, ADA!`), not just the name — confirmed by B-001/B-002 examples.
- Only one positional (the name) exists; any arg other than `--shout` is treated as the name — extra positionals stay undefined behavior, as today (`src/greet.js:13`).

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
IS the task ledger — the ONLY thing /vibe:implement mutates.

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
| T-001 | BE | `--shout` flag uppercases the greeting, any arg order; default output unchanged; same change updates `.claude/skills/backend-architecture/SKILL.md` (Data flow + `greet` signature) per D-002 · B-001, B-002, B-003, B-004 | `node src/greet.js Ada --shout` → `HELLO, ADA!`; `node src/greet.js --shout Ada` → `HELLO, ADA!`; `node src/greet.js --shout` → `HELLO, STRANGER!`; `node src/greet.js Ada` → `Hello, Ada!`; `.claude/skills/backend-architecture/SKILL.md` Data flow describes the flag scan + new `greet` signature | be-eng | passing | 07bc48e; reviewer Accept (rubric 12/12): all four CLI verification commands executed by reviewer matched the plan literally (`HELLO, ADA!` ×2, `HELLO, STRANGER!`, `Hello, Ada!`); `backend-architecture` SKILL.md Data flow + signature verified updated per D-002 |
| T-002 | BE | Tests for the shout behaviors (unit + CLI subprocess, per `## Test behaviors` BE) · B-001, B-002, B-003, B-004 | `./.claude/scripts/test-run.sh` → all tests green | be-test | passing | 07bc48e; reviewer Accept (rubric 12/12): `./.claude/scripts/test-run.sh all` → 12/12 pass, 0 fail (integration/e2e layers (none)); all 7 plan Test behaviors present incl. B-004 pinned-both-orders literal |

## Contracts & wiring *(optional — omit by default; include only if the architect decides it adds value, e.g. a platform API surface)*

- `greet(name, options?) → string` — options carries the shout switch, defaults to off; exact option shape/name is the engineer's call. Existing `greet(name)` call sites and tests stay valid.

## Decision Log *(optional — non-obvious choices not already captured in Architecture)*

- **D-001** — Extend `src/greet.js` in place rather than add a new `src/<verb>.js` · `--shout` is a modifier on the existing greet command, not new CLI behavior · rejected: new command file per `.claude/skills/backend-architecture/SKILL.md` (Where things go) — that rule targets new commands; no precedent covers flags on an existing one (noted in `## Current State`).
- **D-002** — Treat the flag as structural: the changed data flow (`argv.slice(2)` scan) and `greet(name, options?)` signature must land in `.claude/skills/backend-architecture/SKILL.md` in the same change (skill's own same-PR rule, `SKILL.md:10`); folded into T-001's scope, edited at implement time · rejected: separate doc task (too small) or skipping the update (authority goes stale).
- **D-003** *(implement, 2026-07-14)* — T-002 advanced `not_started → passing` without an `active` interval: the command reviews each closed leaf against the single block commit, so under WIP=1 only T-001 held `active` while the test-engineer authored T-002; both leaves gated on the same reviewer Accept citing `07bc48e` · rejected: marking T-002 `active` concurrently (violates WIP=1) or per-leaf commits+reviews (contradicts the command's per-block commit rule).

## Handoff *(orchestrator — written at implement finalize)*

- **Verified now** — plan Implemented: T-001 + T-002 `passing` on reviewer Accept (rubric 12/12) citing commit `07bc48e`; clean-state exit gate observed green 2026-07-14 — `./.claude/scripts/test-run.sh all` → 12 tests, 12 pass, 0 fail (integration/e2e `(none)`, exit 0, incl. the 2 pre-existing tests); all four T-001 CLI verification commands matched the plan literally (reviewer-run and lead-gated); `env-up.sh` → "environment ready"; B-001…B-004 delivered.
- **Changed this session** — `src/greet.js` (`greet(name, options?)` with shout option; CLI guard argv scan), `test/greet.test.js` (+7 behaviour tests, existing 2 untouched), `.claude/skills/backend-architecture/SKILL.md` (Data flow + signature per D-002) — all in block commit `07bc48e`; ledger states/evidence, D-003, this Handoff, and `learnings.md` in the finalize commit.
- **Broken or unverified** — nothing. No lint/build command exists in this project (zero-dependency CLI) — reported as not run per `backend-review`, not a gap. Harness files under `.claude/`/`.workspace/` outside this plan dir remain untracked, as they were before this run.
- **Next best step** — user reviews the implemented feature (`node src/greet.js Ada --shout`); no dependent plans queued.
