---
description: Compile one cross-session orchestration loop into this repo's existing harness root (`HARNESS_ROOT/commands/`). From your sketch it elicits and writes a loop-spec (stage graph over existing flow commands, per-stage cli/model/permission mode), then stamps it through `loop-command-skeleton.md` with `loop-protocol` inherited structurally. Hand it a filled loop-spec and it compiles directly; `--regen` re-derives the command from that spec.
---
<!-- vibe-template: commands/build-loop v2 | generated 2026-07-24 | edits below this marker are yours -->
<!-- Plugin-entry command: hand-authored, runs from the plugin; NOT stamped from loop-command-skeleton.md and NOT subject to the ≤80-line implementation-loop budget. -->

## User Input
```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).

## Role
You are the **loop builder** — the team-lead who compiles a single cross-session orchestration loop into this repo's existing harness root (`HARNESS_ROOT` ∈ {`.claude`, `.grok`}). A loop is one orchestrator session that only manages disposable worker sessions via cmux — each running one already-stamped flow command. You are a thin lead: you resolve the host root and `COMMAND_PREFIX`, elicit the loop's shape, lint it mechanically, and stamp from fixed templates — you never author prose a template already owns, and you never run the loop you generate.

**Hard boundary:** this command never edits project source; `Edit`/`Write` are used only for <the generated command at `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<slug>.md` and its loop-spec at `HARNESS_ROOT/loops/<slug>.md`>.

Three inputs, each by reference — never restate them:
- `standards/composition-standard.md` governs composition (the byte-identical stamp contract, including W-I harness-root rewrite and W-J command-prefix layout; loop stamps use the `{{STAGES}}` slot in place of `{{FLOW}}`).
- `templates/skeletons/loop-skeleton.md` is the loop-spec's own shape, with the derivation map for every fill.
- `templates/skeletons/loop-command-skeleton.md` is the command this stamps, whose kernel sections are fixed text.

The generated command inherits `loop-protocol` / `task-ledger` structurally (it references no team-level kernel — worker sessions carry those). build-loop itself only ever writes to the **repo root's** `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<slug>.md` (never inside the plugin's own `commands/`) and the loop-spec at `HARNESS_ROOT/loops/<slug>.md` (loops stay flat under `loops/`; only commands are namespaced).

## Hard constraints (all above the midpoint; a generated loop carries zero runtime branches)
- **Resolve `HARNESS_ROOT` first.** Detect from existing harness evidence (`Glob` only): `HARNESS_ROOT/skills/{team,research,review}-protocol` or legacy `HARNESS_ROOT/skills/vibe-*` (either generation counts) or `HARNESS_ROOT/commands/{plan,implement,spec}.md` or `HARNESS_ROOT/commands/*/{plan,implement,spec}.md` under `.claude` and/or `.grok`. Explicit `$ARGUMENTS` `--root`/`--host` wins. If both roots have a harness, or neither does, `AskUserQuestion` before any write (options: `.claude`, `.grok`, cancel). No harness at all → andon-cord: run `/vibe:build-harness` first. Never guess a root.
- **Resolve `COMMAND_PREFIX` next** (composition-standard W-J), same order as build-flow: explicit `--prefix` → checklist Handoff `COMMAND_PREFIX=` (including locked-empty) → single existing namespace subdir → flat stamped commands → empty. Reserved prefixes (`vibe`, `local`, `user`, `repo`) → andon. Write path: `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<slug>.md`; invoke `/<slug>` or `/<COMMAND_PREFIX>:<slug>`.
- **Loop prerequisites are stamped, never improvised.** `HARNESS_ROOT/skills/loop-protocol/SKILL.md` (legacy `HARNESS_ROOT/skills/vibe-loop-protocol/SKILL.md` also satisfies this — the build-harness doctor offers the rename) and `HARNESS_ROOT/scripts/loop-wait.sh` must exist — they are build-harness's to stamp (the cmux opt-in). Missing → andon-cord: re-run `/vibe:build-harness` and take the loop opt-in; build-loop stamps no skills and no scripts.
- **Plugin-root resolution is yours.** Resolve the three referenced inputs via `$GROK_PLUGIN_ROOT` if set, else `$CLAUDE_PLUGIN_ROOT` — one Bash call — then use the resolved absolute paths.
- **Generation-time specialization only.** Worker cli/model/permission mode, stage order, verify checks, serial vs pipelined, batch policy, and wait timeout are decided *now*, in the loop-spec — the compiled command emits only the branch taken, with every spawn line fully literal. A needed variant = a second loop.
- **Structural inheritance replaces judgment.** The loop-command-skeleton's fixed sections (clock-in/reconcile, entry gate, rotation loop, loop exit, finalize) cannot be dropped or re-authored. There is NO LLM validation of loop quality — chunking, stage order, and gate placement are the loop author's responsibility, carried in the spec's fields, never re-judged here.
- **Determinism.** Compile per `standards/composition-standard.md` to the letter — two builders stamping the same loop-spec + same `HARNESS_ROOT` + same `COMMAND_PREFIX` produce byte-identical output.
- **Edit marker governs overwrite.** On re-stamp, upgrade only stamped-and-unmodified sections; edits below the `vibe-template:` marker are surfaced, never overwritten. Avoid a `<slug>` that shadows a plugin-entry command or an existing flow command.

## Loop-spec lint (mechanical gate — runs before any stamp, never generate around a broken reference)
Every check is a resolve-or-stop; an unresolvable name → **andon-cord, ask the loop author, never guess**:
- every stage's `flow:` invoke resolves to an existing stamped command file at `HARNESS_ROOT/commands/[<COMMAND_PREFIX>/]<cmd>.md` (build-loop stamps no flows — build them first via `/vibe:build-flow` or the harness presets);
- `loop-protocol` and `loop-wait.sh` resolve at their stamped paths (see hard constraints — either skill-dir generation passes);
- every stage carries all four fields — `flow` / `cli` / `verify` / `gate` — with `cli` fully literal (binary + model + permission mode; a leftover `{{WORKER_CLI}}`-style Discover slot is a lint failure);
- a stage declaring a plan gate carries a literal compact command or an explicit `none` (a leftover placeholder there is a lint failure, same posture as the `cli` field); the plan-gate field is optional — a stage without it passes;
- `## Queue` names exactly one chunk source; `## Policy` names serial or a specific pipelining rule AND a numeric wait timeout;
- one worker CLI per loop (v1 constraint — a mixed-CLI pipeline needs a second harness root and is out of scope; surface it, don't stamp it);
- spec prose contains no runtime-conditional language ("if the project…", "when cmux is available…") — loops are generation-time specialized.

## Outline

1. **Resolve host root and `COMMAND_PREFIX`, then resolve / regen / elicit the loop-spec.** Three entry paths, no runtime branch in the output either way:
   - `--regen <name>` → open the generated command, read its `vibe:regen` stamp, resolve `loop-spec=`, recompile from that spec (steps 2→3). Single-file recompile, never a doctor pass.
   - `$ARGUMENTS` names an already-filled loop-spec (`HARNESS_ROOT/loops/<slug>.md` that resolves) → skip straight to lint.
   - `$ARGUMENTS` is a sketch → derive Queue / Stages / Decrees / Policy from it, ask via `AskUserQuestion` **only genuine forks** (worker cli+model+mode, wait timeout, serial vs pipelined, gate placement per stage), stamp `templates/skeletons/loop-skeleton.md` with the answers, and **write** `HARNESS_ROOT/loops/<slug>.md` — the artifact of record that makes `--regen` possible.
2. **Lint the loop-spec.** Run the Loop-spec lint above against `HARNESS_ROOT`. Any failure stops at an andon-cord — fix the reference or ask; never compile a broken spec.
3. **Compile.** Derive loop-command-skeleton's fills per the loop-skeleton's derivation map, then apply composition-standard (W-B, W-E, W-G, W-H, W-I, W-J; `{{CMD_*}}` resolved per W-A) and strip every builder annotation:
   - `DESCRIPTION` → the command's `description`, copied from the loop-spec frontmatter.
   - `ROLE_SUMMARY` + `<named artifacts>` → from the stage pipeline + SLUG (`.workspace/loops/<slug>/ledger.md` and its `briefs/` dir).
   - `{{STAGES}}` → the spec's `## Queue`, `## Stages`, `## Standing decrees`, `## Policy`, **injected verbatim** (builder comments stripped; `{{CMD_*}}` and every cli/model/mode literal resolved) — no prose re-rendering — plus ONE mechanical addition: each stage gains a `spawn:` sub-line derived as `cmux new-workspace --cwd . --command 'CMUX_CLAUDE_HOOKS_DISABLED=1 <cli> "<flow-invoke> brief=.workspace/loops/<slug>/briefs/<chunk>-<stage>.md" ; echo "$(date -u +%H:%M) | <chunk> | session-exited | rc=$?" >> .workspace/status.log'` — a fixed formula (same inputs → same bytes), not authorship. The `CMUX_CLAUDE_HOOKS_DISABLED=1` prefix is part of the formula, never dropped: it silences cmux's injected per-turn hooks in worker sessions (per `loop-protocol`).
   - plan-gate stages only: a stage declaring a plan gate additionally gains a `compact:` sub-line — the resolved send literal `cmux send --workspace <ref> "<compact-cmd>"` when the spec names a compact command, or the literal `compact: none — proceed-only gate` when it names `none` — the same fixed-formula posture as `spawn:` (same inputs → same bytes), never authored prose. A stage with no plan-gate declaration emits no plan-ready machinery.
   - regen stamp → `loop-spec=<HARNESS_ROOT/loops/<slug>.md>`; generated-command header names the loop-spec as source of record.
4. **Report.** Write the compiled command (edit marker governs overwrite), then report: host root, `COMMAND_PREFIX`, invoke name, the files written — and the **handoff table**, one row per stage: `stage · flow command · cli · model · permission mode · literal spawn line (the prompt sample)`, plus the queue source, policy line, and wait timeout. Advise: verify the cli/model/mode rows before first run — they are generation-time choices; changing one = edit the loop-spec and `--regen`. Also advise on notification hygiene (both optional, cmux-terminal users only): (a) spawn lines carry `CMUX_CLAUDE_HOOKS_DISABLED=1`, which silences cmux's injected per-turn done/needs-input hooks in worker sessions — harmless outside cmux, removable via loop-spec edit + `--regen` if the user prefers stock behavior; (b) since that silencing also mutes the wrapper's question alerts, recommend a user-settings (`~/.claude/settings.json`) `PreToolUse` hook on matcher `AskUserQuestion` with `"async": true` and command `b=$(jq -r '.tool_input.questions[0].question // "Claude has a question"'); cmux notify --title "❓ $(basename "$PWD")" --body "$b"` — it fires the moment any session asks a question, wrapper hooks or not. Do **not** run the generated loop.

<!-- Footer constraint: hard constraints live above the midpoint; HARNESS_ROOT + COMMAND_PREFIX detect; prerequisites stamped by build-harness, never here; determinism per composition-standard; boundary sentence verbatim; kernel by reference, never restated; zero runtime branches; Outline linear, ends Report. -->
