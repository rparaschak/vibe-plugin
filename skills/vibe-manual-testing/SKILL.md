---
name: vibe-manual-testing
description: How the qa-engineer drives the running app with the Playwright MCP browser to confirm a plan's behaviors work. Covers bringing the env up with one command, the pre-authenticated session, the click-through method, and the pass/findings format. Use whenever acting as qa-engineer.
---

# Manual testing

You drive the **real running app** through the Playwright MCP browser and confirm the plan's user-facing behaviors actually work. You do not write code or tests.

## Bring the env up

Data services are already up — Docker on local, native services on Claude web — so you only need to start the app processes:

- From the repo root, start the API and web dev server in the background:
  - `make api-run` (API on `:5601`, E2E auth mode — no Clerk network)
  - `make web-run` (web on `:5600`, E2E auth mode)
- Wait until both ports respond (`nc -z 127.0.0.1 5601` and `nc -z 127.0.0.1 5600`).
- If you suspect the local data stack is down, run `make local-up` from the repo root (no-op on Claude web).
- If auth fails, andon-cord the team-lead — don't try to sign in by hand.

## Auth is already solved

The MCP browser launches with the saved storage state, so it opens **already signed in**. Never navigate the Clerk sign-in UI or type credentials. Start at `http://localhost:5600`.

## Method

1. Read the plan's **Behaviors** (B-NNN) for the block under test. Those are your test cases.
2. `browser_navigate` to the app, then per behavior: `browser_snapshot` to read state, `browser_click` / `browser_type` to act, snapshot again to verify the outcome the behavior promises.
3. Test the real happy path plus the obvious user-facing edge the behavior names (empty state, validation error, etc.). Don't audit code or chase paths outside the plan.

## Reply format

Send exactly ONE, per `vibe-team-communication-protocol`.

**Pass** — every behavior confirmed:
```
QA pass — <block>.
Behaviors: B-001 ✓, B-002 ✓, …
```

**Findings** — one bullet per broken behavior, ordered by behavior id:
```
QA findings — <block>:
- B-003 · <what you did> → <what happened> vs <what the behavior promises>
- B-005 · … → … vs …
```

Bullets only. Each finding ties to a behavior and states the observed vs expected. A finding is a routed fix for the engineer — you never edit code.
