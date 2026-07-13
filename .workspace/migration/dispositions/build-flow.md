# Disposition: `commands/build-flow.md` (leaf 4.2)

Scout pass for Phase 4.2. Feeds an author who will NOT read v1 sources — everything load-bearing is captured verbatim below. Recommendations are mine, marked **REC**.

## 1. Requirements table (design doc + migration plan, cited)

| Stage | Requirement (near-verbatim) | Cite |
|---|---|---|
| Scope | "For ad-hoc, task-shaped needs — strangler-fig refactor, slice extraction, one-off migrations. Generates a lean, linear, project-local flow from the same skeletons with the same structural kernel inheritance. Flows are allowed to be opinionated, specific, and disposable; the kernel is not." | harness-builder.md:78 |
| Repoint | "repoint: generate into the project's `.claude/commands/` from `flow-skeleton.md`. Delete the LLM-judged 'validate guarantees are preserved' step — inheritance is now structural. Remove its copy of the consolidation rule." | migration-plan.md:166 |
| Fate | "Promote & repoint — the compiler, generating into the project — Center of gravity already moved here; currently undocumented in README." | harness-builder.md:106 |
| Structural inheritance | "Inheritance is structural, not judged. Generated commands/flows come from skeletons whose kernel sections are literal fixed template text the builder *cannot omit*... Today build-flow 'validates guarantees are preserved' via LLM judgment; that soft enforcement is exactly what gets replaced. A generated flow cannot silently drop the andon cord or the research ladder; opt-out means the user said so, never that the generator forgot." | harness-builder.md:59 |
| Single-source | "Consolidation rule stated in 3 places (architect.md, orchestration skill, build-flow.md) → Single-source in kernel" | harness-builder.md:112 |
| Runtime footprint | Plugin-resident at runtime: only build-harness, build-flow, distill; everything else executes from the project's own `.claude/`. | migration-plan.md:18,150 |
| Standard | Both builder commands "are themselves written against `standards/command-standard.md` and the skeleton discipline (the builder obeys its own kernel)." | migration-plan.md:168 |
| Determinism | Composition spec (W-A..H) "apply[ies] exactly on every command/**flow** stamp" — not build-harness-specific. | build-harness.md:69 |
| Evidence | 4.1's Handoff cites "3.5's composition-convention WARN checklist... as the composition spec — two builders must stamp byte-identical output" — binds build-flow too. | ledger.md:29 |

**8 requirement rows.**

## 2. v1 disposition table (verbatim contracts, keep/merge/rewrite/delete)

