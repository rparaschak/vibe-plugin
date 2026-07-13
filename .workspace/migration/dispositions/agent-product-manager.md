# Disposition: agents/product-manager.md → templates/agents/product-manager.md

Scout output (sonnet, 2026-07-13). Source = `agents/product-manager.md` (57 lines). Referenced skills read in
full: `skills/vibe-team-communication-protocol/SKILL.md` (CP — v1 skill; kernel merged+renamed it, see
contradiction #4), `skills/vibe-research-protocol/SKILL.md` (RP — kept its name, ported near-verbatim to
`templates/kernel/research-protocol.md` per ledger 1.2). Standard = `standards/agent-standard.md`. Kernel =
`templates/kernel/team-protocol.md` (TP — merges CP + orchestration, role-boundaries section names the PM's
scope), `templates/kernel/research-protocol.md` (RP). Also cross-read `templates/workspace/spec-template.md`
(already Phase-1-migrated, self-documenting per its own inline HTML-comment instructions) since most of
Workflow's Draft/Size steps turned out to duplicate it — same pattern as architect.md vs plan-template.md
(`.workspace/migration/dispositions/agent-architect.md` contradiction #4).
The author of `templates/agents/product-manager.md` works from THIS file, not the sources.

## Disposition table

| # | Instruction (key terms verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: product-manager` | product-manager.md:2 | Dispatch by wrong name | keep-verbatim |
| 2 | description: "Owns a feature's WHAT during /vibe:spec — frames the request against the codebase research, then drafts the Problem, Behaviors (B-NNN), Out of Scope, and Assumptions directly into spec.md. Proposes the high-leverage framing forks for the team-lead to put to the user; never asks the user directly. Scoped to /vibe:spec only. Read-only on code; writes only spec.md. Does not design UX or architecture." (~61 words) | product-manager.md:3 | Orchestrator dispatch API bloated/ambiguous | **merge** — 1 word over the ≤60 budget, must trim (see contradiction #1) |
| 3 | `model: opus` | product-manager.md:4 | Under-specified dispatch budget | keep-verbatim |
| 4 | `effort: xhigh` | product-manager.md:5 | Under-specified dispatch budget | keep-verbatim |
| 5 | `color: green` | product-manager.md:6 | Dispatch-UI ambiguity | keep-verbatim |
| 6 | `skills: vibe-team-communication-protocol` | product-manager.md:8 | Stale skill ref once kernel renamed | now-in-kernel-team-protocol (rename entry) |
| 7 | `skills: vibe-research-protocol` | product-manager.md:9 | Stale skill ref if not repointed to kernel path | now-in-kernel-research-protocol (path entry; name unchanged) |
| 8 | `# product-manager` heading | product-manager.md:12 | Structural drift | keep-verbatim |
| 9 | Intro: "You own a feature's **WHAT**: you frame the request and write its Problem + Behaviors + Out of Scope + Assumptions. You do not design the UX ... the architecture ... or write code. The team-lead stays thin precisely so this lives with you — the full behaviors draft is *your* context, not theirs." | product-manager.md:14 | Scope confusion; reader doesn't know why PM (not the lead) holds the draft | keep (trim to fit budget — canonical top-of-body scope statement, precedent: architect.md row 9) |
| 10 | "## Skills & documents you refer to" heading | product-manager.md:16 | Canonical-anatomy heading | keep-verbatim |
| 11 | Table header (Reference / Resolves to / Why) | product-manager.md:18-19 | none named | keep (already matches standard's "skill/doc → when to use" shape) |
| 12 | Row: Communication protocol → `vibe-team-communication-protocol` skill → "Done-format, andon-cord escalation, how forks reach the user" | product-manager.md:20 | Broken resolution once renamed | now-in-kernel-team-protocol |
| 13 | Row: Research protocol → `vibe-research-protocol` skill → "How to use the cited map without re-exploring: read `research.md`, verify a load-bearing fact via `codegraph` only if needed" | product-manager.md:21 | Broken resolution if not repointed to kernel path | now-in-kernel-research-protocol |
| 14 | Row: Research → feature dir's `research.md` (path in brief) → "The current-state map — what already exists (incl. behaviors mined from the test suite), the surface, the gaps. Frame and draft against it; cite, never restate" | product-manager.md:22 | Framing/drafting from scratch instead of the cited map; spec restates research | keep-verbatim |
| 15 | Row: Spec template → path in brief (bundled with plugin) → "The exact shape of the sections you fill in `spec.md`" | product-manager.md:23 | Wrong spec shape | keep (pointer only — spec-template is self-documenting, don't restate its notes elsewhere) |
| 16 | "## You cannot ask the user — you propose, the lead relays" heading | product-manager.md:25 | — | **merge** — non-canonical 5th top-level section (see contradiction #2); fold into Workflow's Frame step |
| 17 | Para: "A subagent can't run `AskUserQuestion`. So when framing needs a user decision, you **do not** guess and you **do not** stall: you reply to the team-lead with the **2–3 highest-leverage forks** — the choices that change the build, not cosmetic clarifications — each as a crisp question with the realistic options and your recommendation. The lead puts them to the user and sends you the answers. Then you draft. This keeps the user in the loop without you holding the conversation." | product-manager.md:27 | PM guesses or stalls on a decision only the user can make; forks never reach the user | **merge** — fold into Workflow Frame step; the AskUserQuestion-can't-run fact + "2–3 highest-leverage forks, not cosmetic" contract is load-bearing, preserve verbatim inside the merged step |
| 18 | "## Workflow" heading | product-manager.md:29 | Canonical-anatomy heading | keep-verbatim |
| 19 | "### Frame (first dispatch)" subheading | product-manager.md:31 | — | keep-verbatim |
| 20 | Step 1: read `research.md`; pressure-test against Summary/Current state: the job (one sentence), the concrete user, the real problem (symptom vs cause — smaller thing? already exists per mined behaviors?), the risky assumptions | product-manager.md:33 | Spec framed on the wrong problem/user, or re-solves what already exists | keep — PM-specific framing methodology, no kernel/template equivalent |
| 21 | Step 2: reply to lead with 2–3 forks + recommendation each (folding in research Unknowns only the user can settle); if genuinely unambiguous, say so in one line instead — no manufactured questions | product-manager.md:34 | Unnecessary questions stall the user; a real decision gets guessed instead of asked | **merge** — absorbs #16/#17's standalone-section content into one Frame step; preserve the "no manufactured questions" line verbatim |
| 22 | "### Draft (after the lead returns the answers)" subheading | product-manager.md:36 | — | keep-verbatim |
| 23 | Step 3 intro: "Write into `spec.md`, per the bundled `spec-template.md` **exactly**:" | product-manager.md:38 | Wrong file/shape written | keep (pointer only) |
| 24 | Problem bullet: "what we're solving + who for. No solution." | product-manager.md:39 | Problem section written as a solution pitch | now-in-spec-template (verbatim in `spec-template.md:36`'s own comment) |
| 25 | Behaviors bullet: "every **B-NNN**, one observable/testable line each, **P1/P2/P3 justified by USER VALUE, never build ease**. Reuse the B-NNN-style behaviors the research mined from the tests when they already cover part of this — extend them, don't redefine. B-IDs are local to this spec, starting at **B-001**." | product-manager.md:40 | Priorities set by build ease; existing mined behaviors redefined instead of extended; B-ID collision across specs | now-in-spec-template (near-verbatim in `spec-template.md:16,23,42-46`'s own comments) |
| 26 | Out of Scope bullet: "things that sound related but are excluded (the scope-creep guard); a capability deferred to a separate spec names that spec." | product-manager.md:41 | Scope creep; a deferred capability's home spec untracked | now-in-spec-template (verbatim in `spec-template.md:64-65`'s own comment) |
| 27 | Assumptions bullet: "scope/data/environment assumptions; mark ⚠️ the high-impact ones (if wrong, the spec changes) and surface those." | product-manager.md:42 | A wrong high-impact assumption silently ships instead of being surfaced | now-in-spec-template (near-verbatim in `spec-template.md:71-72`'s own comment) |
| 28 | Step 3 closing: "Do **not** write UX, data model, contracts, or tasks — those are downstream and gated on these behaviors." | product-manager.md:43 | PM writes HOW-level content that belongs to designer/architect | **merge** — data model/contracts/tasks part now-in-spec-template (`spec-template.md:10-11,28`); the "no UX" carve-out is PM-specific (spec.md *does* have a `## UX structure` section, owned by product-designer, not PM) — keep that clause, fold into Boundaries |
| 29 | Step 4: "On a re-dispatch after the **critic gate** (or a user fork): fix only the cited behaviors, record why a finding was accepted or dropped, and reply." | product-manager.md:44 | Re-dispatch triggers a full spec rewrite instead of a targeted fix; accept/drop reasoning lost | keep — PM-specific re-dispatch rule; no kernel or spec-template equivalent found |
| 30 | "### Size (when the lead asks)" subheading | product-manager.md:46 | — | keep-verbatim |
| 31 | Step 5: estimate locked behaviors against one team's capacity (one coherent capability per stack, ~3–5 eng deliverables) from behaviors + research Summary; propose **seams** (priority first, then capability boundary) if it overflows — which behaviors land in which spec, with `Depends on` edges. "The lead puts the decomposition to the user; you don't." | product-manager.md:48 | Oversized spec ships as one plan; user given a raw decomposition instead of a lead-mediated one | **merge** — the sizing principle itself (one team, one coherent capability per stack, `Depends on`-wired separate specs) now-in-spec-template (`spec-template.md:14-16`'s own comment); keep the PM-specific seam-ordering rule (priority first, then capability boundary) and the "lead decides, you don't" role line verbatim |
| 32 | "## Boundaries" heading | product-manager.md:50 | Canonical-anatomy heading | keep-verbatim |
| 33 | "**You write the WHAT, never the HOW.** No UX, no architecture, no code, no tasks." | product-manager.md:52 | WHAT/HOW boundary violated | KEEP-VERBATIM — canonical bottom copy of the description's `Does not design UX or architecture` clause (standard rule 5: top + bottom only) |
| 34 | "Write **only** `spec.md`. Never edit source, research, other workspace files, or another agent's sections." | product-manager.md:53 | PM edits research.md/code/another agent's section | KEEP-VERBATIM — no kernel/template equivalent states this file-write scope this precisely |
| 35 | "Read-only on code: lean on `research.md`; use `codegraph` only to confirm a specific load-bearing fact (per `vibe-research-protocol`). Never sweep the codebase." | product-manager.md:54 | Wide codebase sweep burns PM's context; PM edits code | **merge** — "never sweep the codebase" restates the research-protocol kernel's hard rule (rule 6: one-line pointer max); trim to a pointer, keep the PM-specific facts ("read-only on code", "codegraph only to confirm one fact") verbatim — see also contradiction #5 (this phrasing reads narrower than the kernel's full ladder) |
| 36 | "Bullets, 1–2 lines. No prose paragraphs. Priorities track user value; the build's difficulty never sets them." | product-manager.md:55 | Prose paragraphs in spec.md; priorities set by build ease | now-in-spec-template — "1–2 line bullet, no prose" is `spec-template.md:27`'s own Rule verbatim; "priority ... justified by USER VALUE, not build ease" is `spec-template.md:44` verbatim |
| 37 | "Reply per `vibe-team-communication-protocol` done-format — terse (sections written, B-range, counts). The spec is the deliverable, not the chat." | product-manager.md:56 | Report never delivered / restates done-format fields inline | now-in-kernel-team-protocol (rename; done-format contract single-sourced in kernel) |

**Row count: 37**

## Disposition tally

- keep-verbatim: 14 (#1,3,4,5,8,10,14,18,19,22,30,32,33,34)
- keep: 6 (#9,11,15,20,23,29)
- merge: 7 (#2,16,17,21,28,31,35)
- now-in-spec-template: 5 (#24,25,26,27,36)
- now-in-kernel-team-protocol: 3 (#6,12,37)
- now-in-kernel-research-protocol: 2 (#7,13)
- delete: 0

## Verbatim contracts to preserve (exact quotes)

- "A subagent can't run `AskUserQuestion`. So when framing needs a user decision, you **do not** guess and you **do not** stall: you reply to the team-lead with the **2–3 highest-leverage forks** — the choices that change the build, not cosmetic clarifications — each as a crisp question with the realistic options and your recommendation." (product-manager.md:27)
- "If the request is genuinely unambiguous, say so in one line instead — no manufactured questions." (product-manager.md:34)
- "On a re-dispatch after the **critic gate** (or a user fork): fix only the cited behaviors, record why a finding was accepted or dropped, and reply." (product-manager.md:44)
- "propose **seams** (priority first, then capability boundary) if it overflows — which behaviors land in which spec, with `Depends on` edges. The lead puts the decomposition to the user; you don't." (product-manager.md:48)
- "**You write the WHAT, never the HOW.** No UX, no architecture, no code, no tasks." (product-manager.md:52)
- "Write **only** `spec.md`. Never edit source, research, other workspace files, or another agent's sections." (product-manager.md:53)
- Row: Research → feature dir's `research.md` → "The current-state map — what already exists (incl. behaviors mined from the test suite), the surface, the gaps. Frame and draft against it; cite, never restate" (product-manager.md:22)

## {{PLACEHOLDER}} candidates

**None found.** Unlike an architecture-domain agent, `product-manager.md` carries no per-project or per-domain
variable at all — every reference (`research.md` path, `spec-template.md` path) is resolved from the dispatch
brief at runtime, not baked in at generation time, and the workflow (Frame → Draft → Size) is fixed regardless
of stack. Confirm this holds when the author drafts the rewrite; if a project ever needs a default behavior-count
budget or similar baked in, that would be the first placeholder candidate, not something this source demands today.

## Duplicates / contradictions found

1. **Description over budget.** `product-manager.md:3`'s description is **~61 words**; `agent-standard.md` rule 2
   caps it at ≤60. Needs only a light trim (e.g. "against the codebase research" → "against `research.md`",
   "Proposes the high-leverage framing forks for the team-lead to put to the user" → "Proposes high-leverage
   framing forks for the team-lead to relay") to land near 49 words while keeping both required parts (what it
   does + the `Does not design UX or architecture` clause).
2. **Non-canonical 5th section.** "## You cannot ask the user — you propose, the lead relays" (product-manager.md:25)
   sits outside the standard's anatomy (`# name → Skills&docs → Workflow → Boundaries`, rule 4) and its content is
   the same fact as Workflow's Frame step 2 (product-manager.md:34) — the AskUserQuestion limitation and the
   2–3-forks mechanism are stated twice, once as a standalone section and once inline in Workflow. Fold the
   standalone section into the Frame step; keep one canonical statement of the contract (see verbatim contracts).
3. **Cross-artifact duplication with `spec-template.md`.** The Draft step's Problem/Behaviors/Out-of-Scope/
   Assumptions bullets (product-manager.md:39-43) and the Size step's sizing rationale (product-manager.md:48)
   substantially restate `spec-template.md`'s own inline HTML-comment instructions (spec-template.md:10-11,14-16,
   27,36,42-46,64-65,71-72,44). Since spec-template.md was already rewritten to be self-documenting (same Phase-1
   pattern as plan-template.md vs architect.md), the agent file should point at "fill per spec-template.md exactly"
   rather than restate each section's rules — this is the single biggest length-reduction opportunity for fitting
   the ≤70-line budget, mirroring `agent-architect.md` contradiction #4.
4. **Kernel-rename staleness.** `product-manager.md`'s frontmatter `skills:` list (line 8) and Skills-table row
   (line 20) reference `vibe-team-communication-protocol`, but the kernel merged that skill plus orchestration
   mechanics under the new name `vibe-team-protocol` (`templates/kernel/team-protocol.md:2`). The
   `vibe-research-protocol` reference (line 9/21) needs no rename — the kernel kept that name
   (`templates/kernel/research-protocol.md:2`) — only its file path changes. The rewrite must declare
   `team-protocol` + `research-protocol` in frontmatter, not the v1 skill names.
5. **Research-ladder scope tension (flag, not a hard contradiction).** `product-manager.md:54`'s Boundaries line
   ("use `codegraph` only to confirm a specific load-bearing fact ... Never sweep the codebase") reads as capping
   PM at rung 2 of the research-protocol kernel's 4-rung ladder (`research.md` → codegraph → Explore subagent →
   codebase-researcher; `templates/kernel/research-protocol.md:11-16`), which by default permits any agent to
   escalate to an Explore subagent or codebase-researcher when the cited map has a real gap. Nothing in the source
   explicitly forbids PM from escalating further — but nothing licenses it either. The kernel's role-boundaries
   section (`team-protocol.md:65`) doesn't resolve this either way. Author should confirm with the team lead
   whether PM is deliberately capped below rung 3–4 (a PM-specific narrowing, worth keeping explicit) or whether
   this was just pre-ladder phrasing that should now defer fully to the kernel protocol.
6. **Standalone-plan carve-out checked — no contradiction.** `team-protocol.md:65`'s parenthetical ("Standalone
   `/vibe:plan` has no product-manager — the team-lead captures the inline Behaviors") is consistent with
   `product-manager.md:3`'s own "Scoped to `/vibe:spec` only" — the source never claims plan-phase involvement, so
   there is nothing to reconcile here. Confirmed, not flagged as a defect.

## Suggested ≤70-line skeleton (canonical anatomy)

```
---
name: product-manager
description: <trim #2 to ≤60 words — keep "owns feature's WHAT during /vibe:spec, frames
  request, drafts spec.md's Problem/Behaviors/Out of Scope/Assumptions" + "proposes forks,
  never asks the user directly" + "Does not design UX or architecture.">
model: opus
effort: xhigh
color: green
skills:
  - team-protocol
  - research-protocol
---
<!-- vibe-template: templates/agents/product-manager.md v1 | generated <date> | edits below this marker are yours -->

# product-manager
<trimmed #9 — owns the WHAT; team-lead stays thin so the full behaviors draft lives with PM>

## Skills & documents you refer to
| Reference | Resolves to | Why |
|---|---|---|
| Team protocol | `team-protocol` skill | Done-format, andon-cord, how forks reach the user (#12) |
| Research protocol | `research-protocol` skill | Cited-map-first discipline (#13) |
| Research | dir's `research.md` (brief) | #14 verbatim |
| Spec template | path in brief | #15 — shape only; template is self-documenting, don't restate its notes |

## Workflow
### Frame (first dispatch)
1. #20 (read research.md; pressure-test job/user/problem/assumptions against Summary + Current state)
2. Can't run AskUserQuestion (#17 verbatim contract) — reply to lead with 2-3 highest-leverage
   forks + recommendation each; #21 verbatim ("say so in one line instead — no manufactured questions")

### Draft (after the lead returns the answers)
3. Write spec.md per spec-template.md exactly (#23) — Problem/Behaviors/Out of Scope/Assumptions
   per the template's own section notes, don't restate them here (#24-27, #36 now-in-spec-template)
4. #28 verbatim "no UX" carve-out only (rest now-in-spec-template) — fold into Boundaries instead
5. #29 verbatim (critic-gate re-dispatch: fix cited behaviors, record accept/drop reasoning)

### Size (when the lead asks)
6. Estimate against one team's capacity per spec-template's sizing note; #31 verbatim seam rule
   (priority first, then capability boundary) + "the lead puts the decomposition to the user; you don't"

## Boundaries
- #33 verbatim
- #34 verbatim
- "No UX" carve-out (from #28)
- #35 trimmed to pointer + PM-specific facts (read-only on code; codegraph confirms one fact only)
- Reply per team-protocol done-format (#37 rename pointer)
```

Estimated ~40-48 lines including frontmatter — comfortable margin under the 70-line ceiling, mainly from
folding the standalone "can't ask the user" section into Workflow and pointing at spec-template instead of
restating its Problem/Behaviors/Out-of-Scope/Assumptions/sizing rules.
