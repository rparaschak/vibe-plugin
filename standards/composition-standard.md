---
name: composition-standard
description: Determinism contract for composing a project command from `templates/skeletons/command-skeleton.md` plus a preset or flow-spec. Obeyed by any builder command that stamps commands this way (currently build-harness). Every rule is mechanically checkable.
---

<!-- vibe-template: standards/composition-standard v1 | generated 2026-07-13 | edits below this marker are yours -->

# Composition Standard

Obeyed by: any builder command that composes a project command from `templates/skeletons/command-skeleton.md` plus a preset or flow-spec — currently `build-harness`; future builders inherit this contract by reference, never by restating it.

The mandate: two conforming builders, given the same skeleton and the same preset/flow-spec, MUST stamp byte-identical output — no re-authoring, no re-ordering, no spacing drift. The rules below are the letter of that mandate.

## Composition spec (build determinism — apply exactly on every command/flow stamp)
Presets live at `presets/<preset>/*.md`; each supplies the skeleton's fills (`DESCRIPTION`, `OPT_OUTS`, `ROLE_SUMMARY`, `NAMED_ARTIFACTS`) and one FLOW block (between `<!-- FLOW … -->` and `<!-- FLOW END -->`), injected into `command-skeleton.md`'s single `{{FLOW}}` slot. When stamping:
- **W-A** — inject the FLOW block verbatim (no summarizing/re-authoring) but still resolve every embedded `{{PLACEHOLDER}}` inside it at stamp time: `{{SPEC_TEMPLATE_PATH}}`, `{{PLAN_TEMPLATE_PATH}}`, `{{RESEARCH_TEMPLATE_PATH}}` → the stamped-template paths (`.claude/templates/<name>.md`). "Verbatim" is exemption from re-authoring, not from placeholder resolution.
- **W-B** — every resolved file path substituted into generated text is backtick-wrapped.
- **W-C** — when a FIXED skeleton section is opted out, renumber the remaining `## Outline` steps sequentially — leave no gap at the removed step's old number.
- **W-D** — when `archive` is opted out, drop the exact clause "and never archive a Blocked ledger" — including the joining "and" — from the Finalize ordering line, not only the `archive` arrow item; the resulting text reads exactly "— load-bearing:".
- **W-E** — strip **every** builder-facing annotation from output in ALL cases (opted out or not): the `(Opt-out-able: …)` parenthetical, every `<!-- BUILDER… -->` / `<!-- FILL… -->` / rationale comment, and every `>` blockquote meta-note addressed to the builder (e.g. lines beginning `> Skeleton …` that explain how skeleton sections map). These are authoring-time notes, never runtime text.
- **W-F** — `opt-out:` names may target a full section heading **or** a Finalize sub-item (`archive`, `commit`); recognize both levels. Emit the frontmatter `opt-out:` line only when non-empty; omit the line entirely when empty.
- **W-G** — on every stamp, **including doctor re-runs of a section you actually re-emit**, rewrite that file's header `generated <date>` to today. (An idempotent re-run re-emits nothing, so no date moves — see Doctor.)
- **W-H** — emit exactly one blank line immediately above and below the injected `{{FLOW}}` content, regardless of the source file's blank lines.
- **`<named artifacts>`** — the angle-bracket slot in the boundary sentence is distinct from `{{PLACEHOLDER}}`; fill it from the preset's `FILL NAMED_ARTIFACTS`, comma-joined into prose — resolved, not left as a literal token.
- **Regen stamp** — fill the `<!-- vibe:regen preset={{PRESET}} · flow-spec={{FLOW_SPEC}} -->` line per builder, spelling out the inverse literally: build-harness stamps `preset=<preset-dir> · flow-spec=` (empty). build-flow stamps `preset= · flow-spec=<.claude/flows/<slug>.md>` (empty preset). Never `n-a` for the empty side — this makes `--regen` re-derivable.
- **Generated-command header** — for a preset stamp, the generated command's `vibe-template:` header names `presets/<preset>/<cmd>.md` and its version — never the skeleton; for a FLOW stamp it names the flow-spec (`.claude/flows/<slug>.md`). Doctor/drift-diff checks FIXED sections against `templates/skeletons/command-skeleton.md`, and the FLOW middle against the preset file (preset stamp) or the flow-spec's injected sections (FLOW stamp), respectively.