| # | Rule | Cite | Disposition |
|---|---|---|---|
| 1 | "One self-contained command at the **repo root's** `.claude/commands/<name>.md` (never inside the plugin's own `commands/`)." | build-flow.md:24 | **keep verbatim contract** — this IS the "repoint" the leaf title names; write target unchanged |
| 2 | "`--regen <name>`" + bespoke provenance stamp (`<!-- vibe:build-flow … flow-spec: … -->`, a hand-rolled YAML block) | build-flow.md:97-114,123 | **delete, superseded** — command-skeleton's own `<!-- vibe:regen preset={{PRESET}} · flow-spec={{FLOW_SPEC}} -->` line (command-skeleton.md:6) is the shared regen mechanism; flow-skeleton fills `PRESET=flow`, `FLOW_SPEC=<this spec's path>` (flow-skeleton.md:38). No bespoke stamp needed. |
| 3 | **The stage catalog** (delegate-vs-inline, "skeleton lift-from base command" column, whole-phase rule) | build-flow.md:28-52,76-81 | **delete** — presumes `spec.md`/`plan.md`/`implement.md` are live, invocable base commands a flow can "delegate to" at runtime. v2 has no such runtime call target (presets are generation-time-only inputs to build-harness; command-standard rule 4 forbids runtime branching, which "delegate or inline" is). flow-skeleton has no delegation concept — only Team/Artifact/Blocks. |
| 4 | **"### 3. Validate the flow keeps vibe's guarantees"** — andon via `AskUserQuestion` for dropped invariants; confirm testing-gate level matches domains; thin-lead check on consolidation owner slot | build-flow.md:83-88 | **DELETE** — this is precisely the LLM-judged machinery migration-plan.md:166 names for removal. |
| 5 | **"Invariants you must preserve"** (8 items: thin lead, dispatch protocol, context discipline, testing gate, gates-before-build, behavior coverage, one-team+teardown, Platform→BE→FE order) | build-flow.md:54-66 | **split** — #1 thin lead, #2 dispatch protocol, #3 context discipline, #4 testing/exit gate, #7 teardown are now **structural** (command-skeleton.md Role ¶ + step 1 Clock-in + step 4 Clean-state exit gate + step 5 Finalize teardown — FIXED, uncuttable). #5 gates-before-build, #6 behavior coverage, #8 block order are **NOT** skeleton-enforced — block ordering "lives HERE [FLOW slot], never baked into the skeleton" (command-skeleton.md:19) — so these become the flow-**spec author's** responsibility (BLOCKS' entry-gate/exit-lens fields), unchecked mechanically by build-flow. Migration-plan §6 independently confirms Platform→BE→FE moves to plan/preset, not implement (harness-builder.md:113). |
| 6 | "You lift invariant sections from `spec.md`/`plan.md`/`implement.md` **verbatim, at generation time**... You do not paraphrase a guarantee; you copy it." | build-flow.md:20 | **merge, mechanism swapped** — principle survives (never paraphrase a guarantee) but source swaps from base-command prose to command-skeleton's FIXED sections + kernel-skill-by-reference; nothing left to "lift" from spec/plan/implement since those aren't read at flow-compile time. |
| 7 | Interactive interview: sketch from `$ARGUMENTS` → map to catalog → `AskUserQuestion` rounds for slots (name/domains/fan-out/consolidation/fix-mode/commit) | build-flow.md:11,72,89-93 | **contradiction, flagged not resolved** — see §5 C1. flow-skeleton.md:8 implies the flow-spec is filled *before* build-flow runs ("You (or `/vibe:distill`) fill the `{{SLOTS}}`... `/vibe:build-flow` compiles it"), i.e. build-flow becomes a pure compiler, not an interviewer. |
| 8 | Name-collision guard: `AskUserQuestion` overwrite-or-rename if target exists; avoid names shadowing a base command | build-flow.md:122 | **merge, subsumed** — build-harness's "edit marker governs overwrite" hard constraint (build-harness.md:26) already makes re-stamp safe generically (upgrade unmodified sections, surface user edits, never overwrite). Keep only the collision-**avoidance** sub-rule, updated to the v2 command inventory (avoid shadowing `build-harness`/`build-flow`/`distill`, not the deleted `spec`/`plan`/`implement`/`feature`/`adopt`). |
| 9 | "Report... the file written; phases delegated/inlined; roster; review fan-out+combine; testing-gate level; any `⚠️ weakened guarantee` accepted." | build-flow.md:127-129 | **rewrite** — report shape survives minus "delegated/inlined" (dead per row 3) and minus "weakened guarantee" (dead per row 4, no more andon-accepted weakenings — flow-spec either compiles or the author fixes it). |
| 10 | Hard boundaries: never touch project source, only writes the generated command; never runs the generated flow | build-flow.md:17-19 | **keep contract, rewrite phrasing** — content is command-standard rule 7's canonical boundary sentence target; v1's bullet-list phrasing ("Hard boundaries.") must become the verbatim sentence form. |

**10 disposition rows, 2 verbatim contracts carried forward** (#1 write-target, #10 boundary content — reworded to canonical form, not literal text).

## 3. Flow-spec → fills derivation map

flow-skeleton.md's own closing comment (line 38) claims all of command-skeleton's fills derive from 4 spec sections + the spec's own frontmatter/path. Verified, field by field:

| command-skeleton fill | Derived from (flow-spec) | Flow-specific bit a preset doesn't have |
|---|---|---|
| `{{DESCRIPTION}}` | flow-spec's own `{{DESCRIPTION}}` frontmatter (copied) | — |
| `{{ROLE_SUMMARY}}` | `## Team` + `## Artifact` (team + artifact driven, prose) | — |
| `<named artifacts>` | `## Artifact` (single file — the *only* file the generated command may Edit/Write) | flows are **single-artifact**; presets may name a plan+ledger pair |
| `{{FLOW}}` | `## Blocks` (ordered, each: roster/entry gate/exit lens/fix-routing) | **custom lens names**: exit lens may be an arbitrary checklist skill (`security-review`, not just `<domain>-review`) — flow-skeleton.md:25 explicitly allows this; presets are constrained to the fixed domain checklists build-harness pre-seeds |
| Role paragraph worktree note | `## Team`'s optional ` · worktree` suffix (flow-skeleton.md:14) | **not present in v1 build-flow at all** (grepped, zero hits) — this is a v2-only capability introduced by flow-skeleton; no runtime `--worktree` flag, decided at generation time only |
| Block fix-routing clause | Per-block "Fix-routing" line in `## Blocks`, may target **a standing role spawned in an earlier block without re-listing it in the roster** (flow-skeleton.md:26) | **standing-role cross-block targeting** is flow-specific — a preset's fix-routing is local to its own fixed two-role split (test-code→test-engineer, prod-code→engineer), never needs to reach back across blocks |
| `{{OPT_OUTS}}` | `## Opt-outs` (comma-separated FIXED-section names or Finalize sub-items) | — |
| `{{PRESET}}` / `{{FLOW_SPEC}}` | constant `flow` / the flow-spec file's own resolved path | build-harness fills the inverse (`{{PRESET}}`=preset dir, `{{FLOW_SPEC}}` empty) — build-flow's regen stamp is the mirror image |

