# Disposition: agents/critic.md + skills/vibe-critique/SKILL.md → (rewritten) agents/critic.md

Scout output (sonnet, 2026-07-13). CR = agents/critic.md (20 lines); VC = skills/vibe-critique/SKILL.md (72 lines). The author of the rewritten critic.md works from THIS file, not the sources. Cross-checked against `standards/agent-standard.md` and kernel files `templates/kernel/team-protocol.md`, `templates/kernel/research-protocol.md`, `templates/kernel/review-protocol.md`.

## Known-mandate check: the "stance paragraph"

CR:15 (the whole first body paragraph) is confirmed to be the paragraph `agent-standard.md` rule 6 names verbatim as the example failure ("a critic agent restated its skill's stance near-verbatim"). Sentence-by-sentence:

- "You attack a draft before anyone builds on it, and report what you find." → near-verbatim echo of VC:8.
- "Read-only: you find weaknesses; the team-lead reconciles them with the user and the authoring agent." → near-verbatim echo of VC:8 and of team-protocol's role-boundary line.
- "You decide neither what to attack nor through which lenses — your dispatch brief names both: the artifact … and the lens-set …" → this LOOKS like teeth (a real operational constraint), but it is already stated twice elsewhere: in CR's own frontmatter `description` (CR:3) and in VC:10-13 ("Your brief names the mode…"). No unique teeth survive extraction — the constraint's canonical homes (description + VC) already cover it.
- "You run at the cheapest moment to cut a mistake — before anyone builds on the draft." → near-verbatim echo of VC:8.

**Verdict: confirmed delete-candidate, no nameable failure beyond what VC:8 and VC:10-13 already prevent.** No teeth needed extraction as new rows — the one candidate tooth (dispatch-brief-decides-scope) already has two canonical homes.

## Disposition table

