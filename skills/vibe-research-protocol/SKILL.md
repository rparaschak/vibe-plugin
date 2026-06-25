---
name: vibe-research-protocol
description: How any vibe agent gets the code facts it needs without burning its own context — the escalation ladder (research.md → codegraph → Explore subagent → codebase-researcher) and the hard rule against wide file sweeps. Applies to every agent, in every phase.
---

# Research protocol

Your context is for your real job — designing, building, testing, reviewing. Filling it with wide file reads is how that job degrades. So you never explore the codebase by sweeping it: you climb a ladder, cheapest rung first, and stop at the rung that answers you.

## The ladder

1. **`research.md`** — if your brief names one, read it first. It's a pre-built, cited map of the current state, written so you don't pay the exploration cost again. Don't re-derive what it already covers; verify a load-bearing fact via `codegraph` before relying on it.
2. **`codegraph`** — your default for targeted lookups: a symbol, its callers/callees, a trace, an impact set, one node's source. "Where is X / what calls Y / what would Z break" ends here.
3. **Built-in `Explore` subagent** (or a cheaper Haiku one) — when a lookup outgrows codegraph: a module-scale survey, or breadth that would bloat your own context. You have the `Agent` tool — **spawn it yourself**. It's a compression boundary: work from its returned summary, cite `file:line`, never paste its raw output into your context.
4. **`codebase-researcher` agent** — the heavy rung. Reach for it only when `research.md` doesn't contain what you need and the gap is bigger than a single `Explore` survey. Spawn it yourself; it returns a synthesized, cited summary (and appends to `research.md` when one exists).

Stop the moment a rung answers your question — most end at rung 1 or 2.

## The hard rule

**Don't *discover* the codebase by sweeping it** — no wide `Grep` / `Glob` / `Read` passes just to find where things live or how they fit together. That is what the ladder is for.

This bans *exploration*, not your actual work. You always **Read the specific files you're about to edit, the code under test, or the diff you're reviewing** — directly and in full (the `Edit` tool requires the Read; a reviewer reads the whole diff; a test author reads the implementation). The line is **discovery vs. doing**: climb the ladder to *find* the right files, then Read them to *do the job*.

## No on-call researcher

There is no standing researcher to message, and no "ask the team-lead to spawn one." Whoever needs research spawns it: the team-lead at the start of `/vibe:plan` (one or more `codebase-researcher`s for `research.md`), and any agent mid-task via rungs 3–4 above. Reserve the andon-cord / team-lead for design and structural problems — never for "I need to read more code."

## If you are the codebase-researcher

You **are** rung 4 — don't recurse into another researcher. Climb rungs 1–3: `codegraph` first, fan out parallel `Explore` subagents for breadth, then synthesize. `research.md` is your deliverable.
