# Project setup checklist

What a consuming repo must supply for the vibe plugin to work. The plugin (🔌) ships the harness; every item below is 📁 **project-level** — authored once per repo so the harness can bind to it. Agents resolve these **by name at runtime**; if one is absent, the agent says so and falls back to constitution + research.

This list is also the **contract `/vibe:adopt` drives**: that command reads it, detects what your repo already has, writes `.workspace/adoption-checklist.md`, and walks you through closing each gap. Keep the items here enumerable (`- [ ]` + a `Starter:` line) so adopt can parse them.

**Starter** = a copy ships in `workspace-starter/` to adapt from. When adding an item here, note whether a starter exists. *(The `*-template.md` files there — `plan-template`, `research-template` — are different: the harness reads them straight from the plugin at runtime, so they're **not** project items and aren't listed below.)*

---

## Skills (`.claude/skills/`)

Resolved by name at runtime. Most are **per-domain** (`<domain>-architecture`, `<domain>-testing`, …), resolved by the agent dispatched to that domain; `environment` and `product-design` are **repo-level** skills, resolved by plain name.

- [ ] **`<domain>-architecture`** — a domain's structural conventions (e.g. `backend-architecture`: module/slice layout, persistence, platform subsystems, error handling, handler/event/job/MCP patterns). Resolved at runtime by the **`architect`** agent for its domain (and later by that domain's `engineer` / `reviewer` / `test-engineer`).
  - **Starter: ✅** `workspace-starter/architecture-sample.md` — currently encodes a Go/GORM backend; adapt per domain/stack.

- [ ] **`<domain>-testing`** — a domain's test conventions (e.g. `backend-testing`: layers, file layout, mocking boundary, fixtures/factories, behaviour-focused structure). Resolved at runtime by the **`test-engineer`** agent for its domain (and consulted by that domain's `reviewer`).
  - **Starter: ✅** `workspace-starter/backend-testing-sample.md` — currently a Go integration-test convention; adapt per domain.

- [ ] **`<domain>-review`** *(optional)* — a domain's review **checklist**: the concrete things the `reviewer` actively flags beyond the architecture/testing conventions (e.g. `backend-review`, `frontend-review`). Resolved at runtime by the **`reviewer`** agent for its domain; if absent, the reviewer falls back to `<domain>-architecture` + `<domain>-testing` + constitution.
  - **Starter: ✅** `workspace-starter/review-checklist-sample.md` — currently a backend checklist (N+1, query perf, Go test-file split); adapt per domain.

- [ ] **`environment`** — the **one repo-level skill** (not per-domain): the dev-environment commands and how the harness verifies work — how to bring infra/the app up, the **lint + build** command, how to run each **test layer** (unit / integration / component / E2E), codegen/client-regen, and the **verification decision logic** (which verifications a change triggers; in a monorepo a backend change re-runs the dependent clients' tests). The plugin enforces *that* verification happens and at what evidence level; this skill supplies *how*. Resolved by name by the **`engineer`** (lint + build), **`test-engineer`** (run the layers), **`reviewer`** (verify green), and **`qa-engineer`** (bring the app up). If absent, those agents andon-cord rather than guess commands.
  - **Starter: ✅** `workspace-starter/environment-sample.md` — currently a Go/`make` backend + `yarn` frontend monorepo; adapt per repo.

- [ ] **`product-design`** *(needed only if the repo has a UI)* — the other **repo-level** skill: the app's UX/UI conventions (design system, component library, layout/interaction patterns) the `product-designer` proposes against. Resolved by name by the **`product-designer`** agent; if absent, it proposes from the existing UI alone.
  - **Starter: —** (none yet; author from the repo's existing UI and design system).

## Documents (`.workspace/`)

- [ ] **`constitution.md`** — non-negotiable project rules, gated by `/vibe:plan` and checked by the `reviewer`. State whatever rules you need (platform-vs-feature split, build/test gates, …); the harness reads the **concepts**, not specific article numbers, so you're free to structure and number it your way.
  - **Starter: ✅** `workspace-starter/constitution-sample.md`.

## Tooling (external / MCP)

Not authored as files — installed/connected in the repo's environment. No starter ships (the plugin can't bundle external tooling); if absent, the agents that rely on it degrade to plain `Read`/`Grep` and lose their context-preserving lookups.

- [ ] **`codegraph` MCP** — the code-intelligence index every code-touching agent uses for targeted lookups (callers/callees/trace/impact) instead of wide file reads. Used by `codebase-researcher`, `architect`, `engineer`, `reviewer`, and `test-engineer`.
  - **Starter: —** (external; install + connect the MCP server in the consuming repo).

- [ ] **Playwright MCP** — the browser-automation server used to drive the running app: the `qa-engineer`'s manual click-through and the `test-engineer`'s FE/E2E specs both rely on it. Used by `qa-engineer` and `test-engineer` (frontend / user-facing blocks).
  - **Starter: —** (external; install + connect the MCP server in the consuming repo).
