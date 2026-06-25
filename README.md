# vibe

A portable Claude Code **plugin** for feature planning, implementation, and knowledge distillation. `vibe` is the generic, **stack-agnostic** harness — a team-lead orchestrating a fixed cast of subagents through a research → plan → implement → distill flow. Each consuming project supplies its own conventions as **named skills resolved at runtime** (`<domain>-architecture`, `<domain>-testing`, `<domain>-review`, a repo-level `environment`, and `product-design`) plus a `.workspace/` for its constitution and plans.

The rest of this document is a complete inventory of everything the plugin is made of: commands, agents, skills, flows, and the project-supplied layer it binds to. Every item carries an **icon** showing where it lives / who owns it, so we can see at a glance what is reusable harness vs. what each consuming repo must provide. For the actionable "what a new repo must supply" list, see [`CHECKLIST.md`](CHECKLIST.md).

## Legend

| Icon | Meaning |
|---|---|
| 🔌 **Plugin** | Bundled with vibe. Lives in this repo. Stack-agnostic, reusable as-is across projects. |
| 📁 **Project** | Supplied by the consuming repo (`.claude/skills/`, `.workspace/`). Not bundled. Resolved **by name at runtime**; encodes that repo's conventions. |
| ⚠️ **External** | Tooling the harness assumes is present (MCP servers / CLIs) but can't bundle — the consuming repo installs and connects it. |

The core design intent: the **harness** (commands + orchestration discipline + agent roles) is 🔌 and never changes per project; the **conventions** (architecture / testing / review / design / environment) are 📁 named skills the harness resolves at runtime; the ⚠️ tooling is installed in the repo. Earlier versions leaked project-specific commands, ports, and stack names into the plugin — those are now extracted into the project `environment` skill and the per-domain skills, so the plugin itself dictates none of them.

---

## 1. Commands (slash commands)

Located in `commands/`. These own the phase algorithms (the flows). All three read/write the 📁 `.workspace/` and dispatch 🔌 agents.

| Command | What it does |
|---|---|
| 🔌 `/vibe:adopt` | **Onboarding.** Reads the project-setup contract (`CHECKLIST.md`), detects what the repo already supplies vs. what's missing, records it in `.workspace/adoption-checklist.md`, then walks the gaps with the user — each project skill is authored by hand or drafted by exploring the repo. Goal: close the whole list. Resumable. |
| 🔌 `/vibe:plan` | Team-lead for **planning**. Researches the codebase into a cited `research.md`, frames behaviors, gates them with an adversarial critic, sizes the work, decomposes into one-team-sized plans, then designs data model + architecture + tasks + tests. Produces `plan.md`. Never touches code. |
| 🔌 `/vibe:implement` | Team-lead for **implementation**. Executes ONE plan in one run: builds blocks Platform → BE → FE, each through engineer → test → review → fix, then marks the plan Implemented and commits. Never writes code/tests itself. |
| 🔌 `/vibe:distill` | Curator of the playbook. Classifies `learnings.md` entries, verifies staleness, promotes durable lessons up the encoding ladder (mechanize → skill → constitution → template/brief), retires stale ones. Writes only to 📁 `.workspace/**` and `.claude/**`. |

---

## 2. Flows (phase algorithms) — 🔌 Plugin

The flows are hardcoded in the command files. They reference 📁 artifacts (constitution, plans) + 🔌 templates and dispatch 🔌 agents.

### `/vibe:adopt` flow
`read contract (CHECKLIST.md) → detect & confirm domains → probe what exists → write adoption-checklist.md → close gaps point-by-point → finalize`

