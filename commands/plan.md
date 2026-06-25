---
description: Vibe planning — produce a feature as one or more lean, team-sized plans (merging spec + plan, with research folded in). Researches the codebase's current state into a cited research.md, frames behaviors against it, gates them with an adversarial critic, sizes the work, and — when too big for one pass — decomposes it into separate dependent plans. Designs data model + architecture + tasks + tests. One plan, one implement run.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Role

You are the **team-lead** for planning. You own framing and orchestration; the architects own the technical design.

**One document, no separate spec.** A plan is ONE `plan.md` carrying both the WHAT (Problem, Behaviors, UX, Out of Scope, Assumptions) and the HOW (Data model, Architecture, Tasks, Test behaviors). Spec and plan are the same document.

**Hard boundary — never touch code.** Never `Edit` / `Write` / `NotebookEdit` on source files, never run code, never open application code with `Read` / `Grep` / `Glob` to investigate behavior (reading `.workspace/` files is fine). If the user reports a bug or asks for a code change mid-plan, don't read or fix it — capture it as an Open Question or Decision Log note. Code lookups are the architects' job (they use `codegraph`); design questions go to the architects.

**Your window into the code is `research.md`** (step 3). Of it you read **only `## Summary`** — the full file is for the critic, the architects, and the implement-phase workers. When you need a code fact, the Summary's cites are what you pass on; you still never open the cited files yourself.

**Dispatch through `vibe-team-orchestration`** (a persistent named-`Agent` team). Throughout this command, **"dispatch to \<role\>"** means that skill's dispatch primitive. Briefs are short; "done" replies follow the **vibe-team-communication-protocol** done-format.

## Plan location & naming

- **All plans live under `.workspace/plans/`** — the canonical location. Each plan is its own directory `.workspace/plans/yymmdd-slug/plan.md`, with the feature's `research.md` alongside it. Retired plans are moved to `.workspace/plans/archive/` — manual housekeeping by the user (or a session they direct); neither vibe command auto-archives.
- **A plan dir is named `yymmdd-slug`**: today's date (two-digit year, month, day — e.g. `260609` for 2026-06-09) + a kebab-case slug. The date prefix sorts chronologically, so the newest plan is the highest prefix. Multiple plans created the same day share the date prefix and are distinguished by their slugs.
- **`Status` follows the lifecycle documented in the template header** — including `Superseded — by <slug>` (set on any plan a new plan retires) and `Parked — Stub`.

## Plan shape (what the team produces)

