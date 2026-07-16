# vibe 2.0 — Harness Builder (Design Doc)

**Status:** executed and shipped as plugin v2.0.0 (2026-07); migration record in `.workspace/migration/ledger.md`.
**Date:** 2026-07-13
**Companion doc:** `docs/harness-improvement-plan.md` (research digest from the Learn Harness Engineering course — its P1–P8 improvements fold into this design as *template properties*, see §7).
**Next step:** done — `docs/migration-plan.md` was produced and executed; only live-project validation (migration Phase 5.1) remains.

---

## 1. The decision

**vibe stops being a harness and becomes a harness builder.** The plugin no longer ships universal runtime commands that every project calls; it ships **templates, standards, and a builder** that generates a self-contained, project-specific harness into each project's own `.claude/` directory.

### Why (observed, not theoretical)

1. **The plugin-as-runtime distribution model fails in practice.** Claude web doesn't fetch the plugin on other projects; the monorepo breaks path resolution; the real-world workaround has always been the same — hand-copy the harness into the project. This matches the course's Lecture 3 thesis: *the repository must be the system of record; information outside the repo doesn't exist for the agent.* A plugin is by definition outside the repo.
2. **`/vibe:adopt` doesn't serve real needs.** It tries to make the project conform to the plugin's contract. In practice the owner rebuilds the harness per project instead. The inversion is correct: build a harness that conforms to the project.
3. **Universal commands accumulate edge-case bloat.** `implement.md` is 174 lines largely because one file must handle every project shape at runtime (spec-or-no-spec, worktree-or-not, QA-or-not, Platform→BE→FE ordering). Conditionals added at different times is where "explained several times, with conflicts" comes from. A generator makes those decisions **once, at generation time** and emits lean, linear commands with zero dead branches — this is where determinism/predictability actually comes from (fewer branches an LLM can take wrongly), not from having fewer files.
4. **Actual usage already voted.** On the live projects, `/vibe:plan` and `/vibe:implement` are no longer called directly; custom flows are built via `build-flow` (e.g., a strangler-fig refactoring flow for a legacy API). What *is* reused every time: research protocol, communication protocol, orchestration, task management. Flows are specific; the kernel is universal. The repo layout must catch up with this reality.
5. **Two real usage profiles exist today** and a single universal pipeline serves neither cleanly:
   - Tech backend: plan → implement only ("PRI").
   - Fullstack app: spec → plan → implement (full product cycle).

### What this is NOT

- Not "kill all skills and rebuild." An audit (2026-07-13) showed skills are the **lean** part: 311 lines total across 6 skills, mostly load-bearing; `vibe-research-protocol` (27 lines, referenced by all 9 agents) is the single highest-leverage file. The bloat's center of mass is `commands/` (757 lines, 2.4× the skills). Skills survive as kernel templates.
- Not a greenfield rebuild. `CHECKLIST.md` (the contract) and `/vibe:build-flow` (the command composer) are proto-versions of the two halves of the builder. This is a refactor of intent.

---

## 2. Target architecture: kernel + compiler

```
plugin (vibe)                              project (generated, in-repo)
├── kernel templates (default-on)         .claude/
│   ├── task-ledger                        ├── skills/    ← stamped kernel + project skills
│   ├── research-protocol                  ├── agents/    ← generated from agent templates
│   ├── team-protocol                      └── commands/  ← generated, lean, linear,
│   └── review-protocol                                     kernel inherited structurally
├── agent template library (the 9 agents)
├── standards & checklists (agent-description standard,
│   command standard, domain review checklists)
├── flow/command skeletons (fixed kernel sections)
├── presets (plan→implement; spec→plan→implement; …)
└── commands: /vibe:build-harness, /vibe:build-flow, /vibe:distill
```

### Kernel — default-on, explicit opt-out only

Every generated harness includes these unless the user *explicitly* opts out; they appear in every generated checklist automatically:

- **Task ledger** (see §5) — task schema, evidence-gated states, WIP=1, stop conditions.
- **Research protocol** — the context-discipline ladder (cited map → codegraph → Explore → codebase-researcher). Keep near-verbatim; it is the plugin's best artifact.
- **Team protocol** — SendMessage done-format, andon cord, role boundaries, plus spawn/dispatch/fan-out/teardown mechanics. Communication and orchestration/teardown were merged into this one file (audit: the two always co-referenced and duplicated the idle-run rule).
- **Review protocol** — three-pass method + rubric verdict format (see §7).