**8/8 fills derivable — skeleton's own claim holds**, no gap found. All builder-facing annotations (`<!-- BUILDER… -->`, `Fill:`/`Discover:` comments, examples) strip per composition rule W-E.

## 4. Deltas from build-harness's pipeline

Per harness-builder.md:76-80 and migration-plan.md:166, build-flow does **NOT**: parse a natural-language roster (the flow-spec's `## Team` is already a resolved role list, not prose to interpret), run audit scouts (no `.claude/` state to survey — flow-spec fully specifies what's needed), emit or maintain a `.workspace/…/checklist.md` (single artifact = the flow-spec, no ledger-of-artifacts), or offer doctor mode (no "re-audit rows OK/MISSING" — `--regen` is a single-file recompile, not a diff-and-upgrade pass over many stamped files). Design doc confirms: build-harness's §3 is a 4-stage pipeline (parse→audit→checklist→build+doctor); §4's build-flow description names none of those stages, only "generate... from the same skeletons." **REC**: build-flow's Outline should be ~3 steps (resolve flow-spec → compile via composition spec → write + report), not build-harness's ~7.

## 5. Contradictions

| # | Design doc / skeleton | v1 | REC |
|---|---|---|---|
| C1 | flow-skeleton.md:8 — a flow-spec is filled by "You (or `/vibe:distill`)" *before* build-flow compiles it; build-flow.md:76 names build-flow "the compiler" | v1 build-flow interviews the user directly from a free-text sketch (`$ARGUMENTS`), no separate flow-spec file exists | **REC**: build-flow does both, sequenced — if `$ARGUMENTS` is a sketch (no flow-spec path resolves), interview + materialize a `flow-skeleton`-shaped file under `.workspace/flows/<slug>/flow-spec.md` first, *then* compile it; if `$ARGUMENTS` names an existing flow-spec, skip straight to compile. This preserves v1's sketch UX without making build-flow non-deterministic — the materialize step is interview (like spec-plan-implement's decompose), the compile step is the deterministic W-A..H pass. Flag for the author to confirm against harness-builder.md before committing — this is a genuine judgment call §0 doesn't cover. |
| C2 | build-harness.md:69 states the composition spec (W-A..H, stamp map, `<named artifacts>`, regen-stamp fill) applies to "every command/**flow** stamp" | The rules live inline in the *already-`passing`* `commands/build-harness.md` (leaf 4.1), not in a shared location build-flow can reference without a command→command dependency | See §6 below — **REC (b)**, requires a small mechanical edit to a passing leaf. |
| C3 | Row 5 above: invariants #5/#6/#8 (gates-before-build, behavior coverage, block order) have no structural (skeleton-fixed) enforcement in v2 | v1 enforced all 8 invariants via LLM judgment in step 3 (now deleted) | **REC**: not a defect to fix in build-flow — it's the accepted tradeoff harness-builder.md:59 describes ("that soft enforcement is exactly what gets replaced"). No mechanical replacement exists for ordering/coverage checks; they are the flow-spec author's responsibility via the Blocks' entry-gate/exit-lens fields. Worth one explicit line in build-flow.md's Role or Outline so this isn't silently dropped from institutional memory — not a re-implementation of the judgment. |

