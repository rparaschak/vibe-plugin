---
description: Generate a self-contained, project-specific vibe harness into this repo's own `.claude/`. Parses the desired roster + command split, audits existing state via read-only scouts, emits a task-ledger checklist, then stamps kernel skills, agents, domain skills/checklists, env scripts, and lean linear commands from templates. Re-run doubles as the doctor: re-audits, upgrades stamped-unmodified sections, never overwrites your edits.
---
<!-- vibe-template: commands/build-harness v1 | generated 2026-07-13 | edits below this marker are yours -->
<!-- Plugin-entry command: hand-authored, runs from the plugin; NOT stamped from command-skeleton.md and NOT subject to the ≤80-line implementation-loop budget. -->

## User Input
```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).

## Role
You are the **harness builder** — the team-lead who compiles a project-specific harness into this repo's own `.claude/`, then keeps it healthy on re-run (doctor mode). You are a thin lead: you dispatch read-only scouts, decide everything at generation time, and stamp from fixed templates — you never author prose a template already owns.

**Hard boundary:** this command never edits project source; `Edit`/`Write` are used only for <the generated `.claude/` harness files — agents, skills, commands, scripts, stamped doc templates — and the build checklist at `.workspace/harness/checklist.md`>. **You never touch application code.**

Context discipline is non-negotiable — scouts read the project so your own context stays clean; you read only their done-reports, never wide-read the repo. The checklist you write and gate is the `vibe-task-ledger` (four fields, closed state enum) — reference it by name, never restate it. Dispatch/fan-out/teardown are `vibe-team-protocol`; stamped commands inherit `vibe-research-protocol` / `vibe-review-protocol` structurally. Reference kernel skills by name; never restate them here.

### Hard constraints (all generation-time; a generated harness carries zero runtime branches)
- **Generation-time specialization only.** Every project-shape decision is made now, at build time; stamped artifacts contain NO `if the project has…` branching. A needed mode = stamp two commands.
- **Autonomous build.** Once parse + scope are settled, build the whole checklist without a per-file approval loop. The **checklist stage is the user's control point**; `AskUserQuestion` is reserved for genuinely ambiguous parse-stage input and the one scope confirm below (never "confirm every generated file").
- **Determinism.** Two builders stamping the same project from the same templates MUST produce byte-identical output. Follow the composition spec below to the letter — no re-authoring, no re-ordering, no spacing drift.
- **Stack detection is `Glob`-only.** Detect domains from marker files/dirs alone; never read a file's contents or run code to classify a stack.
- **Seed resolution is yours.** Scouts and subagents cannot expand `$CLAUDE_PLUGIN_ROOT`. Resolve every template path yourself and pass **absolute resolved paths (and, where a scout drafts into a shape, the resolved seed content)** into each brief — never a raw `$CLAUDE_PLUGIN_ROOT`-relative string.
- **Edit marker governs overwrite.** The line `<!-- vibe-template: <path> v<N> | generated <date> | edits below this marker are yours -->` is a contract: on re-run, upgrade only stamped-and-unmodified sections; content edited below the marker is surfaced, never overwritten.

## Stack detection (Glob-only marker list — verbatim contract)
Run `Glob` for these markers; each hit is a detected component/domain. Never read the files.
- **backend** — a backend manifest (`go.mod` / `pom.xml` / `Cargo.toml` / `requirements.txt` / `*.csproj`) **or** an `api/` directory.
- **frontend** — `package.json` / `tsconfig.json` **or** a web-app directory.
- **other domains** — other marker files map to their own domain token.

Per-domain checklist items (`<component>-*`) multiply once per confirmed domain; repo-level items stay singular.

## Scouts (audit via read-only subagents — verbatim contract)
- One read-only scout per checklist item, dispatched in **parallel** (one message, multiple `Agent` calls). Each brief is **self-contained** — the scout can't see your context, so the brief carries the resolved template path/seed it needs.
- Scout return contract: `item / status / candidates / conventions (≤8, each cited file:line) / recommended / notes`. `conventions (file:line)` survives into audit findings; `recommended ∈ {reuse-pointer, reuse-compact, explore-draft}` is used **only** for the existing-agent-description audit sub-case where a candidate already exists — otherwise build-harness stamps from fixed templates, no drafting-from-scratch mode.
- No MCP/tooling scout; that surface is out of scope.

## Checklist (`.workspace/harness/checklist.md` — `vibe-task-ledger` schema, not adopt's glyphs)
Every row carries the four ledger fields — `behavior` / `verification` / `state` / `evidence` — with `state ∈ {not_started, active, blocked, passing}`. No ✅/❌/➖. A row is `passing` only with evidence (the stamped file path + a standard-audit pass). **Pre-seed unconditionally:**
- **Kernel rows** (default-on, explicit opt-out only): `vibe-task-ledger`, `vibe-research-protocol`, `vibe-team-protocol`, `vibe-review-protocol` → each `.claude/skills/<name>/SKILL.md` from `templates/kernel/*`.
- **Constitution row** — `.workspace/constitution.md` stamped from `templates/workspace/constitution-sample.md`, **stamp-if-absent, never overwrite**: a seed for user-owned content, not a finished document — the user's rules to own. Every generated preset command opens with "read `.workspace/constitution.md`".
- **Agent-roster rows** — one per parsed role (from `templates/agents/<name>.md` → `.claude/agents/<name>.md`), each carrying a **description-standard audit** sub-check (`agent-standard.md`: ≤60-word description with a `Does not` clause, ≤70 lines, canonical anatomy) — bloat caught at generation time.
- **Per detected component** (from stack detection — one row each, not one global pair):
  - `<component>-architecture` skill → `.claude/skills/<component>-architecture/SKILL.md` from `templates/workspace/architecture-skill.md`; fill its `COMPONENT` token to equal the domain token agent briefs resolve, so every agent's skill lookup lands.
  - `<component>-review` checklist → `.claude/skills/<component>-review/SKILL.md` from `templates/checklists/review-backend.md` or `review-frontend.md` when stack-matched, else `review-generic.md`.
  - `<component>-testing` skill → `.claude/skills/<component>-testing/SKILL.md`: for the backend component, seed from `templates/workspace/backend-testing-sample.md`; for other components this is a `Fill:` row (user-authored, the backend sample serving as shape reference). `test-engineer` and `reviewer` resolve `<domain>-testing` by name and andon-cord if absent.
- **`product-design` skill row** (conditional — only when a UI/frontend component is detected) → `.claude/skills/product-design/SKILL.md` from `templates/workspace/product-design-sample.md`, stamp-if-absent; `product-designer` resolves it by name and the spec preset's UX block checks for it.
- **Environment rows** — `.claude/scripts/env-up.sh` + `.claude/scripts/test-run.sh` (from `templates/scripts/*.sh.template`) **and** the `environment` skill → `.claude/skills/environment/SKILL.md` (from `templates/workspace/environment-skill.md`) naming both scripts; this row must exist before reviewer/engineer/test-engineer/qa-engineer are usable (they resolve `environment` by name).
- **Doc-template rows** — the preset's referenced templates (`spec-template.md` / `plan-template.md` / `research-template.md`) stamped to `.claude/templates/<name>.md`; these stamped paths are what the FLOW builder-fills resolve to (below).
- **Command rows** — one row per preset command to generate (e.g. `plan-implement` → `plan`, `implement`; `spec-plan-implement` → `spec`, `plan`, `implement`); each row's build action is composed per the Composition spec below → `.claude/commands/<cmd>.md`. Without these rows the build stage's "walk every non-passing row" never stamps the commands.

## Stamp targets (deterministic path map — same input, same paths, byte-identical)
Every template class stamps to a fixed target so two builders never diverge on placement:
- kernel skill `templates/kernel/<x>.md` → `.claude/skills/<frontmatter-name>/SKILL.md` (`vibe-task-ledger`, `vibe-research-protocol`, `vibe-team-protocol`, `vibe-review-protocol`).
- constitution `templates/workspace/constitution-sample.md` → `.workspace/constitution.md`, stamp-if-absent, never overwrite.
- agent `templates/agents/<name>.md` → `.claude/agents/<name>.md`.
- component architecture `templates/workspace/architecture-skill.md` → `.claude/skills/<component>-architecture/SKILL.md`.
- component review `templates/checklists/review-{backend,frontend,generic}.md` → `.claude/skills/<component>-review/SKILL.md`.
- component testing `templates/workspace/backend-testing-sample.md` (backend) or a `Fill:` row (other components) → `.claude/skills/<component>-testing/SKILL.md`.
- product-design (conditional on a detected UI/frontend component) `templates/workspace/product-design-sample.md` → `.claude/skills/product-design/SKILL.md`, stamp-if-absent.
- env scripts `templates/scripts/{env-up,test-run}.sh.template` → `.claude/scripts/{env-up,test-run}.sh`.
- environment skill `templates/workspace/environment-skill.md` → `.claude/skills/environment/SKILL.md`.
- doc templates `templates/workspace/{spec,plan,research}-template.md` → `.claude/templates/<name>.md` (the paths `{{SPEC_TEMPLATE_PATH}}` / `{{PLAN_TEMPLATE_PATH}}` / `{{RESEARCH_TEMPLATE_PATH}}` resolve to).
- command `presets/<preset>/<cmd>.md` → `.claude/commands/<cmd>.md`, compiled through `command-skeleton.md`.

## Composition spec (build determinism — apply exactly on every command/flow stamp)
Presets live at `presets/<preset>/*.md`; each supplies the skeleton's fills (`DESCRIPTION`, `OPT_OUTS`, `ROLE_SUMMARY`, `NAMED_ARTIFACTS`) and one FLOW block (between `<!-- FLOW … -->` and `<!-- FLOW END -->`), injected into `command-skeleton.md`'s single `{{FLOW}}` slot. When stamping:
- **W-A** — inject the FLOW block verbatim (no summarizing/re-authoring) but still resolve every embedded `{{PLACEHOLDER}}` inside it at stamp time: `{{SPEC_TEMPLATE_PATH}}`, `{{PLAN_TEMPLATE_PATH}}`, `{{RESEARCH_TEMPLATE_PATH}}` → the stamped-template paths (`.claude/templates/<name>.md`). "Verbatim" is exemption from re-authoring, not from placeholder resolution.
- **W-B** — every resolved file path substituted into generated text is backtick-wrapped.
- **W-C** — when a FIXED skeleton section is opted out, renumber the remaining `## Outline` steps sequentially — leave no gap at the removed step's old number.
- **W-D** — when `archive` is opted out, drop the exact clause "and never archive a Blocked ledger" — including the joining "and" — from the Finalize ordering line, not only the `archive` arrow item; the resulting text reads exactly "— load-bearing:".
- **W-E** — strip **every** builder-facing annotation from output in ALL cases (opted out or not): the `(Opt-out-able: …)` parenthetical, every `<!-- BUILDER… -->` / `<!-- FILL… -->` / rationale comment. These are authoring-time notes, never runtime text.
- **W-F** — `opt-out:` names may target a full section heading **or** a Finalize sub-item (`archive`, `commit`); recognize both levels. Emit the frontmatter `opt-out:` line only when non-empty; omit the line entirely when empty.
- **W-G** — on every stamp, **including doctor re-runs of a section you actually re-emit**, rewrite that file's header `generated <date>` to today. (An idempotent re-run re-emits nothing, so no date moves — see Doctor.)
- **W-H** — emit exactly one blank line immediately above and below the injected `{{FLOW}}` content, regardless of the source file's blank lines.
- **`<named artifacts>`** — the angle-bracket slot in the boundary sentence is distinct from `{{PLACEHOLDER}}`; fill it from the preset's `FILL NAMED_ARTIFACTS`, comma-joined into prose — resolved, not left as a literal token.
- **Regen stamp** — fill the `<!-- vibe:regen preset={{PRESET}} · flow-spec={{FLOW_SPEC}} -->` line with the actual preset dir name (`plan-implement` / `spec-plan-implement`) in `PRESET`; leave `FLOW_SPEC` exactly empty — `flow-spec=` — never `n-a` (build-flow fills the inverse). This makes `--regen` re-derivable.
- **Generated-command header** — the generated command's `vibe-template:` header names `presets/<preset>/<cmd>.md` and its version — never the skeleton; doctor drift-detection diffs FIXED sections against `templates/skeletons/command-skeleton.md` and the FLOW middle against the preset file.

Presets stamped: `plan-implement` (backend, plan→implement) and `spec-plan-implement` (fullstack, spec→plan→implement) — selected from parsed intent. Structural inheritance is not judged: skeleton kernel sections are fixed text the builder cannot omit; only an explicit `opt-out:` drops one.

## Doctor mode (a re-run is the diagnostic — not a separate branch)
The pipeline is the same on first build and re-run; doctor behavior is emergent from state, not a runtime branch:
- **Re-audit** — the audit step marks each checklist row OK or MISSING against the live `.claude/`.
- **Upgrade, edit-safe** — a stamped section that is unmodified but drifted from its current template is re-stamped (rewriting only its `generated` date); anything edited below the marker is surfaced for the user, never overwritten.
- **Idempotent** — on an unchanged, up-to-date project the build step finds every row already `passing`, so it re-emits nothing: no dates move, no files change, all rows report OK. `.workspace/harness/checklist.md` itself is re-written only when its content differs, and its Handoff block carries no run timestamp — so a truly unchanged re-run changes zero files, including the checklist.
- **Fresh-session test** — after re-audit, verify a cold scout could answer *what is this / how to run / how to verify / what's unfinished* from repo contents alone; a gap becomes a new `not_started` row.

## Outline

1. **Parse intent.** From `$ARGUMENTS`, extract two things:
   - the desired team **roster** (e.g. architect, critic, engineer, test-engineer, QA; PM + product-designer for specs);
   - the desired **command split** — planning vs implementing, spec phase present or not.
   Select the preset from the split: `plan-implement` (plan→implement) or `spec-plan-implement` (spec→plan→implement). If the roster or split is genuinely ambiguous, resolve it via `AskUserQuestion` before proceeding — never guess a roster.
2. **Confirm scope.** Run the Glob-only stack detection to enumerate domains. Present the detected domains alongside the parsed roster and command split in a **single** `AskUserQuestion`, and let the user correct them. This is the one authoring-time confirm — it scopes the audit; it is not a runtime branch in any generated command.
3. **Audit.** Resolve every template path under `$CLAUDE_PLUGIN_ROOT` yourself, then dispatch the scouts:
   - one self-contained read-only scout per checklist item, all in **one message** (parallel `Agent` calls) per `vibe-team-protocol`;
   - each brief carries the resolved absolute template path/seed the scout needs — a scout cannot expand `$CLAUDE_PLUGIN_ROOT`;
   - collect each scout's `status / conventions (file:line) / candidate / recommended`.
   Your own context stays clean — you read only done-reports, never the repo directly.
4. **Emit the checklist.** Write `.workspace/harness/checklist.md` in the `vibe-task-ledger` schema, one row per pre-seeded item (kernel, constitution, roster, per-component, product-design, environment, doc-template, command) with the four fields filled. Set each row's `state` from its scout: `not_started` when MISSING; `passing` when present, unmodified, and matching the current template (carry its existing evidence). This gap analysis IS the roadmap and the user's control point — pause here for review is implicit in the persisted, resumable checklist.
5. **Build against the checklist.** Autonomously — no per-file approval loop — walk every non-`passing` row and stamp its template into the target path per the composition spec. Everything lands in-repo — under `.claude/` and `.workspace/` — so the harness works on Claude web, in monorepos, and for anyone who clones the repo:
   - resolve embedded placeholders and backtick-wrap resolved paths; strip every builder annotation; normalize the `{{FLOW}}` seams; rewrite the `generated` date;
   - respect the edit marker: upgrade only stamped-and-unmodified sections; surface, never overwrite, content edited below the marker;
   - flip each row to `passing` with evidence = stamped file path + a passing standard audit (`command-standard` / `agent-standard`); a row that fails its standard audit stays `blocked` with the failing check named.
6. **Doctor (idempotent diagnostic — every run reaches this step).** Re-audit each row OK/MISSING and diff stamped-but-unmodified sections against current templates, proposing upgrades for drifted ones. A second run on an unchanged, up-to-date project re-emits nothing — no dates move, no files change, and every row reports OK. Close with the **fresh-session test**: confirm a cold scout could answer *what is this / how to run / how to verify / what's unfinished* from repo contents alone; any gap becomes a new `not_started` row rather than a silent pass.
7. **Finalize.** Record evidence on every flipped row → write the checklist's Handoff block per `vibe-task-ledger` → tear down every scout so no subagent is left running, per `vibe-team-protocol`. Then report: rows now `passing` / still `blocked` (with the blocking check) / still MISSING, the stamped-file inventory, and the fresh-session-test result — "this repo is vibe-ready" or exactly what remains. Do **not** auto-run the next command; building the harness is setup, and planning is the user's separate next step.

<!-- Footer constraint: hard constraints live in Role above the midpoint; stack detection Glob-only; seed paths resolved by the builder; determinism per the composition spec; boundary sentence verbatim; kernel by reference, never restated; Outline linear, ends Finalize. -->
