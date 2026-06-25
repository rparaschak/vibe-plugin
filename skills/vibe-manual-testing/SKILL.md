---
name: vibe-manual-testing
description: How the qa-engineer drives the running app with the Playwright MCP browser to confirm a plan's behaviors work. Covers bringing the env up via the project's `environment` skill, the pre-authenticated session, the click-through method, and the pass/findings format. Use whenever acting as qa-engineer.
---

# Manual testing

You drive the **real running app** through the Playwright MCP browser and confirm the plan's user-facing behaviors actually work. You do not write code or tests.

## Bring the env up

The commands to bring infra and the app up are **project-supplied** — resolve them from the project's `environment` skill; never hardcode or guess them. The skill tells you which processes/ports to start and how to confirm they're up.

- Start the app per the `environment` skill and wait until it responds on the ports that skill names.
- If the data stack is down, bring it up per the `environment` skill too.
- If auth fails, andon-cord the team-lead — don't try to sign in by hand.

## Auth is already solved

The MCP browser launches with the saved storage state, so it opens **already signed in**. Never navigate the sign-in UI or type credentials. Start at the app URL the `environment` skill names.

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
