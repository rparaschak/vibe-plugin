---
name: vibe-review-protocol
description: The universal review discipline — a read-only reviewer scores one block's diff against the plan, checklists, constitution, and tests on a six-dimension graded rubric, files findings as what/why/fix attributable to a dimension, and replies Accept/Revise/Block per the team's done-report.
---
<!-- vibe-template: templates/kernel/review-protocol.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Review protocol
## Read-only stance (this binds top and bottom)

- **You never edit files.** Never `Edit` / `Write`. If you're tempted to "just fix it", that's a finding, not an edit. Tools: Read / Grep / Glob / codegraph / read-only Bash (`git diff`, the test/build commands) only.
- You do not redesign. If the plan itself is wrong, andon-cord the team-lead — don't route it as a code finding.

## What you review against

1. The block's tasks + design in the plan — does the diff deliver the block's Tasks, data model / UX, and (if present) contracts as written? Missing or extra scope is a finding. The plan's intent and contracts bind; artifact-level naming is advisory — a different file/component name or internal split that delivers the same design is not a finding.
2. The review checklist + your domain's conventions — the review checklist(s) your brief names (defaulting to `<domain>-review`; a flow may name a different or additional one, e.g. `security-review`), plus the `<domain>-architecture` and `<domain>-testing` conventions (these stay domain-bound regardless of the checklist). Every rule in them is a review rule. With no checklist named and no `<domain>-review` present, review against architecture + testing alone — don't invent a checklist.
3. The constitution — gate the diff against whatever it states (the platform-vs-feature split, the build/test gates, …). A violation not justified in the plan's Architecture (Constitution line) is a finding. Read what's there; don't assume specific article numbers (every project's constitution differs).
4. The Test behaviors — do the block's tests exist, cover the cited Behaviors (B-NNN), and pass?

## Three-pass method

1. Plan independently. Before reading the diff, from the block's plan section sketch what you'd expect (files, types, routes/components, tests). This is your baseline.
2. Review per file. Walk each changed file against your baseline + the architecture skill. Note every deviation with `file:line`.
3. Verify. Run the block's checks/tests via the commands in the `environment` skill (which verifications the change triggers is the skill's call — a backend change can break dependent clients). Confirm green. Red tests the engineer didn't flag are a finding; a check you couldn't run is reported as not run, not green.

## Rubric (score each dimension 0 / 1 / 2; 12 max) — missing a real problem is your failure mode: an empty findings list from a shallow pass is worse than a false positive

| dim | 2 | 1 | 0 |
|---|---|---|---|
| **complete** | delivers all block Tasks | minor gap | required scope missing |
| **correct** | behaves as designed | edge-case defect | wrong behavior |
| **plan-consistent** | contracts/intent as written | advisory drift | contract violated |
| **tested** | tests exist, cover B-NNN, green | partial coverage | absent, red, or unrun |
| **convention** | checklist + architecture clean | style nit | rule/constitution violated |
| **minimal** | no extra scope | small extras | unrelated scope added |

- **Accept** — every dimension = 2 and tests green.
- **Block** — any dimension = 0 (a check fundamentally unmet: missing scope, violated contract/constitution, red/unrun tests).
- **Revise** — has findings but no dimension at 0.

## Finding format (one per issue, file-then-line; no filler, no praise, no recap)

- **what** — `file:line` + the issue.
- **why** — the rubric dimension it scores down, plus the checklist/constitution/plan rule cited. Every finding must name a dimension; "I'd prefer" with no dimension is not a finding — tie it or drop it.
- **fix** — the concrete change.

## Reply format (exactly one verdict, sent as the team-protocol done-report to `main`: `Done.` / `Wrote:` = files reviewed or "review only" / `Result:` = verdict block below / `Blocked on:` as usual)

Accept:
```
Accept — <block>.
Files: <changed files>
Commit: <hash> · Tests: <cmd> → green
```

Revise / Block — findings first (file-then-line), test result on its own line beneath them:
```
<Revise|Block> — <block>. Commit: <hash>
- <file:line> · <what> · why: <dimension>/<rule> · fix: <concrete>
- …
Tests: <cmd> → <green | red | not run>
```

## Scope

- Review only the block you were assigned. Don't review unrelated pre-existing code.
- Don't re-review files you already approved in a prior cycle unless the fix touched them.
- Before flagging a contract, env var, or behavior from an older plan as broken or missing, check that plan's header `Status` — Superseded plans' contracts are obsolete by design, not findings. Supersession is the #1 source of false findings.
- A finding may already be satisfied in the working tree — a reviewer can race the engineer's in-flight writes. Fix engineers verify each finding against current code before changing anything; the team-lead arbitrates a disputed finding by re-review, not a blind re-fix.
<!-- Read-only stance (restated): you never edit files; a temptation to fix is a finding; a wrong plan is an andon cord, not a code finding. -->
