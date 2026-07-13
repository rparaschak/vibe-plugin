# Migration Ledger — vibe → Harness Builder

**Plan:** `docs/migration-plan.md` | **Design:** `docs/harness-builder.md`
**Schema:** each leaf = `behavior / verification / state / evidence`. States: `not_started | active | blocked | passing`. `passing` is irreversible. WIP=1 for authoring (read-only scouts may run in parallel). Only the orchestrator flips states, citing evidence.

**Live progress:** this file is updated after every state change. Read top-to-bottom: Decision Log → Handoff → Phase tables.

---

## Decision Log

| # | Date | Decision | Reasoning | Rejected |
|---|---|---|---|---|
| D1 | 2026-07-13 | README engineer model aligned to **opus** (README currently says sonnet) | `agents/engineer.md` declares opus; commit 2d102dc shows the sonnet→opus change was deliberate | Reverting file to sonnet |
| D2 | 2026-07-13 | Ledger lives at `.workspace/migration/ledger.md`, committed | Not gitignored; user asked for visible progress file | docs/ location |
| D3 | 2026-07-13 | Model policy: scouts/cross-checkers = sonnet; authors/cold reviewers = opus; no fable | Per migration plan §2 orchestration table + standing constraint | — |
| D4 | 2026-07-13 | `distill.md` reclassified `shrink`→`rewrite`: user wrote it by hand, unsure it follows best practices; rewrite against course learning-loop practices (L10/L12: feedback promotion, mechanization ladder, golden rules) before adding the template-promotion rung | User instruction mid-migration; goal = effective learning flywheel | Porting user's version + patching rung on top |
| D5 | 2026-07-13 | WIP=1 scope in task-ledger = **per ledger**: parallel worktrees each carry their own ledger and their own single active leaf | Cold review flagged ambiguity; per-ledger matches vibe's existing `--worktree` isolation model | Global single active leaf (would forbid parallel worktree runs) |
| D6 | 2026-07-13 | Idle-teammate procedure in team-protocol = ORCH's sequence: re-ping once, THEN verify ground truth | Scout found CP:10 vs ORCH:21 contradiction; ORCH version is more actionable | CP's immediate-verify version |
| D7 | 2026-07-13 | User additions to scope: (a) per-component code-review checklists — already leaf 2.10 + build-harness gap rows, confirmed; (b) **architecture doc/skill per component** — NEW leaf 2.11; build-harness checklist must pre-seed one `<component>-architecture` skill row per detected component; (c) **deterministic environment scripts** — NEW leaf 2.12: `scripts/` templates for env-up + test-run, self-verifying (course P06 init.sh pattern), wrapped in an environment skill template; build-harness pre-seeds these rows; review-protocol's Pass 3 already runs verification "via the environment skill" so it plugs in directly | User instruction 2026-07-13 mid-Phase-1 | — |

## Handoff block

- **Verified now:** Phase 0 complete (bad6b8d). Phase 1: 1.1 task-ledger passing (65 lines), 1.2 research-protocol passing (verbatim, 28 lines), 1.3 team-protocol **passing** (70 lines; cold review Accept 10/12, all 9 contracts present; 4 polish fixes applied + grep-verified). 1.4 review-protocol **drafted** at 70 lines from its disposition (opus author, never saw source): all verbatim contracts confirmed by author; 3 rubric contradictions resolved (Accept = all 6 dims at 2 AND tests green; finding format what/why/fix, "no filler, no praise, no recap"; every finding names its dimension).
- **Broken / unverified:** 1.4 cold review not run (cross-check DONE: CLEAN, 0 high / 1 low — see leaf evidence). 1.5 workspace move not started.
- **Next best step (resume here):** (1) dispatch cold reviewer for `templates/kernel/review-protocol.md` (opus, fresh context; rubric complete/unambiguous/checkable/minimal/consistent-with-siblings/correct; verify verbatim contracts incl. "Supersession is the #1 source of false findings" + read-only stance opens AND closes file; ask it to judge the 1-low from cross-check: restore "you find issues and report them; the engineer fixes them" framing sentence or leave implicit); (2) apply fixes if Revise, flip 1.4; (3) then 1.5: move workspace-starter → templates/workspace + rewrite plan-template Tasks section to task-ledger schema (author from ledger kernel, not old CHECKLIST); (4) commit Phase 1 + real-task contact test; Phase 2 next (12 leaves incl. 2.11/2.12). Protocol: migration-plan.md §2 (orchestrator never authors/reviews/reads v1 sources; scouts+cross-checkers sonnet, authors+cold reviewers opus, no fable; WIP=1 authoring per ledger).

