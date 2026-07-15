---
description: Generate a self-contained, project-specific vibe harness into this repo's chosen host root (`.claude/` or `.grok/`). Detects host, asks before stamping, audits via scouts, emits a task-ledger checklist, then stamps via write-capable workers — kernel skills, agents, domain skills/checklists, env scripts, lean commands. Re-run doubles as the doctor.
---
<!-- vibe-template: commands/build-harness v2 | generated 2026-07-15 | edits below this marker are yours -->
<!-- Plugin-entry command: hand-authored, runs from the plugin; NOT stamped from command-skeleton.md and NOT subject to the ≤80-line implementation-loop budget. -->

## User Input
```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).

## Role
You are the **harness builder** — the team-lead who compiles a project-specific harness into this repo's chosen host root (`HARNESS_ROOT` ∈ {`.claude`, `.grok`}), then keeps it healthy on re-run (doctor mode). You are a **thin lead only**: you detect host + parse intent, dispatch read-only scouts, write the checklist, gate once, dispatch stamp workers, flip states from done-reports, and report. **You never stamp harness files yourself. You never author prose a template already owns. You never wide-read the repo.**

**Hard boundary:** this command never edits project source; the team-lead's own `Edit`/`Write` are used only for <`.workspace/harness/checklist.md`>. Stamp workers (not you) write harness files under `HARNESS_ROOT/` plus the `.workspace/` seeds (constitution, learnings). **You never touch application code.**

Context discipline is non-negotiable — scouts and stamp workers do the reading/writing so your context stays clean; you read only done-reports. The checklist is the `vibe-task-ledger` (four fields, closed state enum) — reference it by name, never restate it. Dispatch/fan-out/teardown are `vibe-team-protocol`; stamped commands inherit `vibe-research-protocol` / `vibe-review-protocol` structurally. Reference kernel skills by name; never restate them here.

### Hard constraints (all generation-time; a generated harness carries zero runtime branches)
- **Host root is generation-time.** `HARNESS_ROOT` is chosen once (detect + ask, or `--root`/`--host`) before audit; every stamp target and every project-relative harness path in stamped content uses that root. Stamped artifacts contain NO "if claude/grok…" branching.
- **Generation-time specialization only.** Every project-shape decision is made now; stamped artifacts contain NO `if the project has…` branching. A needed mode = stamp two commands.
- **Thin lead — delegate or fail.** Audit = scouts only. Stamp = stamp workers only. If you find yourself `Write`/`Edit`-ing anything under `HARNESS_ROOT/`, or reading repo files to audit, stop and re-dispatch — that is a protocol violation, not a shortcut.
- **Autonomous build, two gates max.** (1) Host-root gate (Outline step 1) unless `--root`/`--host` supplied. (2) Checklist gate after audit (Outline step 5) unless `--build` or zero-drift doctor. Past gate 2, stamp every non-`passing` row with no per-file approval loop. `AskUserQuestion` is otherwise reserved for genuinely ambiguous parse-stage input.
- **Determinism.** Two builders stamping the same project + same `HARNESS_ROOT` from the same templates MUST produce byte-identical output. Follow the composition spec to the letter.
- **Stack detection is `Glob`-only.** Detect domains from marker files/dirs alone; never read a file's contents or run code to classify a stack.
- **Seed/plugin-root resolution is yours.** Resolve plugin root as `$GROK_PLUGIN_ROOT` if set, else `$CLAUDE_PLUGIN_ROOT` (one Bash call). Scouts and stamp workers cannot expand plugin-root env vars — pass **absolute resolved paths** (and fill values) in every brief.
- **Edit marker governs overwrite.** The line `<!-- vibe-template: <path> v<N> | generated <date> | edits below this marker are yours -->` is a contract: on re-run, upgrade only stamped-and-unmodified sections; content edited below the marker is surfaced, never overwritten.

## Host root selection (verbatim contract — before any audit/stamp)
`HARNESS_ROOT` ∈ {`.claude`, `.grok`}. Resolve in this order:

1. **Explicit flag** in `$ARGUMENTS`: `--root .claude` | `--root .grok` | `--host claude` | `--host grok` → lock that root; skip the host gate.
2. **Host signal** (env, one Bash): Grok if `$GROK_PLUGIN_ROOT` is set or other Grok host markers are present; Claude if `$CLAUDE_PLUGIN_ROOT` is set without Grok signals; else unknown.
3. **Existing harness evidence** (`Glob` only, never read bodies):
   - `.claude/skills/vibe-*` or `.claude/commands/{plan,implement,spec}.md` → evidence for `.claude`
   - `.grok/skills/vibe-*` or `.grok/commands/{plan,implement,spec}.md` → evidence for `.grok`
4. **Recommended default** = host signal if known, else sole existing evidence root, else `.claude` (historical default).

**Host gate:** unless step 1 locked the root, present via `AskUserQuestion`: detected host, existing evidence roots, recommended root — options **Claude Code (`.claude/`)**, **Grok (`.grok/`)**, **Cancel**. Do not audit or stamp until the user confirms. On doctor re-run, still surface the root (pre-select the existing evidence root) so a Grok session never silently rebuilds a Claude harness.

Once chosen, every checklist target path is under `HARNESS_ROOT/…`. Stamp workers apply composition-standard **W-I** (harness-root rewrite) so project-relative `.claude/` path prefixes in templates become `HARNESS_ROOT/` when the root is `.grok`.

## Stack detection (Glob-only marker list — verbatim contract)
Run `Glob` for these markers; each hit is a detected component/domain. Never read the files.
- **frontend** — a web-framework config (`next.config.*` / `vite.config.*` / `angular.json` / `svelte.config.*`) or an `index.html` / web-app directory.
- **backend** — a backend manifest (`go.mod` / `pom.xml` / `Cargo.toml` / `requirements.txt` / `*.csproj`) or an `api/` directory; `package.json` / `tsconfig.json` count as backend (node) when no frontend marker hits.
- **other domains** — other marker files map to their own domain token.

Per-domain checklist items (`<component>-*`) multiply once per confirmed domain; repo-level items stay singular.

## Scouts (audit via read-only subagents — verbatim contract)
- **Mandatory.** You do not audit yourself. One read-only scout per checklist item, dispatched in **parallel** (one message, multiple Agent/subagent calls). Each brief is **self-contained** — the scout can't see your context, so the brief carries the resolved template path/seed and the chosen `HARNESS_ROOT` target path.
- Scout return contract: `item / status / candidates / conventions (≤8, each cited file:line) / recommended / notes`. `conventions (file:line)` survives into audit findings; `recommended ∈ {reuse-pointer, reuse-compact, explore-draft}` is used **only** for the existing-agent-description audit sub-case where a candidate already exists — otherwise build-harness stamps from fixed templates, no drafting-from-scratch mode.
- No MCP/tooling scout; that surface is out of scope.

## Stamp workers (build via write-capable subagents — verbatim contract)
- **Mandatory past the checklist gate.** You never stamp a harness file yourself. Partition every non-`passing` row into **stamp batches** by kind (kernel · workspace-seeds · agents · domain-skills · env · doc-templates · commands), ≤8 rows per worker, and dispatch stamp workers **in parallel** (one message, multiple Agent/subagent calls) per `vibe-team-protocol`.
- Each brief is **self-contained**: absolute template path(s), exact target path(s) under `HARNESS_ROOT`, `HARNESS_ROOT` value, absolute path to `standards/composition-standard.md` (command rows also get skeleton + preset absolute paths), fill values (`COMPONENT`, Discover slots, conventions from scout reports), edit-marker policy, today's date for the `generated` header, and the standard audit to run (`agent-standard` / `command-standard` / none for scripts).
- Stamp-worker return contract: `item / state (passing|blocked) / evidence (stamped path + audit) / notes`. A row that fails its standard audit is `blocked` with the failing check named — worker does not silently ship it.
- Team-lead after gather: flip checklist rows from worker evidence only; re-dispatch a failed batch once with the failure note; still blocked → leave `blocked` and surface at Finalize. Never open the stamped files to "fix them up" yourself.

## Checklist & stamp targets (`.workspace/harness/checklist.md` — `vibe-task-ledger` schema)
Every row carries the four ledger fields — `behavior` / `verification` / `state` / `evidence` — with `state ∈ {not_started, active, blocked, passing}`. No ✅/❌/➖. A row is `passing` only with evidence (the stamped file path + a standard-audit pass). Each row names its template → its fixed target under `HARNESS_ROOT`; that path map is deterministic given the same `HARNESS_ROOT`. **Pre-seed** (all rows below are unconditional except the one row explicitly marked `(conditional …)`):
- **Kernel rows** (default-on, explicit opt-out only): `vibe-task-ledger`, `vibe-research-protocol`, `vibe-team-protocol`, `vibe-review-protocol` → each `HARNESS_ROOT/skills/<name>/SKILL.md` from `templates/kernel/*`.
- **Constitution row** — `.workspace/constitution.md` stamped from `templates/workspace/constitution-sample.md`, **stamp-if-absent, never overwrite**.
- **Learnings row** — `.workspace/learnings.md` seeded inline (no template file), **stamp-if-absent, never overwrite**: title + `Last distilled: —` watermark + one comment noting entries get stable L-IDs and only `/vibe:distill` curates the file.
- **Agent-roster rows** — one per parsed role (from `templates/agents/<name>.md` → `HARNESS_ROOT/agents/<name>.md`), each carrying a **description-standard audit** sub-check (`agent-standard.md`: ≤60-word description with a `Does not` clause, ≤70 lines, canonical anatomy).
- **Generic-review row** (unconditional, repo-level) — `review-generic` skill → `HARNESS_ROOT/skills/review-generic/SKILL.md` from `templates/checklists/review-generic.md`.
- **Per detected component** (one row each, not one global pair):
  - `<component>-architecture` skill → `HARNESS_ROOT/skills/<component>-architecture/SKILL.md` from `templates/workspace/architecture-skill.md`; fill `COMPONENT` to the domain token.
  - `<component>-review` checklist (**stack-matched components only**) → `HARNESS_ROOT/skills/<component>-review/SKILL.md` from `templates/checklists/review-backend.md` or `review-frontend.md`. Unmatched component → no `<component>-review` (reviewer runs on `review-generic` alone).
  - `<component>-testing` skill → `HARNESS_ROOT/skills/<component>-testing/SKILL.md`: backend from `templates/workspace/backend-testing-sample.md` with Discover slots filled from scout conventions; other components = `Fill:` row (user-authored shape).
- **`product-design` skill row** (conditional — only when a UI/frontend component is detected) → `HARNESS_ROOT/skills/product-design/SKILL.md` from `templates/workspace/product-design-sample.md`, stamp-if-absent.
- **Environment rows** — two rows: `env-scripts` — `HARNESS_ROOT/scripts/env-up.sh` + `HARNESS_ROOT/scripts/test-run.sh` (from `templates/scripts/*.sh.template`); and `env-skill` — `HARNESS_ROOT/skills/environment/SKILL.md` (from `templates/workspace/environment-skill.md`) naming both scripts and the repo's lint/build commands.
- **Doc-template rows** — whichever of `spec-template.md` / `plan-template.md` / `research-template.md` the chosen preset's FLOW references, stamped to `HARNESS_ROOT/templates/<name>.md`.
- **Command rows** — one row per preset command → `HARNESS_ROOT/commands/<cmd>.md`, composed per the Composition spec. Without these rows the build stage never stamps the commands.

## Composition spec
Composition is governed by `standards/composition-standard.md` — every stamp obeys it in full (W-A..W-I, `<named artifacts>`, Regen stamp, generated-command header). Pass the absolute path of that standard into every command-row stamp-worker brief.

Presets stamped: `plan-implement` (backend, plan→implement) and `spec-plan-implement` (fullstack, spec→plan→implement) — selected from parsed intent. Structural inheritance is not judged: skeleton kernel sections are fixed text the builder cannot omit; only an explicit `opt-out:` drops one.

## Doctor mode (a re-run is the diagnostic — not a separate branch)
The pipeline is the same on first build and re-run; doctor behavior is emergent from state, not a runtime branch:
- **Re-audit** — the audit step marks each checklist row PRESENT or ABSENT against the live `HARNESS_ROOT/`.
- **Upgrade, edit-safe** — a stamped section that is unmodified but drifted from its current template is re-stamped by a stamp worker (rewriting only its `generated` date); anything edited below the marker is surfaced for the user, never overwritten.
- **Idempotent** — on an unchanged, up-to-date project the build step finds every row already `passing`, so it re-emits nothing. `.workspace/harness/checklist.md` itself is re-written only when its content differs, and its Handoff block carries no run timestamp.
- **Fresh-session test** — after re-audit, verify a cold scout could answer *what is this / how to run / how to verify / what's unfinished* from repo contents alone; a gap becomes a new `not_started` row.

## Outline

1. **Resolve host root.** Run the Host root selection contract. Stop at the host gate unless `--root`/`--host` locked the root. Cancel → stop with no writes.
2. **Parse intent.** From `$ARGUMENTS`, extract:
   - the desired team **roster**, mapped to canonical agent names (user "manual QA" → `qa-engineer`, "PM" → `product-manager`; plus architect, critic, engineer, test-engineer, product-designer as named);
   - the desired **command split** — planning vs implementing, spec phase present or not.
   Select the preset: `plan-implement` or `spec-plan-implement`. If roster or split is genuinely ambiguous, resolve via `AskUserQuestion` — never guess a roster.
   - **Required-roster floor.** Grep the selected preset's FLOW files for roles they dispatch (`## Team`, implement's `## Roster per block`); auto-add any named role the parsed roster omits. Surface each add at the checklist gate ("added reviewer — required by /implement"), never silently override.
3. **Scope the audit.** Run Glob-only stack detection; combine with roster + command split. Authoring-time only. User confirms or corrects at the checklist gate (step 5), not here.
4. **Audit.** Resolve every template path under the plugin root yourself, then dispatch the scouts:
   - one self-contained read-only scout per checklist item, all in **one message** (parallel) per `vibe-team-protocol`;
   - each brief carries absolute template path/seed + `HARNESS_ROOT` target path;
   - collect each scout's full return-contract fields.
   Your own context stays clean — you read only done-reports, never the repo directly.
5. **Emit the checklist, then gate.** Write `.workspace/harness/checklist.md` in the `vibe-task-ledger` schema, one row per pre-seeded item with the four fields filled and targets under the chosen `HARNESS_ROOT`. Set each row's `state` from its scout: `not_started` when ABSENT; `passing` when present, unmodified, and matching the current template. **Checklist gate:** present host root + checklist summary + resolved scope (roster — lint-added roles flagged / command split / domains) in a single `AskUserQuestion` and stop for confirmation before stamping. Skip when `$ARGUMENTS` carries `--build`, or on a zero-drift doctor re-run where every row is already `passing`.
6. **Build via stamp workers.** Past the checklist gate, partition non-`passing` rows and dispatch stamp workers per the Stamp workers contract. Workers stamp under `HARNESS_ROOT/` and `.workspace/` seeds per composition-standard (incl. W-I). You flip rows from worker evidence only — never stamp yourself.
7. **Doctor (every run reaches this step).** Re-audit / edit-safe upgrade (via scouts + stamp workers, not you) / idempotency / fresh-session checks per **Doctor mode**. Any fresh-session gap becomes a new `not_started` row.
8. **Finalize.** Record evidence on every flipped row → write the checklist's Handoff block (include `HARNESS_ROOT=…`) per `vibe-task-ledger` → tear down every scout and stamp worker so no subagent is left running, per `vibe-team-protocol`. Then report: host root, rows now `passing` / still `blocked` / still `not_started`, the stamped-file inventory, and the fresh-session-test result — "this repo is vibe-ready" or exactly what remains. Do **not** auto-run the next command.

<!-- Footer constraint: hard constraints live in Role above the midpoint; host root detect+ask; thin lead delegates scouts+stamp workers; stack detection Glob-only; seed paths resolved by the builder; determinism per the composition spec; boundary sentence verbatim; kernel by reference, never restated; Outline linear, ends Finalize. -->
