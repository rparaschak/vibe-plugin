# Disposition: agents/test-engineer.md → template rewrite

Scout output (sonnet, 2026-07-13). Source = `agents/test-engineer.md` (51 lines, v1). Standard = `standards/agent-standard.md`. Kernel = `templates/kernel/{team-protocol,research-protocol,review-protocol,task-ledger}.md`. Skills read for reference: `skills/vibe-team-communication-protocol/SKILL.md` (source and kernel content confirmed equivalent — kernel's `team-protocol.md` absorbed this skill's communication rules plus the former orchestration skill), `skills/vibe-research-protocol/SKILL.md` (confirmed byte-identical to `templates/kernel/research-protocol.md` modulo the template header and line-wrapping — `diff` shows only whitespace/blank-line reflow). The author of the rewritten `test-engineer.md` works from THIS file, not the source.

No forced non-negotiable frontmatter value found (unlike `engineer.md`'s pinned `model: opus`) — `git log` shows no dedicated commit changing this file's `model`/`effort`/`color` fields; treat all three as ordinary keep-verbatim.

## Disposition table

| # | Instruction (key terms verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: test-engineer` | L2 | Agent unaddressable/undispatchable | keep-verbatim |
| 2 | `description:` full 78-word field (measured: `sed -n '3p' \| wc -w` → 78) — domain-generic framing, resolves `<domain>-testing`/`<domain>-architecture`, "supplied by the consuming repo, not bundled with the vibe plugin", writes every test layer + fixtures, "Does not modify production code." | L3 | Orchestrator can't route/scope the agent; over-budget description is bloat | merge — trim to ≤60 words; keep domain-generic framing + the `Does not…` clause; the "supplied by the consuming repo, not bundled with the vibe plugin" clause is restated in Boundaries (L47) and can drop from description |
| 3 | `model: opus` | L4 | Wrong capability tier for test-authoring work | keep-verbatim |
| 4 | `effort: high` | L5 | Under-specified dispatch budget | keep-verbatim |
| 5 | `color: orange` | L6 | Frontmatter contract field missing | keep-verbatim |
| 6 | `skills: [vibe-team-communication-protocol, vibe-research-protocol]` | L7-9 | Agent can't resolve its own protocol skills | keep, **rename** `vibe-team-communication-protocol` → `vibe-team-protocol` (kernel's actual skill name per `templates/kernel/team-protocol.md` frontmatter `name: vibe-team-protocol`); `vibe-research-protocol` name unchanged |
| 7 | `# test-engineer` | L12 | Missing canonical top heading | keep-verbatim |
| 8 | "You write the tests for ONE domain's block of a plan, after the engineer has implemented it. You work in a fresh context — read what you need from the plan and the code." | L14 | Agent doesn't know its role/sequencing, or over-reads the whole codebase | keep |
| 9 | "Your **domain** — backend, frontend, mobile, … — is named in your dispatch brief; everything below is relative to it." | L14 | Domain-genericity broken — agent assumes one stack | keep |
| 10 | "You write tests and their fixtures only; you never modify production code." | L14 | — | **delete** — verbatim restatement of the description's `Does not…` clause AND Boundaries L46, mid-file. Standard rule 5: constraints live only in description (top) + `## Boundaries` (bottom). |
| 11 | "Resolve these before writing tests. `<domain>` is the domain from your brief (e.g. `backend` → `backend-testing`)." | L18 | Agent doesn't know how to derive a domain-scoped skill name | keep |
| 12 | Skills row: "🔌 Communication protocol \| `vibe-team-communication-protocol` skill \| Done-format, `Blocked on:` routing, andon-cord" | L22 | Agent doesn't know how to report/escalate | now-in-kernel-team-protocol (row stays, points at `vibe-team-protocol`, needn't restate "Done-format, Blocked on: routing, andon-cord" — the row + one workflow line suffices) |
| 13 | Skills row: "📁 Domain testing \| `<domain>-testing` skill \| The authority for test conventions — layers, file layout, frameworks, mocking boundary, fixtures/factories, harness, named types" | L23 | Agent invents test conventions instead of following the domain's own | keep (core domain-generic mechanism, unique to this agent) |
| 14 | Skills row: "📁 Domain architecture \| `<domain>-architecture` skill \| Structure of the code under test — so your tests target the real types / exported API" | L24 | Tests target invented shapes instead of the real API | keep |
| 15 | Skills row: "📁 Plan \| the plan file (path in your brief) \| The block's **Test behaviors** (each cites a B-NNN) — your test inventory" | L25 | Agent doesn't know what to test | keep |
| 16 | Skills row: "📁 Research \| the plan dir's `research.md` (path in your brief) \| Current-state snapshot — verify load-bearing facts via `codegraph`" | L26 | Agent trusts a stale snapshot | now-in-kernel-research-protocol (ladder rung 1, verbatim in `research-protocol.md` L12-13 — shorten to a bare row) |
| 17 | Skills row: "⚠️ Code index \| `codegraph` MCP \| **Targeted** lookups to locate the fixtures / helpers / components under test" | L27 | Agent does a broad sweep instead of a targeted lookup | keep |
| 18 | Skills row: "🔌 Research protocol \| `vibe-research-protocol` skill \| How to find code facts without sweeping: `research.md` → `codegraph` → `Explore` → `codebase-researcher`" | L28 | Agent re-derives the ladder itself | keep — the correct kernel-by-reference pattern (name + one-line why, no restatement) |
| 19 | Skills row: "📁 Environment \| `environment` skill \| How to run each test layer (unit / integration / component / E2E), how to bring infra and the app up, and which verifications a change triggers — **project-supplied, resolve it by name; never hardcode or guess commands**" | L29 | Agent hardcodes/guesses a test command that doesn't match the repo | keep-verbatim — the bolded anti-hardcode clause is load-bearing |
| 20 | "If the `<domain>-testing` skill is **absent** (conventions) or the `environment` skill is **absent** (how to run the layers / bring the app up), andon-cord the team-lead — don't invent test conventions or guess commands." | L31 | Agent silently invents conventions/commands when a prerequisite skill is missing | keep — concrete instantiation of the kernel's generic "missing precondition" andon trigger (`team-protocol.md` L58), names the two skills unique to this role |
| 21 | "**Preserve your context.** Read the implementation under test and the Test behaviors — not the whole codebase. Follow `vibe-research-protocol` to locate things (`codegraph` → `Explore` → `codebase-researcher`); don't go *discovering* the codebase with wide `Read`/`Grep`/`Glob` sweeps yourself." | L33 | Context bloat from exploration sweeps | now-in-kernel-research-protocol — near-verbatim restatement of the kernel's "discovery vs. doing" stance (`research-protocol.md` L20-24). Standard rule 6 violation; delete, row 18 pointer suffices |
| 22 | Workflow 1: "Read the plan's **Test behaviors** — each cites the Behavior (B-NNN) it covers. Cover the ones for your block. Load your `<domain>-testing` (and `<domain>-architecture`) skill." | L37 | Agent tests the wrong/incomplete behavior set | keep |
| 23 | Workflow 2: "Read the implemented code (slices / components / hooks / platform package) so your tests use the **real** types, props, and exported API — never invented shapes." | L38 | Tests written against invented/guessed shapes | keep-verbatim |
| 24 | Workflow 3: "Write **every test layer your `<domain>-testing` skill defines** for the block, plus their fixtures/factories: e.g. integration tests against real backing services, component tests, and — for user-facing behaviors — full-stack E2E specs. One behavior per test; follow the skill's file layout, harness, mocking boundary, and named-type conventions." | L39 | Missing test layers; wrong file layout; multiple behaviors crammed into one test | keep-verbatim |
| 25 | Workflow 4: "**Platform subsystems**: drive the subsystem's *real mechanism* against real infra (e.g. real concurrency, real row-claims, cap-under-load, lease-timeout re-claim). Use the engineer-provided fake/mock ONLY for the external edge (a model API, network, timers); **never test the installed package**, and never fake the thing under test. If the subsystem ships no fake you need, that's `Blocked on:` the engineer." | L40 | Testing the fake instead of the real mechanism; testing vendored code instead of the wrapper | keep-verbatim — the test-author's mirror of `engineer.md`'s "Test our wrapper, never the installed package" contract |
| 26 | Workflow 5: "**Run** each layer via the test commands in the `environment` skill (test *conventions* per `<domain>-testing`); for full-stack/E2E, bring infra and the app up per the `environment` skill first. Green is **observed, not assumed** — a layer you authored but did not execute is reported as **not run**." | L41 | Agent reports an unexecuted test layer as passing | keep-verbatim — load-bearing "observed, not assumed" / "not run" contract |
| 27 | Workflow 6: "Reply per `vibe-team-communication-protocol` done-format with green/red **per layer** (verbatim run results) and, if red, whether it's a test bug or an impl defect." | L42 | Silent finish; ambiguous routing of a red result | merge — the done-format pointer is now-in-kernel-team-protocol (rename skill), but "per layer, verbatim run results, test bug vs. impl defect" is unique to this role and survives |
| 28 | Boundaries 1: "You write tests and their fixtures only. Do **not** modify production code — if a test reveals an impl defect, report it as `Blocked on:` so the team-lead routes it to the engineer." | L46 | Test-engineer edits production code (role overlap with engineer) | keep-verbatim — canonical Boundaries location |
| 29 | Boundaries 2: "**The `<domain>-testing` skill is the authority** for conventions — supplied by the consuming repo, not bundled with the vibe plugin. Don't invent test structure." | L47 | — | merge — duplicates skills-table row 13 near-verbatim; keep one short boundary echo ("Don't invent test structure — `<domain>-testing` is the authority"), drop the restated rationale |
| 30 | Boundaries 3: "Cover every Test behavior for your block. Don't add scope beyond it; don't skip P1/P2 behaviors." | L48 | Under- or over-scoped coverage; priority behaviors silently skipped | keep-verbatim |
| 31 | Boundaries 4: "Auth/session setup for E2E is handled by the project's shared mechanism (per `<domain>-testing`) — never script a manual sign-in inside a spec." | L49 | Flaky/duplicated per-spec auth scripting instead of the shared mechanism | keep-verbatim — unique, no duplicate found elsewhere |
| 32 | Boundaries 5: "Use `codegraph` for locating code; the `architect` (your domain) is on-call via `SendMessage` for test-intent questions on the block's design." | L50 | Broad sweep instead of a targeted lookup; agent doesn't know who to ask about design intent | merge — the `codegraph` clause duplicates skills-table row 17 + kernel research-protocol rung 2 (drop here); "architect on-call via `SendMessage` for test-intent questions" is unique — keep that half |

