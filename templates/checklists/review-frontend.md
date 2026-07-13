<!-- vibe-template: templates/checklists/review-frontend.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Frontend review checklist — SKELETON

<!-- BUILDER: this is a skeleton. Emit one filled copy per detected frontend component (web app, design-system package, native client). Fill every {{SLOT}} from your stack audit, delete this comment and the "— SKELETON" suffix, then keep the file ≤60 lines. Rules stay `- [ ]` lines: short, imperative, one failure mode each. Tag any grep-able/lint-able rule `[mech]`. -->

The `reviewer` agent loads this as the `frontend-review` checklist. Every line is a review rule — cite it as `why: convention/<rule>`. It stacks on `review-generic.md`; put only frontend-specific rules here, not the generic ones.

**`[mech]` = mechanizable** (grep/lint). The reviewer runs `[mech]` rules and the lint commands below in its mechanized-checks-first step, before any prose review.

## Mechanized gate
{{LINT_COMMANDS}}
<!-- BUILDER: the exact lint/format/typecheck/build commands a reviewer runs first — one `- [ ]` per command, command in backticks, `[mech]`. Pull from the stack's package scripts. Example:
- [ ] `eslint .` → clean. [mech]
- [ ] `tsc --noEmit` → passes. [mech] -->

## Stack rules
{{STACK_RULES}}
<!-- BUILDER: the framework/state/styling failure modes your audit found for THIS stack — one `- [ ]` each, `[mech]` where grep-able. Example:
- [ ] No state mutation — return new objects/arrays.
- [ ] Effects declare every dependency; no suppressed deps-lint. [mech]
- [ ] No inline literal that belongs in the design-token/theme system. -->

## Architecture gotchas
When in doubt, prefer {{STACK_RULES}}.
{{ARCH_GOTCHAS}}
<!-- BUILDER: the component/data-flow traps specific to this codebase's frontend — one `- [ ]` each. Example:
- [ ] No data fetching inside a presentational component.
- [ ] Interactive elements are keyboard-reachable and labeled. -->