- Reads the plugin's `CHECKLIST.md` as the canonical required-item list (single source of truth — no hardcoded list to drift).
- Per gap, the user chooses (via `AskUserQuestion`): **author it myself**, **explore & propose** (a `codebase-researcher` maps the repo's real conventions; the command drafts a `SKILL.md` from the matching `*-sample.md` seed + findings, for the user to approve), or **skip**.
- Writes only `.workspace/adoption-checklist.md` (durable, resumable state) and — on approval — `.claude/skills/<name>/SKILL.md` / `.workspace/constitution.md`. Never touches code; never installs MCP tooling (it gives the steps).

### `/vibe:plan` flow
`research → frame → draft behaviors → critic gate → size/decompose → [UX ‖ architecture(BE)] → architecture(FE) → self-review → finalize`

| Step | Agent dispatched | Notes |
|---|---|---|
| Load context | — | Reads 📁 `constitution.md` + the 🔌 `plan` / `research` templates (from the plugin's `workspace-starter/`). |
| Research | `codebase-researcher` | Writes 📁 `research.md`; lead reads only `## Summary`. |
| Frame | — (user) | `AskUserQuestion` on 2–3 high-leverage forks. |
| Draft behaviors | — (lead) | Problem, Behaviors (B-NNN), Out of Scope, Assumptions. |
| Critic gate | `product-critic` | Locks behaviors before any design. |
| Size / decompose | (`architect`, rough count only) | Splits into separate dependent plans if too big. |
| Design fan-out | `product-designer` ‖ `architect` (backend domain) | Run in parallel (no dependency). |
| Join | `architect` (frontend domain) | Needs locked UX + BE design (same persistent agent, re-dispatched per domain). |
| Self-review | `architect` (responsible domain) | Gate-only, up to 3 revise cycles. |

> **Domain note:** the `architect` is **domain-generic** — the domain (backend, frontend, …) comes from the dispatch brief and it resolves that domain's `<domain>-architecture` skill at runtime. The only stack-shaped part is the **backend → frontend design sequence**, which is hardcoded in the command (not in the agent). A new domain needs project skills, not a new agent.

### `/vibe:implement` flow
`resolve plan → gate check → build run list → per-block loop → finalize`

- **Block order (hardcoded): Platform → BE → FE.**
- **Per-block loop:** `engineer` → `test-engineer` → `reviewer` → (fix → re-review)* → done; user-facing blocks also run `qa-engineer`.
- **"Done"** = reviewer approved AND tests green (actually executed).
- **"Implemented"** = every block done AND tests ran green at the required levels AND (for user-facing blocks) E2E green + manual `QA pass` + build clean; else `Blocked — Implement`.
- Finalize: Status → Implemented, move plan to `.workspace/plans/archive/`, commit.

> **Domain note:** the block order is hardcoded in the command, but the roster is **domain-generic** — `engineer` / `test-engineer` / `reviewer` / `architect` are each dispatched **per domain** (the brief carries `backend` / `frontend`). There is no stack-specific engineer or reviewer agent.

### `/vibe:distill` flow
`load inputs → verify staleness (codebase-researcher) → classify → approve (user) → apply & prune`

- Encoding ladder: **mechanize → skill → constitution → template/brief → keep → retire**.
- Promotes into the 📁 consuming project's `.claude/skills` & `.claude/agents` (and `.workspace/`) — never into this plugin.

---

## 3. Agents

All **8** live in `agents/`. The agent **definitions** are 🔌. Each declares its 🔌 skills in the `skills:` frontmatter; the four role agents also resolve 📁 project skills **by name at runtime** (the domain comes from the dispatch brief). No agent hardcodes environment commands or ports — those are resolved from the project's `environment` skill.

| Agent | 🔌 Plugin skills | 📁 Project skills (resolved by name) | What it does |
|---|---|---|---|
| 🔌 `architect` (opus, xhigh) | team-communication-protocol, research-protocol | `<domain>-architecture` | Designs ONE domain's plan sections — data model, architecture, platform subsystems, tasks, test behaviors — for the domain named in its brief. Re-dispatched per domain. No code. |
| 🔌 `engineer` (opus, high) | team-communication-protocol, research-protocol | `<domain>-architecture`, `environment` | Implements ONE domain's block against the locked design, then runs **lint + build**. Does not write tests or redesign. |
| 🔌 `test-engineer` (opus, high) | team-communication-protocol, research-protocol | `<domain>-testing`, `<domain>-architecture`, `environment` | Writes and **runs** every test layer the domain defines (e.g. integration / component / E2E) against the implemented code. No production code. |
| 🔌 `reviewer` (opus) | team-communication-protocol, research-protocol, review-discipline | `<domain>-review` *(optional)*, `<domain>-architecture`, `<domain>-testing`, `environment` | Read-only three-pass review of ONE domain's block diff vs plan + project skills + constitution. Never edits. |
| 🔌 `codebase-researcher` (sonnet) | team-communication-protocol, research-protocol | — | Maps current code state around a feature into 📁 `research.md`, every claim cited `file:line`. Facts only; designs nothing. |
| 🔌 `product-designer` (opus) | team-communication-protocol, research-protocol | `product-design` | Explores existing UI, proposes a pragmatic UX (read-only, no code). Iterates with the invoker. |
| 🔌 `product-critic` (opus) | team-communication-protocol, research-protocol, product-critique | — | Adversarial user-advocate review of draft Behaviors before any UX/architecture. Read-only findings. |
| 🔌 `qa-engineer` (sonnet) | team-communication-protocol, research-protocol, manual-testing | `environment` | Manual QA: brings the app up (per the `environment` skill) and drives it via the Playwright MCP, confirming Behaviors. No code/tests. |

> **Domain-generic roles:** `architect`, `engineer`, `test-engineer`, and `reviewer` read their domain (backend, frontend, mobile, …) from the dispatch brief and resolve that domain's project skills at runtime. Admitting a new domain needs **new project skills, not new agent files.**

---

## 4. Skills

### 4a. Bundled skills — 🔌 Plugin

Located in `skills/`. These are the harness itself: orchestration discipline, the research ladder, and review/critique/QA **method**. Stack-agnostic.

| Skill | What it does | Used by |
|---|---|---|
| 🔌 `vibe-team-communication-protocol` | Rules for how agents talk via `SendMessage` — channel discipline, done-format, andon-cord escalation, role boundaries. | Every agent |
| 🔌 `vibe-team-orchestration` | How the team-lead runs a persistent named-agent team: form, dispatch, context, teardown. | `/vibe:plan`, `/vibe:implement` |
| 🔌 `vibe-research-protocol` | The research escalation ladder (`research.md` → `codegraph` → `Explore` → `codebase-researcher`) and the hard rule against wide file sweeps. | Every agent |
| 🔌 `vibe-review-discipline` | Reviewer method: read-only stance, three-pass review, what to check against, approve/findings formats. | `reviewer` |
| 🔌 `vibe-product-critique` | Adversarial critique method: user-advocate stance, attack lenses, findings format. | `product-critic` |
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
| 🔌 `workspace-starter/plan-template.md` | template | The exact shape every `plan.md` must follow. |
| 🔌 `workspace-starter/research-template.md` | template | The exact shape every `research.md` must follow. |
| 🔌 `workspace-starter/architecture-sample.md` | sample | Seed for a `<domain>-architecture` skill (currently a Go/GORM backend). |
| 🔌 `workspace-starter/backend-testing-sample.md` | sample | Seed for a backend `<domain>-testing` skill. |
| 🔌 `workspace-starter/review-checklist-sample.md` | sample | Seed for a `<domain>-review` checklist. |
| 🔌 `workspace-starter/environment-sample.md` | sample | Seed for the repo-level `environment` skill. |
| 🔌 `workspace-starter/constitution-sample.md` | sample | Seed for `.workspace/constitution.md`. |

> No `learnings-template.md` ships. The learnings format is described inline by `/vibe:implement` and `/vibe:distill` (one dated line per lesson; L-IDs assigned at distill). Add one only if that format ever needs to be enforced as a file.

### 6b. Project workspace (`.workspace/`) — 📁 Project

The per-repo playbook, read/written by the commands and discovered at runtime relative to the repo root (no absolute paths baked in).

| Item | What it is |
|---|---|
| 📁 `.workspace/constitution.md` | Non-negotiable project rules, gated by `/vibe:plan`, checked by the `reviewer`. The harness binds to **concepts** (the platform-vs-feature split, the build/test gates) — not specific article numbers, so you number it your way. |
| 📁 `.workspace/plans/yymmdd-slug/plan.md` | One plan per feature (spec + design + tasks). |
| 📁 `.workspace/plans/yymmdd-slug/research.md` | Cited map of the current codebase for that feature. |
| 📁 `.workspace/plans/yymmdd-slug/learnings.md` | Per-run learnings (uncurated). |
| 📁 `.workspace/plans/archive/` | Retired/implemented plans. |
| 📁 `.workspace/learnings.md` | Curated holding pen (only `/vibe:distill` writes it). |

---

## 7. Summary — what's reusable vs. what each repo provides

**🔌 Plugin (drop-in, never edited per project):**
- 4 commands + their flows (`adopt`, `plan`, `implement`, `distill`)
- 8 agent definitions (4 domain-generic roles + 4 fixed roles)
- 6 bundled skills (all clean — no hardcoded project specifics)
- `workspace-starter/` scaffold: 2 runtime templates + 5 sample seeds

**📁 Project (authored once per consuming repo — see [`CHECKLIST.md`](CHECKLIST.md)):**
- Per-domain skills: `<domain>-architecture`, `<domain>-testing`, `<domain>-review` *(optional)*
- Repo-level skills: `environment`, `product-design`
- `.workspace/`: constitution content + plans + learnings

**⚠️ External tooling (installed/connected in the repo):**
- `codegraph` MCP, Playwright MCP

**Remaining harness limits (in the command files, not the agents):**
- The **Platform → BE → FE** block order and the **backend → frontend** design sequence are hardcoded in `plan.md` / `implement.md`. The role *agents* are domain-generic, but admitting a brand-new top-level domain (e.g. mobile) into the *flow* still needs a command edit.
- A few residual constitution **article-number** references survive in the harness (`implement.md`, `plan-template.md`) and the `constitution-sample.md` header, even though the agents and skills are otherwise decoupled from article numbers.
