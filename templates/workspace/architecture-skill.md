---
name: {{COMPONENT}}-architecture
description: {{DESCRIPTION}}
---

<!-- vibe-template: templates/workspace/architecture-skill.md v1 | generated 2026-07-13 | edits below this marker are yours -->
<!-- Fill `description:` above with one line naming the component and its role, e.g.
     "Structural authority for the backend component: module layout, data flow, where new code goes, naming, and forbidden patterns."
     Discover the component's role from its top-level directory name + its README/package manifest.
     COMPONENT must equal the domain token the plan briefs use to resolve this skill (usually the top-level component name, e.g. `backend`, `frontend`) — a mismatched name makes every agent's skill lookup silently fail. -->

# {{COMPONENT}} Architecture

This skill is the **structural authority** for the {{COMPONENT}} component. The architect, engineer, reviewer, and test-engineer agents resolve it by name and **cite it** in their designs, findings, and reviews; when it conflicts with an agent's own defaults, this skill wins. **Keep it current** — any structural change (new layer, moved boundary, renamed convention, new forbidden rule) lands here in the **same PR** that makes the change. A stale architecture doc is how the authority silently dies.

## Data flow
<!-- Discover: trace ONE request/trigger end to end (entrypoint → business logic → persistence). Open a router/controller and follow the call chain (codegraph or grep). Record the layers in order and what type crosses each boundary. -->
{{DATA_FLOW}}
<!-- (backend example) Request <-(DTO)-> Handler <-(Domain)-> UseCase <-(Domain)-> Persistence; Trigger(Job,Event) -(Domain)-> UseCase
     (frontend example) Route → Page → hook → api-client -->

## Module / layer structure
<!-- Discover: `ls` the component root and one representative module. List each directory/layer with its one-line responsibility, and any cross-module dependency rule. -->
{{MODULE_STRUCTURE}}
<!-- (backend example) modules/[module]/ — handlers/ (HTTP), usecases/ (business logic), models/ (domain + DTOs), errors/ (business errors). Modules may depend on each other; circular deps forbidden.
     (frontend example) features/[feature]/ — components/ (UI), hooks/ (state + data), api/ (fetchers). -->

## Where things go
<!-- Discover: for each common addition (new endpoint, new UI component, new model, new job/event), find the most recent example added and record which file/dir it lives in and the pattern it followed. -->
{{WHERE_THINGS_GO}}
<!-- (backend example) New endpoint → handlers/, registered in router.go. New model → modules/[m]/models/. -->

## Naming conventions
<!-- Discover: sample 5–10 existing files and their exported symbols; extract the file-name and type/function patterns actually in use (not aspirational ones). -->
{{NAMING}}
<!-- (backend example) Files [action]_[resource].go; types [Action][Entity]Handler / Request / Response; params camelCase, uuid.UUID for IDs. -->

## Integration points
<!-- Discover: find how this component talks to others — generated clients, shared event/job topic registries, contract files. Note the regeneration/codegen command by name if one exists. -->
{{INTEGRATION_POINTS}}
<!-- (backend example) Event topics in modules/core/events.go; consume another component's contracts via a generated client — regenerate with `make gen-client`. -->

## Forbidden patterns
<!-- Discover: list structural/boundary prohibitions only, e.g. no cross-module JOIN, layering violations — grep the component's guidelines for "never/don't/avoid" rules that break architecture. Exclude style/lint-shaped rules; those belong in the domain's review checklist (`<domain>-review`). -->
{{FORBIDDEN}}
<!-- (backend example) Never JOIN/PRELOAD across modules (use batch usecases); no DB queries inside loops (use WHERE id IN (?)); never fmt.Errorf — return predefined errors. -->

## Exemplar files
<!-- Discover: pick the single cleanest real file per layer that a new contributor should copy from. Give repo-relative paths, not descriptions. -->
{{EXEMPLARS}}
<!-- (backend example) Handler: modules/sample/handlers/create_sample.go · UseCase: modules/sample/usecases/create.go · Model: modules/sample/models/sample.go -->
