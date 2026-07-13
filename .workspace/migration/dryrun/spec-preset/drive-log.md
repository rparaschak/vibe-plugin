# Drive log — `spec-preset/spec.md`, decompose/materialize path

**Scenario input** (`$ARGUMENTS`): `add user accounts — registration/login, profile management, and an admin moderation panel`
**Driven artifact**: the composed `spec-preset/spec.md` (spec-plan-implement preset). Team-lead drives it line by line.
**Finding classes**: **BLOCKER** = unsatisfiable/contradictory as written · **WARN** = inference required (I say what I inferred).
All agent done-reports and `AskUserQuestion` answers below are simulated by me, plausibly.

Style: `> quoted line obeyed` → **Action** → **Finding** (if any).

---

## Environment note (before driving)

- **WARN-E1** — My brief says "Kernel skill copies (`task-ledger.md`, `team-protocol.md`, `review-protocol.md`, `research-protocol.md`) sit in the work dir." They do **not** (`ls` of the work dir shows only `spec-preset/`, `toy-plan/`, `drive-log.md`, `implement.md`, `plan.md`, `redrive-log.md`). The composed command references them only by skill *name* (`vibe-task-ledger`, `vibe-team-protocol`, `vibe-review-protocol`, `vibe-research-protocol`), so I can still drive the block→phase mapping without their bodies — but any rule that lives *inside* those skills (e.g. the exact Handoff-block format, WIP=1 mechanics) I take on faith from the name. Flag for the builder: the dry-run harness did not stage the kernel copies it promised.

---

## FIXED pre-loop steps vs. a WHAT-phase, fresh-start flow

### Outline 1 — Clock-in

> "**Clock-in.** Resolve the ledger's directory; `Grep -n '^## '` it for a section map; read only the header, Handoff block, Decision log, Open Questions, and open leaves — per `vibe-research-protocol` (never wide-read the ledger). Resume point = first leaf not `passing`. If resolving the target from `$ARGUMENTS` is ambiguous or inferred, confirm via `AskUserQuestion` before proceeding."

**Action** — This is a *fresh* spec built from a raw feature request, not a resume of an existing artifact. There is no ledger to resolve, and the spec's dir is not created until the FLOW's `First:` line (which runs *inside* the work loop). So on this run Clock-in has nothing to `Grep` and nothing to read. I treat it as: "is this a resume or a fresh start? → fresh → defer dir creation to `First:`, and the resume point is the first block (Product research)."

**Findings**
- **WARN-1 (ordering collision, guided by Blocks note)** — The fixed pre-loop Clock-in assumes the artifact *predates the run* ("resolve the ledger's directory"), but a spec **creates its own artifact mid-loop** in the `First:` step. On a fresh spec, Clock-in is vacuous; it is only meaningful on a *resume* of a `Draft` spec. The Blocks preamble ("resume point = first block not yet closed. No task ledger this phase; the spec IS the artifact") gives me exactly the remap I need for "resume point", so this is a guided inference, not a break.
- **WARN-2 (read-list names sections a spec does not have)** — Clock-in says read "the header, **Handoff block**, **Decision log**, Open Questions, and **open leaves**." The stamped `spec-template.md` has Problem / Behaviors / UX structure / Out of Scope / Assumptions / Open Questions — **no Handoff block, no Decision log, no leaves** (those are ledger/plan constructs). Three of the five named sections structurally do not exist in a spec. I degraded gracefully: read the header + Open Questions, treat the ledger-only sections as N/A. Not a BLOCKER (progress is possible) but the literal read-list is wrong for this phase and no mapping note covers it — the only note ("No task ledger this phase") is in the *Blocks* section, not attached to Clock-in.
- **No AskUserQuestion needed** — the target is unambiguous (a new feature); slug is *derived*, not selected among existing artifacts, so I did not fire the "ambiguous/inferred → confirm" clause here.

### Outline 2 — Gate check (entry)

