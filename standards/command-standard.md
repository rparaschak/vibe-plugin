---
name: command-standard
description: Quality bar for command/flow files the harness builder generates, the plugin's own commands, and audits of existing project commands. Every rule is mechanically checkable.
---

<!-- vibe-template: standards/command-standard v1 | generated 2026-07-13 | edits below this marker are yours -->

# Command Standard

Judged against by: author agents (write to it), reviewer agents (score against it), the builder's audit step. Prefer checks a reviewer runs mechanically (line counts, section presence, grep) over taste. Every hard rule traces to a nameable failure it prevents; if a rule can become a script/grep check, make it one — prose is the fallback.

## Hard rules (all checkable; violations are defects)

1. **Size budget.** Measured on the composed artifact (a generated/plugin-entry command, or a preset/flow FLOW block as it will be injected), never gamed by packing. Entry command files: 50–200 lines. Implementation-loop-shaped commands: ≤80 lines. Classification test: implementation-loop-shaped = its `## Outline` contains a repeat/until step over a work ledger; all others are entry commands. **No packing:** the budget assumes normal line discipline — one Outline step (or one numbered block's single action) per line. A line that bundles multiple sequential sub-steps — the "do X. Then do Y. Then Z." shape, chaining independent imperatives to keep the line count low — is a defect: break it into sub-bullets, even though that grows the count (honest accounting beats a gamed number). A single dense clause, even a long `·`-joined gate line, is not packing — the test is "how many distinct steps," not raw length. Detail beyond budget moves to referenced on-demand docs/skills, never inline. (Prevents: buried-rule blindness — a rule packed mid-line into an 878-char step, like a rule at line 300, is ignored ~40% of the time.)
2. **Constraints at top.** Hard constraints (MUST/never rules) live in the file's top section, above the midpoint; optionally restated in a one-line footer. Any hard rule below the file midpoint is a defect. (Prevents: mid-file constraint burial — see the 174-line command hiding "Context discipline" at line 35.)
3. **Template-version header.** Every generated file's first non-frontmatter line is:
   `<!-- vibe-template: <template-path> v<N> | generated <date> | edits below this marker are yours -->`
   Enables re-stamp/upgrade diffs: unmodified stamped sections diff against newer template versions; user-modified sections are surfaced, never overwritten. (Prevents: silent overwrite of user edits on re-stamp; undiffable drift.)
4. **No runtime branching.** Zero conditional branches for project shapes ("if the project has a spec…", "--worktree mode optional…"). Shape decisions are made once at generation time; emit only the branch taken. A command needing a mode = generate two commands. (Prevents: dead-branch mistakes — every unused branch is a path an LLM can wrongly take. Linearity = predictability.)
5. **Kernel by reference.** Reference the project's kernel skills (task ledger, research protocol, team protocol, review protocol) by name. Restating their content inline is a defect. One rule = one home. (Prevents: drift — the boundary rule currently exists in 4 phrasings across 4 files.)
6. **Canonical section order.** frontmatter (`description` required, ≤80 words) → template header → `## User Input` (includes, verbatim: `You **MUST** consider the user input before proceeding (if not empty).`) → `## Role` (one paragraph: who the team-lead is + the hard boundary lines) → optional flow-specific sections → `## Outline` (final step per rule 9). (Codifies existing convention: 7/7 commands use User Input→Role→…→Outline. Prevents: structural drift across generated commands.)
7. **Canonical code-touch boundary.** Use this sentence verbatim, filling the artifact list:
   `**Hard boundary:** this command never edits project source; \`Edit\`/\`Write\` are used only for <named artifacts>.`
   No paraphrases ("Hard boundaries.", "Mutation surface (narrow).", "Same boundaries as the phases you run"). (Prevents: boundary phrasing drift — the rule existed in 4 phrasings across 4 files.)
8. **Embedded-template policy.** Formats ≤10 lines (e.g. a report shape) may be inlined. Anything longer lives as a separate template file referenced by path. (Prevents: bloated entry files that bury constraints.)
9. **Outline linearity.** `## Outline` steps are numbered and linear — no nested conditionals, no "if…" steps (follows from rule 4). Final step name is exactly `Finalize` for commands that mutate a state artifact, `Report` otherwise. (Codifies: 5/7 commands end Finalize, 2/7 Report.)

## Review checklist (the audit step runs these)

- [ ] Line count within budget (50–200; ≤80 if implementation-loop-shaped) — and no packed lines dodging it (no numbered step/block line chaining multiple sequential sub-steps — the "do X. Then Y. Then Z." shape belongs in sub-bullets).
- [ ] All hard constraints in the top section, above the file midpoint.
- [ ] Zero runtime branches for project shape (grep for "if the project", "optional", "--" mode splits).
- [ ] Kernel skills referenced by name, not restated inline.
- [ ] Canonical boundary sentence present verbatim (rule 7 pattern).
- [ ] Template header present as first non-frontmatter line (generated files).
- [ ] Section order matches rule 6; `## Outline` linear and ends `Finalize` or `Report`.
- [ ] Frontmatter has `description` (≤80 words); embedded templates ≤10 lines else referenced by path.

<!-- Footer constraint: constraints at top, ≤200 lines, linear outline, boundary phrasing verbatim, kernel by reference. -->
