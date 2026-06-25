# Architecture

```
Request <-(DTO)-> Handler|MCP <-(Domain)-> UseCase <-(Domain)-> Persistance
Trigger(Job,Event) -(Domain)-> UseCase <-(Domain)-> Persistance
```

## Module Structure

```
modules/[module]/
├── router.go           # Route definitions
├── handlers/           # HTTP handlers
├── usecases/           # Business logic
├── models/             # Domain models and DTOs
├── events/             # Event handlers
├── jobs/               # Background jobs
├── mcp/                # AI assistant tools
├── testing/            # Test factories and data
└── errors/             # Business errors
```
- 
- Modules have dependencies on each other
- Circular dependencies are not allowed

## Usecases

### Philosophy

- **Simple**: Each usecase does one thing well
- **Reusable**: Called from handlers, jobs, event handlers, or other usecases
- **Composable**: Build complex workflows by combining multiple usecases
- **Foundation**: Jobs, event handlers, and HTTP handlers are always based on usecases
- **Primary testing target**: Test business logic in usecase tests

### Rules

- Use GORM generics: `gorm.G[Model](db)` — see https://gorm.io/docs/the_generics_way.html
- Prefer batch usecases over Preload/Join — compose separate usecases instead
- NEVER use JOIN/PRELOAD on models from another module, use batch instead
- No database queries inside loops — use `WHERE id IN (?)`
- No protective coding — don't search before deleting/updating
- Never use `fmt.Errorf` — return predefined errors from `errors.go`

## Error Handling

- Modules define errors in `[module]/errors/errors.go` as
  `&coreErrors.DomainError{Status: http.StatusNotFound, Message: "..."}`
- `pkg/` packages use `errors.New()`
- Module's `MapErrorToHttpError` checks DomainError first, falls back to `MapErrorToHttpErrorGlobal`
- MCP equivalent: `MapErrorToMcpError` — business errors returned as-is, system errors logged

## REST Handlers

- File: `[action]_[resource].go` (one handler per file)
- Naming: `[Action][Entity]Handler`, `[Action][Entity]Request`, `[Action][Entity]Response`
- Params: `camelCase`, `uuid.UUID` for IDs, struct tags (`format:"uuid"`, `required:"true"`, `enum:"..."`)
- Route groups: `groups.Public` (no auth), `groups.Auth` (JWT), `groups.Admin`
- No business logic — delegate to usecases
- Errors mapped via module's `MapErrorToHttpError`
- Registration: `routing.POST(groups.Auth, "", "Create Sample", h.CreateSampleHandler)`

## Events

- Topics and payload structs defined in `modules/core/events.go`
- Topic naming: `ModuleName.EventName`
- Publish: `u.Events.Publish(core.TopicName, PayloadStruct{...})`
- Subscribe: `events.On(s, core.TopicName, "HandlerName", e.Handler)` in `Register()`
- Handlers are slim — no business logic, always call usecase
- Handler errors automatically logged

## Jobs

- Job types and payload structs defined in `modules/core/jobs.go`
- Register: `j.ScheduledJobs.Subscribe(core.JobType, handler)` in `Register()`
- Schedule from usecases only: `u.ScheduledJobs.Schedule(ctx, jobType, &payload, startAfter)`
- Handlers unmarshal payload and call usecases — no business logic
- Flow: `UseCase.Schedule() → DB Queue → Subscriber → Handler → UseCase.Execute()`

## MCP Handlers

- Tools in `modules/[module]/mcp/` only
- Input/Output structs with `json`, `jsonschema_description`, `jsonschema` tags
- Register in module's `WithMCP()` method
- Delegate to usecases — no business logic
- Business errors returned via `MapErrorToMcpError` (not logged), system errors logged
- All errors defined in module's `errors/errors.go`

## Comments

- Default to no comments. Only add a comment when the WHY is non-obvious (hidden constraint, workaround, surprising invariant).
- Don't describe WHAT the code does — let names do that.