<!-- SIMULATION ARTIFACT (Part 2 drive) — MATERIALIZED sibling from block 5 decomposition. Left Draft for its own later /vibe:spec pass (UX, critique, readiness). Only header + behaviors set this run. -->

# Spec: Admin Moderation

**Created**: 2026-07-13   **Status**: Draft
**Depends on**: 260713-user-accounts
**Input**: "(from decomposition of user-accounts) admin moderation panel — user list, suspend/ban, session invalidation, audit"

---

## Problem

- (to be drafted in this sibling's own /vibe:spec pass)

## Behaviors

<!-- moved from the parent's locked set, renumbered LOCAL from B-001 -->

- **B-001** (P1): An admin can view a list of users.
- **B-002** (P1): An admin can suspend/ban a user, blocking their login.
- **B-003** (P1): A suspended user sees a clear "account suspended" message on login attempt.
- **B-004** (P1): Suspending a user invalidates their active sessions.
- **B-005** (P3): An admin can see a basic audit trail of suspend/ban actions.

## Out of Scope

- Content moderation (chosen out of scope with the user; suspend/ban of users only).

## Assumptions

- (deferred to this sibling's own pass)

## Open Questions *(gate — must be "None" before `/vibe:plan`)*

None
