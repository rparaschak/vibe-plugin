<!-- vibe-template: templates/checklists/review-generic.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Generic review checklist

Domain-agnostic review rules. The `reviewer` agent loads this as the `<domain>-review` checklist when no stack-specific one is named, and alongside a stack checklist when one is. Every line is a review rule — cite it in a finding as `why: convention/<rule>`.

**`[mech]` = mechanizable.** A `[mech]` rule is grep-able or lint-able; the reviewer's mechanized-checks-first step runs these before any prose reading. Untagged rules need human judgment over the diff.

## Correctness
- [ ] Errors are handled or propagated — none swallowed silently.
- [ ] No expensive call (query, network, disk) inside a loop.
- [ ] Boundary/off-by-one assumptions checked at the edges.
- [ ] Inputs crossing a trust boundary are validated before use.

## Hygiene
- [ ] No commented-out code in the diff.
- [ ] No leftover debug print / log / breakpoint. [mech]
- [ ] No new TODO/FIXME without a tracking reference. [mech]
- [ ] No hardcoded secret, credential, or token. [mech]
- [ ] No unused import, variable, or function introduced. [mech]
- [ ] No comment that only restates the code.

## Simplification
- [ ] No defensive search-before-write (no read-to-check before a delete/update).
- [ ] No magic number — name it a constant.
- [ ] No logic duplicating an existing helper.

## Tests
- [ ] No test duplicates another test's behavior.
- [ ] Access-control tests consolidated — one per role, not per endpoint.