---

## Phase 0 — Prep & hygiene

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 0.1 | Pre-migration state tagged `v1-final-harness` | `git tag -l` shows tag | passing | tag at 0a078c4 |
| 0.2 | Target dirs exist; `SIMPLIFICATION-LOG.md` seeded with purpose statement | `ls` dirs; file exists | passing | dirs + SIMPLIFICATION-LOG.md created 2026-07-13 |
| 0.3 | README drift fixed: engineer=opus, command count correct, build-flow listed | scout re-audit finds zero drift vs repo files | passing | scout found 4 discrepancies; fixer applied all 4; grep verified README:62,72,147,151,246 |
| 0.4 | `standards/command-standard.md`: size budgets, constraint placement, template-header convention | cold review Accept; ≤120 lines | passing | authored 50→39 lines; cold review Revise 10/12 → 5 fixes applied → grep-verified; round log: 1 revise round |
| 0.5 | `standards/agent-standard.md`: description budget, role boundary, done-format, model/effort rules | cold review Accept; ≤120 lines | passing | authored 36→39 lines; cold review Revise 13/14 → 2 fixes applied → grep-verified (header rule, 9 Prevents clauses); round log: 1 revise round |

## Phase 1 — Kernel extraction

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 1.1 | `templates/kernel/task-ledger.md`: leaf schema, closed enum, WIP=1, evidence-gated transitions, stop conditions, round log, decision log + handoff, two-level verification | cold review Accept; within budget | passing | 65 lines; cold review Revise 10/12 (hostile-lawyer pass found 3 gate holes) → 5 fixes applied → grep-verified; decisions D5 recorded; round log: 1 revise round |
| 1.2 | `templates/kernel/research-protocol.md`: near-verbatim from skill (verbatim tag justified) | cross-check: no content lost; cold review Accept | passing | verbatim copy + v1 header; `diff` (header excluded) = identical; verbatim tag pre-justified in plan §2 Step 0 |
| 1.3 | `templates/kernel/team-protocol.md`: comm+orchestration merged, dupes killed, consolidation rule single-sourced | ≤70 lines; cross-check: no protocol lost; cold review Accept | passing | 70 lines; cross-check restored 2 losses; cold review **Accept 10/12**, all 9 contracts present; 4 polish findings (main↔lead naming, 3-sense "blocked" split, triple-stated no-paste rule, pronoun) applied + grep-verified; round log: 1 polish round |
| 1.4 | `templates/kernel/review-protocol.md`: three-pass + 0–2×6 rubric → Accept/Revise/Block + what/why/fix | cold review Accept | active | drafted 70 lines from disposition; cross-check vs source = **CLEAN (0 high, 1 low)** — all teeth verbatim; 1 low: "reviewer finds, engineer fixes" framing sentence dropped, substance survives (lines 10, 69) — have cold reviewer judge if restoring is worth a line; **cold review pending — dispatch it first on resume** |
| 1.5 | `templates/workspace/` populated from workspace-starter; plan-template Tasks section = ledger schema | files present; plan-template references closed enum | not_started | — |

