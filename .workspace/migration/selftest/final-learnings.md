# Learnings — 260714-add-shout-flag (implement run)

- 2026-07-14 — This project has no lint/build command (zero-dependency Node CLI); the engineer's "clean lint + build" bar and the reviewer's mechanized gate both resolve to "report as not run" per `backend-review` — the full suite via `./.claude/scripts/test-run.sh` is the only executable gate.
- 2026-07-14 — `test-run.sh all` is the right exit-gate invocation here: integration/e2e layers print `(none)` and exit 0, satisfying the BE exit lens (integration suite ran) without inventing commands.
- 2026-07-14 — The plan-mandated same-change update of `.claude/skills/backend-architecture/SKILL.md` (D-002) reviewed cleanly as in-scope when the review brief names it explicitly; without that naming a reviewer could score it as extra scope under `minimal`.
- 2026-07-14 — B-004's pinned-literal both-orders test behavior (assert each order === the literal, not order-equality) was implemented as specified and caught nothing — but the reviewer confirmed it independently, validating the plan's anti-false-pass note as cheap insurance.
- 2026-07-14 — One block commit (`07bc48e`) covering engineer + test-engineer work, reviewed once with both leaves citing that hash, closed the block in a single review round (Accept, 12/12).
