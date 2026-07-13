# Disposition: agents/engineer.md → template rewrite

Scout output (sonnet, 2026-07-13). Source = `agents/engineer.md` (54 lines, v1). Standard = `standards/agent-standard.md`. Kernel = `templates/kernel/{team-protocol,review-protocol,task-ledger}.md`. Skills read for reference: `skills/vibe-team-communication-protocol/SKILL.md`, `skills/vibe-research-protocol/SKILL.md` (the latter is byte-identical to `templates/kernel/research-protocol.md` — already kernelized under the same name). The author of the rewritten `engineer.md` works from THIS file, not the source.

**Hard constraint carried forward: `model: opus` is a deliberate recent change (commit 2d102dc) — the rewrite MUST keep `model: opus`, not revert to `sonnet`.**

## Disposition table

| # | Instruction (key terms verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: engineer` | L2 | Agent unaddressable/undispatchable | keep-verbatim |
| 2 | `description:` full 74-word field (measured: `sed -n '3p' \| wc -w` → 74) — domain-generic framing + `<domain>-architecture` resolution + "Does not write the block's tests or fixtures, and does not redesign the plan." | L3 | Orchestrator can't route/scope the agent | merge (content is right, budget is not — standard caps description at ≤60 words; rewrite must trim while keeping the `Does not…` clause) |
| 3 | `model: opus` | L4 | Wrong capability tier for a recent deliberate change (commit 2d102dc) | keep-verbatim (non-negotiable per task brief) |
| 4 | `effort: high` | L5 | Under-specified dispatch budget | keep-verbatim |
| 5 | `color: green` | L6 | Frontmatter contract field missing | keep-verbatim |
| 6 | `skills: [vibe-team-communication-protocol, vibe-research-protocol]` | L7-9 | Agent can't resolve its own protocol skills | keep, but **rename** `vibe-team-communication-protocol` → `vibe-team-protocol` (the kernel's actual skill name per `templates/kernel/team-protocol.md` frontmatter `name: vibe-team-protocol`); `vibe-research-protocol` name is unchanged |
| 7 | `# engineer` | L12 | Missing canonical top heading | keep-verbatim |
| 8 | "You implement ONE domain's block of a plan per assignment. The team-lead gives you the plan path and your Task IDs — read only the Behaviors and your block's design." | L14 | Agent over-reads the plan (other blocks) | keep |
| 9 | "Your **domain** — backend, frontend, mobile, … — is named in your dispatch brief; everything below is relative to it." | L14 | Domain-genericity broken — agent assumes one stack | keep |
| 10 | "You do not write the block's tests (the test engineer does, after you) and you do not redesign the plan." | L14 | — | **delete** — verbatim restatement of the description's `Does not…` clause AND Boundaries #1/#2, mid-file. Standard rule 5: constraints live only in description (top) + `## Boundaries` (bottom), never restated mid-file. |
| 11 | Skills table row: "🔌 Communication protocol \| `vibe-team-communication-protocol` skill \| Done-format, andon-cord escalation" | L22 | Agent doesn't know how to report/escalate | now-in-kernel-team-protocol (row stays, but points at `vibe-team-protocol` and needn't restate "Done-format, andon-cord escalation" — the skill row + one workflow line suffices) |
| 12 | Skills table row: "📁 Domain architecture \| `<domain>-architecture` skill \| The authority for every structural decision — don't invent structure" | L23 | Agent invents structure instead of following the domain's own convention | keep (core domain-generic mechanism) |
| 13 | Skills table row: "📁 Constitution \| `.workspace/constitution.md` \| The project's non-negotiable rules — incl. the platform-vs-feature split and the build/test gates. Read what's there; don't assume specific article numbers (every project's constitution differs)." | L24 | Agent cites a wrong/assumed article number; misses platform/feature split | keep-verbatim (fixed vibe convention path — confirmed identical across `architect.md`, `reviewer.md`, `engineer.md`; not a per-project placeholder) |
| 14 | Skills table row: "📁 Plan \| the plan file (path in your brief) \| Your block's **Behaviors** + design (Data model / UX / Architecture / Contracts)" | L25 | Agent doesn't know where design lives | keep |
| 15 | Skills table row: "📁 Research \| the plan dir's `research.md` (path in your brief) \| Current-state snapshot — verify load-bearing facts via `codegraph` before relying on them" | L26 | Agent trusts a stale snapshot | now-in-kernel-research-protocol (this is ladder rung 1, verbatim in `templates/kernel/research-protocol.md` L12-13 — shorten to a bare row, drop the restated caveat) |
| 16 | Skills table row: "⚠️ Code index \| `codegraph` MCP \| **Targeted** code lookups (callers/callees/trace/impact/node)" | L27 | Agent does a broad sweep instead of a targeted lookup | keep (real tool reference the agent needs listed, even though the ladder also names it) |
| 17 | Skills table row: "🔌 Research protocol \| `vibe-research-protocol` skill \| How to find code facts without sweeping: `research.md` → `codegraph` → `Explore` → `codebase-researcher`" | L28 | Agent re-derives the ladder itself | keep — this row is the *correct* kernel-by-reference pattern (name + one-line why, no restatement) |
| 18 | Skills table row: "📁 Environment \| `environment` skill \| The repo's **lint + build** command and any codegen/client-regen step — **project-supplied, resolve it by name; never hardcode or guess commands**. (You run lint + build only — the `test-engineer` runs the test suite.)" | L29 | Agent hardcodes/guesses a build command that doesn't match the repo | keep-verbatim (the bolded anti-hardcode clause is the load-bearing part); the trailing parenthetical duplicates Workflow step 6 / Boundaries scope — keep once, drop from here |
| 19 | "If the `<domain>-architecture` skill is **absent** (structure) or the `environment` skill is **absent** (build/verify commands), andon-cord the team-lead — don't invent structure or guess the build command." | L31 | Agent silently invents structure/commands when a prerequisite skill is missing | keep — a concrete instantiation of the kernel's generic "missing precondition" andon trigger (`team-protocol.md` L58), worth keeping explicit since it names the two skills unique to this role |
| 20 | "**Preserve your context for building.** Your context is for the code you're writing — don't fill it with discovery reads. Start from your block's design + `research.md`, then follow `vibe-research-protocol` for anything more (`codegraph` → `Explore` → `codebase-researcher`); don't go *discovering* the codebase with broad `Read`/`Grep`/`Glob` sweeps yourself. (Reading the files you're about to edit is your job, not discovery.)" | L33 | Context bloat from exploration sweeps | now-in-kernel-research-protocol — near-verbatim restatement of the kernel's "discovery vs. doing" stance paragraph (`research-protocol.md` L20-24: "no wide Grep/Glob/Read passes... Read the specific files you're about to edit... discovery vs. doing"). Standard rule 6 violation (skill stance paragraph restated). Delete; the skills-table row (#17) is sufficient. |
| 21 | Workflow 1: "Read the plan's **Behaviors** and your block's design — the sections your domain owns... Skip other blocks. Load your `<domain>-architecture` skill." | L37 | Agent reads/builds against the wrong block | keep |
| 22 | Workflow 2: "**Consuming another domain's contracts?** Run your domain's codegen / client-regen step **first**... The exact command is in the `environment` skill... don't hardcode or guess it." | L38 | Agent builds against stale contracts; hardcodes a regen command | merge — keep the ordering rule ("regen first"), drop "don't hardcode or guess it" as an intra-doc duplicate of #18's anti-hardcode clause |
| 23 | Workflow 3: "Build your impl Tasks as coherent units — decompose internally, never ask the team-lead to split a Task. A page/modal/component together with its hooks and sub-components is ONE Task." | L39 | Task splintering / team-lead asked to micromanage decomposition | keep-verbatim — hard rule + concrete example. Note: the example's vocabulary (page/modal/component/hooks) is frontend-flavored inside a nominally domain-generic agent; not a `{{PLACEHOLDER}}` case (illustrative, not project-specific), but the author should consider whether to generalize the example or keep it as one illustrative case |
| 24 | Workflow 4: "**Platform block**: build the subsystem feature-agnostic... per the constitution's platform/feature rule, and include any fake/mock it needs to be drivable in tests, as part of the Task. Test our wrapper, never the installed package." | L40 | Feature-coupled platform code; untestable subsystem; testing vendored code instead of the wrapper | keep-verbatim — both clauses; "Test our wrapper, never the installed package." is a crisp, quotable contract |
| 25 | Workflow 5: "Follow `<domain>-architecture` for every structural decision. You build production code only — the test-engineer writes the block's tests and fixtures after you." | L41 | — | **delete** — clause 1 duplicates skills-table row #12 / Boundaries #3; clause 2 duplicates description `Does not…` + L14 + Boundaries #1 (now a 4-way restatement across the file — the worst offender in this file). Standard rule 5 violation. |
| 26 | Workflow 6: "Run the **linter and build** from the `environment` skill before reporting — those two only. You do **not** run the full test suite (the `test-engineer` writes and runs that after you); reporting a clean lint + build is your bar." | L42 | Agent runs/reports the test suite (not its job) or skips lint/build | keep-verbatim — concrete, checkable scope boundary; "those two only" / "your bar" are load-bearing |
| 27 | Workflow 7: "Reply per `vibe-team-communication-protocol` done-format with the build result." | L43 | Silent finish / unreported build result | now-in-kernel-team-protocol — the done-format itself is fully specified in `team-protocol.md` L20-26; per standard rule 6 this line is already at the sanctioned maximum ("Reply per the team protocol done-format" + one clause naming the evidence: "with the build result") |
| 28 | Boundaries 1: "You do **not** write the block's tests or their fixtures/factories — the domain's `test-engineer` does, after you. (For a **Platform** block you still ship the subsystem's fake/mock — that's production test-support that makes the subsystem drivable, not a test.)" | L47 | Engineer writes tests (role overlap with test-engineer); fake/mock miscategorized as a test and dropped | keep-verbatim — canonical Boundaries location; the parenthetical resolves a real ambiguity |
| 29 | Boundaries 2: "You do **not** redesign the plan. If a block's design contradicts the code or is unbuildable, andon-cord the team-lead." | L48 | Engineer silently reinterprets a broken design instead of escalating | keep-verbatim |
| 30 | Boundaries 3: "**The `<domain>-architecture` skill is the authority** for structure — supplied by the consuming repo, not bundled with the vibe plugin. Don't invent structure." | L49 | — | merge — duplicates skills-table row #12 near-verbatim (same "authority for structure" / "not bundled with the vibe plugin" phrasing). Keep one short boundary bullet ("Don't invent structure — `<domain>-architecture` is the authority"), drop the restated rationale already in the table. |
| 31 | Boundaries 4: "If the brief names a `research.md`, read it before exploring — it's a snapshot; verify load-bearing facts via `codegraph`." | L50 | Trusting a stale snapshot | now-in-kernel-research-protocol — identical to ladder rung 1 (`research-protocol.md` L12-13) and to row #15. Delete. |
| 32 | Boundaries 5: "Use `codegraph` for code lookups; the `architect` (your domain) is on-call via `SendMessage`." | L51 | Broad sweep instead of targeted lookup; agent doesn't know who to ask for design intent | merge — split in two: the `codegraph` clause duplicates skills-table row #16 + kernel ladder rung 2 (drop here); the "architect on-call via SendMessage" clause is **unique to this file** — not stated anywhere else, not in kernel — **keep** that half |
| 33 | Boundaries 6: "In the fix loop, you receive reviewer findings verbatim; fix exactly those, then report." | L52 | Scope creep during a fix round; re-litigating findings instead of fixing them | keep-verbatim, **but see contradiction below** — reconcile with `review-protocol.md` L69 before finalizing wording |
| 34 | Boundaries 7: "When a Task says **replace / promote / rename X**, delete the superseded file or type in the **same** Task and re-run lint + build before reporting — don't leave the old artifact behind." | L53 | Orphaned/superseded files left in the tree | keep-verbatim — specific, checkable, prevents a real class of bug |