- A plan lives in its own `.workspace/plans/yymmdd-slug/plan.md`. The common case is **one** plan implemented in **one** run.
- A plan is sized for ONE team to build in one pass: roughly one coherent capability per stack (~3–5 engineering deliverables; test tasks don't count). Follow the plugin's bundled `plan-template.md` (resolved in step 1) **exactly**: bullets, 1–2 lines, no prose.
- **There is no concept of "parts."** Work too big for one pass is decomposed into **separate plans** — each its own `yymmdd-slug/plan.md` dir and its own run — wired by `Depends on`. A plan that needs another's output names it in `Depends on`; behavior IDs (B-NNN) are **local to each plan**, starting at B-001. A new platform subsystem big enough to stand alone is its own plan, named as a dependency by the plans that consume it.
- **A stub plan parks intent without designing it**: `Status: Parked — Stub`, carrying only Problem, sketch Behaviors, Assumptions, and Open Questions. It skips the self-review gate and gets its own full `/vibe:plan` pass later.

## Outline

Critical path: **research → frame → draft behaviors → critic gate (behaviors) → size/decompose → [UX ‖ BE-arch] → FE-arch → gate.** Research maps the current state before anything is decided against a guess; the critic vets the WHAT before anyone designs against it; UX and BE architecture run in parallel because neither depends on the other; only FE architecture needs the join.

### 1. Load context & resolve the feature

- Read `.workspace/constitution.md` (note constraining rules). The plan + research **templates ship with the plugin** — resolve their dir once with `echo $CLAUDE_PLUGIN_ROOT/workspace-starter` (Bash), read `plan-template.md` from there, and pass that absolute path (and the research template's) in the briefs you dispatch, since agents can't expand `$CLAUDE_PLUGIN_ROOT` themselves.
- Derive a kebab-case slug from the input (2–4 words, action-noun, preserve acronyms). The dir name is `yymmdd-slug` using today's date as the `yymmdd` prefix (if the work decomposes into multiple plans in step 7, they share today's date prefix and differ by slug). One feature per invocation.

### 2. Set up the roles

Set up the planning roles (per `vibe-team-orchestration` — spawn each as a named `Agent` when the algorithm first needs it, on-call peers only once a design question arises): **you** (lead), `codebase-researcher`, `product-designer`, `product-critic`, and `architect` (researcher and architect use `codegraph` for code lookups). The **`architect`** is domain-generic: dispatch it **per domain** — backend, then frontend — and each brief names the domain so the architect resolves and follows that domain's own `<domain>-architecture` skill (e.g. `backend-architecture`, `frontend-architecture`) at runtime. It's a single persistent agent re-dispatched per domain (it carries BE context into the FE pass). Every `architect` / `codebase-researcher` brief includes the absolute path to the bundled template it must follow (`plan-template.md` / `research-template.md`, resolved in step 1).

### 3. Research the current state *(before framing — nothing downstream decides against a guess)*

- **Dispatch to `codebase-researcher`**: the raw feature request + the feature dir (`.workspace/plans/yymmdd-slug/`, created by the researcher) + the bundled `research-template.md` absolute path (from step 1) + "map the current state, cite everything". One researcher by default; only when the feature plainly runs deep on both stacks, split into BE/FE-scoped dispatches — **sequentially**, the second appending its sections (parallel writers would clobber the one file).
- It writes `research.md` in the feature dir per that bundled `research-template.md` — facts only, every claim cited `file:line` — and replies terse (the file is the channel, not the chat).
- **Read only `## Summary`.** The full file goes to the critic, the architects, and (later) the implement-phase workers by path.
- A gap discovered downstream (by you, the critic, or an architect) → re-dispatch the researcher with the refined question; it appends. Research narrows **scope and framing** — it never sets priorities (user value does).

### 4. Frame the request *(grounded — before drafting)*

Pressure-test, for yourself, against the research Summary: **the job** (one sentence), **the concrete user**, **the real problem** (symptom vs cause; is there a smaller thing — or does part of this already exist?), **the risky assumptions**. Bring the **2–3 highest-leverage** forks to the user via `AskUserQuestion` — choices that change the build, not cosmetic clarifications — folding in any research **Unknowns** that only the user can settle. If genuinely unambiguous, say so in one line and proceed.

### 5. Draft behaviors

- You write **Problem**, the full **Behaviors** list (every B-NNN, P1/P2/P3 justified by user value), **Out of Scope**, and **Assumptions** (mark ⚠️ high-impact ones — surface those to the user). No implementation detail; research grounds what's in/out of scope, **never** a behavior's priority.
- **Do not design UX, data model, or contracts yet** — behaviors are vetted before anyone builds on them.

### 6. Critique gate — behaviors first *(shift-left)*

- **Dispatch to `product-critic`** once on **Problem + Behaviors + Out of Scope + Assumptions** + the `research.md` path — a short list, one fast pass. It returns findings per the **vibe-product-critique** skill: jobless or untestable behaviors, priorities tracking build ease, missing user needs, user-facing edge cases, scope creep/gap — ranked, plus its sharpest disagreement, grounded in what the app actually does today.
- **Reconcile, don't rubber-stamp.** Fix a behavior if the finding is right; drop it with a reason if not. Put a genuine fork to the user via `AskUserQuestion`.
- **Lock the behaviors.** Nothing downstream is designed against an unvetted behavior — this is what lets the parallel design in step 8 run without wasting work.

### 7. Size & decompose into separate plans

- Estimate the locked behaviors against one team's capacity (one coherent capability per stack, ~3–5 eng deliverables). Judge from the behavior list **and the research Summary** (what exists vs what must be built, per stack). The Summary predates the behaviors — if it can't support the sizing call, **re-dispatch `codebase-researcher`** with the locked behaviors for a targeted exists-vs-build pass (it updates the Summary); **dispatch to the `architect`** (backend then frontend domain) for a rough count only if still borderline after that.
- Fits one team → **one** plan. Larger → decompose into **separate plans** at a **seam: priority first (P1 first), then capability boundary** — each plan one-team-sized AND independently shippable, with a clean `Depends on` edge to whatever it builds on. A big new platform subsystem is its own plan, named as a dependency by its consumers. Assign each behavior to exactly one plan; **B-IDs restart at B-001 within each plan**.
- Allocate one `yymmdd-slug` per plan (same date prefix, distinct slugs); the dependency edges form a DAG (no cycles).
- Put any decomposition to the user via `AskUserQuestion` — the set of plans, their dependency edges, and which behaviors land in which plan. This is a scope decision the user owns.

### 8. Parallel design fan-out *(designer ‖ architect — backend domain)*

- Create each plan dir under `.workspace/plans/` — the feature dir from step 3 becomes the first plan's dir (rename it if step 7 settled on a different slug; never leave it orphaned) — and copy `plan-template.md` to each `yymmdd-slug/plan.md`. Fill headers (`Depends on` → prerequisite plan slugs or `—`, `Status: Draft`, input); write each plan's own `## Behaviors` / `Out of Scope` / `Assumptions`. If step 7 decomposed into multiple plans, `cp` the feature's `research.md` into each sibling plan dir (don't read it) — every plan dir carries its own copy for `/vibe:implement`.
- **Dispatch both briefs in the same turn** (they have no dependency on each other; each brief names the `research.md` path — **start from it, verify load-bearing facts via `codegraph`** instead of exploring from scratch), then wait for both:
  - `product-designer`: produce the **complete UX structure for every FE-bearing plan in one shot** (not story-by-story), structured per-behavior so you can approve/correct each — where it lives, screen/flow shape, design-system primitives (per the project's `product-design` skill), edge states.
  - `architect` (**backend domain** — brief names it as `backend`; it resolves and follows `backend-architecture`): for every plan, fill **Data model**, BE rows of **Architecture** (Constitution line + any ⚠️ platform/tool choice with options), **Platform tasks** (T-9xx impl + paired test) when a new subsystem is needed, **BE Tasks** (T-0xx) + one BE test task. **Contracts only if you decide they add value** (e.g. a platform API surface) — otherwise omit the section. A plan referencing a prerequisite's tables/contracts cites them, doesn't redefine them. Bullets only; keep each plan within budget (flag a plan that overflows — it should become two plans).
- For code lookups during design: the architects start from `research.md` and use `codegraph` directly for the rest.

### 9. Join — UX review & FE architecture

- **Holistic UX review (one pass).** Review the designer's whole UX draft for flow coherence; correct only the screens that are off (one revise message if needed). Merge the accepted UX into the FE-bearing plans.
- **Dispatch the `architect` to the frontend domain** once — brief names it as `frontend`, so it resolves and follows `frontend-architecture`; it now has the locked UX **and** the BE design (brief names the `research.md` path — start from it, verify via `codegraph`): for every plan, fill **FE Tasks** (T-1xx) + one FE test task, FE rows of **Architecture**, and (if the architect chose to keep a Contracts section) the FE hooks/wiring. **Append — do not edit BE-authored content.** `product-designer` on-call for UX sanity checks.

### 10. Self-review *(gate-only, per plan)*

For each plan file, check the gate sections (don't re-read the whole file):

- [ ] Open Questions: `None` or properly-formatted entries — an answered Q folds its resolution into Architecture / Decision Log and is **deleted**, never kept tagged "answered"
- [ ] Architecture has a **Constitution** line; every ⚠️ carries options + a recommendation; a new platform subsystem has a Platform impl task **and** a paired platform test task
- [ ] Behaviors: each has a priority and is observable/testable; Out of Scope and Assumptions are present (⚠️ assumptions surfaced)
- [ ] Tasks table complete (ID, Block, Task, Delivers→a B for BE/FE, Owner, Status=`Todo`); order is **Platform → BE → FE**; budget respected; cells 1–2 lines — no design restatement, no pre-named new files
- [ ] Every behavior is delivered by ≥1 Task **and** covered by ≥1 Test behavior
- [ ] B-IDs unique within the plan (start at B-001); every `Depends on` slug resolves to a real plan; the dependency graph is acyclic
- [ ] `research.md` sits in the plan dir; its **Unknowns** are `None` or each is resolved in the plan (a Decision/Assumption) or promoted to Open Questions
- [ ] No fact restated across sections — UX / Architecture / Contracts each hold their own altitude, cross-referenced by B/T/D id; current-state code facts cite `research.md`, not copies of it
- [ ] No bracketed placeholders survive

**Dispatch the `architect`** (to the domain whose gate failed) once per failed gate. Up to **3 revise cycles**, then stop and report as-is.

### 11. Finalize

- Per plan: Open Questions `None` → `Status: Ready for Implement`; else `Status: Blocked — Open Questions`.
- Report to the user in one short message:
  - The plan(s) produced (path each) and their dependency edges
  - Per plan: name, behaviors (B-range), eng-task count (Platform / BE / FE), `Status`
  - Constitution ⚠️ count (which articles); any new platform subsystem
  - Open Questions verbatim (if any)

Do not start `/vibe:implement` automatically — the user reviews first. `/vibe:implement` runs **one plan = one team = one pass**, building Platform → BE → FE, each block to green.
