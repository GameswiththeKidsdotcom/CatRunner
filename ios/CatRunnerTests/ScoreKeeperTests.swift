//
//  ScoreKeeperTests.swift
//  CatRunnerTests
//
//  C8 — Scoring: segment completion, multiplier, high score persistence.
//

import XCTest
@testable import CatRunner

final class ScoreKeeperTests: XCTestCase {

    func testInitialScoreZero() {
        let keeper = ScoreKeeper(userDefaults: .standard)
        XCTAssertEqual(keeper.currentScore, 0)
    }

    func testAddSegmentCompletedIncrementsScore() {
        let keeper = ScoreKeeper(userDefaults: .standard)
        keeper.pointsPerSegment = 100
        keeper.addSegmentCompleted()
        XCTAssertEqual(keeper.currentScore, 100)
        keeper.addSegmentCompleted()
        XCTAssertEqual(keeper.currentScore, 200)
    }

    func testMultiplierDoublesPoints() {
        let keeper = ScoreKeeper(userDefaults: .standard)
        keeper.pointsPerSegment = 100
        keeper.multiplier = 2.0
        keeper.addSegmentCompleted()
        XCTAssertEqual(keeper.currentScore, 200)
    }

    func testHighScoreUpdatesWhenCurrentExceeds() {
        let defaults = UserDefaults(suiteName: "ScoreKeeperTests")!
        defaults.removeObject(forKey: ScoreKeeper.highScoreUserDefaultsKey)
        let keeper = ScoreKeeper(userDefaults: defaults)
        keeper.pointsPerSegment = 100
        keeper.addSegmentCompleted()
        XCTAssertEqual(keeper.highScore, 100)
        keeper.addSegmentCompleted()
        XCTAssertEqual(keeper.highScore, 200)
        defaults.removeObject(forKey: ScoreKeeper.highScoreUserDefaultsKey)
    }

    func testResetCurrentRunKeepsHighScore() {
        let defaults = UserDefaults(suiteName: "ScoreKeeperTests")!
        defaults.removeObject(forKey: ScoreKeeper.highScoreUserDefaultsKey)
        let keeper = ScoreKeeper(userDefaults: defaults)
        keeper.pointsPerSegment = 100
        keeper.addSegmentCompleted()
        keeper.addSegmentCompleted()
        let high = keeper.highScore
        keeper.resetCurrentRun()
        XCTAssertEqual(keeper.currentScore, 0)
        XCTAssertEqual(keeper.highScore, high)
        defaults.removeObject(forKey: ScoreKeeper.highScoreUserDefaultsKey)
    }

    // P003 Chunk 2 — "New high score!" celebration: didBeatHighScoreThisRun set when current exceeds high, cleared on reset.
    func testDidBeatHighScoreThisRunSetWhenCurrentExceedsHigh() {
        let defaults = UserDefaults(suiteName: "ScoreKeeperTests")!
        defaults.removeObject(forKey: ScoreKeeper.highScoreUserDefaultsKey)
        let keeper = ScoreKeeper(userDefaults: defaults)
        keeper.pointsPerSegment = 100
        XCTAssertFalse(keeper.didBeatHighScoreThisRun)
        keeper.addSegmentCompleted()
        XCTAssertTrue(keeper.didBeatHighScoreThisRun)
        keeper.addSegmentCompleted()
        XCTAssertTrue(keeper.didBeatHighScoreThisRun)
        keeper.resetCurrentRun()
        XCTAssertFalse(keeper.didBeatHighScoreThisRun)
        defaults.removeObject(forKey: ScoreKeeper.highScoreUserDefaultsKey)
    }

    func testDidBeatHighScoreThisRunNotSetWhenNotExceedingHigh() {
        let defaults = UserDefaults(suiteName: "ScoreKeeperTests")!
        defaults.set(500, forKey: ScoreKeeper.highScoreUserDefaultsKey)
        let keeper = ScoreKeeper(userDefaults: defaults)
        keeper.pointsPerSegment = 100
        keeper.addSegmentCompleted()
        keeper.addSegmentCompleted()
        XCTAssertEqual(keeper.highScore, 500)
        XCTAssertFalse(keeper.didBeatHighScoreThisRun)
        defaults.removeObject(forKey: ScoreKeeper.highScoreUserDefaultsKey)
    }

    func testAddTimeScoreIncrements() {
        let keeper = ScoreKeeper(userDefaults: .standard)
        keeper.addTimeScore(deltaTime: 1.0, pointsPerSecond: 10)
        XCTAssertEqual(keeper.currentScore, 10)
        keeper.addTimeScore(deltaTime: 0.5, pointsPerSecond: 10)
        XCTAssertEqual(keeper.currentScore, 15)
    }
}
