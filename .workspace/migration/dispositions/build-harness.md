# Disposition: `commands/build-harness.md` (leaf 4.1)

Scout pass for Phase 4.1. Feeds an author who will NOT read v1 sources — everything load-bearing is captured verbatim below. Recommendations are mine, marked **REC**.

## 1. Requirements table (design doc, grouped by pipeline stage)

| Stage | Requirement (near-verbatim) | Cite |
|---|---|---|
| Parse | "Parse intent — desired team roster and desired commands from the user's natural-language description." | harness-builder.md:69 |
| Parse | Example prompt shape: roster (architect/critic/engineer/test-engineer/QA) + command split (planning vs implementing) | harness-builder.md:65 |
| Audit | "Audit — scout the project's existing state: `.claude/` contents, existing skills/conventions, stack facts, verification commands. (Scouts are subagents; the builder's own context stays clean — kernel discipline applies to the builder itself.)" | harness-builder.md:70 |
| Audit | "Audit via scout subagents (builder's own context stays clean): existing `.claude/`, stack facts, verification commands, existing conventions." | migration-plan.md:162 |
| Checklist | "Emit the checklist — the gap analysis IS the implementation roadmap: agents to add, domain review checklists missing (e.g., backend/frontend code-review checklist), existing agent descriptions to audit against the description standard (size budget, role boundary, done-format — bloat caught at generation time). Kernel components are pre-seeded rows." | harness-builder.md:71 |
| Checklist | "Checklist format: task-ledger schema, not adopt's format. `/vibe:build-harness` writes `.workspace/harness/checklist.md` using the same leaf schema as the ledger (`behavior/verification/state/evidence`, closed enum)." | migration-plan.md:17 |
| Checklist | "The checklist is persistent state (resumable, reviewable) — same pattern adopt used, inverted in direction." | harness-builder.md:74 |
| Build | "Build against the checklist — generate agents, skills, and commands into the project's `.claude/` from templates. Everything in-repo → works on Claude web, in monorepos, and for anyone who clones the repo." | harness-builder.md:72 |
| Build | "stamping into the project's `.claude/` with template-version headers; flip rows to `passing` with evidence (file path + standard-audit pass)." | migration-plan.md:164 |
| Build | Structural inheritance: skeleton kernel sections are literal fixed text the builder **cannot omit**; only the flow-specific middle is authored; no LLM-judged "guarantees preserved" soft check. | harness-builder.md:59 |
| Build | Kernel default-on unless explicit opt-out: task ledger, research protocol, communication+orchestration (team-protocol), review protocol. | harness-builder.md:51-58 |
| Build | Presets instantiated: `plan-implement`, `spec-plan-implement`. | harness-builder.md:80 |
| Build | Generation-time specialization: no runtime branching for project shape; a needed mode = generate two commands. | harness-builder.md:18 (rationale); command-standard.md:19 (hard rule) |
| Build | "Both builder commands are themselves written against `standards/command-standard.md` and the skeleton discipline (the builder obeys its own kernel)." | migration-plan.md:168 |
| Doctor | Re-run = doctor mode: re-audit each checklist row OK/MISSING, diff stamped-but-unmodified sections against current templates, propose upgrades, **never** overwrite user-modified sections; finish with fresh-session test (what-is-this / how-to-run / how-to-verify / what's-unfinished from repo contents alone). | migration-plan.md:165; harness-builder.md:127,138 |
| Doctor | Verify: run on this repo or a scratch project; checklist created, harness stamped, **doctor mode idempotent** (2nd run all-OK, changes nothing). | migration-plan.md:170 |
| Cross-cut | Template-version header on every generated file: `<!-- vibe-template: <path> v<N> \| generated <date> \| edits below this marker are yours -->` | migration-plan.md:57; command-standard.md:16-18 |
| Cross-cut | Plugin-resident at runtime: only build-harness, build-flow, distill; everything else executes from the project's own `.claude/`. | migration-plan.md:18,150 |

**12 requirement rows** across 5 stages.

## 2. v1 `adopt.md` disposition table

| # | Rule | Cite | Disposition |
|---|---|---|---|
| 1 | Domain detection by `Glob`-only marker files: backend manifest (`go.mod`/`pom.xml`/`Cargo.toml`/`requirements.txt`/`*.csproj`) or `api/`-dir; `package.json`/`tsconfig.json` or web-app dir → frontend; other markers → other domains | adopt.md:40 | **keep** — becomes the Audit stage's stack-detection heuristic, verbatim marker list |
| 2 | Per-domain item expansion: `<domain>-*` items multiply per confirmed domain; repo-level items stay singular | adopt.md:42 | **keep** — becomes the D7 per-component checklist-row seeding rule (§4 below) |
| 3 | One read-only scout subagent per checklist item, dispatched in parallel (one message, multiple `Agent` calls), self-contained brief (scout can't see orchestrator context) | adopt.md:46 | **keep** — matches migration-plan.md:162's audit-via-scouts requirement verbatim in spirit |
| 4 | Scout return contract: `item / status / candidates / conventions (≤8, cited file:line) / recommended / draft / notes` | adopt.md:66-75 | **merge** — `conventions cited file:line` survives into audit findings; `recommended: reuse-pointer/reuse-compact/explore-draft` survives only for the "existing agent description audit" sub-case (harness-builder.md:71) where a candidate already exists — build-harness otherwise stamps from fixed templates, no drafting-from-scratch mode |
| 5 | `.workspace/adoption-checklist.md`, hand-rolled ✅/❌/➖ status format | adopt.md:91-117 | **delete** — superseded wholesale by `.workspace/harness/checklist.md` ledger schema (migration-plan.md:17) |
| 6 | "**Mutation surface (narrow).** You write exactly: `.workspace/adoption-checklist.md`... and — only on the user's explicit approval — project skill files... You **never** touch application code" | adopt.md:17 | **keep contract**, reworded — build-harness's boundary sentence (command-standard rule 7) must equal `.claude/` generated artifacts + `.workspace/harness/checklist.md`; "never touch application code" survives verbatim as the hard boundary |
| 7 | "**Interactive, not autonomous.** Every gap is the user's call... You propose... you don't impose. You write a skill file only after the user approves the draft." | adopt.md:19, 121-131 | **delete — contradicts design doc**, see Contradiction C1 below |
| 8 | MCP/tooling items have no scout; check `.mcp.json`/settings yourself; mark "verify manually" | adopt.md:79, 111-112 | **delete** — out of scope; design doc's build-harness pipeline never mentions MCP/tooling verification |
| 9 | Resolve `CHECKLIST.md` via `$CLAUDE_PLUGIN_ROOT` at runtime as the canonical, non-hardcoded item list | adopt.md:23-33 | **delete** — `CHECKLIST.md` is absorbed + deleted in Phase 6 (migration-plan.md:24); build-harness's rows come from the template inventory + audit findings, not a static contract file |
| 10 | "Read the seed content yourself and pass it into each scout's brief — scouts can't expand `$CLAUDE_PLUGIN_ROOT`, and the seed is the shape they draft into." | adopt.md:33 | **keep verbatim contract** — build-harness/its scouts run inside the plugin; the orchestrator must resolve template paths itself and pass resolved paths/content into dispatch briefs, never a raw `$CLAUDE_PLUGIN_ROOT`-relative string a scout can't expand |
| 11 | Final report: items now ✅ / still ❌ / skipped ➖; "this repo is vibe-ready" vs list what remains; **never auto-run the next command** ("Adoption is setup; planning is the user's next, separate step.") | adopt.md:135-143 | **merge** — report shape carries into build-harness's Report step; "never auto-run the next command" merges with command-skeleton's existing Finalize convention (harness-builder.md's structural-inheritance point; skeleton already has "the user reviews first") |

**11 disposition rows**, **3 verbatim contracts** carried forward (#1 marker list, #6 boundary statement, #10 seed-resolution rule).

## 3. Composition spec (ledger 3.5's W-A..W-H → one testable rule each)

| Tag | Builder rule |
|---|---|
| W-A | When injecting a preset/flow's FLOW block "verbatim" into `{{FLOW}}`, still resolve every embedded `{{PLACEHOLDER}}` inside that block at stamp time (e.g. `{{SPEC_TEMPLATE_PATH}}`) — "verbatim" means no summarizing/re-authoring, not exemption from placeholder resolution. |
| W-B | Every resolved file path substituted into generated command text is backtick-wrapped. |
| W-C | When a FIXED section is opted out via `opt-out:`, renumber the remaining `## Outline` steps sequentially — no gap left at the removed step's old number. |
| W-D | When `archive` is opted out, drop the exact preamble clause "never archive a Blocked ledger" from the Finalize ordering line, not only the `archive` arrow item. |
| W-E | Strip every builder-facing parenthetical annotation (e.g. "(Opt-out-able: …)") from stamped output in ALL cases, whether or not that section is opted out — these are authoring-time notes, never runtime text. |
| W-F | `opt-out:` names may target either a full section heading or a Finalize sub-item (`archive`, `commit`) — the builder must recognize both levels. |
| W-G | On every stamp, including doctor-mode re-runs, rewrite the template header's `generated <date>` to the current date — never carry forward a stale date. |
| W-H | Emit exactly one blank line immediately above and below injected `{{FLOW}}` content, regardless of blank-line presence in the source preset/flow file — normalizes spacing so two independent builders produce byte-identical output. |
| — | `<named artifacts>` (angle-bracket) is a distinct placeholder syntax from `{{PLACEHOLDER}}`: it is command-standard rule 7's boundary-sentence slot, filled from the preset/flow's `FILL NAMED_ARTIFACTS` content, comma-joined into prose — never left as a literal token. |
| — | The regen stamp's `preset={{PRESET}}` / `flow-spec={{FLOW_SPEC}}` line is filled with the actual preset dir name (e.g. `plan-implement`) or flow-spec file path used for this stamp — build-harness fills `PRESET`, leaves flow-spec empty/n-a (build-flow does the inverse). This is what makes `--regen` re-derivable. |

**10 composition rules.** Source: ledger.md:78 (row 3.5 Evidence cell).

## 4. Pre-seeded checklist rows (per D7, ledger.md:23)

The audit stage MUST emit, per detected component (from §2 row 1's stack detection):
- `<component>-architecture` skill row — target `.claude/skills/<component>-architecture/SKILL.md`, stamped from `templates/workspace/architecture-skill.md`; `COMPONENT` token must equal the domain token agent briefs resolve (architecture-skill.md:10).
- `<component>-review` checklist row — target `.claude/skills/<component>-review/SKILL.md`, stamped from `templates/checklists/review-{backend,frontend}.md` when stack-matched, else `review-generic.md`; **one row per detected component, not one global pair** (harness-builder.md:71's "domain review checklists missing" example + migration-plan.md Phase 2 note "the builder emits one review checklist per detected component").
- Env-script rows — `.claude/scripts/env-up.sh` + `.claude/scripts/test-run.sh` (from `templates/scripts/*.sh.template`) plus an `environment` skill row (`.claude/skills/environment/SKILL.md`, from `templates/workspace/environment-skill.md`) naming both; review-protocol's Pass 3 / reviewer/engineer/test-engineer/qa-engineer templates already resolve `environment` by name (confirmed: reviewer.md:35, engineer.md:30), so this row must exist before those agents are usable.
- Kernel rows (task-ledger, research-protocol, team-protocol, review-protocol) pre-seeded unconditionally, default-on (harness-builder.md:51-58).
- Agent roster rows per parsed intent, each carrying a "description standard audit" sub-check (harness-builder.md:71).

## 5. Contradictions

| # | Design doc | v1 | Standard | REC |
|---|---|---|---|---|
| C1 | Build stage 4 is "generate... into the project's `.claude/` from templates" (harness-builder.md:72) — no gap-by-gap approval loop described; checklist rows just flip to `passing` with evidence (migration-plan.md:164) | `adopt.md`'s entire close-list step is per-item `AskUserQuestion` before any write (adopt.md:19,121-131) | — | **REC**: build autonomously from the checklist once parsed+audited; reserve `AskUserQuestion` only for genuinely ambiguous parse-stage inputs (roster/command split unclear) — matches command-standard's no-runtime-branching spirit and migration-plan's orchestrator-stops-only-for-4-cases rule (migration-plan.md:100-104), none of which is "confirm every generated file" |
| C2 | Checklist schema = task-ledger leaf schema (migration-plan.md:17) | adopt's checklist is a bespoke ✅/❌/➖ markdown list (adopt.md:93-115) | — | **REC**: fully replace; do not carry adopt's status glyphs — use `state ∈ {not_started,active,blocked,passing}` per task-ledger.md |
| C3 | No design-doc statement on whether build-harness may run without any user confirmation of detected domains | adopt.md:41 requires `AskUserQuestion` confirmation of detected domains before expansion | command-standard rule 4 (no runtime branching) governs generated commands, not the builder itself | **REC**: keep a single confirm-domains step at end of Parse (cheap, one round-trip, prevents mis-scoped audits) — this is a builder-authoring-time interaction, not a runtime branch in a *generated* command, so it doesn't trip rule 4 |

**3 contradictions**, all mine to flag per task instructions (not authored/resolved here).

## 6. Budget

`command-standard.md` size budget: entry command files 50-200 lines (rule 1); build-harness's own outline is parse→audit→checklist→build(+doctor) — no repeat/until loop over a ledger at the top level (the loop lives inside the *generated* commands, not build-harness itself), so it classifies as an **entry command**, not implementation-loop-shaped (≤80 rule doesn't apply). Given: 4-stage pipeline + doctor-mode branch-free-at-generation-time description + kernel-by-reference (rule 5, no restating templates inline) + canonical section order (rule 6) →

**REC: 150-180 lines**, upper-middle of the 50-200 band — comparable to `templates/skeletons/command-skeleton.md` (30) + `flow-skeleton.md` (38) combined scope but with parse/audit/checklist logic (not present in either skeleton) added, and doctor-mode as a re-run branch described once, not duplicated.
