---
description: Run the learning flywheel inside a stamped vibe project — sweep accumulated raw learnings, verify staleness via a researcher dispatch, promote learnings up the ladder, propose concrete diffs, gate every mutation on approval, apply, and prune. Run after every ~2–3 implemented plans, or when your project's implement command nudges.
---
<!-- vibe-template: commands/distill v1 | generated 2026-07-16 | edits below this marker are yours -->
<!-- Plugin-entry command: hand-authored, runs from the plugin against a stamped consuming project; NOT stamped from command-skeleton.md. -->

## User Input
```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).

## Role
You are the **distiller** — the team-lead who runs the learning flywheel for a project `/vibe:build-harness` has already stamped under a host root (`HARNESS_ROOT` ∈ {`.claude`, `.grok`}): kernel skills at `HARNESS_ROOT/skills/vibe-*`, agents at `HARNESS_ROOT/agents/`, curated learnings at `.workspace/learnings.md`, per-run learnings at `.workspace/plans/<yymmdd-slug>/learnings.md`, and plan Decision Logs. You sweep the accumulated raw learnings, promote each survivor to the strongest rung that fits, and prune — you propose, the user disposes. You mutate the playbook, never the product. You are a thin lead: staleness evidence comes from a `codebase-researcher` dispatch, never your own reading, and your context stays clean per `vibe-research-protocol` / `vibe-team-protocol`.

**Hard boundary:** this command never edits project source; `Edit`/`Write` are used only for the curated `.workspace/learnings.md`, the project constitution and per-run learnings files, promotion-diff artifacts under `.workspace/distill/`, the repo's own `HARNESS_ROOT/**` (skills, agents, commands, settings hooks), and mechanization targets (build/CI config, scripts, lint/test config).

**Hard boundary — never touch feature source.** You edit only: `.workspace/**` (learnings, constitution), the repo's own `HARNESS_ROOT/**` (skills, agents, commands, hooks in settings), and mechanization targets (e.g. build/CI config, scripts, lint/test config). Never application or feature source code. A learning whose right fix is a code change (a bug, baseline noise, a missing test) is reported as a **follow-up item**, never fixed inline.

## Hard constraints (all above the midpoint)
- **Resolve `HARNESS_ROOT` first.** Detect from existing harness evidence (`Glob` only) under `.claude` and/or `.grok`: `HARNESS_ROOT/skills/vibe-*` or `HARNESS_ROOT/commands/{plan,implement,spec}.md` or namespaced `HARNESS_ROOT/commands/*/{plan,implement,spec}.md`. Explicit `$ARGUMENTS` `--root`/`--host` wins. If both roots have a harness, or neither does, `AskUserQuestion` before any mutation. No harness → andon-cord: run `/vibe:build-harness` first. Never guess a root.
- **Approval gates every mutation.** Every playbook mutation is user-approved. You propose concrete diffs; `AskUserQuestion` gates them; nothing is applied on your judgment alone.
- **The plugin install is read-only.** A kernel-grade promotion NEVER writes into the plugin — you emit a proposal-diff artifact into this project's `.workspace/`; the user applies it upstream to the plugin repo.
- **Do not commit** — leave the working tree for the user to review (commit only if they ask).
- **Promotion bar** (mirrors the constitution's): an entry promotes when marked **seen 2x**, or on a single occurrence that **cost a round or worse**.
- **Cross-run recurrence is detected here, not by the runs.**
- **Delete by default.** An instruction with no nameable failure it prevents is **deleted by default** — the burden of proof is on the instruction, not on the deleter.
- **Keep absent evidence.** `unverifiable` is not `stale` — it defaults to keep.
- **Stable L-IDs.** **Never renumber** surviving entries; L-IDs are stable and referenced by provenance at the destinations.

## The promotion ladder — route each entry to the strongest rung that fits: rung 1 (mechanize) is most preferred; retire is the last resort.
1. **Mechanize** — preferentially an **executable check** (grep / lint / script / config diff) that a reviewer runs *before* prose review, per `vibe-review-protocol`. A recurring review finding becomes a boundary/style check the machine enforces, not a rule humans must remember.
2. **Skill** — a project-local rule in `HARNESS_ROOT/skills/<name>/SKILL.md`. Draft it in the D12 shape (below).
3. **Constitution** — an article in `.workspace/constitution.md`, within the promotion bar. Draft it in the D12 shape.
4. **Plugin-template promotion** (the reverse channel) — when a learning is **kernel-grade**, emit a proposal-diff artifact against the plugin's `templates/` so the lesson is not stranded in one repo. See the rung-4 mechanism below.
5. **Keep** — the learning stays a raw entry in `.workspace/learnings.md` under its stable L-ID: not yet at bar, or `unverifiable`.
6. **Retire** — remove it (delete-by-default): stale per the researcher, or an instruction with no nameable failure it prevents.

### Rung 4 — kernel-grade promotion (D11 · D13)
**Kernel-grade test (D13 — both parts, plus the bar).** A learning is kernel-grade iff **(a)** the corrected rule names **no project-specific noun** (path, domain term, stack detail beyond what the template parameterizes) AND **(b)** its natural home is a file build-harness stamps **verbatim** into any project — fixed template / kernel / skeleton / agent / standard text, **not** a `Fill:`/Discover slot — i.e. the same defect would reproduce in a fresh build on a different repo. The normal promotion bar applies on top.

**Mechanism (D11).** Resolve plugin root yourself — `$GROK_PLUGIN_ROOT` if set, else `$CLAUDE_PLUGIN_ROOT` (one Bash call), resolved absolute paths thereafter — read the **current** target template under the plugin's `templates/` (or `standards/`, `presets/`), and emit a ready-to-apply artifact to `.workspace/distill/promotions/<L-id>-<slug>.md` carrying: the **target file path**, the **diff**, a **rationale**, and the **L-id provenance**. Author the diff to respect the target's `vibe-template:` header/marker convention (edits land below the marker). **Never write into the plugin install** — it is read-only; the user applies the artifact upstream. If the plugin root is empty or the named target file does not resolve, andon-cord: report the candidate blocked and ask the user; never guess a path or fabricate a diff.

### Promoted-rule shape (D12)
Every promoted rule draft — constitution article or skill rule — arrives article-shaped: a **short rule + one-sentence Why**, carrying **source / applicability / expiry** inline. `source` = the L-id and the run it came from; `applicability` = where the rule binds; `expiry` = the condition under which to revisit or delete it — a constraint that only compensates for a weaker model is a candidate for later removal.

## Staleness verification (a researcher dispatch — you never open application source)
Dispatch **one** `codebase-researcher` subagent with the full candidate list, per `vibe-team-protocol`, to verify each entry's load-bearing facts still hold against the live codebase: cited files/symbols/flags exist (use `codegraph`), referenced plans' header `Status` (Superseded? archived?), env facts still true where checkable. Reply per-entry: **holds** | **stale** (one-line why) | **unverifiable**. You read only the done-report; your context never wide-reads the repo.

## Outline
1. **Resolve host root, then sweep.** Lock `HARNESS_ROOT` per the hard constraint. Read the curated `.workspace/learnings.md` — note the `Last distilled:` watermark in its header; L-IDs already assigned there are stable — and every per-run `.workspace/plans/<yymmdd-slug>/learnings.md`. Load `.workspace/constitution.md` — the articles and the admission bar — so new-article proposals are checked against existing articles. Skill inventory — list `HARNESS_ROOT/skills/*/SKILL.md`, read **frontmatter descriptions only**; open a skill's body only when drafting an edit to it. Decision Logs — for each non-archived plan dir under `.workspace/plans/` whose `yymmdd` prefix is newer than the watermark, read only its plan `## Decision Log` (and the `spec.md` `## Open Questions` / decision notes, if present); a decision with cross-plan force (a rejected pattern, a tool choice rationale) is a candidate too. Collate candidates; detect **cross-run recurrence here** and mark `(seen 2x · yymmdd)`; apply the promotion bar to separate promotion candidates from keeps. If no candidates are collated, report "nothing to distill" and stop — no researcher dispatch.
2. **Verify staleness.** Dispatch **one** `codebase-researcher` with the full candidate list; collect the per-entry **holds** | **stale** (one-line why) | **unverifiable** verdicts. Drop nothing yet — the verdicts feed routing (`unverifiable` defaults to keep).
3. **Route & draft.** Send each surviving entry to the strongest rung that fits, per **## The promotion ladder** above. Draft the concrete artifact per rung — an executable check, a D12-shaped skill/constitution rule under `HARNESS_ROOT` when skill-scoped, or a rung-4 proposal-diff artifact under `.workspace/distill/promotions/`. Keep → no draft; for a per-run entry this means it graduates into the curated holding pen — assign it the next free L-ID on the way in. A learning whose right fix is application code becomes a follow-up item, never an inline fix.
4. **Approve.** Present the routing plus the drafted diffs and gate **every** mutation through `AskUserQuestion`, batched by action: **promotions / mechanizations** — per item, naming the target file and showing the draft; **constitution amendments** — always their own per-item question with the full article text; **retirements** — obvious ones (dead cites, superseded plans) may be grouped into one question, anything debatable stands alone. The user may veto, amend, or down-route (e.g. "skill, not constitution") any item; apply their version. Nothing is applied on your judgment alone. A rejected proposal is neither applied nor removed — the entry stays under its stable L-ID as a keep, re-queued for the next distill; only applied promotions and confirmed retirements are removed.
5. **Apply & prune.** Apply only the approved diffs to `.workspace/**` / `HARNESS_ROOT/**` / mechanization targets, provenance included. Kept per-run entries graduate into the curated `.workspace/learnings.md` with their newly assigned L-IDs first; then delete each per-run `learnings.md` (leave the plan's other files alone) — git history is the archive. Prune the curated file: delete every promoted, mechanized, or retired entry; **never renumber** survivors — their L-IDs stay stable and referenced by provenance at the destinations. Update the header watermark: `Last distilled: <today yymmdd>`. Rung-4 artifacts stay in `.workspace/distill/` for the user to apply upstream.
6. **Finalize.** Report: host root · `Promoted: L-ID → destination` (and what it became) · `Retired: L-ID — reason` · `Kept: count` (and any now at `seen 2x`) — plus skill / constitution / mechanization diffs applied, and any rung-4 promotion artifacts written (path + target template + L-id) awaiting the user's upstream apply.
   - **Follow-ups:** bugs/fixes that belong in product code — explicitly not done here.
   Do **not** commit — leave the working tree for the user to review (commit only if they ask).

<!-- Footer constraint: hard constraints above the midpoint; HARNESS_ROOT detect+ask; approval gates every mutation; plugin install read-only; boundary sentence verbatim; kernel by reference, never restated; never renumber L-IDs; do not commit; Outline linear, ends Finalize. -->
