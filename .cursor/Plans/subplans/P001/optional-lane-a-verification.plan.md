# Optional Lane A — Verification (5-iPhone E2E matrix, lane accessibility IDs)

**Plan:** [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) (Investigation 4, Optional Tier 4).  
**Master-Plan:** [Master-Plan.md](../../Master-Plan.md) — Optional and deferred work (backlog), Lane A.

**Status:** Verified in codebase (read-only). Both items are **already implemented**. No code changes required.

---

## 1. Scope

| Item | Reference | Expected |
|------|-----------|----------|
| 5-iPhone E2E matrix | e2e-spec-journeys Investigation 4 | CI job runs unit + UI tests on SE, 14, 15, 16, 16 Pro Max; `fail-fast: false`. |
| Lane accessibility IDs | Same | LaneTapLeft, LaneTapRight (and GameView, GameOverAlert) for E2E selectors; J2 test for lane taps. |

---

## 2. Verification (read-only)

### 2.1 5-iPhone E2E matrix

**Location:** [.github/workflows/test.yml](../../../.github/workflows/test.yml)

- **Job name:** `test-ios-matrix` (lines 71–110).
- **Matrix devices:** iPhone SE (3rd generation), iPhone 14, iPhone 15, iPhone 16, iPhone 16 Pro Max.
- **Strategy:** `fail-fast: false` (one device failure does not cancel others).
- **Steps:** Checkout → `xcodebuild -scheme CatRunner -destination "platform=iOS Simulator,name=${{ matrix.device }},OS=latest" test` → report + upload log artifact.

**Confidence (implementation present):** 95%. Matches e2e-spec-journeys §4 Implementation (2026-02-24) and viewport matrix table.

### 2.2 Lane accessibility IDs

**Locations:**

- **GameViewController** ([ios/CatRunner/GameViewController.swift](../../../ios/CatRunner/GameViewController.swift)):
  - `skView.accessibilityIdentifier = "GameView"` (J1).
  - `LaneTapLeft` / `LaneTapRight` on overlay `UIButton`s with `accessibilityLabel` "Move lane left" / "Move lane right"; targets call `gameScene?.moveLaneLeft()` / `moveLaneRight()`.
  - `alert.view.accessibilityIdentifier = "GameOverAlert"` for game-over/revive alert.
- **JourneyTests** ([ios/CatRunnerUITests/JourneyTests.swift](../../../ios/CatRunnerUITests/JourneyTests.swift)):
  - `testJ2_LaneTapRegions_ExistAndTappable`: asserts `app.buttons["LaneTapLeft"]` and `app.buttons["LaneTapRight"]` exist, taps both, asserts GameView still present.

**Confidence (implementation present):** 95%. Lane tap regions and J2 variant test match plan; no additional lane IDs required for current J1–J5 (jump/slide remain gesture-only per Investigation 1).

---

## 3. Optional extensions (backlog)

- **Score HUD:** GameScene uses `scoreHUDLabel.name = "scoreHUD"` (SKNode name). Not exposed as `accessibilityIdentifier` (SpriteKit nodes are not UIKit). E2E does not currently assert on score text; if needed later, consider exposing score string via a dedicated accessibility element or keep asserting only on GameView + alert.
- **Additional IDs:** Plan states "extend if more IDs needed". Current J1–J5 do not require jump/slide buttons; swipe is sufficient for J2 gameplay. No change recommended unless new journeys need tap targets for jump/slide.

---

## 4. Validation and risks

| Check | Action | Risk |
|-------|--------|------|
| CI | Push/PR runs `test` (iPhone 16) + `test-ios-se` + `test-ios-matrix` (5 devices) + `admin-e2e`. | Matrix job may be slower; no code change so no new regression from this verification. |
| Local | `cd ios && xcodebuild -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' test` (and optionally one other device). | None. |
| Rollback | Not applicable (verification only; no code edits). | N/A |

---

## 5. Confidence and handoff

- **Confidence (root cause):** N/A (verification of existing implementation).
- **Confidence (solution path):** 95% — 5-iPhone matrix and lane IDs are implemented as specified; Optional Lane A can be marked done in Master-Plan backlog.

**Next:** Update [Master-Plan.md](../../Master-Plan.md) Optional and deferred work table: mark "5-iPhone E2E matrix" and "Lane accessibility IDs" as done with date 2026-02-24 (verification). Update [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) Next hand off to reference Optional Lane A verification complete.
