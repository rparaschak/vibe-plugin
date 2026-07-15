---
name: environment
description: {{DESCRIPTION}}
---
<!-- vibe-template: templates/workspace/environment-skill.md v1 | generated 2026-07-13 | edits below this marker are yours -->
<!-- Fill `description:` above with one line: what this brings up + that these scripts and commands are the ONLY sanctioned way to run it, e.g.
     "The sanctioned way to bring the local environment up, lint, build, and run verification for <project>: two self-verifying scripts plus the repo's lint/build commands, no improvised commands."
     Discover the project name from the repo-root manifest/README. -->

# Environment

This skill is the **only** sanctioned way to bring the environment up, lint, build, and run verification. The engineer, test-engineer, qa-engineer, and reviewer agents resolve it **by name** and run the two scripts and the lint/build commands below **verbatim** — they never improvise `docker`, `make`, lint, build, or test commands of their own. If a command you need is missing here, that is an andon-cord to the team-lead, not a reason to guess.

## Bring the environment up

Run this before any test that needs infra or the app. It is **idempotent** (safe when already up) and **self-verifying** — it exits non-zero with a named failure if a service isn't ready within its timeout.

```
{{ENV_UP_PATH}}
```
<!-- Discover: the repo-relative path env-up.sh was written to. e.g. .claude/scripts/env-up.sh or .grok/scripts/env-up.sh -->
- App URL (what a browser opens): {{APP_URL}} <!-- Discover: the base URL a browser opens, from env-up's wait_http checks. e.g. http://127.0.0.1:8080 -->

## Lint & build

The repo's lint (format/typecheck) and build/compile commands. The engineer runs these before reporting; the reviewer runs them in its mechanized-checks-first step. Run each **verbatim** — resolve by name, never improvise a formatter or compiler invocation.

{{LINT_BUILD_COMMANDS}}
<!-- Discover: the repo's lint/format/typecheck command(s) and its build/compile command, from the repo-root manifest or CI config (package scripts, Makefile, CI workflow). List each verbatim, one per line in a code block. If the repo is interpreted with no build step, say so explicitly. e.g. `npm run lint` then `npm run build`. -->

## Run verification

One entry point for every test layer. Pass a layer and, optionally, a single file/test to narrow the run; the script prints the layer + verbatim command and **exits with the underlying test exit code**.

```
{{TEST_RUN_PATH}} [unit|integration|e2e|all] [file-or-args…]
```
<!-- Discover: the repo-relative path test-run.sh was written to, and which layer names actually resolve to a real command (others are `:`). e.g. .claude/scripts/test-run.sh integration or .grok/scripts/test-run.sh integration -->

## Which verifications a change triggers
<!-- Discover: is this a monorepo / are there dependent clients? Trace whether one component consumes another's contracts (generated clients, shared schemas). Record the decision logic: which change scope runs which layers, and why a cross-cutting change must run all. -->
{{VERIFICATION_TRIGGERS}}
<!-- e.g. Frontend-only change → `test-run unit` + `test-run e2e`. Backend or shared/contract change → `env-up` then `test-run all`, because the dependent clients may break. -->

## Troubleshooting (named failures from env-up)
<!-- Discover: for each wait_port/wait_http check in env-up, write the exact "FAILED — <name> …" string it prints and what a human does about it (start Docker, free the port, read the app log). One row per readiness check. -->
{{TROUBLESHOOTING}}
<!-- e.g.
     `FAILED — postgres not listening on 127.0.0.1:5432` → Docker isn't running or the compose stack didn't start; run `docker ps`, then re-run env-up.
     `FAILED — api health check … not green` → the app crashed on boot; read its log (/tmp/app.log) for the stack trace. -->
