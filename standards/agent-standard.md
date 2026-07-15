---
name: agent-standard
description: Quality bar for agent definition files (`HARNESS_ROOT/agents/*.md`, where `HARNESS_ROOT` is `.claude` or `.grok`) — the plugin's own agent templates, the files the builder stamps into projects, and audits of a project's existing agents. Every rule is mechanically checkable.
---

<!-- vibe-template: standards/agent-standard v1 | generated 2026-07-13 | edits below this marker are yours -->

# Agent Standard

Judged against by: author agents (write to it), reviewer agents (score against it), the builder's audit step (scores existing agent descriptions to catch bloat). Prefer checks a reviewer runs mechanically (word counts, line counts, section presence, grep) over taste. The description is an API the dispatching team-lead reads, not documentation. Every hard rule traces to a nameable failure it prevents; if a rule can become a grep/count check, make it one — prose is the fallback.

## Hard rules (all checkable; violations are defects)

1. **Frontmatter contract.** Required fields, all present: `name`, `description`, `model`, `effort`, `color`, `skills`. Templates declare default `model` + `effort`; the builder may override both at generation time, but a generated file MUST omit neither. (Prevents: under-specified dispatch — a missing `effort` runs the agent at an unintended budget.)
2. **Description budget & shape.** ≤60 words. One or two sentences carrying two things: what the agent does, and a `Does not …` clause naming its hardest boundary. It is the API the team-lead dispatches on. (Prevents: description bloat — an over-length description is documentation smuggled into an API.)
3. **File size budget.** ≤70 lines total. Detail beyond budget moves to referenced skills/docs, never inline. (Prevents: body creep — the ceiling keeps agent files lean and blocks growth beyond it.)
4. **Canonical body anatomy, in order.** `# <name>` → `## Skills & documents you refer to` (table: Reference | Resolves to | Why) → `## Workflow` → `## Boundaries` (bulleted never-list). Small agents may omit Workflow; never Boundaries. (Prevents: structural drift — unheaded prose with no Boundaries section.)
5. **Constraint placement.** Boundary rules live in exactly two places: the description's `Does not …` clause (top) and `## Boundaries` (bottom). Never mid-file, never restated per-section. (Prevents: buried and duplicated constraints — one rule in three phrasings drifts.)
6. **Kernel by reference.** Protocols (research, team/communication, review, task ledger) are listed in the skills table and referenced by name only. One line like "Reply per the team protocol done-format" is the maximum; restating the done-format's fields, or a skill's stance paragraph, is a defect. Bespoke agent-specific reply formats defined inline are allowed when they are not kernel content and stay bounded (e.g. ≤10 lines) — kernel formats remain reference-only. (Prevents: kernel drift — today every agent restates the done-format ~twice and a critic agent restated its skill's stance near-verbatim.)
7. **Placeholder convention (templates).** Template files mark generation-time slots with `{{PLACEHOLDER_NAME}}` (e.g. `{{STACK_FACTS}}`, `{{VERIFY_COMMANDS}}`, `{{DOMAIN_CHECKLIST}}`). Placeholders appear only in Workflow/Boundaries content, never in the frontmatter contract fields' structure. A stamped (generated) file contains zero unresolved `{{…}}`. (Prevents: shipped stubs — a live agent carrying `{{VERIFY_COMMANDS}}` runs nothing.)
8. **One agent = one job.** A description that needs "and" to name two unrelated jobs is two agents. Role overlap is resolved once at generation time, not at runtime. (Prevents: fuzzy dispatch — a team-lead can't reliably route to a two-headed agent.)
9. **Template-version header.** Every generated file's first non-frontmatter line is:
   `<!-- vibe-template: <template-path> v<N> | generated <date> | edits below this marker are yours -->`
   Enables re-stamp/upgrade diffs: unmodified stamped sections diff against newer template versions; user-modified sections are surfaced, never overwritten. (Prevents: silent overwrite of user edits on re-stamp; undiffable drift.)

## Review checklist (the audit step runs these, per agent file)

- [ ] Frontmatter fields all present: `name`, `description`, `model`, `effort`, `color`, `skills`.
- [ ] `model` + `effort` explicit (never omitted, even after override).
- [ ] Description ≤60 words and contains a `Does not` clause.
- [ ] File ≤70 lines total.
- [ ] Body sections in canonical order (rule 4); `## Boundaries` present.
- [ ] Constraints only in description + Boundaries — none mid-file.
- [ ] No kernel content restated (grep for the team protocol's done-format field names — take the terms from the referenced protocol skill; skill stance paragraphs).
- [ ] Zero unresolved `{{…}}` placeholders (generated files).
- [ ] Description names one job — no "and" joining two unrelated jobs.
- [ ] Template header present as first non-frontmatter line (generated files).

<!-- Footer constraint: frontmatter contract complete, description ≤60 words with "Does not", ≤70 lines, canonical order, Boundaries present, kernel by reference, no unresolved placeholders. -->