**Inheritance is structural, not judged.** Generated commands/flows come from skeletons whose kernel sections are literal fixed template text the builder *cannot omit* — only the flow-specific middle is authored per need. Today build-flow "validates guarantees are preserved" via LLM judgment; that soft enforcement is exactly what gets replaced. A generated flow cannot silently drop the andon cord or the research ladder; opt-out means the user said so, never that the generator forgot.

---

## 3. Flagship command: `/vibe:build-harness`

Serves prompts like: *"Create a harness for this project. Implementation: architect, critic, engineer, test-engineer, reviewer, manual QA. PM + product designer for specs. Two commands: planning (design + product thinking + technical planning) and implementing (per-block reviews, task split)."*

Pipeline:

1. **Parse intent** — desired team roster and desired commands from the user's natural-language description.
2. **Audit** — scout the project's existing state: `.claude/` contents, existing skills/conventions, stack facts, verification commands. (Scouts are subagents; the builder's own context stays clean — kernel discipline applies to the builder itself.)
3. **Emit the checklist** — the gap analysis IS the implementation roadmap: agents to add, domain review checklists missing (e.g., backend code-review checklist, frontend code-review checklist), existing agent descriptions to audit against the description standard (size budget, role boundary, done-format — bloat caught at generation time, not discovered later). Kernel components are pre-seeded rows.
4. **Build against the checklist** — generate agents, skills, and commands into the project's `.claude/` from templates. Everything in-repo → works on Claude web, in monorepos, and for anyone who clones the repo.

The checklist is persistent state (resumable, reviewable) — same pattern adopt used, inverted in direction.

## 4. Second command: `/vibe:build-flow` (retained, repointed)

For ad-hoc, task-shaped needs — strangler-fig refactor, slice extraction, one-off migrations. Generates a lean, linear, project-local flow from the same skeletons with the same structural kernel inheritance. Flows are allowed to be opinionated, specific, and disposable; the kernel is not.

**Presets:** today's `spec`/`plan`/`implement` are demoted from universal commands to **reference presets** the builder instantiates. The backend project stamps plan→implement; the fullstack app stamps spec→plan→implement; each diverges freely afterward. Neither carries the other's edge cases. Generated commands land under `HARNESS_ROOT/commands/<prefix>/` (default prefix `dev` → `/dev:plan`, `/dev:implement`, …; `--prefix none` for unprefixed) so they don't collide with host builtins that share the bare name.

---

## 5. Task ledger (kernel component, answers "what is a task")

Two-level hierarchy is fine and matches current practice (plan → feature → subtasks, e.g., a feature with 3 API endpoints + UI components). Hierarchy depth is not the point; the **leaf** unit is:

- **Sizing rule:** completable in a single session (course guidance).
- **Leaf fields (mandatory):** `behavior` (user-visible outcome) / `verification` (executable command(s), not prose) / `state` / `evidence` (append-only: commit hash + test output ref).
- **Closed state enum:** `not_started | active | blocked | passing`. `passing` is irreversible except by explicit team-lead/user decision.
- **WIP=1:** one leaf active at a time; no "also fixing" adjacent items (course data: 87.5% vs 37.5% completion).
- **Only the team-lead flips `active → passing`,** against reviewer-cited evidence — never the engineer that built it.
- **Stop conditions:** numeric max fix→re-review rounds + no-progress detection (same findings two rounds running → stop, andon cord).
- **Two-level verification:** subtask = command-level check ("endpoint returns 201"); feature = behavior/E2E check ("user can register end to end"). The reviewer's per-block reviews judge against the leaf's stated verification, not vibes.

Format stays markdown (human-diffable, fits tooling); the win is the schema and the closed enum, not JSON.

---

## 6. Deprecations and cleanups

| Item | Fate | Why |
|---|---|---|
| `/vibe:adopt` | **Deprecate** — replaced by `/vibe:build-harness` | Wrong direction (project conforms to plugin); fails in practice; owner rebuilds by hand anyway |
| `/vibe:spec`, `/vibe:plan`, `/vibe:implement`, `/vibe:feature` | **Demote to presets** | No longer called directly on live projects; universality is the bloat source |
| `/vibe:build-flow` | **Promote & repoint** — the compiler, generating into the project | Center of gravity already moved here; was undocumented in README pre-migration (fixed in 6.2) |
| `/vibe:distill` | **Keep + extend one rung** | Project learnings stay local; kernel-grade learnings get promoted back into plugin templates (otherwise best lessons stay stranded in one repo) |
| Skills: team-communication + team-orchestration | **Merge** (removes duplicated idle-run rule) | Audit: always co-referenced, overlapping content |
| Skill: vibe-manual-testing | **Inline into qa-engineer template** | Single consumer, no command references it |
| Skills: research-protocol, review-discipline, critique | **Keep as kernel/role templates** | Lean and load-bearing |
| Restated stance paragraphs in `critic.md`, `qa-engineer.md` | **Delete** (near-verbatim duplicates of their skills) | Audit finding |
| Consolidation rule stated in 3 places (architect.md, orchestration skill, build-flow.md) | **Single-source in kernel** | Audit finding |
| Hardcoded Platform→BE→FE block order in implement | **Move into plan/preset** (architect decides per plan) | Adding a domain shouldn't require editing command files |
| README drift (engineer listed as sonnet, file says opus; "6 commands" count) | **Fix during migration** | Docs-as-harness hygiene |

