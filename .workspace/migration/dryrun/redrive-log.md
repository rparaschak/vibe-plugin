# Re-drive log — toy `--version` plan through FIXED `implement.md`

Targeted re-drive of the steps the prior drive flagged, against the CURRENT
`.workspace/migration/dryrun/implement.md` (re-read fresh; line numbers below are
current, not the stale drive-log ones).

Kernel of record: `templates/kernel/task-ledger.md` and
`templates/kernel/review-protocol.md`. (The task said kernel copies sit in the
dryrun dir; they do not — `task-ledger.md` exists only at `templates/kernel/`.
Its :16 / :27 match the task's citations verbatim, so it is authoritative here.)

Style: quote the line obeyed → what I did → finding (BLOCKER / WARN / CLEAR).

---

## 1 — Entry gate (old: entry-WARN — ready-Status set unstated)

Obeying implement.md:40:
> "2. **Gate check (entry).** Before any dispatch, confirm the ledger's Status / Open Questions / Dependencies are ready. Not ready → andon-cord per `vibe-team-protocol`; do not build on an unready artifact."

…resolved against the new Entry bullet, implement.md:17:
> "- Entry: Status `Ready for Implement` (a mid-run resume per the ledger's Handoff block also qualifies); every header `Depends on` plan is `Implemented` — this command is where that promise is enforced."

What I did:
- **Status.** Toy header = `Status: Ready for Implement`. Line 17 now names the
  ready set explicitly: `Ready for Implement`, OR a mid-run resume (identified by
  a Handoff block). Toy plan matches the primary named value → **closed answer,
  no inference.** The old WARN ("which Status values count as ready?") is
  answered by the enumeration on line 17.
- **Depends on: —.** Line 17: "every header `Depends on` plan is `Implemented`."
  Toy header `Depends on: —` lists zero prerequisite plans → the universal holds
  vacuously → gate passes. This is a closed answer (empty-set quantification), not
  an improvisation. The dash is the plan's own no-deps sentinel (used the same way
  in the header), so reading `—` as "no plans" is the plan's convention, not a
  driver guess.
- Open Questions = None ✓. Gate passes.

**Verdict — entry-WARN: CLEAR.** Resolving line: implement.md:17 (names the ready
Status set AND states the Depends-on rule the gate enforces).

---

## 2 — Block 1 (Platform, T-901, NO test leaf) (old: F-1 WARN)

Obeying implement.md:26:
> "- The engineer implements the block's non-test leaves; then the test-engineer (a fresh context) writes the block's test leaf — **a block with no test leaf skips the test-engineer dispatch (its exit lens still applies)**."