> "**Gate check (entry).** Before any dispatch, confirm the ledger's Status / Open Questions / Dependencies are ready. Not ready → andon-cord per `vibe-team-protocol`; do not build on an unready artifact."

**Action** — On a fresh spec there is no ledger and no Status/Open Questions/Dependencies to confirm yet (they get created in `First:`/blocks 3–5). I treat the entry gate as vacuously satisfied for a fresh start; on a *resume* it would check the spec header's `Status`.

**Finding**
- **WARN-3 (entry gate N/A on fresh spec, no remap note)** — Unlike the work loop (which the Blocks preamble explicitly remaps), the entry gate gets **no** phase-mapping note anywhere in the FLOW. I inferred "vacuously satisfied on fresh start." Satisfiable, so WARN not BLOCKER, but the builder should note that the fixed entry gate has no fresh-start branch.

### Outline 3 — Work loop (fixed shape)

> "**Work loop (fixed shape).** Walk the blocks from the slot in order — one block fully closes before the next opens. Per block: **dispatch → wait → gate → advance**. … review each leaf against `vibe-review-protocol`; advance a leaf to `passing` only on reviewer-cited evidence and only you, per `vibe-task-ledger`; honor its stop conditions …"

**Action** — I walk the FLOW `## Blocks` in order, one at a time (WIP=1 over product phases). I substitute per the Blocks preamble: `leaf → block`, `passing → gate-passed`, "advance a leaf" → "close a block."

**Finding**
- **WARN-4 (only ONE block is a review-protocol gate; the fixed loop implies all are)** — The fixed loop says *every* block gates by "review each leaf against `vibe-review-protocol` … reviewer-cited evidence." In this spec, only **block 4 (Critique)** is a review-protocol gate; blocks 1/2/3/5/6 close on a done-report, an `AskUserQuestion` answer, or a materialization check — **not** a reviewer citation. The FLOW *does* bridge the one case: the Team line says the critic's score "is the spec's 'review' the fixed Role names," and block 4 repeats it. So the critique↔review mapping is guided; the other blocks' non-review gates are left to inference (I read each block's own gate from its FLOW bullet, which overrides the fixed "review each leaf").

---

## Work loop body — walking the FLOW `## Blocks`

### `First:` (setup, before block 1)

> "First: read `.workspace/constitution.md` (note constraining rules). Derive a kebab-case slug from the input (2–4 words, action-noun, preserve acronyms); the dir is `.workspace/plans/<yymmdd-slug>/` using today's date — create it and copy the stamped spec template in as `spec.md`, filling its header (`Created`, `Status: Draft`, `Depends on`, input)."

**Action**
- Read `.workspace/constitution.md`. *Simulated notes*: "auth must reuse the existing session middleware; admin/moderation actions must be audited."
- Derive slug: input → `user-accounts` (2 words, action-noun). Today = 2026-07-13 → `yymmdd` = `260713`. Dir = `.workspace/plans/260713-user-accounts/`.
- Create dir; copy stamped `spec-template.md` → `spec.md`; fill header: `Created: 2026-07-13`, `Status: Draft`, `Depends on: —`, `Input: "add user accounts — …"`.

**Finding** — Executable exactly as written. (Real artifact simulated at `toy-spec/260713-user-accounts/spec.md`.) One small note: **WARN-5** — the slug `user-accounts` is derived from the *whole oversized* input; after block-5 decomposition narrows this dir to just the auth piece, the slug is a mild misnomer. See WARN-9.

### Block 1 — Product research

> "1. **Product research** — the codebase-researcher fills `research.md`'s current-state map … every claim cited `file:line`. You read only the done-report Summary, never the full research."
> "   - Pass the absolute path of the stamped spec template — `.claude/vibe/templates/spec-template.md` — in every product-manager/product-designer brief … Pass the stamped research template — `.claude/vibe/templates/research-template.md` — in the codebase-researcher brief."

