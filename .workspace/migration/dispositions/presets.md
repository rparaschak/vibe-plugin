# Disposition: `presets/plan-implement/{plan,implement}.md`, `presets/spec-plan-implement/{spec,plan,implement}.md`

Scout pass for Phase 3.3/3.4. Consumes `skeletons.md`'s `belongs-in-preset` rows (1-30) — those mechanics are dispositioned here to a concrete preset+file. Does NOT re-disposition anything `skeletons.md` marked keep-in-skeleton / now-in-kernel / now-in-agent. `templates/skeletons/command-skeleton.md` does not exist yet (`templates/skeletons/` is empty) → **skeleton-size-unknown**, budget section uses `skeletons.md`'s own ~40-60-line estimate as a working assumption.

## Disposition table

### From implement.md (elaborating skeletons.md rows 9/11/12/15b/19/20/25 — WHERE in the preset)

| # | instruction (verbatim key terms) | source | failure prevented | disposition |
|---|---|---|---|---|
| I1 | Worktree create/reuse/gitignore/carry-plan-in/bootstrap-env substeps | implement.md:67-76 | corrupted parallel worktrees, lost uncommitted plan | keep-in-preset-plan-implement/implement.md AND spec-plan-implement/implement.md, as an opt-in sub-block the preset's flow-slot cites by name — mechanism itself lives in kernel `team-protocol.md:39` ("Worktree mode: EnterWorktree BEFORE spawning the first role"); preset only supplies the project-specific path/branch naming (`.claude/worktrees/vibe-<slug>/`, `vibe/<slug>`) and the env-bootstrap step (deps clone, env files) since that's flow/project-specific, not universal |
| I2 | Roles-needed-per-block enumeration (engineer/test-engineer/reviewer/architect on-call/qa-engineer, FE adds qa-engineer) | implement.md:84-93 | wrong roster | keep-in-preset — both implement.md files, "Set up the roles" step, verbatim roster split (Platform/BE vs FE) |
| I3 | Per-block loop 5a-5e (impl→test→review+QA→fix→close) | implement.md:95-131 | skipped gate, premature close | keep-in-preset — both implement.md files; loop *shape* already lives in skeleton (dispatch→wait→gate→advance per skeletons.md row 12), so preset content here is ONLY the flow-specific payload: which role each step dispatches to, brief contents (domain, block, paths, Task IDs), FE's extra E2E+QA sub-steps, and the fix-routing rule (see Test-defect routing recommendation below) |
| I4 | Testing gate specific levels (BE/Platform integration must run; FE E2E run green + QA pass) | implement.md:29-31, 136-143 | conflating build-clean with tested; FE shipped without E2E/QA | keep-in-preset — the *shape* ("no Done without command-verified evidence") is skeleton-owned per skeletons.md row 15; the specific per-domain levels are preset-owned, one line each, cross-referenced from the skeleton's exit-gate step |
| I5 | Learnings capture: dated line, dedupe-within-run-only, finding-theme aggregation, nudge line pointing at `/vibe:distill` | implement.md:169-172 | learnings lost, double-assigned L-IDs, cross-run dedupe done wrong | keep-in-preset — both implement.md files; NOT kernel (task-ledger's Handoff block is a different artifact: "what's unverified for resume," not "durable lessons for other runs") |
| I6 | "The only commit is the finalize commit... never commit mid-run" | implement.md:174 | stray mid-run commits | keep-in-preset as a one-line reminder next to the roster/dispatch content — commit-on-Implemented is a preset-level `commit: on` config stamp per harness-builder.md's preset framing, the reminder line is cheap insurance |
| I7 | Block order Platform → BE → FE, hardcoded | implement.md:26, 80, 90 | inventing an order at generation time that a plan later contradicts | **NOT hardcoded text in implement.md** — implement's "build the run list" step (skeleton-owned, row 7) reads block order FROM the plan/ledger; the preset's role is only to make plan.md (below) the place that authors the order. Implement preset's slot content should say "process blocks in the plan's authored order" not name Platform/BE/FE literally |

### From plan.md (not covered by skeletons.md — new dispositions)

| # | instruction (verbatim key terms) | source | failure prevented | disposition |
|---|---|---|---|---|
| P1 | "Plan is the HOW, not the WHAT... Spec and plan are separate documents" | plan.md:17 | plan restating spec's behaviors instead of referencing by id | **verbatim contract** — keep-in-preset, both plan.md files |
| P2 | Spec-optional branch: spec-fed (read behaviors by id) vs standalone (capture lightweight Goal+Behaviors inline, no critic/UX) | plan.md:19-21 | forcing a spec step on purely technical work, or skipping WHAT capture entirely | **split by preset** — `plan-implement/plan.md`: standalone path is the ONLY path (no spec ever precedes it in this preset) — simplify to "capture Goal+Behaviors inline" unconditionally, delete the spec-fed branch and its `spec.md` lookup entirely. `spec-plan-implement/plan.md`: spec-fed is the ONLY path (a spec always precedes it) — delete the standalone branch, inline-Behaviors capture, and the "no spec.md" fallback entirely. **This is the biggest simplification the preset split buys** — v1's plan.md carries both branches because it's one universal command; neither preset needs the conditional |
| P3 | Plan location/naming (`yymmdd-slug`, `.workspace/plans/`, archive convention) | plan.md:29-33 | ambiguous plan dir resolution | now-in-kernel candidate — this is identical to spec.md:25-29's naming rule and to the general ledger-location convention; **recommend folding into `task-ledger.md`** (not yet done there) rather than repeating in 2 preset files x 2 commands = duplicated 4x; flag as contradiction #3 below if kernel authors already closed |
| P4 | Plan shape: "sized for ONE team... no concept of parts... overflow → andon to the user" | plan.md:35-39 | oversized plan; command silently decomposing (that's spec's job) | keep-in-preset — both plan.md files, short bullet |
| P5 | Outline step 1 (load context, resolve `plan-template.md` via `$CLAUDE_PLUGIN_ROOT`) | plan.md:45-48 | agent inventing template shape | keep-in-preset — both plan.md files; template path resolution mechanics are project-generic, worth a one-liner |
| P6 | Outline step 3: roles set up (lead, codebase-researcher, architect, critic; NO product-manager in standalone) | plan.md:57-59 | wrong roster for standalone; architect surfacing product questions unhandled | **split by preset** — plan-implement/plan.md: roster is fixed (lead/researcher/architect/critic), never product-manager, since standalone is the only path; spec-plan-implement/plan.md: same 4-role roster (product-manager was already spec.md's, not plan.md's) — roster is actually IDENTICAL across presets here; only the behavior-source branching (P2) differs |
| P7 | Outline step 4: technical research → `## Current State`, cite `file:line`, lead reads only done-report | plan.md:61-65 | lead reading full research; uncited claims | keep-in-preset — both plan.md files, verbatim dispatch brief shape |
| P8 | Outline steps 5-6: architecture BE then FE, FE-bearing test (spec has `## UX structure` OR standalone domain surface names frontend), append-never-edit rule | plan.md:67-74 | FE architect overwriting BE-authored content; running FE architecture for backend-only work | keep-in-preset — both plan.md files; FE-bearing test differs slightly per preset (spec-plan-implement checks `spec.md`'s `## UX structure`; plan-implement — no spec exists — checks only the domain-surface flag captured in P2's Goal+Behaviors step) |
| P9 | Outline step 7: critique gate (architecture lens), reconcile-don't-rubber-stamp, cap 3 revise cycles, ⚠️ → Open Questions | plan.md:76-80 | rubber-stamped design; infinite critique loop | **verbatim contract** (cap "3 revise cycles" matches kernel stop-condition numeric style) — keep-in-preset, both plan.md files |
| P10 | Outline step 8: finalize gate checklist (Open Questions None, Constitution line + ⚠️ options+recommendation, every behavior delivered+tested, Tasks Platform→BE→FE, Depends-on acyclic) | plan.md:82-91 | plan marked Ready with a gap | keep-in-preset — both plan.md files; this is plan's OWN exit gate (distinct from implement's clean-state exit gate, which is skeleton-owned) so it stays preset content, not skeleton |
| P11 | "Tear down the team... do not start `/vibe:implement` automatically — the user reviews first" | plan.md:91 | uncontrolled auto-chaining | now-in-skeleton per skeletons.md row 22 (already dispositioned) — do not repeat here beyond a one-line pointer |

