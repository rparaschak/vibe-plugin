# Plan: CLI --version flag

**Created**: 2026-07-13   **Status**: Ready for Implement
**Depends on**: —
**Input**: "add a --version flag to a CLI"

---

## Behaviors

- **B-001** — Running `mycli --version` prints the CLI's current package version to stdout and exits 0.
- **B-002** — Running `mycli -v` (short alias) also prints the version and exits 0, taking precedence over any other flags passed alongside it.

## Current State *(technical research — written by codebase-researcher)*

- CLI entrypoint parses argv manually, no existing `--version`/`-v` handling — `src/cli.ts:1-40` (toy fixture; no real repo scan performed for this dry run).
- Package version lives in `package.json:"version"` — no runtime accessor currently exported.

## Architecture

### BE *(architect — backend)*

- Add `src/version.ts` exporting `getVersion()` that reads `package.json`'s `version` field at runtime — single source of truth, no build-step duplication.
- Parse `--version` / `-v` at the top of the existing arg-parsing entrypoint (`src/cli.ts`), short-circuiting before any other flag handling — satisfies B-002's precedence requirement.
- **Constitution**: ✅ all clear

## Test behaviors

### BE *(architect — backend)*

- `mycli --version` and `mycli -v` both print the version and exit 0, and version short-circuits other flags · B-001, B-002

## Open Questions *(gate — must be "None" before `/vibe:implement`)*

None

## Tasks

| ID | Block | Behavior | Verification | Owner | State | Evidence |
|---|---|---|---|---|---|---|
| T-901 | Platform | Add a `getVersion()` wrapper reading the package version at runtime · B-001 | `node -e "console.log(require('./src/version').getVersion())"` → prints semver | platform | not_started | — |
| T-001 | BE | Wire `--version`/`-v` into the CLI arg parser to call `getVersion()` and print+exit 0 before other flag handling · B-001, B-002 | `mycli --version` → prints version, exit 0; `mycli -v` → same | be-eng | not_started | — |
| T-002 | BE | Integration tests for the version flag · B-001, B-002 | `npm test -- version.test.ts` → green | be-test | not_started | — |

## Decision Log *(optional — non-obvious choices not already captured in Architecture)*

- **D-001** — Read version from `package.json` at runtime rather than a hardcoded constant · avoids drift on release bumps · rejected alternative: build-time codegen constant (unnecessary complexity for a toy CLI).
