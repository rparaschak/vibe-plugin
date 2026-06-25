# Project setup checklist

What a consuming repo must supply for the vibe plugin to work. The plugin (🔌) ships the harness; every item below is 📁 **project-level** — authored once per repo so the harness can bind to it. Agents resolve these **by name at runtime**; if one is absent, the agent says so and falls back to constitution + research.

**Starter** = a copy ships in `workspace-starter/` to adapt from. When adding an item here, note whether a starter exists.

---

## Skills (`.claude/skills/`)

Resolved by name by the agent dispatched to that domain (`<domain>-architecture`, `<domain>-testing`, …).

- [ ] **`backend-architecture`** — the backend's structural conventions: module/slice layout, persistence, platform subsystems, error handling, handler/event/job/MCP patterns. Resolved at runtime by the **`architect`** agent when dispatched to the `backend` domain (and later by the backend engineer / reviewer / test-engineer).
  - **Starter: ✅** `workspace-starter/templates/architecture-template.md` — currently encodes a Go/GORM backend; adapt to your stack. (Note: it lives under `templates/` but is really the seed for this *skill*, not a `.workspace` artifact.)

## Documents (`.workspace/`)

- [ ] **`constitution.md`** — non-negotiable project rules, gated by `/vibe:plan` and checked by reviewers. Keep the hard-referenced Article slot numbers meaningful: **V** = Platform vs Feature, **VI–VII** = test/QA gates, **VIII** = build clean. Renumbering them silently breaks the harness.
  - **Starter: ✅** `workspace-starter/constitution.md`.
