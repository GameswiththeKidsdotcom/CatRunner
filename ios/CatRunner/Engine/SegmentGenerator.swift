//
//  SegmentGenerator.swift
//  CatRunner
//
//  C3 — Procedural segment generator; seeded RNG; same seed + config → identical segment.
//  C4 — Uses ObstacleGenerator for obstacle placements.
//  C5 — Path guarantee: after obstacle generation, ensure ≥1 viable lane per segment.
//

import Foundation
import GameplayKit

/// Generates segments with duration in [config.min, config.max] and obstacles via ObstacleGenerator.
/// Same seed + same config → identical segment layout. C5: path guarantee applied as a post-pass (no extra RNG).
/// C6: optional power-up (max 1 per segment, free lane only) via PowerUpSpawner when powerUpConfig present.
/// P002: optional enemy (e.g. dog) per segment; deterministic from same RNG; visual-only for first slice.
final class SegmentGenerator {

    private let durationConfig: SegmentDurationConfig
    private let obstacleGenerator: ObstacleGenerator
    private let laneCount: Int
    private let powerUpSpawner: PowerUpSpawner?
    /// C8 — Optional difficulty scaler; when nil, no scaling applied.
    private let difficultyScaler: DifficultyScaler?

    /// Initialize with full engine variant config (duration + obstacle config + lane count + optional power-up config).
    init(engineConfig: EngineVariantConfig) {
        self.durationConfig = engineConfig.segmentDurationConfig
        self.laneCount = engineConfig.laneCount
        self.obstacleGenerator = ObstacleGenerator(
            obstacleConfig: engineConfig.obstacleConfig,
            laneCount: engineConfig.laneCount
        )
        self.powerUpSpawner = engineConfig.powerUpConfig.map {
            PowerUpSpawner(powerUpConfig: $0, laneCount: engineConfig.laneCount)
        }
        self.difficultyScaler = engineConfig.difficultyScaling.map { DifficultyScaler(config: $0) }
    }

    /// Legacy init with duration config only; obstacles will be empty (no obstacle config); no power-up spawner; no difficulty scaler.
    init(config: SegmentDurationConfig, obstacleConfig: ObstacleConfig? = nil, laneCount: Int? = nil, powerUpConfig: PowerUpConfig? = nil, difficultyScaling: DifficultyScalingConfig? = nil) {
        self.durationConfig = config
        let lanes = laneCount ?? DesignConstants.defaultLaneCount
        self.laneCount = lanes
        if let obs = obstacleConfig {
            self.obstacleGenerator = ObstacleGenerator(obstacleConfig: obs, laneCount: lanes)
        } else {
            self.obstacleGenerator = ObstacleGenerator(obstacleConfig: ObstacleConfig(types: [], clusterConfig: ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear")), laneCount: lanes)
        }
        self.powerUpSpawner = powerUpConfig.map { PowerUpSpawner(powerUpConfig: $0, laneCount: lanes) }
        self.difficultyScaler = difficultyScaling.map { DifficultyScaler(config: $0) }
    }

    /// Generate one segment. Deterministic: same seed and config always produce the same segment.
    /// C5: path guarantee applied after obstacle generation (pure function of obstacles + laneCount; no extra RNG).
    /// C6: at most one power-up per segment, same RNG used so determinism preserved.
    /// C8: segmentIndex used for difficulty scaling (speed multiplier shortens duration; probability overrides for obstacles).
    /// DifficultySpawnRamp: elapsedTimeAtSegmentStart used to compute spawn rate and target obstacle count when difficultyScaler present.
    func generateSegment(seed: UInt64, segmentIndex: Int = 0, elapsedTimeAtSegmentStart: TimeInterval? = nil) -> Segment {
        let rng = GKMersenneTwisterRandomSource(seed: seed)
        var duration = randomDuration(using: rng)
        var difficultyOverrides: ObstacleGenerator.DifficultyOverrides? = nil
        if let scaler = difficultyScaler {
            let (speedMult, multiLaneBonus, instantFailBonus) = scaler.scaledValues(forSegmentIndex: segmentIndex)
            duration = duration / speedMult
            difficultyOverrides = ObstacleGenerator.DifficultyOverrides(instantFailBonus: instantFailBonus, multiLaneBonus: multiLaneBonus)
        }
        let avgDuration = (durationConfig.minDurationSeconds + durationConfig.maxDurationSeconds) / 2
        let elapsed = elapsedTimeAtSegmentStart ?? Double(segmentIndex) * avgDuration
        let targetObstacleCount: Int? = difficultyScaler.map { scaler in
            let rate = scaler.spawnRate(elapsedSeconds: elapsed)
            let expected = rate * duration
            let cap = max(0, Int(duration * 2))
            return max(0, min(Int(expected.rounded()), cap))
        }
        let obstacles = obstacleGenerator.generate(segmentDuration: duration, rng: rng, difficultyOverrides: difficultyOverrides, targetObstacleCount: targetObstacleCount)
        let guaranteed = PathGuarantee.ensurePathGuarantee(obstacles: obstacles, laneCount: laneCount)
        let segmentBase = Segment(durationSeconds: duration, seed: seed, obstacles: guaranteed)
        let powerUp = powerUpSpawner?.generate(for: segmentBase, rng: rng)
        let enemy = randomEnemyPlacement(duration: duration, laneCount: laneCount, rng: rng)
        return Segment(durationSeconds: duration, seed: seed, obstacles: guaranteed, powerUp: powerUp, enemy: enemy)
    }

    /// P002 — Optional enemy per segment (deterministic from rng). ~35% chance; lane and timeOffset in safe range.
    private func randomEnemyPlacement(duration: TimeInterval, laneCount: Int, rng: GKRandom) -> EnemyPlacement? {
        guard laneCount > 0, rng.nextUniform() < 0.35 else { return nil }
        let laneIndex = rng.nextInt(upperBound: laneCount)
        let t = 0.2 + 0.6 * Double(rng.nextUniform())
        let timeOffset = t * duration
        return EnemyPlacement(laneIndex: laneIndex, typeId: "dog", timeOffset: timeOffset)
    }

    /// Duration in [min, max] from config; deterministic given rng state.
    private func randomDuration(using rng: GKRandom) -> TimeInterval {
        let minS = durationConfig.minDurationSeconds
        let maxS = durationConfig.maxDurationSeconds
        let range = maxS - minS
        let u = Double(rng.nextUniform())
        return minS + range * u
    }
}
