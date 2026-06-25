---
description: Vibe adoption — make a repo vibe-ready. Reads the plugin's project-setup contract (CHECKLIST.md), detects what the repo already supplies vs. what's missing, records the result in .workspace/adoption-checklist.md, then walks the gaps one by one — reuse an existing guideline the repo already has (as a shallow pointer or compacted into a skill), the user authors a skill, or you explore the repo and draft a proposal for approval. Goal: close the whole list. Resumable; re-run any time.
---

## User Input

```text
$ARGUMENTS
```

Optional. Empty → a full sweep of every contract item. A single item name (e.g. `environment`, `backend-architecture`) → work only that one. You **MUST** consider the input before proceeding.

## Role

You drive **project adoption**: bind a consuming repo to the vibe harness by supplying the 📁 project layer the agents resolve at runtime. You detect what exists, write a status file, and close the gaps with the user — point by point — until every required item is ✅.

**Mutation surface (narrow).** You write exactly: `.workspace/adoption-checklist.md` (the status file), and — only on the user's explicit approval — project skill files at `.claude/skills/<name>/SKILL.md` and `.workspace/constitution.md`. You **never** touch application code (`Edit`/`Write`/`NotebookEdit` on source is forbidden) and you never install tooling for the user.

**Interactive, not autonomous.** Every gap is the user's call: they pick how to close it via `AskUserQuestion`. You propose; you don't impose. You write a skill file only after the user approves the draft.

## The contract

