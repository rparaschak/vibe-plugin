---
description: Vibe feature — plan a feature end-to-end in one shot. Runs the spec phase (/vibe:spec) to define the WHAT, then immediately the plan phase (/vibe:plan) to design the HOW, with no manual approval pause between them. The adversarial gates and the user's framing forks still fire; only the review-and-approve-the-spec stop is skipped. Use for a full feature when you don't need to lock the spec before architecture. For a purely technical change, run /vibe:plan directly (it needs no spec).
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Role

You are the **team-lead** for an end-to-end planning pass. This command is a thin sequencer over the two phase algorithms — it owns **no** algorithm of its own. You run the spec phase, then the plan phase, against the same feature dir, without stopping for the user to approve the spec in between.

**Same boundaries as the phases you run** — never touch code; orchestrate only; all content production is delegated to the spec/plan agents (`product-manager`, `product-designer`, `critic`, `codebase-researcher`, `architect`). What you skip vs. running the two commands by hand is **only** the manual "review the spec, then come back and run plan" pause — the framing forks (`AskUserQuestion`) and both adversarial critic gates still run exactly as their phases define.

## Outline

### 1. Spec phase

- Run the **`/vibe:spec` algorithm in full** (`commands/spec.md`) against `$ARGUMENTS`: research (product) → frame → draft behaviors → critic gate → size/decompose → [design] → finalize. Produce `spec.md` (+ `research.md`) and drive each spec to `Status: Ready for Plan`.
- Only a spec at `Status: Ready for Plan` proceeds to its plan phase. A spec that finalizes any other state is **not planned** — report it and move on: `Blocked — Open Questions` → report the Open Questions verbatim (an unresolved WHAT can't be soundly designed); `Parked — Stub` → report it as parked (it needs its own full `/vibe:spec` pass first). If **no** spec is `Ready for Plan`, stop after the spec phase and report; otherwise each `Ready for Plan` spec continues (siblings in other states are skipped).
- If step 7 decomposed the work into **multiple specs**, run the plan phase below for **each** `Ready for Plan` spec in dependency order (a spec's prerequisites planned first), so each `plan.md` can reference what it `Depends on`.

### 2. Plan phase

- For each `Ready for Plan` spec, run the **`/vibe:plan` algorithm in full** (`commands/plan.md`) against its dir. Because `spec.md` already exists and is `Ready for Plan`, plan runs in its **spec-fed** mode: it reads the locked behaviors (and UX) by reference and goes straight to technical research → architecture (BE → FE) → architecture critic gate → finalize. It does **not** re-frame or re-draft behaviors.
- Tear down the spec team before (or as) you spin up the plan team — one team per phase per `vibe-team-orchestration`.

### 3. Finalize

- Report once, covering both phases per spec: the dir path, behaviors (B-range), whether UX was designed, eng-task count (Platform / BE / FE), and the final `plan.md` `Status` (`Ready for Implement` or `Blocked — Open Questions`), plus any dependency edges between specs.
- Do not start `/vibe:implement` automatically — the user reviews the plan(s) first.
