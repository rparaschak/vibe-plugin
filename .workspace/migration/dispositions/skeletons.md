# Disposition: `templates/skeletons/{command,flow}-skeleton.md`

Scout pass for Phase 3.1/3.2. Kernel (Phase 1) and agent templates (Phase 2) already exist — kernel `name:` fields confirmed: `vibe-task-ledger`, `vibe-research-protocol`, `vibe-team-protocol`, `vibe-review-protocol` (all in `templates/kernel/*.md`).

## Disposition table

| # | instruction (verbatim key terms) | source | failure it prevents | disposition |
|---|---|---|---|---|
| 1 | "You **MUST** consider the user input before proceeding (if not empty)." | implement.md:11, plan.md:11, spec.md:11, build-flow.md:11 (identical 4x) | ignored `$ARGUMENTS` | keep-in-skeleton (command-standard rule 6 mandates this verbatim under `## User Input`) |
| 2 | "You only orchestrate... never touch code" hard-boundary block | implement.md:15-20 | lead edits app code | keep-in-skeleton, but reword to command-standard rule 7's canonical sentence: `**Hard boundary:** this command never edits project source; Edit/Write are used only for <named artifacts>.` |
| 3 | Same boundary, 3 more phrasings | plan.md:23, spec.md:19, build-flow.md:17-19 | phrasing drift (command-standard names this exact defect) | delete (all 4 collapse into command-standard rule 7's one sentence) |
| 4 | "Dispatch through `vibe-team-orchestration`... briefs are short; done replies follow `vibe-team-communication-protocol`" | implement.md:22, plan.md:27, spec.md:23 | ad-hoc dispatch/reply formats | now-in-kernel (`team-protocol.md`, merged) — skeleton references by name only |
| 5 | "Context discipline (non-negotiable)" section, buried at line 35 | implement.md:35-39 | lead reads app code mid-run | keep-in-skeleton as a fixed top-section item (command-standard rule 2 names this exact file/line as the canonical bad example of constraint burial) |
| 6 | Gate check: Status/Open Questions/Dependencies before any dispatch | implement.md:56-61 | building on an unready artifact | keep-in-skeleton as a fixed early "Gate check" step (entry gate, distinct from exit gate) |
| 7 | Resolve target dir, `Grep -n '^## '` map, read only header/OQ/Tasks | implement.md:51-54 | wide reads of the plan file | keep-in-skeleton (this IS the "clock-in" step named in migration-plan.md:150) — generalize past "plan" to "the ledger" |
| 8 | `--worktree` flag toggling a whole alternate lifecycle within one command | implement.md:41-47, 63-77, 148-154 | — (mechanism itself is a defect per command-standard rule 4) | **contradiction — see below**; mechanics that survive → now-in-kernel (`team-protocol.md:39` "Worktree mode: EnterWorktree BEFORE spawning the first role") |
| 9 | Worktree create/reuse/gitignore/carry-plan-in/bootstrap-env substeps | implement.md:67-76 | corrupted parallel worktrees, lost uncommitted plan | belongs-in-preset (implement-preset only; not every flow needs worktrees) |
| 10 | Build the run list, resume-aware ("first task not Done is the resume point") | implement.md:78-82 | re-doing completed work on resume | now-in-kernel (ledger resume semantics — task-ledger.md is the schema; skeleton's clock-in step invokes it) |
| 11 | Roles-needed-per-block enumeration (engineer/test-engineer/reviewer/architect on-call/qa-engineer) | implement.md:84-93 | wrong roster | belongs-in-preset (roster is domain/flow-specific) |
| 12 | Per-block loop 5a-5e (impl→test→review/QA→fix→close) | implement.md:95-131 | skipped gate, premature close | belongs-in-preset (implement-preset's WIP=1 dispatch loop, migration-plan.md:152); loop *shape* (dispatch→wait→gate→advance) is the pattern the flow slot is for |
| 13 | "green means actually executed and passing, not merely written, compiling, or `--list`-verified" | implement.md:27, 112, 142 | false-green closes | **verbatim contract** — keep-in-skeleton language for the clean-state exit gate |
| 14 | Cap at 3 fix cycles; findings survive 2 rounds → stop | implement.md:126 | infinite fix loops | now-in-kernel (`task-ledger.md:34-38` Stop conditions, verbatim) |
| 15 | Testing gate hard requirement (4-bullet list: all Done / integration ran / E2E+QA for user-facing / build clean) | implement.md:136-143 | declaring Implemented without genuine evidence | **verbatim contract**, split: the *shape* ("no Done without command-verified evidence") → keep-in-skeleton (P3 clean-state exit gate); the *specific levels* (BE integration vs FE E2E+QA) → belongs-in-preset |
| 16 | `**Verified**: <date> · <evidence per layer>` report line | implement.md:144 | evidence living only in chat, lost on resume | now-in-kernel (task-ledger.md evidence field / two-level verification already generalizes this) |
| 17 | Finalize ordering: capture learnings → archive plan → commit → (worktree) merge-back → teardown team | implement.md:144-154 | teardown-before-evidence-written race, lost learnings | **verbatim contract** — keep-in-skeleton as the fixed Teardown section's internal order |
| 18 | Blocked variant: `Status: Blocked — Implement` + Why / What NOT done (checklist) / What IS done | implement.md:162-167 | unresumable blocked state | now-in-kernel, superseded by task-ledger.md's cleaner Handoff block (Verified now/Changed this session/Broken or unverified/Next best step) — skeleton's handoff write-out step should emit the kernel format, not this bespoke one |
| 19 | Learnings capture (dated line, dedupe within run only, no L-IDs) | implement.md:169-172 | learnings lost or double-assigned | belongs-in-preset (implement-preset-specific; not every flow produces learnings) |
| 20 | "The only commit is the finalize commit... never commit mid-run" | implement.md:174 | stray mid-run commits | belongs-in-preset (commit-on-Implemented is a preset/flow slot per build-flow.md:110 `commit: <on|off>`) |
| 21 | Teardown: "no teammate left running... one team's lifetime = one invocation" | implement.md (Role, throughout), plan.md:91, spec.md:92 | orphaned agents | now-in-kernel (`team-protocol.md:45-49` Teardown) — skeleton's fixed Teardown section is a one-line reference |
| 22 | "Tear down the team... do not start X automatically — the user reviews first" | plan.md:91, spec.md:92 | uncontrolled auto-chaining between phases | keep-in-skeleton as fixed Report/Finalize closing line pattern |
| 23 | Invariant list (thin lead, dispatch-via-kernel, context discipline, testing gate, gates-before-build, behavior coverage, one-team-teardown, block order) | build-flow.md:54-66 | a generated flow silently drops a guarantee | superseded — structural inheritance (fixed skeleton sections) replaces LLM-judged invariant-checking; items 1-3,7 → now-in-kernel/keep-in-skeleton; items 4-6,8 → belongs-in-preset (see harness-builder.md:59) |
| 24 | "Delete the LLM-judged 'validate guarantees are preserved' step" | migration-plan.md:166 | soft/skippable enforcement | delete (build-flow.md:83-88 step 3 entirely — fixed sections make it structurally impossible to omit, no runtime check needed) |
| 25 | Block order Platform → BE → FE hardcoded | implement.md:26, 80, 90 | — | belongs-in-preset explicitly (harness-builder.md:113 deprecation table: "Move into plan/preset (architect decides per plan)") — NOT a skeleton fixed section |
| 26 | Provenance stamp: `<!-- vibe:build-flow generated:... templated-from:... flow-spec: {...} -->` (structured, multi-line, carries full flow-spec for deterministic `--regen`) | build-flow.md:97-114 | non-deterministic regen, no audit trail | **contradiction — see below**; the payload need (regen determinism) survives, home unresolved |
| 27 | Stage catalog table (skeleton lift-from / agent home / variable slots) | build-flow.md:28-52 | inventing capabilities instead of composing existing ones | belongs-in-preset / flow-skeleton design reference — not skeleton content itself, but the *slot* concept (flow-specific middle) is exactly what row 12 generalizes |
| 28 | Whole-phase rule: only implement is sub-stage-customizable; spec/plan are delegate-whole-or-omitted | build-flow.md:74-81 | inventing partial-phase customization | belongs-in-preset/build-flow command logic, not skeleton — but confirms flow-skeleton's slot is one contiguous middle, not multiple scattered slots |
| 29 | Name-collision guard before writing generated file | build-flow.md:122 | silent overwrite of a hand-edited command | belongs-in-preset/build-flow command, not skeleton |
| 30 | "Never `Edit`/`Write` on source files... the only file you write is the generated command" (build-flow's own boundary) | build-flow.md:17-19 | build-flow touching app code | not skeleton content — build-flow.md is a *generator*, not a generated command; N/A to these two files |

## Verbatim contracts (must survive word-level)

1. **Clean-state exit gate language** (P3, harness-builder.md:124): *"build passes / all tests incl. pre-existing / ledger accurate / no stale artifacts / startup works — verified by command output"* — cross-checked against implement.md:136-143's four-bullet testing gate and the "green means actually executed... not merely written, compiling, or `--list`-verified" line (implement.md:27).
2. **Command-standard boundary sentence** (rule 7, command-standard.md:22-23): `` **Hard boundary:** this command never edits project source; `Edit`/`Write` are used only for <named artifacts>. `` — replaces implement.md:15-20 + 3 other phrasings.
3. **Template-version header** (command-standard.md:16-18): `` <!-- vibe-template: <template-path> v<N> | generated <date> | edits below this marker are yours --> ``
4. **`## User Input` block** verbatim (command-standard.md:21, migration-plan.md example matches all 4 v1 commands exactly): the `$ARGUMENTS` code fence + "You **MUST** consider the user input before proceeding (if not empty)."
5. **Opt-out frontmatter contract** (migration-plan.md:150): *"Opt-outs require an explicit `opt-out:` frontmatter line naming the section — absence of a section with no opt-out line = generation bug."*
6. **Finalize ordering** (implement.md:144-154, condensed): evidence/Verified-line written → learnings captured → archive/state-flip → commit → (if applicable) merge-back → teardown. Order is load-bearing: "Do this only on a true Implemented finalize... never archive a Blocked plan."
7. **Kernel handoff block fields** (task-ledger.md:52-57, already kernel-final): Verified now / Changed this session / Broken or unverified / Next best step — this is what the skeleton's handoff write-out step must emit, not implement.md's bespoke Blocked-note shape (row 18).

## Design-doc requirements (harness-builder.md + migration-plan.md §3)

- Kernel sections in generated commands are "literal fixed template text the builder *cannot omit*" — harness-builder.md:59.
- "A generated flow cannot silently drop the andon cord or the research ladder; opt-out means the user said so, never that the generator forgot." — harness-builder.md:59.
- build-flow "Generates a lean, linear, project-local flow from the same skeletons with the same structural kernel inheritance. Flows are allowed to be opinionated, specific, and disposable; the kernel is not." — harness-builder.md:78.
- command-skeleton.md fixed sections enumerated: "clock-in (read ledger + handoff + decision log), kernel references (research/team/review protocols), clean-state exit gate (P3...), teardown, handoff write-out. One marked slot for the flow-specific middle." — migration-plan.md:150.
- flow-skeleton.md: "same kernel sections, lighter middle, for ad-hoc flows" — migration-plan.md:151.
- "Generated files carry a template + version header" for upgrade diffing — harness-builder.md:137; example format at migration-plan.md:57.
- "Zero conditional branches for project shapes... A command needing a mode = generate two commands." — command-standard.md:19 (rule 4) — directly indicts implement.md's `--worktree` flag.
- Canonical section order: frontmatter → template header → `## User Input` → `## Role` → optional flow-specific sections → `## Outline` (final step `Finalize` or `Report`) — command-standard.md:21, 26 (rules 6, 9).
- Size budgets: entry commands 50-200 lines; implementation-loop-shaped ≤80 lines — command-standard.md:14 (rule 1).
- Risk-table pressure valve: "if a section is opted out of in >half of generated flows, it wasn't kernel — demote it" — migration-plan.md:227.

## Contradictions to resolve

1. **`--worktree` runtime flag vs. "no runtime branching."** implement.md:41-47 implements worktree mode as an in-command flag (`--worktree` in `$ARGUMENTS` or a constitution setting), producing two behavioral paths in one file. command-standard.md rule 4 explicitly bans this shape and names line-35-style burial as the canonical failure this same file exhibits (rule 2's example). **Recommend:** worktree-or-not becomes a generation-time decision (two stamped commands, or a preset parameter baked in at build-harness time), not a `$ARGUMENTS` flag on the generated file.
2. **build-flow's structured provenance stamp vs. the generic one-line template-version header.** build-flow.md:97-114 carries a full multi-line `flow-spec:` payload (domains, phase modes, review fan-out, consolidation, fix mode, commit) enabling deterministic `--regen`. command-standard.md rule 3 / migration-plan.md:57 specify only a single-line header. **Recommend:** flow-skeleton.md keeps the single-line template-version header (rule 3) as the *first* line for upgrade-diffing, but may append a second structured comment block for flow-specific regen metadata — author should decide whether that block is skeleton-fixed or preset-authored; flag as open judgment call, not silently drop build-flow's regen determinism.
3. **P3 clean-state exit gate is described as fixed for "every implement-shaped skeleton" (harness-builder.md:124) but command-skeleton.md is described as the spine for every generated command (spec/plan/implement alike).** Non-implement-shaped commands (spec, plan) don't build code and can't satisfy "build passes / startup works." **Recommend:** the section stays structurally present in command-skeleton.md but is the expected `opt-out:` target for non-implement-shaped presets (spec/plan opt out by name, per the opt-out contract) — not conditionally omitted from the skeleton itself.
4. **Block order Platform→BE→FE**: harness-builder.md:113 says this moves to plan/preset; but implement.md's per-block loop *shape* (dispatch→wait→gate→advance, rows 12/6/13) is still a hard-won skeleton-worthy pattern. **Recommend:** skeleton's flow slot carries a generic "ordered blocks, one closes before the next opens" loop shape with block order itself left to the preset/plan to populate — don't bake Platform→BE→FE into the skeleton, but don't lose the sequencing discipline either.

## Suggested outlines

### `command-skeleton.md`
```
---
description: <filled by author per preset, ≤80 words>
---
<!-- vibe-template: skeletons/command-skeleton v1 | generated <date> | edits below this marker are yours -->
[opt-out: <section-name>]   ← zero or more, only when a fixed section doesn't apply

## User Input                          [FIXED — verbatim block, row 1/4]
## Role                                [FIXED — thin-lead + canonical boundary sentence, row 2]
## {{FLOW-SPECIFIC MIDDLE}}            ← the one marked slot; preset authors everything here
## Outline
1. Clock-in                            [FIXED — read ledger/handoff/decision log, rows 6-7]
2. Gate check                          [FIXED — entry-gate pattern, row 6]
3-N. {{FLOW STEPS}}                    ← slot continues into Outline body
N+1. Clean-state exit gate             [FIXED, opt-out-able — P3, verbatim contract 1]
N+2. Teardown                          [FIXED — kernel team-protocol reference, row 21]
N+3. Handoff write-out                 [FIXED — kernel Handoff block shape, verbatim contract 7]
Final step name: `Finalize` (mutates state artifact) per command-standard rule 9
```
Budget: ≤200 lines for entry-shaped instantiations, ≤80 for implement-shaped (command-standard rule 1) — the skeleton itself should be lean (~40-60 lines of fixed scaffolding) since most bulk is preset-authored into the slot.

### `flow-skeleton.md`
Same fixed-section skeleton as above, minus preset-specific bulk:
```
[same header/opt-out/User-Input/Role as command-skeleton]
## {{FLOW-SPECIFIC MIDDLE}}   ← lighter: build-flow's stage catalog (build-flow.md:28-52)
                                 populates this from the sketch; whole-phase rule (row 28)
                                 still applies if an implement-shaped stage is inlined
## Outline
1. Clock-in                    [FIXED, lighter — no plan-dir resolution machinery]
2. Gate check                  [FIXED, opt-out-able — ad-hoc flows may have no upstream gate]
3-N. {{FLOW STEPS}}
N+1. Clean-state exit gate     [FIXED, opt-out-able — most likely opt-out target per row 15]
N+2. Teardown                  [FIXED]
N+3. Handoff write-out         [FIXED, opt-out-able for one-shot flows with no resume need]
```
Provenance: single-line template-version header is mandatory (contract 3); whether build-flow's richer `flow-spec:` regen block also lives here is contradiction #2 — author's call, but don't silently drop `--regen` determinism.

## Ecosystem note: test-defect fix-routing gap

v1's `reviewer.md` line 14 says "You find issues and report them; the engineer fixes them" — undifferentiated. But `templates/agents/engineer.md:45` states the engineer explicitly "does **not** write the block's tests or their fixtures" and `test-engineer.md:46` says a test-engineer that finds an impl defect reports `Blocked on:` for the team-lead to route to the engineer — there is no symmetric instruction for what happens when the defect is in the *test* itself (wrong assertion, missing case) rather than the code. `test-engineer.md:42` only says the done-report states "whether it's a test bug or an impl defect" — routing after that classification is undefined in both v1 and the current agent templates. **This must be resolved in preset design** (implement-preset's fix loop, row 12): the skeleton's flow-slot loop shape should leave an explicit routing branch — test-bug findings re-dispatch to test-engineer, impl-defect findings re-dispatch to engineer — as a named pattern the preset author fills in, not something the skeleton hardcodes (since not every flow has a test-engineer role at all).