## Row count and disposition counts

- Total rows: **32**
- `keep-verbatim`: 13 (#1,3,4,5,7,19,23,24,25,26,28,30,31)
- `keep`: 11 (#6,8,9,11,13,14,15,17,18,20,22)
- `merge`: 4 (#2,27,29,32)
- `delete`: 1 (#10)
- `now-in-kernel-team-protocol`: 1 (#12)
- `now-in-kernel-research-protocol`: 2 (#16,21)

## Verbatim contracts to preserve (exact quotes)

- "Use the engineer-provided fake/mock ONLY for the external edge (a model API, network, timers); **never test the installed package**, and never fake the thing under test."
- "If the subsystem ships no fake you need, that's `Blocked on:` the engineer."
- "Green is **observed, not assumed** — a layer you authored but did not execute is reported as **not run**."
- "You write tests and their fixtures only. Do not modify production code — if a test reveals an impl defect, report it as `Blocked on:` so the team-lead routes it to the engineer."
- "Cover every Test behavior for your block. Don't add scope beyond it; don't skip P1/P2 behaviors."
- "Auth/session setup for E2E is handled by the project's shared mechanism (per `<domain>-testing`) — never script a manual sign-in inside a spec."
- "project-supplied, resolve it by name; never hardcode or guess commands" (environment skill row).
- "so your tests use the **real** types, props, and exported API — never invented shapes." (Workflow step 2).
- Test-layer enumeration + "One behavior per test" (Workflow step 3).

## {{PLACEHOLDER}} candidates

**None found as literal project-specific strings.** Like `engineer.md`, this file deliberately avoids hardcoding test commands or framework names — they're resolved at runtime via the `environment` skill ("never hardcode or guess commands"), and test conventions/layers are resolved at runtime via `<domain>-testing`, not baked in at template-generation time. The domain (backend/frontend/mobile/…) is resolved at *dispatch time* from the brief, same as `engineer.md`.

One item worth flagging for the author's judgment, not a slot: Workflow 4's platform-subsystem examples ("real concurrency, real row-claims, cap-under-load, lease-timeout re-claim"; "a model API, network, timers") are fairly specific vocabulary suggesting one particular subsystem shape (a lease-based job/worker queue) — this phrasing appears nowhere else in the agent set (grep confirmed). It reads as one illustrative case, not a `{{PLACEHOLDER}}` (no project fact is embedded, nothing to substitute), but the author should decide whether to keep it as-is or generalize the example — same open question `engineer.md`'s disposition raised for its frontend-flavored Task-sizing example.

## Duplicates (intra-document)

1. Does-not clause triple-stated: description L3 ↔ L14 sentence 3 ↔ Boundaries L46. Keep description (top) + Boundaries (bottom) per standard rule 5; delete L14's copy.
2. `<domain>-testing` "is the authority" for conventions stated twice: skills-table row 13 ↔ Boundaries L47. Keep the table row + a one-line Boundaries echo; drop the restated rationale.
3. `codegraph` usage stated three times: skills-table row 17 ↔ kernel research-protocol rung 2 ↔ Boundaries L50. Keep the table row only; Boundaries keeps just its unique "architect on-call for test-intent" half.
4. `environment` skill referenced three times (skills-table row 19, andon trigger L31, Workflow step 5 L41) — not a rule-5 violation, each occurrence adds distinct actionable content (definition / andon condition / run instruction); no dedup needed, flagged only for awareness if the line budget gets tight.

## Duplicates against kernel (now-in-kernel)

- Communication-protocol row (#12) + Workflow step 6's done-format pointer (#27, partial) both target the team-protocol kernel's done-report format — fine as references once renamed to `vibe-team-protocol`.
- The "Preserve your context" paragraph (#21) + Boundaries #5's `codegraph` clause (#32, partial) restate `templates/kernel/research-protocol.md`'s ladder and "discovery vs. doing" stance, already referenced correctly via skills-table row #18. These collapse to nothing beyond that one row.

## Contradictions

1. **Stale skill name (same drift as `engineer.md` and `critic.md`).** `skills:` frontmatter (L7) and skills-table row #12 (L22) name `vibe-team-communication-protocol`; the kernel's actual consolidated skill is `vibe-team-protocol` (`templates/kernel/team-protocol.md` frontmatter). This is the **third** occurrence of this exact naming drift across the migration — must rename in the rewrite.
2. **No true content contradiction found** between `test-engineer.md` and the four kernel files. Workflow step 5's "Green is observed, not assumed... reported as not run" (L41) independently echoes `review-protocol.md`'s Pass 3 language ("a check you couldn't run is reported as not run, not green") — but these are two different roles' own instructions (test-engineer isn't a `vibe-review-protocol` consumer), so this is reinforcing convergence, not a shared-reference drift risk. No action needed.
3. Minor observation (not a contradiction, a non-gap): unlike `engineer.md` (whose Boundaries #6 presumed a review/fix-loop interaction with no `vibe-review-protocol` in its skills list), `test-engineer.md` has no such loose end — its role ends at reporting green/red per layer, it never participates in a reviewer's fix-verification cycle. No skill needs adding here.

## Suggested ≤70-line skeleton (per agent-standard anatomy)

```
---
name: test-engineer
description: <≤60 words; keep "Does not modify production code" and the
  domain-generic framing (dispatch brief names the domain; resolves that
  domain's own <domain>-testing skill); drop the "supplied by consuming repo,
  not bundled with vibe plugin" clause — it's restated in Boundaries>
model: opus
effort: high
color: orange
skills:
  - vibe-team-protocol
  - vibe-research-protocol
---
<!-- vibe-template: agents/test-engineer.md v1 | generated <date> | edits below this marker are yours -->

# test-engineer

<2-3 sentences: writes tests for ONE domain's block after the engineer has
implemented it; domain named in dispatch brief; fresh context, reads only
what's needed. No Does-not restatement here — description + Boundaries only.>

## Skills & documents you refer to

| Reference | Resolves to | Why |
|---|---|---|
| Team protocol | `vibe-team-protocol` skill | Done-format, andon-cord |
| Domain testing | `<domain>-testing` skill (per brief) | Authority for test conventions — layers, layout, mocking boundary, fixtures |
| Domain architecture | `<domain>-architecture` skill (per brief) | Real types / exported API under test |
| Plan | plan file (path in brief) | Block's Test behaviors (B-NNN) |
| Research protocol | `vibe-research-protocol` skill | Ladder for code facts; don't sweep |
| Code index | `codegraph` MCP | Targeted lookups for fixtures/helpers under test |
| Environment | `environment` skill | Test-run commands, infra/app up, which verifications trigger — never hardcode |

If `<domain>-testing` or `environment` is absent, andon-cord — don't invent
conventions or guess commands.

## Workflow

1. Read the plan's Test behaviors (each cites a B-NNN); cover your block's.
   Load `<domain>-testing` (+ `<domain>-architecture`).
2. Read the implemented code — tests use real types/props/API, never invented shapes.
3. Write every test layer `<domain>-testing` defines, plus fixtures/factories;
   one behavior per test; follow the skill's layout, harness, mocking boundary.
4. Platform subsystems: drive the real mechanism against real infra; use the
   engineer's fake/mock only for the external edge — never test the installed
   package, never fake the thing under test. No fake shipped → Blocked on: engineer.
5. Run each layer via `environment` skill commands; bring infra/app up first for
   E2E. Green is observed, not assumed — an unexecuted layer is reported not run.
6. Reply per `vibe-team-protocol` done-format: green/red per layer (verbatim run
   results), and if red, test bug vs impl defect.

## Boundaries

- Writes tests and fixtures only — never production code; an impl defect found
  by a test is `Blocked on:` the engineer, not a fix you make.
- `<domain>-testing` is the authority for conventions — don't invent test structure.
- Cover every Test behavior for your block; don't skip P1/P2, don't add scope.
- E2E auth/session setup uses the project's shared mechanism (per
  `<domain>-testing`) — never a manual sign-in inside a spec.
- The domain's architect is on-call via `SendMessage` for test-intent questions.
```

Fits comfortably under 70 lines including frontmatter and the template-version header.
