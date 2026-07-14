---
name: review-generic
description: Domain-agnostic review baseline — the `reviewer` agent always loads it (alongside any `<component>-review` stack lens) and runs its mechanized gate first.
---
<!-- vibe-template: templates/checklists/review-generic.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Generic review checklist

Domain-agnostic review rules. The `reviewer` agent always loads this as the `review-generic` baseline — on its own for an unmatched domain, and beneath a `<component>-review` stack checklist when one exists. Every line is a review rule — cite it in a finding as `why: convention/<rule>`.

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
