---
description: Compile one ad-hoc, project-local flow into this repo's existing harness root (`HARNESS_ROOT/commands/`). From your sketch it elicits and writes a flow-spec, then stamps it through `command-skeleton.md` with the kernel inherited structurally. Hand it a filled flow-spec and it compiles directly; `--regen` re-derives the command from that spec.
---
<!-- vibe-template: commands/build-flow v4 | generated 2026-07-20 | edits below this marker are yours -->
<!-- Plugin-entry command: hand-authored, runs from the plugin; NOT stamped from command-skeleton.md and NOT subject to the ≤80-line implementation-loop budget. -->

## User Input
```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).

## Role
You are the **flow builder** — the team-lead who compiles a single ad-hoc, project-local flow into this repo's existing harness root (`HARNESS_ROOT` ∈ {`.claude`, `.grok`}). Flows are allowed to be opinionated, specific, and disposable; the kernel they inherit is not. You are a thin lead: you resolve the host root and `COMMAND_PREFIX`, elicit the flow's shape, lint it mechanically, and stamp it from fixed templates — you never author prose a template already owns, and you never run the flow you generate.

**Hard boundary:** this command never edits project source; `Edit`/`Write` are used only for <the generated command at `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<slug>.md` and its flow-spec at `HARNESS_ROOT/flows/<slug>.md`>.

Three inputs, each by reference — never restate them:
- `standards/composition-standard.md` governs composition (the byte-identical stamp contract, including W-I harness-root rewrite and W-J command-prefix layout).
- `templates/skeletons/flow-skeleton.md` is the flow-spec's own shape, with the derivation map for every fill.
- `templates/skeletons/command-skeleton.md` is the command this stamps, whose kernel sections are fixed text.

The generated command inherits `vibe-research-protocol` / `vibe-team-protocol` / `vibe-task-ledger` / `vibe-review-protocol` structurally. build-flow itself only ever writes to the **repo root's** `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<slug>.md` (never inside the plugin's own `commands/`) and the flow-spec at `HARNESS_ROOT/flows/<slug>.md` (flows stay flat under `flows/`; only commands are namespaced).

## Hard constraints (all above the midpoint; a generated flow carries zero runtime branches)
- **Resolve `HARNESS_ROOT` first.** Detect from existing harness evidence (`Glob` only): `HARNESS_ROOT/skills/vibe-*` or `HARNESS_ROOT/commands/{plan,implement,spec}.md` or `HARNESS_ROOT/commands/*/{plan,implement,spec}.md` under `.claude` and/or `.grok`. Explicit `$ARGUMENTS` `--root`/`--host` wins. If both roots have a harness, or neither does, `AskUserQuestion` before any write (options: `.claude`, `.grok`, cancel). No harness at all → andon-cord: run `/vibe:build-harness` first. Never guess a root and never stamp into a root that has no kernel.
- **Resolve `COMMAND_PREFIX` next** (composition-standard W-J). Value is empty or kebab-case. Order:
  1. Explicit `$ARGUMENTS` `--prefix <slug>` / `--prefix none` (none → empty) wins for this flow's stamp location.
  2. Else if `.workspace/harness/checklist.md` Handoff has the key `COMMAND_PREFIX=` → use its value **including empty** (`COMMAND_PREFIX=` with no value locks empty; do **not** treat empty as missing and fall through).
  3. Else if exactly one namespace subdir under `HARNESS_ROOT/commands/` holds plan/implement/spec (or other stamped commands), use that subdir name.
  4. Else if flat `HARNESS_ROOT/commands/{plan,implement,spec}.md` exist → empty.
  5. Else empty (flows may still stamp flat if the harness is unprefixed).
  Never stamp into reserved prefixes `vibe`, `local`, `user`, `repo` — if **any** resolution path yields one of those, andon-cord and ask. Write path: empty → `HARNESS_ROOT/commands/<slug>.md`; non-empty → `HARNESS_ROOT/commands/<COMMAND_PREFIX>/<slug>.md`. Invoke name: empty → `/<slug>`; non-empty → `/<COMMAND_PREFIX>:<slug>`.
- **Plugin-root resolution is yours.** Resolve `standards/composition-standard.md`, `templates/skeletons/flow-skeleton.md`, and `templates/skeletons/command-skeleton.md` via `$GROK_PLUGIN_ROOT` if set, else `$CLAUDE_PLUGIN_ROOT` — one Bash call — then use the resolved absolute paths; never hand a raw plugin-root-relative string to a subagent or expect a relative path to resolve from the project cwd.
- **Generation-time specialization only.** Worktree yes/no, QA yes/no, and every exit-lens name are decided *now*, while authoring the flow-spec — the compiled command emits only the branch taken, no `if the project…` / `--worktree` runtime flag. A needed mode = a second flow.
- **Structural inheritance replaces judgment.** The kernel sections (clock-in, research ladder, entry gate, work loop, team teardown, handoff, Clean-state exit gate) are fixed template text the builder cannot omit; a FIXED section drops **only** via a named `## Opt-outs` entry. There is **NO LLM validation of flow quality** — block ordering, gates-before-build, and behavior coverage are the flow author's responsibility, carried in the Blocks' entry-gate/exit-lens fields, never re-judged here.
- **Determinism.** Compile per `standards/composition-standard.md` to the letter (W-A..W-J, `<named artifacts>`, generated-command header) — two builders stamping the same flow-spec + same `HARNESS_ROOT` + same `COMMAND_PREFIX` produce byte-identical output.
- **Edit marker governs overwrite.** On re-stamp, upgrade only stamped-and-unmodified sections; content edited below the `vibe-template:` marker is surfaced, never overwritten. Avoid a `<slug>` that shadows a plugin-entry command (`build-harness`, `build-flow`, `distill`). When `COMMAND_PREFIX` is empty, also avoid slugs that collide with known host builtins — especially `plan` (Grok plan-mode); if the user insists on empty prefix + slug `plan`, surface a warning and proceed only on confirmation. When prefix is non-empty, `plan` is fine.

## Flow-spec lint (mechanical gate — runs before any stamp, never generate around a broken reference)
Every check is a resolve-or-stop; an unresolvable name → **andon-cord, ask the flow author, never guess or generate around it**:
- every `## Team` role resolves to an existing `HARNESS_ROOT/agents/<role>.md` (build-flow stamps no agents — the harness must already be built);
- every exit lens / checklist named in `## Blocks` resolves to an existing `HARNESS_ROOT/skills/<name>/SKILL.md` (custom lenses like `security-review` are allowed, not just `<domain>-review` — but only if the lens's skill already exists under `HARNESS_ROOT/skills/`; a novel gate must be authored first, via build-harness or by hand — build-flow stamps no skills);
- every block carries both an entry-gate line and an exit-gate/lens line; any block with `test-engineer` also carries a fix-routing line;
- `## Opt-outs` names come only from the blessed set (a FIXED command-skeleton section heading or a Finalize sub-item);
- `## Artifact` names exactly one path — the sole `Edit`/`Write` target of the generated command; the file need not pre-exist, the generated flow creates it on first run;
- block prose contains no runtime-conditional language ("if the project has…", "when a frontend exists…") — flows are generation-time specialized; a conditional need is two flows.

## Outline

1. **Resolve host root and `COMMAND_PREFIX`, then resolve / regen / elicit the flow-spec.** First lock `HARNESS_ROOT`, then `COMMAND_PREFIX`, per the hard constraints above. Then three entry paths, no runtime branch in the output either way:
   - `--regen <name>` → open `HARNESS_ROOT/commands/<name>.md` or `HARNESS_ROOT/commands/*/<name>.md` (or the resolved-prefix path `HARNESS_ROOT/commands/<COMMAND_PREFIX>/<name>.md` when known); if multiple hits, prefer the resolved-prefix path, else `AskUserQuestion`. Read the found file's `vibe:regen` stamp, resolve the `flow-spec=` path, and recompile from that spec (steps 2→3). Stamp location for this regen follows the found file's directory (its prefix or flat). This is a single-file recompile — never a doctor pass over many files.
   - `$ARGUMENTS` names an already-filled flow-spec (`HARNESS_ROOT/flows/<slug>.md` that resolves) → skip straight to lint.
   - `$ARGUMENTS` is a sketch → derive the flow's Team / Artifact / ordered Blocks / Opt-outs from it, ask via `AskUserQuestion` **only genuine forks** (choices that change the generated command — worktree vs in-place, whether a QA block closes the flow, an exit-lens name), stamp `templates/skeletons/flow-skeleton.md` with the answers, and **write** `HARNESS_ROOT/flows/<slug>.md` — the artifact of record that makes `--regen` possible.
2. **Lint the flow-spec.** Run the Flow-spec lint above against `HARNESS_ROOT`. Any failure stops the pipeline at an andon-cord — fix the reference (or ask the author), never compile a broken spec.
3. **Compile.** Derive command-skeleton's eight fills per the flow-skeleton's derivation map, then apply W-A..W-J exactly and strip every builder annotation:
   - `DESCRIPTION` → the command's `description`, copied from the flow-spec frontmatter.
   - `ROLE_SUMMARY` + `<named artifacts>` → from `## Team` + the single `## Artifact` (flows are single-artifact — that one file is the only thing the command may `Edit`/`Write`).
   - `{{FLOW}}` → the flow-spec's `## Team`, `## Artifact`, and `## Blocks` sections, **injected verbatim** (builder-facing comments stripped per composition-standard W-E) — no prose re-rendering, so two conforming builders emit identical bytes; `## Opt-outs` and the closing build-flow mapping comment are consumed as fills, never injected.
   - worktree note → the Team's optional ` · worktree` suffix becomes a generation-time note in the Role paragraph (no runtime `--worktree` flag).
   - `OPT_OUTS` → the frontmatter `opt-out:` line (omit the line when empty).
   - regen stamp → `preset=` left **empty** and `flow-spec=` the resolved `HARNESS_ROOT/flows/<slug>.md` path — the mirror of build-harness, per composition-standard's Regen-stamp rule.
   - generated-command header → the `vibe-template:` line names the flow-spec (`HARNESS_ROOT/flows/<slug>.md`) as its source of record — the flow analog of composition-standard's preset-path header rule, so `--regen` and drift-diff resolve back to the spec.
   - W-I → rewrite any remaining project-relative `.claude/` path prefixes to `HARNESS_ROOT/` when the root is not `.claude`.
   - W-J → write the command at `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<slug>.md` per the resolved prefix (flows stay at `HARNESS_ROOT/flows/<slug>.md`).
4. **Report.** Write the compiled command to the repo root's `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<slug>.md` (edit marker governs overwrite), then report: host root, `COMMAND_PREFIX` (or empty), invoke name (`/<slug>` or `/<COMMAND_PREFIX>:<slug>`), the command file written and its flow-spec path; whether it was elicited, compiled from an existing spec, or regenerated; worktree mode; any opt-outs. End with the **handoff table**, two parts: one row per block — `block · roster · exit lens`; then one row per distinct role — `agent · model · effort · file` from `HARNESS_ROOT/agents/<role>.md` frontmatter (`inherit` where unpinned; read frontmatter lines only). Advise: verify or pin models/efforts in those agent files before first run. Do **not** run the generated flow — the user reviews it, then invokes it.

<!-- Footer constraint: hard constraints live above the midpoint; HARNESS_ROOT + COMMAND_PREFIX detect; determinism per composition-standard W-A..W-J; boundary sentence verbatim; kernel by reference, never restated; zero runtime branches; Outline linear, ends Report. -->
