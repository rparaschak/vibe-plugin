# Harness Improvement Plan for vibe

**Sources:** [Learn Harness Engineering](https://walkinglabs.github.io/learn-harness-engineering/en/) (13 lectures, 7 projects, template library) and its [repo](https://github.com/walkinglabs/learn-harness-engineering) (canonical templates, SOPs, a progressive 6-stage reference implementation).
**Date:** 2026-07-13

---

## 1. Executive summary

The course and vibe agree on the fundamentals — role separation, file-based state, context discipline, evidence-gated completion. The course's empirical data *validates* vibe's core architecture (their P05 experiment: single agent scored 1.6/5, generator+evaluator 3.3/5, planner+generator+evaluator 4.9/5 on identical scope — exactly vibe's architect→engineer→reviewer pipeline).

Where the course is ahead of us is **mechanization**: they turn every soft convention into a machine-checkable artifact — verification commands per task, state machines with harness-controlled transitions, numeric stop conditions, executable architecture checks, self-verifying init scripts. vibe currently enforces almost everything through instruction prose, which our own weaknesses list already identifies as the brittleness ("a single agent misbehaving has no structural safety net beyond another instruction").

**The single biggest idea to steal:** *evidence-gated state transitions on a machine-readable task list.* Everything else (clean-state gates, stop conditions, rubrics) hangs off that spine.

---

## 2. What the course validates — keep as is

| vibe design | Course confirmation |
|---|---|
| architect / engineer / reviewer separation, reviewer read-only | P05: plan-gen-eval scored 4.9/5 vs 1.6/5 single-role. Lecture 9/13: "someone in your crew must not believe you" — self-evaluation is structurally biased. |
| State in `.workspace/` markdown, not chat | Lecture 13: external state is the foundational loop primitive; "memory must live on disk, not the context window." |
| Team-lead never reads code; scouts/researchers do | Lecture 4/5: context budget is the scarce resource; orchestrator context must stay clean. |
| "Implemented" gated on *executed* green tests with a `**Verified**` line | Lecture 9's verification gap — vibe already has the right instinct. |
| `--worktree` isolation for parallel runs | Lecture 13 names worktrees one of the six loop primitives. |
| `/vibe:distill` mechanize→skill→constitution ladder | Lecture 10/12 ("review-feedback promotion," OpenAI golden rules) prescribe exactly this. Ours predates reading theirs — good sign. |
| Spec (WHAT) split from plan (HOW) | Lecture 11's Planner role: spec-level only, no implementation detail. |

---

## 3. Adopt — prioritized

### P1 — Task schema with verification + evidence (Lectures 7, 8; `feature_list.json` template)

**What:** Upgrade the plan's Tasks table so every task carries four fields: `behavior` (user-visible outcome), `verification` (executable command(s) or observable steps), `state` (strict enum: `not_started | active | blocked | passing`), `evidence` (append-only: commit hash + test output reference). Keep it markdown (fits our tooling), but make the columns mandatory and the enum closed.

**Why:** This is the course's load-bearing primitive. Their data: structured feature lists → 45% higher completion, zero duplicate implementations, 60–80% less startup diagnostic time. It converts our "done means genuinely-executed green tests" from an instruction the engineer must remember into a field the team-lead can check.

**Rules to encode with it:**
- Only the **team-lead** flips `active → passing`, and only after the reviewer's verdict cites the evidence. The engineer never marks its own work passing (Lecture 9).
- `passing` is irreversible except by explicit user/team-lead decision.

**Touches:** `plan.md` command (task-table format), `implement.md` (gating logic), `architect.md` (must author verification per task), `reviewer.md` (must cite evidence).

### P2 — WIP=1 + numeric stop conditions in the implement loop (Lectures 7, 13; `goal-template.md`, `loop-state-template.md`)

**What:** Make `/vibe:implement` dispatch **one task at a time** explicitly (WIP=1), with a hard "no also-fixing adjacent items" rule in the engineer brief. Add numeric stop conditions to the fix→re-review cycle: max rounds (we cap at 3-ish informally — make it a stated constant), **no-progress detection** (same findings two rounds running → stop, escalate via andon cord), and a compact round log (round #, what engineer did, review verdict, next action).

**Why:** Their WIP=1 experiment: 87.5% vs 37.5% feature completion; LOC generated correlates *negatively* with completion. And their loop templates have the one thing our review cycle lacks: convergence detection. Today a stuck engineer↔reviewer loop only ends by hitting the retry cap; detecting "no progress" one round earlier saves an expensive opus round-trip.

**Touches:** `implement.md`, `vibe-team-orchestration` skill.

### P3 — Clean-state exit gate (Lecture 12; `clean-state-checklist.md`)

**What:** Add a mandatory end-of-block/end-of-run gate to `/vibe:implement`, checked by the team-lead before declaring done: (1) build passes, (2) all tests pass *including pre-existing*, (3) task states in plan.md accurate, (4) no stale artifacts (debug logs, commented code, leftover `console.log`/TODOs from this run), (5) standard startup path still works. Items 1/2/5 verified by command output, not agent claim.

**Why:** Their 12-week decay data without cleanup gates: build success 100%→68%, startup time 5min→60min+. vibe has teardown discipline for *agents* but no hygiene gate for the *code state* left behind. This is also exactly what makes a follow-up `/vibe:implement` run cheap to start.

**Touches:** `implement.md`; the checklist itself becomes part of the plan template so reviewers see it.

### P4 — Rubric + what/why/fix format for reviews (Lectures 10, 11; `evaluator-rubric.md`, `checker-prompt.md`)

**What:** Give the reviewer a structured verdict format: score 0–2 on ~6 fixed dimensions (correctness, verification, scope discipline, reliability, maintainability, handoff readiness) → verdict `Accept / Revise / Block` → required follow-ups. Every finding must be three-part: **what** (file:line), **why** (rationale), **fix** (concrete correction). Adopt their Checker framing: "not finding problems is your failure."

**Why:** Graded rubrics prevent the observed failure where evaluators "talk themselves into dismissing issues"; the what/why/fix format is what lets the engineer repair without a second diagnostic round-trip. This layers cleanly onto our existing three-pass review method — it changes the *output contract*, not the method.

**Touches:** `reviewer.md`, `vibe-review-discipline` skill, review-dispatch section of `implement.md`.

### P5 — Session continuity artifacts: decision log + handoff (Lecture 5; `session-handoff.md` template)

**What:** Two additions to the `.workspace/plans/<slug>/` bundle:
- A **Decision Log** section in plan.md (or `decisions.md` if it grows): timestamp, decision, reasoning, rejected alternatives. Engineers append when they deviate from the plan; the team-lead reads it on resume.
- A lightweight **handoff block** the team-lead writes when pausing a run: Verified Now / Changed This Session / Broken or Unverified / Next Best Step.

**Why:** Prevents "decision divergence" — a resumed session re-litigating and reversing settled choices (their measured cost: 30–50% of session time re-diagnosing state). Our Tasks-table resume covers *what*; it doesn't cover *why*, which is what gets re-litigated.

**Touches:** `plan.md` template, `implement.md` (clock-in reads it, clock-out writes it), `engineer.md`.

### P6 — Mechanize project constraints; ship a harness doctor (Lectures 10, 12; P04's `check-architecture.sh`, P06's self-verifying `init.sh`)

**What:** Two related moves:
- `/vibe:distill`'s "mechanize" rung gets teeth: recurring review findings should preferentially become **executable checks** (grep/lint scripts, e.g. architecture-boundary checks) that the reviewer runs *before* prose review. Encourage `/vibe:plan` to express hard constraints as runnable checks in the plan, not MUST-prose alone.
- Add a **harness self-check** (natural home: `/vibe:adopt`, possibly a `/vibe:doctor` alias): loop over required artifacts/skills from `CHECKLIST.md`, report OK/MISSING per item, and run the "fresh session test" — can a scout agent, from repo contents alone, answer *what is this / how to run / how to verify / what's unfinished*? This turns adopt's current LLM-judgment-only validation (a known weakness) into a checkable gate.

**Why:** Executable checks are cheaper and more reliable than opus re-flagging the same violation every review; their P06 `init.sh` self-verification is the pattern for making adoption gaps visible mechanically.

**Touches:** `distill.md`, `adopt.md`, `reviewer.md`, `CHECKLIST.md`.

### P7 — Apply Lecture 4 to vibe itself: prompt calibration + simplification log

**What:** Audit our own instruction surface with their rules: entry files 50–200 lines, hard constraints at top/bottom (never the middle), detail pushed into on-demand skill docs (we already do this — enforce the size budget), and each rule annotated mentally with *source / applicability / expiry*. Add a **Simplification Log** (their `QUALITY_SCORE.md` pattern): when a constraint exists only to compensate for a weaker model, periodically disable it and observe — if quality holds, delete it and log the removal.

**Why:** `implement.md` is 174 lines of dense procedural prose — our own noted brittleness, and the exact decay curve Lecture 4 documents (rule at line 300 ignored 40% of the time; refactor to 80-line entry + topic docs raised success 45%→72%). The simplification log matters because models improve: Anthropic's own team removed a sprint-splitting mechanism once the model could self-decompose, gaining 2+ hours of continuous work.

**Touches:** all `commands/*.md` and `agents/*.md` (audit pass); a `SIMPLIFICATION-LOG.md` in-repo.

### P8 — Repo hygiene fixes surfaced during this review

Not from the course, but confirmed drift that undermines the harness-of-the-harness:
- README says `engineer` is `(sonnet, high)`; `agents/engineer.md` declares `opus`. Reconcile (decide which is intended — all-opus is expensive).
- `/vibe:build-flow` exists but is absent from README's command inventory ("6 commands").
- Hardcoded Platform→BE→FE block order lives in `implement.md` despite domain-generic agents — move block order into the plan document (architect decides per-plan), so new domains don't require editing command files.

---

## 4. Considered and NOT adopting — and why

- **JSON state files (`feature_list.json`)** — we keep markdown tables. Our agents and users read/diff plan.md constantly; the win is the *schema and closed state enum*, not the serialization. Revisit only if we ever add programmatic tooling over task state.
- **OpenTelemetry runtime traces (Lecture 11)** — heavyweight for a prompt-orchestration plugin with no daemon. Our observability layer is the round log (P2) + evidence fields (P1); same intent, right weight.
- **High-throughput merge philosophy (Lecture 12)** — explicitly flagged by the author as "irresponsible in low-throughput environments." That's us.
- **Timer/cron loops and fleet orchestration (Lecture 13, L4–L5 maturity)** — out of scope for the plugin's core. A `/vibe:goal` autonomous wrapper around implement (goal + machine-checkable stop condition + independent verifier) is a plausible *future* command once P1–P3 exist — it depends on machine-checkable task state, so it can't come first.
- **Dedicated initializer agent / init.sh scaffolding (Lecture 6)** — `/vibe:adopt` already owns this ground. We take the *readiness gate* idea (P6's fresh-session test) rather than adding a parallel init phase.
- **Their AGENTS.md/CLAUDE.md templates** — consuming projects' root files are the project's business; vibe's CHECKLIST.md contract already points there. We adopt their *content rules* (P7), not their files.

---

## 5. Suggested sequencing

| Phase | Items | Rationale |
|---|---|---|
| 1 — spine | P1, P2 | Task schema + WIP=1/stop conditions change the data model everything else gates on. Do together; both touch `implement.md`. |
| 2 — gates | P3, P4 | Clean-state exit and rubric reviews plug into the Phase-1 state machine. |
| 3 — continuity & mechanization | P5, P6 | Decision log/handoff and executable checks; independent of each other. |
| 4 — self-maintenance | P7, P8 | Prompt-calibration audit is best done *after* Phases 1–3 rewrite the files anyway. |

Each phase is a small, reviewable diff to `commands/` + `agents/` + `skills/` — and per Lecture 12's audit discipline, after each phase we should use the plugin on a real task before starting the next.

---

## 6. Further reading (from the course's curated library)

The three "backbone" articles behind the whole course, worth reading first-hand:
1. Anthropic — *Effective harnesses for long-running agents* (2025-11) — origin of feature lists + progress logs.
2. Anthropic — *Harness design for long-running application development* (2026-03) — planner/generator/evaluator, harness simplification.
3. OpenAI — *Harness engineering: leveraging Codex in an agent-first world* (2026-02) — agent-first repo layout, structural guardrails.

Also directly reusable from their repo: `resources/templates/` (evaluator-rubric, clean-state-checklist, session-handoff), `resources/reference/method-map.md` (failure-mode → artifact map), and lecture-13's `maker-prompt.md`/`checker-prompt.md`/`goal-template.md`.
