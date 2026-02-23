//
//  Segment.swift
//  CatRunner
//
//  C3 — SegmentGenerator. One procedural segment; duration from config; obstacles deferred to C4.
//

import Foundation

/// A single procedural segment. Same seed + same config → identical segment.
/// C6: may contain at most one power-up (powerUp), placed in a free lane only and not overlapping obstacles.
struct Segment: Equatable {
    /// Duration of this segment in seconds (within config min...max).
    let durationSeconds: TimeInterval
    /// Seed used to generate this segment (for determinism).
    let seed: UInt64
    /// Obstacle placements; C4 will populate. C3 uses empty spread.
    var obstacles: [ObstaclePlacement] { _obstacles }
    private let _obstacles: [ObstaclePlacement]
    /// C6 — At most one power-up per segment; nil if none spawned. Free lane only; never overlaps obstacles.
    let powerUp: PowerUpPlacement?

    init(durationSeconds: TimeInterval, seed: UInt64, obstacles: [ObstaclePlacement] = [], powerUp: PowerUpPlacement? = nil) {
        self.durationSeconds = durationSeconds
        self.seed = seed
        self._obstacles = obstacles
        self.powerUp = powerUp
    }
}

/// Placement of one power-up in a segment (C6): lane index, type id, time offset. Max 1 per segment; free lane only; no overlap with obstacles.
struct PowerUpPlacement: Equatable {
    let laneIndex: Int
    let typeId: String
    let timeOffset: TimeInterval
}

/// Placement of one obstacle in a segment: start lane, span (1–5 lanes), type, time offset.
/// Invariant: startLane in 0..<lanes, laneSpan in 1...5, startLane + laneSpan <= lanes.
struct ObstaclePlacement: Equatable {
    /// First lane index (0-based).
    let startLane: Int
    /// Number of lanes this obstacle spans (1...5).
    let laneSpan: Int
    let typeId: String
    let timeOffset: TimeInterval

    /// Validates startLane and laneSpan against lane count; span must be ≤ 5.
    static func validate(startLane: Int, laneSpan: Int, laneCount: Int) -> Bool {
        guard laneSpan >= 1, laneSpan <= 5 else { return false }
        guard startLane >= 0, startLane < laneCount else { return false }
        return startLane + laneSpan <= laneCount
    }
}
