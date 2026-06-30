# Harness Teardown — How `revfactory/harness` Builds Harnesses

> Reverse-engineering brief for building our own harness builder.
> Source: https://github.com/revfactory/harness (v1.2.x), cloned to `_ref/harness`.
> Analyzed by 5 parallel agents across: core SKILL.md + manifest, templates + 6 patterns,
> authoring guides, conceptual framing, and real runtime artifacts in `_workspace/`.

---

## 0. TL;DR

**Harness is a Claude Code *plugin* that is a "meta-skill": a skill whose job is to generate
*other* skills and agents.** You say *"build a harness for a fintech risk team"* and it writes a
set of `.claude/agents/*.md` files + `.claude/skills/*/SKILL.md` files (including an orchestrator
skill) that together form a purpose-built agent team for your domain.

It is **100% markdown + JSON**. There is no executable code, no compiler, no runtime engine. The
entire "product" is:
- one big instruction file (`skills/harness/SKILL.md`, ~30K) that tells Claude *how to design a team*,
- six reference docs it lazy-loads (patterns, templates, authoring/testing/QA guides),
- a 2-file plugin manifest so Claude Code can discover and install it.

The leverage is entirely in **prompt engineering + conventions**, not software.

---

## 1. Core mental model

- **Harness** (Anthropic's term) = the structured control layer wrapped around a long-running agent.
- This project is a **factory that generates harnesses** — it calls itself a "Team-Architecture Factory".
- Self-assigned taxonomy ("L3 Meta-Factory"):
  - **L1** — individual prompts / single-agent skills
  - **L2** — cross-harness standardization (shared rules/hooks across harnesses)
  - **L3 — Meta-Factory** — *generates other harnesses*. Two sub-types they name:
    - **Team-Architecture Factory** = Harness (domain sentence → agent team + skills)
    - **Runtime-Configuration Factory** = "Archon" (deterministic runtime configs)
- Claimed result (their own benchmark, take with salt): structured team pre-config gave +60% avg
  quality (49.5 → 79.3) on 15 SWE tasks, 15/15 win rate, −32% output variance; effect grows with
  task complexity.

**The single most important insight for building your own:** the "builder" is just a very carefully
written SKILL.md that encodes (a) a fixed phase workflow, (b) a small library of architecture
patterns, (c) a set of file/naming conventions, and (d) copy-paste templates. Everything else is
discipline enforced by prose.

---

## 2. Repo anatomy

```
.claude-plugin/
  plugin.json          # plugin manifest (name, version, description, keywords)
  marketplace.json     # marketplace registry entry (points source: "./")
skills/harness/
  SKILL.md             # THE ENGINE — 8-phase team-design algorithm (~30K, the heart)
  references/          # lazy-loaded detail (progressive disclosure)
    agent-design-patterns.md    # 6 patterns + agent anatomy + type selection
    orchestrator-template.md     # 3 orchestrator templates (Team / Sub-agent / Hybrid)
    team-examples.md             # 5 worked example teams (verbatim agent files)
    skill-writing-guide.md       # how to author a skill (description, body, prog. disclosure)
    skill-testing-guide.md       # with-skill vs baseline eval methodology
    qa-agent-guide.md            # how to design a QA/verification agent (from real bugs)
docs/
  quickstart.md               # 5-min install + usage
  experimental-dependency.md  # the experimental flag it depends on + contingency plans
README.md / README_KO.md / README_JA.md   # trilingual framing
CHANGELOG.md / CONTRIBUTING.md
_workspace/                   # REAL ARTIFACTS from a past run (best runtime evidence)
  01_auditor_repo_audit.md / 02_content_*.md / 03_scout_*.md / 04_strategist_*.md
  release/audit-2026-04-18.md / release/post-m0-audit-2026-04-18.md
```

Note: SKILL.md and the references are **written in Korean**. Author is Korean (kakaocorp). The
deliverable artifacts target English audiences; the orchestration layer is Korean.

---

## 3. Plugin packaging (minimal scaffolding to ship a Claude Code plugin)

Skill discovery is **path-based, not declaration-based**. Claude Code reads `plugin.json` to find the
plugin root, then auto-scans `skills/*/SKILL.md`. There is no `skills:` array anywhere.

**`plugin.json` (minimum: name, version; rest is discovery metadata):**
```json
{
  "name": "harness",
  "description": "...",
  "version": "1.2.0",
  "author": { "name": "...", "url": "..." },
  "homepage": "...", "repository": "...", "license": "Apache-2.0",
  "keywords": ["harness", "team-architecture-factory", ...]
}
```

**`marketplace.json` (install registry; `source: "./"` = plugin root):**
```json
{
  "name": "harness-marketplace",
  "owner": { "name": "...", "email": "...", "url": "..." },
  "plugins": [ { "name": "harness", "source": "./", "description": "...", "version": "1.2.0" } ]
}
```

**A skill = a directory with `SKILL.md` whose YAML frontmatter has only `name` + `description`.**
The `description` is the *sole* trigger mechanism — no routing table exists.

Install flow: `claude plugin marketplace add <owner/repo>` → `claude plugin install harness@harness`
→ `export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. (See §10 on the flag.)

---

## 4. The engine: SKILL.md's 8-phase algorithm

The whole builder is a state machine Claude executes when triggered. Phases:

| Phase | Name | What happens |
|---|---|---|
| **0** | Current-state audit | Read `.claude/agents/`, `.claude/skills/`, `CLAUDE.md`. Branch: **new build** / **extend** / **maintenance**. Detect drift between files and CLAUDE.md records. Never blindly overwrite. |
| **1** | Domain analysis | Parse domain sentence → identify core task types (generate/validate/edit/analyze) → explore codebase (stack, data model) → gauge user skill level for tone. *No classifier — pure model reasoning.* |
| **2** | Team architecture design | 2-1 pick **execution mode** (Agent Team default vs Sub-agent vs Hybrid). 2-2 pick one of **6 patterns**. 2-3 decide agent split (4 axes: expertise / parallelism / context burden / reusability). |
| **3** | Agent generation | 3-0 reuse check vs existing agents. Write `.claude/agents/{name}.md` with mandatory sections. |
| **4** | Skill generation | 4-0 reuse check. Write `.claude/skills/{name}/SKILL.md`. "Pushy" descriptions, ≤500-line body, progressive disclosure into `references/`. |
| **5** | Integration & orchestration | Write `.claude/skills/{domain}-orchestrator/SKILL.md`. Wire data passing, error handling. Register a **pointer** (trigger rule + changelog only) into `CLAUDE.md`. |
| **6** | Validation & testing | Structural checks, trigger validation (8–10 should-trigger + 8–10 near-miss should-NOT), with-skill vs baseline comparison, dry run. |
| **7** | Evolution | Post-run feedback → map feedback type to a modification target → log to changelog → auto-trigger next cycle. Maintenance loop (7-5). |

**Extension matrix (Phase 0 routing for existing harnesses):**

| Change | Ph1 | Ph2 | Ph3 | Ph4 | Ph5 | Ph6 |
|---|---|---|---|---|---|---|
| Add agent | skip | routing only | required (+3-0) | only if new skill | modify orchestrator | required |
| Add/modify skill | skip | skip | skip | required (+4-0) | if wiring changes | required |
| Architecture change | skip | required | affected agents | affected skills | required | required |

---

## 5. The hard rules / invariants (the "core")

These are the load-bearing MUST/MUST-NOT rules. If you build your own builder, this list IS the spec.

1. **Agents are always files.** Never put a role definition inline in an `Agent` prompt — write
   `.claude/agents/{name}.md`. (Enables cross-session reuse + clear team comms protocol.) This holds
   even for built-in types (`general-purpose`, `Explore`, `Plan`).
2. **Every agent uses `model: "opus"`** — set explicitly in every `TeamCreate` member and every
   `Agent` call.
3. **Never generate `.claude/commands/`.** Harness creates agents + skills only.
4. **SKILL.md body ≤ 500 lines.** Overflow → `references/`. SKILL.md is an *index*, references are detail.
5. **Descriptions must be "pushy".** Enumerate explicit trigger phrases + boundary (when-NOT) cases.
   Claude under-triggers by default; the description must over-compensate.
6. **Orchestrator descriptions must include follow-up keywords** (re-run / update / fix / improve /
   "just the X part again"). Without them the harness is dead code after the first run.
7. **Agent Team is the default** whenever ≥2 agents; Sub-agent is the opt-out, not the default.
8. **Phase 0 before everything.** Audit existing state; never blindly overwrite.
9. **`_workspace/` is never deleted.** It's the shared state + audit trail. New run archives old to
   `_workspace_{YYYYMMDD_HHMMSS}/`.
10. **CLAUDE.md gets a pointer only** — trigger rule + changelog table. No agent/skill lists, no dir
    dumps (they go stale). Single source of truth = the actual files.
11. **Max hierarchy depth = 2** (teams can't nest). Max team size 5–7 (2–3 for small tasks).
12. **Retry budget = 1** per failed agent; on 2nd failure continue and note the missing artifact.
13. **Reuse before create** (agents and skills): full overlap → reuse; partial + generalizable →
    extend; intentional domain specialization or no overlap → create new.

**Naming conventions (also invariants):**
- Agent file: `.claude/agents/{kebab-name}.md` (matches `name:` frontmatter + `subagent_type` string)
- Skill: `.claude/skills/{name}/SKILL.md`
- Orchestrator: `.claude/skills/{domain}-orchestrator/SKILL.md`
- Team name: `{domain}-team`
- Artifact: `_workspace/{phase#}_{agent}_{artifact}.md` (e.g. `01_official_research.md`)

---

## 6. The six architecture patterns

| Pattern | Shape | When | Team-mode fit |
|---|---|---|---|
| **Pipeline** | A→B→C→D sequential | Strong stage dependency (novel: world→char→plot→draft→edit) | Limited (sequential blocks parallelism) |
| **Fan-out/Fan-in** | distributor → N parallel experts → integrator | Same input, many independent perspectives (research, code review) | **Best fit — must use team**; live cross-agent finding-sharing |
| **Expert Pool** | router → pick one specialist | Input type varies, route by type | Sub-agents preferred (no standing team) |
| **Producer-Reviewer** | generate → review → (fail) loop back | Quality-critical w/ objective criteria (webtoon panels) | Team useful (SendMessage feedback loop). **Cap retries 2–3.** |
| **Supervisor** | supervisor watches state → dynamically assigns workers | Variable workload, runtime allocation (mass migration) | Team — shared task list, workers self-claim |
| **Hierarchical Delegation** | top → leads → workers | Naturally hierarchical decomposition (full-stack) | **Max 2 levels**; teams can't nest — flatten or use sub-agents at L2 |

**Compound patterns** are explicitly supported: Fan-out+Producer-Reviewer (parallel gen, each
reviewed), Pipeline+Fan-out (sequential phases, parallel middle), Supervisor+Expert Pool (dynamic
routing to specialists).

**Pattern selection is model judgment** guided by the "When" column — there is no algorithm.

**Execution mode decision tree:**
```
≥2 agents?
├── Yes → inter-agent communication needed?
│         ├── Yes → Agent Team (DEFAULT)
│         └── No  → Sub-agent viable
└── No  → Sub-agent
```

---

## 7. The templates (the reusable gold)

These are the copy-paste skeletons the builder emits. Originals are Korean; English skeletons below.

### 7.1 Agent definition skeleton
```markdown
---
name: agent-name
description: "1-2 sentence role. List trigger keywords."
---

# Agent Name — one-line role

You are a [role] specialist in [domain].

## Core Role
1. ...
## Working Principles
- ...
## Input/Output Protocol
- Input:  [from where, what]
- Output: [to where, what]   (a file path under _workspace/)
- Format: [file format, structure]
## Team Communication Protocol   (team mode only)
- Receives: [from whom, what messages]
- Sends:    [to whom, what messages]
- Tasks:    [what it claims from the shared task list]
## Error Handling
- [on failure] / [on timeout]
## Collaboration
- [relationship to other agents]
```

### 7.2 Orchestrator skill — Template A (Agent Team, the default)
Key structural elements (verbatim shape, translated):
```markdown
---
name: {domain}-orchestrator
description: "Orchestrates the {domain} agent team. {initial trigger keywords}.
  Follow-up: also use this skill for modifying results, partial re-runs, updates,
  improvements, 'run again', 'improve previous result' requests."
---

# {Domain} Orchestrator
## Execution Mode: Agent Team
## Agent Composition         (table: teammate | type | role | skill | output)

## Workflow
### Phase 0: Context check (follow-up support)
  1. Does `_workspace/` exist?
  2. none → initial run (Phase 1) | exists+partial-edit → partial re-run (re-call only that agent)
     | exists+new-input → archive to `_workspace_{YYYYMMDD_HHMMSS}/`, then Phase 1
  3. On partial re-run: pass prior artifact paths into the agent prompt
### Phase 1: Prep — analyze input, create `_workspace/`, save input to `_workspace/00_input/`
### Phase 2: Team formation
  TeamCreate(team_name: "{domain}-team", members: [{ name, agent_type, model: "opus", prompt }, ...])
  TaskCreate(tasks: [{ title, description, assignee }, { ..., depends_on: ["..."] }])
  # ~5-6 tasks per member; declare deps with depends_on
### Phase 3: Main work — members self-coordinate (SendMessage), write _workspace/{phase}_{member}_{artifact}.md
  # leader monitors idle notifications, can reassign via SendMessage/TaskUpdate
### Phase 4: Integration — TaskGet wait-all → Read all artifacts → integrate → write final output
### Phase 5: Cleanup — SendMessage shutdown → TeamDelete → preserve `_workspace/` → report

## Data Flow         (ASCII diagram)
## Error Handling    (standard 5-row table)
## Test Scenarios    (1 happy path + 1 error path — MANDATORY)
```

### 7.3 Orchestrator — Template B (Sub-agent)
Same Phase 0/1, but Phase 2 = single message firing N `Agent` calls in parallel
(`run_in_background: true`, `model: "opus"`), Phase 3 = collect returns + Read file outputs +
integrate, Phase 4 = preserve + report. Error: 1 agent fail → 1 retry → note missing; majority fail
→ ask user.

### 7.4 Orchestrator — Template C (Hybrid)
Per-phase mode table, e.g.: Phase 2 parallel collect = **sub-agent**; Phase 3 consensus integration
= **agent team** (editor + fact-checker + synthesizer discuss conflicts); Phase 4 independent verify
= **sub-agent** (one QA agent). Transition rules: Team→Sub must `TeamDelete` first; Sub→Team pass
file outputs as `Read` paths; only one active team per session.

### 7.5 CLAUDE.md pointer block
```markdown
## Harness: {domain}
**Goal:** {one line}
**Trigger:** For {domain} work, use the `{domain}-orchestrator` skill. Simple Qs answered directly.
**Changelog:**
| Date | Change | Target | Reason |
| {YYYY-MM-DD} | Initial build | all | - |
```

### 7.6 Standard error-handling table (orchestrators)
```markdown
| Situation | Strategy |
| 1 member fails/stops | Leader detects → SendMessage status check → restart or spawn replacement |
| Majority fail | Notify user, ask whether to continue |
| Timeout | Use partial results collected so far, terminate incomplete members |
| Data conflict between members | Annotate source, keep both, never delete |
| Task status stalled | Leader checks via TaskGet, manual TaskUpdate |
```

---

## 8. The authoring sub-guides (meta-knowledge to replicate)

### Skill writing
- **Description is the only trigger.** Enumerate operations + trigger situations + boundary
  (when-NOT). Be "pushy". Bad: `"a skill that processes PDFs"`. Good: `"All PDF ops: read,
  extract text/tables, merge, split, OCR... If a .pdf is mentioned or a PDF output requested, MUST
  use this skill."`
- **Why-first, not rules-first.** Explain the reason (`pdfplumber preserves table structure;
  PyPDF2 can't`) rather than `ALWAYS/NEVER`. LLMs handle edge cases better with rationale.
- **Generalize, don't overfit.** Fix at principle level, not for the one failing example.
- **Context economy.** Every sentence must earn its tokens. Cut what Claude already knows; replace
  long prose with one concrete example.
- **Progressive disclosure** = 3 tiers: metadata always loaded → SKILL.md on trigger → `references/`
  on demand. Domain-separate references (`finance.md`/`sales.md`), conditional detail, ToC for files >300 lines.
- **Script bundling** when a helper is regenerated in all test runs → put in `scripts/`.

### Skill testing
- **Core loop:** write → run test → evaluate → improve → re-test.
- **With-skill vs baseline:** for each test prompt, spawn two sub-agents (one with the skill, one
  without, identical prompt). Compare. The skill must *discriminate* — assertions that pass in both
  configs measure nothing; remove them.
- **Test prompts must be concrete, natural sentences** (real file paths, column names), mixing
  formal/casual, explicit/implicit, simple/complex.
- **Assertion-based scoring** with an exact schema (field names are invariants: `text`, `passed`,
  `evidence` — not variants):
  ```json
  { "expectations": [{ "text": "...", "passed": true, "evidence": "..." }],
    "summary": { "passed": 2, "failed": 1, "total": 3, "pass_rate": 0.67 } }
  ```
- **Capture `total_tokens` + `duration_ms` immediately** from the sub-agent completion notification —
  unrecoverable later.
- **Trigger validation:** 20 queries = 10 should-trigger + 10 should-NOT (near-misses are the point).
- **Workspace per iteration**, never overwritten: `iteration-N/eval-{descriptive-name}/{with,without}_skill/`.
- Specialized eval roles: **Grader** (scores), **Comparator** (blind A/B), **Analyzer** (variance,
  non-discriminating assertions, time/token trade-offs).

### QA agent design (drawn from 7 real bugs in a "SatangSlide" project)
- **The #1 missed defect class is boundary mismatch** — two components each correct in isolation but
  their contract doesn't match at the seam (API returns `{projects:[]}` but hook expects an array;
  `thumbnailUrl` vs `thumbnail_url`; link points to `/create` but page is at `/dashboard/create`).
- **Why static review misses it:** TS generics/`any` let `npm run build` pass while runtime breaks;
  "does X exist?" ≠ "does X's output match its consumer's expectation?".
- **QA agent principles:** use `general-purpose` (not read-only `Explore`, which can't run checks);
  checklist must prioritize **cross-comparison over existence**; **"read both sides simultaneously"**
  (producer + consumer together); run QA **incrementally** per module, not once at the end.
- Ships a verbatim `qa-inspector.md` template + an integration-coherence checklist (API↔hook,
  routing, state machine, data-flow).

**Cross-cutting philosophy** across all guides: why-first · token economy · generalize-not-overfit ·
exact-schema determinism · dual-side verification · incremental-not-big-bang · discrimination-aware
eval · single-responsibility skills · concreteness as a quality signal · preserve the audit trail.

---

## 9. Runtime evidence (`_workspace/` — what a built harness actually produced)

The repo's own launch was run by a Harness-built team. The artifacts reveal the operational patterns:

- **Team:** `auditor` (repo readiness score + numbered recs R1–R15), `content` (multi-platform launch
  copy), `scout` (tiered outreach map), `strategist` (synthesizes 01+02+03 into a dated launch plan),
  plus `release-engineer` (version sync) used in a later milestone.
- **Pattern observed:** Fan-out (01,02,03 parallel) → Synthesizer (04) → parallel "M0 Quick Wins"
  milestone → re-invoked auditor as a **read-only QA gate** (`release/post-m0-audit-*.md`) giving a
  commit go/no-go verdict.
- **Operational conventions that worked in practice:**
  1. `_workspace/` is the shared store; agents write to known paths and trust the orchestrator to route.
  2. `NN_agent_artifact.md` prefix encodes execution order *and* dependency.
  3. **Stable IDs (R1–R15) are the cross-artifact API** — the strategist cites `Audit R4` without
     re-reading the audit. (Artifact = contract.)
  4. Synthesizer **declares its sources** in the header ("based on: auditor, content, scout outputs").
  5. **Approval gating for irreversible ops** — the release agent wrote out exact `git tag` / `gh
     release create` commands but marked them "DO NOT EXECUTE until orchestrator approves".
  6. **Integration audit as a first-class role** — auditor runs twice (pre-work analyze, post-work
     verify, read-only the 2nd time) with a per-file agent-attribution table that caught one agent
     editing a file another had declared off-limits.
  7. Tables are the primary information carrier; status markers ✅ ❌ ⚠️ PASS/FAIL.
  8. Execution plans include **Plan B columns + a risk matrix** — agents document conditional
     branches, not just the success path.

---

## 10. Platform dependency (what primitives this is built on)

Flag-gated experimental Claude Code primitives the Agent-Team mode needs:
`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` enables **`TeamCreate`**, **`SendMessage`**, **`TaskCreate`**
(+ `TaskUpdate`/`TaskGet`/`TeamDelete`). The plain **`Agent` tool (sub-agents) is GA** and needs no
flag — which is why Sub-agent and Hybrid modes degrade gracefully and Agent-Team patterns silently
collapse to single-agent without the flag.

Enterprise escape hatch: run the builder **design-time only** (scaffold the `.md` files), commit them,
and production never needs the flag — only live `TeamCreate` does.

---

## 11. Blueprint: building YOUR OWN harness builder

What to copy wholesale, what to change, and an MVP path.

### Keep (these are the genuinely reusable ideas)
- **Builder = a single meta-SKILL.md** + lazy-loaded references. No code.
- **Fixed phase workflow** with a Phase 0 state-audit and a Phase N evolution loop.
- **A small pattern library** (6 is a good number) with a "when to use" column, selected by model
  judgment — not a classifier.
- **File-mediated shared state** in a `_workspace/` with `NN_agent_artifact` naming + stable IDs as
  the cross-artifact contract.
- **Orchestrator-as-skill** (not agent) with follow-up keywords in its description.
- **CLAUDE.md = pointer only** (single source of truth).
- **The authoring/testing/QA sub-guides** — especially with-skill-vs-baseline eval, near-miss trigger
  validation, and "read both sides" boundary QA.
- **Approval gating + read-only integration-audit** for any irreversible/external action.

### Change / decide for yourself
- **Language:** write yours in English (theirs is Korean). The description/trigger words must match
  your users' phrasing.
- **Agent-Team dependency:** decide whether to require the experimental flag at all. A
  **sub-agent-first** builder (using only the GA `Agent` tool, or this harness's own Workflow tool)
  is more portable and is probably the right MVP. Add team mode later behind a capability check.
- **`model: "opus"` everywhere** is their rule — you'll likely want per-role model tiers (cheap
  models for mechanical agents) for cost.
- **Pattern set:** keep the 6 or curate your own. Producer-Reviewer + Fan-out + Pipeline cover ~80%.
- **Persistence/evolution depth:** their Phase 7 self-evolution is sophisticated; an MVP can skip it.

### Suggested MVP scope (smallest thing that works)
1. `plugin.json` + `marketplace.json` (or just drop the skill in `~/.claude/skills/`).
2. One `SKILL.md` builder with: Phase 0 audit → Phase 1 domain analysis → Phase 2 pick pattern
   (start with 3: Pipeline, Fan-out, Producer-Reviewer) → Phase 3 write agents → Phase 4 write
   orchestrator skill → Phase 5 register CLAUDE.md pointer.
3. Two reference docs: `agent-skeleton.md` + `orchestrator-template.md` (sub-agent version only).
4. The hard rules from §5 baked in as MUST/MUST-NOT.
5. A `_workspace/` convention + one worked example team to anchor the model.

### Open questions to resolve before building
- Sub-agent-only vs. require experimental Agent-Teams? (recommend sub-agent-first)
- Do you want it as a Claude Code *plugin*, a project-local skill, or a standalone CLI that emits the
  files?
- Per-role model tiers vs. one model?
- How much of the evolution/maintenance machinery (Phase 7) to build vs. defer?
```
