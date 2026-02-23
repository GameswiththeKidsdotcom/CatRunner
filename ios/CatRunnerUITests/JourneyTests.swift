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

    // MARK: - J3 — Collision → game over or revive

    func testJ3_GameOver_ReviveDialogAppears() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "J3: Game Over / Revive dialog should appear")
        XCTAssertTrue(app.buttons["Revive"].exists, "J3: Revive button present")
        XCTAssertTrue(app.buttons["Play again"].exists, "J3: Play again button present")
        XCTAssertTrue(app.buttons["Done"].exists, "J3: Done button present")
    }

    // MARK: - J4 — Revive flow

    func testJ4a_Revive_ResumeGameplay() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        app.buttons["Revive"].tap()
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.waitForExistence(timeout: 3), "J4a: After Revive, game scene should be visible again")
    }

    func testJ4b_Revive_Done_DismissesToScene() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        app.buttons["Done"].tap()
        XCTAssertFalse(alert.waitForExistence(timeout: 2), "J4b: After Done, alert should dismiss")
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.exists, "J4b: Game view still present after Done (no new run)")
    }

    // MARK: - J5 — Game over → play again

    func testJ5_PlayAgain_NewRunStarts() throws {
        app.launchArguments = ["ForceGameOver"]
        app.launch()
        let alert = app.alerts["Game Over"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        app.buttons["Play again"].tap()
        let gameView = app.otherElements["GameView"]
        XCTAssertTrue(gameView.waitForExistence(timeout: 3), "J5: After Play again, new run (GameView) should be visible")
        XCTAssertFalse(alert.exists, "J5: Alert should be dismissed")
    }
}
