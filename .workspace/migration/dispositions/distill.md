# Disposition — commands/distill.md rewrite (4.3)

Scout: sonnet, 2026-07-14. Sources: docs/harness-improvement-plan.md, docs/migration-plan.md, docs/harness-builder.md, v1 commands/distill.md, templates/**, presets/**, standards/**.
Contradictions 1–3 below ADJUDICATED by orchestrator as D11–D13 (see ledger Decision Log) — author follows the adjudications, not the open questions.

## Course practices (L10/L12 + neighbors) — verbatim extracts with doc:line cites

- `docs/harness-improvement-plan.md:27` — "`/vibe:distill` mechanize→skill→constitution ladder | Lecture 10/12 (\"review-feedback promotion,\" OpenAI golden rules) prescribe exactly this. Ours predates reading theirs — good sign."
- `docs/harness-improvement-plan.md:83-84` (P6, Lectures 10, 12) — "`/vibe:distill`'s \"mechanize\" rung gets teeth: recurring review findings should preferentially become **executable checks** (grep/lint scripts, e.g. architecture-boundary checks) that the reviewer runs *before* prose review... Add a **harness self-check**... loop over required artifacts/skills... report OK/MISSING per item, and run the \"fresh session test\"."
- `docs/harness-improvement-plan.md:64` (P4, Lectures 10, 11) — "Give the reviewer a structured verdict format: score 0–2 on ~6 fixed dimensions... → verdict `Accept / Revise / Block` → required follow-ups. Every finding must be three-part: **what** (file:line), **why** (rationale), **fix** (concrete correction)."
- `docs/harness-improvement-plan.md:92` (P7, Lecture 4) — "each rule annotated mentally with *source / applicability / expiry*. Add a **Simplification Log**... when a constraint exists only to compensate for a weaker model, periodically disable it and observe — if quality holds, delete it and log the removal."
- `docs/migration-plan.md:70` (Step 1, Lecture 4's rule metadata) — "An instruction with no nameable failure it prevents is **deleted by default** — the burden of proof is on the instruction, not on the deleter."
- `docs/migration-plan.md:200-213` traceability table, exact rows:
  - "Review rubric 0–2 × 6 dims → Accept/Revise/Block; what/why/fix findings | L10, L11; P4 | Phase 1 `kernel/review-protocol.md`"
  - "Mechanized checks before prose review; harness doctor; fresh-session test | L10, L12; P6 | Phase 2 reviewer template; Phase 4 doctor mode"
  - "Decision log + session handoff (kills re-litigation on resume) | L5; P5 | Phase 1 ledger sections; skeleton clock-in/out"
  - "Rule metadata (source / applicability / expiry); delete-by-default | L4 | §2 execution protocol, Step 1"
  - "Simplification log (delete constraints models outgrow) | L4/L12; P7"
- `docs/harness-improvement-plan.md:34` (P1) — promotion bar analog: closed-enum evidence gating ("Only the **team-lead** flips `active → passing`... engineer never marks its own work passing").
- `templates/kernel/task-ledger.md:22` — "`passing` is irreversible except by an explicit orchestrator/user decision recorded in the decision log" (same discipline distill's own L-ID/state pruning should mirror).

## v1 distill.md disposition table

| v1 element (quote) | KEEP/MERGE/DELETE | rationale + L-cite |
|---|---|---|
| "Route each entry to the **highest rung that fits**... 1. Mechanize 2. Skill 3. Constitution 4. Template/agent brief 5. Keep 6. Retire" (distill.md:23-33) | KEEP the ladder shape | Directly matches L10/L12 ladder (harness-improvement-plan.md:27); this is v1's strongest alignment. |
| Rung 4 text: "the spec/plan/research templates and the role agents live in the vibe **plugin** (`workspace-starter/*-template.md`...) which is installed read-only... record this as a **follow-up plugin change**, not an in-place edit" (distill.md:30) | MERGE (stale paths + wrong shape) | `workspace-starter/` no longer exists — moved to `templates/workspace/` (migration-plan.md:25); templates now also live at `templates/agents/*.md`, `templates/kernel/*.md`, `presets/*/*.md`. D4 requires this rung emit a **proposed diff against `templates/`**, not a passive "follow-up item" (migration-plan.md:167, harness-builder.md:107,140). See D11. |
| "**Promotion bar** (mirrors the constitution's): an entry promotes when marked **seen 2x**, or on a single occurrence that **cost a round or worse**." (distill.md:34) | KEEP verbatim | No direct L-cite but structurally mirrors L7/L13 numeric-threshold discipline; do not lose this exact wording. |
| Constitution draft rule: "A constitution draft must arrive article-shaped: short rule + one-sentence **Why**, within its bar." (distill.md:63) | MERGE | Right idea (terse, gated) but missing L4's rule metadata: "source / applicability / expiry" (migration-plan.md:213) — course-conformant shape adds those three tags to every promoted rule draft. See D12. |
| "**Hard boundary — never touch feature source.**" + edit scope list (distill.md:17) | KEEP verbatim | Matches role-separation discipline (Lecture 4/5 context cleanliness, Lecture 9 self-approval ban); load-bearing, quote exactly (see contracts below). |
| "You never open application source yourself. Staleness evidence comes from the researcher dispatch (step 2)." (distill.md:21, and step 2 lines 48-51) | KEEP | Matches L4/L5 context-budget discipline and the kernel's `codebase-researcher` dispatch pattern (agents/codebase-researcher.md:22). |
| Step 2 dispatch: "verify its load-bearing facts still hold... use `codegraph`... Reply per-entry: **holds** \| **stale**... \| **unverifiable**." "`unverifiable` is not `stale` — it defaults to keep." (distill.md:50-51) | KEEP verbatim | Sound delete-by-default-with-evidence discipline; matches L4's burden-of-proof framing (migration-plan.md:70) but correctly inverts default toward keep absent evidence. |
| Step 4 Approve: "**Every playbook mutation is user-approved.** You propose concrete diffs; `AskUserQuestion` gates them; nothing is applied on your judgment alone." (distill.md:19, 65-73) | KEEP verbatim | Matches P4's caution that evaluators "talk themselves into dismissing issues" — human is final arbiter. |
| Step 5 Apply & prune: "**Never renumber** surviving entries; L-IDs are stable..." / "delete each per-run learnings file... Git history is the archive." / "Do **not** commit — leave the working tree for the user to review" (distill.md:76-82) | KEEP verbatim | Hard-won invariants; no course contradiction, high accidental-loss risk if rewritten loosely. |
| Mechanization draft: "the hook / make / script / config diff" (distill.md:58) | KEEP, MERGE emphasis | Aligns with P6/L10,L12 "mechanized checks before prose review" (harness-improvement-plan.md:83) — cross-reference that the reviewer runs mechanized checks *before* prose (reviewer template's job per migration-plan.md:207); a cross-reference, not new logic. |
| Frontmatter: "Run after every ~2–3 implemented plans, or when /vibe:implement nudges." (distill.md:2) | KEEP | Cadence guidance untouched by the course material; no conflict found. |
| No explicit "delete-by-default / burden of proof" statement anywhere in v1 | MERGE (gap) | L4 (migration-plan.md:70) names this explicitly; v1's Retire rung implies it but never states the burden-of-proof framing — course-conformant shape states it. |
| No promotion-rung → `templates/` diff mechanism anywhere in v1 | MERGE/ADD (the central rewrite) | The entire D4 ask — absent from v1 entirely. Mechanism adjudicated in D11. |

## Verbatim contracts an author must not lose

- `distill.md:17` — "**Hard boundary — never touch feature source.** You edit only: `.workspace/**` (learnings, constitution), the repo's own `.claude/**` (skills, agents, commands, hooks in settings), and mechanization targets (e.g. build/CI config, scripts, lint/test config). Never application or feature source code. A learning whose right fix is a code change (a bug, baseline noise, a missing test) is reported as a **follow-up item**, never fixed inline."
- `distill.md:34` — "**Promotion bar** (mirrors the constitution's): an entry promotes when marked **seen 2x**, or on a single occurrence that **cost a round or worse**."
- `distill.md:46` — "**Cross-run recurrence is detected here, not by the runs.**"
- `distill.md:51` — "`unverifiable` is not `stale` — it defaults to keep."
- `distill.md:80` — "**Never renumber** surviving entries; L-IDs are stable and referenced by provenance at the destinations."
- `distill.md:82` — "Do **not** commit — leave the working tree for the user to review (commit only if they ask)."

## Learnings input map — where learnings/decision-logs accumulate in generated projects

- `presets/plan-implement/implement.md:44-45` and `presets/spec-plan-implement/implement.md:44-45` — "## Learnings — At finalize, append dated lines to this run's `.workspace/plans/<yymmdd-slug>/learnings.md` (create if absent) — distinct from the curated `.workspace/learnings.md`, which only `/vibe:distill` writes."
- `presets/plan-implement/plan.md:34` and `presets/spec-plan-implement/plan.md:35` — "Planning learnings, if any, land in the plan's Decision Log — no separate learnings file this phase."
- `templates/kernel/task-ledger.md:46-50` — "## Decision log (append-only table in the plan) | date | decision | reasoning | rejected alternatives | ... Write a row when deviating from the plan or resolving an ambiguity."
- `templates/workspace/plan-template.md:162-164` — "## Decision Log *(optional — non-obvious choices not already captured in Architecture)* — **D-001** — [decision] · [driver] · [alternative rejected]."
- `agents/codebase-researcher.md:22` and `templates/agents/codebase-researcher.md:29` — both curated `.workspace/learnings.md` (cite L-id) and per-run `.workspace/plans/*/learnings.md` (cite plan slug) are read as research input, matching distill's own input list.

## Promotion-rung target inventory — templates/ and standards/

```
templates/
├── agents/        architect.md, codebase-researcher.md, critic.md, engineer.md,
│                   product-designer.md, product-manager.md, qa-engineer.md,
│                   reviewer.md, test-engineer.md
├── checklists/     review-backend.md, review-frontend.md, review-generic.md
├── kernel/         research-protocol.md, review-protocol.md, task-ledger.md, team-protocol.md
├── scripts/        env-up.sh.template, test-run.sh.template
├── skeletons/      command-skeleton.md, flow-skeleton.md
└── workspace/      architecture-sample.md, architecture-skill.md, backend-testing-sample.md,
                     constitution-sample.md, environment-sample.md, environment-skill.md,
                     plan-template.md, product-design-sample.md, research-template.md,
                     review-checklist-sample.md, spec-template.md

