# Testing — Documentation index

Start here for any testing question. This index links to test plans, agents, spec sections, and test code. Plan files stay in [.cursor/Plans/](../.cursor/Plans/); this hub only links to them (per [Agents/planner.md](../Agents/planner.md)).

## What “testing” means in this repo

| Type | Scope | Code / validation |
|------|--------|-------------------|
| **Unit** | iOS engine, mechanics, path guarantee, scoring | `ios/CatRunnerTests/` |
| **E2E iOS** | User journeys J1–J5 (launch, gameplay, revive, play again) | `ios/CatRunnerUITests/JourneyTests.swift` |
| **E2E Admin** | User journeys J6–J9 (config, variants, asset upload, CI) | `e2e/admin/journeys.spec.ts` (Playwright) |
| **logic-test** | Game logic, state machine, allowed moves, revive/play-again | Validation deliverable; no separate test target |
| **ui-test** | Viewport, layout, contrast, accessibility, Admin E2E implementation | Playwright + viewport/validation plans |

## Where things live

| Category | Paths |
|----------|--------|
| **Test code** | `e2e/admin/`, `ios/CatRunnerTests/`, `ios/CatRunnerUITests/` |
| **Test plans** | [.cursor/Plans/subplans/P001/](../.cursor/Plans/subplans/P001/) (e.g. e2e-spec-journeys.plan.md, admin-e2e-ui-test-plan.md, logic-test-revive-playagain-2026-02-23.md, C11-tests.plan.md); [.cursor/Plans/z-archives/](../.cursor/Plans/z-archives/) (completed UI/logic-test plans) |
| **Agents** | [Agents/tester.md](../Agents/tester.md), [Agents/ui-test.md](../Agents/ui-test.md), [Agents/logic-test.md](../Agents/logic-test.md), [Agents/e2e-harness.md](../Agents/e2e-harness.md) |
| **Spec** | [docs/SPECIFICATION.md](../SPECIFICATION.md) §7 (testing requirements, baseline) |

## By type (drill down)

- **E2E** (journeys, Playwright + XCUITest) → [e2e/README.md](e2e/README.md)
- **Logic-test** (state, rules, revive/play-again) → [logic-test/README.md](logic-test/README.md)
- **Ui-test** (viewport, accessibility, Admin E2E) → [ui-test/README.md](ui-test/README.md)
- **Baselines** (test counts, CI, screenshot strategy) → [baselines/README.md](baselines/README.md)
