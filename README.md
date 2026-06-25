# vibe

A portable Claude Code **plugin** for feature planning, implementation, and knowledge distillation. `vibe` is the generic harness — a team-lead orchestrating a fixed cast of subagents through a research → plan → implement → distill flow. Each consuming project supplies its own stack conventions (architecture / testing / design skills) and its own `.workspace/` playbook.

The rest of this document is a complete inventory of everything the plugin is made of: commands, agents, skills, flows, and the project-supplied layer it binds to. Every item carries an **icon** showing where it lives / who owns it, so we can see at a glance what is reusable harness vs. what each consuming repo must provide.

## Legend

| Icon | Meaning |
|---|---|
| 🔌 **Plugin** | Bundled with vibe. Lives in this repo. Stack-agnostic, reusable as-is across projects. |
| 📁 **Project** | Supplied by the consuming repo (`.claude/skills/`, `.workspace/`). Not bundled. Encodes that repo's conventions. |
| ⚠️ **Leak** | Currently lives in the plugin (🔌) but hardcodes project-specific values (commands, ports, stack names). Should become 📁 to be reusable. |

The core design intent: the **harness** (commands + orchestration discipline + agent roles) is 🔌 and never changes per project; the **conventions** (architecture / testing / design / environment) are 📁 and differ per project. The ⚠️ items are where that separation currently leaks.

---

## 1. Commands (slash commands)

Located in `commands/`. These own the phase algorithms (the flows). All three read/write the 📁 `.workspace/` and dispatch 🔌 agents.

| Command | What it does |
|---|---|
| 🔌 `/vibe:plan` | Team-lead for **planning**. Researches the codebase into a cited `research.md`, frames behaviors, gates them with an adversarial critic, sizes the work, decomposes into one-team-sized plans, then designs data model + architecture + tasks + tests. Produces `plan.md`. Never touches code. |
| 🔌 `/vibe:implement` | Team-lead for **implementation**. Executes ONE plan in one run: builds blocks Platform → BE → FE, each through engineer → test → review → fix, then marks the plan Implemented and commits. Never writes code/tests itself. |
| 🔌 `/vibe:distill` | Curator of the playbook. Classifies `learnings.md` entries, verifies staleness, promotes durable lessons up the encoding ladder (mechanize → skill → constitution → template), retires stale ones. Writes only to 📁 `.workspace/**` and `.claude/**`. |

---

## 2. Flows (phase algorithms) — 🔌 Plugin

The flows are hardcoded in the command files. They reference 📁 artifacts (constitution, templates, plans) and dispatch 🔌 agents.

### `/vibe:plan` flow
`research → frame → draft behaviors → critic gate → size/decompose → [UX ‖ BE-arch] → FE-arch → self-review → finalize`

| Step | Agent dispatched | Notes |
|---|---|---|
| Load context | — | Reads 📁 `constitution.md` + 📁 `templates/`. |
| Research | `codebase-researcher` | Writes 📁 `research.md`; lead reads only `## Summary`. |
| Frame | — (user) | `AskUserQuestion` on 2–3 high-leverage forks. |
| Draft behaviors | — (lead) | Problem, Behaviors (B-NNN), Out of Scope, Assumptions. |
| Critic gate | `product-critic` | Locks behaviors before any design. |
| Size / decompose | (architects, rough count only) | Splits into separate dependent plans if too big. |
| Design fan-out | `product-designer` ‖ `backend-architect` | Run in parallel (no dependency). |
| Join | `frontend-architect` | Needs locked UX + BE design. |
| Self-review | responsible architect | Gate-only, up to 3 revise cycles. |

> **Reuse limit:** steps 8–9 hardcode a **Backend → Frontend** sequence and dispatch `backend-architect` / `frontend-architect` by name. A new domain (e.g. mobile) has no slot here.

### `/vibe:implement` flow
`resolve plan → gate check → build run list → per-block loop → finalize`

- **Block order (hardcoded): Platform → BE → FE.**
- **Per-block loop:** engineer → test-engineer → reviewer → (fix → re-review)* → done.
- **"Done"** = reviewer approved AND tests green (actually executed).
- **"Implemented"** = every block done AND E2E green AND manual QA passed; else `Blocked — Implement`.
- Finalize: Status → Implemented, move plan to `.workspace/plans/archive/`, commit.

> **Reuse limit:** block order and the BE/FE engineer/test/reviewer roster are hardcoded; no mobile/other-domain slot.

### `/vibe:distill` flow
`load inputs → verify staleness (codebase-researcher) → classify → approve (user) → apply & prune`

- Encoding ladder: **mechanize → skill → constitution → template → keep → retire**.
- Promotes into the 📁 consuming project's `.claude/skills` & `.claude/agents` — never into this plugin.

---

## 3. Agents

All 12 live in `agents/`. The agent **definitions** are 🔌. Each declares 🔌 skills in its `skills:` frontmatter, and most reference 📁 project skills **by name inline in the body** ("follow this project's own `X` skill"). The ⚠️ column flags agents that also hardcode environment commands/ports.

