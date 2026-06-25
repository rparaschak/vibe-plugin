# Backend Code Review Checklist

## Critical Checks

### Guidelines Compliance
Review code against guidelines. Flag any violations.

### Query Performance
- [ ] No N+1 queries - use `.Preload()` or batch operations
- [ ] No queries inside loops
- [ ] Batch operations for multiple records

### Code Simplification
- [ ] No defensive coding (no search before delete/update)
- [ ] No comments in code
- [ ] Core readability

### Tests
- [ ] Split files: `{feature}_usecase_test.go` + `{feature}_api_test.go`
- [ ] API tests don't duplicate usecase test behaviors
- [ ] Access control tests consolidated (one per role)