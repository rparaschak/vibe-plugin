# Disposition: agents/product-designer.md → template rewrite

Scout output (sonnet, 2026-07-13). Source = `agents/product-designer.md` (30 lines, v1). Standard = `standards/agent-standard.md`. Kernel = `templates/kernel/{team-protocol,research-protocol}.md`. Also read: `templates/workspace/product-design-sample.md` (the project-supplied `product-design` skill starter) and `templates/workspace/spec-template.md` (the `## UX structure` section this agent fills — self-documenting). No project `product-design` skill instance exists in this repo to read (it's resolved by name at runtime from the consuming repo); the starter stands in for it. Ledger item 2.9, no product-designer-specific migration mandate recorded (unlike reviewer's mandates (a)-(c)) — this rewrite follows the general Phase-2 pipeline only. The author of the rewritten `product-designer.md` works from THIS file, not the source.

## Disposition table

| # | Instruction (key terms verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: product-designer` | L2 | Agent unaddressable/undispatchable | keep-verbatim |
| 2 | `description:` full 72-word field (measured: `sed -n '3p' \| wc -w` → 72, incl. the `description:` token) — locked-behaviors input, explore-UI-to-learn-conventions, design-a-pragmatic-UX, write-to-spec's-UX-structure, iterate-with-invoker, "Does not write code.", when-used (`/vibe:spec`, after behaviors locked), and the runtime-resolved project-supplied `product-design` skill fact | L3 | Orchestrator can't route/scope the agent from a bloated API surface — standard rule 2 caps description at ≤60 words; this file is over | merge (trim to ≤60 words; keep the `Does not write code` clause, the "writes into spec.md's `## UX structure`, iterating with the invoker" core job, and the project-supplied/runtime-resolved `product-design` skill fact since it's genuinely API-relevant — the orchestrator needs to know this agent may run with no design-system skill present; drop the "not bundled with the vibe plugin" explainer clause, which the skills-table row already carries in full) |
| 3 | `model: opus` | L4 | Wrong capability tier for a creative-but-bounded design job | keep-verbatim |
| 4 | `effort:` — **absent from frontmatter** (no line between `model:` and `color:`) | — (gap L4-L5) | Under-specified dispatch budget — agent-standard rule 1 names this exact failure | merge (frontmatter contract requires it; source carries no value to preserve, author must set one — recommend `effort: high`, matching the bounded-single-artifact precedent already set by `engineer`/`reviewer`/`qa-engineer`/`test-engineer` (all `high`), not the broader cross-plan `architect`/`critic` precedent (`xhigh`) — this agent designs ONE spec section, not a whole plan) |
| 5 | `color: pink` | L5 | Frontmatter contract field missing | keep-verbatim |
| 6 | `skills: [vibe-team-communication-protocol, vibe-research-protocol]` | L6-8 | Agent can't resolve its own protocol skills post-kernel-rename | keep, but **rename**: `vibe-team-communication-protocol` → `vibe-team-protocol` (kernel `team-protocol.md` frontmatter `name: vibe-team-protocol` — the old skill name doesn't exist in the kernel); `vibe-research-protocol` name unchanged |
| 7 | `# product-designer` | L11 | Missing canonical top heading | keep-verbatim |
| 8 | "You design the UX for ONE feature and write it into the spec, then iterate with the invoker. You do not write code, and you touch only the spec's `## UX structure` section." | L13 | Agent doesn't know its scope | merge — this is unheaded prose duplicating the description AND restating "Does not write code"/"only UX structure" a 2nd time outside the two sanctioned locations (standard rule 5: constraints live only in description + Boundaries). Keep one short orientation sentence (what the agent does); drop the Does-not restatement entirely — it belongs only in description + the new `## Boundaries` |
| 9 | `## Skills & documents you refer to` | L15 | Missing canonical section | keep-verbatim |
| 10 | Table row: "🔌 Communication protocol \| `vibe-team-communication-protocol` skill \| Done-format, andon-cord escalation" | L19 | Agent doesn't know where done-format/andon rules live | keep, **renamed** to `vibe-team-protocol` |
| 11 | Table row: "📁 Product design \| `product-design` skill \| ...design system, component library, layout/interaction patterns. **Project-supplied; resolve it by name.** If absent, propose from the existing UI alone and say so." | L20 | Agent invents UI conventions instead of resolving the project's real design system, or silently guesses when the skill is missing | keep-verbatim — the single most load-bearing, agent-specific, non-kernel fact in the file; no kernel or template equivalent states the absent-skill fallback |
| 12 | Table row: "🔌 Research protocol \| `vibe-research-protocol` skill \| How to learn the UI without sweeping: `research.md` → `Explore` → targeted `Read`" | L21 | Agent re-derives the ladder instead of citing it | keep — correct kernel-by-reference pattern (name + one-line why, no restatement). Flag: duplicated at length by Workflow step 1 (row 15) |
| 13 | Table row: "🔌 Spec template \| path in your brief (bundled with the plugin) \| The exact shape of the `## UX structure` section you fill in `spec.md`" | L22 | Agent doesn't know where to find the required deliverable shape | keep — path-resolution row, doesn't restate content (correct pattern). Flag: Workflow step 3 (rows 18-19) over-restates the template's own content instead of just pointing here |
| 14 | `## Workflow` | L24 | Missing canonical section | keep-verbatim |
| 15 | Step 1: full ladder restatement — "start from `research.md`, then use the `Explore` subagent (per `vibe-research-protocol`) to find the related screens, the components already in use, and the navigation/interaction patterns; then **`Read` specific files yourself**... Don't go discovering the whole codebase with broad sweeps — explore to locate, read to confirm." | L26 | Agent re-derives the research-protocol ladder mechanics inline instead of citing the skill — standard rule 6 violation (kernel restated, not referenced in one line) | now-in-kernel-research-protocol for the ladder mechanics (rungs, sweep-ban, "explore to locate, read to confirm"); merge for what survives — keep only the two facts unique to this agent: (a) its inputs are "the locked behaviors + `spec.md`/`research.md` paths from the invoker", and (b) *what* it's grounding on ("the existing UI... related screens, components, nav/interaction patterns") — the *how* is the research protocol's job, referenced in one line |
| 16 | Step 2: "Design a pragmatic UX that fits the conventions in the `product-design` skill... Offer 1–3 options to the invoker when a real tradeoff exists; otherwise a single recommended direction with the tradeoff named." | L27 | Agent doesn't know how many options to present, or omits naming the tradeoff | keep — agent-specific creative-process rule, no kernel or template equivalent |
| 17 | Step 3a: "structured per-behavior so the invoker can approve/correct each" | L28 | Agent dumps one undifferentiated UX blob instead of a per-behavior structure the invoker can approve/correct piecemeal | keep — **not** covered by `spec-template.md`'s own `## UX structure` comment (which lists Lives-in/Screens/Components/States fields but never says "structured per-behavior"); this is a real, non-duplicated instruction |
| 18 | Step 3b: "where it lives, screen/flow shape, design-system primitives, edge states" | L28 | Agent's deliverable omits a required field | now-in-template-spec-template — near-verbatim duplicate of `spec-template.md`'s own inline comment ("Designer altitude ONLY: where it lives, screen/flow shape, primitives, edge states."). Delete the restatement; point at "the spec template's own inline instructions" instead, per the `architect.md` precedent ("per the plan template's own inline instructions... don't restate its notes here") |
| 19 | Step 3c: "Designer altitude only — no hooks, no client calls, no file paths (wiring is the plan's FE Architecture's job)." | L28 | Agent scope-creeps into implementation (hooks/client calls/file paths) | now-in-template-spec-template — near-verbatim duplicate of `spec-template.md`'s comment ("No hooks, no client calls, no file paths — wiring is the plan's FE Architecture's job."), **and** duplicated a third time in `product-design-sample.md` ("Don't design data shapes, hooks, or wiring — that's the architect's job; stay at UX altitude."). Delete the agent-file restatement; the rule already lives in two other places the designer reads every time (spec template it fills, product-design skill it resolves) |
| 20 | Step 4a: "Stay in the conversation: the invoker may send follow-up messages to refine. Iterate on `## UX structure` until they're satisfied." | L29 | Agent one-shots the design instead of staying available for refinement | keep — agent-specific interaction pattern; not stated in kernel |
| 21 | Step 4b: "Reply per `vibe-team-communication-protocol` done-format — terse; the spec section is the deliverable." | L29 | Agent's final report doesn't reach the team-lead in the expected shape | keep — correct kernel-by-reference pattern (rule 6 compliant), **renamed** to `vibe-team-protocol` |
| 22 | Step 5: "You write **only** `spec.md`'s `## UX structure` section. Never write code, never edit other sections (Behaviors are the product-manager's; the HOW is the plan's), never edit source files." | L30 | Agent edits outside its lane — other spec sections, the plan, or source code | split: the core "only `## UX structure`" fact is now-in-kernel-team-protocol, verbatim in kernel's Role boundaries ("**Designers** write `## UX structure` only.", `team-protocol.md` L66) — drop the restatement; merge the rest (the concrete never-list: no code, no other sections, no source files, plus the PM/plan attribution) into a new `## Boundaries` section — the source has **no** Boundaries section at all, a standard rule 4 violation (canonical anatomy requires one even for small agents), and this content was misplaced mid-Workflow, a rule 5 violation (constraints belong only in description + Boundaries) |