**Action** — Dispatch codebase-researcher; brief carries `.claude/vibe/templates/research-template.md`. *Simulated done-report Summary*: "`users` table (email, hashed_password) at models/user.py:12; session middleware at middleware/session.py:8; login endpoint auth/login.py:20 with tests tests/test_auth.py (covers login success/failure only). No registration, no profile fields beyond email, no admin/moderation surface." I read the Summary only. Block closes on done-report received.

**Finding** — Executable. Confirms the Part-1 resolution mattered: these two paths were `{{SPEC_TEMPLATE_PATH}}` / `{{RESEARCH_TEMPLATE_PATH}}` in the preset and had to be resolved to satisfy the grep gate (see Part-1 WARN-A).

### Block 2 — Frame the request

> "2. **Frame the request** — the product-manager returns the 2–3 highest-leverage forks … You relay them via `AskUserQuestion` and return the answers; you never analyze the research yourself."

**Action** — Dispatch PM (brief carries the spec template path). *Simulated PM forks*:
- **A** Registration activation: email-verify link **vs.** instant activation?
- **B** Admin moderation scope: user suspend/ban only **vs.** also content moderation?
- **C** Profile management: self-serve edit only **vs.** include avatar/media upload?

Relay via `AskUserQuestion`. *Simulated user answers*: **A** instant activation · **B** suspend/ban only · **C** self-serve edit, no media upload.

**Finding** — Executable as written; the "relay, don't analyze" boundary is clean.

### Block 3 — Draft behaviors

> "3. **Draft behaviors** — the product-manager drafts Problem, Behaviors (B-NNN), Out of Scope, Assumptions into `spec.md` per the template. You read only the terse done-report."

**Action** — Dispatch PM to draft into `spec.md`. *Simulated draft* (parent spec, pre-decomposition, spanning all three capabilities):
- B-001 (P1) register + instant login · B-002 (P1) login/logout · B-003 (P2) view/edit profile (display name, bio) · B-004 (P2) change password · B-005 (P1) admin views user list + suspend/ban · B-006 (P2) suspended user sees message · B-007 (P3) admin audit trail.
- Out of Scope: email verification, avatar upload, content moderation. Assumptions: ⚠️ reuse session middleware (confirmed via research); password hashing exists.

**Finding** — Executable.

### Block 4 — Critique gate + Lock

> "4. **Critique gate** — the critic scores the spec against its Product lens-set (this is the spec's "review" the fixed Role names); reconcile, don't rubber-stamp; cap at 3 revise cycles, then stop and report as-is; any unresolved finding → `## Open Questions`. Then **Lock the behaviors** …"

**Action** — Dispatch critic. *Simulated round 1 findings*: (F1) B-005 conflates "view list" + "suspend/ban" → split; (F2) B-006 is security-adjacent → bump P2→P1; (F3) no behavior covers a suspended user's *active session*. Reconcile: split B-005 → B-005 (view list) + B-008 (suspend/ban); B-006→P1; add B-009 (suspending invalidates active sessions). *Round 2*: critic passes. 2 cycles (< 3 cap). Open Questions: None. **Lock** the 9-behavior set.

**Locked parent behaviors**: B-001 register+login · B-002 login/logout · B-003 profile view/edit · B-004 change password · B-005 admin user list · B-006 (P1) suspended-user message · B-007 audit trail · B-008 admin suspend/ban · B-009 session invalidation.

**Finding** — This is the **one** block where the fixed work-loop's "review each leaf against `vibe-review-protocol`" literally lands, and the FLOW flags it explicitly (Team line + block-4 parenthetical). Clean. Corroborates WARN-4: the bridge exists here and only here.

### Block 5 — Size & decompose → **MATERIALIZE** (the adversarial focus)

