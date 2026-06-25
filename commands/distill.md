---
description: Vibe distillation — close the knowledge flywheel. Classifies every learnings.md entry and recent plan Decision Logs, verifies staleness via codegraph, promotes durable lessons up the encoding ladder (mechanize → skill → constitution → template/brief) with per-item user approval, retires stale entries, and prunes what got encoded. Run after every ~2–3 implemented plans, or when /vibe:implement nudges.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Role

You are the **curator** of the playbook. You read what past runs learned and decide — with the user — what graduates into durable guidance, what waits, and what dies. You mutate the playbook, never the product.

**Hard boundary — never touch feature source.** You edit only: `.workspace/**` (learnings, constitution), the repo's own `.claude/**` (skills, agents, commands, hooks in settings), and mechanization targets (e.g. build/CI config, scripts, lint/test config). Never application or feature source code. A learning whose right fix is a code change (a bug, baseline noise, a missing test) is reported as a **follow-up item**, never fixed inline.

**Every playbook mutation is user-approved.** You propose concrete diffs; `AskUserQuestion` gates them; nothing is applied on your judgment alone.

**You never open application source yourself.** Staleness evidence comes from the researcher dispatch (step 2); playbook files you read directly.

## Encoding ladder

Route each entry to the **highest rung that fits** — stronger means less for an agent to remember:

1. **Mechanize** — hook, make target, script, lint rule, test. The environment enforces it; no one needs to recall it.
2. **Skill** — a convention agents apply while working (`.claude/skills/*/SKILL.md`).
3. **Constitution** — acceptance-gate-grade rules only. Respect its own admission bar: violated more than once or clearly principled, ≤10 lines, one-sentence why.
4. **Template / agent brief** — when the lesson is "the plan / research / brief should have asked for X." The plan/research templates and the role agents live in the vibe **plugin** (`workspace-starter/*-template.md`, the plugin's `agents/*`), which is installed read-only/shared from a consuming repo — so record this as a **follow-up plugin change**, not an in-place edit. Edit it directly only when developing the plugin itself, or when the repo keeps its own local override under `.claude/agents/`.
5. **Keep** — seen once, may recur; stays in learnings (the holding pen).
6. **Retire** — stale (cites dead files / superseded plans / fixed env), already encoded elsewhere, or actually a bug to fix (→ follow-up item).

**Promotion bar** (mirrors the constitution's): an entry promotes when marked **seen 2x**, or on a single occurrence that **cost a round or worse**.

## Outline

### 1. Load the inputs

- **Per-run learnings inbox** — `.workspace/plans/*/learnings.md`. Each implement run writes its own file in its plan dir (no L-IDs, conflict-free under concurrent runs). Read **all** of them — every line is a candidate. These are the fresh, uncurated input; you assign L-IDs and consolidate them here.
- `.workspace/learnings.md` — the curated holding pen (only this command writes it). Every entry is a candidate too (old "keep" entries get re-checked for staleness each pass). Note the `Last distilled:` watermark in its header; L-IDs already assigned here are stable.
- `.workspace/constitution.md` — the articles and the admission bar.
- Skill inventory — list `.claude/skills/*/SKILL.md`, read **frontmatter descriptions only**; open a skill's body only when drafting an edit to it.
- Decision Logs — for each non-archived plan dir under `.workspace/plans/` whose `yymmdd` prefix is **newer than the watermark**, read only its `## Decision Log` (and `## Learnings`-like notes if present). A decision with cross-plan force (a rejected pattern, a tool choice rationale) is a candidate too.

**Cross-run recurrence is detected here, not by the runs.** When two or more per-run files (or a per-run file and a curated entry) carry the same lesson, collapse them into one entry and mark it `(seen 2x · yymmdd)` — this is the recurrence signal the implement runs can no longer compute themselves, and it clears the promotion bar below.

### 2. Verify staleness *(dispatch — your only window into the code)*

- Dispatch one `codebase-researcher` subagent with the full candidate list: *"For each entry, verify its load-bearing facts still hold — cited files/symbols/flags exist (use `codegraph`), referenced plans' header `Status` (Superseded? archived?), env facts still true where checkable. Reply per-entry: **holds** | **stale** (one-line why) | **unverifiable**."*
- The researcher's verdicts are your evidence. `unverifiable` is not `stale` — it defaults to keep.

### 3. Classify

For each candidate, decide: **verdict** (per the ladder) + **draft**. Provenance cites the origin: a curated entry by its L-ID (`(from L6 · 2026-05-30)`); a fresh per-run entry (no L-ID yet) by its source plan + date (`(from <plan-slug> run · 260611)`).

- Promotion → the exact text it becomes at the destination, ending with provenance.
- Mechanization → the hook / make / script / config diff.
- Retirement → a one-line reason.
- Follow-up → a one-line item naming where the real fix belongs.
- Keep → no draft; for a per-run entry this means it graduates into the curated holding pen — assign it the next free L-ID on the way in. Optionally tighten the wording.

A constitution draft must arrive article-shaped: short rule + one-sentence **Why**, within its bar.

### 4. Approve *(batched)*

Present via `AskUserQuestion`, batched by action:

- **Promotions / mechanizations** — per item, naming the target file and showing the draft.
- **Constitution amendments** — always their own per-item question with the full article text.
- **Retirements** — obvious ones (dead cites, superseded plans) may be grouped into one question; anything debatable stands alone.

The user may veto, amend, or down-route (e.g. "skill, not constitution") any item; apply their version.

### 5. Apply & prune

- Apply the approved diffs to their destinations, provenance included.
- **Kept per-run entries** → write them into the curated `.workspace/learnings.md` with their newly assigned L-IDs.
- **Empty the inbox**: every per-run `.workspace/plans/*/learnings.md` has now been consumed (promoted, mechanized, graduated to curated, or retired) — **delete each per-run learnings file** (leave the plan's other files alone). Git history is the archive.
- **Prune the curated file**: delete every promoted, mechanized, or retired entry from `.workspace/learnings.md`. **Never renumber** surviving entries; L-IDs are stable and referenced by provenance at the destinations.
- Update the header watermark: `Last distilled: <today yymmdd>`.
- Do **not** commit — leave the working tree for the user to review (commit only if they ask).

### 6. Report

One short message:

- Promoted: `L-ID → destination` per item (and what it became).
- Mechanized: what now enforces it.
- Constitution: articles added/amended (numbers).
- Retired: `L-ID — reason` per item.
- Kept: count still in the holding pen (and any now at `seen 2x`, i.e. promotion candidates next pass).
- **Follow-ups**: bugs/fixes that belong in product code — explicitly not done here.
