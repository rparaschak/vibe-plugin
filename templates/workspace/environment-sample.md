<!-- vibe-template: templates/workspace/environment-sample.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Development Environment

<!-- If this repo operates differently in a specific environment (e.g. a hosted web/CI sandbox), point here
to the skill or doc that explains how to bring things up there. -->


## Backend

### Commands

- `make local-infra` — Spins local infra for local server (idempotent)
- `make start` — Starts local server
- `make test` — Runs all tests agains running local server
- `make check` — Runs linter (golangci-lint) + go vet + `make build` + `make test`
- `make build` — Builds the project
- `make migration NAME=xxx ENV=yyy` - Creates a migration based on schema change

### Current Limitations

- Only 1 started server is possible (TODO: make ephemeral-env)

### Verification checklist

- [ ] `make start`
- [ ] `make check`

All checks should pass without warnings and failures

## Frontend

### Commands
- `yarn dev` - Starts local server
- `yarn lint` - Runs linter
- `yarn test` - Runs all tests (integration + E2E, headless)
- `yarn test:integration` Runs integration tests only (vitest)
- `yarn test:e2e` - Run E2E tests only (playwright, headless)

### Verification checklist

- [ ] `yarn lint`
- [ ] `cd api && make start`
- [ ] `yarn test`

All checks should pass without warnings and failures

## Verification decision logic

This is a **monorepo**: backend and frontend live together and the frontend consumes the backend's contracts, so a backend change can break the clients that depend on it.

- **Frontend-only change** → run frontend verification only.
- **Backend change** (or anything shared/contract-level) → run **all** verifications, because the dependent components (the clients) may break.
