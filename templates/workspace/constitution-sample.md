<!-- vibe-template: templates/workspace/constitution-sample.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Constitution

> **Starter file — adapt to your project.** This ships with the `vibe` plugin as a starting point.
> The vibe harness binds to the **concepts** in your constitution — the platform-vs-feature split, the
> test/QA gates, the build-clean gate — **not** to specific article numbers. Number and structure this
> file however you like; just keep those concepts stated somewhere a plan's Constitution line can cite.
> Replace the stack-specific wording below (paths, commands, tools) with your project's reality.

Non-negotiable rules for this project. Loaded by every vibe phase. Gated explicitly by `/plan` — any violation must be justified on the plan's `## Architecture` Constitution line (⚠️ + why), otherwise the plan is incomplete.

Keep this file small. Add an article only when the rule has been violated more than once or has a clear principled reason.

---

## I. [Project-specific simplicity rule — example, replace me]

State the one assumption that lets your code stay simple, and the patterns it forbids. Example for a low-traffic admin tool:

> This is a 1–2 user admin panel. Do not write code that defends against contention — no explicit transactions, no row locks, no pre-mutation existence checks. Let datastore constraints and not-found errors flow through the error-translation layer.

**Why:** an explicit simplicity assumption prevents speculative complexity that the actual load never justifies.

## II. Vertical slices

Each feature is a self-contained slice (e.g. under `api/internal/<module>/<slice>/`). No shared service layer across slices. Cross-slice reuse goes through small explicit interfaces or graduates to a shared platform package (e.g. `pkg/`).

**Why:** slices stay independently readable and changeable; a shared service layer becomes a tangled chokepoint.

## III. Generated API client on the frontend

The frontend calls the backend through the generated API client (e.g. under `web/src/api/`). Never hand-write fetches against backend endpoints.

**Why:** a generated client keeps the frontend in lockstep with backend contracts; hand-written fetches drift silently.

## IV. Real dependencies in tests

Integration tests hit real backing services — a real database, real object storage — not mocks at the storage boundary. Unit tests for pure logic are fine; anything touching a datastore goes through the real driver.

**Why:** mocks at the storage boundary pass while the real query/schema is wrong.

## V. Platform vs Feature separation

**Platform** = subsystems that power features (database, events, scheduled jobs, auth, storage). Lives in shared packages (e.g. `api/pkg/` and `web/src/lib/`). Encapsulates complexity behind a small, stable API so feature slices stay readable.

**Feature** = a vertical slice that solves a user-visible problem. Composes platform APIs; never reimplements them inline.

Rules:

- If a slice needs a capability the platform doesn't expose, the architect **must** flag it on the plan's `## Architecture` as a ⚠️ entry (and park it in `## Open Questions`), list implementation options, and pause for user verification before proceeding.
- **Extending an existing subsystem** (new method, new field, new event type) — architect decides.
- **Tool choice or architectural change** (new library, new subsystem, new pattern, breaking API change) — architect proposes, user decides.
- A feature slice never reaches across to another feature slice. Shared logic graduates to platform.

**Why:** features get rewritten; platform shouldn't. Mixing them produces tangled slices and frozen platform decisions. Pulling platform changes into a human-approved gate keeps the surface deliberate.

## VI. A plan is not done until tests run on a migrated real environment

Article IV says tests hit real services. This article makes it an acceptance gate: backend work **cannot be marked Implemented / done** unless, on a clean checkout, the **real environment** (a migrated database, object storage, etc.) can be spawned with **one command**, **all migrations apply**, and the check suite then passes.

- The migration applier, the schema-diff entrypoint, and the server entrypoint are required source — never let `.gitignore` shadow them.
- If the environment cannot be spawned or migrations cannot be applied, the job is **blocked, not done** — say so explicitly; do not claim green from a build/vet alone.
- "Migrations are fine" means: they apply cleanly from scratch **and** match the code's entities (no drift).

**Why:** the expensive failures come from shipping schema/code that was never exercised against a migrated, real environment. Running it is the only proof.

## VII. A plan is not complete until tests ran and QA checked the result

Writing tests is not running them; a green build is not a passing suite. A plan **cannot be marked Implemented / done** unless, for every block:

- its automated tests were **actually executed and observed green** — backend integration, frontend component, **and** the Playwright E2E specs via `make api-run` + `make web-run` (backgrounded) + `make e2e` (not merely authored and lint-clean); and
- a human-style **manual QA** click-through of the plan's user-facing Behaviors was performed against the running app and passed.

If the environment can't run them, that is **blocked, not done** — only if it genuinely cannot run does the plan stay `Blocked`, said so explicitly. Specs that were written but never executed, or behaviors never clicked through, do **not** count toward completion.

**Why:** "tests exist" and "tests pass" are different claims; shipping on the first is how a broken seed or dead flow reaches a user unnoticed. Completion means the result was observed, not assumed.

## VIII. Every project must build

A plan touching a project **cannot be marked Implemented / done** unless that project builds clean: `api` via `make build-api`, `web` via `make build-web` (whole-project type-check **including test files**, plus the production bundle — not just the unit-test runner). A broken build is **blocked, not done**.

- The build is **necessary, not sufficient** — it never substitutes for the test/E2E/QA gates above (Articles VI–VII). It is the floor, not the proof.
- Type-check the **whole** project, including test files — a passing unit-test run does not mean the full type-check passes (test-only type errors fail the build but not the suite).

**Why:** the full build type-checks code that the unit-test runner skips; shipping a green suite while the production build is red is how a type error reaches deploy time.

---

**Adding an article:** propose it on a plan's `## Architecture` or as a separate PR. Articles should be short (≤10 lines), state the rule, and explain WHY in one sentence.