| Agent | 🔌 Plugin skills | 📁 Project skills | ⚠️ Hardcoded env | What it does |
|---|---|---|---|---|
| 🔌 `codebase-researcher` (sonnet) | team-communication-protocol | — | — | Maps current code state around a feature into 📁 `research.md`, every claim cited `file:line`. Facts only; designs nothing. |
| 🔌 `product-designer` (opus) | team-communication-protocol | product-design | — | Explores existing UI, proposes a pragmatic shadcn-based UX (read-only, no code). Iterates with invoker. |
| 🔌 `product-critic` (opus) | team-communication-protocol, product-critique | — | — | Adversarial user-advocate review of draft Behaviors before any UX/architecture. Read-only findings. |
| 🔌 `backend-architect` (opus, xhigh) | team-communication-protocol | backend-architecture | — | Designs BE sections of the plan — data model, BE architecture, Platform subsystems (Article V), BE tasks, test behaviors. No code. |
| 🔌 `frontend-architect` (opus) | team-communication-protocol | frontend-architecture | — | Designs FE sections — UX wiring, FE architecture, components/hooks, FE tasks, test behaviors — against locked UX + BE design. No code. |
| 🔌 `backend-engineer` (opus) | team-communication-protocol | backend-architecture, backend-testing | make check (api/) | Implements a Platform/BE block (entities, slices, routes, persistence). Does not write tests or redesign. |
| 🔌 `backend-test-engineer` (opus) | team-communication-protocol | backend-architecture, backend-testing | make check | Writes BE integration tests against implemented code, real DB. No production code. |
| 🔌 `backend-reviewer` (opus) | team-communication-protocol, review-discipline | backend-architecture, backend-testing | make check (api/) | Read-only three-pass review of a Platform/BE diff vs plan + architecture skill + constitution. |
| 🔌 `frontend-engineer` (opus) | team-communication-protocol | frontend-architecture | make check (web/), npm run update-api-client | Implements the FE block (pages, components, hooks). Regenerates API client first. No tests/redesign. |
| 🔌 `frontend-test-engineer` (opus) | team-communication-protocol | frontend-architecture, frontend-testing | make api-run/web-run, ports :5601/:5600, make e2e, make check | Writes component tests (Vitest + RTL) + Playwright E2E specs and runs them green. No production code. |
| 🔌 `frontend-reviewer` (opus) | team-communication-protocol, review-discipline | frontend-architecture | make check (web/) | Read-only three-pass review of the FE diff vs plan + architecture skill + constitution. |
| 🔌 `qa-engineer` (sonnet) | team-communication-protocol, manual-testing | — (env baked into manual-testing skill) | make api-run/web-run, ports :5601/:5600, make local-up | Manual QA: drives the running app via Playwright MCP, confirms Behaviors. No code/tests. |

> **Reuse limit:** the four roles **architect / engineer / test-engineer / reviewer** each exist as a hardcoded **backend-** and **frontend-** pair (8 of the 12 agents). A new domain requires 4 new agent files. The intended fix is one domain-generic agent per role that resolves `<domain>-architecture` / `<domain>-testing` at runtime.

---

## 4. Skills

### 4a. Bundled skills

Located in `skills/`. These are the harness itself: orchestration discipline and review/critique/QA **method**. Stack-agnostic.

| Skill | What it does | Used by |
|---|---|---|
| 🔌 `vibe-team-communication-protocol` | Rules for how agents talk via SendMessage — channel discipline, done-format, andon-cord escalation, role boundaries. | Every agent |
| 🔌 `vibe-team-orchestration` | How the team-lead dispatches via a persistent named-agent team. Spawn, dispatch, context, teardown. | `/vibe:plan`, `/vibe:implement` |
| 🔌 `vibe-review-discipline` | Reviewer method: read-only stance, three-pass review, what to check against, approve/findings formats. | `reviewer` |
| 🔌 `vibe-product-critique` | Adversarial critique method: user-advocate stance, 8 attack lenses, findings format. | product-critic |
| ⚠️ `vibe-manual-testing` | QA method: click-through via Playwright MCP, pre-auth session, pass/findings format. **Mostly 🔌 method, but hardcodes 📁 env** (`make api-run`/`web-run`, ports `:5601`/`:5600`, `make local-up`). | qa-engineer |

### 4b. Project-supplied skills

NOT bundled. Each consuming repo authors these under `.claude/skills/`. Agents reference them **by name**; if absent, the agent simply won't find it. These encode per-repo conventions.

| Skill | What it should contain | Referenced by |
|---|---|---|
| 📁 `backend-architecture` | Structural rules for the backend (slices, persistence, platform subsystems). | backend-architect / engineer / reviewer / test-engineer |
| 📁 `frontend-architecture` | Structural rules for the frontend (components/hooks, data access, generated client + TanStack Query). | frontend-architect / engineer / reviewer / test-engineer |
| 📁 `backend-testing` | Backend integration-test + fixture conventions (one file per slice, real DB). | backend-engineer / reviewer / test-engineer |
| 📁 `frontend-testing` | E2E (Playwright) + component-test spec conventions. | frontend-test-engineer |
| 📁 `product-design` | The app's UX/UI conventions (design system, shadcn usage). | product-designer |
| 📁 `environment` *(does not exist yet)* | **Currently a ⚠️ leak.** The one place a repo declares how to run/build/test itself — run commands, ports, build/check/e2e targets, client-regen. Today these are hardcoded in `vibe-manual-testing` + agent bodies. | qa / test-engineers / engineers / reviewers |

