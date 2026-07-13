# Disposition: skills/vibe-review-discipline/SKILL.md → templates/kernel/review-protocol.md

Scout output (sonnet, 2026-07-13). The author of review-protocol.md works from THIS file, not the source.

## Disposition table

| Instruction (verbatim key terms) | file:line | Failure prevented | Disposition |
|---|---|---|---|
| Reviewer reviews one block's diff (Platform/BE/FE) against the plan and the constitution | 8 | Reviewing out-of-scope work | keep |
| "You never edit files." Finds issues, reports; engineer fixes | 8 | Reviewer silently patching, bypassing ownership/audit | keep |
| Read/Grep/Glob/codegraph/read-only Bash (git diff, test/build cmd) ONLY | 12 | Mutating commands under guise of checking | keep |
| Never Edit/Write. "If you're tempted to 'just fix it', that's a finding, not an edit." | 13 | Reviewer editing instead of filing | keep |
| No redesign; plan wrong → andon-cord team-lead, not a code finding | 14 | Plan defects buried as code findings | keep |
| Check 1: diff delivers block's Tasks + design (data model/UX/contracts); missing/extra scope = finding. Plan intent/contracts bind; artifact-level naming advisory | 18 | Cosmetic-naming false findings; scope drift unflagged | keep |
| Check 2: named review checklist(s) (default `<domain>-review`, may add e.g. security-review) + `<domain>-architecture`/`<domain>-testing` conventions; none present → arch+testing only, don't invent a checklist | 19 | Invented rules; skipped domain conventions | keep |
| Check 3: gate vs constitution; violation not justified in plan's Architecture (Constitution line) = finding; read what's there, don't assume article numbers | 20 | Constitution violations slipping; hallucinated articles | keep |
| Check 4: tests exist, cover cited Behaviors (B-NNN), pass | 21 | Untested behaviors passing | keep |
| Pass 1 "Plan independently": sketch expected files/types/routes/tests BEFORE reading diff | 25 | Anchoring bias | keep |
| Pass 2 "Review per file": walk each changed file vs baseline + architecture skill; every deviation gets file:line | 26 | Untraceable/incomplete coverage | keep |
| Pass 3 "Verify": run block's checks/tests via `environment` skill; backend change can break dependent clients; red tests engineer didn't flag = finding; couldn't-run = reported "not run", not green | 27 | Assuming green; couldn't-run treated as pass | keep |
| Reply: exactly ONE of two, per team protocol | 31 | Mixed/ambiguous replies | superseded-by-rubric (graded Accept/Revise/Block) |
| Approve format (all passes clean + tests green): "Approved — block." / Files: / Tests: cmd → green | 33-39 | Approving with unrun tests | superseded-by-rubric — but all-clean gate + Files:/Tests: fields carry into new Accept shape |
| Findings format: one block per issue, ordered file-then-line: file:line · issue · rule-cited | 41-47 | Findings without location/rule | superseded-by-rubric — file:line + ordering carry into what/why/fix |
| Bullets only, ≤2 lines per finding, no praise/recap | 49 | Narrative bloat | superseded-by-rubric — re-express as "no filler", not line count |
| Every finding cites a rule; "I'd prefer" is not a finding — tie to rule or drop | 50 | Opinion findings | superseded-by-rubric — becomes the "why" field; enforcement rule survives in spirit |
| Findings + test result coexist → test result on own line under findings | 51 | Buried test result | keep |
| Review only assigned block; not unrelated pre-existing code | 55 | Scope creep | keep |
| Don't re-review already-approved files unless fix touched them | 56 | Re-review thrashing | keep |
| Older-plan contracts: check plan header `Status` — Superseded plans' contracts obsolete by design, not findings. "Supersession is the #1 source of false findings." | 57 | #1 false-positive source | keep |
| Finding may already be satisfied (reviewer races in-flight writes): fix engineers verify vs current code first; team-lead arbitrates disputes by re-review, not blind re-fix | 58 | Blind re-fixes; unverified arbitration | keep |

## Verbatim contracts to preserve

**Read-only stance:** "You never edit files." / "Never `Edit` / `Write`. If you're tempted to 'just fix it', that's a finding, not an edit." / "You do not redesign. If the plan itself is wrong, andon-cord the team-lead — don't route it as a code finding."

**What you review against (4 items):**
1. The block's tasks + design in the plan — does the diff deliver the block's Tasks, data model / UX, and (if present) contracts as written? Missing or extra scope is a finding. The plan's intent and contracts bind; artifact-level naming is advisory — a different file/component name or internal split that delivers the same design is not a finding.
2. The review checklist + your domain's conventions — the review checklist(s) your brief names (defaulting to `<domain>-review`; a flow may name a different or additional one, e.g. `security-review`), plus the `<domain>-architecture` and `<domain>-testing` conventions (these stay domain-bound regardless of the checklist). Every rule in them is a review rule. With no checklist named and no `<domain>-review` present, review against architecture + testing alone — don't invent a checklist.
3. The constitution — gate the diff against whatever it states (the platform-vs-feature split, the build/test gates, …). A violation not justified in the plan's Architecture (Constitution line) is a finding. Read what's there; don't assume specific article numbers (every project's constitution differs).
4. The Test behaviors — do the block's tests exist, cover the cited Behaviors (B-NNN), and pass?

**Three-pass method:**
1. Plan independently. Before reading the diff, from the block's plan section sketch what you'd expect (files, types, routes/components, tests). This is your baseline.
2. Review per file. Walk each changed file against your baseline + the architecture skill. Note every deviation with `file:line`.
3. Verify. Run the block's checks/tests via the commands in the `environment` skill (which verifications the change triggers is the skill's call — a backend change can break dependent clients). Confirm green. Red tests the engineer didn't flag are a finding; a check you couldn't run is reported as not run, not green.

**Scope rules (4 bullets):**
- Review only the block you were assigned. Don't review unrelated pre-existing code.
- Don't re-review files you already approved in a prior cycle unless the fix touched them.
- Before flagging a contract, env var, or behavior from an older plan as broken or missing, check that plan's header `Status` — Superseded plans' contracts are obsolete by design, not findings. Supersession is the #1 source of false findings.
- A finding may already be satisfied in the working tree — a reviewer can race the engineer's in-flight writes. Fix engineers verify each finding against current code before changing anything; the team-lead arbitrates a disputed finding by re-review, not a blind re-fix.

## Contradictions with the graded-rubric model (author must resolve)

1. Binary "exactly ONE of two" + "Approve only when every pass clean and tests green" vs 3-way Accept/Revise/Block: define how all-passes-clean maps to the Accept threshold — not a drop-in.
2. "≤2 lines per finding" cannot survive what/why/fix (inherently ≥3 parts) — re-express as "no filler", not a line count.
3. No severity/dimension concept exists today; the rubric requires findings attributable to a dimension — new structure, no prior analog.

## Suggested skeleton (≤70 lines)

Read-only stance → What you review against (verbatim 4 items) → Three-pass method (verbatim) → Rubric (new: 6 dims 0–2 → Accept/Revise/Block) → Finding format what/why/fix (new; carries file:line ordering, rule-citation, no-praise/no-recap) → Reply format (Accept/Revise/Block shapes; preserve Files:/Tests: fields + test-result-own-line) → Scope (verbatim 4 bullets)
