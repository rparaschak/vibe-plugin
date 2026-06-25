# Project Setup Checklist — wiring a repo to the `vibe` plugin

`vibe` is the **portable harness**: the commands, the orchestration skills, and the cast of subagents. Everything stack-specific is intentionally left out so the same plugin drops into any of your projects. This checklist is what each repo must supply before `/vibe:plan` → `/vibe:implement` → `/vibe:distill` will run end-to-end.

Work top to bottom. Tick each box as you go.

---

## 0. Environment the bundled agents assume

The shipped agents/skills were written for a **Go-backend + React/shadcn-frontend monorepo driven by `make`, with Playwright E2E and a `codegraph` index**. If your stack matches, just satisfy these. If it differs, you'll *also* need to adjust the wording in `agents/*.md` (the `make`/`npm`/path references) — but keep the skill **names** identical so the agents resolve them.

- [ ] Repo is a monorepo with a backend dir (`api/`) and a frontend dir (`web/`, app code under `web/src/`).
- [ ] `make` targets exist and work:
  - [ ] `make check` (from `api/` and from `web/`) — lint + type-check + unit
  - [ ] `make build-api`, `make build-web` — production builds (Constitution VIII)
  - [ ] `make api-run` (API on `:5601`), `make web-run` (web on `:5600`) — backgroundable dev servers
  - [ ] `make e2e` — runs the Playwright suite
  - [ ] `make local-up` — brings up local data services (no-op where they're already native)
- [ ] Generated API client: `cd web && npm run update-api-client` regenerates the client the FE consumes.
- [ ] **`codegraph` MCP** is connected and indexed (the architects/engineers/researchers rely on it). Verify with `codegraph_status`.
- [ ] **Playwright MCP** is connected (the `qa-engineer` drives the browser through it).
- [ ] E2E/QA auth is pre-solved: a saved Playwright **storage state** (a `setup` project) so specs/QA open already signed in — never sign in inside a spec.

> If a target genuinely can't run in an environment (no Docker, no DB), that's a **Blocked**, not a pass — by design (Constitution VI–VII).

---

## 1. Install the plugin

- [ ] `/plugin marketplace add <this-repo-url-or-path>`
- [ ] `/plugin install vibe@vibe`
- [ ] Confirm `/vibe:plan`, `/vibe:implement`, `/vibe:distill` show up as slash commands.
- [ ] Confirm the 12 agents and 6 `vibe-*` skills are listed.

---

## 2. Scaffold `.workspace/` (docs the harness reads/writes)

- [ ] Copy the starter into the repo:
  ```bash
  cp -R /path/to/vibe/workspace-starter ./.workspace
  ```
- [ ] `.workspace/constitution.md` exists (adapt it in step 3).
- [ ] `.workspace/templates/plan-template.md` exists.
- [ ] `.workspace/templates/research-template.md` exists.
- [ ] Create the plans dir: `mkdir -p .workspace/plans` (plans land in `.workspace/plans/yymmdd-slug/`).
- [ ] (Optional) Seed the curated learnings holding pen:
  ```bash
  printf '# Learnings\n\nLast distilled: —\n' > .workspace/learnings.md
  ```
  (`/vibe:distill` maintains this; per-run learnings are written to each plan dir.)

---

## 3. Adapt the constitution

The starter ships generic. The harness **hard-references some article numbers** — keep these slots meaningful when editing:

- [ ] **Article V — Platform vs Feature** stays (referenced by `/vibe:plan`, `backend-architect`, `/vibe:implement`).
- [ ] **Articles VI–VII — test/QA gates** stay (the "not done until it ran" gates).
- [ ] **Article VIII — build clean** stays (`make build-api` / `make build-web`).
- [ ] Reviewers check **"Articles I–V"** — keep I–V present and real.
- [ ] Replace **Article I** (the example simplicity rule) with your project's actual one — or delete its placeholder wording and state your real assumption.
- [ ] Fix every path/tool reference to match your repo (datastore, client location, build commands).
- [ ] Keep it small — only add an article that's been violated 2× or is clearly principled (≤10 lines, one-sentence Why).

---

## 4. Author the 5 project-supplied skills

These live in **the repo's** `.claude/skills/<name>/SKILL.md` (not in this plugin). The agents reference them **by name** — names must match exactly. For each, write the conventions your code actually follows; below is who consumes it and what it must answer.

### 4.1 `backend-architecture`
- [ ] Created at `.claude/skills/backend-architecture/SKILL.md`
- **Consumed by:** `backend-architect`, `backend-engineer`, `backend-reviewer`, `backend-test-engineer` (and named in `vibe-review-discipline`).
- **Must answer:** where a feature slice lives and its shape (vertical slices, no shared service layer); error handling/translation conventions; what graduates to a shared platform package; entity/persistence patterns; naming rules. Every rule here is a review rule.

### 4.2 `frontend-architecture`
- [ ] Created at `.claude/skills/frontend-architecture/SKILL.md`
- **Consumed by:** `frontend-architect`, `frontend-engineer`, `frontend-reviewer`, `frontend-test-engineer` (and named in `vibe-review-discipline`).
- **Must answer:** component/hook decomposition; that all data access goes through the generated client + your query layer (e.g. TanStack Query); co-located `*.test.tsx`; any house style the reviewer enforces (e.g. the no-ternary rule); where pages vs shared primitives live.

### 4.3 `backend-testing`
- [ ] Created at `.claude/skills/backend-testing/SKILL.md`
- **Consumed by:** `backend-engineer`, `backend-reviewer`, `backend-test-engineer`.
- **Must answer:** integration-test layout (one test file per slice, one `Test<Action>` fn, cases as subtests); the shared test-app/harness entrypoint; real-datastore rule (no storage mocks); fixtures conventions; "use named types, never raw JSON."
- *(Renamed from `api-testing` — the plugin standardizes on `backend-testing`.)*

### 4.4 `frontend-testing`
- [ ] Created at `.claude/skills/frontend-testing/SKILL.md`
- **Consumed by:** `frontend-test-engineer`.
- **Must answer:** Playwright E2E conventions — specs under `web/e2e/*.spec.ts`, `getByRole`/`data-testid` over text, no arbitrary sleeps, auth via the shared storage state (never sign in in a spec), and the run recipe (`make api-run` + `make web-run` backgrounded → `make e2e`).
- *(Renamed from `e2e-testing` — the plugin standardizes on `frontend-testing`.)*

### 4.5 `product-design`
- [ ] Created at `.claude/skills/product-design/SKILL.md`
- **Consumed by:** `product-designer`.
- **Must answer:** explore existing UI under `web/src/` first; reuse the shadcn primitives already present (`web/src/components/ui/`) before adding new ones; output a high-level UX sketch (where it lives, screen shape, key components, edge states) — no code.

#### Skeleton (copy into each `SKILL.md`, fill the body)
```markdown
---
name: <backend-architecture | frontend-architecture | backend-testing | frontend-testing | product-design>
description: <one-line summary used for triggering — what conventions this skill encodes, for which stack>
---

# <skill name>

<The rules/conventions agents must follow. Be concrete and cite a canonical example
file in this repo for each rule. Keep it the law of the land for this stack.>
```

---

## 5. Smoke test

- [ ] `claude --plugin-dir /path/to/vibe` (or after install) in the target repo.
- [ ] Run `/vibe:plan <small feature>` — confirm: `codebase-researcher` writes `research.md`, the critic and architects run, **no "skill not found" for any `backend-architecture` / `frontend-architecture` / `backend-testing` / `frontend-testing` / `product-design`**.
- [ ] Plan finalizes to `Ready for Implement` with Open Questions `None`.
- [ ] Run `/vibe:implement` on it — confirm the block loop runs, `make check`/tests/E2E/QA actually execute, and it commits on a true Implemented finalize.
- [ ] After ~2–3 plans, run `/vibe:distill` — confirm it reads the per-run `learnings.md` files and proposes promotions.

---

## Quick reference — what each repo must provide

| Item | Where | Status when missing |
|---|---|---|
| `backend-architecture`, `frontend-architecture` skills | repo `.claude/skills/` | agents can't find structural conventions |
| `backend-testing`, `frontend-testing` skills | repo `.claude/skills/` | test engineers/reviewers lack test conventions |
| `product-design` skill | repo `.claude/skills/` | `product-designer` lacks UX conventions |
| `constitution.md` | `.workspace/` | `/vibe:plan` has nothing to gate against |
| `plan-template.md`, `research-template.md` | `.workspace/templates/` | architects/researcher have no shape to fill |
| `make` targets + generated client + codegraph + Playwright MCP + E2E auth | the repo/tooling | implement-phase gates can't run → plans stay Blocked |
