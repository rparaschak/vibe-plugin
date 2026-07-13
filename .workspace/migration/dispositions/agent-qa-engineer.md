# Disposition: agents/qa-engineer.md + skills/vibe-manual-testing/SKILL.md → (rewritten) agents/qa-engineer.md

Scout output (sonnet, 2026-07-13). QA = agents/qa-engineer.md (19 lines); SK = skills/vibe-manual-testing/SKILL.md (45 lines). Confirmed by grep: `vibe-manual-testing` has exactly one consumer (`agents/qa-engineer.md`) — `docs/migration-plan.md:140` and `docs/harness-builder.md:109` both mandate inlining it into the qa-engineer template, no command references the skill directly. The author of the rewritten qa-engineer.md works from THIS file, not the sources. Because of the single-consumer inline mandate, skill rows are dispositioned `inline-from-skill` (their content moves into the agent body) rather than routed to a kept reference skill. Cross-checked against `standards/agent-standard.md` and kernel files `templates/kernel/team-protocol.md`, `templates/kernel/research-protocol.md` (skimmed `templates/kernel/review-protocol.md` too — no overlap found; qa-engineer and the code reviewer share no machinery).

## Known-mandate check: the "stance paragraph"

QA:15 (the whole first body paragraph) is confirmed to be the paragraph `agent-standard.md` rule 6 and `docs/migration-plan.md:139` both name as the same-shape failure as critic's ("delete the restated stance paragraphs in `critic.md` and `qa-engineer.md` — near-verbatim duplicates of their skills"). Sentence-by-sentence:

- "You manually test an implemented, user-facing block by clicking through the real running app" → near-verbatim echo of SK:8 ("You drive the **real running app** through the Playwright MCP browser…").
- "the human-QA step the reviewers and automated tests don't cover" → LOOKS like teeth (positioning rationale), but it's already covered by QA:3's description clause "Use in the implement-phase review step for user-facing blocks" and the description's "Does not write code or tests." No unique failure prevented beyond what the description already carries.
- "You confirm each of the plan's behaviors actually works for a user." → near-verbatim echo of SK:8 ("…confirm the plan's user-facing behaviors actually work").
- "You never edit code or write tests." → triple duplicate: description QA:3 ("Does not write code or tests"), SK:8 ("You do not write code or tests"), and SK:45's tail ("you never edit code"). Canonical home per rule 5 is the description + Boundaries, not a restated mid-file sentence.

**Verdict: confirmed delete-candidate, no nameable failure beyond what the description (QA:3) and SK:8/SK:45 already prevent.** No teeth needed extraction as new rows.

## Disposition table

