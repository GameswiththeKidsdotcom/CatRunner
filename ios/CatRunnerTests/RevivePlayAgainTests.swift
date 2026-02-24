//
//  RevivePlayAgainTests.swift
//  CatRunnerTests
//
//  Tier 1 optional — Unit tests for revive and play-again flow (hasRevivedThisRun, resumeFromCheckpoint).
//

import XCTest
import SpriteKit
@testable import CatRunner

final class RevivePlayAgainTests: XCTestCase {

    /// hasRevivedThisRun is false before any revive.
    func testHasRevivedThisRunFalseInitially() {
        let scene = GameSceneTestHelper.makeSceneWithDidMove()
        XCTAssertFalse(scene.hasRevivedThisRun)
    }

    /// After resumeFromCheckpoint(), hasRevivedThisRun becomes true (first-revive-only spec).
    func testHasRevivedThisRunTrueAfterResumeFromCheckpoint() {
        let scene = GameSceneTestHelper.makeSceneWithDidMove()
        XCTAssertFalse(scene.hasRevivedThisRun)
        scene.resumeFromCheckpoint()
        XCTAssertTrue(scene.hasRevivedThisRun)
    }

    /// Default variant has null IAP and null ad, so isReviveMonetizationConfigured is false.
    func testIsReviveMonetizationConfiguredFalseWhenNoIAPOrAd() {
        let scene = GameSceneTestHelper.makeSceneWithDidMove()
        XCTAssertFalse(scene.isReviveMonetizationConfigured)
    }
}