---

## 7. Template properties (folding in the improvement-plan research)

The P1–P8 items from `docs/harness-improvement-plan.md` are not abandoned — they re-home as properties of the **templates** the builder stamps:

- **P1 task schema** → the task-ledger kernel template (§5).
- **P2 WIP=1 + stop conditions** → ledger rules + implement-preset skeleton.
- **P3 clean-state exit gate** → fixed section of every implement-shaped skeleton (build passes / all tests incl. pre-existing / ledger accurate / no stale artifacts / startup works — verified by command output).
- **P4 review rubric + what/why/fix findings** → review-protocol kernel template (0–2 across ~6 dimensions → Accept/Revise/Block; every finding = what (file:line) / why / fix).
- **P5 decision log + session handoff** → sections of the plan/ledger templates (prevents resumed sessions re-litigating settled choices).
- **P6 mechanized checks + harness doctor** → builder emits executable constraint checks where possible; `/vibe:build-harness` re-run doubles as the doctor (checklist re-audit: OK/MISSING per item + fresh-session test: can a scout answer what/how-to-run/how-to-verify/what's-unfinished from repo contents alone).
- **P7 prompt calibration** → the agent-description and command standards the builder audits against (entry files small, constraints top/bottom, detail in on-demand docs) + a simplification log in the plugin (periodically disable a constraint, observe, delete if quality holds).
- **P8 hygiene fixes** → §6 table.

---

## 8. Known cost: drift (accepted, managed)

Once N projects are stamped, a template fix propagates to zero of them until re-stamped (scaffold-vs-framework tradeoff; the create-react-app "eject" problem). Mitigations:

- Generated files carry a **template + version header**.
- An **upgrade path**: re-run the builder; it diffs stamped-but-unmodified sections against current templates and proposes updates; user-modified sections are surfaced, not overwritten.
- The kernel being small and stable is what makes this tolerable — most churn should happen in project-local flows, which never need upstream syncing.
- Distill's promotion rung (§6) is the reverse channel: kernel-grade learnings flow back to templates.

---

## 9. Questions resolved during the migration plan

These were open questions when this doc was written; `docs/migration-plan.md` §0 resolved each before execution:

1. **Ordering:** kernel extraction first (merge/dedupe skills into kernel templates) vs. builder command first? Kernel-first is likely — the builder needs finished templates to stamp. → **Resolved:** kernel-first — Phases 1–3 built the material, Phase 4 the machine (incl. 4.4's real-execution self-test, passing), Phase 6 deleted; Phase 5.1 live-project validation remains open.
2. **Preset fidelity:** how much of today's `plan.md`/`implement.md` prose survives into the presets vs. gets rewritten around the task ledger (P1/P2 said: rewrite implement around the state machine, ~174→~80 lines)? → **Resolved:** rewrite, don't port — `implement` rewritten around the task-ledger state machine (≤80 lines), `plan` kept its skeleton with the Tasks section replaced by the ledger schema, `spec` survived mostly intact, `feature` was not ported (the fullstack preset covers its use case).
3. **The two live projects are the validation cases:** tech backend (plan→implement preset) and fullstack app (full product-cycle preset). Migration isn't done until both run on generated harnesses and the hand-copied harness in the monorepo is retired. → **Resolved:** confirmed as the validation gate — migration is done only once both run real work on generated harnesses and the hand-copied monorepo harness is retired; that gate is Phase 5.1, still open.
4. **Checklist format** for build-harness: reuse adopt's `.workspace/adoption-checklist.md` resumable pattern or a new schema aligned with the task ledger? → **Resolved:** task-ledger schema, not adopt's format — `.workspace/harness/checklist.md` uses the same leaf schema as the ledger (`behavior`/`verification`/`state`/`evidence`, closed enum).
5. **What stays plugin-resident at runtime** (if anything): possibly only `build-harness`, `build-flow`, `distill` — everything else executes from the project's own files. → **Resolved:** only `/vibe:build-harness`, `/vibe:build-flow`, `/vibe:distill`; everything else executes from the project's own `.claude/`.
