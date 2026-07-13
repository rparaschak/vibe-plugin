<!-- SIMULATION ARTIFACT (Part 2 drive) — not a real project spec. Copied from templates/workspace/spec-template.md, header + sections filled by the driven /vibe:spec run. -->

# Spec: User Accounts — Auth

**Created**: 2026-07-13   **Status**: Ready for Plan
**Depends on**: —
**Input**: "add user accounts — registration/login, profile management, and an admin moderation panel"

---

## Problem

- Visitors cannot self-register; there is only a hard-coded login (research: auth/login.py:20), no signup path.
- The app has no first-class notion of an authenticated identity a user can create for themselves.

## Behaviors

- **B-001** (P1): A visitor can register with email + password and is immediately logged in (instant activation).
- **B-002** (P1): A registered user can log in and log out.

## UX structure *(conditional — present only when the design step ran; omit for purely technical work)*

- **Lives in**: `/register` and `/login` pages; top-nav shows auth state.
- **Screens**: Register (email+password form, primary "Create account", edge: email-taken inline error); Login (form, primary "Log in", edge: bad-credentials error); logged-in nav shows account menu with "Log out".
- **Components**: reuse Form/Input/Button; new AuthCard.
- **States**: empty (blank form) / loading (submit spinner, disabled button) / error (inline field errors).

## Out of Scope

- Email verification (deferred; instant activation chosen with the user).
- Profile management — moved to spec `260713-user-profile`.
- Admin moderation — moved to spec `260713-admin-moderation`.

## Assumptions

- ⚠️ Reuses the existing session middleware (middleware/session.py:8) rather than a new auth stack — confirmed against research.
- Password hashing already exists on the users table (models/user.py:12) and is reused.

## Open Questions *(gate — must be "None" before `/vibe:plan`)*

None
