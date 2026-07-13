# Migration Plan: vibe → Harness Builder

**Status:** ready to execute.
**Date:** 2026-07-13
**Source of truth for the target design:** `docs/harness-builder.md`. Research backing: `docs/harness-improvement-plan.md`.
**Prime directive:** the plugin stays usable at every phase boundary. Nothing is deleted until the builder has replaced it *and* both live projects run on generated harnesses (Phase 5 gate). Tag `v1-final-harness` before Phase 1 so the old world is always one checkout away.

---

## 0. Decisions (resolving harness-builder.md §9)

These were open questions; the plan proceeds on these answers:

1. **Ordering: kernel-first.** The builder is a stamping machine; it needs finished templates before it can stamp. Phases 1–3 build the material, Phase 4 builds the machine, Phase 5 validates, Phase 6 deletes.
2. **Preset fidelity: rewrite, don't port.** `implement` preset is rewritten around the task-ledger state machine (target ≤80 lines; today 174). `plan` preset keeps its skeleton but its Tasks section is replaced by the ledger schema. `spec` survives mostly intact (it's already lean). `feature` is not ported — it was a thin wrapper; the fullstack preset covers its use case.
3. **Validation = the two live projects.** Tech backend gets the `plan-implement` preset; fullstack app gets `spec-plan-implement`. Migration is done only when both run real work on generated harnesses and the hand-copied monorepo harness is retired.
4. **Checklist format: task-ledger schema, not adopt's format.** `/vibe:build-harness` writes `.workspace/harness/checklist.md` using the same leaf schema as the ledger (`behavior / verification / state / evidence`, closed enum). The builder eats its own dog food, and the checklist is resumable for free because resume semantics are the ledger's semantics.
5. **Plugin-resident at runtime:** only `/vibe:build-harness`, `/vibe:build-flow`, `/vibe:distill`. Everything else executes from the project's own `.claude/`.

Additional fates not covered by the design doc's §6 table:

| Item | Fate |
|---|---|
| `CHECKLIST.md` (the adopt contract) | Absorbed: its artifact list becomes pre-seeded rows in the builder's checklist template; the file is deleted in Phase 6 |
| `workspace-starter/` (9 sample/template files) | Moves to `templates/workspace/`; the builder stamps these instead of adopt copying them |
| `_ref/` | Stays as-is; reference material, not shipped behavior |
| `plan-template.md` Tasks table | Replaced by the task-ledger schema (Phase 1) |

---

## 1. Target repo layout

```
vibe/
├── .claude-plugin/            plugin.json (v2), marketplace.json
├── commands/                  build-harness.md, build-flow.md, distill.md   ← only 3
├── templates/
│   ├── kernel/                task-ledger.md, research-protocol.md,
│   │                          team-protocol.md, review-protocol.md
│   ├── agents/                architect.md, critic.md, engineer.md, reviewer.md,
│   │                          test-engineer.md, qa-engineer.md, codebase-researcher.md,
│   │                          product-manager.md, product-designer.md
│   ├── skeletons/             command-skeleton.md, flow-skeleton.md
│   ├── checklists/            review-backend.md, review-frontend.md, review-generic.md
│   └── workspace/             (from workspace-starter/) plan, spec, research templates + samples
├── presets/
│   ├── plan-implement/        plan.md, implement.md
│   └── spec-plan-implement/   spec.md, plan.md, implement.md
├── standards/                 agent-standard.md, command-standard.md
├── docs/                      harness-builder.md, harness-improvement-plan.md, migration-plan.md
└── SIMPLIFICATION-LOG.md
```

Every file under `templates/`, `presets/`, and generated into a project carries a header:

```
<!-- vibe-template: kernel/task-ledger v1 | generated 2026-07-13 | edits below the marker are yours -->
```

This is what makes the re-stamp/upgrade diff (§8 of the design doc) possible later. The header convention is defined once in `standards/command-standard.md`.

---

## 2. Execution protocol — migration is rewriting, not moving

The biggest quality risk in this plan is silent porting: copying v1's stale or over-complicated instructions into v2 directories and calling it migration. That would launder the bloat into a nicer layout. The countermeasure: **the old file is evidence about intent, never a draft.** Every artifact that carries content forward (kernel template, agent template, preset, checklist) must pass this pipeline. The goal is a high-quality builder — deleting most of a source file is a success outcome, not a loss.