---

## 5. Environment / tooling assumptions — ⚠️ Leak → should be 📁 Project

These are project-specific values currently hardcoded across the plugin (the `vibe-manual-testing` skill and several agent bodies). They are the third runtime category and the main thing blocking drop-in reuse.

| Item | Where it's hardcoded | What it is |
|---|---|---|
| ⚠️ `make api-run` → port `:5601` | vibe-manual-testing, frontend-test-engineer, qa-engineer | Start API (E2E auth mode). |
| ⚠️ `make web-run` → port `:5600` | vibe-manual-testing, frontend-test-engineer, qa-engineer | Start web dev server (E2E auth mode). |
| ⚠️ `make e2e` | frontend-test-engineer | Run Playwright E2E suite. |
| ⚠️ `make check` (api/ and web/) | backend/frontend engineer / reviewer / test-engineer | Build + lint + type-check + tests for touched packages. |
| ⚠️ `make build-api`, `make build-web` | constitution (Article VIII) | Clean-build gate. |
| ⚠️ `make local-up` | vibe-manual-testing | Bring data stack up locally. |
| ⚠️ `npm run update-api-client` | frontend-architect, frontend-engineer | Regenerate the typed API client before consuming BE contracts. |
| ⚠️ `codegraph` MCP | all code-touching agents | Code-intelligence index the harness assumes is present. External tooling. |
| ⚠️ Playwright MCP | qa-engineer, frontend-test-engineer | Browser automation the harness assumes is present. External tooling. |

---

## 6. Workspace (`.workspace/`) — 📁 Project

The per-repo playbook. Read/written by the commands; discovered at runtime relative to repo root (no absolute paths baked in). A 🔌 **starter** ships in `workspace-starter/`.

| Item | What it is |
|---|---|
| 📁 `.workspace/constitution.md` | Non-negotiable project rules (Articles I–VIII). Gated by `/vibe:plan`, checked by reviewers. |
| 📁 `.workspace/templates/plan-template.md` | Exact shape every `plan.md` must follow. **(exists)** |
| 📁 `.workspace/templates/research-template.md` | Exact shape every `research.md` must follow. **(exists)** |
| 📁 `.workspace/templates/learnings-template.md` | Exact shape every per-run + curated `learnings.md` must follow. **⚠️ MISSING — should be added.** |
| 📁 `.workspace/plans/yymmdd-slug/plan.md` | One plan per feature (spec + design + tasks). |
| 📁 `.workspace/plans/yymmdd-slug/research.md` | Cited map of current codebase for that feature. |
| 📁 `.workspace/plans/yymmdd-slug/learnings.md` | Per-run learnings (uncurated). |
| 📁 `.workspace/plans/archive/` | Retired/implemented plans. |
| 📁 `.workspace/learnings.md` | Curated holding pen (only `/vibe:distill` writes it). |
| 🔌 `workspace-starter/` | Starter copies of the above, shipped in the plugin to scaffold a new repo. |

> **Templates check:** the harness produces three durable artifacts — `plan.md`, `research.md`, `learnings.md`. Templates exist for the first two; **`learnings-template.md` is missing** even though both the per-run and curated learnings files have a defined structure the distill flow depends on. Add it to `workspace-starter/templates/`.

> **Hard-referenced contract:** the harness hard-references constitution article *numbers* — **Article V** (Platform vs Feature), **VI–VII** (test/QA gates), **VIII** (build clean). The article *content* is 📁; the *slot numbers* are a 🔌 contract that must stay meaningful.

---

## 7. Summary — what's reusable vs. what each repo provides

**🔌 Plugin (drop-in, never edited per project):**
- 3 commands + their flows
- 12 agent definitions
- 6 bundled skills (5 clean + `vibe-manual-testing` with an env leak)
- `workspace-starter/` scaffold
- Hard-referenced constitution article numbers (V, VI–VII, VIII)

**📁 Project (authored once per consuming repo):**
- 5 convention skills: `backend-architecture`, `frontend-architecture`, `backend-testing`, `frontend-testing`, `product-design`
- `.workspace/` (constitution content, templates, plans, learnings)
- External tooling: codegraph MCP, Playwright MCP, the `make` targets

**⚠️ Leaks & gaps blocking clean reuse:**
- Environment commands + ports baked into `vibe-manual-testing` and agent bodies → should be one `environment` skill
- The 4 role agents hardcoded as backend/frontend pairs → should be domain-generic roles resolving `<domain>-architecture` / `<domain>-testing` at runtime
- The BE→FE flow in `plan.md` / `implement.md` → should be domain-driven to admit new domains (e.g. mobile)
- `learnings-template.md` missing from `workspace-starter/templates/`
