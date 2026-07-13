# Disposition: agents/architect.md → templates/agents/architect.md

Scout output (sonnet, 2026-07-13). Source = `agents/architect.md` (64 lines). Referenced skills read in full:
`skills/vibe-team-communication-protocol/SKILL.md` (CP), `skills/vibe-research-protocol/SKILL.md` (RP, already
ported verbatim to `templates/kernel/research-protocol.md` per ledger 1.2), `skills/vibe-team-orchestration/SKILL.md`
(ORCH — referenced in prose but **not declared** in this file's frontmatter `skills:` list, see contradiction below).
Standard = `standards/agent-standard.md`. Kernel = `templates/kernel/team-protocol.md` (TP, merges CP+ORCH),
`templates/kernel/review-protocol.md` (RVP). Also cross-read `templates/workspace/plan-template.md` (already
Phase-1-migrated, self-documenting) since several Workflow bullets turned out to duplicate it.
The author of `templates/agents/architect.md` works from THIS file, not the sources.

## Disposition table

| # | Instruction (key terms verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: architect` | architect.md:2 | Dispatch by wrong name | keep-verbatim |
| 2 | description: "Designs ONE domain's slice of a vibe plan — ... writing directly into the plan during /vibe:plan. Domain-generic: ... resolves and follows that domain's own `<domain>-architecture` skill ... Does not write code." (71 words) | architect.md:3 | Orchestrator dispatch API bloated/ambiguous | **merge** — over budget, must trim to ≤60 words (see contradiction #1) |
| 3 | `model: opus` | architect.md:4 | Under-specified dispatch budget | keep-verbatim |
| 4 | `effort: xhigh` | architect.md:5 | Under-specified dispatch budget | keep-verbatim |
| 5 | `color: cyan` | architect.md:6 | Dispatch-UI ambiguity | keep-verbatim |
| 6 | `skills: vibe-team-communication-protocol` | architect.md:8 | Stale skill ref once kernel renamed | now-in-kernel-team-protocol (rename entry) |
| 7 | `skills: vibe-research-protocol` | architect.md:9 | Stale skill ref once kernel renamed | now-in-kernel-research-protocol (rename entry) |
| 8 | `# architect` heading | architect.md:12 | Structural drift | keep-verbatim |
| 9 | Intro: "You design ONE domain's slice of a feature's plan ... You do not write code. Your **domain** ... is named in your dispatch brief; everything below is relative to it." | architect.md:14 | Domain-generic scope confusion | keep (trim to fit budget) |
| 10 | "## Skills & documents you refer to" + "Resolve these before designing. `<domain>` is the domain from your brief (e.g. `backend` → `backend-architecture`)." | architect.md:16-18 | Canonical-anatomy heading; unresolved `<domain>` token | keep-verbatim |
| 11 | Table header (Reference / Resolves to / Why) | architect.md:20-21 | none named | keep (cosmetic — align columns to standard's "skill/doc → when to use" shape) |
| 12 | Row: Communication protocol → `vibe-team-communication-protocol` skill → "Done-format, channel/role discipline, andon-cord escalation" | architect.md:22 | Broken resolution once renamed | now-in-kernel-team-protocol |
| 13 | Row: Domain architecture → `<domain>-architecture` skill → "The authority for every structural decision — your domain's conventions, and which plan sections your domain owns" | architect.md:23 | Architect invents conventions with no domain authority | keep-verbatim |
| 14 | Row: Constitution → `.workspace/constitution.md` → "The project's non-negotiable rules — gate your design against whatever it says and record the **Constitution** line. Read what's there; don't assume specific articles or numbering" | architect.md:24 | Design ships ungated against non-negotiables | keep-verbatim |
| 15 | Row: Plan template → path in brief → "Exact shape of the sections you fill" | architect.md:25 | Wrong plan shape | keep |
| 16 | Row: Behaviors & UX → dir's `spec.md` / plan's inline `## Behaviors` → "The locked WHAT you design against ... Reference by id, never restate" | architect.md:26 | Designing off unlocked/undefined WHAT; spec restated into plan | keep-verbatim |
| 17 | Row: Current-state facts → plan's `## Current State` + `research.md` → "The code facts to design on — cite, never restate" | architect.md:27 | Designing on stale/undiscovered facts; plan bloated with copied facts | keep-verbatim |
| 18 | Row: Code index → `codegraph` MCP → "**Targeted** lookups ...; verify load-bearing facts before designing on them" | architect.md:28 | Undesigned/unverified load-bearing facts | keep |
| 19 | Row: Research protocol → `vibe-research-protocol` skill → "How to find code facts without sweeping" | architect.md:29 | Stale resolution once renamed | now-in-kernel-research-protocol |
| 20 | "If the `<domain>-architecture` skill is **absent**, say so in your reply and design from the constitution + research alone — do not invent conventions." | architect.md:31 | Architect invents unauthorized conventions when skill missing | **KEEP-VERBATIM** (hard rule, no kernel equivalent) |
| 21 | "**Preserve your context for decisions.**" + full ladder restatement ("Follow `vibe-research-protocol` to find what you need (`## Current State`/research.md → codegraph → Explore → codebase-researcher); don't go *discovering* the codebase with wide `Read`/`Grep`/`Glob` sweeps yourself.") | architect.md:33 | Context bloat from wide sweeps | now-in-kernel-research-protocol — this restates the kernel ladder beyond the standard's one-line-pointer allowance (rule 6); collapse to "Preserve your context for decisions — follow the research protocol." |
| 22 | Workflow step 1: read behaviors/constitution/Current-State(+research.md)/plan-template; FE locked-UX conditional; load `<domain>-architecture`; verify via codegraph | architect.md:37 | Designing without grounding docs; FE built off wrong/no UX | keep (trim for length) |
| 23 | Workflow step 2 intro: "If another domain has already authored its sections, **append** under your own `### <domain>` subheads — never edit another domain's content." | architect.md:38 | Cross-domain content collision | **delete** — verbatim duplicate of Boundaries (#39, architect.md:59); standard rule 5 forbids mid-file constraint restatement, single copy belongs in Boundaries only |
| 24 | Architecture bullet: decisions 1-line, Constitution line, ⚠️ tool/platform choice w/ options+recommendation, unsettled ⚠️ → Open Questions | architect.md:39 | Undocumented/silently-designed-around ⚠️ | **merge** — substantially duplicates `plan-template.md:67-79`'s own inline instructions (now self-documenting since Phase 1.5); trim to a pointer, don't restate |
| 25 | Data model bullet: tables/columns/FKs/indexes, 1-2 line bullets, BE-only | architect.md:40 | Missing persistence detail | keep |
| 26 | Platform bullet: NEW subsystem → own Platform task (T-9xx) + paired platform test task, ordered before block, ships fake/mock; small extension folds inline | architect.md:41 | Platform/feature split violated; wrong task shape/ordering | **merge** — near-verbatim duplicate of `plan-template.md:74-79`; trim to pointer |
| 27 | Tasks bullet: one coherent deliverable, never pre-split by artifact, budget ~3-5 eng deliverables (flag overflow → split plan), task-id ranges per plan-template | architect.md:42 | Task sprawl; plan-size overflow undetected | **merge** — duplicates `plan-template.md:16-19,28-30,145`; trim to pointer |
| 28 | Test behaviors bullet: domain's inventory, each citing a Behavior (B-NNN) | architect.md:43 | Untested/untraceable behaviors | keep |
| 29 | Contracts & wiring bullet: include ONLY if adds real value; otherwise omit | architect.md:44 | Low-value boilerplate bloating plan | keep |
| 30 | Workflow step 3: consuming another domain's contracts → keep tasks consistent; codegen/regen step named from `<domain>-architecture`/environment skill, never hardcoded here | architect.md:45 | Client/contract drift; hardcoded env command going stale | KEEP-VERBATIM |
| 31 | Workflow step 4: "Reply per `vibe-team-communication-protocol` done-format. Decisions go in the plan (Architecture / Decision Log), not chat." | architect.md:46 | Report never delivered (only emitted); decisions lost in chat | now-in-kernel-team-protocol (rename + already carried by kernel done-format contract) |
| 32 | "## On-call during implementation" heading | architect.md:48 | — | keep, but flagged: a 5th top-level section outside the canonical `Skills → Workflow → Boundaries` anatomy — author must fold its surviving content into Workflow or Boundaries rather than keep a standalone section |
| 33 | "During `/vibe:implement` you stay on-call (per `vibe-team-orchestration`) for the things your design judgment owns — you never write code:" | architect.md:50 | Design-judgment duties dropped during implement phase | **merge** — also fixes an orphan reference (see contradiction #2); point at team-protocol kernel |
| 34 | "**Confirm a suspected design flaw** a reviewer raises, before it's escalated — is the *design* wrong, or only the code?" | architect.md:52 | Reviewer escalates a code-only issue as a design flaw, or vice versa | keep — architect-specific judgment call, no kernel equivalent |
| 35 | "**Consolidate review findings** when the running command asks for it: given several reviewers' findings over one block, dedupe them, drop false positives, and reply with one **prioritized, design-coherent fix list**. You hold the design context ... You triage and hand back the list; the engineer fixes." | architect.md:53 | Conflicting/duplicate findings sent to the fix engineer unfiltered | **now-in-kernel-team-protocol — MANDATED DELETE.** Single-sourced at `team-protocol.md:42` ("the consolidation owner (architect, per on-call) gets the gathered findings before the fix"). Replace with a pointer only. |
| 36 | "## Boundaries" heading | architect.md:55 | Canonical-anatomy heading | keep-verbatim |
| 37 | "You design and write the plan; you never write application code." | architect.md:57 | Code-boundary violation | KEEP-VERBATIM — canonical bottom copy of the description's `Does not write code` clause (rule 5: top + bottom only) |
| 38 | "**The `<domain>-architecture` skill is the authority** for every structural decision — it is supplied by the consuming repo, not bundled with the vibe plugin. When it conflicts with your defaults, it wins." | architect.md:58 | Architect overrides domain conventions with its own defaults | KEEP-VERBATIM |
| 39 | "You own ONE domain's slice. Never edit another domain's authored content — append your own subheads beneath it." | architect.md:59 | Cross-domain overwrite | KEEP-VERBATIM — canonical location; absorbs duplicate #23 |
| 40 | "Bullets only, 1–2 lines. No prose paragraphs, no spec restatement. Each fact has one home — cross-reference by id, never restate across sections." | architect.md:60 | Plan bloat / restatement drift | KEEP-VERBATIM |
| 41 | "Current-state facts ... belong in `research.md` — cite it, don't copy it into the plan. The plan carries decisions and contracts." | architect.md:61 | Plan duplicates research.md | KEEP-VERBATIM |
| 42 | "Name an existing artifact when reuse is load-bearing; never pre-name new files — the engineer owns naming." | architect.md:62 | Architect pre-names files, engineer naming authority violated | keep-verbatim (note: `plan-template.md:69-70` states the same rule for the human/agent filling the template — acceptable cross-artifact duplication, both audiences need it) |
| 43 | "Use `codegraph` for code lookups; `product-designer` on-call for UX sanity checks when relevant." | architect.md:63 | Wrong/no lookup tool used; UX shipped without design-authority check | keep-verbatim |

**Row count: 43**

## Disposition tally

- keep-verbatim: 20 (#1,3,4,5,8,10,13,14,16,17,20,30,36,37,38,39,40,41,42,43)
- keep: 10 (#9,11,15,18,22,25,28,29,32,34)
- merge: 5 (#2,24,26,27,33)
- delete: 1 (#23)
- now-in-kernel-team-protocol: 4 (#6,12,31,35)
- now-in-kernel-research-protocol: 3 (#7,19,21)

## Verbatim contracts to preserve (exact quotes)

- "If the `<domain>-architecture` skill is **absent**, say so in your reply and design from the constitution + research alone — do not invent conventions." (architect.md:31)
- "When your domain **consumes another domain's contracts** (new/changed routes, request/response shapes), keep your tasks consistent with those contracts. Any client-regeneration or codegen step your domain requires is defined in your `<domain>-architecture` / environment skill — name it in the task, don't hardcode a command here." (architect.md:45)
- "You design and write the plan; you never write application code." (architect.md:57)
- "**The `<domain>-architecture` skill is the authority** for every structural decision — it is supplied by the consuming repo, not bundled with the vibe plugin. When it conflicts with your defaults, it wins." (architect.md:58)
- "You own ONE domain's slice. Never edit another domain's authored content — append your own subheads beneath it." (architect.md:59)
- "Bullets only, 1–2 lines. No prose paragraphs, no spec restatement. Each fact has one home — cross-reference by id, never restate across sections." (architect.md:60)
- "Name an existing artifact when reuse is load-bearing; never pre-name new files — the engineer owns naming." (architect.md:62)
- Row: Domain architecture → `<domain>-architecture` skill → "The authority for every structural decision — your domain's conventions, and which plan sections your domain owns" (architect.md:23)
- Row: Constitution → `.workspace/constitution.md` → "gate your design against whatever it says and record the **Constitution** line. Read what's there; don't assume specific articles or numbering" (architect.md:24)

## {{PLACEHOLDER}} candidates

**None found.** Unlike most agent files, `architect.md` is already project-agnostic by construction: domain
variation (`backend`/`frontend`/`mobile`/…) is resolved **at runtime** from the dispatch brief via the `<domain>`
token, not baked in at generation time — so there's nothing here for the builder to stamp with `{{…}}`. The
`.workspace/constitution.md` path, the plan-template path ("in your brief"), and the `product-designer` on-call
mention are all fixed vibe-wide conventions, not per-project variables. Confirm this holds when the author drafts
the rewrite — if a project-specific default ever needs baking in (e.g. a default domain list), that's the first
placeholder candidate to introduce, not something this source demands today.

## Duplicates / contradictions found

1. **Description over budget.** `architect.md:3`'s description is **71 words**; `agent-standard.md` rule 2 caps it
   at ≤60. Must trim ~11+ words while keeping both required parts (what it does + the `Does not write code` clause).
2. **Orphan skill reference.** `architect.md:50` says "you stay on-call (per `vibe-team-orchestration`)" but the
   frontmatter `skills:` list (architect.md:7-9) only declares `vibe-team-communication-protocol` and
   `vibe-research-protocol` — `vibe-team-orchestration` is never declared. A v1 defect; the rewrite must declare
   whatever kernel skill(s) it actually names (here: `team-protocol`, which merges CP+ORCH per ledger 1.3).
3. **Mid-file constraint duplicate.** `architect.md:38` ("never edit another domain's content — append your own
   subheads") restates `architect.md:59` verbatim-in-substance. `agent-standard.md` rule 5 confines constraints to
   the description (top) and `## Boundaries` (bottom) only — the Workflow copy must go, Boundaries keeps the one
   canonical copy.
4. **Cross-artifact duplication with `plan-template.md`.** Workflow's Architecture/Platform/Tasks bullets
   (architect.md:39-42) substantially restate `plan-template.md`'s own inline HTML-comment instructions
   (plan-template.md:16-19, 28-30, 67-79, 145) — T-9xx numbering, the paired-platform-test-task rule, the
   fake/mock-ships rule, the ~3-5 deliverable budget, and the Constitution-line convention are now stated in BOTH
   places. Since `plan-template.md` was already rewritten to be self-documenting (Phase 1.5, ledger), the agent
   file should point at it rather than restate it — this is the biggest single length-reduction opportunity for
   fitting the ≤70-line budget.
5. **KNOWN MANDATE confirmed.** `architect.md:53`'s "Consolidate review findings" bullet is the v1 copy of the
   consolidation rule now single-sourced at `templates/kernel/team-protocol.md:42` (the parallel-fan-out
   combine-rule paragraph: "the consolidation owner (architect, per on-call) gets the gathered findings before the
   fix"). Delete the v1 prose (dedupe/drop-false-positives/prioritized-list mechanics) and replace with a pointer;
   only the fact that the architect **is** the consolidation owner needs restating here, the "how" lives in the
   kernel.
6. **Non-canonical 5th section.** "## On-call during implementation" (architect.md:48) sits outside the standard's
   anatomy (`# name → Skills&docs → Workflow → Boundaries`). Once #5's consolidation content is deleted, only the
   "confirm a suspected design flaw" duty survives — small enough to fold into `## Workflow` (as a final
   implement-phase step) or `## Boundaries`, rather than keep as a standalone section.

## Suggested ≤70-line skeleton (canonical anatomy)

```
---
name: architect
description: <trim #2 to ≤60 words — keep "designs one domain's plan slice" + domain-generic
  `<domain>-architecture` resolution + "Does not write code.">
model: opus
effort: xhigh
color: cyan
skills:
  - team-protocol
  - research-protocol
---
<!-- vibe-template: templates/agents/architect.md v1 | generated <date> | edits below this marker are yours -->

# architect
<trimmed #9 — one domain's slice, domain named in brief, never writes code>

## Skills & documents you refer to
| Reference | Resolves to | Why |
|---|---|---|
| Team protocol | `team-protocol` skill | Done-format, role/andon discipline, on-call + consolidation mechanics |
| Domain architecture | `<domain>-architecture` skill (per brief) | #13 verbatim — authority; absent → #20 verbatim |
| Constitution | `.workspace/constitution.md` | #14 verbatim |
| Plan template | path in brief | #15 — shape only; template is self-documenting, don't restate its notes |
| Behaviors & UX | spec.md / inline Behaviors | #16 verbatim |
| Current-state facts | Current State + research.md | #17 verbatim |
| Code index | `codegraph` MCP | #18 |
| Research protocol | `research-protocol` skill | ladder discipline — one line, no restatement |

## Workflow
1. #22 (read grounding docs, load domain-architecture skill, verify via codegraph)
2. Fill your domain's plan sections per the plan-template + domain-architecture skill — the
   template's own notes govern Architecture/Platform/Tasks/Test-behaviors/Contracts shape,
   don't restate them here. Append under your own subhead; never edit another domain's (Boundary, not repeated here).
3. #30 verbatim (consuming another domain's contracts)
4. Reply per team protocol done-format; decisions go in the plan, not chat.
5. On-call during implement (team protocol): confirm suspected design flaws (#34 verbatim);
   you are the consolidation owner for fan-out review findings — mechanics per team protocol.

## Boundaries
- #37 verbatim
- #38 verbatim
- #39 verbatim
- #40 verbatim
- #41 verbatim
- #42 verbatim
- #43 verbatim
```

Estimated ~45-55 lines including frontmatter — comfortable margin under the 70-line ceiling even before
accounting for the author's own phrasing choices.
