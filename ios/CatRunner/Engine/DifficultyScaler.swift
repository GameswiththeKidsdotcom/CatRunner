//
//  DifficultyScaler.swift
//  CatRunner
//
//  C8 — Difficulty scaling: speed multiplier and probability bonuses per segment index.
//

import Foundation

/// C8 — Given segment index and config, returns scaled speed multiplier and probability bonuses.
/// Steps advance every `segmentsPerStep` segments; each step adds one increment.
struct DifficultyScaler {

    private let config: DifficultyScalingConfig

    init(config: DifficultyScalingConfig) {
        self.config = config
    }

    /// Step index (0, 1, 2, …) based on segment index; advances every segmentsPerStep segments.
    func step(forSegmentIndex segmentIndex: Int) -> Int {
        guard config.segmentsPerStep > 0 else { return 0 }
        return max(0, segmentIndex) / config.segmentsPerStep
    }

    /// Speed multiplier (≥ 1). Base 1 + step * speedIncrementPerSegment.
    func speedMultiplier(forSegmentIndex segmentIndex: Int) -> Double {
        let s = step(forSegmentIndex: segmentIndex)
        return 1.0 + Double(s) * config.speedIncrementPerSegment
    }

    /// Multi-lane probability bonus (≥ 0). Step * multiLaneProbabilityIncrement.
    func multiLaneProbabilityBonus(forSegmentIndex segmentIndex: Int) -> Double {
        let s = step(forSegmentIndex: segmentIndex)
        return Double(s) * config.multiLaneProbabilityIncrement
    }

    /// Instant-fail probability bonus (≥ 0). Step * instantFailProbabilityIncrement.
    func instantFailProbabilityBonus(forSegmentIndex segmentIndex: Int) -> Double {
        let s = step(forSegmentIndex: segmentIndex)
        return Double(s) * config.instantFailProbabilityIncrement
    }

    /// All scaled values for a segment index. Used by SegmentGenerator / game loop.
    func scaledValues(forSegmentIndex segmentIndex: Int) -> (speedMultiplier: Double, multiLaneBonus: Double, instantFailBonus: Double) {
        (
            speedMultiplier(forSegmentIndex: segmentIndex),
            multiLaneProbabilityBonus(forSegmentIndex: segmentIndex),
            instantFailProbabilityBonus(forSegmentIndex: segmentIndex)
        )
    }

    /// DifficultySpawnRamp — Spawn rate (obstacles per second) at given elapsed game time.
    /// rate = 1/initialSpawnIntervalSeconds + (elapsedSeconds/5) * spawnRateIncrementPerFiveSeconds, clamped to ≥ 0.
    func spawnRate(elapsedSeconds: TimeInterval) -> Double {
        let rate = (1.0 / config.initialSpawnIntervalSeconds) + (elapsedSeconds / 5.0) * config.spawnRateIncrementPerFiveSeconds
        return max(0, rate)
    }
}
