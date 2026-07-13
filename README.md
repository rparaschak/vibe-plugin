# vibe

A portable Claude Code **plugin** for feature planning, implementation, and knowledge distillation. `vibe` is the generic, **stack-agnostic** harness — a team-lead orchestrating a fixed cast of subagents through a research → spec → plan → implement → distill flow. The WHAT (spec) and the HOW (plan) are split into separate phases and artifacts: `/vibe:spec` defines behaviors + UX, `/vibe:plan` designs the architecture (and runs standalone for purely technical work that needs no spec). Each consuming project supplies its own conventions as **named skills resolved at runtime** (`<domain>-architecture`, `<domain>-testing`, `<domain>-review`, a repo-level `environment`, and `product-design`) plus a `.workspace/` for its constitution and plans.

The rest of this document is a complete inventory of everything the plugin is made of: commands, agents, skills, flows, and the project-supplied layer it binds to. Every item carries an **icon** showing where it lives / who owns it, so we can see at a glance what is reusable harness vs. what each consuming repo must provide. For the actionable "what a new repo must supply" list, see [`CHECKLIST.md`](CHECKLIST.md).

---

## Quick start

### 1. Install the plugin

In Claude Code, add this repo as a plugin marketplace, then install the plugin:

```
/plugin marketplace add rparaschak/vibe-plugin
/plugin install vibe@vibe
```

That registers the `/vibe:*` commands. (Or just run `/plugin`, browse to the **vibe** marketplace, and install from the menu.) Installing from a local clone instead of GitHub? Point the marketplace at the path: `/plugin marketplace add /path/to/vibe-plugin`.

### 2. Adopt it in your repo

The plugin ships the stack-agnostic harness; **your repo supplies its conventions** as named skills (see [`CHECKLIST.md`](CHECKLIST.md)). From the repo you want to use vibe in, run:

```
/vibe:adopt
```

It reads the setup contract, detects what your repo already has vs. what's missing, writes `.workspace/adoption-checklist.md`, and walks you through each gap — **reuse an existing guideline** the repo already has, **author a skill by hand**, or have it **explore your code and draft one** for your approval. It also points out which external tooling to connect (the `codegraph` and Playwright MCP servers). It never touches your application code, and it's resumable — re-run `/vibe:adopt` any time to continue.

### 3. Plan and build

Once adoption reports **vibe-ready**, the normal loop is:

```
/vibe:spec       # define the WHAT: research → frame behaviors → critic gate → [design UX] → spec.md
/vibe:plan       # design the HOW: technical research → architecture → critic gate → plan.md (spec-optional)
/vibe:feature    # run spec then plan end-to-end, no approval pause between
/vibe:implement  # build ONE plan in one run: engineer → test → review → fix → done  (--worktree = isolated branch, for parallel runs)
/vibe:distill    # fold what each run learned back into the playbook (run every ~2–3 plans)
```

For a **full feature**, run `/vibe:spec` (review the spec), then `/vibe:plan` — or `/vibe:feature` to do both in one shot. For **purely technical** work (a refactor, migration, backend change) with no product/design question, run `/vibe:plan` directly — it needs no spec and skips the product/design steps. See **§2. Flows** below for what each command does step by step.

To build several plans **in parallel**, run each `/vibe:implement --worktree` (in its own session/tab): each gets its own git worktree + branch off local HEAD, so the runs never touch each other's files, and each auto-merges back to your branch when it finishes. See the `/vibe:implement` flow in §2 for the full lifecycle.

## Legend

| Icon | Meaning |
|---|---|
| 🔌 **Plugin** | Bundled with vibe. Lives in this repo. Stack-agnostic, reusable as-is across projects. |
| 📁 **Project** | Supplied by the consuming repo (`.claude/skills/`, `.workspace/`). Not bundled. Resolved **by name at runtime**; encodes that repo's conventions. |
| ⚠️ **External** | Tooling the harness assumes is present (MCP servers / CLIs) but can't bundle — the consuming repo installs and connects it. |

The core design intent: the **harness** (commands + orchestration discipline + agent roles) is 🔌 and never changes per project; the **conventions** (architecture / testing / review / design / environment) are 📁 named skills the harness resolves at runtime; the ⚠️ tooling is installed in the repo. Earlier versions leaked project-specific commands, ports, and stack names into the plugin — those are now extracted into the project `environment` skill and the per-domain skills, so the plugin itself dictates none of them.