What I did: Block 1's only Tasks-table row is T-901 (Platform) — no paired
platform test leaf. Line 26's trailing clause **explicitly authorizes** skipping
the test-engineer dispatch for a test-leaf-less block, and reminds me the exit
lens still applies (implement.md:30: "Platform / BE block → the integration suite
ran and passed"). I skipped the test-engineer for block 1 **with textual warrant**
— no inference. The prior drive had to skip it unlicensed; that gap is closed.

**Verdict — F-1: CLEAR.** Resolving line: implement.md:26 (the "no test leaf skips
the test-engineer dispatch" clause).

---

## 3 — Block gate + advance under the per-block commit model (old: F-2 BLOCKER)

Obeying implement.md:18:
> "- Commit: on, per block. When a block's build work is done, **you commit it, then dispatch the block's review against that commit** — the reviewer's verdict and each leaf's evidence cite that hash, per `vibe-task-ledger`/`vibe-review-protocol`; every fix round commits before re-review. The Finalize commit is the closing commit only (ledger state-flips, learnings, Handoff)."

Literal walk of Block 1 (T-901), simulated hashes:
1. **Dispatch → wait.** Engineer (backend) writes `src/version.ts`; done-report:
   `node -e "console.log(require('./src/version').getVersion())"` → `1.0.0`.
2. **Commit (before review).** Build work done → per line 18 the team-lead commits
   the block → hash **`c0mm1a1`**. (Git commit via Bash — not an Edit/Write of
   source, so within the line-12 boundary; line 18 assigns "you commit it" to the
   lead, so no ambiguity about who commits.)
3. **Gate (review against that commit).** Dispatch reviewer (backend) against
   `backend-review`. Reviewer Accept, in review-protocol.md:49-54 format:
   ```
   Accept — Platform block.
   Files: src/version.ts
   Commit: c0mm1a1 · Tests: node -e "…getVersion()" → 1.0.0 → green
   ```
   Reviewer **names the commit AND the executed verification output** → satisfies
   task-ledger.md:27 verbatim.
4. **Advance.** Team-lead flips T-901 `not_started → passing` and writes the
   evidence field = `c0mm1a1; node -e "…getVersion()" → 1.0.0, reviewer-run`.
   This is exactly task-ledger.md:16's shape ("commit hash + the test/command
   output a reviewer cited") — the hash exists **before** evidence is recorded,
   because the commit (step 2) precedes review and advance. **No improvisation.**

Block 2 (T-001 + T-002, two leaves in one block): engineer writes `src/cli.ts`,
test-engineer writes `test/version.test.ts`; block build done → commit → hash
**`c0mm1b2`** → review → Accept cites `c0mm1b2 · Tests: npm test -- version.test.ts
→ 2 passed → green`. Both leaves' evidence cite `c0mm1b2` + the reviewer-cited
output. task-ledger.md:16 defines evidence as "the test/command output **a
reviewer cited**" (whatever the reviewer cited, singular per review) — so two
leaves sharing one block commit + one cited block-test result is satisfiable as
written, not a gap.

The old F-2 mechanism — Execution model forbade any commit before the single
Finalize commit, so no in-loop reviewer Accept could ever carry a real
`Commit: <hash>` and no leaf evidence could carry a hash — is **removed**. Line 18
now mandates a real per-block commit before review; every downstream citation
(review Accept `Commit: <hash>`, task-ledger:16 evidence, task-ledger:27 advance)
resolves to a genuine hash with zero invented behavior.

**Verdict — F-2: CLEAR.** Resolving line: implement.md:18 (per-block commit
before review; verdict + evidence cite that hash).

---

## 4 — Fix round (Revise on block 2)

Obeying implement.md:18 ("…every fix round commits before re-review…") and
implement.md:28:
> "- **Fix-routing** — route each finding by WHERE its fix lands … a fix in test code → re-dispatch the **test-engineer**; a fix in production code → re-dispatch the **engineer**."

Simulated: reviewer returns **Revise — BE block. Commit: c0mm1b2** with one finding:
`src/cli.ts:14 · `-v` not short-circuiting before other flags · why: correct/B-002
· fix: move the version check above the flag loop`. Fix lands in **production
code** (`src/cli.ts`) → line 28 routes it to the **engineer** (re-dispatch), not
the test-engineer — routed by the finding's cited `file:line`, exactly as the rule
says, not by symptom. Engineer applies the fix; per line 18 the team-lead
**commits before re-review** → new hash **`c0mm1b3`** → re-dispatch reviewer
against `c0mm1b3` → Accept cites the new hash. task-ledger.md:37's 3-round /
no-progress stop conditions bound the loop.

Confirmed: the text (a) tells me to commit before re-review (line 18), and (b)
routes the fix deterministically (line 28). **No improvisation. No finding.**

---

## 5 — Clean-state exit gate FAIL (old: F-3 WARN)

Obeying implement.md:42:
> "4. **Clean-state exit gate.** Before finalizing: build passes / all tests incl. pre-existing / ledger accurate / no stale artifacts / startup works — verified by command output — never merely written, compiling, or `--list`-verified. **On FAIL: an unrun check → run it; a real defect → fix-route per the flow's rule and re-gate; can't reach green → andon-cord, never finalize around a red gate.**"

Re-simulated the prior FAIL: a pre-existing suite `test/cli-help.test.ts` was
never executed this session (only `version.test.ts` ran). Under "all tests incl.
pre-existing … verified by command output," that is a **FAIL**. Walking the new
FAIL branch:
- **(a) an unrun check** → "run it." The pre-existing suite is an unrun check →
  the text gives the explicit instruction: run it. I run `npm test` → `5 passed`
  → re-gate passes. This is now **licensed**, where the prior drive had to infer it.
- **(b) a real defect** → "fix-route per the flow's rule and re-gate." Explicit —
  routes back to the line-28 fix-routing rule.
- **(c) can't reach green** → "andon-cord, never finalize around a red gate."
  Explicit — matches the parallel structure of the entry gate's andon-cord.

All three sub-cases have an explicit instruction to obey; no branch forces
improvisation. The old parallelism gap (entry gate had a FAIL branch, exit gate
did not) is closed.

**Verdict — F-3: CLEAR.** Resolving line: implement.md:42 (the three-way "On
FAIL:" branch).

---

## 6 — Finalize (old F-2 tail — evidence-before-commit contradiction)

Obeying implement.md:43:
> "5. **Finalize.** In this order … evidence recorded (Verified line where applicable) → learnings captured → state-flip → (if applicable) archive → commit → (if applicable) merge-back → write the Handoff block per `vibe-task-ledger` → tear down the team …"

Walk under the per-block commit model:
- By the time Finalize runs, **every leaf's evidence field already carries a real
  per-block commit hash** (`c0mm1a1` for T-901; `c0mm1b3` for T-001/T-002),
  recorded at each block's advance step (Section 3). So "evidence recorded" at
  Finalize is **already complete — no hash to backfill.** The step reduces to
  writing the summary Verified line, which needs no new hash.
- The Finalize **`commit` arrow now covers only the closing commit** — line 18
  scopes it precisely: "the closing commit only (ledger state-flips, learnings,
  Handoff)." It commits the Finalize-step ledger edits (Status → Implemented,
  `learnings.md`, Handoff block) — **not** source, which was already committed
  per block. That closing commit's hash is a ledger-bookkeeping hash and is **not
  required in any leaf's evidence field**, so nothing in the order depends on it
  existing earlier.

The old F-2 contradiction — Finalize sequenced "evidence recorded" strictly
before "commit," yet the evidence format (task-ledger:16) needed a commit hash,
forcing a backfill improvisation — is **gone**: the evidence-supplying commits now
happen per block, upstream of Finalize, so evidence is recorded from real hashes
and the Finalize commit no longer owes anything to the evidence field. The order
is internally consistent and completes with **no backfill**.

**Verdict — F-2 (Finalize tail): CLEAR** (same resolving line, implement.md:18,
which scopes the Finalize commit and moves the evidence-bearing commit per block).

---

## Adversarial sweep — any NEW step forcing improvisation?

Checked for a literally-unsatisfiable or inference-forcing step in the fixed text:

- **Commit not named in the 4-word outline shorthand.** implement.md:41 renders
  the per-block loop as "dispatch → wait → gate → advance"; "commit" is not one of
  the four words. But implement.md:18 (Execution model) unambiguously places the
  commit "when a block's build work is done … then dispatch the block's review" —
  i.e. between wait and gate. A driver reads the whole command, and line 18 leaves
  no ambiguity about commit timing. **Observation only, not a finding** — no
  improvisation is forced; the shorthand just doesn't restate line 18's substep.
- **Two leaves / one block commit / one cited test.** Satisfiable as written
  (see Section 3) — task-ledger:16 defines evidence as whatever a reviewer cited,
  not a per-leaf-command mandate. Not a finding.
- **"Depends on: —" definition.** Line 17 quantifies over listed plans; the dash
  is the plan's no-deps sentinel → vacuous pass. Closed, not a finding.

**No new BLOCKER or WARN found.** Every previously-flagged step now has an
explicit line to obey.

---

## Summary

| old finding | class | verdict | resolving line |
|---|---|---|---|
| entry-WARN (ready-Status set unstated) | WARN | **CLEAR** | implement.md:17 |
| F-1 (test-leaf-less block, no skip authorization) | WARN | **CLEAR** | implement.md:26 |
| F-2 (commit/evidence contradiction, loop + Finalize) | BLOCKER | **CLEAR** | implement.md:18 |
| F-3 (exit gate had no FAIL branch) | WARN | **CLEAR** | implement.md:42 |

New findings: **none.** One non-blocking observation: the line-41 outline shorthand
"dispatch → wait → gate → advance" omits the commit substep that line 18 defines
authoritatively (no improvisation forced).

(Out of this task's scope but noted by the prior drive: D-1 — the line-12 Role
boundary still hard-codes the literal `.workspace/plans/<yymmdd-slug>/…` path; not
in the F-1/F-2/F-3/entry set and untouched by these fixes.)
