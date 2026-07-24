---
description: {{DESCRIPTION}}
opt-out: {{OPT_OUTS}}
---
<!-- vibe-template: templates/skeletons/command-skeleton.md v3 | generated 2026-07-24 | edits below this marker are yours -->
<!-- vibe:regen preset={{PRESET}} · flow-spec={{FLOW_SPEC}} — builder re-derives every FIXED section from these on --regen -->
<!-- BUILDER: DESCRIPTION = one line ≤80 words (command + state artifact), e.g. "Drive a plan to Implemented." OPT_OUTS = comma-separated FIXED-section headings (or the Finalize `commit` item) legitimately omitted (e.g. `opt-out: Clean-state exit gate`); a FIXED section absent without being named here is a generation bug, never silent deletion. An opted-out `commit` or `archive` is dropped from the Finalize chain (delete that arrow item); an opted-out `commit` also drops the "(if applicable) merge-back" arrow item that follows it (merge-back without a commit is meaningless); an opted-out `archive` also drops the "never archive a Blocked ledger" preamble clause; an opted-out section is omitted whole. Fill PRESET with the preset dir name, FLOW_SPEC with the flow file it was generated from. Hand-edits below the marker are preserved; this line is not. -->
## User Input
```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).
A `brief=<path>` token in the input is a pointer brief: read that file first — it is this run's full input (how a loop orchestrator dispatches this command; identical behavior run directly).
## Role
You are the team-lead orchestrating {{ROLE_SUMMARY}}. You are a thin lead: you dispatch, gate, and record — you never do a block's work yourself. **Hard boundary:** this command never edits project source; `Edit`/`Write` are used only for <named artifacts>.
Context discipline is non-negotiable — you read only via the `research-protocol` ladder and never widen into app code. Dispatch and teardown mechanics are `team-protocol`; task state, WIP=1, stop conditions, and the handoff block are `task-ledger`; every review scores against `review-protocol`. Reference them by name; never restate them here.
Signal discipline: append one `<utc hh:mm> | <slug> | <signal> | <one-line detail>` line to `.workspace/status.log` — `needs-user` immediately before any `AskUserQuestion`, and `done` or `blocked` at Finalize. Harmless run directly (a free audit trail); load-bearing under a loop orchestrator.
<!-- BUILDER: fill <named artifacts> with the exact files this command may write (the ledger/plan, the spec). Fill {{ROLE_SUMMARY}}: the team + the artifact driven. If worktree mode was chosen at GENERATION time, state it here and let `team-protocol` own the mechanics — there is NO runtime `--worktree` flag on a generated command. -->

{{FLOW}}
<!-- BUILDER Discover: the flow-specific middle — the ONLY flow slot; everything above and in the Outline below is FIXED. Emit the ordered blocks this command runs and, per block, the roles dispatched and the gate/checklist that block closes on. Block ordering is decided HERE by the plan/preset, never baked into the skeleton. e.g. a `## Blocks` list "Platform → Backend → Frontend, each closing before the next opens", the roster per block, and the review lens each block gates against. If the block has a test role, include the fix-routing rule: findings whose fix lands in test code re-dispatch to test-engineer; production-code fixes to engineer. -->

## Outline

1. **Clock-in.** Resolve the ledger's directory; `Grep -n '^## '` it for a section map; read only the header, Handoff block, Decision log, Open Questions, and any open tracked units — per `research-protocol` (never wide-read it). Resume point = the first tracked unit this command's flow leaves open (a ledger leaf not `passing` for a ledger-carrying command; the first flow block not yet closed for a design-phase command — as the flow defines). A target that doesn't exist yet (fresh run), or a section it doesn't have, makes that read vacuous — the flow's first step creates it; treat as a fresh start. If resolving the target from `$ARGUMENTS` is ambiguous or inferred, confirm via `AskUserQuestion` before proceeding.
2. **Gate check (entry).** Before any dispatch, confirm the ledger's Status / Open Questions / Dependencies are ready. Not ready → andon-cord per `team-protocol`; do not build on an unready artifact.
3. **Work loop (fixed shape).** Walk the blocks from the slot in order — one block fully closes before the next opens. Per block: **dispatch → wait → gate → advance**. Briefs and fan-out per `team-protocol`; close each tracked unit only on the gate evidence this command's flow names, and only you — for a ledger leaf, advance to `passing` only on reviewer-cited evidence per `review-protocol`/`task-ledger`; for a design-phase block, on the block's own exit gate; honor its stop conditions (max rounds, no-progress andon).
4. **Clean-state exit gate.** Before finalizing: build passes / all tests incl. pre-existing / ledger accurate / no stale artifacts / startup works — verified by command output — never merely written, compiling, or `--list`-verified. On FAIL: an unrun check → run it; a real defect → fix-route per the flow's rule and re-gate; can't reach green → andon-cord, never finalize around a red gate. (Opt-out-able: a command that builds no code names this section under `opt-out:`.)
5. **Finalize.** In this order — load-bearing, and never archive a Blocked ledger: evidence recorded (Verified line where applicable) → learnings captured → state-flip → write the Handoff block per `task-ledger` → (if applicable) archive → commit → (if applicable) merge-back → tear down the team so no teammate is left running, per `team-protocol` → append the `done`/`blocked` status line per the Role's signal discipline. Then report; do not auto-start the next phase — the user reviews first.

<!-- Footer constraint: hard constraints live in Role above the midpoint; ≤80 lines when implementation-loop-shaped; kernel by reference, never restated; boundary sentence verbatim; exactly ONE flow slot. -->