---

## 1. Commands (slash commands)

Located in `commands/`. These own the phase algorithms (the flows). All commands read/write the 📁 `.workspace/` and dispatch 🔌 agents.

| Command | What it does |
|---|---|
| 🔌 `/vibe:adopt` | **Onboarding (orchestration command).** Reads the project-setup contract (`CHECKLIST.md`), detects what the repo already supplies vs. what's missing — via a read-only **scout subagent per item**, so repo exploration stays off the orchestrator's context — records it in `.workspace/adoption-checklist.md`, then walks the gaps with the user: each project skill is reused from an existing guideline (the repo may already have one under another name), authored by hand, or drafted by a scout exploring the repo. Goal: close the whole list. Resumable. |
| 🔌 `/vibe:spec` | Team-lead for the **WHAT**. Researches the codebase into a cited `research.md` (mining the behaviour-based tests for what already exists), then via the `product-manager` frames + drafts behaviors, gates them with an adversarial critic, sizes/decomposes the work, and — for UI features — designs the UX. Produces `spec.md`. Thin orchestrator: drafting is delegated; design is auto-skipped for technical work. Never touches code. |
| 🔌 `/vibe:plan` | Team-lead for the **HOW**. **Spec-optional.** Reads behaviors from a Ready-for-Plan `spec.md` (or, standalone, captures a lightweight Goal + Behaviors inline), researches the technical landscape into the plan's `## Current State`, designs data model + architecture (BE → FE) + tasks + tests, and gates the design with an adversarial architecture critic. Produces `plan.md`. Never touches code. |
| 🔌 `/vibe:feature` | Thin sequencer: runs `/vibe:spec` then `/vibe:plan` end-to-end against one feature, with **no manual approval pause** between (the framing forks and both critic gates still fire). Use for a full feature when you don't need to lock the spec before architecture. Owns no algorithm of its own. |
| 🔌 `/vibe:implement` | Team-lead for **implementation**. Executes ONE plan in one run: builds blocks Platform → BE → FE, each through engineer → test → review → fix, then marks the plan Implemented and commits. Never writes code/tests itself. Optional **`--worktree`** runs the build in an isolated git worktree on its own branch (from local HEAD) for **parallel implementation**, then auto-merges back at finalize. |
| 🔌 `/vibe:distill` | Curator of the playbook. Classifies `learnings.md` entries, verifies staleness, promotes durable lessons up the encoding ladder (mechanize → skill → constitution → template/brief), retires stale ones. Writes only to 📁 `.workspace/**` and `.claude/**`. |
| 🔌 `/vibe:build-flow` | Flow builder. Recomposes vibe's base phase algorithms (spec / plan / implement) per an interactive interview into ONE custom orchestration command written to the consuming repo's `.claude/commands/`, validating the requested flow keeps vibe's load-bearing guarantees. Never runs the flow or touches project code. |

---

## 2. Flows (phase algorithms) — 🔌 Plugin

The flows are hardcoded in the command files. They reference 📁 artifacts (constitution, plans) + 🔌 templates and dispatch 🔌 agents.

### `/vibe:adopt` flow
`read contract (CHECKLIST.md) → detect & confirm domains → scout each item (one subagent per point, parallel) → write adoption-checklist.md → close gaps point-by-point → finalize`

- **Orchestration command.** The main agent never explores the repo itself — for each contract item it dispatches a read-only **scout subagent** that probes what exists, finds reusable guidelines, maps the repo's conventions (using `Explore` for broad areas), and hands back a compact report + a drafted `SKILL.md`. Exploration cost stays in the scouts, so the orchestrator's context stays clean on any size repo.
- Reads the plugin's `CHECKLIST.md` as the canonical required-item list (single source of truth — no hardcoded list to drift).
- Per gap, the user chooses (via `AskUserQuestion`): **accept the scout's drafted proposal** (reuse an existing guideline as a shallow pointer or compacted into a skill, or drafted from the codebase when there's no candidate), **use a different method**, **author it myself**, or **skip**.
- Writes only `.workspace/adoption-checklist.md` (durable, resumable state) and — on approval — `.claude/skills/<name>/SKILL.md` / `.workspace/constitution.md`. Never touches code; never installs MCP tooling (it gives the steps).

### `/vibe:spec` flow
`research (product) → frame → draft behaviors → critic gate → size/decompose → [design UX] → finalize`