## Row count and disposition counts

- Total rows: **22**
- `keep-verbatim`: **7** (#1, 3, 5, 7, 9, 11, 14)
- `keep` (plain, unchanged content): **5** (#12, 13, 16, 17, 20)
- `keep, renamed` (skill-name rename only, content unchanged): **3** (#6, 10, 21)
- `merge`: **5** (#2, #4, #8, #15, #22)
- `now-in-template-spec-template`: **2** (#18, #19)
- `delete`: **0** (no bare deletes — everything either keeps, merges, or has a named new home)

Two `merge` rows are split dispositions — part of the row's content moves out entirely, the remainder is what's merged into the rewrite's Workflow/Boundaries:
- #15 → the ladder mechanics half is `now-in-kernel-research-protocol`; the agent-specific input/grounding half is `merge`.
- #22 → the "only `## UX structure`" clause is `now-in-kernel-team-protocol` (verbatim in kernel's Role boundaries); the concrete never-list half is `merge` into the new `## Boundaries` section.

## Verbatim contracts to preserve (exact quotes, in the agent file)

- "**Project-supplied; resolve it by name.** If absent, propose from the existing UI alone and say so." (product-design skill row — the load-bearing fallback behavior).
- "Offer 1–3 options to the invoker when a real tradeoff exists; otherwise a single recommended direction with the tradeoff named."
- "structured per-behavior so the invoker can approve/correct each" (not covered by spec-template's own comment — must survive independently).
- "Stay in the conversation... Iterate on `## UX structure` until they're satisfied."
- "Does not write code." (description's `Does not…` clause — required by standard rule 2).

## Project-specific content requiring `{{PLACEHOLDER}}`

**None found.** The `product-design` skill is resolved *by name* at runtime from the consuming repo (not baked into this bundled template), and the spec-template path arrives via the dispatch brief, not at generation time. Same pattern as `engineer.md`/`reviewer.md`: nothing here is a per-project generation-time slot.

## Duplicates / contradictions

- **Skill-name mismatch (contradiction, must fix)**: source frontmatter + body reference `vibe-team-communication-protocol`; the kernel file is named `vibe-team-protocol` (`templates/kernel/team-protocol.md:2`). The old skill `skills/vibe-team-communication-protocol/SKILL.md` still exists on disk under its old name, but the kernel supersedes it — same rename already applied in `architect.md`, `engineer.md`, and the `reviewer.md` disposition. All three of this file's references (frontmatter L7, table L19, Workflow L29) need the rename.
- **Missing `## Boundaries` section (standard rule 4 violation)**: source has no Boundaries section; its boundary content is scattered across the description, the L13 intro paragraph, and Workflow step 5 — a standard rule 5 violation (constraints must live only in description + Boundaries, never mid-file). Three restatement sites collapse to two in the rewrite.
- **"No hooks/client calls/file paths" stated three times**: source `product-designer.md` L28, `spec-template.md`'s `## UX structure` inline comment, and `product-design-sample.md`'s "What the designer should NOT do" section all state this rule near-verbatim. The rewrite should state it zero times in the agent file itself and rely on the two template/skill copies (both of which the designer reads directly during its own workflow).
- **Research-protocol ladder restated at length** (source L26) instead of referenced in one line, per standard rule 6 — same class of defect the `reviewer.md`/`engineer.md` dispositions already flagged for their own Workflow step 1s.
- No conflicting *facts* found (unlike reviewer's binary-vs-graded verdict contradiction) — this file's kernel/template overlaps are all restatement-of-agreeing-content, not disagreement.

## Suggested ≤70-line skeleton (per agent-standard anatomy)

```
---
name: product-designer
description: <≤60 words. Keep: writes ONE feature's UX into spec.md's
  `## UX structure`, iterating with the invoker; resolves the project's
  own `product-design` skill at runtime (project-supplied). "Does not
  write code." clause required.>
model: opus
effort: high
color: pink
skills:
  - vibe-team-protocol
  - vibe-research-protocol
---
<!-- vibe-template: templates/agents/product-designer.md v1 | generated <date> | edits below this marker are yours -->

# product-designer

You design ONE feature's UX and write it into `spec.md`'s `## UX structure`,
iterating with the invoker until they're satisfied.

## Skills & documents you refer to

| Reference | Resolves to | Why |
|---|---|---|
| Team protocol | `vibe-team-protocol` skill | Done-report format, andon-cord escalation |
| Product design | `product-design` skill | The app's UX/UI conventions — design system, component library, layout/interaction patterns. Project-supplied; resolve by name. If absent, propose from the existing UI alone and say so |
| Research protocol | `vibe-research-protocol` skill | How to learn the UI without sweeping — research.md, then the ladder |
| Spec template | path in your brief (bundled with the plugin) | Exact shape of the `## UX structure` section — self-documenting; follow its inline instructions, don't restate them here |

## Workflow

1. Take the locked behaviors + `spec.md`/`research.md` paths from the invoker. Ground your design in the existing UI — related screens, components in use, nav/interaction patterns — per the research protocol.
2. Design a pragmatic UX fitting the `product-design` skill's conventions and the patterns found. Offer 1–3 options when a real tradeoff exists; otherwise one recommended direction with the tradeoff named.
3. Write it into `spec.md`'s `## UX structure`, structured per-behavior so the invoker can approve/correct each, per the spec template's own inline instructions.
4. Stay in the conversation; iterate on `## UX structure` until the invoker is satisfied.
5. Reply per the team protocol done-report format to `main` — terse; the spec section is the deliverable.

## Boundaries

- You write only `spec.md`'s `## UX structure` section — never code, never other spec sections, never source files.
- The spec template's inline instructions are the shape authority; don't invent a different shape.
- The `product-design` skill is the authority for conventions — project-supplied, not bundled with the vibe plugin. If absent, propose from the existing UI alone and say so.
```

Fits comfortably under 70 lines including frontmatter and the template-version header (~40 lines total).
