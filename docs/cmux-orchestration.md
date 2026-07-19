# vibe 2.x — Cmux orchestration (session-tier orchestration) — Design Doc

**Status:** proposed — architecture settled, execution checklist in §9 not yet run.
**Date:** 2026-07-19
**Companion docs:** `docs/harness-builder.md` (the shipped 2.0 design this extends; its "repo is the system of record" thesis is what makes this tier nearly free).

---

## 1. The decision

Add a **third, top tier of orchestration**: an **orchestrator** that drives a long-running loop of **sessions**, where each session runs one stamped harness command (`{{CMD_PLAN}}`, `{{CMD_IMPLEMENT}}`, `{{CMD_SPEC}}`) in a fresh context with its own **team-lead** and team.

The orchestrator receives exactly **two lifecycle messages per session** — started and finished — plus one bounded read of durable repo state. It never holds team context. Today the loop driver and the team-lead share one context and the loop costs ~100k tokens per plan→implement iteration; split into tiers, the session interior still costs ~100k but is **discarded with the session**, and the orchestrator pays under ~1k per iteration — hundreds of iterations per orchestrator context instead of a handful.

### Terminology (normative from this doc forward)

| Term | Means | Never means |
|---|---|---|
| **Orchestrator** | The session-tier driver: spawns cmux sessions, loops plan → implement → plan → …, reads only lifecycle + Status/Handoff | The in-session role that dispatches teammates |
| **Team-lead** | Manages the team **within** one session — dispatch, gates, ledger states (the role every stamped command puts you in) | Anything session-spawning; "orchestrates" is no longer used for this role |
| **Session** | One invocation of one stamped command in a fresh context (cmux pane, headless CLI run, remote session) | A subagent/teammate |

The words *orchestrate / orchestrator / orchestration* are **reserved for the session tier**. The in-session role is the team-lead; its verbs are *lead / manage / run / dispatch*. The rename is applied to live templates in §5.

---

## 2. Why this is nearly free (observed, not theoretical)

The whole interface an orchestrator needs **already exists and is durable in-repo** — harness-builder.md's Lecture-3 thesis (the repository is the system of record) did the heavy lifting in 2.0:

1. **Phase state is a closed enum in the plan header** — `Status: Draft → Ready for Implement → Implemented`, archive move on completion. The orchestrator's "what phase comes next" is a one-line Grep, not a conversation.
2. **The Handoff block** (`vibe-task-ledger`) is written at every Finalize — Verified now / Changed this session / Broken or unverified / Next best step. That is precisely the "finished" payload; nobody has to author a new report format.
3. **Fresh contexts resuming from durable state is already the contract** — `vibe-team-protocol`: teammates don't survive `/resume`; you re-spawn from the ledger, never from memory. Cmux orchestration is that same property used *deliberately*: every phase is a fresh session, and nothing rides in the orchestrator's context except lifecycle facts.
4. **Stamped commands already end without auto-starting the next phase** — the seam between sessions is already cut; the orchestrator is just the thing standing on the seam.

Consequence: a session must not know or care whether a human or an orchestrator invoked it. **Stamped `plan`/`implement`/`spec` commands change zero lines for this feature.**

---

## 3. The building block (what the harness builder gains)

**Opt-in, not kernel.** Stamped only when parsed intent asks for it ("orchestrator", "endless loop", "autonomous cycle"). Four new stamp targets plus one generation-time decision:

### 3.1 `templates/kernel/orchestrator-protocol.md` → `HARNESS_ROOT/skills/vibe-orchestrator-protocol/SKILL.md`

Kernel-shaped (fixed text, referenced by name, never restated) but **conditional** — the 4 default-on kernel skills stay as they are. Normative content:

- **Two-message contract.** Per session the orchestrator processes exactly: *session started* and *session finished (exit code)*. No progress updates, no transcript reads, no streaming — the session's team-lead has **no channel** to the orchestrator by design (symmetry with the team tier: workers message done/andon only; sessions "message" started/finished only).
- **Bounded read rule.** After *finished*, read ONLY: the plan's `Status:` header + Handoff block (Grep-anchored, never a wide read) and the target backlog line. Never plan bodies, code, diffs, or session transcripts. The `vibe-research-protocol` ladder does not apply above the session boundary because the orchestrator never researches.
- **Session-level WIP=1.** One live session at a time — the same discipline the ledger applies to leaves. (Parallel worktree sessions are a v2 variant, §10.)
- **Stop conditions (numeric, andon-shaped).** Backlog empty → clean stop. Same phase on the same plan fails **twice consecutively** → stop, surface the Handoff verbatim (no third blind retry). Iteration cap (default **25 sessions/invocation**) → stop and report. Session exits non-zero with no Handoff written → andon immediately — an unreadable session is a structural problem, not a retry.
- **Boundary (hard rule).** The orchestrator never spawns teammates, never edits project source, never "fixes up" a session's output from above; its `Edit`/`Write` touch only `.workspace/backlog.md` checkmarks and its own run log. Anything wrong inside a session is the next session's team-lead's problem, dispatched with the Handoff as input.