| Step | Agent dispatched | Notes |
|---|---|---|
| Load context | — | Reads 📁 `constitution.md` + the 🔌 `spec` / `research` templates (from the plugin's `workspace-starter/`). |
| Research | `codebase-researcher` (product brief) | Writes 📁 `research.md`, mining behaviour-based tests for existing behaviors; lead reads only `## Summary`. |
| Frame | `product-manager` → (user) | PM proposes 2–3 high-leverage forks; lead relays them via `AskUserQuestion`. |
| Draft behaviors | `product-manager` | Writes Problem, Behaviors (B-NNN), Out of Scope, Assumptions into `spec.md`. Lead stays thin. |
| Critic gate | `critic` (product brief) | Locks behaviors before any design. |
| Size / decompose | `product-manager` | Splits into separate dependent specs if too big (user owns the call). |
| Design UX | `product-designer` | Writes `## UX structure` into `spec.md`. **Auto-skipped** when no `product-design` skill or no UI surface (`--design`/`--no-design` overrides). |
| Finalize | — | Status → `Ready for Plan` or `Blocked — Open Questions`. |

### `/vibe:plan` flow
`resolve behaviors (spec.md | standalone) → technical research → architecture(BE) → architecture(FE) → critic gate → finalize`

| Step | Agent dispatched | Notes |
|---|---|---|
| Load context | — | Reads 📁 `constitution.md` + the 🔌 `plan` template. |
| Resolve behaviors | — (team-lead, standalone only) | **Spec-fed:** read locked `spec.md` behaviors by id. **Standalone (no spec):** the lead writes a lightweight Goal + Behaviors inline — no PM, no critic, no UX. |
| Technical research | `codebase-researcher` (technical brief) | Writes the plan's `## Current State` (structure, data model, integration points); folded into `plan.md`. |
| Architecture (BE) | `architect` (backend domain) | Data model, BE architecture, platform/BE tasks, BE test behaviors. |
| Architecture (FE) | `architect` (frontend domain) | Reads the locked `## UX structure` (spec-fed) or the inline `## Behaviors` (standalone-FE) + BE design; FE tasks/architecture/tests. Skipped only for plans with no frontend surface. |
| Critic gate | `critic` (architecture brief) | Adversarial review of design + tasks (behavior coverage, constitution, over-engineering); up to 3 revise cycles. |
| Finalize | — | Status → `Ready for Implement` or `Blocked — Open Questions`. |

### `/vibe:feature` flow
`/vibe:spec (to Ready for Plan) → /vibe:plan (spec-fed)` — sequenced back-to-back, no manual approval pause; owns no algorithm of its own. A spec that finalizes `Blocked — Open Questions` stops there. Multiple specs (from decomposition) → plan each in dependency order.

> **Domain note:** the `architect` and `critic` are **domain-generic** — the domain (backend, frontend, …) or the critique mode (product, architecture) comes from the dispatch brief, and the agent resolves the matching skill/lens-set at runtime. The only stack-shaped part is the **backend → frontend design sequence** in `/vibe:plan`, hardcoded in the command (not the agent). A new domain needs project skills, not a new agent.

### `/vibe:implement` flow
`resolve plan → gate check → [enter worktree] → build run list → per-block loop → finalize [→ merge back]`

- **Block order (hardcoded): Platform → BE → FE.**
- **Per-block loop:** `engineer` → `test-engineer` → `reviewer` → (fix → re-review)* → done; user-facing blocks also run `qa-engineer`.
- **"Done"** = reviewer approved AND tests green (actually executed).
- **"Implemented"** = every block done AND tests ran green at the required levels AND (for user-facing blocks) E2E green + manual `QA pass` + build clean; else `Blocked — Implement`.
- Finalize: Status → Implemented, move plan to `.workspace/plans/archive/`, commit.
- **`--worktree` mode (opt-in, for parallel runs).** After the gate, the lead creates a worktree at `.claude/worktrees/vibe-<slug>/` on branch `vibe/<slug>` **from local HEAD**, gitignores `.claude/worktrees/`, carries the (usually uncommitted) plan in, APFS-clones `node_modules` (isolated writable tree per run), and `EnterWorktree`s so the whole team shares it. At an **Implemented** finalize the lead `ExitWorktree`s and **merges back itself** (a merge lock serializes parallel merges; a conflict is resolved by a dispatched `engineer` then re-verified). A **Blocked** finalize keeps the worktree + branch for in-place resume. The lead still never touches code — it owns only the git plumbing. See the command file for the full step-by-step.

> **Domain note:** the block order is hardcoded in the command, but the roster is **domain-generic** — `engineer` / `test-engineer` / `reviewer` / `architect` are each dispatched **per domain** (the brief carries `backend` / `frontend`). There is no stack-specific engineer or reviewer agent.

### `/vibe:distill` flow
`load inputs → verify staleness (codebase-researcher) → classify → approve (user) → apply & prune`

- Encoding ladder: **mechanize → skill → constitution → template/brief → keep → retire**.
- Promotes into the 📁 consuming project's `.claude/skills` & `.claude/agents` (and `.workspace/`) — never into this plugin.

---

## 3. Agents

All **9** live in `agents/`. The agent **definitions** are 🔌. Each declares its 🔌 skills in the `skills:` frontmatter; six of them also resolve 📁 project skills **by name at runtime** — the four domain-generic roles resolve their `<domain>-*` skills (the domain comes from the dispatch brief), `engineer` / `test-engineer` / `reviewer` / `qa-engineer` resolve the repo-level `environment` skill, and `product-designer` resolves `product-design`. No agent hardcodes environment commands or ports — those are resolved from the project's `environment` skill.

| Agent | 🔌 Plugin skills | 📁 Project skills (resolved by name) | What it does |
|---|---|---|---|
| 🔌 `architect` (opus, xhigh) | team-communication-protocol, research-protocol | `<domain>-architecture` | Designs ONE domain's plan sections — data model, architecture, platform subsystems, tasks, test behaviors — for the domain named in its brief. Re-dispatched per domain. No code. |
| 🔌 `engineer` (opus, high) | team-communication-protocol, research-protocol | `<domain>-architecture`, `environment` | Implements ONE domain's block against the locked design, then runs **lint + build**. Does not write tests or redesign. |
| 🔌 `test-engineer` (opus, high) | team-communication-protocol, research-protocol | `<domain>-testing`, `<domain>-architecture`, `environment` | Writes and **runs** every test layer the domain defines (e.g. integration / component / E2E) against the implemented code. No production code. |
| 🔌 `reviewer` (opus) | team-communication-protocol, research-protocol, review-discipline | `<domain>-review` *(optional)*, `<domain>-architecture`, `<domain>-testing`, `environment` | Read-only three-pass review of ONE domain's block diff vs plan + project skills + constitution. Never edits. |
| 🔌 `product-manager` (opus, xhigh) | team-communication-protocol, research-protocol | — | Owns the WHAT in `/vibe:spec`: frames the request and drafts Problem + Behaviors (B-NNN) + Out of Scope + Assumptions into `spec.md`. Proposes framing forks for the lead to relay. Scoped to `/vibe:spec` only. No UX/architecture/code. |
| 🔌 `codebase-researcher` (sonnet, high) | team-communication-protocol, research-protocol | — | Maps current code state to the **target its brief names** (a feature's 📁 `research.md`, or a plan's `## Current State`), every claim cited `file:line`; mines the behaviour tests when inventorying what exists. Generic across briefs — the orchestrator sets angle + target. Facts only; designs nothing. |
| 🔌 `product-designer` (opus) | team-communication-protocol, research-protocol | `product-design` | Designs the UX for a feature and writes it into `spec.md`'s `## UX structure`. Iterates with the invoker. No code; touches no other section. |
| 🔌 `critic` (opus, xhigh) | team-communication-protocol, research-protocol, critique | — | Adversarial review before work is built on a draft. Generic — the brief names the **artifact + lens-set** (a spec's Behaviors, or a plan's design + tasks); the lens-sets live in `vibe-critique`. Read-only findings. |
| 🔌 `qa-engineer` (sonnet, high) | team-communication-protocol, research-protocol, manual-testing | `environment` | Manual QA: brings the app up (per the `environment` skill) and drives it via the Playwright MCP, confirming Behaviors. No code/tests. |

> **Domain-generic roles:** `architect`, `engineer`, `test-engineer`, and `reviewer` read their domain (backend, frontend, mobile, …) from the dispatch brief and resolve that domain's project skills at runtime. Admitting a new domain needs **new project skills, not new agent files.** The `critic` is **mode-generic** the same way — one agent, a product brief in `/vibe:spec` and an architecture brief in `/vibe:plan`, selecting the matching lens-set in `vibe-critique`.

---

## 4. Skills

### 4a. Bundled skills — 🔌 Plugin

Located in `skills/`. These are the harness itself: orchestration discipline, the research ladder, and review/critique/QA **method**. Stack-agnostic.

| Skill | What it does | Used by |
|---|---|---|
| 🔌 `vibe-team-communication-protocol` | Rules for how agents talk via `SendMessage` — channel discipline, done-format, andon-cord escalation, role boundaries. | Every agent |
| 🔌 `vibe-team-orchestration` | How the team-lead runs a persistent named-agent team: form, dispatch, context, teardown. | `/vibe:spec`, `/vibe:plan`, `/vibe:implement` |
| 🔌 `vibe-research-protocol` | The research escalation ladder (the cited map: `research.md` / plan `## Current State` → `codegraph` → `Explore` → `codebase-researcher`) and the hard rule against wide file sweeps. | Every agent |
| 🔌 `vibe-review-discipline` | Reviewer method: read-only stance, three-pass review, what to check against, approve/findings formats. | `reviewer` |
| 🔌 `vibe-critique` | Adversarial critique method with two lens-sets: a **product** set (a spec's Behaviors) and an **architecture** set (a plan's design + tasks); stance, lenses, findings format. | `critic` |
| 🔌 `vibe-manual-testing` | QA method: click-through via Playwright MCP, pre-auth session, pass/findings format. Resolves app bring-up from the project `environment` skill. | `qa-engineer` |

### 4b. Project-supplied skills — 📁 Project

NOT bundled. Each consuming repo authors these under `.claude/skills/`. Agents resolve them **by name** at runtime; if one is absent the agent says so and falls back (or andon-cords). These encode per-repo conventions. The `<domain>-*` skills are **per-domain** (one set per stack the repo uses); `environment` and `product-design` are repo-level singletons.

| Skill | What it should contain | Resolved by |
|---|---|---|
| 📁 `<domain>-architecture` | A domain's structural rules (module/slice layout, persistence, platform subsystems, error handling, the patterns that domain uses). | `architect` / `engineer` / `reviewer` / `test-engineer` (for that domain) |
| 📁 `<domain>-testing` | A domain's test conventions (layers, file layout, mocking boundary, fixtures/factories, harness). | `test-engineer` / `reviewer` (for that domain) |
| 📁 `<domain>-review` *(optional)* | A domain's review **checklist** — the concrete things the reviewer actively flags beyond architecture/testing. If absent, the reviewer falls back to architecture + testing + constitution. | `reviewer` (for that domain) |
| 📁 `environment` | The **one repo-level** skill: how to run/build/test the repo — commands, ports, infra/app bring-up, codegen/client-regen, and the verification decision logic (which checks a change triggers). | `engineer` / `test-engineer` / `reviewer` / `qa-engineer` |
| 📁 `product-design` | The app's UX/UI conventions (design system, component usage). | `product-designer` |

See [`CHECKLIST.md`](CHECKLIST.md) for the authoring checklist and which starter seeds each one from.

---

## 5. External tooling assumptions — ⚠️

Not authored as files — installed/connected in the consuming repo's environment. The plugin can't bundle these; if absent, the agents that rely on them degrade (e.g. codegraph → plain `Read`/`Grep`, losing their context-preserving lookups).

| Tool | What it is | Used by |
|---|---|---|
| ⚠️ `codegraph` MCP | Code-intelligence index for targeted lookups (callers/callees/trace/impact) instead of wide file reads. | `codebase-researcher`, `architect`, `engineer`, `reviewer`, `test-engineer` |
| ⚠️ Playwright MCP | Browser automation for driving the running app. | `qa-engineer`, `test-engineer` (FE/E2E) |

> All project **commands, ports, and build targets** that earlier versions hardcoded here (`make api-run`, ports, `make e2e`, `make check`, …) now live in the project's `environment` skill — the plugin dictates none of them, and the `environment-sample.md` seed deliberately uses a *different* command set to make that clear.

---

## 6. Templates & workspace

### 6a. Plugin-bundled starter — 🔌 Plugin

Everything in `workspace-starter/` ships with the plugin. Two kinds:

- **Templates (`*-template.md`)** — the exact shapes the harness reads **straight from the plugin at runtime** (the commands resolve them via `$CLAUDE_PLUGIN_ROOT/workspace-starter` and pass the path in agent briefs). These are **not** project items.
- **Samples (`*-sample.md`)** — seeds a repo copies and **adapts** into its own `.claude/skills/` or `.workspace/` (the "Adapt" step a `/vibe:adopt`-style setup walks through).

| File | Kind | Seeds / defines |
|---|---|---|
| 🔌 `workspace-starter/spec-template.md` | template | The exact shape every `spec.md` must follow (the WHAT: Problem, Behaviors, UX, Out of Scope, Assumptions). |
| 🔌 `workspace-starter/plan-template.md` | template | The exact shape every `plan.md` must follow (the HOW: Current State, Data model, Architecture, Tasks, Test behaviors). |
| 🔌 `workspace-starter/research-template.md` | template | The exact shape every `research.md` must follow (the spec phase's product map). |
| 🔌 `workspace-starter/architecture-sample.md` | sample | Seed for a `<domain>-architecture` skill (currently a Go/GORM backend). |
| 🔌 `workspace-starter/backend-testing-sample.md` | sample | Seed for a backend `<domain>-testing` skill. |
| 🔌 `workspace-starter/review-checklist-sample.md` | sample | Seed for a `<domain>-review` checklist. |
| 🔌 `workspace-starter/environment-sample.md` | sample | Seed for the repo-level `environment` skill. |
| 🔌 `workspace-starter/constitution-sample.md` | sample | Seed for `.workspace/constitution.md`. |
| 🔌 `workspace-starter/product-design-sample.md` | sample | Seed for the repo-level `product-design` skill (UI repos). |

> No `learnings-template.md` ships. The learnings format is described inline by `/vibe:implement` and `/vibe:distill` (one dated line per lesson; L-IDs assigned at distill). Add one only if that format ever needs to be enforced as a file.

### 6b. Project workspace (`.workspace/`) — 📁 Project

The per-repo playbook, read/written by the commands and discovered at runtime relative to the repo root (no absolute paths baked in).

| Item | What it is |
|---|---|
| 📁 `.workspace/constitution.md` | Non-negotiable project rules, gated by `/vibe:spec` + `/vibe:plan`, checked by the `reviewer`. The harness binds to **concepts** (the platform-vs-feature split, the build/test gates) — not specific article numbers, so you number it your way. |
| 📁 `.workspace/plans/yymmdd-slug/spec.md` | The feature's WHAT — Problem, Behaviors (B-NNN), UX. Produced by `/vibe:spec`; absent for standalone technical plans. |
| 📁 `.workspace/plans/yymmdd-slug/plan.md` | The feature's HOW — Current State, data model, architecture, tasks. References spec behaviors by id. |
| 📁 `.workspace/plans/yymmdd-slug/research.md` | The spec phase's product map of the current codebase for that feature (the plan's technical map lives inline in `plan.md`'s `## Current State`). |
| 📁 `.workspace/plans/yymmdd-slug/learnings.md` | Per-run learnings (uncurated). |
| 📁 `.workspace/plans/archive/` | Retired/implemented plans. |
| 📁 `.workspace/learnings.md` | Curated holding pen (only `/vibe:distill` writes it). |

---

## 7. Summary — what's reusable vs. what each repo provides

**🔌 Plugin (drop-in, never edited per project):**
- 7 commands + their flows (`adopt`, `spec`, `plan`, `feature`, `implement`, `distill`, `build-flow`)
- 9 agent definitions (4 domain-generic roles + the mode-generic `critic` + 4 fixed roles)
- 6 bundled skills (all clean — no hardcoded project specifics)
- `workspace-starter/` scaffold: 3 runtime templates + 6 sample seeds

**📁 Project (authored once per consuming repo — see [`CHECKLIST.md`](CHECKLIST.md)):**
- Per-domain skills: `<domain>-architecture`, `<domain>-testing`, `<domain>-review` *(optional)*
- Repo-level skills: `environment`, `product-design`
- `.workspace/`: constitution content + plans + learnings

**⚠️ External tooling (installed/connected in the repo):**
- `codegraph` MCP, Playwright MCP

**Remaining harness limit (in the command files, not the agents):**
- The **Platform → BE → FE** block order and the **backend → frontend** design sequence are hardcoded in `plan.md` / `implement.md`. The role *agents* are domain-generic, but admitting a brand-new top-level domain (e.g. mobile) into the *flow* still needs a command edit.
