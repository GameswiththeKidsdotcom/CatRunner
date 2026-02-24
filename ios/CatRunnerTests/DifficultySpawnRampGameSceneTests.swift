//
//  DifficultySpawnRampGameSceneTests.swift
//  CatRunnerTests
//
//  DifficultySpawnRamp — Logic-test items 8–9: After revive totalElapsedTime restored;
//  new run = 0, advance increments, restart unchanged.
//

import XCTest
import SpriteKit
@testable import CatRunner

final class DifficultySpawnRampGameSceneTests: XCTestCase {

    /// Logic-test item 8: After resumeFromCheckpoint(), totalElapsedTime must equal checkpointElapsedTime.
    func testAfterResumeFromCheckpoint_totalElapsedTimeEqualsCheckpoint() {
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)

        XCTAssertEqual(scene.totalElapsedTimeForTesting, 0)
        scene.advanceToNextSegmentForTesting()
        let checkpoint = scene.checkpointElapsedTimeForTesting
        scene.resumeFromCheckpoint()
        XCTAssertEqual(scene.totalElapsedTimeForTesting, checkpoint, "After revive, totalElapsedTime must be restored to checkpoint value")
    }

    /// Logic-test item 9 (new run): totalElapsedTime starts at 0.
    func testNewRun_totalElapsedTimeStartsAtZero() {
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)
        XCTAssertEqual(scene.totalElapsedTimeForTesting, 0)
    }

    /// Logic-test item 9 (advance): totalElapsedTime incremented by segment duration when advancing.
    func testAdvance_incrementsTotalElapsedTime() {
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)
        let t0 = scene.totalElapsedTimeForTesting
        scene.advanceToNextSegmentForTesting()
        XCTAssertGreaterThan(scene.totalElapsedTimeForTesting, t0, "Advance should add segment duration to totalElapsedTime")
    }

    /// Logic-test item 9 (restart): totalElapsedTime unchanged when restarting current segment.
    func testRestartCurrentSegment_doesNotChangeTotalElapsedTime() {
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)
        let t0 = scene.totalElapsedTimeForTesting
        scene.restartCurrentSegmentForTesting()
        XCTAssertEqual(scene.totalElapsedTimeForTesting, t0, "Restart same segment must not add to totalElapsedTime")
    }
}
