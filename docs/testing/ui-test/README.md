# Ui-test — Viewport, layout, accessibility

UI/viewport/accessibility validation and Admin E2E implementation. Layout, contrast, cross-viewport (iPhone, Android, iPad, desktop), and full user flows.

## Scope

- Admin (J6–J9): layout, contrast, viewport projects (e.g. desktop-1280, desktop-1440).
- Viewport and 5-iPhone matrix (when in scope, e.g. P002).
- User-usable objects: tappable, in-viewport, minimal stable selectors.

## Plans

- [admin-e2e-ui-test-plan.md](../../../.cursor/Plans/subplans/P001/admin-e2e-ui-test-plan.md) — Admin E2E (Playwright) and viewport scope.
- P002 viewport validation (archived): [.cursor/Plans/z-archives/z-P002/P002-viewport-validation-2026-02-23.md](../../../.cursor/Plans/z-archives/z-P002/P002-viewport-validation-2026-02-23.md).

## Agent

- **ui-test:** [Agents/ui-test.md](../../../Agents/ui-test.md) — E2E user journeys, layout, contrast, viewport, UX/UI automation.

## E2E code (Admin)

- [e2e/admin/journeys.spec.ts](../../../e2e/admin/journeys.spec.ts) — Playwright specs for J6–J9.
