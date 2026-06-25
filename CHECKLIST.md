# Project setup checklist

What a consuming repo must supply for the vibe plugin to work. The plugin (🔌) ships the harness; every item below is 📁 **project-level** — authored once per repo so the harness can bind to it. Agents resolve these **by name at runtime**; if one is absent, the agent says so and falls back to constitution + research.

**Starter** = a copy ships in `workspace-starter/` to adapt from. When adding an item here, note whether a starter exists. *(The `*-template.md` files there — `plan-template`, `research-template` — are different: the harness reads them straight from the plugin at runtime, so they're **not** project items and aren't listed below.)*

---

## Skills (`.claude/skills/`)

Resolved by name by the agent dispatched to that domain (`<domain>-architecture`, `<domain>-testing`, …).

- [ ] **`<domain>-architecture`** — a domain's structural conventions (e.g. `backend-architecture`: module/slice layout, persistence, platform subsystems, error handling, handler/event/job/MCP patterns). Resolved at runtime by the **`architect`** agent for its domain (and later by that domain's `engineer` / `reviewer` / `test-engineer`).
  - **Starter: ✅** `workspace-starter/architecture-template.md` — currently encodes a Go/GORM backend; adapt per domain/stack.

- [ ] **`<domain>-testing`** — a domain's test conventions (e.g. `backend-testing`: layers, file layout, mocking boundary, fixtures/factories, behaviour-focused structure). Resolved at runtime by the **`test-engineer`** agent for its domain (and consulted by that domain's `reviewer`).
  - **Starter: ✅** `workspace-starter/backend-testing-sample.md` — currently a Go integration-test convention; adapt per domain.

- [ ] **`<domain>-review`** *(optional)* — a domain's review **checklist**: the concrete things the `reviewer` actively flags beyond the architecture/testing conventions (e.g. `backend-review`, `frontend-review`). Resolved at runtime by the **`reviewer`** agent for its domain; if absent, the reviewer falls back to `<domain>-architecture` + `<domain>-testing` + constitution.
  - **Starter: ✅** `workspace-starter/review-checklist-sample.md` — currently a backend checklist (N+1, query perf, Go test-file split); adapt per domain.

## Documents (`.workspace/`)

- [ ] **`constitution.md`** — non-negotiable project rules, gated by `/vibe:plan` and checked by the `reviewer`. State whatever rules you need (platform-vs-feature split, build/test gates, …); the harness reads the **concepts**, not specific article numbers, so you're free to structure and number it your way.
  - **Starter: ✅** `workspace-starter/constitution-sample.md`.

## Tooling (external / MCP)

Not authored as files — installed/connected in the repo's environment. No starter ships (the plugin can't bundle external tooling); if absent, the agents that rely on it degrade to plain `Read`/`Grep` and lose their context-preserving lookups.

- [ ] **`codegraph` MCP** — the code-intelligence index every code-touching agent uses for targeted lookups (callers/callees/trace/impact) instead of wide file reads. Used by `codebase-researcher`, `architect`, `engineer`, `reviewer`, and `test-engineer`.
  - **Starter: —** (external; install + connect the MCP server in the consuming repo).