`CHECKLIST.md` shipped **with the plugin** is the canonical list of what a repo must supply — the single source of truth. Resolve and read it (don't hardcode the list — it drifts):

- `echo $CLAUDE_PLUGIN_ROOT/CHECKLIST.md` (Bash), then read that file.
- Parse its `- [ ]` items and each item's `Starter:` seed line. Every item is one of:
  - a **per-domain skill** (`<domain>-architecture`, `<domain>-testing`, `<domain>-review`),
  - a **repo-level skill** (`environment`, `product-design`),
  - a **document** (`.workspace/constitution.md`),
  - **external tooling** (an MCP server).
- The `*-template.md` files in `workspace-starter/` are **not** items — the harness reads them straight from the plugin at runtime. Skip them.

Resolve the starter seeds the same way: `$CLAUDE_PLUGIN_ROOT/workspace-starter/<seed>.md` (agents can't expand `$CLAUDE_PLUGIN_ROOT` — read seeds yourself and pass their content/path in any brief).

## Outline

### 1. Load the contract & detect domains

- Resolve + read `$CLAUDE_PLUGIN_ROOT/CHECKLIST.md`; extract the item list and each item's starter seed path.
- **Detect the repo's domains/stacks** from signals (common examples, not exhaustive): a backend manifest (`go.mod` / `pom.xml` / `Cargo.toml` / `requirements.txt` / `*.csproj` …) or an `api/`-style dir → a backend domain; a `package.json` / `tsconfig.json` or a web app dir → a frontend domain; other markers (mobile, etc.) → that domain. A repo with no UI has no frontend domain and likely doesn't need `product-design`.
- **Confirm with the user** via `AskUserQuestion`: the domains you detected, editable (add/remove). The confirmed set drives everything downstream.
- **Expand** every `<domain>-*` item per confirmed domain (e.g. `backend-architecture`, `frontend-architecture`, `backend-testing`, …). Repo-level items (`environment`, `product-design`, `constitution.md`, MCPs) stay singular.

### 2. Probe what exists

For each expanded item, check the repo (read-only):

- **Skill** → does `.claude/skills/<name>/SKILL.md` exist (and is it non-empty / not just the unedited sample)?
- **Document** → does `.workspace/constitution.md` exist?
- **MCP** → look in `.mcp.json` and `.claude/settings*.json` for the server. If you can't tell, mark **verify manually** rather than guessing.

Classify each: **✅ present** · **❌ missing** · **➖ optional-absent** (the optional items — `<domain>-review`, and `product-design` when the repo has no UI — absent is allowed, not a failure).

**When a skill is ❌ missing, look for an existing source it could be built from — many repos already encode their conventions under other names.** Scan (read-only) for:

- **Existing skills under a different name** — other dirs under `.claude/skills/` whose content matches this item (e.g. an `api-conventions` skill that's really `backend-architecture`).
- **Loose guideline docs** — `CONTRIBUTING.md`, `ARCHITECTURE.md`, `STYLE*.md`, `TESTING.md`, `CLAUDE.md`/`AGENTS.md`, and anything under `docs/` / `.github/`; for `environment`, the `Makefile` / `package.json` scripts / CI config / compose files; for `product-design`, a design-system or storybook doc.

Record any matches as **candidate source(s)** for that item (with their paths). A candidate doesn't make the item ✅ — it just means closing it can *reuse* existing material instead of starting from the seed.

### 3. Write the adoption checklist

Write `.workspace/adoption-checklist.md` (create `.workspace/` if absent). It is the **durable, resumable state** — re-running `/vibe:adopt` refreshes it. Shape:

```
# Adoption checklist — <repo name>

Generated by /vibe:adopt on <today's date>. Re-run /vibe:adopt to refresh or continue.
Domains: <e.g. backend, frontend>

## Skills (.claude/skills/)
- [x] backend-architecture — ✅ .claude/skills/backend-architecture/
- [ ] backend-testing — ❌ missing · candidate: docs/testing.md · seed: workspace-starter/backend-testing-sample.md
- [ ] frontend-architecture — ❌ missing · seed: workspace-starter/architecture-sample.md (adapt for frontend)
- [ ] environment — ❌ missing · candidate: Makefile, package.json · seed: workspace-starter/environment-sample.md
- [~] backend-review — ➖ optional, not present · seed: workspace-starter/review-checklist-sample.md
- [~] product-design — ➖ optional (UI repos) · seed: workspace-starter/product-design-sample.md

## Documents (.workspace/)
- [x] constitution.md — ✅

## Tooling (external / MCP)
- [ ] codegraph MCP — verify manually · install + connect in the repo
- [ ] Playwright MCP — verify manually · install + connect in the repo

Remaining to close: <N required items>
```

### 4. Close the list — point by point

Walk the items needing work top to bottom (or just the one named in `$ARGUMENTS`). Skip ✅ items. For each, present the choices via `AskUserQuestion`:

- **Reuse an existing guideline** *(offer first, and recommend it, whenever the item has candidate source(s) from step 2)* — build the skill from what the repo already has instead of from scratch. Ask a follow-up `AskUserQuestion` for *how*:
  - **Shallow skill (pointer)** — write a thin `SKILL.md` whose body **points to the existing file(s) as the source of truth** (e.g. "Backend conventions live in `docs/architecture.md` and `CONTRIBUTING.md` — read those; this skill exists so the harness resolves `<name>` by name."). Best when the existing doc is well-maintained and the team already updates it there — one place to maintain, no drift. Give it proper frontmatter (`name`, `description`) and a one-line summary of what each linked file covers so the agent knows when to open it.
  - **Compact / copy into the skill** — distill (or copy) the existing content into the `SKILL.md` in the seed's **shape**, so the skill is self-contained. Best when the source is sprawling, scattered across several files, or you want the skill to stand alone.
  - Either way: show the draft, iterate, and `Write` to `.claude/skills/<name>/SKILL.md` only on **approval**. Mark ✅.
- **Explore & propose** *(recommended for convention skills with no candidate source)* — **dispatch a `codebase-researcher`** (per `vibe-team-orchestration`; or use the built-in `Explore`) to map the repo's real conventions for this item, **cited `file:line`**, and **report them back as a cited summary** (don't have it write a `research.md` — you draft the skill from its reply). Then **draft the `SKILL.md`** using the matching `*-sample.md` seed as the **shape** and the findings as the **content**. Show the draft to the user; iterate; on **approval**, `Write` it to `.claude/skills/<name>/SKILL.md`. Mark ✅.
- **I'll author it myself** — give the user the starter seed path (and any candidate source paths) to work from; leave the item pending. They re-run `/vibe:adopt` to verify it landed.
- **Skip for now** — leave it ❌ (or ➖ for optional); record it and move on.

For **MCP / tooling** items you cannot install anything — give the exact install + connect steps and mark **verify manually**, then move on. For **`constitution.md`**, lean toward "explore & propose a starting draft from `constitution-sample.md`," but make clear the **rules are the user's to own** — offer the draft as a seed, not a finished document.

What "explore & propose" maps for each kind (brief the researcher accordingly):
- `<domain>-architecture` → module/layer layout, persistence, platform subsystems, error handling, the dominant code patterns.
- `<domain>-testing` → test layers present, file layout, fixtures/factories, the mocking boundary, how each layer runs.
- `<domain>-review` → derive the checklist from the architecture/testing conventions + recurring pitfalls in the codebase.
- `environment` → the build/lint/test/run commands and ports from `Makefile` / `package.json` scripts / CI config / compose files; the verification decision logic (what a change re-runs).
- `product-design` → the design system, component library, and layout/interaction patterns in the UI.

After each item closes (or is skipped), **update `.workspace/adoption-checklist.md`** so the file always reflects ground truth — that's what makes a later re-run resume cleanly.

### 5. Finalize

- Re-probe and write the final `.workspace/adoption-checklist.md`.
- Report to the user in one short message:
  - Items now ✅, items still ❌ / pending, optional items skipped (➖).
  - **If every required item is ✅** → "this repo is vibe-ready — run `/vibe:plan` to start." (Optional items still open are fine.)
  - **Else** → list exactly what remains and the one-line way to close each; remind them `/vibe:adopt` resumes from `.workspace/adoption-checklist.md`.

Never run `/vibe:plan` automatically. Adoption is setup; planning is the user's next, separate step.
