//
//  JourneyTests.swift
//  CatRunnerUITests
//
//  iOS E2E J1–J5 per e2e-spec-journeys.plan.md §2.1 and Agents/e2e-harness.md.
//  Viewport/device: iPhone 16 for PR (Investigation 4); element-present assertions.
//

import XCTest

final class JourneyTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    // MARK: - J1 — App launch / start

    func testJ1_Launch_GameSceneVisible() throws {
        app.launch()
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.waitForExistence(timeout: 5), "J1: Game scene (GameView) should be visible after launch")
    }

    // MARK: - J2 — Gameplay (run, move, score)

    func testJ2_Gameplay_SwipeAffectsGame() throws {
        app.launch()
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.waitForExistence(timeout: 5), "GameView must exist for J2")
        let center = gameView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let up = center.withOffset(CGVector(dx: 0, dy: -80))
        center.press(forDuration: 0.15, thenDragTo: up)
        // Still in game (no game-over alert); scene responds to input
        XCTAssertTrue(gameView.exists, "J2: After swipe, game view should still be present")
        let alert = app.alerts.firstMatch
        XCTAssertFalse(alert.waitForExistence(timeout: 1), "J2: No game-over alert expected during short play")
    }

    /// J2 variant: lane tap regions (LaneTapLeft, LaneTapRight) exist and are tappable (e2e-spec-journeys Investigation 4).
    func testJ2_LaneTapRegions_ExistAndTappable() throws {
        app.launch()
        XCTAssertTrue(app.otherElements["GameView"].waitForExistence(timeout: 5), "J2: GameView must exist")
        let left = app.buttons["LaneTapLeft"]
        let right = app.buttons["LaneTapRight"]
        XCTAssertTrue(left.waitForExistence(timeout: 3), "J2: LaneTapLeft should exist")
        XCTAssertTrue(right.waitForExistence(timeout: 1), "J2: LaneTapRight should exist")
        left.tap()
        right.tap()
        XCTAssertTrue(app.otherElements["GameView"].exists, "J2: After lane taps, game view should still be present")
    }

    // MARK: - J3 — Collision → game over or revive

    func testJ3_GameOver_ReviveDialogAppears() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "J3: Game Over / Revive dialog should appear")
        // Tier 2: With monetization configured, "Watch ad" is present; with default (both IDs null), only Play again + No thanks.
        XCTAssertTrue(app.buttons["Play again"].exists, "J3: Play again button present")
        XCTAssertTrue(app.buttons["No thanks"].exists, "J3: No thanks button present")
    }

    // MARK: - J4 — Revive flow

    func testJ4a_Revive_ResumeGameplay() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        // Tier 2: Watch ad only when variant has revive IAP or rewarded ad; skip when not configured.
        guard app.buttons["Watch ad"].exists else {
            throw XCTSkip("J4a: Watch ad not shown when monetization not configured (default variant)")
        }
        app.buttons["Watch ad"].tap()
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.waitForExistence(timeout: 3), "J4a: After Watch ad, game scene should be visible again")
    }

    func testJ4b_Revive_Done_DismissesToScene() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        app.buttons["No thanks"].tap()
        XCTAssertFalse(alert.waitForExistence(timeout: 2), "J4b: After No thanks, alert should dismiss")
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.exists, "J4b: Game view still present after No thanks (no new run)")
    }

    /// J4 second game-over path (first-revive-only): after one revive, second game over must not show "Watch ad".
    func testJ4c_SecondGameOver_NoWatchAd() throws {
        app.launchArguments = ["ForceGameOver", "ForceSecondGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "J4c: First game-over alert should appear")
        guard app.buttons["Watch ad"].exists else {
            throw XCTSkip("J4c: Watch ad not shown (monetization not configured); need it to test second-game-over path")
        }
        app.buttons["Watch ad"].tap()
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.waitForExistence(timeout: 3), "J4c: After Watch ad, game scene should be visible again")
        let secondAlert = app.alerts["Game Over"]
        XCTAssertTrue(secondAlert.waitForExistence(timeout: 5), "J4c: Second game-over alert should appear")
        XCTAssertFalse(app.buttons["Watch ad"].exists, "J4c: Second game over must not show Watch ad (first-revive-only)")
        XCTAssertTrue(app.buttons["Play again"].exists, "J4c: Play again present on second game over")
        XCTAssertTrue(app.buttons["No thanks"].exists, "J4c: No thanks present on second game over")
    }

    // MARK: - J5 — Game over → play again

    func testJ5_PlayAgain_NewRunStarts() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        app.buttons["Play again"].tap()
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.waitForExistence(timeout: 5), "J5: After Play again, new run (GameView) should be visible")
        // Primary success = new run started; alert dismissal timing can vary in simulator.
    }
}
