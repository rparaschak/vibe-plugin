---
flow: {{SLUG}}
description: {{DESCRIPTION}}
---
<!-- vibe-template: templates/skeletons/flow-skeleton.md v1 | generated 2026-07-13 | edits below this marker are yours -->
<!-- SLUG = the flow's short name → becomes `/vibe:<slug>`, the generated command's filename, e.g. `strangler-fig`. DESCRIPTION = one line ≤80 words: what the flow does and drives <artifact> until every leaf is `passing` → becomes the command's frontmatter `description`. -->

This is a **FLOW SPEC**. You (or `/vibe:distill`) fill the `{{SLOTS}}` below; `/vibe:build-flow` compiles it into a lean, linear command through `command-skeleton.md`. Every fixed kernel section of that command — clock-in, the research ladder, entry gate, work loop, team teardown, handoff write-out — is inherited **structurally and cannot be dropped**. You describe only the flow-specific middle: the team, the artifact it drives, and the ordered blocks. build-flow re-derives the whole command from this file on `--regen`, so this file is the single source of truth — no other regen stamp is needed.

## Team
<!-- Fill: the agent roles this flow stamps into `.claude/agents/`, comma-separated. Use exact template names — the flow cannot dispatch a role it never stamped. Pick from: architect, critic, engineer, test-engineer, reviewer, qa-engineer, product-manager, product-designer, codebase-researcher. -->
{{TEAM}}
<!-- e.g. engineer, test-engineer, reviewer -->
<!-- Optional: append ` · worktree` to run each block in its own git worktree; omit for in-place. `vibe-team-protocol` owns the mechanics. -->

## Artifact
<!-- Fill: the single file this flow reads and writes as its ledger/state. This is the ONLY project file the generated command may `Edit`/`Write` — it never touches app source — so it fills the command's hard-boundary sentence. Learnings captured at finalize live in a `## Learnings` section of this same artifact — a flow never opens a second file. -->
{{ARTIFACT}}
<!-- e.g. .workspace/strangler/ledger.md -->

## Blocks
<!-- Fill: the ordered stages the flow runs — one block fully closes before the next opens. For EACH block state three things:
       - roster: which Team roles run in it;
       - entry gate: what must be ready/true before it starts;
       - exit lens: the review checklist or verification that proves it done (what the block gates against).
     If a block includes test-engineer, ALSO give its fix-routing rule: findings whose fix lands in TEST code re-dispatch to test-engineer; production-code fixes go to engineer. Fix-routing may target a standing role spawned in an earlier block without re-listing it in the roster. Block order lives here, never in the skeleton. -->
{{BLOCKS}}
<!-- e.g.
     1. Characterize — roster: test-engineer · entry: target module identified · exit: characterization tests green (backend-review); fix-routing: test defects → test-engineer.
     2. Extract — roster: engineer, reviewer · entry: block 1 passing · exit: new module carries the behavior, all tests incl. pre-existing green (backend-review); fix-routing: impl defects → engineer, test defects → test-engineer.
     3. Cut over — roster: engineer, reviewer, qa-engineer · entry: block 2 passing · exit: old path deleted, E2E + manual QA pass. -->

## Opt-outs
<!-- Fill: name any FIXED command-skeleton section this flow legitimately omits (comma-separated), or leave blank. Opt-outs are the only sanctioned way to drop a fixed section — the builder treats an unnamed-but-absent section as a generation bug (see command-skeleton). Common cases: `Clean-state exit gate` for a flow that builds no code; `commit` to leave committing to the user (the builder then omits it from Finalize). You may NEVER opt out of the kernel disciplines the command references (research ladder, andon cord, team teardown, handoff) — those are structural, not sections. -->
{{OPT_OUTS}}
<!-- e.g. (blank) — or: Clean-state exit gate -->

<!-- build-flow, compiling this spec: DESCRIPTION → command `description`; TEAM → agents stamped + {{ROLE_SUMMARY}}; ARTIFACT → the Role boundary's <named artifacts> + {{ROLE_SUMMARY}}; BLOCKS → the {{FLOW}} slot (ordered blocks, per-block roster, gate/checklist lens, fix-routing); OPT_OUTS → the command's `opt-out:` line; worktree flag → Role paragraph note; PRESET = `flow`, FLOW_SPEC = this file's path → the command's regen stamp. -->
