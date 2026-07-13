# Disposition: agents/reviewer.md → template rewrite

Scout output (sonnet, 2026-07-13). Source = `agents/reviewer.md` (41 lines, v1). Standard = `standards/agent-standard.md`. Kernel = `templates/kernel/{review-protocol,team-protocol}.md`. Skill read for reference: `skills/vibe-review-discipline/SKILL.md` (58 lines — this is the v1 "method" skill the source `skills:` frontmatter points at; kernel `review-protocol.md` now supersedes it wholesale, not just renames it — see contradictions). The author of the rewritten `reviewer.md` works from THIS file, not the source.

**Migration mandates carried into this disposition (from `docs/migration-plan.md:141` + `docs/harness-improvement-plan.md` P6):**
(a) point the verdict format at kernel `review-protocol.md` — do not restate it;
(b) ADD a "run mechanized checks before prose review" step — lint/build/tests/grep-able rule checks run FIRST (via the `environment` skill), prose review only on what machines can't check;
(c) `skills/vibe-review-discipline` content is now kernel-owned — most source rows resolve to `now-in-kernel-review-protocol`; the agent file keeps only what is reviewer-**agent**-specific (dispatch handling, domain/checklist resolution mechanics, done-report routing).

## Disposition table

| # | Instruction (key terms verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: reviewer` | L2 | Agent unaddressable/undispatchable | keep-verbatim |
| 2 | `description:` full 103-word field (measured: `sed -n '3p' \| wc -w` → 103, incl. the `description:` token) — domain-generic framing + checklist-naming mechanism + "Does not edit files." | L3 | Orchestrator can't route/scope the agent from a bloated API surface | merge (content is right, budget is not — standard rule 2 caps description at ≤60 words; rewrite must trim while keeping the `Does not edit files` clause, the domain-generic framing, and the "brief may name a different/additional checklist" fact) |
| 3 | `model: opus` | L4 | Wrong capability tier for a graded-rubric review job | keep-verbatim |
| 4 | `effort:` — **absent from frontmatter** (no line between `model:` and `color:`) | — (gap between L4–L5) | Under-specified dispatch budget — agent-standard rule 1 names this exact failure ("today `effort` is missing on 2/9 agents"); `reviewer.md` is one of the two | merge (frontmatter contract requires it; source carries no value to preserve, author must set one — `opus`-tier judgment work argues for `effort: high`, matching the `engineer`/`architect` precedent already merged) |
| 5 | `color: red` | L5 | Frontmatter contract field missing | keep-verbatim |
| 6 | `skills: [vibe-team-communication-protocol, vibe-research-protocol, vibe-review-discipline]` | L6-9 | Agent can't resolve its own protocol skills post-kernel-rename | keep, but **rename**: `vibe-team-communication-protocol` → `vibe-team-protocol` (kernel `team-protocol.md` frontmatter `name: vibe-team-protocol`); `vibe-review-discipline` → `vibe-review-protocol` (kernel `review-protocol.md` frontmatter `name: vibe-review-protocol`); `vibe-research-protocol` name unchanged |
| 7 | `# reviewer` | L12 | Missing canonical top heading | keep-verbatim |
| 8 | "You review ONE domain's block diff of a plan — read-only." | L14 | Agent doesn't know its review is scoped to one domain's block and is read-only | keep |
| 9 | "You find issues and report them; the engineer fixes them." | L14 | Reviewer doesn't know findings route to the engineer, not itself | merge — keep only the recipient-role fact ("the engineer fixes them"); drop the "you find issues and report them" half, which is the same read-only-boundary restated a second time (kernel's Read-only stance + this file's own Boundaries cover it) |
| 10 | "Your **domain** — backend, frontend, mobile, … — is named in your dispatch brief; everything below is relative to it." | L14 | Domain-genericity broken — agent assumes one stack | keep-verbatim |
| 11 | "`vibe-review-discipline` is your **method**: the read-only stance, the three-pass review, the verify step, and the exact approve/findings reply formats. This file only says which project skills to resolve for your domain." | L16 | Agent re-derives the review method instead of citing the kernel | now-in-kernel-review-protocol — rename target to `vibe-review-protocol`. **Delta, not just a rename**: this sentence says "approve/findings" (binary), but kernel `review-protocol.md` now defines a graded 6-dimension rubric with **Accept/Revise/Block** verdicts and what/why/fix findings (L26-46). The rewrite must not carry the old binary vocabulary forward anywhere, including in any new Workflow prose. |
| 12 | "Resolve these before reviewing. `<domain>` is the domain from your brief (e.g. `backend` → `backend-architecture`, `backend-testing`). The review **checklist** is named independently of the domain (next row) — defaulting to `<domain>-review`." | L20 | Agent can't map its brief's domain word to concrete skill names | keep — dispatch/resolution mechanic, explicitly reviewer-**agent**-specific per mandate (c), not restated anywhere in kernel |
| 13 | Skills table row: "🔌 Review method \| `vibe-review-discipline` skill \| Read-only stance, three-pass method, verify step, reply formats" | L24 | Agent doesn't know where its method lives | keep, **renamed** to `vibe-review-protocol`; reword "Why" to name the graded rubric + Accept/Revise/Block (not the old binary reply) — this row IS the correct kernel-by-reference pattern mandate (a) asks for |
| 14 | Skills table row: "📁 Review checklist \| checklist skill(s) your brief names — defaults to `<domain>-review` \| ... may name a **different or additional** checklist (e.g. `security-review`) to run a specialized lens ... `<domain>-architecture`/`<domain>-testing` baseline stays domain-bound regardless ... if none named and `<domain>-review` absent, review against architecture+testing+constitution alone; don't invent a checklist" | L25 | Agent invents a checklist, or ignores a brief-specified specialized lens | merge — keep the resolution mechanic (brief names it; defaults to `<domain>-review`; may add e.g. `security-review`) since it's the agent-specific "how do I find my checklist" fact; the evaluative rationale ("don't invent a checklist", domain-bound-regardless framing) is now near-verbatim in kernel point 2 (`review-protocol.md` L16) — now-in-kernel-review-protocol for that half |
| 15 | Skills table row: "📁 Domain architecture \| `<domain>-architecture` skill \| The structural conventions the diff must follow — every rule there is a review rule" | L26 | Agent doesn't resolve the domain's own architecture skill | merge — keep the resolution row (`<domain>` → `<domain>-architecture`); drop "every rule there is a review rule" (now-in-kernel-review-protocol point 2, same sentence in substance) |
| 16 | Skills table row: "📁 Domain testing \| `<domain>-testing` skill \| The test conventions the block's tests must follow" | L27 | Agent doesn't resolve the domain's own testing skill | merge, same split as #15 |
| 17 | Skills table row: "📁 Constitution \| `.workspace/constitution.md` \| The project's non-negotiable rules — a violation not justified in the plan's **Constitution** line is a finding. Read what's there; don't assume specific article numbers (every project's constitution differs)" | L28 | Agent cites a wrong/assumed article number; misses a real violation | merge — keep-verbatim the path + "don't assume specific article numbers (every project's constitution differs)" caveat (fixed vibe convention path, confirmed identical across `architect.md`/`reviewer.md`/`engineer.md` per the engineer disposition's #13 finding — not a per-project placeholder); the "violation not justified... is a finding" clause is now near-verbatim in kernel point 3 (`review-protocol.md` L17) — now-in-kernel-review-protocol for that clause |
| 18 | Skills table row: "📁 Plan \| the plan file (path in your brief) \| The block's **Tasks**, design, contracts, and **Test behaviors** — your review baseline" | L29 | Agent doesn't know where the plan/baseline document lives | keep — path-resolution fact; kernel's "what you review against" (points 1+4) never states *where* the plan file is, only what to check against it once found |
| 19 | Skills table row: "📁 Research \| the plan dir's `research.md` (path in your brief) \| Current-state snapshot — verify a load-bearing fact via `codegraph` before flagging on it" | L30 | Agent trusts a stale snapshot | now-in-kernel-research-protocol — identical to research-protocol ladder rung 1 (same disposition as engineer's row #15) |
| 20 | Skills table row: "⚠️ Code index \| `codegraph` MCP \| **Targeted** lookups to trace the diff (callers/callees/impact)" | L31 | Agent does a broad sweep instead of a targeted lookup | keep — real tool reference the agent needs listed directly (same pattern as engineer's row #16) |
| 21 | Skills table row: "🔌 Research protocol \| `vibe-research-protocol` skill \| How to find code facts without sweeping: `research.md` → `codegraph` → `Explore` → `codebase-researcher`" | L32 | Agent re-derives the ladder itself | keep — correct kernel-by-reference pattern (name + one-line why, no restatement), same as engineer's row #17 |
| 22 | Skills table row: "📁 Environment \| `environment` skill \| How to run the block's checks/tests to confirm green, and which verifications the change triggers — **project-supplied, resolve it by name; never hardcode or guess commands**" | L33 | Agent hardcodes/guesses a verification command | keep-verbatim — the bolded anti-hardcode clause is load-bearing. **This is also the anchor point for mandate (b)**: the new mechanized-checks-first Workflow step runs through this same skill row — see "New content required" below. |
| 23 | Boundaries bullet 1: "**Read-only.** You never `Edit`/`Write`. A fix you're tempted to make is a finding, not an edit." | L37 | Reviewer edits instead of filing a finding | now-in-kernel-review-protocol — near-verbatim of kernel's Read-only stance opening bullet (`review-protocol.md` L10). Delete the restatement; rely on the skills-table pointer row (#13) per standard rule 6. |
| 24 | Boundaries bullet 2: "You review the design **as built**, not the design itself. If the plan's *design* is wrong (not just the code), that's an andon to the team-lead — the `architect` (your domain) is on-call via `SendMessage` to confirm a suspected design flaw before you escalate." | L38 | Reviewer routes a design flaw as a code finding, or escalates without first confirming with the architect | merge — split in two: "you review as-built, not the design; a wrong design is an andon, not a code finding" duplicates kernel's Read-only stance bullet 2 (`review-protocol.md` L12) — now-in-kernel-review-protocol, delete; "the `architect` (your domain) is on-call via `SendMessage` to confirm a suspected design flaw before you escalate" is **unique to this file** — not stated anywhere in kernel — **keep** that half verbatim |
| 25 | Boundaries bullet 3: "Review only your assigned block; don't re-review files you already approved unless the fix touched them." | L39 | Reviewer scope-creeps into unrelated or already-approved files | now-in-kernel-review-protocol — near-verbatim of kernel Scope section bullets 1–2 (`review-protocol.md` L65-67). Delete. |
| 26 | Boundaries bullet 4: "Run the block's verification (commands from the `environment` skill) before approving — green is **observed, not assumed**; a check you couldn't run is reported as not run, never as a pass." | L40 | Reviewer approves on assumed/unverified green, or reports an unrun check as a pass | now-in-kernel-review-protocol — near-verbatim of kernel Three-pass method step 3 "Verify" (`review-protocol.md` L24). Delete the restatement, but **replace its function** with the new mandate-(b) Workflow step below — don't just delete and leave nothing; the file still needs to say verification comes first among mechanized checks. |

## Row count and disposition counts

- Total rows: **26**
- `keep-verbatim`: 6 (#1, 3, 5, 7, 10, 22)
- `keep`: 6 (#8, 12, 13, 18, 20, 21)
- `merge`: 9 (#2, 4, 6, 9, 14, 15, 16, 17, 24)
- `delete`: 0
- `now-in-kernel-review-protocol`: 4 (#11, 23, 25, 26)
- `now-in-kernel-research-protocol`: 1 (#19)

## New content required (not in source — mandate (b), P6)

Nothing in v1 `reviewer.md` runs mechanized checks before prose review; the file has no `## Workflow` section at all (source omits it, which was standard-legal for a small agent — agent-standard rule 4 allows omission). Mandate (b) now requires one. Author must add a `## Workflow` with, at minimum:

1. Resolve domain skills (`<domain>-architecture`, `<domain>-testing`, checklist named in brief — default `<domain>-review`) per row #12/#14.
2. **Run mechanized checks first**: lint/build/tests and any grep-able rule checks via the `environment` skill (row #22) — before prose review. Prose review covers only what the mechanized pass can't check.
3. Apply `vibe-review-protocol`'s three-pass method + rubric for everything else (kernel-by-reference — do not restate the rubric here).
4. Reply per `vibe-review-protocol`'s Accept/Revise/Block verdict format to `main`.

## Verbatim contracts to preserve (exact quotes, in the agent file)

- "Your domain — backend, frontend, mobile, … — is named in your dispatch brief; everything below is relative to it."
- "the `architect` (your domain) is on-call via `SendMessage` to confirm a suspected design flaw before you escalate."
- "project-supplied, resolve it by name; never hardcode or guess commands" (environment skill row).
- "don't assume specific article numbers (every project's constitution differs)" (constitution row).
- "`<domain>` is the domain from your brief (e.g. `backend` → `backend-architecture`, `backend-testing`)."
- checklist-resolution mechanic: "defaulting to `<domain>-review`, but a flow may supply a different or additional checklist (e.g. `security-review`) to run a specialized lens over the same diff."
- "Does not edit files." (description's `Does not…` clause — required by standard rule 2).

## Project-specific content requiring `{{PLACEHOLDER}}`

**None found.** Same pattern as `engineer.md`: verification commands are resolved at runtime via the `environment` skill ("never hardcode or guess commands"), and the domain is resolved at *dispatch time* from the brief, not baked in at template-generation time. `.workspace/constitution.md` is a fixed vibe-wide convention path, not per-project. No `{{PLACEHOLDER}}` is needed in the rewrite.

## Duplicates (intra-document, v1 source)

1. Read-only/report-not-fix stated twice: L14 ("You find issues and report them; the engineer fixes them.") ↔ Boundaries #1 (L37, "Read-only... a fix you're tempted to make is a finding, not an edit."). Both also now duplicate the kernel. Keep only the recipient-role fact from L14 (#9); Boundaries #1 goes to kernel entirely.
2. "Review method"/verify-before-approving stated twice: skills-table row #13 (points at the method skill) ↔ Boundaries #4 (L40, restates the verify step inline). Keep the table row as the pointer; Boundaries #4's content is kernel-owned (#26).

## Duplicates against kernel (now-in-kernel)

- L16's method-skill description (#11), Boundaries #1 (#23), Boundaries #2's first half (#24), Boundaries #3 (#25), and Boundaries #4 (#26) all restate content that `templates/kernel/review-protocol.md` now owns wholesale (read-only stance, three-pass method, verify step, scope rules). This is the bulk of the file's post-migration shrinkage mandate (c) predicted.
- Skills-table rows #14/#15/#16/#17's evaluative rationale ("every rule is a review rule", "violation not justified... is a finding") duplicates kernel's "what you review against" points 2–3 (`review-protocol.md` L16-17) — kept only as trimmed resolution rows, rationale dropped.

## Contradiction found

**Reply-format vocabulary: binary vs. graded.** `agents/reviewer.md` L16 and `skills/vibe-review-discipline/SKILL.md` L29-51 both describe a **two-outcome** reply: "Approve" or "Findings" (see the skill's exact section header `## Reply format` → "Send exactly ONE of the two"). `templates/kernel/review-protocol.md` L26-62 now defines a **six-dimension 0/1/2 rubric** collapsing to **three** verdicts — **Accept / Revise / Block** — with a mandatory what/why/fix finding format and a `Result:` block nested in the team-protocol done-report. This is a substantive behavior change, not cosmetic: a literal "keep the reply format" port would ship an agent that can't produce a "Revise" verdict (v1 has no such state — a finding-bearing diff with no dimension at 0 was presumably filed as "Findings" with no accept/reject signal at all). The kernel wins. The rewrite must not reference "approve" or "findings" as reply-format nouns anywhere — only Accept/Revise/Block, sourced by reference to `vibe-review-protocol`, never restated.

No other contradictions found — the remaining v1 content (checklist/domain-skill resolution mechanics, environment/codegraph/plan/research path rows) operates at the "how do I find my inputs" layer, which kernel `review-protocol.md` doesn't cover (kernel starts one layer up, at "what do I do with inputs once resolved") — those layers are complementary, not conflicting.

## Suggested ≤70-line skeleton (per agent-standard anatomy)

```
---
name: reviewer
description: <≤60 words. Keep: ONE domain's block diff, read-only, domain-generic
  (brief names domain + checklist), "Does not edit files." clause>
model: opus
effort: high
color: red
skills:
  - vibe-team-protocol
  - vibe-research-protocol
  - vibe-review-protocol
---
<!-- vibe-template: templates/agents/reviewer.md v1 | generated <date> | edits below this marker are yours -->

# reviewer

<1-2 sentences: reviews ONE domain's block diff, read-only; findings go to the
engineer; domain named in dispatch brief, everything below is relative to it.
No Does-not restatement here — description + Boundaries only.>

`vibe-review-protocol` is your method (read-only stance, three-pass, rubric,
Accept/Revise/Block). This file only resolves which project skills to load.

## Skills & documents you refer to

| Reference | Resolves to | Why |
|---|---|---|
| Review protocol | `vibe-review-protocol` skill | Read-only stance, three-pass, rubric, Accept/Revise/Block |
| Review checklist | brief-named, defaults to `<domain>-review` | May add a specialized lens (e.g. `security-review`) |
| Domain architecture | `<domain>-architecture` skill | Structural conventions to resolve |
| Domain testing | `<domain>-testing` skill | Test conventions to resolve |
| Constitution | `.workspace/constitution.md` | Non-negotiable rules; don't assume article numbers |
| Plan | plan file (path in brief) | Block's Tasks/design/contracts/Test behaviors |
| Research protocol | `vibe-research-protocol` skill | Ladder for code facts; don't sweep |
| Code index | `codegraph` MCP | Targeted lookups to trace the diff |
| Environment | `environment` skill | Checks/tests to confirm green; never hardcode |

## Workflow

1. Resolve your domain's skills + checklist (default `<domain>-review`) from the brief.
2. Run mechanized checks first — lint/build/tests + grep-able rule checks via
   `environment` — before prose review; prose covers only what machines can't check.
3. Apply `vibe-review-protocol`'s three-pass method + rubric for the rest.
4. Reply per `vibe-review-protocol`'s Accept/Revise/Block verdict to `main`.

## Boundaries

- Read-only — never `Edit`/`Write`; a fix you're tempted to make is a finding
  (per `vibe-review-protocol`).
- Review only your assigned block; don't re-review already-approved files
  unless the fix touched them.
- The domain's `architect` is on-call via `SendMessage` to confirm a suspected
  design flaw before you escalate it as an andon, not a code finding.
- A check you couldn't run is reported as not run, never as a pass.
```

Fits comfortably under 70 lines including frontmatter and the template-version header.