**Step 0 — classify.** At the start of each phase, tag every source file `verbatim / shrink / rewrite`. Expected distribution: `verbatim` = `research-protocol` only (27 lines, already proven lean); everything in `commands/` = `rewrite`; agents mostly `shrink`. A `verbatim` tag must be justified, not assumed.

**Step 1 — intent extraction.** List every instruction in the source file with three annotations (Lecture 4's rule metadata): *what failure does it prevent* / *still applicable, or compensating for a weaker model or a project shape we no longer target* / *where it belongs* (this file, kernel, mechanized check, or deleted). An instruction with no nameable failure it prevents is **deleted by default** — the burden of proof is on the instruction, not on the deleter.

**Step 2 — fresh rewrite.** Author the v2 artifact from scratch, from: the job it must do + the Phase 0 standards + the course's canonical templates where one exists (evaluator-rubric, clean-state-checklist, session-handoff, maker/checker prompts, goal/loop templates). Only then consult the old file — to check the fresh draft didn't miss a hard-won rule (recognizable by the concrete failure named in Step 1).

**Step 3 — cold review.** A reviewer with no author context (fresh session or dispatched agent) scores the draft with the P4 rubric — 0–2 on: correct, minimal, unambiguous, within size budget, no duplication with kernel, mechanizable-parts-mechanized → `Accept / Revise / Block`, findings in what/why/fix. This dogfoods the review protocol on the harness builder itself before any project sees it.

**Step 4 — disposition record.** Append to `docs/migration-log.md`: per source file, the fate of every instruction — `kept / rewritten / moved-to-kernel / mechanized / deleted (+why)`. This is what makes aggressive deletion safe: nothing drops silently, the Phase 6 pre-delete diff-check becomes a lookup instead of an archaeology dig, and the deleted entries seed `SIMPLIFICATION-LOG.md`.

Two tripwires, applied to ourselves:
- A rewrite landing at **>70% of the source's line count** is presumptively a port — redo Step 1.
- **Two consecutive `Block` verdicts** on the same artifact → stop patching, redo from scratch (our own no-progress stop condition).

### Orchestrated execution

This plan is executed by an orchestrator session end-to-end, on a single green light from the user. The migration runs on the same kernel rules it is building — it is the first real workload of the vibe 2.0 discipline.

**The orchestrator never authors, never reviews, and never reads full source files.** Its context is reserved for: the ledger, dispatch briefs, verdicts, and decisions. All content work is delegated:

| Role | Who | Gets | Returns |
|---|---|---|---|
| Intent scout | subagent (sonnet) | one source file + the Step 1 questions | disposition table (instruction → failure-prevented / applicability / destination) |
| Author | subagent (opus), fresh context | job description + Phase 0 standards + scout's disposition table + course template refs — **not** the raw source file | the v2 artifact draft + a self-declared line count vs. source |
| Cross-checker | subagent (sonnet) | draft + original source file | list of hard-won rules present in source, absent in draft (each tied to a named failure) — feeds one revision |
| Cold reviewer | subagent (opus), fresh context, no author material beyond the draft | draft + standards + rubric | `Accept / Revise / Block` + what/why/fix findings |
| Scribe duty | folded into author's brief | — | appends the artifact's rows to `docs/migration-log.md` |

No fable subagents (standing constraint). Author and cold reviewer must never be the same agent or share context — the cold review is only cold if the reviewer hasn't seen the reasoning.

**State lives in a migration ledger**, `.workspace/migration/ledger.md`, created on green light from the §3 phase checklists — one leaf per artifact/item, in the task-ledger schema (`behavior / verification / state / evidence`). WIP=1: one artifact in flight at a time within a phase (independent scouts may run ahead in parallel — scouting is read-only). Only the orchestrator flips a leaf to `passing`, and only citing the cold reviewer's `Accept` plus the phase's mechanical check (line budget, file exists, standard-audit pass).

**The orchestrator stops and asks the user only when:**
1. A finding contradicts `docs/harness-builder.md` — design flaws are the user's call; the design doc gets amended first.
2. A decision arises that §0 doesn't cover and both options are defensible (a judgment call with no recorded principle deciding it).
3. **Phase 5 entry** — validation runs on the user's live projects; the orchestrator hands over stamped harnesses and instructions, the user runs real work, results come back before Phase 6.
4. Anything destructive beyond the plan's recorded scope.

Everything else — including deleting large amounts of v1 prose — is inside the mandate and proceeds without asking.

## 3. Phases

Each phase is one reviewable diff with a verification step. Every checklist item below that migrates content executes via the §2 pipeline. Per the course's audit discipline: **use the plugin on a real task between phases** — don't stack two phases without contact with reality.

### Phase 0 — Prep & hygiene (small, zero-risk)

- [ ] `git tag v1-final-harness`.
- [ ] Fix README drift: engineer model (README says sonnet, file says opus — pick one and align), command count, add `build-flow` to the inventory.
- [ ] Create empty target directories + `SIMPLIFICATION-LOG.md` (seeded with its purpose statement).
- [ ] Write `standards/command-standard.md` v0: size budgets (entry files 50–200 lines), constraints top/bottom, template-header convention. Written first because every later phase is judged against it.
- [ ] Write `standards/agent-standard.md` v0: description size budget, role-boundary statement, done-format reference, model/effort declaration rules.

**Verify:** README matches reality; standards exist; `wc -l` budgets recorded as the baseline.

### Phase 1 — Kernel extraction

Build `templates/kernel/` — the four default-on components. Source material exists; this is merge + dedupe + upgrade, not greenfield.

- [ ] **`task-ledger.md`** (new; from design doc §5 + improvement plan P1/P2): leaf schema (`behavior / verification / state / evidence`), closed enum `not_started | active | blocked | passing`, `passing` irreversible, WIP=1, orchestrator-only transitions against reviewer-cited evidence, numeric stop conditions (max rounds + no-progress detection), round log format, decision-log + handoff sections (P5), two-level verification rule.
- [ ] **`research-protocol.md`**: near-verbatim from `skills/vibe-research-protocol/SKILL.md` (27 lines, best artifact in the plugin — do not "improve" it).
- [ ] **`team-protocol.md`**: merge `vibe-team-communication-protocol` + `vibe-team-orchestration` (77+33 lines → target ≤70). Kill the duplicated idle-run rule; single-source the consolidation rule here (removing it from `architect.md` and `build-flow.md` happens in Phases 2/4).
- [ ] **`review-protocol.md`**: `vibe-review-discipline` three-pass method + P4 upgrades — 0–2 rubric across 6 dimensions → `Accept / Revise / Block`, every finding as what (file:line) / why / fix, "not finding problems is your failure" framing.
- [ ] Replace the Tasks table in `templates/workspace/plan-template.md` (moved from workspace-starter) with the ledger schema.

The existing `skills/` directory is **not deleted yet** — current commands still reference it. Kernel templates are the new source of truth; skills become frozen copies until Phase 6.

**Verify:** four kernel files exist, each within size budget; a diff-review confirms no protocol content was lost in the merge (the merge is lossy only for duplicates).

### Phase 2 — Agent template library + checklists

- [ ] Move the 9 agents to `templates/agents/`, converting each into a template: explicit placeholders for project facts (stack, verification commands, domain checklist reference), model/effort kept as defaults the builder may override.
- [ ] Audit each against `standards/agent-standard.md`; delete the restated stance paragraphs in `critic.md` and `qa-engineer.md` (near-verbatim duplicates of their skills — the kernel reference replaces them).
- [ ] Inline `vibe-manual-testing` skill into the `qa-engineer` template (single consumer).
- [ ] `reviewer.md` template: point verdict format at `kernel/review-protocol.md`; add "run mechanized checks before prose review" step (P6).
- [ ] Author `templates/checklists/`: `review-generic.md` (from `workspace-starter/review-checklist-sample.md`), plus `review-backend.md` and `review-frontend.md` skeletons the builder fills with stack findings from its audit step. Per-component: the builder emits one review checklist per detected component, not one global pair.
- [ ] Author `templates/workspace/architecture-skill.md` — per-component architecture doc/skill template; the builder pre-seeds one `<component>-architecture` row per detected component (user addition, D7b).
- [ ] Author `templates/scripts/` — deterministic environment scripts: env-up + test-run templates, self-verifying (course P06 `init.sh` pattern), plus an environment skill template that names them. Agents get ONE sanctioned way to spin the env and run tests; review-protocol's Pass 3 verification runs through it (user addition, D7c).

**Verify:** every agent template passes the agent-standard audit (this audit procedure is itself the one build-harness will run — write it once, reuse it); no agent references a skill slated for deletion except via kernel paths.

### Phase 3 — Skeletons + presets

- [ ] **`templates/skeletons/command-skeleton.md`** — the structural-inheritance mechanism, the most load-bearing new file. Fixed literal sections the builder cannot omit: clock-in (read ledger + handoff + decision log), kernel references (research/team/review protocols), clean-state exit gate (P3: build passes / all tests incl. pre-existing / ledger accurate / no stale artifacts / startup works — verified by command output), teardown, handoff write-out. One marked slot for the flow-specific middle. Opt-outs require an explicit `opt-out:` frontmatter line naming the section — absence of a section with no opt-out line = generation bug.
- [ ] **`templates/skeletons/flow-skeleton.md`** — same kernel sections, lighter middle, for ad-hoc flows (strangler-fig etc.).
- [ ] **`presets/plan-implement/`** — rewrite `plan.md` (ledger-schema Tasks, architect authors per-task verification, decision-log section, block/domain ordering decided here per-plan — removing the hardcoded Platform→BE→FE from implement) and `implement.md` (≤80 lines: clock-in → WIP=1 dispatch loop over ledger → review gate with rubric → evidence-gated state flip → stop conditions → clean-state gate → handoff). Both instantiate the command skeleton.
- [ ] **`presets/spec-plan-implement/`** — the above plus `spec.md` (mostly today's file, restyled onto the skeleton; PM + product-designer roles).
- [ ] Old `commands/{spec,plan,implement,feature}.md` remain untouched and functional.

**Verify:** dry-run one preset by hand on a toy task in this repo (e.g., a docs change driven through plan-implement) — confirms the ledger loop and clean-state gate are executable instructions, not aspirations. `implement.md` line count ≤80.

### Phase 4 — The builder commands

- [ ] **`commands/build-harness.md`** — the flagship. Pipeline per design doc §3:
  1. Parse intent → desired roster + commands.
  2. Audit via scout subagents (builder's own context stays clean): existing `.claude/`, stack facts, verification commands, existing conventions.
  3. Emit `.workspace/harness/checklist.md` in ledger schema; kernel components pre-seeded as rows; gaps become rows (missing agents, missing domain checklists, agent descriptions failing the standard).
  4. Build against the checklist from `templates/` + chosen preset, stamping into the project's `.claude/` with template-version headers; flip rows to `passing` with evidence (file path + standard-audit pass).
  - Re-run = **doctor mode** (P6): re-audit each checklist row OK/MISSING, diff stamped-but-unmodified sections against current templates, propose upgrades, never overwrite user-modified sections; finish with the fresh-session test (can a scout answer what-is-this / how-to-run / how-to-verify / what's-unfinished from repo contents alone?).
- [ ] **`commands/build-flow.md`** — repoint: generate into the project's `.claude/commands/` from `flow-skeleton.md`. Delete the LLM-judged "validate guarantees are preserved" step — inheritance is now structural. Remove its copy of the consolidation rule.
- [ ] **`commands/distill.md`** — add the promotion rung: when a distilled learning is kernel-grade (would apply to any project), emit a proposed diff against the plugin's `templates/` instead of only writing project-local skills.
- [ ] Both builder commands are themselves written against `standards/command-standard.md` and the skeleton discipline (the builder obeys its own kernel).

**Verify:** run `/vibe:build-harness` on this repo itself or a scratch project; confirm checklist created, harness stamped, doctor mode idempotent (second run reports all-OK, changes nothing).

### Phase 5 — Validation on the live projects (the real gate)

- [ ] **Tech backend:** `/vibe:build-harness` with the `plan-implement` preset. Run one real feature end-to-end on the generated harness.
- [ ] **Fullstack app (monorepo):** build with `spec-plan-implement`. Run one real feature. **Retire the hand-copied harness** — delete it in that repo once the generated one has shipped work.
- [ ] Confirm the original failure modes are gone: works on Claude web (files are in-repo), works in the monorepo (no plugin path resolution).
- [ ] Feed friction back: every rough edge found here is fixed in `templates/`/`presets/` (not patched in the stamped project), then re-stamped via doctor mode — this exercises the upgrade path for real.

**Verify:** both projects shipped at least one feature on generated harnesses; monorepo hand-copy deleted; doctor mode re-stamp performed at least once successfully.

### Phase 6 — Deprecation & cleanup (only after Phase 5 passes)

- [ ] Delete `commands/{adopt,spec,plan,implement,feature}.md`.
- [ ] Delete `skills/` (all six — kernel templates are the source; manual-testing already inlined).
- [ ] Delete `CHECKLIST.md` and `workspace-starter/` (absorbed per §0).
- [ ] Rewrite `README.md` for vibe 2.0: what the builder is, the 3 commands, kernel philosophy, preset list, upgrade/doctor story.
- [ ] Bump `plugin.json` to 2.0.0; note breaking changes.
- [ ] First entry in `SIMPLIFICATION-LOG.md`: record the constraints deleted during migration and why, establishing the practice (P7).

**Verify:** fresh checkout + fresh session test on the plugin repo itself: a scout can answer what-is-this / how-to-use from README + repo alone. `find commands -type f | wc -l` → 3.

---

## 4. Course best-practices traceability

Every adopted practice from the Learn Harness Engineering research (`docs/harness-improvement-plan.md`) has a home in a phase — check this table when reviewing each phase's diff:

| Course practice | Source | Lands in |
|---|---|---|
| Task schema: behavior / verification / evidence, closed state enum | L7, L8; P1 | Phase 1 `kernel/task-ledger.md` |
| Evidence-gated transitions; orchestrator-only `passing`; engineer never self-approves | L9; P1 | Phase 1 ledger + Phase 3 implement preset |
| WIP=1 (87.5% vs 37.5% completion data) | L7; P2 | Phase 1 ledger + Phase 3 implement preset |
| Numeric stop conditions + no-progress detection + round log | L13; P2 | Phase 1 ledger |
| Clean-state exit gate (build/tests/ledger/artifacts/startup, command-verified) | L12; P3 | Phase 3 command-skeleton (fixed section) |
| Review rubric 0–2 × 6 dims → Accept/Revise/Block; what/why/fix findings | L10, L11; P4 | Phase 1 `kernel/review-protocol.md` |
| Decision log + session handoff (kills re-litigation on resume) | L5; P5 | Phase 1 ledger sections; skeleton clock-in/out |
| Mechanized checks before prose review; harness doctor; fresh-session test | L10, L12; P6 | Phase 2 reviewer template; Phase 4 doctor mode |
| Prompt calibration: entry files 50–200 lines, constraints top/bottom | L4; P7 | Phase 0 standards; enforced by build-harness audits |
| Simplification log (delete constraints models outgrow) | L4/L12; P7 | Phase 0 file; Phase 6 first entry; §4 opt-out demotion rule |
| Repo as system of record — harness lives in the project's repo | L3 | The whole architecture (Phase 4/5) |
| Context discipline for the orchestrator (scouts read, lead decides) | L4/L5 | Phase 4 build-harness audit step |
| Audit discipline: real-world use between changes | L12 | Rule at top of §3; Phase 5 as hard gate |
| Rule metadata (source / applicability / expiry); delete-by-default | L4 | §2 execution protocol, Step 1 |

Consciously **not** adopted (with reasons recorded in the improvement plan §4): JSON state files, OpenTelemetry traces, high-throughput merge, cron/fleet loops. If someone proposes one of these later, read that section first.

## 5. Effort & sequencing notes

- Phases 0–1 are one sitting each. Phase 2 is mechanical but wide (9 files). Phase 3 contains the two hardest writing tasks (command-skeleton, implement preset rewrite) — budget the most care there; everything downstream inherits their quality. Phase 4 is large but well-specified by then. Phase 5 is calendar time, not effort — it rides on real project work.
- Dependency chain is strict: 1 → 2 → 3 → 4 → 5 → 6. Within phases, checklist items are parallelizable.
- If anything in Phase 5 reveals a design flaw (not a template bug), stop and amend `harness-builder.md` first — the design doc stays the source of truth.

## 6. Risks

| Risk | Mitigation |
|---|---|
| Skeleton's "fixed sections" too rigid for some flow | Opt-out frontmatter is the pressure valve; if a section is opted out of in >half of generated flows, it wasn't kernel — demote it (log in SIMPLIFICATION-LOG) |
| Preset rewrite loses a hard-won edge case from old implement.md | §2 Step 1 dispositions every instruction up front; Phase 6 pre-delete check is a lookup in `docs/migration-log.md`, not archaeology |
| Migration silently ports v1 bloat into v2 | §2 pipeline: zero-based rewrite, >70%-of-source-lines tripwire, cold review with Block verdicts |
| Builder generates plausible-but-broken harnesses | The checklist's `verification` field forces per-row evidence; doctor mode + fresh-session test are the backstop |
| Drift across stamped projects | Version headers + doctor-mode diff (exercised for real in Phase 5) |
