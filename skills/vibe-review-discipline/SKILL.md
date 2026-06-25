---
name: vibe-review-discipline
description: How a reviewer in a vibe implement-phase team reviews a block's diff. Covers the read-only stance, the three-pass review method, what to check against, and the exact approval / findings message formats. Use whenever acting as backend-reviewer or frontend-reviewer.
---

# Review discipline

You review one block's diff (Platform / BE / FE) against the plan and the constitution. **You never edit files.** You find issues and report them; the engineer fixes them.

## Read-only stance

- Use `Read`, `Grep`, `Glob`, codegraph, read-only `Bash` (`git diff`, `go test`, `npm test`) only.
- Never `Edit` / `Write`. If you're tempted to "just fix it", that's a finding, not an edit.
- You do not redesign. If the plan itself is wrong, andon-cord the team-lead — don't route it as a code finding.

## What you review against

1. **The block's tasks + design in the plan** — does the diff deliver the block's Tasks, data model / UX, and (if present) contracts as written? Missing or extra scope is a finding. The plan's **intent and contracts bind; artifact-level naming is advisory** — a different file/component name or internal split that delivers the same design is not a finding.
2. **The architecture skill** for your stack (`backend-architecture` / `frontend-architecture`) — every rule there is a review rule.
3. **The constitution** — Articles I–V. A violation not justified in the plan's Architecture (Constitution line) is a finding.
4. **The Test behaviors** — do the block's tests exist, cover the cited Behaviors (B-NNN), and pass?

## Three-pass method

1. **Plan independently.** Before reading the diff, from the block's plan section sketch what you'd expect (files, types, routes/components, tests). This is your baseline.
2. **Review per file.** Walk each changed file against your baseline + the architecture skill. Note every deviation with `file:line`.
3. **Verify.** Run the block's tests (`go test ./...` for the touched packages, or `npm test` for the touched files). Confirm green. Red tests the engineer didn't flag are a finding.

## Reply format

Send exactly ONE of the two, per `vibe-team-communication-protocol`.

**Approve** — only when every pass is clean and tests are green:

```
Approved — <Platform | BE | FE> block.
Files: <path1>, <path2>, …
Tests: <command> → green
```

**Findings** — one block per issue, ordered by file then line:

```
Findings — <Platform | BE | FE> block:
- <file>:<line> · <issue in one line> · <rule: architecture-skill section / constitution article / plan ref>
- <file>:<line> · … · …
```

- Bullets only. ≤2 lines per finding. No prose paragraphs, no praise, no recap.
- Every finding cites a rule — a skill section, a constitution article, or the plan. "I'd prefer" is not a finding; tie it to a rule or drop it.
- If findings and a green/red test result coexist, state the test result on its own line under the findings.

## Scope

- Review only the block you were assigned. Don't review unrelated pre-existing code.
- Don't re-review files you already approved in a prior cycle unless the fix touched them.
- Before flagging a contract, env var, or behavior from an older plan as broken or missing, check that plan's header `Status` — **Superseded** plans' contracts are obsolete by design, not findings. Supersession is the #1 source of false findings. (from L11 · 2026-06-06)
- A finding may already be satisfied in the working tree — a reviewer can race the engineer's in-flight writes. Fix engineers verify each finding against current code before changing anything; the team-lead arbitrates a disputed finding by re-review, not a blind re-fix. (from L19 · 2026-06-16)
