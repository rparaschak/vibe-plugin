# Disposition: vibe-team-communication-protocol + vibe-team-orchestration → templates/kernel/team-protocol.md

Scout output (sonnet, 2026-07-13). CP = communication-protocol skill (77 lines); ORCH = orchestration skill (33 lines). The author of team-protocol.md works from THIS file, not the sources.

## Disposition table

| # | Instruction (key terms/formats verbatim) | Source | Failure prevented | Disposition |
|---|---|---|---|---|
| 1 | "Teammates only see what you `SendMessage`; your text output is invisible to them." | CP:8 | Report silently lost | keep (premise) |
| 2 | One in-flight message per recipient (parallel to different recipients fine) | CP:8 | Message pileup/racing | keep |
| 3 | idle-after-reporting ≠ broken: sent done/blocked then waits; don't respawn | CP:8 | Wasteful re-spawn of finished worker | keep |
| 4 | Idle WITHOUT report is not normal waiting; lead must verify ground truth and proceed | CP:10 | Phantom wait | merge-dup → #22 (ORCH version canonical, adds re-ping-once) |
| 5 | Message lead ONLY when: done / blocked / andon cord. "Do not send progress updates, micro-status, or running commentary. The team-lead does not respond to those by design." | CP:14-20 | Status noise burying real signals | keep (gate) |
| 6 | Done-message: "Send it — don't just emit it." Last action = SendMessage to lead (`main`). Format: `Done.` / `Wrote: <artifacts or sections>` / `Result: <role's evidence — test/build outcome with counts, findings count, or "Open Questions added: N">` / `Blocked on: <none or one line>` | CP:22-33 | Unverifiable completion; printed-not-sent report | KEEP (load-bearing contract) |
| 7 | Decisions/reasoning belong in the artifact (spec.md WHAT, plan.md Decision Log HOW, code comments only non-obvious WHY, PR description). Not in chat. | CP:35 | Decisions lost in chat | keep (intra-dup w/ #14b) |
| 8a-d | Turn-based not a daemon; NEVER background a long command and end turn promising to report (real incident); foreground + block + report; multi-minute run = one turn's work ("Monitor armed" is not a deliverable, recorded pass/fail is); if truly can't finish in one turn → andon-cord, never fake async completion | CP:39-43 | Phantom async runs; fake completion | KEEP (hard rules) |
| 9 | Peer-to-peer: ask = one sentence need + scope (paths/sections/IDs) + what's known; reply = bullets ≤2 lines, cite file:line/B-NNN/D-NNN, say unsure — don't speculate | CP:47-48 | Redundant re-discovery; speculation | keep |
| 10 | Andon cord — stop and escalate the moment you see: artifact in unexpected state; missing precondition (plan not Ready for Implement, prerequisite plan not Implemented); asked to work outside your role; unresolvable blocker | CP:52-58 | Proceeding on bad preconditions | KEEP (THE andon rule) |
| 11 | Send one message describing what you saw and stop; don't fix structural problems by guessing | CP:59 | Compounding guessed fixes | keep |
| 12 | Role boundaries (verbatim): PM frames/writes WHAT (spec.md Problem+Behaviors+Out of Scope+Assumptions), no UX/architecture/code. Designers write `## UX structure` only. Architects design/write plan.md, no code. Engineers write code, don't redesign plan. Reviewers/critic find+report, never modify files. Team-lead orchestrates: does not read code, write artifacts, or edit spec/plan. | CP:63-68 | Role overreach | KEEP (hard rule); lead-reads-no-code dup w/ #25 |
| 13 | Message asks you outside your role → andon-cord it | CP:70 | Silent boundary violations | keep |
| 14 | Never over SendMessage: long source dumps (cite file:line); decisions belonging in Decision Log; reasoning meant for the user; internal deliberation ("decide first, then send") | CP:74-77 | Context bloat; uncommitted deliberation | keep |
| 15 | "Command owns the algorithm; this skill never repeats it" framing | ORCH:8 | unclear | drop-candidate (one-line scope note max) |
| 16 | Spawn each role NAMED when first needed; keep standing to retain context; never re-spawn a held role | ORCH:12 | Context destruction | KEEP |
| 17 | On-call peers spawn lazily when a question arises; live set near 3–5 | ORCH:13 | Idle-agent overhead | KEEP (numeric limit) |
| 18 | Self-contained first brief; teammates load own project context (CLAUDE.md, skills, codegraph) | ORCH:14 | Lead-pasted stale context | keep |
| 19 | Worktree mode: lead must EnterWorktree BEFORE spawning first role; all roles share the tree; teardown exits/merges (command owns lifecycle) | ORCH:15 | Wrong-tree work | KEEP (sequencing rule) |
| 20 | "Dispatch to <role>" = ONE SendMessage with the command's brief, then wait. Briefs short + self-contained: what to do, scope (paths/plan section/IDs), what's known. Workers read their own plan section and source themselves — never paste code. | ORCH:19 | Brief bloat; dispatch races | KEEP (dispatch contract) |
| 21 | Every brief ends by telling the worker to SendMessage its done-report to `main` | ORCH:20 | Silent finish | merge-dup → #6 (cross-cites CP) |
| 22 | Idle teammate = a turn that ended, not a run in flight. Idle without report → re-ping ONCE, then get ground truth yourself (read deliverable, check live process). Never wait on a phantom background run. | ORCH:21 | Indefinite wait on dead worker | KEEP — canonical; absorbs #4 |
| 23 | Standing vs fresh dispatch: re-dispatch = SendMessage to STANDING instance; fresh instance = tear down standing + spawn new. "Fresh replaces, never adds" — one-instance-per-role and live-set rules hold; new instance rebuilds from brief + cited map | ORCH:22 | Duplicate role instances; contaminated context | KEEP (hard rule) |
| 24 | Parallel fan-out: one role across N concurrent instances, each a different checklist lens; sanctioned bounded exception to one-instance-per-role; gather ALL replies, then apply command's combine rule — block review = all-clear (passes only when no reviewer has open findings after consolidation + fix), not a vote; consolidation owner (architect, per on-call) gets gathered findings before the fix | ORCH:23 | Partial-consensus bugs; vote semantics | KEEP (combine semantics) |
| 25 | Lead stays out of code; workers start from cited map; matching architect on-call for design-intent; codebase-researcher = context oracle in spec/plan; blocked worker andon-cords; "you never read code to answer" | ORCH:27 | Lead context contamination; wrong oracle | keep — dedupe lead-no-code with #12; oracle detail additive |
| 26 | Teardown: work complete → tear down team, no teammate left running. "One team's lifetime = one invocation." | ORCH:31 | Orphaned agents leaking context | KEEP (hard rule) |
| 27 | Resume caveat: in-process teammates don't survive /resume or /rewind; name stops answering → re-spawn role from durable state (Tasks table + decisions), don't message the dead name | ORCH:33 | Messaging dead identities forever | keep (distinct from #22) |

## Duplicate pairs (collapse to single canonical statements)
1. CP:10 ↔ ORCH:21 idle-without-report — ORCH canonical (has re-ping-once step).
2. CP:22-24 ↔ ORCH:20/21 done-report delivery — state once in done-message section; dispatch section references it.
3. CP:68 ↔ ORCH:27 lead-does-not-read-code — single copy in role boundaries; ORCH's oracle detail kept as additive.
4. Intra-CP: CP:35 ↔ CP:76 decisions-in-artifact — single statement.

## Contradiction to resolve
CP:10 says verify-ground-truth immediately; ORCH:21 says re-ping once THEN verify. Author must pick ONE sequence — recommendation: ORCH's (re-ping once, then ground truth).

## Suggested skeleton (≤70 lines)
Premise (invisible output, one in-flight msg/recipient) → Form & dispatch (named standing spawns, lazy on-call, live-set 3–5, self-contained briefs, worktree sequencing, dispatch contract, standing-vs-fresh, fan-out + combine rule) → Messaging the lead (done/blocked/andon only; verbatim done-format) → Turn discipline (idle rules merged, no-backgrounding, resume caveat) → Peer-to-peer + never-over-SendMessage → Andon cord (verbatim) + role boundaries (verbatim, single lead-no-code copy) → Teardown. Drops only #15.
