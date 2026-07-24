---
loop: {{SLUG}}
description: {{DESCRIPTION}}
---
<!-- vibe-template: templates/skeletons/loop-skeleton.md v2 | generated 2026-07-24 | edits below this marker are yours -->
<!-- SLUG = the loop's short name → becomes `/<slug>` (or `/<COMMAND_PREFIX>:<slug>`), the generated command's filename, e.g. `roadmap`. DESCRIPTION = one line ≤80 words: the queue drained and the stage pipeline → becomes the command's frontmatter `description`. -->

This is a **LOOP SPEC**. You fill the `{{SLOTS}}` below; `/vibe:build-loop` compiles it into a lean, linear loop command through `loop-command-skeleton.md`. The generated command inherits the rotation lifecycle, signal grammar, bounded reads, and board **structurally** from `loop-protocol` — none of that is restated here. Everything CLI/model/mode-shaped is resolved HERE, at generation time — the compiled command carries zero runtime branches. build-loop re-derives the whole command from this file on `--regen`, so this file is the single source of truth.

## Queue
<!-- Fill: where chunks come from (a roadmap file, a fixed list) and how the loop ledger at `.workspace/loops/<slug>/ledger.md` is seeded from it — one leaf per chunk×stage. Also when queue edits are picked up (recommended: at clock-in, never mid-rotation). -->
{{QUEUE}}
<!-- e.g. Chunks live in `.workspace/roadmap.md`, one `## Chunk: <slug>` section each, priority-ordered, user-maintained. -->

## Stages
<!-- Fill: the ordered stages every chunk passes through — one worker session per stage. Per stage state four things (plus one optional):
       - flow: the flow command the worker runs (use `{{CMD_*}}` placeholders or invoke names that resolve in this harness);
       - cli: the worker CLI + flags — binary, model, permission mode (e.g. `claude --model opus --permission-mode acceptEdits`);
       - verify: the bounded checks proving the stage's claim (artifact Status lines, `git log --oneline`, push reached remote);
       - gate: what user approval means for this stage and WHERE it happens (always in the worker session — the loop never proxies);
       - plan-gate (optional): declare only on a stage whose flow pauses after planning inside the SAME session, e.g. `plan-gate: yes · compact: /compact` — the compact command is a generation-time literal for this stage's cli, or `compact: none` to degrade the gate to proceed-only; omit the field entirely when the stage has no plan pause. -->
{{STAGES}}
<!-- e.g. 1. plan — flow: {{CMD_PLAN}} · cli: claude --model opus --permission-mode acceptEdits · verify: plan header reads `Status: Ready for Implement` · gate: approval in the planner session; `done` MEANS user-approved. -->

## Standing decrees
<!-- Fill: the standing project rules every brief must carry by reference — branch + push targets, freeze rules, "leave pre-existing dirty files alone". Compiled into the ledger's `## Standing decrees` section at seed time; briefs cite that path, never restate it. -->
{{DECREES}}

## Policy
<!-- Fill: serial (the default — one live worker, WIP=1) or a named pipelining opt-in (e.g. "plan N+1 during implement N", worktree-isolated stages only); the wait timeout per rotation (~2× the slowest expected stage); any batch rule for small chunks (a stated rule, never improvised). -->
{{POLICY}}

<!-- build-loop, compiling this spec: DESCRIPTION → command `description`; QUEUE + STAGES + DECREES + POLICY → the {{STAGES}} slot (injected verbatim, builder comments stripped, `{{CMD_*}}` and cli/model/mode resolved at stamp; each stage additionally gains a mechanically derived `spawn:` sub-line — and, when it declares a plan gate, a resolved `compact:` sub-line — the fixed formulas in build-loop's compile step, never authored prose); SLUG → `<named artifacts>` (`.workspace/loops/<slug>/ledger.md` + `briefs/`) + {{ROLE_SUMMARY}}; LOOP_SPEC = this file's path → the command's regen stamp. -->
