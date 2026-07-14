<!-- vibe-template: templates/workspace/backend-testing-sample.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Backend Testing

## Core rules
- Primary layer is integration testing against a real database and real services (API, MCP) — not mocks at the storage boundary.
- Behaviour that can't be reached through the API (Jobs, Event handlers, schedulers) is covered by use-case tests, still against the real database and services.
- Helpers and functions should be tested with unit tests.
- Tests are focused on user/system behaviours, not technical concerns — assert observable outcomes tied to the spec's Behaviors (B-ids), not implementation (see ## Testing Behaviours).
- Test setup is hidden in fixtures and framework. Test files focus on tests logic.
- Never mock the database, storage, or a service the code genuinely depends on — a mock stays green while the real query or schema is wrong. Mock only third-party boundaries you don't own and can't run locally.

## File Structure
<!-- Discover: Glob existing *test* files. Record the test filename pattern, where a test sits relative to the code it covers, and any per-feature/one-file rule. Cite file:line. -->
{{TEST_FILE_CONVENTION}}
<!-- e.g., in a Go service: `{handler_name}_test.go` in the same directory as the handler, `//go:build integration` tag, one file per feature. -->

## Running tests
<!-- Discover: find the test runner and the exact invocation (Makefile / package.json scripts / CI config). Record the command to run one file and the whole suite. Cite the source file:line. -->
{{TEST_RUNNER}}
<!-- e.g., in a Go service: `go test -tags integration ./...` for the full suite. -->

## Fixtures & setup
<!-- Discover: open 2–3 existing tests; record how fixtures, helpers, and shared setup are provided so test files stay logic-only. Cite file:line. -->
{{FIXTURE_CONVENTION}}

## Integration environment
<!-- Discover: find how integration tests get a real database and services (test-containers, compose, build tag, env-up script). Record the mechanism and any marker/tag that selects these tests. Cite file:line. -->
{{INTEGRATION_SETUP}}

## Testing Behaviours section
Structure tests by behaviour: an outer group per capability, nested cases per rule (access control, validation, happy path). Each case name states the observable rule and maps to a spec Behavior.

e.g., in a Go service:
```go
func BrandInvitations_API_Test(t *testing.T) {
    t.Run("Creating Brand ACL", func(t *testing.T) {
        t.Run("Anonymous user can not create Brand", func(t *testing.T) {...})
        t.Run("Manager can create Brand", func(t *testing.T) {...})
    })
    
    t.Run("Creating Brand validation", func(t *testing.T) {
        t.Run("Can create Brand with all fields valid", func(t *testing.T) {...})
        t.Run("Can not create Brand if user haven't finished onboarding", func(t *testing.T) {...})
    })
}
```