### From spec.md (not covered by skeletons.md — new dispositions, only relevant to spec-plan-implement)

| # | instruction (verbatim key terms) | source | failure prevented | disposition |
|---|---|---|---|---|
| S1 | "Spec is the WHAT, not the HOW... you never draft behaviors or design UX yourself" | spec.md:15,17 | lead drafting behaviors, collapsing PM's role | **verbatim contract** — keep-in-preset spec-plan-implement/spec.md |
| S2 | "Your window into the code is `research.md`... you read only `## Summary`" | spec.md:21 | lead reading full cited research | keep-in-preset, verbatim — same context-discipline pattern as plan.md:64-65 (P7); consider whether this collapses into skeleton's "Context discipline" fixed section (skeletons.md row 5) since the SHAPE (lead reads only the done-report/summary, never full cited artifacts) is identical across spec/plan/implement — **flag as contradiction #4** |
| S3 | Spec location/naming | spec.md:25-29 | same as P3 | same disposition as P3 — fold-into-kernel candidate |
| S4 | Spec shape: sized for one plan/one team, decompose oversized work into separate specs sharing date prefix, B-IDs local per spec, stub spec variant | spec.md:31-36 | oversized spec; global B-ID collisions | keep-in-preset, spec-plan-implement/spec.md only |
| S5 | Outline steps 1-2: load context/resolve templates, set up roles (lead, researcher, PM, critic, product-designer on-call) | spec.md:42-49 | wrong roster; template drift | keep-in-preset |
| S6 | Outline step 3: product research brief ("mine the behaviour-based tests to inventory what the system already does") | spec.md:51-56 | re-deriving behaviors from scratch instead of the existing test surface | **verbatim contract** — this phrase is spec-specific technique, not generic; keep-in-preset |
| S7 | Outline step 4: frame via PM's 2-3 highest-leverage forks, lead relays via `AskUserQuestion`, never analyzes research itself | spec.md:58-61 | lead pre-deciding scope instead of the user | keep-in-preset, verbatim relay pattern |
| S8 | Outline step 5: PM drafts Problem/Behaviors/OutOfScope/Assumptions; lead reads only terse done-report | spec.md:63-66 | lead reading full spec draft mid-flight | keep-in-preset |
| S9 | Outline step 6: critique gate (product lens), reconcile-don't-rubber-stamp, "Lock the behaviors" | spec.md:68-72 | building plan against unvetted behavior | keep-in-preset, verbatim "Lock the behaviors" line — this is the load-bearing handoff contract to plan.md (P2's spec-fed branch depends on behaviors being genuinely locked here) |
| S10 | Outline step 7: size & decompose (seam = priority-first then capability boundary, `AskUserQuestion` for the split, `Depends on` DAG) | spec.md:74-78 | one team choking on an oversized spec; silent decomposition without user sign-off | keep-in-preset, verbatim seam rule |
| S11 | Outline step 8: design UX, conditional on `product-design` skill presence AND FE-bearing, `--design`/`--no-design` override | spec.md:80-83 | running design on backend-only work; skipping it silently on FE work | keep-in-preset, verbatim skip conditions — this is the FE-bearing flag P8 later reads |
| S12 | Outline step 9: finalize (Ready for Plan / Blocked — Open Questions), report shape, teardown, "do not start `/vibe:plan` automatically" | spec.md:85-92 | uncontrolled auto-chain; unresumable state | keep-in-preset for the report shape; teardown/no-auto-chain line is now-in-skeleton per skeletons.md row 22 — don't duplicate, pointer only |

