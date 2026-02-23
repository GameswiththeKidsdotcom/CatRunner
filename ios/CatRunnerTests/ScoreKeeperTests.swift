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

    func testAddTimeScoreIncrements() {
        let keeper = ScoreKeeper(userDefaults: .standard)
        keeper.addTimeScore(deltaTime: 1.0, pointsPerSecond: 10)
        XCTAssertEqual(keeper.currentScore, 10)
        keeper.addTimeScore(deltaTime: 0.5, pointsPerSecond: 10)
        XCTAssertEqual(keeper.currentScore, 15)
    }
}
