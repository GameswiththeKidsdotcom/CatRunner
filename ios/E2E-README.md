# iOS E2E (J1–J5) — XCUITest

Per [e2e-spec-journeys.plan.md](../.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md) and [Agents/e2e-harness.md](../Agents/e2e-harness.md).

## Journey map

| Journey | Feature            | Test in `CatRunnerUITests/JourneyTests.swift` | Notes                          |
|---------|--------------------|----------------------------------------------|--------------------------------|
| J1      | App launch / start | `testJ1_Launch_GameSceneVisible`             | GameView visible, no crash     |
| J2      | Gameplay (swipe)   | `testJ2_Gameplay_SwipeAffectsGame`           | Swipe up (jump); no alert      |
| J3      | Game over / Revive | `testJ3_GameOver_ReviveDialogAppears`        | Watch ad, Play again, No thanks |
| J4a     | Revive → resume    | `testJ4a_Revive_ResumeGameplay`              | Tap Watch ad → game scene       |
| J4b     | No thanks → dismiss | `testJ4b_Revive_Done_DismissesToScene`       | Tap No thanks → alert dismisses |
| J5      | Play again         | `testJ5_PlayAgain_NewRunStarts`              | Tap Play again → new run       |

## Viewport / device (Investigation 4)

- **PR / CI:** iPhone 16, OS=latest (same as unit tests in `.github/workflows/test.yml`).
- **Optional:** 5-iPhone matrix for manual validation per [P002-VIEWPORT.md](P002-VIEWPORT.md).

## Running

- **Xcode:** Scheme CatRunner → Test (runs CatRunnerTests + CatRunnerUITests).
- **CLI:** `xcodebuild -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -configuration Debug test`

## Test hook

J3–J5 use launch argument **`ForceGameOver`** so the game shows the Revive/Game Over dialog after ~1s without relying on collision. Set in test via `app.launchArguments = ["ForceGameOver"]`. Implemented in `GameScene.triggerGameOverForE2EIfRequested()`.
