//
//  PowerUpSpawner.swift
//  CatRunner
//
//  C6 — Power-up spawner: max 1 per segment, free lane only, never overlaps obstacles.
//  Spawn placement only; collection/expiration handled by game layer.
//

import Foundation
import GameplayKit

/// C6 — Spawns at most one power-up per segment. Placement rule: freeLaneOnly; power-up time does not overlap any obstacle in that lane.
/// Deterministic: same segment + same RNG state → same placement or nil.
final class PowerUpSpawner {

    private let config: PowerUpConfig
    private let laneCount: Int

    /// Time window (seconds) around an obstacle's timeOffset; power-up will not be placed within this to avoid overlap.
    private static var obstacleTimeEpsilon: TimeInterval { DesignConstants.timeEpsilon }

    init(powerUpConfig: PowerUpConfig, laneCount: Int) {
        self.config = powerUpConfig
        self.laneCount = laneCount
    }

    /// Generate at most one power-up for the segment. Returns nil if spawn roll fails, no free lane, or no valid time.
    /// Uses the same RNG as segment generation so same seed → same segment including power-up.
    func generate(for segment: Segment, rng: GKRandom) -> PowerUpPlacement? {
        guard config.maxActive >= 1, !config.types.isEmpty else { return nil }
        if Double(rng.nextUniform()) >= config.spawnProbability { return nil }

        let blocked = PathGuarantee.blockedLanes(obstacles: segment.obstacles, laneCount: laneCount)
        let freeLanes = (0..<laneCount).filter { !blocked.contains($0) }
        guard !freeLanes.isEmpty else { return nil }

        let laneIndex: Int
        if freeLanes.count == 1 {
            laneIndex = freeLanes[0]
        } else {
            let idx = min(Int(Double(rng.nextUniform()) * Double(freeLanes.count)), freeLanes.count - 1)
            laneIndex = freeLanes[idx]
        }

        let obstaclesInLane = segment.obstacles.filter { laneIndex >= $0.startLane && laneIndex < $0.startLane + $0.laneSpan }
        guard let timeOffset = pickTimeOffset(
            duration: segment.durationSeconds,
            obstaclesInLane: obstaclesInLane,
            rng: rng
        ) else { return nil }

        let typeIndex = min(Int(Double(rng.nextUniform()) * Double(config.types.count)), config.types.count - 1)
        let typeId = config.types[typeIndex]

        return PowerUpPlacement(laneIndex: laneIndex, typeId: typeId, timeOffset: timeOffset)
    }

    /// Pick a time in [margin, duration - margin] that is not within epsilon of any obstacle in the lane.
    private func pickTimeOffset(
        duration: TimeInterval,
        obstaclesInLane: [ObstaclePlacement],
        rng: GKRandom
    ) -> TimeInterval? {
        let margin = duration * DesignConstants.segmentTimeMarginFraction
        let low = margin
        let high = duration - margin
        guard high > low else { return nil }

        let eps = Self.obstacleTimeEpsilon
        let forbidden = Set(obstaclesInLane.map(\.timeOffset))

        // Build allowed intervals: [low, high] minus (t - eps, t + eps) for each t in forbidden.
        var intervals: [(start: TimeInterval, end: TimeInterval)] = []
        var cursor = low
        for t in forbidden.sorted() {
            let windowStart = t - eps
            let windowEnd = t + eps
            if cursor < windowStart {
                intervals.append((cursor, min(windowStart, high)))
            }
            if windowEnd > cursor { cursor = max(cursor, windowEnd) }
            if cursor >= high { break }
        }
        if cursor < high {
            intervals.append((cursor, high))
        }

        let totalLength = intervals.reduce(0.0) { $0 + ($1.end - $1.start) }
        guard totalLength > 0 else { return nil }

        let u = Double(rng.nextUniform())
        let position = u * totalLength
        var acc = 0.0
        for interval in intervals {
            let len = interval.end - interval.start
            if position < acc + len {
                let v = (position - acc) / len
                return interval.start + v * len
            }
            acc += len
        }
        return intervals.last.map { $0.start }
    }
}
