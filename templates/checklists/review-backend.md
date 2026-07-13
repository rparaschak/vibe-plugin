<!-- vibe-template: templates/checklists/review-backend.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Backend review checklist — SKELETON

<!-- BUILDER: this is a skeleton. Emit one filled copy per detected backend component (service, API, worker). Fill every {{SLOT}} from your stack audit, delete this comment and the "— SKELETON" suffix, then keep the file ≤60 lines. Rules stay `- [ ]` lines: short, imperative, one failure mode each. Tag any grep-able/lint-able rule `[mech]`. -->

The `reviewer` agent loads this as the `backend-review` checklist. Every line is a review rule — cite it as `why: convention/<rule>`. It stacks on `review-generic.md`; put only backend-specific rules here, not the generic ones.

**`[mech]` = mechanizable** (grep/lint). The reviewer runs `[mech]` rules and the lint commands below in its mechanized-checks-first step, before any prose review.

## Mechanized gate
{{LINT_COMMANDS}}
<!-- BUILDER: the exact lint/format/typecheck/build commands a reviewer runs first — one `- [ ]` per command, command in backticks, `[mech]`. Pull from the stack's config (Makefile, package scripts). Example:
- [ ] `golangci-lint run ./...` → clean. [mech]
- [ ] `go build ./...` → passes. [mech] -->

## Stack rules
{{STACK_RULES}}
<!-- BUILDER: the framework/ORM/query failure modes your audit found for THIS stack — one `- [ ]` each, `[mech]` where grep-able. Example:
- [ ] No N+1 query — batch/`.Preload()`, never one query per row. [mech]
- [ ] No raw string-built SQL — parameterize every query. [mech]
- [ ] Handlers return a typed error, not a bare 500. -->

## Architecture gotchas
When in doubt, prefer {{STACK_RULES}}.
{{ARCH_GOTCHAS}}
<!-- BUILDER: the layering/boundary traps specific to this codebase's backend — one `- [ ]` each. Example:
- [ ] No business logic in the transport/handler layer.
- [ ] Transactions do not span external network calls. -->
