<!-- vibe-template: presets/plan-implement/plan.md v1 | generated 2026-07-13 | edits below this marker are yours -->

<!-- This preset supplies command-skeleton.md's fills (below) and its ONE {{FLOW}} slot (bottom).
     The builder substitutes each FILL into the skeleton's frontmatter / Role, and injects the
     FLOW block verbatim into {{FLOW}}. Everything else in the generated command is FIXED skeleton
     text. plan-implement's plan is STANDALONE by design: no spec ever precedes it. -->

<!-- FILL DESCRIPTION -->
Drive a standalone technical plan to Ready for Implement — capture the goal and behaviors inline (no spec phase), research the codebase, design and critique the architecture, and author the task ledger.

<!-- FILL OPT_OUTS -->
Clean-state exit gate, commit, archive

<!-- FILL ROLE_SUMMARY -->
a planning team — codebase-researcher, architect, and critic — driving a standalone technical plan to Ready for Implement

<!-- FILL NAMED_ARTIFACTS -->
the plan at `.workspace/plans/<yymmdd-slug>/plan.md`

<!-- FILL END -->
<!-- OPT_OUTS rationale (not emitted): plan builds no code → `Clean-state exit gate`; the plan is
     left for the user to review before /implement → `commit` (the user commits after review). -->


<!-- FLOW: injected verbatim into command-skeleton.md's {{FLOW}} slot -->

## Team
codebase-researcher, architect, critic. No product-manager: this preset's plan is standalone — no spec ever precedes it, so the lead captures the WHAT inline and never drafts a product spec.

## Plan artifact & shape
- Drives the plan at `.workspace/plans/<yymmdd-slug>/plan.md` — the `vibe-task-ledger` (its `## Tasks` table) — to Status: Ready for Implement. Finished plans move to `.workspace/plans/archive/` — only `/implement` archives, at Implemented, so this command never does.
- This plan carries both the WHAT and the HOW — Behaviors (B-NNN) are captured inline in the plan's `## Behaviors` by the lead (block 1); Architecture and Tasks reference them by B-id.
- Sized for ONE team in one pass (~3–5 engineering deliverables per stack). No concept of parts — overflow → andon to the user (decomposition is a spec's job, and this preset has no spec).
- Planning learnings, if any, land in the plan's Decision Log — no separate learnings file this phase.

## Blocks (design phases, walked in the skeleton's work loop)
Blocks here are design phases: a block closes when its gate passes, not by a ledger leaf reaching `passing`. Tasks authored this run stay `not_started` for /implement; on resume, continue from the first design block not yet closed.
First: read `.workspace/constitution.md`. Derive a kebab-case slug from the input (2–4 words, action-noun, preserve acronyms); create `.workspace/plans/<yymmdd-slug>/` using today's date and copy the stamped plan template in as `plan.md`, filling its header (`Status: Draft`, `Depends on` prerequisite plan slugs or `—`, input).
1. **Capture Goal + Behaviors** — the lead writes a lightweight Goal + inline B-NNN into the plan's `## Behaviors` (observable lines for test traceability; no UX, no Out-of-Scope ceremony). A genuine scope ambiguity that would change the build → relay via `AskUserQuestion`, don't guess.
2. **Technical research** — the codebase-researcher fills `## Current State`, every claim cited `file:line`. The lead reads only the done-report, never the full research.
   - Pass the resolved path of the stamped plan template — {{PLAN_TEMPLATE_PATH}} <!-- BUILDER: where build-harness stamped templates/workspace/plan-template.md into this project --> — in every codebase-researcher/architect brief; agents can't expand variables themselves.
3. **Architecture** — the architect (backend) authors `## Architecture`, `## Test behaviors`, and each Task's verification; a ⚠️ choice (new tool/subsystem, or a constitution deviation) carries options + a recommendation.
4. **Critique gate** — the critic scores the design against its Architecture lens-set (this is the plan's "review" the fixed Role names); reconcile, don't rubber-stamp; cap at 3 revise cycles, then stop and report as-is; any unresolved ⚠️ → `## Open Questions`. A finding that the Behaviors themselves are wrong (not the design) → refine the inline `## Behaviors` yourself (standalone plan; no andon needed).

## Plan readiness gate (this plan's OWN exit gate — distinct from implement's clean-state exit gate)
Before Status → Ready for Implement, confirm: Open Questions is None · a Constitution line is present, and every ⚠️ in Architecture (Constitution or otherwise) carries options + a recommendation · every behavior has a delivering Task AND an entry in `## Test behaviors` · Tasks are ordered Platform → BE · Every header `Depends on` slug resolves to a real plan (acyclic across plans; `Implemented` is enforced at implement-entry) · every Task carries the closed state enum defined in `vibe-task-ledger` — the lead confirms this gate before the Finalize state-flip to Ready for Implement.
Report: B-range, engineering-task count per stack, Constitution ⚠️ count, and Open Questions verbatim.

<!-- FLOW END -->