> "5. **Size & decompose** — measure the locked behaviors + research Summary against one team's capacity. Overflow → the product-manager proposes seams (priority-first, then capability boundary); you put the split to the user via `AskUserQuestion` and record which behaviors land in WHICH SPEC, wired by `Depends on` (an acyclic DAG). Fits in one → no split. Then MATERIALIZE the split — for each spec beyond this one: create its `.workspace/plans/<yymmdd-slug>/` dir, copy the stamped spec template in, move its behaviors over renumbered LOCAL from B-001, set its header (`Depends on`, `Status: Draft`); each is left `Draft` for its own later `/vibe:spec` pass (UX, critique, readiness gate)."

**Action — measure**: 9 behaviors across three capabilities (auth, profile, admin-moderation) — comfortably over ~3–5 deliverables/stack for one team → **overflow → decompose**.

**Action — seams** (PM proposes, priority-first then capability boundary):
- **auth-accounts** (foundational; others depend on it): B-001, B-002. → stays in THIS dir.
- **user-profile** (depends on auth): B-003, B-004.
- **admin-moderation** (depends on auth): B-005, B-006, B-007, B-008, B-009.

Put the split to the user via `AskUserQuestion` ("3 specs: auth-accounts / user-profile / admin-moderation, wired auth ← profile, auth ← admin — approve?"). *Simulated answer*: approved.

**Action — MATERIALIZE** the two siblings (executing the sub-steps verbatim):

Sibling **user-profile** (`toy-spec/260713-user-profile/spec.md`):
- dir `.workspace/plans/260713-user-profile/` ✓ · copy stamped template ✓
- behaviors moved, **renumbered LOCAL from B-001**: B-001 (P2) view/edit profile · B-002 (P2) change password ✓
- header: `Depends on: 260713-user-accounts`, `Status: Draft` ✓ · left `Draft` (no UX/critique/readiness this run) ✓

Sibling **admin-moderation** (`toy-spec/260713-admin-moderation/spec.md`):
- dir `.workspace/plans/260713-admin-moderation/` ✓ · copy stamped template ✓
- behaviors moved, **renumbered LOCAL from B-001**: B-001 (P1) user list · B-002 (P1) suspend/ban · B-003 (P1) suspended message · B-004 (P1) session invalidation · B-005 (P3) audit trail ✓
- header: `Depends on: 260713-user-accounts`, `Status: Draft` ✓ · left `Draft` ✓

Parent (this dir) retains B-001, B-002 (already contiguous from B-001 — no renumber needed).

