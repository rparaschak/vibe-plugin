---
flow: {{SLUG}}
description: {{DESCRIPTION}}
---
<!-- vibe-template: templates/skeletons/flow-skeleton.md v3 | generated 2026-07-24 | edits below this marker are yours -->
<!-- SLUG = the flow's short name → becomes `/<slug>`, the generated command's filename, e.g. `strangler-fig`. DESCRIPTION = one line ≤80 words: what the flow does and drives <artifact> until every leaf is `passing` → becomes the command's frontmatter `description`. -->

This is a **FLOW SPEC**. You (or `/vibe:distill`) fill the `{{SLOTS}}` below; `/vibe:build-flow` compiles it into a lean, linear command through `command-skeleton.md`. Every fixed kernel section of that command — clock-in, the research ladder, entry gate, work loop, team teardown, handoff write-out — is inherited **structurally and cannot be dropped**. You describe only the flow-specific middle: the team, the artifact it drives, and the ordered blocks. build-flow re-derives the whole command from this file on `--regen`, so this file is the single source of truth — no other regen stamp is needed.

## Team
<!-- Fill: the agent roles this flow dispatches, comma-separated. Every role MUST resolve to an already-stamped HARNESS_ROOT/agents/<role>.md (HARNESS_ROOT is .claude or .grok) — build-flow stamps no agents; a missing role means build the harness (or the agent) first. Use exact template names. Pick from: architect, critic, engineer, test-engineer, reviewer, qa-engineer, product-manager, product-designer, codebase-researcher. -->
{{TEAM}}
<!-- e.g. engineer, test-engineer, reviewer -->
<!-- Optional: append ` · worktree` to run each block in its own git worktree; omit for in-place. `team-protocol` owns the mechanics. -->
<!-- Optional: mark a consulting-only role ` (on-call)` (e.g. `critic (on-call)`) — it appears in the generated Role summary and in each block's fix-routing/roster line where it serves; it is never a separate dispatch stage. -->
<!-- Optional: append ` · lead-hands-on` to declare that this flow's team-lead may itself fix SMALL defects (a few lines, shape already decided) and write 1–2 accompanying tests, dispatching engineer/test-engineer only when an assignment is larger than that; review of the lead's own edits by a reviewer stays mandatory — the lead never reviews its own work. build-flow compiles this into the command's Role carve-out sentence; without the marker the standard hands-off boundary stands. -->

## Artifact
<!-- Fill: the single file this flow reads and writes as its ledger/state. This is the ONLY project file the generated command may `Edit`/`Write` — it never touches app source — so it fills the command's hard-boundary sentence. Learnings captured at finalize live in a `## Learnings` section of this same artifact — a custom flow never opens a second file. (The built-in plan/implement presets use their own per-run learnings split — see `presets/*/implement.md`.) Commands that append to this artifact's log sections (learnings, decisions, skips) must use sentinel-append per `task-ledger` — one Edit against the section's closing sentinel, no pre-read. -->
{{ARTIFACT}}
<!-- e.g. .workspace/strangler/ledger.md -->

