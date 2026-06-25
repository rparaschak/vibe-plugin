---
name: vibe-team-communication-protocol
description: Rules for how agents in a vibe team talk to each other via SendMessage — channel discipline, message shape, status reporting, escalation. Applies in every phase that spawns workers (plan, implement).
---

# Team communication protocol

You are a member of an agent team. Teammates only see what you `SendMessage`; your text output is invisible to them. Standard team discipline applies — **one in-flight message per recipient** (parallel to *different* recipients is fine) and **idle-after-reporting ≠ broken** (an agent that *sent its done/blocked report* then waits to be messaged; don't respawn). The rest of this skill is the vibe-specific shapes.

**Idle without a report is NOT a normal waiting state — it means the turn ended with nothing delivered.** An idle agent runs nothing and sends nothing; it is not "still working in the background." So the team-lead must never sit waiting on an idle teammate that owes a report — it must verify ground truth (read the deliverable, check the process) and proceed. See "Long-running work finishes inside your turn" below for the worker side of this.

## When to message the team-lead

Message the team-lead **only** when:

- You are **done** with the work they assigned, OR
- You are **blocked** and cannot proceed, OR
- You hit **unexpected state** (andon cord — see below).

Do not send progress updates, micro-status, or running commentary. The team-lead does not respond to those by design.

## "Done" message shape

**Send it — don't just emit it.** When you finish, your final-turn text is NOT delivered to the team-lead; it sees only that you went idle. So your **last action** must be a `SendMessage` to the lead (`main`) carrying your done-report. A report you only printed is a report the lead never got.

When you finish assigned work, reply with a terse status — no recap, no reasoning dump:

```
Done.
Wrote: <artifacts or sections>
Result: <your role's evidence — test/build outcome with counts, findings count, or "Open Questions added: N">
Blocked on: <none or one line>
```

Decisions and reasoning belong in the artifact you produced (`plan.md` Decision Log, code comments only when WHY is non-obvious, PR description). Not in chat.

## Long-running work finishes inside your turn

You are turn-based, **not a daemon**. While idle you execute nothing and send nothing — any OS process you launched in the background is unsupervised, may die when your turn ends, and there is no live *you* left to observe it finish and message the result. Therefore:

- **Never background a long command and end your turn promising to report when it finishes.** That message can never be sent — the team-lead would wait on a phantom run forever (this has actually happened with a `dotnet test` category run). Run it in the **foreground**, block until it exits, and only then send your done-report and go idle.
- A multi-minute test or build is still **one turn's work** — wait it out in-turn. "Monitor armed / run in progress" is not a deliverable; the recorded result (pass/fail counts) is.
- If a run genuinely cannot complete in a single turn, **andon-cord the team-lead and say so** — never fake async completion by going idle mid-run.

## Peer-to-peer messages

- **Asking:** one sentence of what you need + scope (paths, sections, IDs) + what you already know, so they don't redo it.
- **Replying:** bullets not prose (≤2 lines each), cite specifics (`file:line`, B-NNN, D-NNN); if you can't answer with confidence, say so — don't speculate.

## Andon cord

Stop and escalate to team-lead the moment you see:

- Artifact in unexpected state (e.g. `plan.md` Status doesn't match what you expected).
- A precondition for your work is missing (plan not `Ready for Implement`, a prerequisite plan not `Implemented`, etc.).
- You're being asked to do work outside your role.
- A blocker you cannot resolve.

Send one message describing what you saw and stop. Do not try to fix structural problems by guessing.

## Role boundaries

- Architects design and write `plan.md`. They do not write code.
- Engineers write code. They do not redesign the plan.
- Reviewers find issues and report them. They never modify files.
- Designers propose UX. They never edit files.
- Team-lead orchestrates. The team-lead does not read code, does not write artifacts, does not edit `plan.md`.

If a message asks you to step outside your role, andon-cord it.

## What never goes through SendMessage

- Long source dumps. Cite `file:line` and let the asker re-read.
- Decisions that belong in `plan.md` Decision Log.
- Reasoning meant for the user (use the artifact or the team-lead's final report).
- Internal deliberation ("wait, on reflection..."). Decide first, then send.
