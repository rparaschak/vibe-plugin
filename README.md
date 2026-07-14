# vibe

**vibe is a harness builder.** It doesn't run your project's workflow — it *generates* one. You describe the team and commands you want; vibe stamps a self-contained, project-specific harness into your repo's own `.claude/` directory: kernel skills, agent roles, domain skills and checklists, environment scripts, and lean linear commands.

**Why generate instead of interpret?** A universal runtime command has to branch at execution time on every project shape (spec-or-not, worktree-or-not, QA-or-not, backend-then-frontend ordering) — every conditional is a path an LLM can take wrongly. vibe makes those decisions **once, at generation time**, and emits commands with zero dead branches. And because everything it writes lives **in your repo**, the harness works on Claude web, in monorepos, and for anyone who clones — no plugin needed at runtime. The plugin is a compiler you run at setup, not a dependency your project carries.

The authoritative design is in [`docs/harness-builder.md`](docs/harness-builder.md).

---

## Install

In Claude Code, add this repo as a plugin marketplace, then install the plugin:

```
/plugin marketplace add rparaschak/vibe-plugin
/plugin install vibe@vibe
```

That registers the three `/vibe:*` commands. (Or run `/plugin`, browse to the **vibe** marketplace, and install from the menu.) Installing from a local clone instead of GitHub? Point the marketplace at the path: `/plugin marketplace add /path/to/vibe-plugin`.

## Quick start

From the repo you want a harness for, describe the roster and commands you want:

```
/vibe:build-harness Implementation: architect, critic, engineer, test-engineer, manual QA.
PM + product designer for specs. Two commands: planning (design + product + technical)
and implementing (cold reviews, task split).
```

vibe parses that intent, audits your repo (read-only, via scout subagents), and emits a checklist at `.workspace/harness/checklist.md` — the gap analysis **is** the roadmap and your control point. It then stamps the harness into `.claude/` and `.workspace/`. When it finishes, your repo is self-sufficient: the generated commands and agents run entirely from your own files.

**Re-run it any time — that's the doctor.** `/vibe:build-harness` on an already-stamped repo re-audits every checklist row, upgrades sections that are stamped-and-unmodified but drifted from the current templates, and **never overwrites your edits** (anything below a file's `vibe-template:` marker is surfaced, not clobbered). An unchanged, up-to-date repo re-emits nothing.

## The three commands

| Command | What it does |
|---|---|
| **`/vibe:build-harness`** | Compiles a project-specific harness into `.claude/`. Parses intent → read-only repo audit via scouts → emits a `vibe-task-ledger` checklist → stamps kernel skills, agents, domain skills/checklists, env scripts, and lean linear commands. Re-run = doctor mode. Never touches application code. |
| **`/vibe:build-flow`** | Compiles ONE ad-hoc, project-local flow (a strangler-fig refactor, a slice extraction, a one-off migration) into a lean linear command in your `.claude/commands/`. Elicits a flow-spec, lints it mechanically (references resolve on disk, gates present, single artifact), and stamps it through the command skeleton. Writes `.claude/commands/<slug>.md` + `.claude/flows/<slug>.md`. Never runs the flow. |
| **`/vibe:distill`** | The learning flywheel, run inside a stamped project every ~2–3 implemented plans. Sweeps accumulated learnings, verifies staleness, and routes each survivor up a promotion ladder — mechanize → skill → constitution → plugin-template proposal → keep → retire. Every mutation is user-approved. Kernel-grade lessons emit a proposal diff you apply upstream by hand; it never writes into the plugin install. |

## What gets generated into your project

Everything lands under your repo's `.claude/` and `.workspace/`:

- **Kernel skills** (`.claude/skills/vibe-*`) — four load-bearing protocols, default-on, stamped verbatim and inherited *structurally* (a generated command cannot silently drop them):
  - **`vibe-task-ledger`** — the leaf task schema: `behavior` / `verification` / `state` / `evidence`, a closed state enum (`not_started | active | blocked | passing`, `passing` irreversible), WIP=1, and orchestrator-only, evidence-gated transitions.
  - **`vibe-research-protocol`** — the context-discipline escalation ladder (cited map → codegraph → Explore → codebase-researcher).
  - **`vibe-team-protocol`** — SendMessage channel rules, done-format, the andon cord, and spawn/dispatch/teardown mechanics.
  - **`vibe-review-protocol`** — three-pass review with a 0–2 × 6-dimension rubric → Accept / Revise / Block.
- **Agents** (`.claude/agents/`) — the roles you asked for, drawn from the template library, each audited against the agent standard at generation time.
- **Domain skills & checklists** (`.claude/skills/`) — one `<component>-architecture`, `<component>-review`, and `<component>-testing` per detected component, plus `environment` and (for UI repos) `product-design`.
- **Environment scripts** (`.claude/scripts/`) — self-verifying `env-up.sh` and `test-run.sh`, so agents never improvise build/test commands.
- **Commands** (`.claude/commands/`) — lean, linear, per-preset.
- **Workspace** (`.workspace/`) — a `constitution.md` seed (stamped once, yours to own) and the plans/learnings layout the commands read and write.

## Presets

The old universal pipeline is demoted to reference presets the builder instantiates:

- **`plan-implement`** — technical / backend projects: **plan → implement**.
- **`spec-plan-implement`** — product / fullstack projects: **spec → plan → implement**.

Each stamped project diverges freely afterward and carries none of the other's edge cases.

## Repo layout

```
commands/           the 3 plugin commands: build-harness, build-flow, distill
templates/kernel/   the 4 kernel skills stamped into every harness
templates/agents/   9 agent role templates (architect, critic, engineer, reviewer, …)
templates/checklists/  review checklists: backend / frontend / generic
templates/scripts/  env-up + test-run script templates
templates/skeletons/   command + flow skeletons (fixed kernel sections)
templates/workspace/   doc templates + sample skills stamped into a project
presets/            plan-implement, spec-plan-implement
standards/          agent, command, and composition standards the builder audits against
docs/               design docs (harness-builder.md is authoritative)
```