| # | Instruction (key terms/formats verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: critic` | CR:2 | Dispatch table lookup miss | keep-verbatim |
| 2 | `description:` full text — dispatch-generic mechanism ("the brief names the artifact… and the lens-set…") + "Read-only; reports ranked findings, never edits." | CR:3 | Orchestrator can't route/scope a critique dispatch; unclear it never edits | keep (content); **revise wording** — ~59 words (under the 60 budget but tight) and the boundary clause is implicit ("never edits") not the literal `Does not …` shape rule 2 wants for grep-checking — rewrite the tail as an explicit `Does not …` clause |
| 3 | `model: opus` | CR:4 | Under-specified dispatch budget | keep-verbatim |
| 4 | `effort: xhigh` | CR:5 | Under-specified dispatch budget | keep-verbatim |
| 5 | `color: red` | CR:6 | UI mis-grouping | keep-verbatim |
| 6 | `skills: vibe-team-communication-protocol` | CR:8 | Wrong/stale protocol pointer | keep, **rename** → `vibe-team-protocol` (kernel consolidated communication-protocol + orchestration under this name; see `templates/kernel/team-protocol.md` frontmatter) |
| 7 | `skills: vibe-research-protocol` | CR:9 | Wrong/stale protocol pointer | keep-verbatim (name unchanged; now kernel-backed at `templates/kernel/research-protocol.md`, identical content) |
| 8 | `skills: vibe-critique` | CR:10 | Wrong/stale domain-skill pointer | keep-verbatim |
| 9 | "You attack a draft before anyone builds on it, and report what you find." | CR:15 | none beyond VC:8 | now-in-skill-vibe-critique — delete from agent file |
| 10 | "Read-only: you find weaknesses; the team-lead reconciles them with the user and the authoring agent." | CR:15 | none beyond VC:8 / team-protocol role-boundaries | now-in-skill-vibe-critique — delete from agent file |
| 11 | "You decide neither what to attack nor through which lenses — your dispatch brief names both…" | CR:15 | none beyond frontmatter description + VC:10-13 | merge — redundant with description (CR:3) and VC:10-13; delete this copy |
| 12 | "You run at the cheapest moment to cut a mistake — before anyone builds on the draft." | CR:15 | none beyond VC:8 | now-in-skill-vibe-critique — delete from agent file |
| 13 | "Follow `vibe-critique` for the stance, the lens-set your brief names, what counts as a finding, and the exact reply format." | CR:17 | Agent restating the skill's content instead of pointing at it (this is the CORRECT rule-6 pattern — keep it as the model line, move into the Skills table) | keep-verbatim |
| 14 | "Critique against what the team-lead hands you and the original request." | CR:17 | Critic evaluates the draft only for internal consistency and misses drift from what the user actually asked for — not stated anywhere in VC | keep (unique, no duplicate found) |
| 15 | "Read the grounding files the brief names (a feature's `research.md`, a plan's `## Current State`) to anchor findings in what the app actually does today" | CR:17 | none beyond research-protocol rung 1 — restates it inline despite `vibe-research-protocol` already being a referenced skill (rule 6 violation) | now-in-kernel-research-protocol — delete inline restatement, reference only |
| 16 | "explore read-only only to confirm a specific detail" | CR:17 | none beyond research-protocol's ladder-stop rule + VC:18's read-only tool list | now-in-kernel-research-protocol (+ overlaps VC:18) — delete inline |
| 17 | "Your job is the gap nobody noticed, not agreement." | CR:19 | none beyond VC:17 (near-verbatim) | now-in-skill-vibe-critique — delete from agent file |
| 18 | "A draft you can't fault is rare — look harder before replying 'no findings'." | CR:19 | Rubber-stamped "no findings" from a shallow pass — a real, distinct failure mode not stated anywhere in VC (VC's Clean-reply gate only says "only when you genuinely cannot find an impacting weakness", no "look harder" push) | merge — recommend folding into VC's Clean-reply section (VC:64-68) so all reply-format rules live in one place; keep the wording verbatim wherever it lands |
| 19 | "Cosmetic and wording issues are out of scope; the team-lead's gate owns those." | CR:19 | none beyond VC:21 / VC:49 (this is the rule's 3rd occurrence across the two files) | now-in-skill-vibe-critique — delete from agent file |
| 20 | VC frontmatter `name`/`description` (skill-trigger contract: "Use whenever acting as the `critic` in /vibe:spec (product brief) or /vibe:plan (architecture brief)") | VC:1-4 | Skill fails to auto-load for the right agent/phase | keep-verbatim |
| 21 | "You are the critic. Some agent produced a draft; your job is to attack it before anyone builds on it — not to polish wording. You run at the cheapest possible moment to cut a mistake. You find weaknesses and report them; the team-lead reconciles them with the user and the authoring agent." | VC:8 | Loss of role framing if deleted here too | keep — this is the CANONICAL home for the stance content CR:15 duplicated |
| 22 | "Your brief names the mode" — Product brief → Behaviors (+Problem/OOS/Assumptions), Product lenses, runs before UX/architecture exist; Architecture brief → Architecture+Data model+Tasks+Test behaviors vs locked behaviors, Architecture lenses, runs before `/vibe:implement` | VC:10-13 | Critic doesn't know which artifact/lens-set applies to which phase | keep-verbatim (load-bearing dispatch contract) |
| 23 | "Adversarial. Assume the draft is plausible but wrong somewhere. Your value is the gap nobody noticed, not agreement." | VC:17 | Agreeable/soft critique that misses real gaps | keep — canonical (CR:19's duplicate deleted) |
| 24 | "Read-only. You never edit the artifact. Use `Read`, `Grep`, `Glob`, `codegraph`, and read-only exploration to ground a finding. Findings only." | VC:18 | Critic edits the draft instead of reporting | keep-verbatim — canonical tool-scope; note this list has NO Bash, unlike `review-protocol.md`'s read-only stance which allows read-only Bash for `git diff`/test commands — don't collapse the two, critic doesn't run tests |
| 25 | "Concrete, not abstract." + examples ("B-002 has no clear user" beats "…could be more user-centric"; "T-003 delivers nothing for B-005" beats "coverage could be tighter") | VC:19 | Vague, unactionable findings | keep-verbatim (calibration exemplars — paraphrasing loses the bar they set) |
| 26 | "No praise, no recap, no hedging. If something is fine, say nothing about it." | VC:20 | Noise burying real findings | keep |
| 27 | "Cosmetic/wording/naming issues are out of scope — the team-lead's gate owns those." | VC:21 | Critic duplicates the team-lead's wording-gate job | keep — canonical (intra-skill dup at VC:49 collapses into this one; CR:19's dup also collapses here) |
| 28 | Product lens 1 — Real job (JTBD): name the job in one sentence or the behavior is suspect; flag behaviors serving the system/implementation not a user goal | VC:25 | Behavior with no real user job ships | keep-verbatim |
| 29 | Product lens 2 — Who, concretely: name actual user(s) + context; no concrete user is a finding | VC:26 | Behavior built for nobody in particular | keep-verbatim |
| 30 | Product lens 3 — Right problem / simpler path: smaller thing serving the same job? symptom vs cause? name the cheaper alternative | VC:27 | Over-built solution to the wrong problem | keep-verbatim |
| 31 | Product lens 4 — Priority by user value: challenge P1/P2/P3 when they reflect implementation ease not user value | VC:28 | Priorities inverted toward what's easy to build | keep-verbatim |
| 32 | Product lens 5 — Missing user needs: adjacent jobs, unhappy path hit first, data unavailable at task start | VC:29 | Unaddressed adjacent/unhappy-path needs | keep-verbatim |
| 33 | Product lens 6 — User-facing edge cases: interruption mid-task, partial/dirty data, duplicates, record that doesn't fit model, destructive action w/ no undo | VC:30 | Shipped behavior breaks on real-world edge input | keep-verbatim |
| 34 | Product lens 7 — Testability & value: behavior must be observable/testable and passing its test must prove user value | VC:31 | Untestable or vanity-tested behavior | keep-verbatim |
| 35 | Product lens 8 — Scope creep/scope gap: in-scope nobody asked for; Out-of-Scope user will expect; risky Assumption | VC:32 | Silent scope drift in either direction | keep-verbatim |
| 36 | Architecture lens 1 — Behavior coverage: every B-NNN delivered by ≥1 Task AND covered by ≥1 Test behavior; trace B→Task→Test | VC:36 | A locked behavior ships undelivered or untested | keep-verbatim |
| 37 | Architecture lens 2 — Correctness vs intent: walk data/control flow against research.md/`## Current State`; flag decisions that won't yield the stated behavior or contradict current-state facts | VC:37 | Design that looks right but doesn't produce the behavior | keep-verbatim |
| 38 | Architecture lens 3 — Constitution & platform split: honors `.workspace/constitution.md`; unjustified deviation with no Constitution line is a finding | VC:38 | Silent constitution violation | keep-verbatim |
| 39 | Architecture lens 4 — Simpler path/over-engineering: new subsystem/tool/library where existing would do; unneeded abstraction; ⚠️ choice buying nothing | VC:39 | Unjustified complexity | keep-verbatim |
| 40 | Architecture lens 5 — Hidden coupling/boundary leaks: domain reaching into another's internals, undefined contract two tasks assume, shared-state race, ordering dep violating block order | VC:40 | Cross-domain breakage at integration time | keep-verbatim |
| 41 | Architecture lens 6 — Data model & contract soundness: query w/ no supporting index, missing FK/constraint, contract change breaking a consumer, unmodeled state | VC:41 | Data-layer defects surfacing post-build | keep-verbatim |
| 42 | Architecture lens 7 — Risk & unknowns: load-bearing unverified assumption, ⚠️ actually decision-blocking, migration landmine, unhandled failure mode | VC:42 | Known risk shipped unflagged | keep-verbatim |
| 43 | Architecture lens 8 — Task sizing & order: over-budget task that should split, task that's really a design restatement, block ordered before its dependency, test task that wouldn't catch a regression | VC:43 | Implementation-order/sizing defects discovered mid-build | keep-verbatim |
| 44 | "A concrete weakness tied to an impact and a location" — product: `B-NNN/Problem/Out of Scope/Assumption/"missing"`; architecture: `B-NNN/T-NNN/D-NNN/Data model/Architecture/"missing"` | VC:47 | Findings with no locatable anchor | keep-verbatim |
| 45 | "Ranked by how much it would hurt if it shipped as written." | VC:48 | Team-lead can't triage findings by severity | keep |
| 46 | "'I'd word this differently' is not a finding. Cosmetic, format, and naming issues are out of scope." | VC:49 | none beyond VC:21 (intra-skill duplicate) | delete — collapse into row 27 |
| 47 | "Send exactly ONE message, per `vibe-team-communication-protocol`." | VC:53 | Multiple/fragmented reply messages | keep, **rename** reference → `vibe-team-protocol` (same stale-name issue as row 6) |
| 48 | Findings reply template: `Critique (<product\|architecture>) — <feature>:` / `- <location> · <weakness+impact> · <lens>` / `Sharpest disagreement: <…, or "none">` | VC:57-62 | Inconsistent reply shape the team-lead can't parse programmatically | keep-verbatim (exact contract) |
| 49 | Clean reply template: `Critique (<product\|architecture>) — <feature>: no findings. <mode-specific closing clause>` | VC:64-68 | Ambiguous "clean" signal | keep-verbatim (exact contract) |
| 50 | "Bullets only. ≤2 lines per finding. No prose paragraphs." | VC:70 | Bloated findings the team-lead has to compress before relaying | keep |
| 51 | "The Sharpest disagreement line is mandatory on a findings reply — the single question the team-lead should spar with the user over." | VC:71 | Team-lead has nothing crisp to escalate to the user | keep (hard rule) |

## Verbatim contracts to preserve

- Frontmatter description's dispatch-generic mechanism + "never edits" fact (CR:3) — reword tail into an explicit `Does not …` clause, keep the fact.
- "Follow `vibe-critique` for the stance, the lens-set your brief names, what counts as a finding, and the exact reply format." (CR:17) — the model kernel-by-reference line.
- "Critique against what the team-lead hands you and the original request." (CR:17)
- "A draft you can't fault is rare — look harder before replying 'no findings'." (CR:19)
- VC:10-13 dispatch-mode contract (Product brief vs Architecture brief → which lens-set, which artifact, when it runs).
- VC:18 read-only tool list: "Use `Read`, `Grep`, `Glob`, `codegraph`, and read-only exploration to ground a finding."
- VC:19 calibration examples (B-002/T-003 concrete-vs-abstract pair) — verbatim, don't paraphrase.
- All 16 lens bullets (VC:25-32 Product, VC:36-43 Architecture) — verbatim, word-for-word; these are the actual attack surface.
- Findings reply template (VC:57-62) and Clean reply template (VC:64-68) — exact strings, both modes' closing clauses.
- "Bullets only. ≤2 lines per finding. No prose paragraphs." + Sharpest-disagreement-mandatory rule (VC:70-71).

## {{PLACEHOLDER}} candidates

None identified. Every path/artifact name in CR and VC (`research.md`, `## Current State`, `spec.md`, `plan.md`, `.workspace/constitution.md`) is a vibe-framework convention, not a project-specific fact — critic is read-only and runs no project commands, so none of the standard's example placeholder categories (`{{STACK_FACTS}}`, `{{VERIFY_COMMANDS}}`, `{{DOMAIN_CHECKLIST}}`) apply here.

## Duplicates / contradictions

1. **Confirmed**: CR:15 (whole stance paragraph) near-verbatim duplicates VC:8 + VC:10-13 — this is the exact case `agent-standard.md` rule 6 cites. Delete confirmed, no surviving teeth (see mandate-check section above).
2. CR:19 "gap nobody noticed" near-verbatim duplicates VC:17.
3. "Cosmetic/wording out of scope" appears **three times**: CR:19, VC:21, and VC:49 — VC:21/VC:49 is an *intra-skill* duplicate independent of the agent file. Collapse all three to one statement, canonical home VC:21.
4. CR:17's grounding-files + read-only-exploration language restates `vibe-research-protocol` (kernel rungs 1-3) inline, despite that skill already being referenced in CR's `skills:` list — a rule-6 violation on its own terms.
5. Stale skill name: `vibe-team-communication-protocol` (CR:8, VC:53) — kernel migration renamed/merged this to `vibe-team-protocol` (`templates/kernel/team-protocol.md`, which also absorbed the former orchestration skill). Both references need updating.
6. Not a contradiction but a trap for the rewrite: VC:18's read-only tool list (no Bash) differs in scope from `review-protocol.md`'s read-only stance (permits read-only Bash for `git diff`/tests) — don't merge critic's stance into review-protocol's; critic has no test-running role. No conflicting facts found elsewhere.

## Suggested ≤70-line skeleton (canonical anatomy)

```
--- frontmatter (11 lines): name, description (revised w/ explicit "Does not"), model: opus,
    effort: xhigh, color: red, skills: [vibe-team-protocol, vibe-research-protocol, vibe-critique] ---
<!-- vibe-template header -->

# critic

## Skills & documents you refer to
| skill/doc | when to use |
  vibe-team-protocol   → done/blocked/andon messaging, reply delivery (row 47)
  vibe-research-protocol → ground a finding via cited map/codegraph before reporting it (rows 15-16)
  vibe-critique         → stance, lens-set for your brief's mode, finding format, reply format (row 13)

## Workflow
  - dispatch brief names the artifact + lens-set (row 11, merged)
  - ground against the team-lead's handoff AND the original request (row 14)
  - run the named lens-set per vibe-critique; verify load-bearing details read-only via research-protocol
  - before replying "no findings", look harder — it's rare (row 18)
  - reply once, per vibe-critique's exact format (row 47/48/49)

## Boundaries
  - never edits — Read/Grep/Glob/codegraph only, findings only (row 24)
  - does not choose the target or lens-set — the brief does (rows 11, 22)
  - cosmetic/wording/naming issues are out of scope — the team-lead's gate owns those (row 27)
```

Rows 9, 10, 12, 17, 19 (deleted, now-in-vibe-critique) and rows 15-16 (now-in-research-protocol) have no line in the skeleton — their content already lives in the referenced skills and is reached via the Skills table pointers above.
