---
description: Vibe adoption — make a repo vibe-ready, run as an orchestration command. Reads the plugin's project-setup contract (CHECKLIST.md), confirms the repo's domains, then dispatches a read-only scout subagent per contract item to probe what exists, find reusable guidelines, map the repo's conventions, and draft a proposal — keeping your own context clean. Records status in .workspace/adoption-checklist.md and walks the gaps with the user (reuse an existing guideline as a pointer or a compacted skill, you author it yourself, or accept the scout's drafted proposal). Writes skill/constitution files only on approval; never touches app code. Resumable; re-run any time.
---

## User Input

```text
$ARGUMENTS
```

Optional. Empty → a full sweep of every contract item. A single item name (e.g. `environment`, `backend-architecture`) → work only that one. You **MUST** consider the input before proceeding.

## Role

You drive **project adoption** as an **orchestration command**: you bind a consuming repo to the vibe harness by supplying the 📁 project layer the agents resolve at runtime. You **do not explore the repo yourself** — for each contract item you dispatch a read-only **scout subagent** that probes what exists, finds reusable material, maps the repo's conventions (calling `Explore` when the area is broad), and hands back a compact report plus a drafted proposal. You stay the orchestrator: collect the scouts' reports, talk to the user, and write files on approval. Pushing exploration into the scouts is the whole point — your context stays clean no matter how large the repo is.

**Mutation surface (narrow).** You write exactly: `.workspace/adoption-checklist.md` (the status file), and — only on the user's explicit approval — project skill files at `.claude/skills/<name>/SKILL.md` and `.workspace/constitution.md`. You **never** touch application code (`Edit`/`Write`/`NotebookEdit` on source is forbidden), you never install tooling, and you never explore the repo's source or docs directly — that's the scouts' job. You may use `Glob` for cheap existence checks and read small bounded config (`.mcp.json`, `.claude/settings*.json`).

**Interactive, not autonomous.** Every gap is the user's call: they pick how to close it via `AskUserQuestion`. You propose (via a scout's draft); you don't impose. You write a skill file only after the user approves the draft.

## The contract

`CHECKLIST.md` shipped **with the plugin** is the canonical list of what a repo must supply — the single source of truth. Resolve and read it (don't hardcode the list — it drifts):

- `echo $CLAUDE_PLUGIN_ROOT/CHECKLIST.md` (Bash), then read that file.
- Parse its `- [ ]` items and each item's `Starter:` seed line. Every item is one of:
  - a **per-domain skill** (`<domain>-architecture`, `<domain>-testing`, `<domain>-review`),
  - a **repo-level skill** (`environment`, `product-design`),
  - a **document** (`.workspace/constitution.md`),
  - **external tooling** (an MCP server).
- The `*-template.md` files in `workspace-starter/` are **not** items — the harness reads them straight from the plugin at runtime. Skip them.

Resolve the starter seeds the same way: `$CLAUDE_PLUGIN_ROOT/workspace-starter/<seed>.md`. **Read the seed content yourself** and pass it into each scout's brief — scouts can't expand `$CLAUDE_PLUGIN_ROOT`, and the seed is the shape they draft into.

## Outline

### 1. Load the contract & detect domains

- Resolve + read `$CLAUDE_PLUGIN_ROOT/CHECKLIST.md`; extract the item list and each item's starter seed path. Read each referenced seed so you can hand its content to the scouts.
- **Detect the repo's domains/stacks with `Glob` only** (check for marker files/dirs — don't read their contents): a backend manifest (`go.mod` / `pom.xml` / `Cargo.toml` / `requirements.txt` / `*.csproj` …) or an `api/`-style dir → a backend domain; a `package.json` / `tsconfig.json` or a web app dir → a frontend domain; other markers (mobile, etc.) → that domain. A repo with no UI has no frontend domain and likely doesn't need `product-design`.
- **Confirm with the user** via `AskUserQuestion`: the domains you detected, editable (add/remove). The confirmed set drives everything downstream.
- **Expand** every `<domain>-*` item per confirmed domain (e.g. `backend-architecture`, `frontend-architecture`, `backend-testing`, …). Repo-level items (`environment`, `product-design`, `constitution.md`, MCPs) stay singular.

### 2. Scout every item — one subagent per point (parallel)

For each expanded skill/document item (or just the one named in `$ARGUMENTS`), dispatch a **read-only scout subagent**. Dispatch them **in parallel** — one message, multiple `Agent` calls — they're independent and this is where all the repo-reading happens, off your context. Each brief is self-contained (scouts can't see your context); give it:

- the item name, its kind (per-domain skill / repo-level skill / document), and the domain;
- the target path it would land at (`.claude/skills/<name>/SKILL.md` or `.workspace/constitution.md`);
- the **full seed content** you read in step 1 — the shape to draft into;
- the "what to map" line for this kind (table below);
- the **return contract** (below).

Each scout, working **read-only** and **writing nothing**:

