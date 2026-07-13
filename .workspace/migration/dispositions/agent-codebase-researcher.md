# Disposition: agents/codebase-researcher.md → templates/agents/codebase-researcher.md

Scout output (sonnet, 2026-07-13). Source = `agents/codebase-researcher.md` (32 lines). Referenced skills read in
full: `skills/vibe-team-communication-protocol/SKILL.md` (CP, 77 lines), `skills/vibe-research-protocol/SKILL.md`
(RP, 28 lines — **identical** to `templates/kernel/research-protocol.md`, already ported verbatim per ledger 1.2).
Standard = `standards/agent-standard.md`. Kernel = `templates/kernel/research-protocol.md` (RP-kernel — this agent
is named as **rung 4** of the ladder AND gets its own dedicated "If you are the codebase-researcher" section, kernel
lines 26-28), `templates/kernel/team-protocol.md` (TP-kernel, merges CP + `vibe-team-orchestration`). Also read
`templates/workspace/research-template.md` (already Phase-1-migrated, self-documenting — one of this agent's two
named output targets) since several Workflow bullets turned out to duplicate its own inline `<!-- -->` notes.
Cross-checked the finished `templates/agents/architect.md` (52 lines) as the shipped precedent for anatomy/skills-
table shape, since `templates/agents/codebase-researcher.md` doesn't exist yet (ledger 2.7, not_started).
The author of `templates/agents/codebase-researcher.md` works from THIS file, not the sources.

## Disposition table