standards/          agent-standard.md, command-standard.md, composition-standard.md
presets/            plan-implement/{implement.md, plan.md}, spec-plan-implement/{implement.md, plan.md, spec.md}
```
Every file under `templates/` and `presets/` carries a version header (`migration-plan.md:56-58`): `<!-- vibe-template: kernel/task-ledger v1 | generated 2026-07-13 | edits below the marker are yours -->` — a kernel-grade promotion diff targets one of these files and respects that header/marker convention.

## Design-doc requirements for distill (verbatim, with cites)

- `docs/harness-builder.md:107` (§6 table) — "`/vibe:distill` | **Keep + extend one rung** | Project learnings stay local; kernel-grade learnings get promoted back into plugin templates (otherwise best lessons stay stranded in one repo)"
- `docs/harness-builder.md:140` (§8) — "Distill's promotion rung (§6) is the reverse channel: kernel-grade learnings flow back to templates."
- `docs/migration-plan.md:167` (Phase 4 checklist) — "**`commands/distill.md`** — add the promotion rung: when a distilled learning is kernel-grade (would apply to any project), emit a proposed diff against the plugin's `templates/` instead of only writing project-local skills."
- `docs/migration-plan.md:18` (Decision 5) — "**Plugin-resident at runtime:** only `/vibe:build-harness`, `/vibe:build-flow`, `/vibe:distill`. Everything else executes from the project's own `.claude/`."
- `docs/harness-builder.md:36` (repo layout) — `commands: /vibe:build-harness, /vibe:build-flow, /vibe:distill` — distill stays a plugin-level command, not a generated preset artifact.

## Contradictions — ADJUDICATED (see ledger D11–D13)

1. **Cross-repo delivery mechanism** → **D11**: distill emits a ready-to-apply proposal-diff ARTIFACT in the consuming project (e.g. under `.workspace/`); it reads current template content via the `$CLAUDE_PLUGIN_ROOT` resolution mechanism (as build-flow.md:26 does) to author an accurate diff, but NEVER writes into the plugin install (read-only). The user applies the diff to the plugin repo. Rejected: in-place plugin edit (read-only install); sibling-checkout requirement (unenforceable assumption); v1's passive "follow-up item" note (the exact behavior D4 replaces).
2. **Constitution rung vs L4 rule metadata** → **D12**: distill's drafting instruction includes source / applicability / expiry inline in every promoted rule draft (constitution articles AND skill rules); the constitution template's own schema (Phase 2, passed) is NOT reopened.
3. **"Kernel-grade" test undefined** → **D13**: kernel-grade iff (a) the corrected rule names no project-specific noun (path, domain term, stack detail beyond what the template parameterizes) AND (b) its natural home file is one build-harness stamps verbatim into any project (fixed template/kernel/skeleton/agent/standard text, not a Fill/Discover slot) — i.e. the same defect would reproduce in a fresh build on a different repo. The normal promotion bar (seen 2×, or cost a round) applies on top.
