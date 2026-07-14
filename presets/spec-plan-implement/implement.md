<!-- vibe-template: presets/spec-plan-implement/implement.md v1 | generated 2026-07-13 | edits below this marker are yours -->

<!-- This preset supplies command-skeleton.md's fills (below) and its ONE {{FLOW}} slot (bottom).
     The builder substitutes each FILL into the skeleton's frontmatter / Role, and injects the
     FLOW block verbatim into {{FLOW}}. Everything else in the generated command is FIXED skeleton
     text — the work loop, the clean-state exit gate, teardown, and handoff are NOT restated here. -->

<!-- FILL DESCRIPTION -->
Drive a plan's task ledger to Implemented — dispatch each block's engineer, test-engineer, and reviewer, gate every leaf on cited review evidence, commit per reviewed block, and run the domain's tests green.

<!-- FILL OPT_OUTS -->
<!-- OPT_OUTS empty: implement uses every fixed section; builder omits the opt-out: line entirely -->

<!-- FILL ROLE_SUMMARY -->
an implementation team — engineers, test-engineers, reviewers, a qa-engineer, and an on-call architect — driving a plan's task ledger to Implemented

<!-- FILL NAMED_ARTIFACTS -->
the plan ledger at `.workspace/plans/<yymmdd-slug>/plan.md` and `.workspace/plans/<yymmdd-slug>/learnings.md`

<!-- FILL END -->


<!-- FLOW: injected verbatim into command-skeleton.md's {{FLOW}} slot -->

## Execution model
- Walk the plan's Task blocks in the plan's authored order — block order lives in the plan, never here.
- Entry: Status `Ready for Implement` (a mid-run resume per the ledger's Handoff block also qualifies); every header `Depends on` plan is `Implemented` — this command is where that promise is enforced.
- Commit: on, per block. When a block's build work is done, you commit it, then dispatch the block's review against that commit — the reviewer's verdict and each leaf's evidence cite that hash, per `vibe-task-ledger`/`vibe-review-protocol`; every fix round commits before re-review. Within a block, the build leaf holds the single `active` slot; sibling leaves (e.g. the test leaf) are authored while still `not_started` and flip straight to `passing` on the same reviewer Accept, every leaf's evidence citing the block's commit hash. The Finalize commit is the closing commit only (ledger state-flips, learnings, Handoff). At Status Implemented, archive = move `.workspace/plans/<yymmdd-slug>/` into `.workspace/plans/archive/` — this command is the only archiver.
- Worktree: off (in-place). `vibe-team-protocol` owns worktree mechanics for the variant.

## Roster per block
- **Platform / BE block** — the engineer (backend domain), the test-engineer (backend domain), the reviewer (backend domain); plus the architect (backend domain) on-call.
- **FE block** — the engineer (frontend domain), the test-engineer (frontend domain), the reviewer (frontend domain), and the qa-engineer; plus the architect (frontend domain) on-call.

## Per-block dispatch
- The engineer implements the block's non-test leaves; then the test-engineer (a fresh context) writes the block's test leaf — a block with no test leaf skips the test-engineer dispatch (its exit lens still applies).
- Review each closed leaf against the block's `<domain>-review` lens (`backend-review` / `frontend-review`); an FE user-facing leaf also gets a qa-engineer manual click-through.
- **Fix-routing** — route each finding by WHERE its fix lands, read from the finding's cited `file:line` / `fix` field, never by symptom (a red test is not an automatic route to the engineer): a fix in test code → re-dispatch the **test-engineer**; a fix in production code → re-dispatch the **engineer**. You make this call from the finding's cited path; reading a filename is not reading code.

## Exit lens (per domain — the level the clean-state exit gate checks per block)
- Platform / BE block → the integration suite ran and passed.
- FE / any user-facing block → the E2E suite ran green AND the qa-engineer manual click-through returned QA pass.

## Learnings
- At finalize, append dated lines to this run's `.workspace/plans/<yymmdd-slug>/learnings.md` (create if absent) — distinct from the curated `.workspace/learnings.md`, which only `/vibe:distill` writes.

<!-- FLOW END -->
