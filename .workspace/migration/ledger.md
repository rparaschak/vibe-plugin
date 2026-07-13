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
| D8 | 2026-07-13 | `vibe-critique` skill INLINED into `templates/agents/critic.md` (target layout has no `templates/skills/`; v1 consumers plan.md/spec.md are replaced by presets that dispatch the critic agent, leaving critic sole consumer — same precedent as qa-engineer's manual-testing inline). Critic scout's "now-in-skill-vibe-critique" rows re-route to the agent file. If content can't fit ≤70 lines, author andon-cords rather than cramming | Plan §1 layout is authoritative; single-consumer skills inline per Phase 2 mandate | Creating a templates/skills/ dir (unplanned); leaving methodology unstamped |
| D7 | 2026-07-13 | User additions to scope: (a) per-component code-review checklists — already leaf 2.10 + build-harness gap rows, confirmed; (b) **architecture doc/skill per component** — NEW leaf 2.11; build-harness checklist must pre-seed one `<component>-architecture` skill row per detected component; (c) **deterministic environment scripts** — NEW leaf 2.12: `scripts/` templates for env-up + test-run, self-verifying (course P06 init.sh pattern), wrapped in an environment skill template; build-harness pre-seeds these rows; review-protocol's Pass 3 already runs verification "via the environment skill" so it plugs in directly | User instruction 2026-07-13 mid-Phase-1 | — |

## Handoff block

- **Verified now:** Phases 0–2 COMPLETE — all 12 Phase-2 leaves passing. 9 agent templates (commit 5486739, 456 lines, every one Accept ≥10/12 + cross-checked), 3 checklists (round-3 Accept 12/12), architecture-skill (Accept 10/12 + fixes), env scripts trio (Accept 12/12, live-tested). Dispositions persisted under `.workspace/migration/dispositions/`.
- **Broken / unverified:** nothing in flight.
- **Next best step (resume here):** Phase 3 — 3.1 command-skeleton.md first (most load-bearing new file: clock-in, kernel refs, clean-state exit gate, teardown, handoff, one flow slot, opt-out frontmatter — see plan §3 Phase 3), then 3.2 flow-skeleton, 3.3–3.4 presets (implement ≤80 lines; **resolve test-defect fix-routing gap from 2.5 evidence in preset design**), 3.5 dry-run on a toy task → Phase 4 builder commands (4.3 distill: dedicated L10/L12 course scout first, per D4) → Phase 5 = STOP, hand to user. Protocol: migration-plan.md §2 (orchestrator never authors/reviews/reads v1 sources; scouts+fixers sonnet, authors+cold reviewers opus, no fable; WIP=1 authoring).

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
| 1.4 | `templates/kernel/review-protocol.md`: three-pass + 0–2×6 rubric → Accept/Revise/Block + what/why/fix | cold review Accept | passing | 70 lines; cross-check CLEAN (0 high, 1 low → judged REDUNDANT); cold review **Accept 11/12**, all 6 contract groups present, rubric→verdict mapping confirmed exclusive+exhaustive; 3 fixes applied (verdict nested in done-report Result:, Commit: field added to both shapes, dead back-reference cut) + grep-verified at 70 lines; post-review: plan-mandated P4 framing ("missing a real problem is your failure mode") found absent by orchestrator plan-audit → folded into rubric header line 26, still 70 lines; round log: 1 polish round |
| 1.5 | `templates/workspace/` populated from workspace-starter (9 files, 633 lines); plan-template Tasks section = ledger schema | files present; plan-template references closed enum | passing | 9 files, 9 template headers; 8 diff-identical to source; plan-template Tasks table → leaf schema (ID/Block/Behavior/Verification/Owner/State/Evidence), closed enum seeded, kernel-by-reference one-liner, zero old state vocabulary (grep confirmed); orchestrator re-verified: 9/9 headers, enum present |

## Phase 2 — Agent templates + checklists

| ID | Behavior | Verification | State | Evidence |
|---|---|---|---|---|
| 2.1 | `templates/agents/architect.md` (consolidation-rule copy removed) | agent-standard audit pass; cold review Accept | passing | 52 lines (64→52); disposition 43 rows; consolidation rule → pointer at team-protocol; plan-template dedup sweep adjudicated LEAVE (all pointer targets verified); cross-check 1 HIGH (bare skill names — dangling refs) + 4 low → all fixed; cold review **Accept 12/12**, checklist 10/10; 4 polish fixes applied + grep-verified; round log: 2 fix rounds |
| 2.2 | `templates/agents/critic.md` (stance paragraph deleted) | audit pass; cold review Accept | passing | 68 lines; 16 lenses inlined per D8; cross-check found **4 HIGH** (genericized reply-template contracts, merged constitution triggers, undefined "block order") + 6 low → all 9 restored word-level, still 68 lines; cold review **Accept 12/12**, checklist 10/10, every convention grounded in plan-template; 3 wording fixes applied; round log: 2 fix rounds |
| 2.3 | `templates/agents/engineer.md` | audit pass; cold review Accept | passing | 50 lines; disposition 34 rows; contradiction resolved to kernel verify-first rule; cross-check 0 high / 4 low; cold review **Accept 11/12**, all 10 checklist items pass, kernel refs verified by name+content; 4 polish fixes + 1 adjudicated restore (bold anti-hardcode) applied, grep-verified (invent=1, desc 59 words); round log: 1 polish round |
| 2.4 | `templates/agents/reviewer.md` (points at kernel review-protocol; mechanized-checks-first) | audit pass; cold review Accept | passing | 51 lines; binary vocabulary fully replaced by kernel's graded verdicts; mechanized-checks-first step added, explicitly subsumes kernel Verify pass; round 1 **Revise 9/12** (3 kernel restatements + verify-pass ambiguity) → 6 fixes → round 2 **Accept 12/12**, checklist 10/10; 2 optional polish notes left as-is; round log: 2 rounds |
| 2.5 | `templates/agents/test-engineer.md` | audit pass; cold review Accept | passing | 49 lines; cross-check 0 high / 2 low → restored; cold review **Accept 12/12**, checklist 10/10; 2 nits fixed (P1/P2 tension, done-report naming); reviewer noted ecosystem gap: fix-routing for TEST defects unowned (reviewer→engineer, but engineer doesn't write tests) — carried to Phase 3 preset design; round log: 1 polish round |
| 2.6 | `templates/agents/qa-engineer.md` (manual-testing skill inlined; stance paragraph deleted) | audit pass; cold review Accept | passing | 56 lines; overflow avoided (scout est. 80–95); cross-check 0 high / 3 low; round 1 **Revise 9/12** → 5 fixes → round 2 **Accept 12/12** + 2 nits fixed (mixed ✓/✗ reply case now specified); **model note: qa=sonnet kept (v1 deliberate choice) — user may override to opus**; round log: 2 rounds |
| 2.7 | `templates/agents/codebase-researcher.md` | audit pass; cold review Accept | passing | 44 lines; description 83→42 words; Skills section built from scattered prose; cross-check 0 high / 4 low (2 restored incl. fan-out anti-duplication rule that fell through source→kernel crack); cold review **Accept 11/12** → 2 fixes applied + orchestrator deduped a fixer stutter; round log: 2 fix rounds |
| 2.8 | `templates/agents/product-manager.md` | audit pass; cold review Accept | passing | 48 lines; spec-template dedup executed; codegraph cap kept as PM's deliberate boundary w/ ladder escape hatch; cross-check **2 HIGH** (research-Unknowns fold-in dropped; ~3–5 deliverables quantifier = dangling pointer → repaired AT spec-template, keeping sizing single-sourced) + 4 low → fixed; cold review **Accept 12/12**, 3 optional findings left; round log: 2 fix rounds |
| 2.9 | `templates/agents/product-designer.md` | audit pass; cold review Accept | passing | 38 lines (smallest); Boundaries section built from scattered constraints; altitude rule = zero copies (defers to spec-template primary + product-design skill secondary, reordered for durability per review); cross-check CLEAN (0 high, 1 low pre-existing); cold review **Accept 12/12** → 3 polish fixes; round log: 1 polish round |
| 2.10 | `templates/checklists/`: review-generic + backend/frontend skeletons (per-component checklists per D7a) | files exist; cold review Accept | passing | 3 files (30/29/29 lines); round 1 **Revise 9/12** (protocol leakage + 2 [mech] overclaims) → 6 fixes; round 2 **Revise 9/12** (residual coverage rule + slot-reused-as-prose defect from round-1 fix) → 3 fixes + orchestrator ruling: untag `No commented-out code` (generic checklist can't guarantee lint backing); round 3 **Accept 12/12** — boundary/mech/slot dims all grounded in review-protocol:15-18 + reviewer:28,42; 1 optional finding applied (moved example [mech] from N+1 → raw-SQL, N+1 not reliably grep-able); grep-verified: 0 protocol-owned rules, 0 slot-in-prose, [mech]=5 generic; round log: 3 rounds (max reached, Accept on last) |
| 2.11 | `templates/workspace/architecture-skill.md`: per-component architecture doc/skill template (D7b); build-harness pre-seeds one `<component>-architecture` row per detected component | template exists; cold review Accept | passing | 51 lines, 9 slots each w/ discovery+example; cold review **Accept 10/12** w/ 4 findings (all-Go examples; WHERE/NAMING slot overlap; {{COMPONENT}}↔`<domain>` token binding gap; FORBIDDEN scope) → all 4 fixed + grep-verified (domain token=1, backend example=7, frontend contrasts added); round log: 1 fix round |
| 2.12 | `templates/scripts/`: deterministic env-up + test-run script templates, self-verifying (D7c), + environment skill template that names them; agents never improvise env commands | templates exist; cold review Accept; review-protocol Pass 3 references resolve | passing | authored + LIVE-TESTED (dead-port → named FAILED + exit 1; arg/exit-code passthrough; idempotent); cold review **Accept 12/12** — reviewer traced bash control flow (until-condition suppresses set -e in poll loops; top-level exit propagates; test-run's no-`-e` deliberate for passthrough) and verified all 5 consumer refs land on `name: environment` (review-protocol:24, engineer:30, reviewer:35, test-engineer:30, qa-engineer:23) + troubleshooting keys match env-up's failure strings; 4 minor findings applied post-Accept: ERR trap names start-command failures, {{APP_URL}} slot added for qa-engineer's browser target, blank line before template header removed, brace-less comment labels (naïve find-replace safety); grep-verified: trap present, 4 fill slots remain in env-up, bash -n clean; 61/50/43 lines; round log: 1 polish round |

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
