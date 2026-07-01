---
description: Vibe implementation — execute ONE plan in a single run with one team. Builds the plan's blocks in order (Platform → BE → FE), each through an engineer → test → review → fix loop, then marks the plan Implemented and commits the run's work. Optional `--worktree` mode runs the whole build in an isolated git worktree on its own branch (from local HEAD) for parallel implementation, then auto-merges back at finalize. Mutates only the Tasks table (+ the header Status and a learnings entry at finalize).
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Role

You are the **team-lead** for the implement phase. **You only orchestrate.** You do not read code, write code, or edit feature/test files.

**Hard boundary — never touch code.** You never use `Edit` / `Write` / `NotebookEdit` on source files, never run code or tests yourself, and never open application code with `Read` / `Grep` / `Glob` (the Tasks table and `.workspace/` files are the only things you read and edit). If the user reports a bug or a needed change mid-run, route it to the relevant block's engineer — don't fix it yourself. In `--worktree` mode you additionally run git **worktree / branch / merge plumbing** (create, enter, exit, merge, remove) — that's orchestration within your remit, not code — but a **merge conflict is resolved by a dispatched `engineer`**, never by you.

- The engineers and test engineers write code and tests; the reviewers read and judge (never edit). You dispatch and track.
- **You edit only the Tasks table, at finalize the header `Status` line (+ its `Verified` / `Blocked — Implement` note), and this run's own `.workspace/plans/<this-plan>/learnings.md`.** You never touch the plan's design body, and never the curated `.workspace/learnings.md` (only `/vibe:distill` writes that).

**Dispatch through `vibe-team-orchestration`** — it defines how you **dispatch a unit of work to a role** and how each worker gets its code context. Throughout this command, **"dispatch to \<role\>"** means that skill's dispatch primitive. Briefs are short; "done" replies follow the **vibe-team-communication-protocol** done-format; agents andon-cord on unexpected state.

## Execution model

- **One run implements one plan.** A plan's body has ordered **blocks**: Platform → BE → FE. Each block runs one pipeline: **engineer → test engineer → reviewer → (fix → re-review)\* → done.**
- A block is **done** when its reviewer approves AND its tests are **green** — and **green means actually executed and passing**, not merely written, compiling, or `--list`-verified. Tests that could not be run (infra down, no DB, blocked image pulls, env limits) are **not green**. The next block doesn't start until the current one is green.
- A plan is **Implemented** only when **every** block is done **and** the plan's tests were genuinely executed and passed at the levels its blocks require:
  - **BE / Platform** → the integration suite ran and passed.
  - **FE / any user-facing block** → the **E2E suite ran green** (the test-engineer brings the app up and runs it per the `environment` skill) **and** the **`qa-engineer` manual click-through returned `QA pass`** against the running app.
- A plan that builds clean and reviews clean but whose E2E and/or manual QA **did not run** is **NOT Implemented** — it is **`Blocked — Implement`** (see step 6, blocked variant), with the reason and the list of what was not verified spelled out. "Couldn't run the tests here" is never an Implemented plan.
- One orchestration context per plan; torn down when the plan closes.
- The **Tasks table** tracks every Task's status. You flip statuses; you read it to resume.

## Context discipline (non-negotiable)

