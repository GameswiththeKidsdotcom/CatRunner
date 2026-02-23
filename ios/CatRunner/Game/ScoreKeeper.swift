//
//  ScoreKeeper.swift
//  CatRunner
//
//  C8 — Score by distance (segments) and optional multiplier; persist high score.
//

import Foundation

/// C8 — Tracks current score, high score, and optional multiplier (e.g. speedBoost power-up).
/// Score increases per segment completed; multiplier applied when set.
final class ScoreKeeper {

    static let highScoreUserDefaultsKey = "CatRunnerHighScore"

    /// Points awarded per segment completed (before multiplier).
    var pointsPerSegment: Int = 100

    /// Current run score (before multiplier applied to new points).
    private(set) var currentScore: Int = 0

    /// High score across runs; persisted in UserDefaults.
    private(set) var highScore: Int = 0

    /// Multiplier for new points (e.g. 2.0 during speedBoost). Default 1.0.
    var multiplier: Double = 1.0

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.highScore = userDefaults.integer(forKey: Self.highScoreUserDefaultsKey)
    }

    /// Call when one segment is completed. Adds pointsPerSegment * multiplier to current score and updates high score.
    func addSegmentCompleted() {
        let points = Int(Double(pointsPerSegment) * multiplier)
        currentScore += points
        if currentScore > highScore {
            highScore = currentScore
            userDefaults.set(highScore, forKey: Self.highScoreUserDefaultsKey)
        }
    }

    /// Optional: add time-based points per frame (e.g. 1 point per second). deltaTime in seconds.
    func addTimeScore(deltaTime: TimeInterval, pointsPerSecond: Double = 10) {
        let points = Int(deltaTime * pointsPerSecond * multiplier)
        currentScore += points
        if currentScore > highScore {
            highScore = currentScore
            userDefaults.set(highScore, forKey: Self.highScoreUserDefaultsKey)
        }
    }

    /// Reset current run (e.g. new game); high score unchanged.
    func resetCurrentRun() {
        currentScore = 0
    }
}