### 3.2 `templates/scripts/session-run.sh.template` → `HARNESS_ROOT/scripts/session-run.sh`

The runner shim — same philosophy as `env-up.sh`/`test-run.sh`: **agents never improvise spawn commands.** The generation-time `SESSION_RUNNER` choice (cmux · headless host CLI · none) is compiled into this one script; the orchestrate command only ever calls:

```
HARNESS_ROOT/scripts/session-run.sh "<slash-command and args>"
```

Contract: print one `started` line, block until session exit, print one `finished <exit-code>` line. Nothing else on stdout. Self-verifying like the other scripts (`--check` spawns a trivial no-op session and asserts both lines + exit 0). Swapping runners later = restamp one script; zero lines change in the command.

The exact spawn invocation (cmux CLI syntax, `claude -p … --permission-mode …`, model/permission flags) is a **Discover slot** filled at stamp time from scout findings + the checklist gate — exactly how `backend-testing` fills its runner today. The template never hardcodes a CLI surface that will drift.

### 3.3 `templates/skeletons/orchestrator-skeleton.md`

A second skeleton beside `command-skeleton.md` — reusing the team-lead skeleton would be wrong-parented: its FIXED sections (dispatch/fan-out, clean-state exit gate, team teardown) are exactly what an orchestrator must **not** do. FIXED sections:

1. **Role** — boundary sentence: never spawns teammates; `Edit`/`Write` only for `.workspace/backlog.md` and the run log; references `vibe-orchestrator-protocol` by name.
2. **Loop (fixed shape)** — pick next unit → spawn via `session-run.sh` → wait → bounded read (Status + Handoff) → record one run-log line → decide next per the flow. One `{{LOOP_FLOW}}` slot supplies the per-preset phase graph — the ONLY variable middle, mirroring `{{FLOW}}`.
3. **Stop conditions** — by reference to the protocol skill, plus the generation-time iteration cap value.
4. **Finalize** — totals (sessions run, plans implemented, stops hit), backlog state, last Handoff verbatim if stopped on andon. No team teardown — there is no team at this tier.

