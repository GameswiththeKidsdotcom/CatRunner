//
//  ObstacleGenerator.swift
//  CatRunner
//
//  C4 — Generates obstacle placements for a segment: spread (default) and optional cluster.
//

import Foundation
import GameplayKit

/// Generates [ObstaclePlacement] for a segment using config and seeded RNG.
/// Ensures span ≤ 5 and startLane + span ≤ lane count.
final class ObstacleGenerator {

    private let obstacleConfig: ObstacleConfig
    private let laneCount: Int
    private let maxSpan = 5

    init(obstacleConfig: ObstacleConfig, laneCount: Int) {
        self.obstacleConfig = obstacleConfig
        self.laneCount = laneCount
    }

    /// Generate obstacle placements for a segment. Deterministic for same seed and config.
    func generate(segmentDuration: TimeInterval, rng: GKRandom) -> [ObstaclePlacement] {
        guard !obstacleConfig.types.isEmpty, segmentDuration > 0 else { return [] }

        let totalCount = numberOfObstacles(segmentDuration: segmentDuration, rng: rng)
        guard totalCount > 0 else { return [] }

        let clusterConfig = obstacleConfig.clusterConfig
        var placements: [ObstaclePlacement] = []

        if clusterConfig.enabled && totalCount >= clusterConfig.minGroupSize {
            let range = clusterConfig.maxGroupSize - clusterConfig.minGroupSize + 1
            let groupSize = clusterConfig.minGroupSize + Int(Double(rng.nextUniform()) * Double(range))
            let groupSizeClamped = min(max(clusterConfig.minGroupSize, groupSize), totalCount, clusterConfig.maxGroupSize)
            let clusterPlacements = generateCluster(
                count: groupSizeClamped,
                segmentDuration: segmentDuration,
                layout: clusterConfig.layout,
                rng: rng
            )
            placements.append(contentsOf: clusterPlacements)
            let remaining = totalCount - groupSizeClamped
            if remaining > 0 {
                let spreadPlacements = generateSpread(
                    count: remaining,
                    segmentDuration: segmentDuration,
                    excludeTimeRange: clusterTimeRange(from: clusterPlacements),
                    rng: rng
                )
                placements.append(contentsOf: spreadPlacements)
            }
        } else {
            placements = generateSpread(count: totalCount, segmentDuration: segmentDuration, excludeTimeRange: nil, rng: rng)
        }

        return placements.sorted { $0.timeOffset < $1.timeOffset }
    }

    // MARK: - Count

    private func numberOfObstacles(segmentDuration: TimeInterval, rng: GKRandom) -> Int {
        // Reasonable range: 0–4 obstacles per segment
        let maxCount = min(5, max(0, Int(segmentDuration * 1.2)))
        guard maxCount > 0 else { return 0 }
        return Int(Double(rng.nextUniform()) * Double(maxCount + 1))
    }

    // MARK: - Spread (even distribution)

    private func generateSpread(
        count: Int,
        segmentDuration: TimeInterval,
        excludeTimeRange: (TimeInterval, TimeInterval)?,
        rng: GKRandom
    ) -> [ObstaclePlacement] {
        var times: [TimeInterval] = []
        let margin = segmentDuration * 0.1
        var attempts = 0
        while times.count < count, attempts < 200 {
            let t = margin + Double(rng.nextUniform()) * (segmentDuration - 2 * margin)
            if t >= 0, t <= segmentDuration {
                if let (lo, hi) = excludeTimeRange, t >= lo, t <= hi { attempts += 1; continue }
                times.append(t)
            }
            attempts += 1
        }
        times.sort()
        return times.compactMap { time in
            makePlacement(timeOffset: time, rng: rng)
        }
    }

    // MARK: - Cluster (group in time; layout linear = same/adjacent lanes, wide = spread lanes)

    private func generateCluster(
        count: Int,
        segmentDuration: TimeInterval,
        layout: String,
        rng: GKRandom
    ) -> [ObstaclePlacement] {
        let centerTime = segmentDuration * (0.3 + Double(rng.nextUniform()) * 0.4)
        let timeSpread = segmentDuration * 0.15
        let baseLane = laneCount > 0 ? Int(Double(rng.nextUniform()) * Double(laneCount)) : 0
        var placements: [ObstaclePlacement] = []
        for i in 0..<count {
            let t = centerTime + (Double(rng.nextUniform()) - 0.5) * timeSpread
            let timeOffset = max(0, min(segmentDuration, t))
            guard let p = makePlacement(timeOffset: timeOffset, rng: rng, layout: layout, indexInGroup: i, groupSize: count, clusterBaseLane: baseLane) else { continue }
            placements.append(p)
        }
        return placements
    }

    private func clusterTimeRange(from placements: [ObstaclePlacement]) -> (TimeInterval, TimeInterval)? {
        guard let minT = placements.map(\.timeOffset).min(),
              let maxT = placements.map(\.timeOffset).max() else { return nil }
        return (minT, maxT)
    }

    // MARK: - Single placement (span ≤ 5, startLane + span ≤ laneCount)

    private func makePlacement(
        timeOffset: TimeInterval,
        rng: GKRandom,
        layout: String? = nil,
        indexInGroup: Int = 0,
        groupSize: Int = 1,
        clusterBaseLane: Int? = nil
    ) -> ObstaclePlacement? {
        let typeIndex = min(Int(Double(rng.nextUniform()) * Double(obstacleConfig.types.count)), obstacleConfig.types.count - 1)
        let typeConfig = obstacleConfig.types[typeIndex]
        let span = typeConfig.laneSpanMin + Int(Double(rng.nextUniform()) * Double(typeConfig.laneSpanMax - typeConfig.laneSpanMin + 1))
        let spanClamped = min(max(1, span), maxSpan, laneCount)

        let startLane: Int
        if let layout = layout, groupSize > 1, let base = clusterBaseLane {
            if layout == "linear" {
                // Same or adjacent lanes: offset from base by -1, 0, or +1 so startLane + span <= laneCount
                let offset = (indexInGroup % 3) - 1
                let start = base + offset
                startLane = max(0, min(start, laneCount - spanClamped))
            } else {
                // wide: spread across lanes
                let maxStart = laneCount - spanClamped
                startLane = maxStart > 0 ? Int(Double(rng.nextUniform()) * Double(maxStart + 1)) : 0
            }
        } else {
            let maxStart = laneCount - spanClamped
            startLane = maxStart >= 0 ? Int(Double(rng.nextUniform()) * Double(maxStart + 1)) : 0
        }

        guard ObstaclePlacement.validate(startLane: startLane, laneSpan: spanClamped, laneCount: laneCount) else { return nil }
        return ObstaclePlacement(
            startLane: startLane,
            laneSpan: spanClamped,
            typeId: typeConfig.id,
            timeOffset: timeOffset
        )
    }
}
