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
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)
        XCTAssertFalse(scene.hasRevivedThisRun)
    }

    /// After resumeFromCheckpoint(), hasRevivedThisRun becomes true (first-revive-only spec).
    func testHasRevivedThisRunTrueAfterResumeFromCheckpoint() {
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)
        XCTAssertFalse(scene.hasRevivedThisRun)
        scene.resumeFromCheckpoint()
        XCTAssertTrue(scene.hasRevivedThisRun)
    }

    /// Default variant has null IAP and null ad, so isReviveMonetizationConfigured is false.
    func testIsReviveMonetizationConfiguredFalseWhenNoIAPOrAd() {
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)
        XCTAssertFalse(scene.isReviveMonetizationConfigured)
    }
}