Composition obeys `standards/composition-standard.md` in full (W-A…W-J apply; the standard's scope line gains this skeleton).

### 3.4 Per-preset loop flows + backlog seed

- `presets/plan-implement/orchestrate.md` — per backlog item: session `{{CMD_PLAN}} <item>` → gate `Status: Ready for Implement` → session `{{CMD_IMPLEMENT}} <slug>` → gate `Status: Implemented` + archived → check the backlog item off → next item.
- `presets/spec-plan-implement/orchestrate.md` — session `{{CMD_SPEC}}` first; the spec's decomposition seeds the backlog; then the plan→implement pair per item.
- `templates/workspace/backlog-template.md` → `.workspace/backlog.md` — an ordered checkbox list, one line per feature, plan slug appended once planned. The only artifact the orchestrator writes (besides its run log `.workspace/orchestrator/run-log.md`). Stamp-if-absent, user-owned — the user feeds the loop by editing this file.

### 3.5 build-harness changes

- **Parse:** orchestrator intent → three extra checklist rows (protocol skill · session-run script · `orchestrate` command row from the preset's loop flow). Absent intent → zero new rows; existing harnesses are untouched.
- **New generation-time decision:** `SESSION_RUNNER`, resolved like `HARNESS_ROOT`/`COMMAND_PREFIX` — `--runner cmux|host-cli|none` flag, else detect (`cmux` on PATH; host CLI known from the host gate), else surface at the checklist gate. `none` + orchestrator intent = andon at the gate, never a silent stub.
- **Autonomy is generation-time** (§4): `--autonomy gated|full`, default `gated`; a project wanting both stamps two commands (`orchestrate`, `orchestrate-gated`) per "a needed mode = stamp two commands". No runtime flags on the stamped command.

---

## 4. Autonomy vs. the "user reviews first" rule

Every stamped command ends: *report; do not auto-start the next phase — the user reviews first.* An endless loop looks like a violation. It isn't: that rule is a property of the **team tier**, where nobody above the team-lead exists to review. Invoking the orchestrate command **is** the user's standing review decision, scoped explicitly at generation time:

- **`gated` (default):** the loop pauses after every plan session (`AskUserQuestion`: proceed / edit plan first / stop) before spawning implement. Cheap for the user, catches bad plans before they're built.
- **`full`:** runs to a stop condition. For repos where the backlog itself is the review.

Either way the stop conditions of §3.1 bound the blast radius, and the run log makes an unattended loop auditable line by line.

---

## 5. Terminology sweep (applied with this doc)

| File | Before | After |
|---|---|---|
| `templates/kernel/team-protocol.md` (intro) | "…and the orchestration mechanics (team-lead)" | "…and the team-management mechanics (team-lead)" |
| `templates/kernel/team-protocol.md` (Role boundaries) | "**Team-lead** orchestrates: …" | "**Team-lead** manages the team: …" |
| `templates/skeletons/command-skeleton.md` (Role) | "You are the team-lead orchestrating {{ROLE_SUMMARY}}" | "You are the team-lead running {{ROLE_SUMMARY}}" |

Both templates bump a version (v1→v2) so the doctor propagates the rename to stamped projects on re-run. Going forward, the command/agent standards' audits treat "orchestrat…" applied to the team-lead as a naming defect (execution item, §9).

`.workspace/migration/` records and the SIMPLIFICATION-LOG are history — not rewritten.

---

## 6. What does NOT change

- The default-on kernel stays exactly 4 skills; `vibe-orchestrator-protocol` is conditional, like `product-design`.
- Stamped `plan`/`implement`/`spec` commands: **zero lines**. A session behaves identically under a human or an orchestrator — this is the property that keeps the tiers decoupled and testable in isolation.
- The team tier's two-message discipline (done/andon) is untouched; the session tier mirrors it rather than modifying it.
- `/vibe:build-flow`, `/vibe:distill`: unchanged in v1 (build-flow may later grow a session-tier flow shape, §10).

---

## 7. Known costs & risks (accepted, managed)

- **Runner CLI drift** (cmux and host CLIs change flags): confined to `session-run.sh` by construction; `--check` self-verification catches breakage before a 25-session run does; Discover-slot fill means the template never encodes today's flags.
- **Permission surface**: a spawned session needs its permission mode preconfigured (the shim encodes it; surfaced at the checklist gate). An orchestrator must never be the thing that escalates permissions.
- **Unattended-loop safety**: `gated` default, numeric caps, two-strike andon, session WIP=1, orchestrator barred from editing source. The failure mode is "stopped and reported", never "kept going creatively".
- **Cost opacity**: one run-log line per session (phase, slug, exit, Status observed, wall time) so the user can audit what an unattended loop spent.

---

## 8. Context-budget contract (the point, made testable)

Per iteration the orchestrator's context grows by: 2 lifecycle lines + one Handoff block (≤10 lines) + 1 backlog line + its own ≤3-line log entry. **Numeric gate for the self-test:** drive plan → implement → plan across 3 real sessions; the orchestrator transcript must stay **< 5k tokens** where today's single-context equivalent is ~100k. Same spirit as the ≤80-line command budget — a number, not a vibe.

---

## 9. Execution checklist (next session runs this; `vibe-task-ledger` schema when live)

1. Author `templates/kernel/orchestrator-protocol.md` (§3.1) — kernel-style, ≤70 lines.
2. Author `templates/scripts/session-run.sh.template` (§3.2) with `--check` and Discover slots for runner invocation + permission mode.
3. Author `templates/skeletons/orchestrator-skeleton.md` (§3.3) with the single `{{LOOP_FLOW}}` slot and builder comments matching command-skeleton conventions.
4. Author `presets/plan-implement/orchestrate.md` and `presets/spec-plan-implement/orchestrate.md` loop flows + `templates/workspace/backlog-template.md` (§3.4).
5. Extend `standards/composition-standard.md` scope to the orchestrator skeleton (fills: `DESCRIPTION`, `ROLE_SUMMARY`→orchestrator variant, `{{LOOP_FLOW}}`, iteration cap, `{{CMD_*}}` resolution unchanged).
6. Extend `commands/build-harness.md`: intent parse, `SESSION_RUNNER` + `AUTONOMY` resolution orders, three conditional checklist rows, gate surfacing.
7. Add the naming lint (§5) to `standards/command-standard.md` / `agent-standard.md` audits.
8. Self-test per §8's numeric gate on a live project; record under `.workspace/` migration-style.
9. README: promote the terminology table + the opt-in block once shipped; bump plugin version.

---

## 10. Open questions (with recommendations)

1. **Parallel sessions across worktrees** (session-tier fan-out): the ledger already scopes WIP=1 per worktree, but merge-back discipline between concurrently implemented plans is undefined. **Recommend defer to v2**; keep session WIP=1 now.
2. **`/vibe:build-flow` at the session tier** (ad-hoc loop flows, e.g. "migrate 40 endpoints, one session each"): natural once the orchestrator skeleton exists. **Recommend defer** until the preset loops have survived real use.
3. **Remote sessions as runner** (Claude web / cloud sessions instead of local cmux/CLI): the shim admits it without design change. **Recommend defer** until the local runner is proven.
