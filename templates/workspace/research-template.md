<!-- vibe-template: templates/workspace/research-template.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Research: [FEATURE NAME]

**Created**: [YYYY-MM-DD]   **Feature dir**: [yymmdd-slug]
**Question**: "[the feature request researched]"

<!--
PRODUCT research: facts about what the feature's area ALREADY DOES, written by `codebase-researcher`
at the start of /spec and consumed downstream: the team-lead reads ## Summary ONLY; the
product-manager and the critic read the whole file BEFORE framing/critiquing; /plan workers read
it too. The angle is product — what functionality exists, the user-facing surface, the gaps — NOT the
technical build structure. (Technical/architectural research lives in plan.md's `## Current State`,
written during /plan — not here.)

Mine the behaviour-based tests: the test suite documents what the system already does. Inventory those
existing behaviors in the same B-NNN-style language so the product-manager frames NEW behaviors as
deltas against them, not from scratch.

Rules:
- FACTS ONLY — no design proposals, no recommendations, no "we should".
- Every claim about code carries a `file:line` (or `file`) citation. An uncited claim doesn't count.
- Bullets, 1–2 lines each. Whole file ≤ ~120 lines.
- This is a snapshot, not a contract: consumers verify load-bearing facts via `codegraph` before
  relying on them.
-->

## Summary

<!-- ≤10 bullets, 1–2 lines each. The ONLY section the team-lead reads — structure it for framing:
what the feature's area ALREADY DOES vs what's MISSING for this feature; then the sharpest
risks/unknowns. Vague bullets are worse than none — be concrete. -->

-

## Existing behaviors *(mined from the test suite)*

<!-- What the system already does around this feature, inventoried in B-NNN-style language so the
product-manager frames new behaviors as deltas. Cite the test `file:line` that documents each. -->

-

## Current state

<!-- What exists today around this feature, from the product angle: the user-facing surface,
flows, entities the user touches, what's reachable in the UI. Cite everything. Note explicitly what
does NOT exist where a reader might assume it does. -->

-

## Conventions & reuse

<!-- Existing patterns and platform subsystems the design should build on instead of reinventing —
with one citation each as the canonical example. -->

-

## Constraints & risks

<!-- Platform realities, data shape constraints, prior plans touching this area
(.workspace/plans/, including archive/), migration landmines, and relevant
.workspace/learnings.md entries (cite the L-id — rejected decisions, env traps). -->

-

## Unknowns

<!-- What research could not settle. The team-lead resolves these at framing or promotes them to
the plan's Open Questions. "None" if empty. -->

- None