| # | Instruction (key terms/formats verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | `name: qa-engineer` | QA:2 | Dispatch table lookup miss | keep-verbatim |
| 2 | `description:` full text (42 words, has explicit "Does not write code or tests." clause) | QA:3 | Orchestrator can't route/scope a QA dispatch; unclear boundary | keep-verbatim (already meets rule 2's ≤60-word + `Does not` shape) |
| 3 | `model: sonnet` | QA:4 | Under-specified dispatch budget | keep-verbatim |
| 4 | `effort: high` | QA:5 | Under-specified dispatch budget | keep-verbatim |
| 5 | `color: green` | QA:6 | UI mis-grouping | keep-verbatim |
| 6 | `skills: vibe-team-communication-protocol` | QA:8 | Wrong/stale protocol pointer | keep, **rename** → `vibe-team-protocol` (kernel consolidated communication-protocol + orchestration under this name; `templates/kernel/team-protocol.md` frontmatter) |
| 7 | `skills: vibe-research-protocol` | QA:9 | Wrong/stale protocol pointer | keep-verbatim (name unchanged; kernel-backed at `templates/kernel/research-protocol.md`, identical content) |
| 8 | `skills: vibe-manual-testing` | QA:10 | Skills table would still point at a file that no longer exists standalone | **inline-from-skill** — remove this frontmatter row entirely; content folds into the agent body (single-consumer mandate) |
| 9 | "You manually test an implemented, user-facing block by clicking through the real running app" | QA:15 | none beyond SK:8 | delete (duplicate) |
| 10 | "the human-QA step the reviewers and automated tests don't cover" | QA:15 | none beyond description QA:3's positioning clause | delete-candidate — no nameable failure |
| 11 | "You confirm each of the plan's behaviors actually works for a user." | QA:15 | none beyond SK:8 | delete (duplicate) |
| 12 | "You never edit code or write tests." | QA:15 | none beyond description + SK:8 + SK:45 (4th occurrence) | delete (duplicate; canonical home = description + Boundaries) |
| 13 | "Follow `vibe-manual-testing` for everything: bringing the app up …, the pre-authenticated MCP browser, the click-through method …, and the exact pass / findings reply formats." | QA:17 | Agent restating vs. pointing at the skill (this is the correct rule-6 pattern for a KEPT reference skill) — but here the skill is being inlined, so the pointer itself is obsolete | **inline-from-skill** — delete this pointer sentence; its four named topics become the actual Workflow content (rows 21-35 below), not a reference |
| 14 | "A finding is a routed fix for the engineer, not an edit." | QA:19 | none beyond SK:45's near-identical closing clause | merge — collapse into SK:45's canonical wording (row 35), delete this copy |
| 15 | "If the env won't come up or the block's design contradicts what you see, andon-cord the team-lead rather than working around it." | QA:19 | Two distinct, otherwise-uncovered failure modes: (a) app fails to start at all — SK:14/15 say how to start it but not what to do if it won't come up; (b) the block's *design* contradicts what QA observes — nowhere else in QA or SK; without this, a QA agent might silently "work around" a broken env or quietly report a design mismatch as an ordinary finding instead of escalating it | **keep** (unique teeth, no duplicate found) — Boundaries |
| 16 | SK frontmatter `name: vibe-manual-testing` | SK:2 | N/A once file is retired | delete (file removed under single-consumer inline mandate) |
| 17 | SK frontmatter `description:` (skill-trigger contract) | SK:3 | N/A once file is retired — no longer a dispatched/auto-loaded skill | delete |
| 18 | `# Manual testing` heading | SK:6 | N/A as a standalone doc | inline-from-skill — becomes a Workflow subsection, not a top-level heading |
| 19 | "You drive the **real running app** through the Playwright MCP browser and confirm the plan's user-facing behaviors actually work. You do not write code or tests." | SK:8 | Loss of role framing if deleted entirely | **inline-from-skill, keep** — this is the CANONICAL wording that replaces the deleted QA:15 stance paragraph as the agent's opening line |
| 20 | `## Bring the env up` heading | SK:10 | — | inline-from-skill (subsection) |
| 21 | "The commands to bring infra and the app up are **project-supplied** — resolve them from the project's `environment` skill; never hardcode or guess them. The skill tells you which processes/ports to start and how to confirm they're up." | SK:12 | A QA agent hardcodes/guesses start commands instead of resolving them per-project, breaking on any project whose env differs | inline-from-skill, keep — also dedupes QA:17's now-deleted parenthetical of the same fact |
| 22 | "Start the app per the `environment` skill and wait until it responds on the ports that skill names." | SK:14 | QA agent starts testing before the app is actually up | inline-from-skill, keep |
| 23 | "If the data stack is down, bring it up per the `environment` skill too." | SK:15 | QA agent tests against a broken/absent data layer and misreports app bugs | inline-from-skill, keep |
| 24 | "If auth fails, andon-cord the team-lead — don't try to sign in by hand." | SK:16 | QA agent hand-authenticates, defeating the pre-auth session contract and masking a real auth regression | inline-from-skill, keep (distinct trigger from row 15's env/design andon — see Duplicates §5) |
| 25 | `## Auth is already solved` heading | SK:18 | — | inline-from-skill (subsection) |
| 26 | "The MCP browser launches with the saved storage state, so it opens **already signed in**. Never navigate the sign-in UI or type credentials. Start at the app URL the `environment` skill names." | SK:20 | QA agent wastes turns on sign-in UI, or types credentials it shouldn't have/need | inline-from-skill, keep-verbatim |
| 27 | `## Method` heading | SK:22 | — | inline-from-skill (subsection) |
| 28 | "1. Read the plan's **Behaviors** (B-NNN) for the block under test. Those are your test cases." | SK:24 | QA agent invents its own test cases instead of testing the locked plan behaviors | inline-from-skill, keep-verbatim |
| 29 | "2. `browser_navigate` to the app, then per behavior: `browser_snapshot` to read state, `browser_click` / `browser_type` to act, snapshot again to verify the outcome the behavior promises." | SK:25 | Wrong/ad-hoc tool sequence produces unverified or misread test results | inline-from-skill, keep-verbatim (exact tool-call contract) |
| 30 | "3. Test the real happy path plus the obvious user-facing edge the behavior names (empty state, validation error, etc.). Don't audit code or chase paths outside the plan." | SK:26 | Scope creep — QA agent starts auditing code or testing paths never specified in the plan | inline-from-skill, keep |
| 31 | `## Reply format` heading | SK:28 | — | inline-from-skill (subsection) |
| 32 | "Send exactly ONE, per `vibe-team-communication-protocol`." | SK:30 | Fragmented/multiple reply messages | inline-from-skill, keep, **rename** reference → `vibe-team-protocol` (same stale-name issue as row 6) |
| 33 | Pass template: `QA pass — <block>.` / `Behaviors: B-001 ✓, B-002 ✓, …` | SK:33-36 | Inconsistent pass-report shape the team-lead can't parse programmatically | inline-from-skill, keep-verbatim (exact contract) |
| 34 | Findings template: `QA findings — <block>:` / `- B-003 · <what you did> → <what happened> vs <what the behavior promises>` | SK:39-43 | Inconsistent findings shape; missing observed-vs-expected pairing | inline-from-skill, keep-verbatim (exact contract) |
| 35 | "Bullets only. Each finding ties to a behavior and states the observed vs expected. A finding is a routed fix for the engineer — you never edit code." | SK:45 | Prose-paragraph findings, findings with no behavior anchor, or QA "fixing" instead of reporting | inline-from-skill, keep-verbatim — canonical home for the "finding is a routed fix" fact (absorbs QA:19's row 14 duplicate); note the tail "you never edit code" is this passage's *4th* occurrence of the no-edit boundary — see Duplicates §3 |

**Row count: 35.**

## Verbatim contracts to preserve

- Description QA:3 in full — already-compliant `Does not …` clause, keep as-is.
- SK:8 canonical stance: "You drive the **real running app** through the Playwright MCP browser and confirm the plan's user-facing behaviors actually work. You do not write code or tests." — becomes the agent's new opening line, replacing deleted QA:15.
- SK:12 project-supplied-commands rule: "The commands to bring infra and the app up are **project-supplied** — resolve them from the project's `environment` skill; never hardcode or guess them."
- SK:16 auth-fail andon: "If auth fails, andon-cord the team-lead — don't try to sign in by hand."
- SK:20 pre-auth facts: "The MCP browser launches with the saved storage state, so it opens **already signed in**. Never navigate the sign-in UI or type credentials."
- SK:25 tool-call contract: "`browser_navigate` to the app, then per behavior: `browser_snapshot` to read state, `browser_click` / `browser_type` to act, snapshot again to verify the outcome the behavior promises." — exact MCP tool names, don't paraphrase.
- Pass template (SK:33-36) and Findings template (SK:39-43) — exact strings, both formats.
- SK:45 in full — "Bullets only. Each finding ties to a behavior and states the observed vs expected. A finding is a routed fix for the engineer — you never edit code."
- QA:19's second sentence (row 15) — "If the env won't come up or the block's design contradicts what you see, andon-cord the team-lead rather than working around it." — unique teeth, no source elsewhere covers the design-contradiction trigger.

## {{PLACEHOLDER}} candidates

None identified. No app URL or run command is ever hardcoded in either source — both correctly defer to "the project's `environment` skill" by reference (SK:12, SK:14, SK:15, SK:20), which is itself the placeholder-avoidance pattern the standard wants. There is nothing here shaped like `{{STACK_FACTS}}` / `{{VERIFY_COMMANDS}}` / `{{DOMAIN_CHECKLIST}}` — qa-engineer's only "variable" inputs (app URL, start commands, ports) are resolved at runtime via the `environment` skill lookup, not stamped at generation time.

## Duplicates / contradictions

1. **Confirmed**: QA:15 (whole stance paragraph) near-verbatim duplicates SK:8 — the exact case `agent-standard.md` rule 6 and `docs/migration-plan.md:139` both cite (same shape as critic's). Delete confirmed, no surviving teeth (see mandate-check section above).
2. QA:19's first sentence ("A finding is a routed fix for the engineer, not an edit.") near-verbatim duplicates SK:45's closing clause — collapse to SK:45's canonical wording.
3. "Never edit code / write tests" appears **four times**: description QA:3, QA:15 (deleted), SK:8, and SK:45's tail. Per rule 5 (constraints only in description + Boundaries), recommend the inlined body keep this fact stated once in Boundaries; SK:45's tail clause can likely be trimmed to just the reply-format-specific part ("A finding is a routed fix for the engineer") when inlining, since the "never edit code" restatement there is the 4th copy — flag for author judgment rather than a forced cut, since critic's precedent (row 24/VC:18) kept a differently-scoped restatement.
4. Stale skill name `vibe-team-communication-protocol` (QA:8, SK:30) — kernel migration renamed/merged this to `vibe-team-protocol` (`templates/kernel/team-protocol.md`). Both references need updating — same issue flagged in the critic disposition.
5. Andon-cord triggers appear in three places at different scopes, **not** true duplicates: kernel `team-protocol.md`'s generic list (artifact in unexpected state / missing precondition / asked outside role / unresolvable blocker), SK:16 (auth fails specifically — don't hand-sign-in), and QA:19's row 15 (env won't come up, or block's design contradicts what you see). The two QA-specific triggers name concrete failure modes the generic kernel list doesn't spell out — keep both as Boundaries bullets rather than collapsing into the kernel line.
6. Not a contradiction, confirmed clean: qa-engineer runs "in the implement-phase review step for user-facing blocks" (QA:3) alongside the code reviewer, which follows kernel `review-protocol.md`. Skimmed review-protocol.md — no shared mechanics, no verdict-format overlap, no duplication risk between the two roles' reply formats (QA's `QA pass/QA findings` vs reviewer's `Accept/Revise/Block`).

## Frontmatter skill-name check (kernel `name:` match)

- `vibe-team-communication-protocol` → must become `vibe-team-protocol` (matches `templates/kernel/team-protocol.md:2` `name: vibe-team-protocol`).
- `vibe-research-protocol` → already matches `templates/kernel/research-protocol.md:2` `name: vibe-research-protocol`, no change.
- `vibe-manual-testing` → removed from the skills list entirely (inlined, single consumer, no kernel/skill file survives to match against).

## Suggested ≤70-line skeleton (canonical anatomy) — **overflow risk: YES**

```
--- frontmatter (~10 lines): name, description (unchanged, row 2), model: sonnet,
    effort: high, color: green, skills: [vibe-team-protocol, vibe-research-protocol] ---
<!-- vibe-template header -->

# qa-engineer

You drive the real running app through the Playwright MCP browser and confirm the
plan's user-facing behaviors actually work. You do not write code or tests. (row 19)

## Skills & documents you refer to
| skill/doc | when to use |
  vibe-team-protocol    → done/blocked/andon messaging, reply delivery (row 32)
  vibe-research-protocol → n/a beyond standard ladder if a plan/behavior needs clarifying

## Workflow
  Bring the env up (rows 21-24)
  - resolve commands from the project's `environment` skill; never hardcode/guess
  - start the app, wait for it to respond on the named ports
  - bring up the data stack too if it's down
  - auth fails → andon-cord, don't hand-sign-in

  Auth (row 26)
  - MCP browser opens already signed in via saved storage state; never navigate
    sign-in UI or type credentials; start at the environment skill's app URL

  Method (rows 28-30)
  1. Read the plan's Behaviors (B-NNN) — those are your test cases
  2. browser_navigate, then per behavior: browser_snapshot → act → browser_snapshot
  3. happy path + the obvious named edge only; don't audit code or chase other paths

  Reply (rows 32-35)
  - send exactly ONE reply, per vibe-team-protocol
  - Pass template / Findings template (verbatim, rows 33-34)
  - bullets only, each finding ties to a behavior, states observed vs expected

## Boundaries
  - never edit code or write tests — findings are routed fixes for the engineer (rows 12, 35)
  - env won't come up, or the block's design contradicts what you see → andon-cord,
    don't work around it (row 15)
```

**Overflow flag: YES.** Rough line count of the above skeleton, written out at normal prose density (not the compressed bullet-summary shown here), lands in the 80-95 line range once the two verbatim reply templates (8 code-fenced lines total) and the four-line Method numbered list are expanded in full — well past the 70-line ceiling. SK.md alone is 45 lines of mostly load-bearing content (rows 19, 21-24, 26, 28-30, 32-35 are almost all keep/keep-verbatim, only 3 heading-only rows are pure structure); folding it plus QA's frontmatter and two surviving body rows (2, 15) into one file will not fit at 70 lines without real compression. Recommend the author collapse the four `##` subheadings (Bring the env up / Auth / Method / Reply format) into unheaded bullet groups under a single `## Workflow`, and/or move the two reply templates into a single combined example rather than separate Pass/Findings fenced blocks — flag this tradeoff explicitly to whoever authors the rewrite rather than silently letting the file exceed budget.
