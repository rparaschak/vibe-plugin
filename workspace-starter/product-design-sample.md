# Product design

> **Starter file — adapt to your project.** This ships with the `vibe` plugin as a starting point for
> the repo-level `product-design` skill. Replace the example conventions below with your app's real
> design system, component library, and interaction patterns. Resolved by name by the `product-designer`
> agent; if this skill is absent, the designer proposes from the existing UI alone.

The app's UX/UI conventions — the shared language a `product-designer` proposes against so new features
look and behave like the rest of the product. Keep it to conventions that recur; one canonical example
(component, screen, or pattern) per rule beats prose.

## Design system & tokens

- The source of truth for color, spacing, typography, and radius (e.g. a theme file / token set) — name it.
- How spacing and sizing scale (e.g. a 4/8px scale); never hand-pick off-scale values.
- Light/dark or theme handling, if any.

## Component library

- The primitive library the app builds on (e.g. a component kit) — and that **features compose existing
  primitives, never fork or re-style them**. One canonical example of the wrapped/extended pattern.
- Where shared/app-level components live vs. feature-local ones, and when something graduates to shared.
- The icon set and how icons are used.

## Layout & navigation

- The page shell / navigation model (top nav, sidebar, tabs) and where a new screen slots in.
- The standard content widths, grid, and responsive behavior.
- How a primary action / page header is presented consistently.

## Interaction & state

- The conventions for the **empty / loading / error** states every data view must handle.
- Form patterns: validation timing, inline vs. summary errors, the primary/secondary button rule.
- Feedback patterns: toasts vs. inline confirmation, destructive-action confirmation, undo where it exists.
- Optimistic vs. pending UI, and how long-running actions report progress.

## Content & accessibility

- Voice/tone for labels, empty states, and errors (e.g. plain, action-oriented; no jargon).
- The accessibility bar features must meet (keyboard reachability, focus states, contrast, labels).

## What the designer should NOT do

- Don't introduce a new component library, design language, or one-off styling that bypasses the system.
- Don't design data shapes, hooks, or wiring — that's the architect's job; stay at UX altitude.