**3 contradictions**, none resolved here per task instructions.

## 6. Composition-sharing recommendation (mine)

**REC: (b) — extract to `standards/composition-standard.md`**, referenced by both `build-harness.md` and `build-flow.md`.

- Matches the repo's existing pattern exactly: `standards/command-standard.md` and `standards/agent-standard.md` already hold mechanical, multiply-consumed rules (author + reviewer + builder-audit all read them) rather than living inline in one producer. The composition spec (W-A..H, stamp-target map, `<named artifacts>`, regen-stamp fill) is the same shape of artifact — mechanical, checkable, needed verbatim-identically by two producers.
- The byte-identical mandate (build-harness.md:23, "two builders stamping the same project from the same templates MUST produce byte-identical output") makes (c) duplicate actively dangerous: any future W-rule fix (e.g. a 9th composition rule) must land in two places in lockstep or the two commands silently diverge — exactly the "3 places" failure harness-builder.md:112 names as an audit finding to fix, not repeat.
- (a) command→command reference is fragile for a different reason: both `build-harness.md` and `build-flow.md` are hand-authored plugin-entry commands (build-harness.md:5 — "NOT stamped from command-skeleton.md"), so a reference from one to the other's internal section numbering (`build-harness.md:69-83`) breaks silently the moment either file is edited — no template-header/version mechanism catches command-internal drift the way it catches template drift.
- Cost: a **mechanical edit to the already-`passing` leaf 4.1** — replace build-harness.md's inline composition spec (~L69-83) with a reference to the new standard, re-run its standard-audit, no content change. This is small and the ledger's own precedent (2.1 architect.md, disposition row "consolidation rule → pointer at team-protocol") already normalizes "point an already-accepted file at a newly-extracted shared home." Flag to orchestrator as a scope note, not a blocker.

## 7. Budget

`command-standard.md` rule 1: entry command files 50-200 lines; build-flow classifies as an entry command (no repeat/until loop over a ledger at its own top level — the loop lives inside the *generated* command, per row 4 §4 above), same class as build-harness (112 lines, passing). Given the §4 delta (no parse/audit/checklist/doctor stages — build-flow's job is materialize-or-resolve → compile → write/report, roughly a third of build-harness's stage count) and the composition-spec REC moving W-A..H out of both files into a shared standard (net removal from both):

**REC: 70-100 lines** — well below build-harness's 150-180, reflecting the narrower pipeline; upper end if C1's materialize-when-given-a-sketch path is kept, lower end if build-flow is scoped to compile-only per flow-skeleton.md:8's literal reading.