## Row count and disposition counts

- Total rows: **34**
- `keep-verbatim`: 14 (#1,3,4,5,7,13,18,23,24,26,28,29,33,34)
- `keep`: 9 (#6,8,9,12,14,16,17,19,21)
- `merge`: 4 (#2,22,30,32)
- `delete`: 2 (#10,25)
- `now-in-kernel-team-protocol`: 2 (#11,27)
- `now-in-kernel-research-protocol`: 3 (#15,20,31)

## Verbatim contracts to preserve (exact quotes)

- `model: opus` — do not revert to sonnet (commit 2d102dc).
- "Test our wrapper, never the installed package."
- "reporting a clean lint + build is your bar."
- "When a Task says replace / promote / rename X, delete the superseded file or type in the same Task and re-run lint + build before reporting — don't leave the old artifact behind."
- "You do not write the block's tests or their fixtures/factories — the domain's test-engineer does, after you. (For a Platform block you still ship the subsystem's fake/mock — that's production test-support that makes the subsystem drivable, not a test.)"
- "If the `<domain>-architecture` skill is absent (structure) or the `environment` skill is absent (build/verify commands), andon-cord the team-lead — don't invent structure or guess the build command."
- "project-supplied, resolve it by name; never hardcode or guess commands" (environment skill row).
- "don't assume specific article numbers (every project's constitution differs)" (constitution row).
- "In the fix loop, you receive reviewer findings verbatim; fix exactly those, then report." — reconcile against the contradiction below before treating as final wording.

## Project-specific content requiring `{{PLACEHOLDER}}`

**None found.** This file is unusual among v1 agents in that it deliberately avoids hardcoding anything project-specific — build/lint commands are explicitly resolved at runtime via the `environment` skill ("never hardcode or guess commands"), and the domain (backend/frontend/mobile/…) is resolved at *dispatch time* from the brief, not baked in at template-generation time. `.workspace/constitution.md` is a fixed vibe-wide convention path (same across `architect.md`, `reviewer.md`, `engineer.md`), not per-project. Domain examples ("backend, frontend, mobile") are illustrative, not slots. No `{{PLACEHOLDER}}` is needed in the rewrite for this file.

## Duplicates (intra-document)

1. Does-not clause quadruple-stated: description L3 ↔ L14 sentence 3 ↔ Workflow step 5 clause 2 ↔ Boundaries #1/#2. Keep only description (top) + Boundaries (bottom) per standard rule 5; delete L14's copy and Workflow step 5's copy.
2. `<domain>-architecture` "is the authority for structure" stated three times: skills-table row #12 ↔ Workflow step 5 clause 1 ↔ Boundaries #3. Keep the table row + a one-line Boundaries echo ("Don't invent structure"); drop the rest.
3. "Don't hardcode or guess" the build/regen command stated twice: skills-table row #18 ↔ Workflow step 2. Keep once (row #18).
4. `codegraph` usage stated three times: skills-table row #16 ↔ kernel research-protocol rung 2 ↔ Boundaries #5. Keep the table row only; Boundaries #5 keeps just its unique "architect on-call" half.

## Duplicates against kernel (now-in-kernel)

- Communication-protocol row (#11) + Workflow step 7 (#27) both point at the team-protocol kernel's done-report format — already fine as references, just needs the renamed skill (`vibe-team-protocol`).
- The "preserve your context" paragraph (#20) + Boundaries #4 (#31) + half of Boundaries #5 (#32) all restate `templates/kernel/research-protocol.md`'s ladder and "discovery vs. doing" stance, which is already referenced correctly via skills-table row #17. These three should collapse to nothing beyond that one row.

## Contradiction found

**Fix-loop scope vs. verification order.** `agents/engineer.md` Boundaries #6 (L52) says the engineer "receive[s] reviewer findings verbatim; fix exactly those, then report" — read plainly, this is "fix the list as given." `templates/kernel/review-protocol.md` L69 (Scope section) now states: "Fix engineers verify each finding against current code before changing anything; the team-lead arbitrates a disputed finding by re-review, not a blind re-fix." That is a **verify-first** step the engineer's current wording omits — a literal "fix exactly those" could read as licensing a blind re-fix, which the kernel explicitly rules out. The rewrite must reconcile: keep the "verbatim, no scope creep beyond the list" guarantee, but prepend the kernel's verify-against-current-code step so the two don't read as opposed. Recommend wording: "Verify each reviewer finding against current code, then fix exactly those findings — no more, no less — and report," with no restatement of the rubric/format (kernel-by-reference).

Secondary note (not a contradiction, a gap): the engineer's `skills:` frontmatter never lists `vibe-review-protocol`, yet Boundaries #6 presumes a review/fix-loop interaction governed by that protocol. The rewrite should decide whether to add it to the skills table (with a one-line "why") so the fix-loop reference in Boundaries has a resolvable antecedent.

## Suggested ≤70-line skeleton (per agent-standard anatomy)

```
---
name: engineer
description: <≤60 words, keep the "Does not write tests/fixtures, does not redesign
  the plan" clause, keep domain-generic framing>
model: opus
effort: high
color: green
skills:
  - vibe-team-protocol
  - vibe-research-protocol
---
<!-- vibe-template: agents/engineer.md v1 | generated <date> | edits below this marker are yours -->

# engineer

<2-3 sentences: implements ONE domain's block per assignment; domain named in
dispatch brief; reads only Behaviors + block's design. No Does-not restatement
here — it's in the description and Boundaries only.>

## Skills & documents you refer to

| Reference | Resolves to | Why |
|---|---|---|
| Team protocol | `vibe-team-protocol` skill | Done-format, andon-cord |
| Domain architecture | `<domain>-architecture` skill (per brief) | Authority for structure |
| Constitution | `.workspace/constitution.md` | Non-negotiable rules; don't assume article numbers |
| Plan | plan file (path in brief) | Your block's Behaviors + design |
| Research protocol | `vibe-research-protocol` skill | Ladder for code facts; don't sweep |
| Environment | `environment` skill | Lint+build command, codegen step; never hardcode |

If `<domain>-architecture` or `environment` is absent, andon-cord — don't invent
structure or guess commands.

## Workflow

1. Read Behaviors + your block's design (skip other blocks); load `<domain>-architecture`.
2. Consuming another domain's contracts? Regen/codegen step first (command via `environment`).
3. Build impl Tasks as coherent units — decompose internally, never ask to split a Task.
4. Platform block: feature-agnostic + ship its fake/mock. Test our wrapper, never the
   installed package.
5. Run lint + build only (`environment` skill) before reporting — that's your bar.
6. Reply per `vibe-team-protocol` done-format with the build result.

## Boundaries

- Does not write the block's tests/fixtures (test-engineer does, after you); a
  Platform block's fake/mock is production test-support, not a test.
- Does not redesign the plan — andon-cord if the design contradicts the code or
  is unbuildable.
- `<domain>-architecture` is the authority for structure — don't invent structure.
- Fix loop: verify each reviewer finding against current code, then fix exactly
  those findings, then report.
- Task says replace/promote/rename X → delete the superseded artifact in the
  same Task, re-run lint + build before reporting.
- The domain's architect is on-call via `SendMessage` for design-intent questions.
```

Fits comfortably under 70 lines including frontmatter and the template-version header.