## Verbatim contracts (must survive word-level)

1. **"Plan is the HOW, not the WHAT... Spec and plan are separate documents."** (plan.md:17) — governs the plan-implement vs spec-plan-implement split itself.
2. **"Spec is the WHAT, not the HOW."** (spec.md:17) — spec-plan-implement/spec.md only.
3. **"Lock the behaviors."** (spec.md:72) — the exact handoff contract: nothing downstream (design, or plan's architecture) is built against an unvetted behavior.
4. **Testing gate specific levels**: "BE / Platform → the integration suite ran and passed" / "FE / any user-facing block → the E2E suite ran green ... and the qa-engineer manual click-through returned QA pass" (implement.md:29-30) — the domain-specific payload the skeleton's generic exit-gate step needs from the preset.
5. **Critic gate caps**: "Cap at 3 revise cycles, then stop and report as-is" (plan.md:79) and implement's fix loop "Cap at 3 fix cycles" (implement.md:126, already kernel per skeletons.md row 14) — plan's critic cap is a DIFFERENT numeric gate than the kernel's fix→re-review cap; keep both, don't conflate.
6. **"Reconcile, don't rubber-stamp."** (plan.md:78, spec.md:71) — appears twice verbatim in v1; keep in both preset files it applies to (it is preset-specific critique-loop language, not a kernel review-protocol restatement — review-protocol.md governs the *reviewer* agent's rubric, this line governs the *lead's* handling of critic findings, a different actor).
7. **Roster enumeration** (implement.md:90-91): "Platform / BE blocks — the engineer (backend domain), the test-engineer (backend domain), the reviewer (backend domain); plus the architect (backend domain — on-call)... FE block — the engineer (frontend domain), the test-engineer (frontend domain...), the reviewer (frontend domain), qa-engineer..." — keep verbatim in both implement.md files, this is what lets an author cite exact `templates/agents/*.md` names without re-deriving the roster.

## Per-file content budgets

- `templates/skeletons/command-skeleton.md` does not exist yet → **skeleton-size-unknown** as an authoritative figure. Using `skeletons.md`'s own suggested-outline estimate (~40-60 lines of fixed scaffolding) as a planning assumption:
- **`plan-implement/implement.md` and `spec-plan-implement/implement.md`** (identical or near-identical — both budgeted the same): total ≤80 lines (migration-plan.md §3 hard requirement) minus skeleton's ~40-60 → **slot budget ≈20-40 lines**. This is TIGHT: I2 (roster) + I3 (5a-5e dispatch payload + FE extras + fix-routing) + I4 (testing-gate levels) + I5 (learnings mechanics) + I6 (commit reminder) + I1 (worktree opt-in pointer) must all fit. **Recommend the author cut I5's dedupe/finding-theme prose to one bullet each and I1 to a single "see kernel team-protocol worktree mode; project-specific paths: `.claude/worktrees/vibe-<slug>/`" line** rather than porting implement.md's 10-line worktree substep prose. If it still doesn't fit, I5 (learnings) is the best candidate to shrink further or partially fold into the kernel handoff block (flag to author, not decided here).
- **`plan-implement/plan.md`**: no ≤80 hard cap stated in migration-plan.md (only implement is capped) — command-standard's general entry-file budget (50-200 lines) applies. Content: P1, P4-P10 roughly at v1 lengths since P2's simplification (delete the spec-fed branch) actually SHRINKS this file versus v1's plan.md, offsetting P3/P4 additions. Net: should land comfortably under v1's 92 lines, likely 60-75.
- **`spec-plan-implement/plan.md`**: same content minus the standalone branch (P2's other half) — similarly shrinks vs v1.
- **`spec-plan-implement/spec.md`**: S1-S12 close to v1's spec.md length (92 lines) since nothing in skeletons.md's disposition removed spec-specific content — spec.md's hard boundary/role prose (rows not separately tabled above, e.g. lines 13-23) largely collapses into the skeleton's Role section per skeletons.md row 2, which should shrink this file some.

## Test-defect routing recommendation (MANDATE)

**Recommendation:** the implement preset's fix loop (I3, replacing v1 5d) routes each finding by **where its fix lands, read from the finding's own `file:line`/fix field — never by defect symptom (red test ≠ automatic route-to-engineer)**:
- Finding's fix is in test code (missing test case, wrong assertion, broken fixture/mock, wrong test-layer choice) → re-dispatch to **`test-engineer`**.
- Finding's fix is in production code (impl defect) → re-dispatch to **`engineer`**.
- The **dispatching lead makes this call from the finding's cited file path** (test-file suffix/dir vs source path) — reading a file*name* in a routed finding is not "reading code" and stays inside the lead's context-discipline boundary (implement.md:35-39 / skeletons.md row 5).

**Citations establishing consistency:**
- `templates/agents/engineer.md:3,45` — engineer's description and Boundaries state it explicitly "does **not** write the block's tests or their fixtures/factories — the domain's `test-engineer` does, after you." Routing a test-code fix to the engineer would force it outside its own declared boundary.
- `templates/agents/test-engineer.md:41,45` — test-engineer's done-report already classifies red results as "whether it's a test bug or an impl defect," and its Boundaries line says impl defects are `Blocked on:` for the lead to route to the engineer — establishing the SAME lead-routes-by-classification pattern for the symmetric case (test bug → route back to test-engineer) that v1 never states.
- `templates/kernel/review-protocol.md:41-46` — the finding format already carries `fix: <concrete change>`, which by construction names a location; the lead needs no extra read to route, it only needs to look at that field.
- `templates/kernel/team-protocol.md:63-70` (Role boundaries) — "Engineers write code; don't redesign the plan" / no line grants engineers test-writing authority, confirming production-code-only scope; there is no existing role-boundary text that would let a test-code finding land anywhere but test-engineer.

v1's actual gap (confirmed): implement.md:125 says "re-dispatch to the engineer with the findings verbatim" **unconditionally** — this is the defect. No v1 text or current agent template authorizes engineer to touch test code, so the unconditional route is already inconsistent with the agent boundaries that exist today, not just a v2 upgrade.

## Contradictions to resolve

1. **Plan/spec location-naming convention (P3/S3) is stated near-verbatim in both plan.md and spec.md** (and would be stated a third and fourth time across 2 presets x 2 files) — should this fold into `task-ledger.md` as a kernel convention now, or stay preset-duplicated? Not yet done in the kernel file I read. **Recommend:** fold into kernel (task-ledger.md's existing "The plan is the ledger" framing already half-implies a location; make it explicit) — cleanest single-source fix, low risk.
2. **Plan's own finalize gate (P10) vs implement's clean-state exit gate (skeleton-owned)** — two different "gates" exist in the same pipeline with similar-sounding names. **Recommend:** the author name them distinctly in the preset text ("plan readiness gate" vs "implementation exit gate") to prevent an author or future agent conflating them.
3. **Context-discipline "read only the Summary/done-report" pattern (S2) appears 3x** (spec.md:21, plan.md:39/64-65, implement.md:35-39) with near-identical wording. skeletons.md row 5 already keeps ONE instance in the skeleton's fixed Context Discipline section. **Open question for author:** does that ONE skeleton instance suffice for all three commands' varying artifacts (research.md Summary / plan Current State / worker done-reports), or does each preset still need one line naming ITS specific artifact? **Recommend:** skeleton keeps the generic rule, each preset adds only the one-line artifact-specific pointer (not the full rationale) — avoids re-arguing the discipline three times.
4. **Roster (P6) is identical across both plan.md variants** — v1 already has zero product-manager in plan.md regardless of spec-fed/standalone. This means P2's split is ONLY about behavior-sourcing, not roster. Low-risk, just flag so the author doesn't over-split content that's actually shared.

## Suggested outlines

### `plan-implement/plan.md` (standalone-only; ~60-75 lines)
```
description: <preset-specific, ≤80 words, cites "plan-implement" and no-spec path>
[frontmatter opt-outs: none expected — plan is not implement-shaped]
## User Input / ## Role         [skeleton-owned]
## Plan shape                    P1, P4 (sizing, no-parts rule)
## Outline
1. Load context                  P5 (template resolution)
2. Capture Goal + Behaviors       P2's standalone half, UNCONDITIONAL (no spec-fed branch)
3. Set up roles                   P6 (lead/researcher/architect/critic — never PM)
4. Technical research              P7
5. Architecture BE                 P8 (BE half)
6. Architecture FE (if FE-bearing) P8 (FE half, domain-surface test from step 2)
7. Critique gate                   P9 (cap 3 cycles)
8. Finalize                        P10 (plan's own readiness gate)
[Teardown / handoff — skeleton-owned, one pointer line]
```

### `plan-implement/implement.md` (≤80 total; slot ≈20-40 lines)
```
[skeleton: User Input / Role / Clock-in / Gate check]
## Execution model                I7 — "process blocks in the plan's authored order," NOT hardcoded
## Set up the roles                I2 — verbatim roster split
## Per-block loop                  I3 — 5a-5e payload: dispatch briefs per role, FE E2E+QA extras,
                                     fix-routing rule (test-defect recommendation above)
[skeleton: clean-state exit gate — cites I4's domain-specific levels inline or by reference]
[skeleton: teardown / handoff]
## Finalize extras                 I5 (learnings, compressed) + I6 (commit-only reminder)
                                    + I1 (worktree: one-line pointer to kernel + project paths)
```

### `spec-plan-implement/spec.md` (~75-90 lines)
```
## Role                            S1 (verbatim contract)
## Spec shape                      S4
## Outline
1. Load context                    S5
2. Set up roles                    S5
3. Research current state          S6 (verbatim "mine the behaviour-based tests" brief)
4. Frame the request               S7
5. Draft behaviors                 S8
6. Critique gate                   S9 (verbatim "Lock the behaviors")
7. Size & decompose                S10
8. Design UX (conditional)         S11
9. Finalize                        S12 (report shape; teardown pointer)
```

### `spec-plan-implement/plan.md` (spec-fed-only; ~55-70 lines)
```
Same skeleton as plan-implement/plan.md, EXCEPT:
2. Resolve behaviors from spec.md   P2's spec-fed half, UNCONDITIONAL (delete standalone branch,
                                     delete Goal+Behaviors capture — spec.md already locked them)
6. Architecture FE test             reads spec.md's `## UX structure` presence (not a domain-surface flag)
```

### `spec-plan-implement/implement.md`
Identical to `plan-implement/implement.md` — implement's content doesn't depend on whether a spec preceded planning (it only reads the plan/ledger). **Recommend the author literally share this file's slot content between both presets** (single source, stamped twice) rather than drafting it twice — flag as a build-harness/authoring efficiency note, not a correctness issue.