1. **Probes presence** — does the target exist and is it real (non-empty, not the unedited sample)? If a real skill/doc already exists → it returns `status: present` and stops; no further work.
2. **Finds candidate sources** — scans for existing material this item could be built from (many repos encode conventions under other names): skills under a different name in `.claude/skills/`; loose guideline docs (`CONTRIBUTING.md`, `ARCHITECTURE.md`, `STYLE*.md`, `TESTING.md`, `CLAUDE.md`/`AGENTS.md`, anything under `docs/` / `.github/`); for `environment`, the `Makefile` / `package.json` scripts / CI config / compose files; for `product-design`, a design-system or storybook doc.
3. **Maps conventions** — for a convention skill with no ready-made source, it explores the repo's real conventions, **every claim cited `file:line`**. It reads directly (codegraph / `Read` / `Grep`) or, when the area is broad, **dispatches `Explore` (or `codebase-researcher`) subagents as compression boundaries** — keeping deep reads out of even its own context.
4. **Drafts a proposal** — a ready `SKILL.md` (proper frontmatter `name`/`description` + body) in the seed's shape, and a recommended close-method:
   - **reuse-pointer** — thin `SKILL.md` whose body points to the existing file(s) as the source of truth, with a one-line note on what each linked file covers. Best when a candidate doc is well-maintained and the team already updates it there (one place, no drift).
   - **reuse-compact** — distill/copy the candidate content into the seed's shape, self-contained. Best when the source is sprawling or scattered.
   - **explore-draft** — drafted from the cited conventions when there's no good candidate.
   - For `constitution.md`: a starting draft from the seed, flagged in `notes` that **the rules are the user's to own — a seed, not a finished document.**
5. **Returns a compact report** — and nothing else (the file is never written; the draft comes back as text):

   ```
   item: <name>
   status: present | missing | optional-absent
   candidates: [<path> — one-line note, …]      # existing material that could be reused; [] if none
   conventions: <≤8 cited bullets, file:line>     # only if it explored; else "—"
   recommended: reuse-pointer | reuse-compact | explore-draft | n/a
   draft: |
     <the proposed SKILL.md text — frontmatter + body — or "—" when status: present>
   notes: <anything the user should decide>
   ```

   The report is all your context holds for that item — the exploration cost stayed in the scout. Don't ask the scout to dump raw file contents.

**MCP / tooling items have no scout** — nothing to explore or draft. Check `.mcp.json` / `.claude/settings*.json` yourself (small, bounded config) for the server; if you can't tell, mark **verify manually**.

What each scout maps, by kind (put the matching line in its brief):

- `<domain>-architecture` → module/layer layout, persistence, platform subsystems, error handling, the dominant code patterns.
- `<domain>-testing` → test layers present, file layout, fixtures/factories, the mocking boundary, how each layer runs.
- `<domain>-review` → a checklist derived from the architecture/testing conventions + recurring pitfalls in the codebase.
- `environment` → the build/lint/test/run commands and ports from `Makefile` / `package.json` scripts / CI config / compose files; the verification decision logic (what a change re-runs).
- `product-design` → the design system, component library, and layout/interaction patterns in the UI.

### 3. Write the adoption checklist

From the collected scout reports (not your own probing), write `.workspace/adoption-checklist.md` (create `.workspace/` if absent). It is the **durable, resumable state** — re-running `/vibe:adopt` refreshes it. Shape:

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

Classification (from each scout's `status`): **✅ present** · **❌ missing** · **➖ optional-absent** (the optional items — `<domain>-review`, and `product-design` when the repo has no UI — absent is allowed, not a failure).

### 4. Close the list — point by point

Walk the items needing work top to bottom (or just the one named in `$ARGUMENTS`). Skip ✅ items. For each you already hold the scout's findings **and a drafted proposal** — so **show, don't re-ask from scratch.** Present the choices via `AskUserQuestion`:

- **Accept the proposed skill** *(recommend this — it's the scout's drafted close-method, e.g. "reuse `docs/architecture.md` as a pointer" or "drafted from the codebase")* → you already have the draft text; on confirm, `Write` it to `.claude/skills/<name>/SKILL.md` (or `.workspace/constitution.md`). Mark ✅.
- **Use a different method** — change how it's built:
  - **Shallow pointer ↔ compacted skill** — both are reshapings of material you already hold; **redraft it yourself** from the scout's report (no re-dispatch) and show it.
  - **Explore from scratch** (ignore the candidates) — **re-dispatch the item's scout** with "explore & draft, don't reuse," then show its new draft.
  - Write on approval; mark ✅.
- **I'll author it myself** — give the user the starter seed path (and any candidate source paths from the scout); leave the item pending. They re-run `/vibe:adopt` to verify it landed.
- **Skip for now** — leave it ❌ (or ➖ for optional); record it and move on.

Iterate on a draft by **editing the text you already hold** (a `SKILL.md` is small — don't re-dispatch a scout for wording). Re-dispatch a scout only when the change needs fresh exploration. For **`constitution.md`**, present the scout's starting draft but make clear the **rules are the user's to own** — a seed, not a finished document. For **MCP / tooling** items you cannot install anything — give the exact install + connect steps and mark **verify manually**.

After each item closes (or is skipped), **update `.workspace/adoption-checklist.md`** so the file always reflects ground truth — that's what makes a later re-run resume cleanly.

### 5. Finalize

- Re-probe (re-read the status file; re-scout only items whose state may have changed) and write the final `.workspace/adoption-checklist.md`.
- Report to the user in one short message:
  - Items now ✅, items still ❌ / pending, optional items skipped (➖).
  - **If every required item is ✅** → "this repo is vibe-ready — run `/vibe:plan` to start." (Optional items still open are fine.)
  - **Else** → list exactly what remains and the one-line way to close each; remind them `/vibe:adopt` resumes from `.workspace/adoption-checklist.md`.

Never run `/vibe:plan` automatically. Adoption is setup; planning is the user's next, separate step.
