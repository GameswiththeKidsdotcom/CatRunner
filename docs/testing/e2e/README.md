# E2E — User journeys

End-to-end user journeys: **iOS** (J1–J5, XCUITest) and **Admin** (J6–J9, Playwright).

## Journey map (summary)

| Journey | Feature | iOS test | Admin |
|---------|---------|----------|--------|
| J1 | App launch / start | `testJ1_Launch_GameSceneVisible` | — |
| J2 | Gameplay (swipe) | `testJ2_Gameplay_SwipeAffectsGame` | — |
| J3 | Game over / Revive | `testJ3_GameOver_ReviveDialogAppears` | — |
| J4a | Revive → resume | `testJ4a_Revive_ResumeGameplay` | — |
| J4b | No thanks → dismiss | `testJ4b_Revive_Done_DismissesToScene` | — |
| J5 | Play again | `testJ5_PlayAgain_NewRunStarts` | — |
| J6 | Config editor | — | Playwright |
| J7 | Variant list | — | Playwright |
| J8 | Asset upload | — | Playwright |
| J9 | CI trigger | — | Playwright |

Full journey definitions and success criteria: see plan links below.

## Plans

- [e2e-spec-journeys.plan.md](../../../.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md) — Spec assessment, journey skeleton (J1–J9), investigation question sets.
- [admin-e2e-ui-test-plan.md](../../../.cursor/Plans/subplans/P001/admin-e2e-ui-test-plan.md) — Admin E2E (Playwright J6–J9) implementation and viewport scope.

## Test code

- **Admin (J6–J9):** [e2e/admin/journeys.spec.ts](../../../e2e/admin/journeys.spec.ts)
- **iOS (J1–J5):** [ios/CatRunnerUITests/JourneyTests.swift](../../../ios/CatRunnerUITests/JourneyTests.swift)

## Other docs

- [ios/E2E-README.md](../../../ios/E2E-README.md) — iOS E2E journey map, viewport, run instructions, ForceGameOver hook.

## Agents

- **e2e-harness:** [Agents/e2e-harness.md](../../../Agents/e2e-harness.md) — Harness design, viewport/device matrix, user-usable objects.
- **ui-test:** [Agents/ui-test.md](../../../Agents/ui-test.md) — E2E implementation for Admin (Playwright).