## Blocks
<!-- Fill: the ordered stages the flow runs — one block fully closes before the next opens. For EACH block state three things:
       - roster: which Team roles run in it;
       - entry gate: what must be ready/true before it starts;
       - exit lens: the review checklist or verification that proves it done (what the block gates against).
     If a block includes test-engineer, ALSO give its fix-routing rule: findings whose fix lands in TEST code re-dispatch to test-engineer; production-code fixes go to engineer. Fix-routing may target a standing role spawned in an earlier block without re-listing it in the roster. Block order lives here, never in the skeleton.
     Post-plan pause: a flow whose blocks include both planning and implementing in ONE session MUST declare it — the planning block ends with the plan written to disk and the turn ENDED (under a loop: append `plan-ready` to the status log per `loop-protocol`; direct-run: stop and await the user's proceed). Never roll plan→implement in the same turn — implement starts on the proceed, reading the plan from disk, so plan-phase context is disposable. -->
{{BLOCKS}}
<!-- e.g.
     1. Characterize — roster: test-engineer · entry: target module identified · exit: characterization tests green (backend-review); fix-routing: test defects → test-engineer.
     2. Extract — roster: engineer, reviewer · entry: block 1 passing · exit: new module carries the behavior, all tests incl. pre-existing green (backend-review); fix-routing: impl defects → engineer, test defects → test-engineer.
     3. Cut over — roster: engineer, reviewer, qa-engineer · entry: block 2 passing · exit: old path deleted, E2E + manual QA pass. -->

## Adaptive dispatch *(optional — omit for always-full-ceremony flows)*
<!-- Fill ONLY if this flow sizes ceremony to the work (delete the section otherwise; absent → build-flow emits nothing). Declaring it makes dispatch KIND-SIZED: every work item is classified **design** (uncertain shape — needs research/architecture/critic stages) or **mechanical** (shape known — repetitive, contract-preserving); never mixed in one item — a mixed item is split first.
     Chunk-sizing (flows that cut a module/roadmap into items): an item is what one session can plan+build+ship — kind-pure and dependency-closed. Design items cut along coupling boundaries, 2–5 slices, never through a shared contract; mechanical batches cap at ~8–10 independent entries; a tracker map row stays ONE line (file lists live in a per-item subsection, never in the row).
     The mechanical path may skip default stages (research dispatch, critic pass) ONLY via the plan's Skip log per `task-ledger` — one line per skip, never silently, and a skip line never satisfies an evidence gate. Fill below the flow's **hard invariants**: the steps NEVER skipped regardless of kind — at minimum the evidence gate on every leaf, review before `passing`, the clean-state exit gate when present. build-flow compiles the invariants list into the command verbatim.
     Category-reuse: an earlier green verification category may stand as evidence for a later gate IFF no code change landed after it ran; reuse is a Skip-log line (`- skipped re-run <category> — green at <commit>, no code change since`).
     Tracker narrow-read: a compiled adaptive flow reads its tracker narrowly — grep the item's row + Read ±5 lines, never the whole map (composes with the Artifact comment's sentinel-append rule). -->
{{ADAPTIVE_DISPATCH}}
<!-- e.g. hard invariants: evidence gate on every leaf, review before `passing`, clean-state exit gate. -->

## Opt-outs
<!-- Fill: name any FIXED command-skeleton section this flow legitimately omits (comma-separated), or leave blank. Opt-outs are the only sanctioned way to drop a fixed section — the builder treats an unnamed-but-absent section as a generation bug (see command-skeleton). Common cases: `Clean-state exit gate` for a flow that builds no code; `commit` to leave committing to the user (the builder then omits it from Finalize). You may NEVER opt out of the kernel disciplines the command references (research ladder, andon cord, team teardown, handoff) — those are structural, not sections. -->
{{OPT_OUTS}}
<!-- e.g. (blank) — or: Clean-state exit gate -->

<!-- build-flow, compiling this spec: DESCRIPTION → command `description`; TEAM → agent roles resolved to existing HARNESS_ROOT/agents/<role>.md (build-flow stamps no agents) + {{ROLE_SUMMARY}}; ARTIFACT → the Role boundary's <named artifacts> + {{ROLE_SUMMARY}}; BLOCKS → the {{FLOW}} slot (ordered blocks, per-block roster, gate/checklist lens, fix-routing); OPT_OUTS → the command's `opt-out:` line; worktree flag → Role paragraph note; ` · lead-hands-on` flag → the Role paragraph's fixed carve-out sentence (absent → standard hands-off boundary); `## Adaptive dispatch` present → its invariants list + skip-log rule + narrow-read rule + category-reuse rule compiled into the command (absent → nothing emitted); post-plan pause declared in BLOCKS → the compiled block sequence carries the pause + `plan-ready` line; PRESET = empty (regen stamp's `preset=` left blank), FLOW_SPEC = this file's path → the command's regen stamp. -->
