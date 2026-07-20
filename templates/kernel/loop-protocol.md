---
name: vibe-loop-protocol
description: How a loop orchestrator runs disposable worker sessions via cmux — one session per stage of one chunk, briefs in, status-log signals out, verify-then-kill, O(1) context per rotation, and the loop board. The cross-session level above vibe-team-protocol.
---
<!-- vibe-template: templates/kernel/loop-protocol.md v1 | generated 2026-07-20 | edits below this marker are yours -->

# Loop protocol

Two orchestration levels, one vocabulary. A **flow** runs *inside* a session: one team-lead spawning specialized agents per `vibe-team-protocol`. A **loop** runs *across* sessions: one orchestrator session that only manages other CLI sessions via cmux — it never reads app code, never runs tests, never reads a worker transcript. Each worker session is disposable and single-purpose: it runs exactly one stage of one chunk (one flow command), talks to the user directly, signals through the status log, and is killed after verification.

## Status log (the one signal channel)

`.workspace/status.log`, append-only, shared by both levels. One line per signal:

`<utc hh:mm> | <slug> | <signal> | <one-line detail>`

`signal ∈ {done, blocked, needs-user, session-exited}` — closed enum, no other values. Flow commands append `needs-user` immediately before any `AskUserQuestion` and `done`/`blocked` at Finalize (harmless on a direct run — a free audit trail). The spawn epilogue appends `session-exited` when the worker's CLI process dies for any reason. The log is a **doorbell, not a source of truth**: a `done` line wakes the orchestrator; only verification against artifacts advances the ledger.

## Worker lifecycle (one rotation)

1. **Brief** — write `<loop-dir>/briefs/<chunk>-<stage>.md` from the loop command's brief template: chunk, stage input paths, pre-decided answers, questions that MUST be surfaced to the user, learnings fed forward from prior rotations. Standing decrees live once in the loop ledger's `## Standing decrees`; the brief cites that path, never restates it.
2. **Spawn** — pointer prompt, never inline `$(cat …)` injection:
   `cmux new-workspace --cwd <tree> --command '<cli> "<flow-invoke> brief=<brief-path>" ; echo "$(date -u +%H:%M) | <chunk> | session-exited | rc=$?" >> .workspace/status.log'`
   then `cmux rename-workspace --workspace <ref> "<STAGE>: <chunk>"` — so the user can find the session that will ask them questions.
3. **Wait** — capture `since-line` (`wc -l` of the log) *before* spawning, then foreground-block on `loop-wait.sh <chunk> <timeout> <since-line>`. This is the sanctioned form of waiting — `vibe-team-protocol`'s turn discipline still holds: block in the foreground, never end a turn promising to report later. On timeout: `read-screen --lines 30`, judge liveness, re-wait or andon — never kill blind.
4. **Verify** — the worker's claim is input, not truth. Run the stage's compiled verify checks (artifact Status header, `git log --oneline -5`, push reached remote) — bounded reads only.
5. **Kill** — `read-screen --lines 30` first (never close a workspace blind — it may sit on a question or still be flushing), then `close-workspace`.
6. **Record** — flip the chunk's ledger leaf on verify evidence per `vibe-task-ledger`, note learnings for the next brief, re-render the loop board.

## Signals the orchestrator reacts to

- `needs-user` → `cmux notify --title "<chunk> needs you" --body "<detail>"`. The decision is answered **in the worker session that asked** — the loop never proxies a gate and never answers for the user.
- `session-exited` before `done` → post-mortem via `capture-pane --scrollback`, mark the leaf `blocked` with the rc and last lines, andon.
- `blocked` → leaf `blocked` per `vibe-task-ledger`; andon.

## Context discipline (O(1) per rotation — hard rules)

The orchestrator's context must not grow with the run. Per rotation it reads ONLY: the signal line `loop-wait.sh` printed (plus at most a 5-line log tail) · the active chunk's ledger leaf and Handoff (never the whole ledger) · the exact lines its verify checks name (≤20 lines per check) · one pre-kill `read-screen --lines 30`. It never reads worker transcripts, app code, diffs beyond a `--oneline` log, or its own briefs back. Compaction is the design assumption, not a failure: cold clock-in = ledger Handoff → `cmux list-workspaces` → reconcile → board — one rotation's cost, never a re-derivation of the run.

## Loop board (rendered every rotation)

The user's overview lives in two places, both renders of the ledger — never a second source of truth:

- **In-chat board** — after every rotation print one compact table, `chunk · stage · state · evidence / next`, followed by two lines: `Now: <live worker + workspace ref>` and `Next: <next chunk×stage>`.
- **cmux sidebar** — `set-progress <passing/total> --label "<chunk>:<stage>"` on every spawn and kill; `clear-progress` at loop exit.

## Serial by default

WIP=1 lifts one level: **one live worker session per loop**, and the orchestrator goes repo-read-only while any worker is live (one tree, one env, one test run). Parallel or pipelined stages exist only when the loop command was compiled that way, with worktree-isolated stages — never improvised at runtime.
