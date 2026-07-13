<!-- vibe-template: presets/spec-plan-implement/spec.md v1 | generated 2026-07-13 | edits below this marker are yours -->

<!-- This preset supplies command-skeleton.md's fills (below) and its ONE {{FLOW}} slot (bottom).
     The builder substitutes each FILL into the skeleton's frontmatter / Role, and injects the
     FLOW block verbatim into {{FLOW}}. Everything else in the generated command is FIXED skeleton
     text. This is the spec phase: it captures the WHAT and builds no code. -->

<!-- FILL DESCRIPTION -->
Drive a feature spec to Ready for Plan — research current-state facts, frame the request through the product-manager's highest-leverage forks, draft and critique the behaviors, decompose oversized work into plan-sized pieces, and design the UX when the feature is user-facing.

<!-- FILL OPT_OUTS -->
Clean-state exit gate, commit, archive

<!-- FILL ROLE_SUMMARY -->
a specification team — a product-manager, a product-designer, a codebase-researcher, and a critic — driving a feature spec to Ready for Plan

<!-- FILL NAMED_ARTIFACTS -->
the spec at `.workspace/plans/<yymmdd-slug>/spec.md`

<!-- FILL END -->
<!-- OPT_OUTS rationale (not emitted): the spec builds no code → `Clean-state exit gate`; the spec is
     left for the user to review before /vibe:plan → `commit` (the user commits after review); nothing
     archives a spec — it is the artifact the user LOCKS, then feeds forward → `archive`. -->


<!-- FLOW: injected verbatim into command-skeleton.md's {{FLOW}} slot -->

## Team
product-manager, critic; product-designer on-call (UX, conditional); codebase-researcher. Spec is the WHAT, not the HOW — you never draft behaviors or design UX yourself: the product-manager owns Problem/Behaviors/Out of Scope/Assumptions, the product-designer owns `## UX structure`. You stay thin so the full behaviors draft is the PM's context, not yours.

## Spec artifact & shape
- Drives the spec at `.workspace/plans/<yymmdd-slug>/spec.md` — its Behaviors (B-NNN) — to Status: Ready for Plan. The spec is the artifact you LOCK before any architecture is designed; nothing archives a spec — the user reviews it, then runs /vibe:plan.
- Spec is the WHAT, not the HOW — Spec and plan are separate documents. The spec names behaviors; the HOW (data model, architecture, tasks) is the plan's job, referenced by B-id, never restated here.
- Sized so EACH plan it feeds fits ONE team in one pass (~3–5 engineering deliverables per stack). Work too big does not andon — decomposition is the spec's job: it becomes SEPARATE specs, each its own `.workspace/plans/<yymmdd-slug>/` dir with its own local B-ids, each feeding its own plan, wired by `Depends on` (an acyclic DAG). Fits in one → no split. B-IDs are LOCAL to this spec (B-001).
- No task ledger this phase and no learnings file — the spec IS the artifact; the Finalize handoff is a one-line resume note in the report, not a spec section.

## Blocks (product phases, walked in the skeleton's work loop)
> Skeleton leaf-loop maps here to product phases — a block "closes" when its gate passes; resume point = first block not yet closed. No task ledger this phase; the spec IS the artifact.
First: read `.workspace/constitution.md` (note constraining rules). Derive a kebab-case slug from the input (2–4 words, action-noun, preserve acronyms); the dir is `.workspace/plans/<yymmdd-slug>/` using today's date — create it and copy the stamped spec template in as `spec.md`, filling its header (`Created`, `Status: Draft`, `Depends on`, input).
1. **Product research** — the codebase-researcher fills `research.md`'s current-state map, mining the behaviour-based tests to inventory what the system already does; every claim cited `file:line`. You read only the done-report Summary, never the full research.
   - Pass the absolute path of the stamped spec template — {{SPEC_TEMPLATE_PATH}} <!-- BUILDER: where build-harness stamped templates/workspace/spec-template.md into this project --> — in every product-manager/product-designer brief; agents can't expand variables themselves. Pass the stamped research template — {{RESEARCH_TEMPLATE_PATH}} <!-- BUILDER: where build-harness stamped templates/workspace/research-template.md into this project --> — in the codebase-researcher brief.
2. **Frame the request** — the product-manager returns the 2–3 highest-leverage forks (the choices that change the build, not cosmetic clarifications). You relay them via `AskUserQuestion` and return the answers; you never analyze the research yourself.
3. **Draft behaviors** — the product-manager drafts Problem, Behaviors (B-NNN), Out of Scope, Assumptions into `spec.md` per the template. You read only the terse done-report.
4. **Critique gate** — the critic scores the spec against its Product lens-set (this is the spec's "review" the fixed Role names); reconcile, don't rubber-stamp; cap at 3 revise cycles, then stop and report as-is; any unresolved finding → `## Open Questions`. Then **Lock the behaviors** — nothing downstream (UX, or the plan's architecture) is built against an unvetted behavior.
5. **Size & decompose** — measure the locked behaviors + research Summary against one team's capacity. Overflow → the product-manager proposes seams (priority-first, then capability boundary); you put the split to the user via `AskUserQuestion` and record which behaviors land in WHICH SPEC, wired by `Depends on` (an acyclic DAG). Fits in one → no split. Then MATERIALIZE the split — for each spec beyond this one: create its `.workspace/plans/<yymmdd-slug>/` dir, copy the stamped spec template in, move its behaviors over renumbered LOCAL from B-001, set its header (`Depends on`, `Status: Draft`); each is left `Draft` for its own later `/vibe:spec` pass (UX, critique, readiness gate).
6. **Design UX** (only if the feature is user-facing AND the project's `product-design` skill resolves (checking for a `.claude/skills/<name>/` dir is fine — it isn't app code)) — the product-designer writes `spec.md`'s `## UX structure`; `--design` / `--no-design` in `$ARGUMENTS` overrides the skip either way. Skipped for purely technical work — this presence is the FE-bearing flag /vibe:plan later reads.

> Stub path: when the user wants to park the idea, capture Problem + Open Questions (Behaviors optional) and set `Status: Parked — Stub` — a later full pass finishes it; a stub never proceeds to decomposition or the readiness gate.

## Spec readiness gate (this spec's OWN exit gate — distinct from a later plan/implement gate)
Before Status → Ready for Plan, confirm: Open Questions is None · every behavior is one observable, testable line with a user-value priority · Out of Scope and Assumptions present (each ⚠️ high-impact assumption confirmed with the user or flagged unconfirmed) · if user-facing, `## UX structure` is present · the decomposition (if any) materializes each spec (own dir, local B-ids, Status) with its behaviors and `Depends on` edges — the lead confirms this gate before the Finalize state-flip to Ready for Plan. A blocked spec finalizes to `Status: Blocked — Open Questions`, never Ready for Plan.
Report: each spec produced — name, B-range, UX designed or why skipped, Status — plus `Depends on` edges and Open Questions verbatim.

<!-- FLOW END -->
