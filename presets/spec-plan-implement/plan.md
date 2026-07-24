<!-- vibe-template: presets/spec-plan-implement/plan.md v2 | generated 2026-07-24 | edits below this marker are yours -->

<!-- This preset supplies command-skeleton.md's fills (below) and its ONE {{FLOW}} slot (bottom).
     The builder substitutes each FILL into the skeleton's frontmatter / Role, and injects the
     FLOW block verbatim into {{FLOW}}. Everything else in the generated command is FIXED skeleton
     text. spec-plan-implement's plan is SPEC-FED by design: a spec always precedes it — behaviors
     come from the locked spec by B-id, never captured inline. -->

<!-- FILL DESCRIPTION -->
Drive a spec-fed technical plan to Ready for Implement — resolve the locked spec and the B-ids this plan covers, research the codebase, design and critique the architecture, and author the task ledger.

<!-- FILL OPT_OUTS -->
Clean-state exit gate, commit, archive

<!-- FILL ROLE_SUMMARY -->
a planning team — codebase-researcher, architect, and critic — driving a spec-fed technical plan to Ready for Implement

<!-- FILL NAMED_ARTIFACTS -->
the plan at `.workspace/plans/<yymmdd-slug>/plan.md`

<!-- FILL END -->
<!-- OPT_OUTS rationale (not emitted): plan builds no code → `Clean-state exit gate`; the plan is
     left for the user to review before {{CMD_IMPLEMENT}} → `commit` (the user commits after review). -->


<!-- FLOW: injected verbatim into command-skeleton.md's {{FLOW}} slot -->

## Team
codebase-researcher, architect, critic. No product-manager: behaviors are locked in the spec; a product/behavior question the spec can't settle → relay to the user via `AskUserQuestion`, never guessed — this preset's plan never drafts or edits behaviors; they are the spec's, referenced by B-id.

## Plan artifact & shape
- Drives the plan at `.workspace/plans/<yymmdd-slug>/plan.md` — the `task-ledger` (its `## Tasks` table) — to Status: Ready for Implement. Finished plans move to `.workspace/plans/archive/` — only `{{CMD_IMPLEMENT}}` archives, at Implemented, so this command never does.
- Plan is the HOW, not the WHAT — Spec and plan are separate documents. This plan references behaviors by B-id; it never restates them.
- Sized for ONE team in one pass (~3–5 engineering deliverables per stack). This plan covers ALL of its spec's B-ids (the spec is sized to exactly one plan). Each spec feeds exactly one plan; cross-plan `Depends on` comes from the specs' own `Depends on` edges. Overflow within a single plan → the spec under-decomposed; relay to the user (decomposition is the spec's job, never this command's).
- Planning learnings, if any, land in the plan's Decision Log — no separate learnings file this phase.

## Blocks (design phases, walked in the skeleton's work loop)
Blocks here are design phases: a block closes when its gate passes, not by a ledger leaf reaching `passing`. Tasks authored this run stay `not_started` for {{CMD_IMPLEMENT}}; on resume, continue from the first design block not yet closed.
First: read `.workspace/constitution.md`. The spec's dir already exists — copy the stamped plan template in as `plan.md` and fill its header (`Status: Draft`, `Depends on` from the spec's edges, input).
1. **Resolve the spec + behaviors** — resolve WHICH spec (its dir from the plan target / `$ARGUMENTS`). The spec's Status MUST be `Ready for Plan` — if not, andon to the user (never build on an unlocked spec). Read the spec's Behaviors and record the B-ids THIS plan delivers (its spec's full local B-set); behaviors come FROM the spec by B-id — never restated, never invented. The spec's `## UX structure` present → sets FE-bearing for block 4.
2. **Technical research** — the codebase-researcher fills `## Current State`, every claim cited `file:line`. The lead reads only the done-report, never the full research.
   - Pass the resolved path of the stamped plan template — {{PLAN_TEMPLATE_PATH}} <!-- BUILDER: where build-harness stamped templates/workspace/plan-template.md into this project --> — in every codebase-researcher/architect brief; agents can't expand variables themselves.
3. **Architecture — BE** — the architect (backend) authors `## Architecture` (BE), `## Test behaviors`, and each Task's verification; a ⚠️ choice (new tool/subsystem, or a constitution deviation) carries options + a recommendation.
4. **Architecture — FE** (only if FE-bearing from block 1) — the architect (frontend) appends FE content; never edits BE-authored content.
5. **Critique gate** — the critic scores the design against its Architecture lens-set (this is the plan's "review" the fixed Role names); reconcile, don't rubber-stamp; cap at 3 revise cycles, then stop and report as-is; any unresolved ⚠️ → `## Open Questions`. A finding that the Behaviors themselves are wrong (not the design) → andon back to the user; this plan never edits the locked behaviors.

## Plan readiness gate (this plan's OWN exit gate — distinct from implement's clean-state exit gate)
Before Status → Ready for Implement, confirm: Open Questions is None · a Constitution line is present, and every ⚠️ in Architecture (Constitution or otherwise) carries options + a recommendation · every behavior has a delivering Task AND an entry in `## Test behaviors` · Tasks are ordered Platform → BE → FE · Every header `Depends on` slug resolves to a real plan (acyclic across plans; `Implemented` is enforced at implement-entry) · every Task carries the closed state enum defined in `task-ledger` — the lead confirms this gate before the Finalize state-flip to Ready for Implement.
Report: the plan's B-id range (its spec's full set), engineering-task count per stack, Constitution ⚠️ count, and Open Questions verbatim.

<!-- FLOW END -->