**Findings**
- **Sub-steps executable as written** — dir / template-copy / renumber-local / header / left-Draft all ran without improvisation. The three concrete artifacts are in `toy-spec/`.
- **WARN-6 (materialize header sub-step names only 2 of 4 fields)** — "set its header (`Depends on`, `Status: Draft`)" names only two header fields; the template header also has `Created` and `Input`. A sibling has no raw user request. I inferred `Created: 2026-07-13` and `Input:` = a decomposition provenance note ("(from decomposition of user-accounts) …"). Builder should say what a materialized sibling's `Input`/`Created` should be.
- **WARN-7 (parent renumber unspecified)** — "renumbered LOCAL from B-001" is instructed for the *siblings* only. Here the parent's retained behaviors happened to already be B-001/B-002 contiguous, so no gap appeared — but if the retained set had been, say, B-003/B-006, the FLOW gives **no** instruction to renumber the *parent* after extraction, and its readiness gate ("every behavior … one line … from B-001") could then fail. Latent gap; I got lucky with the seam.
- **WARN-8 (cross-cutting behavior placement is a judgment call)** — B-009 "suspending invalidates active sessions" spans admin (the trigger) and auth (the session primitive). The FLOW says "priority-first, then capability boundary" but gives no tiebreak for a behavior that straddles two capabilities. I placed it in admin-moderation (it is observable in the moderation flow; the session *mechanism* is the plan's HOW, not a behavior). Defensible but an inference.
- **WARN-9 (no re-slug rule for the primary dir / which piece the primary becomes)** — The FLOW says "for each spec **beyond this one**" but never says which decomposed piece THIS dir becomes, nor whether to re-slug it. I made the primary = the foundational auth piece and kept the dir `260713-user-accounts` (now narrower than its slug implies). A builder-facing decision: does the primary keep the broad slug, or get re-slugged (e.g. `auth-accounts`)? Left ambiguous.

### Block 6 — Design UX (conditional)

> "6. **Design UX** (only if the feature is user-facing AND the project's `product-design` skill resolves (checking for a `.claude/skills/<name>/` dir is fine — it isn't app code)) — the product-designer writes `spec.md`'s `## UX structure`; `--design` / `--no-design` in `$ARGUMENTS` overrides the skip either way. …"

**Action** — Primary spec (register/login/logout) is user-facing. Check `.claude/skills/product-design/` → *simulated: present*. No `--no-design` in `$ARGUMENTS` → run UX. Dispatch product-designer; it writes `## UX structure` into the primary `spec.md` (register/login pages, AuthCard, empty/loading/error states — see `toy-spec/260713-user-accounts/spec.md`).

**Finding** — Executable. UX runs **only** for the primary this run; the two siblings are `Draft` and get their UX in their own `/vibe:spec` passes (consistent with block 5's "left Draft"). The presence of `## UX structure` on the primary is the FE-bearing flag `/vibe:plan` later reads.

---

## Spec readiness gate (the primary's own exit gate)

> "Before Status → Ready for Plan, confirm: Open Questions is None · every behavior is one observable, testable line with a user-value priority · Out of Scope and Assumptions present (each ⚠️ high-impact assumption confirmed …) · if user-facing, `## UX structure` is present · the decomposition (if any) materializes each spec (own dir, local B-ids, Status) with its behaviors and `Depends on` edges — the lead confirms this gate before the Finalize state-flip … A blocked spec finalizes to `Status: Blocked — Open Questions`, never Ready for Plan."

**Action — check the primary against each clause**:
- Open Questions None ✓ · B-001/B-002 each one observable/testable line with P-priority ✓ · Out of Scope + Assumptions present, ⚠️ session-middleware assumption confirmed ✓ · user-facing → `## UX structure` present ✓
- **Decomposition clause** — check the materialized siblings: user-profile (own dir ✓, local B-001/B-002 ✓, Status Draft ✓, behaviors present ✓, `Depends on: 260713-user-accounts` ✓); admin-moderation (own dir ✓, local B-001..B-005 ✓, Status Draft ✓, behaviors present ✓, `Depends on: 260713-user-accounts` ✓). Edges are acyclic (both point only at the foundational spec).

**Findings**
- **Decomposition clause is checkable as written** — it enumerates exactly own-dir + local-B-ids + Status + behaviors + `Depends on` edges, every one of which I materialized in block 5. Direct one-to-one check, no improvisation. This is the strongest part of the flow.
- **WARN-10 ("each spec" scope, and it does NOT require siblings to be Ready)** — "materializes **each** spec" — I read "each spec in the decomposition set"; the primary satisfies it trivially (it has its own dir/B-ids/Status inherently). And the gate checks siblings are *materialized*, **not** `Ready for Plan` — consistent with "left Draft." Coherent, but "each" is slightly loose (does it include the primary?). Minor.
- **WARN-11 (Report's "why skipped" conflates two skip-reasons)** — the gate's Report line asks "UX designed or why skipped." For the siblings, UX was neither designed nor "skipped for purely technical work" (block 6's skip reason) — it was **deferred to their own pass**. I report "deferred — sibling left Draft," a third reason the Report grammar doesn't name.

---

## Finalize (Outline 4 — after `commit`/`archive` opt-out drops)

> "**Finalize.** In this order — load-bearing: evidence recorded (Verified line where applicable) → learnings captured → state-flip → (if applicable) merge-back → write the Handoff block per `vibe-task-ledger` → tear down the team so no teammate is left running, per `vibe-team-protocol`. Then report; do not auto-start the next phase — the user reviews first."

**Coherence check after the opt-out drops** — `commit` and `archive` arrows are gone and the "and never archive a Blocked ledger" preamble clause is dropped. Remaining chain: *evidence recorded → learnings captured → state-flip → (if applicable) merge-back → write the Handoff block → tear down → report*. No dangling arrow, no orphaned clause, reads coherently. (Byte-identical Finalize line to the reference `plan.md` line 44 — confirms the opt-out composition.)

**Action — walk the chain**:
- *evidence recorded (Verified line where applicable)* — spec builds no code; "where applicable" → N/A, skip cleanly.
- *learnings captured* — see WARN-12.
- *state-flip* — flip primary `spec.md` `Status: Draft → Ready for Plan`. Siblings stay `Draft`. **This is the core Finalize action.** ✓
- *(if applicable) merge-back* — worktree off / N/A → skip (guard fires cleanly).
- *write the Handoff block per `vibe-task-ledger`* — see WARN-13.
- *tear down the team* — teammates dispatched this run: codebase-researcher, product-manager, critic, product-designer → tear all down. ✓
- *report; do not auto-start* — emit the readiness-gate Report; do not auto-run `/vibe:plan`.

**Findings**
- **WARN-12 (learnings step vs. "no learnings file this phase")** — Finalize says "learnings captured," but the FLOW's Spec-artifact bullet says "no learnings file this phase … the Finalize handoff is a one-line resume note in the report." I mapped "learnings captured" → the one-line resume note in the report (no file written). Guided by the FLOW, but the fixed word "captured" implies a persisted artifact that this phase deliberately does not create.
- **WARN-13 (Handoff-block collision — fixed text points at a skill this phase disowns)** — Finalize says "write the Handoff block per `vibe-task-ledger`," but the FLOW says there is **no task ledger** this phase and "the Finalize handoff is a one-line resume note in the report, **not a spec section**." I did **not** write a ledger Handoff block; I emitted a one-line resume note in the report instead. The FLOW's Spec-artifact bullet supplies the remap, so it is satisfiable (WARN, not BLOCKER) — but the fixed Finalize sentence references a `vibe-task-ledger` construct that does not exist in a spec, the most pointed FIXED-vs-flow collision in the Finalize step.

---

## Final report (what the driven command would emit)

**Specs produced**
| Spec (dir) | Local B-range | UX | Status |
|---|---|---|---|
| `260713-user-accounts` (auth) | B-001–B-002 | designed (register/login/logout) | **Ready for Plan** |
| `260713-user-profile` | B-001–B-002 | deferred (left Draft for own pass) | Draft |
| `260713-admin-moderation` | B-001–B-005 | deferred (left Draft for own pass) | Draft |

**`Depends on` edges (acyclic DAG)**: `user-profile → user-accounts` · `admin-moderation → user-accounts`.
**Open Questions**: None (all forks resolved via `AskUserQuestion`; critique reconciled in 2 cycles).
**One-line resume note (handoff)**: "`260713-user-accounts` is Ready for Plan — run `/vibe:plan` on it; the two `Draft` siblings each need their own `/vibe:spec` pass (UX/critique/readiness) before planning."

---

## Verdict on the adversarial question

No **BLOCKER** (nothing was unsatisfiable/contradictory to the point of halting) — but the FIXED skeleton's ledger-and-leaf vocabulary collides with the WHAT-phase mapping at **five** points, rescued each time by a FLOW note or graceful degradation:
1. Clock-in resolves/greps a pre-existing ledger the fresh spec doesn't have (WARN-1) and names spec-absent sections (WARN-2).
2. Entry gate has no fresh-start branch (WARN-3).
3. Work loop implies every block is a review-protocol gate; only critique is (WARN-4).
4. Finalize "learnings captured" vs. "no learnings file" (WARN-12).
5. Finalize "write the Handoff block per `vibe-task-ledger`" vs. "no ledger; resume note in the report" (WARN-13).

The **materialization** sub-steps and the **readiness gate's decomposition clause** are the cleanest, most executable parts of the flow — checkable one-to-one against what I built, needing only the minor inferences in WARN-6/7/8/9.
