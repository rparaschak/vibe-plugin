<!-- vibe-template: templates/workspace/backend-testing-sample.md v1 | generated 2026-07-13 | edits below this marker are yours -->

# Backend Testing

## Core rules
- Primary testing is Integration Testing(API, MCP) with real database and services
- Secondary tests that can not be tested by API(e.g. Jobs, Event handlers, ...) are usecases tests using read database and services
- Helpers and functions should be tested with unit tests
- Tests are focused on user/system behaviours, not technical concerns (See ## Testing Behaviours section)
- Test setup is hidden in fixtures and framework. Test files focus on tests logic.

## File Structure
- Filename: `{handler_name}_test.go`
- Location: same directory as handler file
- Build tag: `//go:build integration`
- One file per feature


## Testing Behaviours section
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