## Phase 2 — Agent templates + checklists

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 2.1 | `templates/agents/architect.md` (consolidation-rule copy removed) | agent-standard audit pass; cold review Accept | not_started | — |
| 2.2 | `templates/agents/critic.md` (stance paragraph deleted) | audit pass; cold review Accept | not_started | — |
| 2.3 | `templates/agents/engineer.md` | audit pass; cold review Accept | not_started | — |
| 2.4 | `templates/agents/reviewer.md` (points at kernel review-protocol; mechanized-checks-first) | audit pass; cold review Accept | not_started | — |
| 2.5 | `templates/agents/test-engineer.md` | audit pass; cold review Accept | not_started | — |
| 2.6 | `templates/agents/qa-engineer.md` (manual-testing skill inlined; stance paragraph deleted) | audit pass; cold review Accept | not_started | — |
| 2.7 | `templates/agents/codebase-researcher.md` | audit pass; cold review Accept | not_started | — |
| 2.8 | `templates/agents/product-manager.md` | audit pass; cold review Accept | not_started | — |
| 2.9 | `templates/agents/product-designer.md` | audit pass; cold review Accept | not_started | — |
| 2.10 | `templates/checklists/`: review-generic + backend/frontend skeletons (per-component checklists per D7a) | files exist; cold review Accept | not_started | — |
| 2.11 | `templates/workspace/architecture-skill.md`: per-component architecture doc/skill template (D7b); build-harness pre-seeds one `<component>-architecture` row per detected component | template exists; cold review Accept | not_started | — |
| 2.12 | `templates/scripts/`: deterministic env-up + test-run script templates, self-verifying (D7c), + environment skill template that names them; agents never improvise env commands | templates exist; cold review Accept; review-protocol Pass 3 references resolve | not_started | — |

## Phase 3 — Skeletons + presets

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 3.1 | `templates/skeletons/command-skeleton.md`: fixed kernel sections, opt-out frontmatter, flow slot | cold review Accept | not_started | — |
| 3.2 | `templates/skeletons/flow-skeleton.md` | cold review Accept | not_started | — |
| 3.3 | `presets/plan-implement/{plan,implement}.md`: ledger-native; implement ≤80 lines | `wc -l` ≤80; cross-check vs old files; cold review Accept | not_started | — |
| 3.4 | `presets/spec-plan-implement/{spec,plan,implement}.md` | cold review Accept | not_started | — |
| 3.5 | Dry-run: one preset driven by hand on a toy task in this repo | ledger loop + clean-state gate executable | not_started | — |

## Phase 4 — Builder commands

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 4.1 | `commands/build-harness.md`: parse→audit→checklist→build pipeline + doctor mode | cold review Accept; obeys command-standard | not_started | — |
| 4.2 | `commands/build-flow.md` repointed: generates into project; LLM-judged validation removed | cold review Accept | not_started | — |
| 4.3 | `commands/distill.md`: **rewritten** around course learning-flywheel practices (dedicated scout on L10/L12 first), then template-promotion rung added (see D4) | scout report on file; cold review Accept | not_started | — |
| 4.4 | Self-test: build-harness run on scratch project; doctor re-run idempotent | checklist created; stamp works; 2nd run all-OK | not_started | — |

## Phase 5 — Live validation (user gate)

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 5.1 | Handover: stamped harness instructions for tech backend (plan-implement) + fullstack app (spec-plan-implement) | user runs real feature on each; monorepo hand-copy retired | not_started | — |

## Phase 6 — Deprecation & cleanup (gated on 5.1)

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 6.1 | Old commands + skills + CHECKLIST.md + workspace-starter deleted | migration-log lookup confirms every instruction dispositioned | not_started | — |
| 6.2 | README rewritten for vibe 2.0 | fresh-session scout answers what/how from README alone | not_started | — |
| 6.3 | plugin.json → 2.0.0 | file diff | not_started | — |
| 6.4 | SIMPLIFICATION-LOG first entry (constraints deleted in migration) | entry present | not_started | — |
| 6.5 | Final verify: `find commands -type f | wc -l` = 3 | command output | not_started | — |