| # | Instruction (key terms verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: codebase-researcher` | codebase-researcher.md:2 | Dispatch by wrong name | keep-verbatim |
| 2 | description (83 words): "Maps the current state ... facts only ... writes it to the output target its dispatch brief names ... Proposes nothing, designs nothing, edits no source. The target file is the deliverable; the reply is a terse done-message." | codebase-researcher.md:3 | Orchestrator dispatch API bloated | **merge** — 83 words vs ≤60 budget (rule 2), worst overage seen yet (architect was 71); also lacks a literal `Does not …` clause (uses "Proposes nothing, designs nothing, edits no source" instead) — reword while trimming |
| 3 | `model: sonnet` | codebase-researcher.md:4 | Under-specified dispatch budget | keep-verbatim |
| 4 | `effort: high` | codebase-researcher.md:5 | Under-specified dispatch budget | keep-verbatim |
| 5 | `color: yellow` | codebase-researcher.md:6 | Dispatch-UI ambiguity | keep-verbatim |
| 6 | `skills: vibe-team-communication-protocol` | codebase-researcher.md:8 | Stale skill ref once kernel renamed | now-in-kernel-team-protocol (rename entry → `vibe-team-protocol`) |
| 7 | `skills: vibe-research-protocol` | codebase-researcher.md:9 | Stale skill ref | keep-verbatim — name is unchanged; the kernel file IS this skill (near-identical, ledger 1.2) |
| 8 | `# codebase-researcher` heading | codebase-researcher.md:12 | Structural drift | keep-verbatim |
| 9 | "You research the **current state** of the codebase around one feature request — facts only — so no one downstream pays the exploration cost again." | codebase-researcher.md:14 | Scope creep into design/recommendation | keep-verbatim |
| 10 | "**You decide neither what to research nor where it lands** — your dispatch brief names both:" | codebase-researcher.md:14 | Agent inventing its own angle/target | keep-verbatim |
| 11 | Angle bullet: "**Angle** — what the area **already does** ... how it's **built** ... or both. Research exactly the angle you're given." | codebase-researcher.md:16 | Wrong-angle research (product vs technical) | keep-verbatim — no kernel/template equivalent, this is the agent's own dispatch contract |
| 12 | Output-target bullet: "**Output target** — the file + section to write ... The two common ones: a feature's `research.md` ... and a plan's `## Current State`. Write to the one your brief names — never invent a different file." | codebase-researcher.md:17 | Wrong file written | **merge** — the two-targets description duplicates RP-kernel:13 ("Two maps exist: `research.md` ... and the plan's `## Current State`"); trim to the agent-specific instruction ("brief names it, never invent a different file"), point at RP-kernel for what the two targets are |
| 13 | `## Workflow` heading | codebase-researcher.md:19 | Structural drift | keep-verbatim |
| 14 | Step 1: "The team-lead gives you the feature request, the feature dir, the **angle**, the **output target** ..., and a **scope** .... Create the dir if it doesn't exist." | codebase-researcher.md:21 | Missing brief field; researcher writes to a dir that was never created | keep-verbatim — dispatch-receipt contract, no kernel/template equivalent |
| 15 | "Explore with `codegraph` first (primarily `codegraph_explore`, per the project `CLAUDE.md`); fall back to `Read`/`Grep` only to confirm a specific detail." | codebase-researcher.md:22 | Wide sweep instead of ladder climb | now-in-kernel-research-protocol — this is RP-kernel's hard rule + the "If you are the codebase-researcher" line ("codegraph first ... then Read the specific files") restated |
| 16 | "When the angle is **what the area already does**, the behaviour-based tests are a primary source — read them (the technique lives in `vibe-research-protocol`)." | codebase-researcher.md:22 | Product angle researched without mining tests | now-in-kernel-research-protocol — RP-kernel:28 already states this near-verbatim ("the behaviour-based test suite is a primary source ... inventory existing behavior in B-NNN-style language"); source already deferred the technique to the skill, so full sentence collapses to a pointer |
| 17 | "Check `.workspace/plans/` (including `archive/`) for prior plans/specs touching this area, and learnings that bear on it (rejected decisions, env traps) — both the curated `.workspace/learnings.md` (cited by L-id) and any fresh per-run files at `.workspace/plans/*/learnings.md` (cited by plan slug)." | codebase-researcher.md:22 | Re-deciding a rejected decision; missing env trap | **merge** — not in RP-kernel at all (kernel doesn't mention plans/learnings), but substantially duplicates `research-template.md`'s own "Constraints & risks" inline note (template:60-62, same L-id/plan-slug citation forms) — keep the instruction, trim wording to avoid restating the template |
| 18 | Fan-out bullet: "**Fan out when the feature is broad.** ... spawn **parallel `Explore` (or Haiku) subagents — one per area — as compression boundaries**, then synthesize ... Do not paste a subagent's raw output; lift the facts and cite `file:line`. The project `CLAUDE.md` token rules apply ..." | codebase-researcher.md:23 | Context bloat from pasted subagent output | now-in-kernel-research-protocol — RP-kernel:15 (ladder rung 3: "spawn it yourself ... work from its returned summary, cite `file:line`, never paste its raw output") and RP-kernel:28 ("fan out parallel `Explore` subagents for breadth, then synthesize") together cover this near-completely |
| 19 | Step 3 open: "Fill the target your brief names, following its shape — a bundled template (absolute path in your brief) or a named plan section." | codebase-researcher.md:24 | Wrong-shape output | keep — agent-specific decision of which shape source to follow |
| 20 | "Lead with what the downstream reader most needs to act on." | codebase-researcher.md:24 | Buried lede, reader stops at Summary and misses the point | keep-verbatim — no template/kernel equivalent |
| 21 | "When the target carries a **Summary** (≤10 bullets), that's the only part the lead reads — put what the area already does vs what's missing, then the sharpest risks, there." | codebase-researcher.md:24 | Lead misses the framing signal | **merge** — near-verbatim duplicate of `research-template.md:30-32`'s own Summary comment ("The ONLY section the team-lead reads ... what the feature's area ALREADY DOES vs what's MISSING ... then the sharpest risks/unknowns"); template is self-documenting, point at it |
| 22 | "Every code claim cites `file:line`." | codebase-researcher.md:24 | Unverifiable fact | **merge** — triple-stated: also in Boundaries (#30 below, "An uncited code claim doesn't count") and in `research-template.md:22` ("Every claim about code carries a `file:line` ... An uncited claim doesn't count"); standard rule 5 confines a constraint to description+Boundaries — collapse to the one Boundaries copy |
| 23 | "Note explicitly what does **not** exist where a reader might assume it does." | codebase-researcher.md:24 | Reader assumes unbuilt feature exists | **merge** — verbatim duplicate of `research-template.md:47` ("Note explicitly what does NOT exist where a reader might assume it does.") |
| 24 | "If the target already has content (a scoped or follow-up dispatch), **extend it in place** — add your bullets, update the Summary; never start a second file." | codebase-researcher.md:24 | Duplicate/orphaned research files across re-dispatches | KEEP-VERBATIM — unique, no kernel or template equivalent, and the single highest-value hard rule in Step 3 |
| 25 | Step 4: "Reply per `vibe-team-communication-protocol` done-format, terse: target written, section names, citation count, unknown count." | codebase-researcher.md:25 | Report never delivered; lead can't tell what was written without opening the file | **merge** — rename skill ref to `vibe-team-protocol`; the done-format itself (Wrote:/Result:/Blocked on:) is TP-kernel's contract (don't restate it, rule 6) but the domain-specific field contents (target written, section names, citation count, unknown count) are this agent's own and should survive as the `Wrote:`/`Result:` instantiation |
| 26 | "**Never dump findings into the reply** — the file is the channel, not the chat." | codebase-researcher.md:25 | Findings pasted into chat, bypassing the cited-file discipline | **merge** — near-duplicate of TP-kernel's "Never `SendMessage`: long source dumps (cite `file:line`) ..." line; collapse to one copy, kernel's is generic enough to cover it |
| 27 | `## Boundaries` heading | codebase-researcher.md:27 | Structural drift | keep-verbatim |
| 28 | "**Facts only.** No design proposals, no recommendations, no "we should". If you see an obvious design implication, state the underlying fact and let the architects draw the conclusion." | codebase-researcher.md:29 | Researcher smuggles design opinions past the architect | KEEP-VERBATIM — the single most load-bearing boundary in this file, no kernel equivalent |
| 29 | "Read-only on code. You write **only** the single target your brief names. Never edit source, behaviors, other plan sections, or other workspace files." | codebase-researcher.md:30 | Researcher edits source or someone else's section | KEEP-VERBATIM — unique, no kernel equivalent |
| 30 | "≤ ~120 lines per target. Bullets, 1–2 lines each. An uncited code claim doesn't count — cut it or cite it." | codebase-researcher.md:31 | Target bloats past what downstream reads; uncited claims pass as fact | keep — canonical location absorbing #22's duplicate; note this rule must survive at the agent level (not just the template) because it also governs the plan's `## Current State` target, which has no self-documenting budget note of its own |
| 31 | "A gap you can't settle within your run goes where the target's shape places open items (an **Unknowns** section, or noted inline in `## Current State`), not in chat." | codebase-researcher.md:32 | Open question lost in chat instead of the artifact | keep — generalizes across both target shapes; `research-template.md:66-69` only self-documents the `research.md` half (its own Unknowns section), the plan's inline case has no other home |

**Row count: 31**

## Disposition tally

- keep-verbatim: 16 (#1,3,4,5,7,8,9,10,11,13,14,20,24,27,28,29)
- keep: 3 (#19,30,31)
- merge: 8 (#2,12,17,21,22,23,25,26)
- delete: 0
- now-in-kernel-team-protocol: 1 (#6)
- now-in-kernel-research-protocol: 3 (#15,16,18)

## Verbatim contracts to preserve (exact quotes)

- "**You decide neither what to research nor where it lands** — your dispatch brief names both:" (codebase-researcher.md:14)
- "**Angle** — what the area **already does** (user-facing surface, existing flows, the behaviors the system already has), how it's **built** (module/slice structure, data model, integration points, patterns + platform subsystems, constraints + migration landmines), or both. Research exactly the angle you're given." (codebase-researcher.md:16)
- "Create the dir if it doesn't exist." (codebase-researcher.md:21)
- "Lead with what the downstream reader most needs to act on." (codebase-researcher.md:24)
- "If the target already has content (a scoped or follow-up dispatch), **extend it in place** — add your bullets, update the Summary; never start a second file." (codebase-researcher.md:24)
- "**Facts only.** No design proposals, no recommendations, no "we should". If you see an obvious design implication, state the underlying fact and let the architects draw the conclusion." (codebase-researcher.md:29)
- "Read-only on code. You write **only** the single target your brief names. Never edit source, behaviors, other plan sections, or other workspace files." (codebase-researcher.md:30)

## {{PLACEHOLDER}} candidates

**None found.** Like `architect.md`, this file is already project-agnostic by construction — the angle and output
target are resolved at **dispatch time** from the brief, not baked in at generation time. The `.workspace/plans/`,
`.workspace/learnings.md`, and `codegraph` references are fixed vibe-wide conventions, not per-project variables.
If the builder later wants a project-specific default (e.g. a non-standard research dir), that's the first
placeholder candidate — nothing in v1 demands one today.

## Duplicates / contradictions found

1. **Description over budget, worse than architect's.** `codebase-researcher.md:3` is **83 words** against the
   ≤60-word ceiling (rule 2) — the largest overage found in this migration so far. It also expresses its boundary
   as "Proposes nothing, designs nothing, edits no source" rather than a literal `Does not …` clause; the rewrite
   should both trim and reword to the standard's expected shape (e.g. "... Does not design, recommend, or edit
   source.").
2. **Missing canonical section — structural defect.** The standard (rule 4) requires `## Skills & documents you
   refer to` (a table: reference → resolves to → why) between the intro and `## Workflow`. This source has **no
   such section at all** — it names `codegraph`, `.workspace/plans/`, `.workspace/learnings.md`, and the output
   template only inline, scattered across Workflow prose. This is not a "keep/merge/delete" row (nothing to
   dispose of — the section simply doesn't exist) but the rewrite MUST add it; see skeleton below for a proposed
   table pulling those scattered references together.
3. **Stale skill name.** `skills: vibe-team-communication-protocol` (codebase-researcher.md:8) must become
   `vibe-team-protocol` to match `templates/kernel/team-protocol.md`'s `name:` field. `vibe-research-protocol`
   (codebase-researcher.md:9) needs no rename — it already matches the kernel skill's `name:` field exactly.
4. **Triple-stated citation rule.** "Every code claim cites `file:line`" appears in Workflow step 3 (#22,
   codebase-researcher.md:24), again in Boundaries (#30, codebase-researcher.md:31: "An uncited code claim doesn't
   count — cut it or cite it"), and a third time in `research-template.md:22`. Standard rule 5 confines a
   constraint to description (top) + Boundaries (bottom) only — collapse Workflow's copy, keep Boundaries' as
   canonical, let the template's copy stand (different audience: the human/agent filling the template file itself).
5. **Cross-artifact duplication with `research-template.md`.** Three Workflow clauses (#17 prior-plans/learnings,
   #21 Summary framing, #23 "note what doesn't exist") substantially restate the template's own inline `<!-- -->`
   comments (template:30-32, 47, 60-62). Since `research-template.md` is already self-documenting (Phase 1,
   confirmed via ledger cross-reference on `plan-template.md`'s equivalent status), the agent file should point at
   "follow the target's own inline notes" rather than restate the Summary/Current-state/Constraints shape here —
   same pattern the architect disposition found against `plan-template.md`. Caveat: the template only covers the
   `research.md` half of this agent's two possible targets — the plan's `## Current State` has no self-documenting
   equivalent, so the agent file can't drop these rules entirely, only avoid restating the `research.md`-specific
   wording.
6. **Workflow step 2 + fan-out bullet duplicate the kernel's dedicated researcher section almost completely.**
   `templates/kernel/research-protocol.md:26-28` ("If you are the codebase-researcher") was written specifically to
   house this agent's rung-4 behavior (codegraph first, fan out `Explore`/Haiku subagents, synthesize, mine
   behaviour tests for the product angle). Rows #15, #16, #18 restate it in different words — collapse to a
   one-line pointer ("Climb the ladder per the research protocol — you are rung 4").
7. **Reply-shape near-duplicate.** #26 ("Never dump findings into the reply — the file is the channel, not the
   chat") duplicates TP-kernel's "Never `SendMessage`: long source dumps" line closely enough that only one needs
   to survive; keep the kernel's generic version and drop the local restatement.

## Suggested ≤70-line skeleton (canonical anatomy)

```
---
name: codebase-researcher
description: <trim #2 to ≤60 words — keep "maps current state, facts only, file:line cited" +
  "brief names angle and output target, agent decides neither" + a literal
  "Does not design, recommend, or edit source." clause>
model: sonnet
effort: high
color: yellow
skills:
  - vibe-team-protocol
  - vibe-research-protocol
---
<!-- vibe-template: templates/agents/codebase-researcher.md v1 | generated <date> | edits below this marker are yours -->

# codebase-researcher

#9 verbatim (current-state, facts-only, no re-paid exploration) + #10 verbatim (decide neither,
brief names both):
- #11 verbatim (Angle bullet)
- #12 trimmed (Output target — brief names it, never invent a different file; the two common
  shapes are defined in the research protocol, don't restate them)

## Skills & documents you refer to

| Reference | Resolves to | Why |
|---|---|---|
| Team protocol | `vibe-team-protocol` skill | Done-report format, andon/role discipline |
| Research protocol | `vibe-research-protocol` skill | You ARE rung 4 — its own "if you are the codebase-researcher" section defines your climb; don't restate it |
| Output target | template/section named in brief | Exact shape — self-documenting (research-template.md), follow its inline notes |
| Prior plans & learnings | `.workspace/plans/` (+ `archive/`), `.workspace/learnings.md` (L-id), per-run `.workspace/plans/*/learnings.md` (plan slug) | #17 — rejected decisions, env traps bearing on this area |
| Code index | `codegraph` MCP | Primary lookup tool, per project `CLAUDE.md` |

## Workflow

1. #14 verbatim (brief gives feature request/dir/angle/target/scope; create the dir if missing).
2. Climb the research protocol ladder — you are rung 4: `codegraph` first, fan out parallel
   `Explore`/Haiku subagents for breadth, synthesize, cite `file:line` (mechanics live in the
   skill, not restated here). Also check prior plans/learnings per the table above.
3. #19 (fill the named target, following its own shape) + #20 verbatim (lead with what the
   reader needs) + #24 verbatim (extend in place on repeat dispatch; never start a second file).
   The target's own inline notes govern Summary/Current-state/citation shape — don't restate them.
4. Reply per the team protocol done-format: target written, section names, citation count,
   unknown count.

## Boundaries

- #28 verbatim (Facts only — no design/recommendation; state the fact, let architects conclude)
- #29 verbatim (Read-only on code; write only your named target)
- #30 (≤~120 lines per target, bullets 1-2 lines; an uncited claim doesn't count)
- #31 (unsettled gaps go in the target's own open-items section, never chat)
```

Estimated ~40-45 lines including frontmatter — comfortable margin under the 70-line ceiling.
