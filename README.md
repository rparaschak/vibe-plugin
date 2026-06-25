# vibe

A portable Claude Code **plugin** for feature planning, implementation, and knowledge distillation. `vibe` is the generic harness — a team-lead orchestrating a fixed cast of subagents through a research → plan → implement → distill flow. Each consuming project supplies its own stack conventions (architecture / testing / design skills) and its own `.workspace/` playbook.

> **Setting up a new repo?** Follow **[CHECKLIST.md](./CHECKLIST.md)** — a step-by-step for creating the project-supplied skills, the `.workspace/` docs, and the tooling the harness assumes.

## What's inside

### Commands (slash commands)

| Command | What it does |
|---|---|
| `/vibe:plan` | Researches the codebase into a cited `research.md`, frames behaviors, gates them with an adversarial critic, sizes the work, decomposes into one-team-sized plans, then designs data model + architecture + tasks + tests. Produces `plan.md`. |
| `/vibe:implement` | Executes ONE plan in a single run with one team — builds blocks Platform → BE → FE, each through engineer → test → review → fix, then marks the plan Implemented and commits. |
| `/vibe:distill` | Closes the knowledge flywheel — classifies `learnings.md` entries, verifies staleness, promotes durable lessons up the encoding ladder (mechanize → skill → constitution → template), retires stale ones. |

### Skills (bundled — the vibe harness itself)

- **vibe-team-orchestration** — dispatch via an agent team (default mode).
- **vibe-solo-orchestration** — dispatch via stateless single-shot subagents (fallback when `SendMessage` is unavailable).
- **vibe-team-communication-protocol** — how agents talk to each other (channel discipline, done-format, andon cord).
- **vibe-review-discipline** — how reviewers review a block's diff (read-only, three-pass, approve/findings formats).
- **vibe-product-critique** — how the product-critic adversarially critiques draft behaviors.
- **vibe-manual-testing** — how the qa-engineer drives the running app through the Playwright MCP browser.

### Agents (subagents the commands dispatch)

| Plan phase | Implement phase |
|---|---|
| `codebase-researcher` | `backend-engineer`, `backend-test-engineer`, `backend-reviewer` |
| `product-designer`, `product-critic` | `frontend-engineer`, `frontend-test-engineer`, `frontend-reviewer` |
| `backend-architect`, `frontend-architect` | `qa-engineer` (+ architects on-call) |

`/vibe:distill` dispatches `codebase-researcher` to verify staleness.

## Project-supplied skills (NOT bundled — you provide these per repo)

The vibe harness is deliberately stack-agnostic. The engineering/review/test/design agents reference convention skills **by name** that each consuming repo must define in its own `.claude/skills/`:

| Skill name | Used by | Should contain |
|---|---|---|
| `backend-architecture` | backend-architect / engineer / reviewer / test-engineer | structural rules for your backend |
| `frontend-architecture` | frontend-architect / engineer / reviewer / test-engineer | structural rules for your frontend |
| `backend-testing` | backend-engineer / reviewer / test-engineer | backend integration-test + fixture conventions |
| `frontend-testing` | frontend-test-engineer | E2E (Playwright) spec conventions |
| `product-design` | product-designer | your app's UX/UI conventions |

If a repo doesn't define one of these, the agent simply won't find it — author them once per project. (They were intentionally left out so the same base harness drops into any of your projects.)

## Project-supplied workspace (`.workspace/`)

The commands read and write a per-repo `.workspace/`:

- `.workspace/constitution.md` — non-negotiable project rules (gated by `/vibe:plan`).
- `.workspace/templates/plan-template.md`, `research-template.md` — the plan/research shapes.
- `.workspace/plans/yymmdd-slug/` — where each plan + its `research.md` + `learnings.md` live.
- `.workspace/learnings.md` — the curated holding pen `/vibe:distill` maintains.

**Starter copies ship in [`workspace-starter/`](./workspace-starter/).** Scaffold a new repo with:

```bash
cp -R /path/to/vibe/workspace-starter ./.workspace
# then edit .workspace/constitution.md for your project's real rules
```

The starter `constitution.md` is generic — adapt the stack-specific articles to your project. The harness hard-references some article *numbers* (Article V = Platform vs Feature; VI–VII = test/QA gates; VIII = build clean), so keep those slots meaningful.

## Install

```text
# add this repo as a marketplace
/plugin marketplace add <this-repo-url-or-path>

# install the plugin
/plugin install vibe@vibe
```

For a local test run without installing:

```bash
claude --plugin-dir /path/to/vibe
```

## Notes

- No hooks ship with this plugin.
- No absolute paths are baked in — all references are project-relative (`.workspace/`, `.claude/`).
- `/vibe:distill` promotes lessons into the **consuming project's** `.claude/skills` & `.claude/agents`, not into this plugin — that's intentional project-local curation.