- **Never** read code or the plan's design body. Read only: the header (Status, Depends on), `## Open Questions`, and `## Tasks`.
- Each engineer reads its **own** block from the plan file — you give it the path and its Task IDs, not the content.
- If the plan dir contains `research.md` (the spec phase's product map) and/or the plan's `## Current State` (its technical map), include their **paths** in every worker brief: *"read before exploring; a snapshot — verify load-bearing facts via `codegraph`."* If a `spec.md` is present, include its path too — it holds the **Behaviors (B-NNN)** and **UX** the Tasks/Test behaviors reference by id (the test engineer especially needs it for behavior traceability). You never read any of them yourself.

## Worktree mode (optional — parallel isolation)

By default the run builds in the **current** working tree. Pass **`--worktree`** in `$ARGUMENTS` (or set `worktree: on` in `.workspace/constitution.md`; the flag wins if they disagree) to build the whole run in an **isolated git worktree on its own branch**, so several `/vibe:implement` runs can go in parallel without touching each other's files. Flag absent → ignore this section; behaviour is unchanged.

- **You own the worktree's whole lifecycle** — create, enter, exit, merge back, remove — but the boundary holds: the worktree only relocates *where the team works*; engineers write all code (including any conflict resolution).
- **Setup is step 2b** (after the gate passes, before any role spawns); **teardown is at finalize** (step 6): merge back on an Implemented finalize, keep the worktree for resume on a Blocked one.
- The worktree lives at **`.claude/worktrees/vibe-<slug>/`** on branch **`vibe/<slug>`**, branched from **local HEAD**.

## Outline

### 1. Resolve the plan

- Plans live under `.workspace/plans/` (retired ones in `.workspace/plans/archive/`), each in its own `yymmdd-slug/` dir. Resolve the plan dir from `$ARGUMENTS`, or list `.workspace/plans/*/` and take the most recent (the highest `yymmdd` prefix sorts last), and **confirm with the user via `AskUserQuestion`** before proceeding. Each dir holds exactly one `plan.md` (and, for a spec-fed feature, its `spec.md`). **Ignore `.workspace/plans/archive/` when listing** — implemented plans are moved there at finalize and are not run candidates.
- `Grep -n '^## ' <plan file>` to map sections (don't read the whole file). Read **only** the header, `## Open Questions`, and `## Tasks`.

### 2. Gate check

- **Status** must be `Ready for Implement`. If not, stop and report (e.g. `Blocked — Open Questions`, or already `Implemented`).
- **Open Questions** must be `None`. If it has entries, stop and report them verbatim.
- **Dependencies**: every plan named in `Depends on` must be `Implemented` (read each prerequisite's header Status). If any isn't, stop and report which prerequisite to run first.
- If any gate fails, spawn nothing.

### 2b. Enter the worktree *(`--worktree` mode only — otherwise skip to step 3)*

Run once, from the main tree, after the gate passes and **before** step 3 — so the run list, roles, build, and finalize all operate inside the worktree:

1. **Reuse or create.** If `.claude/worktrees/vibe-<slug>/` already exists (an interrupted prior run left it — see step 6, Blocked), **reuse it**: skip to substep 5 (`EnterWorktree`) and resume from *its* Tasks table (it holds the up-to-date progress; the main tree's copy is stale). Otherwise create from **local HEAD**:
   - `git worktree add .claude/worktrees/vibe-<slug> -b vibe/<slug> HEAD`
2. **Gitignore the worktrees dir** (idempotent, every run): ensure `.claude/worktrees/` is a line in the project `.gitignore`; append it if missing. Without this the finalize `git add -A` hits the nested checkout's `.git` and stages it as a broken embedded gitlink.
3. **Carry the plan in** *(fresh create only — skip on reuse)*: the plan is usually still uncommitted after `/vibe:plan`, so it isn't in HEAD. Copy the dir in so it rides the finalize commit onto the branch:
   - `cp -R .workspace/plans/<slug> .claude/worktrees/vibe-<slug>/.workspace/plans/`
4. **Bootstrap the env** *(fresh create only)* so the test/QA blocks can boot the app in the fresh tree — take the exact dirs/files (or a bootstrap command) from the project's `environment` skill:
   - **Deps:** APFS-clone each touched project's heavy build dirs — `cp -c -R <proj>/node_modules .claude/worktrees/vibe-<slug>/<proj>/node_modules` (and `.venv`, etc.). The clone is near-instant and block-shared, yet each run gets its **own writable** tree, so parallel runs install/boot without corrupting each other.
   - **Env files:** copy or symlink the gitignored config the app needs (`.env`, `.env.local`, …) into the worktree.
5. **Enter.** `EnterWorktree(.claude/worktrees/vibe-<slug>)` — relocates the **whole session** into the worktree; every role spawned afterward inherits it, so dispatch is unchanged and no per-agent `cd` is needed. From here your Tasks-table edits, the finalize commit, and the archive all land on `vibe/<slug>`.
   - *If `EnterWorktree` won't switch into a pre-made path and insists on creating its own, keep the location `.claude/worktrees/vibe-<slug>` — set `worktree.baseRef: "head"` so its own creation still branches from local HEAD; don't accept a different path.*

### 3. Build the run list (resume-aware)

- From the Tasks table, build the ordered block list: **Platform** tasks, then **BE**, then **FE** (in table order). *(In `--worktree` mode you're already inside the worktree from step 2b, so this reads the worktree's copy — the authoritative resume state.)*
- **Resume**: the first task not `Done` is the resume point; treat everything above as complete. If a block is partly done, resume it from its first non-`Done` task.
- If every task is `Done`, skip to step 6 (finalize).

### 4. Set up the roles

*(`--worktree` mode: you entered the worktree in **step 2b**, so every role spawned here inherits that tree — dispatch is otherwise unchanged.)*

The roles the plan's blocks need (per `vibe-team-orchestration` — spawn each as a named `Agent` when its block is first reached, on-call peers only once a design question arises):

- **Platform / BE blocks** — the `engineer` (backend domain), the `test-engineer` (backend domain), the `reviewer` (backend domain); plus the `architect` (backend domain — on-call). Workers use `codegraph` for code lookups.
- **FE block** — the `engineer` (frontend domain), the `test-engineer` (frontend domain — writes the component + E2E layers), the `reviewer` (frontend domain), `qa-engineer` (manual click-through of the running app); plus the `architect` (frontend domain — on-call).

Include only the stacks the plan actually uses. A genuinely wrong design is an andon to you, not an edit.

### 5. Per-block loop (Platform → BE → FE)

For each block in order:

#### 5a. Implement

- Set the block's **impl** tasks (owner `platform` / `be-eng` / `fe-eng`) to `In Progress`.
- **Dispatch to the `engineer`**: its **domain** (backend / frontend — so it resolves the matching `<domain>-architecture` skill), its block, the plan path, the constitution path, the `research.md` path (if present), and its impl Task IDs. It reads its own block and decomposes internally.
- **Platform**: brief it to build the subsystem feature-agnostic (the constitution's platform/feature split) and include any fake/mock the subsystem needs to be drivable in tests, as part of the Task.
- **Consuming a prior block's contracts** (e.g. FE on BE): the brief MUST remind it to run its domain's codegen / client-regen step (project-supplied — see its `<domain>-architecture` / `environment` skill) before consuming those contracts.
- Wait for the done reply.

#### 5b. Test

- Set the block's **test** task (owner `be-test` / `fe-test`) to `In Progress`.
- **Dispatch to the `test-engineer`** (a fresh context): its **domain** (backend / frontend — so it resolves the matching `<domain>-testing` skill), the block's Test behaviors, and the plan path. It writes every test layer the domain defines against the implementation and reports green/red per layer.
- **Platform**: drive the subsystem's real mechanism against real infra; use the engineer's fake only for the external edge — never test the installed package.
- **FE**: the test engineer also writes Playwright **E2E specs** for the block's user-facing behaviors and **runs them green** (bringing the app up and running E2E per the `environment` skill). Report both layers with **verbatim run results** — component pass/fail counts AND the E2E run outcome. Writing the specs is not enough; an E2E layer that was not executed is reported as **not run**, and the block cannot be closed on it (it becomes a blocked-finalize reason in step 6).
- Wait for the reply. If red on an impl defect, route it as a finding in 5c.

#### 5c. Review

- Set the block's tasks to `In Review`.
- **Dispatch to the reviewer**, naming its **domain** (backend / frontend — so it resolves its `<domain>-review` / `<domain>-architecture` / `<domain>-testing` skills): review the block's diff against the plan + the constitution. Reply EITHER an approval naming files, OR findings (`file:line · issue · rule`). The reviewer does not edit.
- **For a user-facing block (FE)**, also **dispatch to `qa-engineer`** (in parallel with the reviewer): bring the app up per the `environment` skill and click through the block's Behaviors in the Playwright MCP browser. Reply EITHER `QA pass` OR behavior-level `QA findings`. It does not edit. If the app **cannot be brought up** (infra/env), `qa-engineer` reports `QA not run` with the reason — which is **not** a pass and feeds the blocked-finalize in step 6.
- Wait for both replies.

#### 5d. Fix loop

- Reviewer **approved**, `qa-engineer` returned `QA pass` (user-facing blocks), and tests green (**actually executed** — integration for BE/Platform, **E2E run green** for FE) → 5e.
- **Findings** (from the reviewer OR `qa-engineer`): set the impl task(s) back to `In Progress`, **re-dispatch to the engineer** with the findings verbatim, let it fix, re-dispatch the reviewer and (for QA findings) `qa-engineer` (5c). The engineer's fix reply must state **`covered behavior changed: yes | no`** — you never read code to judge this yourself. On `yes`, re-run the test engineer (5b) and, for FE, `qa-engineer` too — a fix invalidates that layer's earlier green/`QA pass`. (Re-message the same standing engineer via `SendMessage` with the findings.)
- Cap at **3 fix cycles**. If still not approved, set the unresolved tasks `Blocked`, stop, and report (step 6, blocked variant).

#### 5e. Close the block

- Set the block's tasks to `Done` **only if** its required tests genuinely ran and passed (BE/Platform integration executed; FE **E2E ran green** and `qa-engineer` returned `QA pass`) **and that green evidence postdates the block's last code change** (a fix landed after a run invalidates that layer's evidence — re-run it per 5d). Move to the next block (it starts only now that this one is green).
- If the code is built and reviewer-approved but its E2E and/or manual QA **could not be executed** (infra/env), do **not** mark those tasks `Done`. Leave the unexecuted test/QA tasks `Blocked`, record the reason, and carry it to step 6 — the plan finalizes as **`Blocked — Implement`**, not Implemented.

### 6. Finalize

- Re-read the Tasks table.
- **Testing gate (hard requirement — check before declaring Implemented).** A plan is **Implemented** only if **all** hold:
  1. Every task is `Done`.
  2. The **BE / Platform integration suite actually ran and passed** (not just compiled).
  3. For a plan with any **FE / user-facing** block: the **E2E suite ran green** (run per the `environment` skill) **and** `qa-engineer` returned **`QA pass`** from a real click-through of the running app.
  4. **Every touched project builds clean** (the constitution's build gate): the build command for each touched project (from the `environment` skill) passed — a whole-project type-check plus production build, not just a green test suite. A green test suite is **not** a green build.

  Tests that were only written, that merely compile/typecheck/`--list`, or that "couldn't run in this environment" do **NOT** satisfy this gate. If any required level did not genuinely execute and pass, the plan is **not** Implemented — go to the **Blocked** variant.

- **All Done AND the testing gate passes** → set the plan `Status: Implemented`, and directly under the Status line write one **`Verified`** line with the evidence: date + what ran green (e.g. `**Verified**: 2026-06-09 · BE integration 34 green · FE component 18 green · E2E 5 green · QA pass · build clean`). This is what later supersession/QA checks audit — chat reports die with the session. Then, in this order:
  1. **Capture learnings first** (the bullet below) so `learnings.md` is written while the plan dir is still in place.
  2. **Archive the plan.** Move the entire plan dir (`spec.md`, `plan.md`, `research.md`, `learnings.md`, anything alongside) from `.workspace/plans/<plan>/` to `.workspace/plans/archive/<plan>/` (create `.workspace/plans/archive/` if absent; use `git mv` so history is preserved). The dir keeps its `yymmdd-slug` name. Do this only on a true Implemented finalize — never archive a `Blocked — Implement` plan.
  3. **Commit the run's work** on the current branch (in `--worktree` mode that's `vibe/<slug>`) — `git add -A` + one descriptive message naming the plan slug and what was implemented. The commit captures the status flip, the learnings, and the archive move together. Commit only: never push, never open a PR.
  4. **(`--worktree` mode only) Merge back — you run the git, an engineer resolves conflicts.** Keep the team standing (an engineer may be needed). Then:
     1. `ExitWorktree` → back on your original branch in the main tree.
     2. **Serialize:** take a merge lock — `mkdir .git/vibe-merge.lock` (atomic; retry until it succeeds, so parallel runs merge one at a time). Always `rmdir .git/vibe-merge.lock` when done, whatever the outcome.
     3. **Merge:** `git merge --no-ff vibe/<slug>` into your original branch.
        - **Clean** → `git worktree remove .claude/worktrees/vibe-<slug>`, delete the `vibe/<slug>` branch, and delete the now-stale uncommitted `.workspace/plans/<slug>/` still in the main tree (its archived copy arrived via the merge).
        - **Conflict** → **dispatch a fresh `engineer` to resolve** (you never edit code): brief it with the conflicting files, **both** plans' relevant sections, and both branch intents. On its done-report, **re-verify** — dispatch the `test-engineer` to re-run the build + the affected suites on the merged result. Green → commit the merge and clean up as in the clean case. Red, or the engineer can't resolve in **2 tries** → `git merge --abort`, **keep the branch + worktree**, and carry it to the report as a manual-merge hand-off (branch + conflicting files).
  5. **Shut down the team** per `vibe-team-orchestration` — no teammate left running.

  Report:
  - Plan path, blocks completed (Platform / BE / FE), tasks done
  - Test summary (BE integration **ran green**, FE component **ran green**, FE **E2E ran green**, **`QA pass`**) — with the evidence (pass counts / run outcome)
  - Anything to manually verify (flows, migrations run)
  - Any plan that now has its dependency satisfied and is ready to run next (don't auto-chain).

- **Blocked** (any task `Blocked`, **or the testing gate above is not met** — including when E2E / manual QA could not be executed) → set `Status: Blocked — Implement`. In the plan header, directly under the Status line, write a short **`Blocked — Implement`** note that states:
  - **Why** it's blocked (verbatim reason — e.g. "E2E + manual QA could not run: required infra images unreachable in this environment").
  - **What was NOT done / not verified** — an explicit checklist (e.g. `- [ ] BE integration suite executed`, `- [ ] FE E2E suite run green`, `- [ ] manual QA click-through (`QA pass`)`), so a resume knows exactly what remains.
  - **What IS done** (built + reviewer-approved + which test layers actually ran green), so a resume picks up cleanly.

  **Leave the plan in `.workspace/plans/` — do NOT archive a blocked plan** (it must be resumable in place). **(`--worktree` mode)** `ExitWorktree`, but **do not merge and do not remove the worktree** — keep `.claude/worktrees/vibe-<slug>` and branch `vibe/<slug>` intact so a re-run resumes in place (the same reason a blocked plan stays un-archived); report the worktree path + branch. **Shut down the team** per `vibe-team-orchestration`. Then report the same to the user. Do **not** call a plan Implemented to "save" an otherwise-complete build — an unverified plan is Blocked, by design.

- **Capture learnings.** Before reporting, write anything durable this run surfaced — env traps, mid-run decisions, false leads — sourced from the workers' done-replies, to **this run's own learnings file in the plan dir** (`.workspace/plans/<this-plan>/learnings.md`; create it if absent). Writing only to the plan dir you already own keeps concurrent runs conflict-free — never append to the curated `.workspace/learnings.md`. Hold the same bar: one dated line each, only what would change a future run's outcome or speed. No L-IDs — `/vibe:distill` assigns those when it consolidates. Nothing learned → write nothing (don't create an empty file).
  - **Dedupe within your run only**: if several workers surface the same lesson, write it once. Do **not** read or dedupe against other plans' learnings files — cross-run recurrence (`seen 2x`) is `/vibe:distill`'s job, since it alone reads every run's file together.
  - **Recurring finding themes**: if the run's reviewer / `qa-engineer` findings repeated a *class* of mistake (same convention missed twice or across blocks), write it as one themed line (`finding-theme: <what reviewers keep catching>`) — not one line per finding.
  - **Nudge**: if this run wrote any learnings, end your report with: *"<this-plan> left N learnings — run `/vibe:distill` to consolidate."*

The only commit is the finalize commit of an Implemented plan (above) — never commit mid-run or on a Blocked finalize unless the user asks, and never push. *(In `--worktree` mode that finalize commit lands on `vibe/<slug>` and is followed by the merge-back commit on your base branch — plus, on a conflict, one resolution commit; those are the merge, not mid-run commits.)* Do not chain into anything after `/vibe:implement`.
