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
final class SegmentGenerator {

    private let durationConfig: SegmentDurationConfig
    private let obstacleGenerator: ObstacleGenerator
    private let laneCount: Int

    /// Initialize with full engine variant config (duration + obstacle config + lane count).
    init(engineConfig: EngineVariantConfig) {
        self.durationConfig = engineConfig.segmentDurationConfig
        self.laneCount = engineConfig.laneCount
        self.obstacleGenerator = ObstacleGenerator(
            obstacleConfig: engineConfig.obstacleConfig,
            laneCount: engineConfig.laneCount
        )
    }

    /// Legacy init with duration config only; obstacles will be empty (no obstacle config).
    init(config: SegmentDurationConfig, obstacleConfig: ObstacleConfig? = nil, laneCount: Int? = nil) {
        self.durationConfig = config
        let lanes = laneCount ?? 5
        self.laneCount = lanes
        if let obs = obstacleConfig {
            self.obstacleGenerator = ObstacleGenerator(obstacleConfig: obs, laneCount: lanes)
        } else {
            self.obstacleGenerator = ObstacleGenerator(obstacleConfig: ObstacleConfig(types: [], clusterConfig: ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear")), laneCount: lanes)
        }
    }

    /// Generate one segment. Deterministic: same seed and config always produce the same segment.
    /// C5: path guarantee applied after obstacle generation (pure function of obstacles + laneCount; no extra RNG).
    func generateSegment(seed: UInt64) -> Segment {
        let rng = GKMersenneTwisterRandomSource(seed: seed)
        let duration = randomDuration(using: rng)
        let obstacles = obstacleGenerator.generate(segmentDuration: duration, rng: rng)
        let guaranteed = PathGuarantee.ensurePathGuarantee(obstacles: obstacles, laneCount: laneCount)
        return Segment(durationSeconds: duration, seed: seed, obstacles: guaranteed)
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
