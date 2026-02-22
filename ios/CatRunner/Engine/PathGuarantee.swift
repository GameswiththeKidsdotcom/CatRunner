//
//  PathGuarantee.swift
//  CatRunner
//
//  C5 — Path guarantee: ≥1 viable lane per segment. Blocked = instantFail or full-span.
//  A future VariantConfig option (e.g. engine.pathGuarantee: false or obstacles.forcedHazard: true)
//  could disable this guarantee so segments may have zero viable lanes; out of scope for default.
//

import Foundation

/// C5 — Path guarantee: compute blocked lanes and ensure ≥1 viable lane per segment.
/// Blocking: a lane is blocked if covered by an obstacle whose typeId is in blockingTypeIds
/// (default "instantFail"), or by any obstacle that spans all lanes (laneSpan == laneCount).
enum PathGuarantee {

    /// Default type IDs that block a lane (player cannot use that lane).
    static let defaultBlockingTypeIds: Set<String> = ["instantFail"]

    /// Compute the set of lane indices that are blocked (non-viable).
    /// - Parameters:
    ///   - obstacles: Placements for the segment.
    ///   - laneCount: Total number of lanes.
    ///   - blockingTypeIds: Type IDs that block lanes (default: instantFail). Optional; if nil, uses defaultBlockingTypeIds.
    /// - Returns: Set of lane indices that are blocked.
    static func blockedLanes(
        obstacles: [ObstaclePlacement],
        laneCount: Int,
        blockingTypeIds: Set<String>? = nil
    ) -> Set<Int> {
        let blocking = blockingTypeIds ?? defaultBlockingTypeIds
        var blocked: Set<Int> = []
        for p in obstacles {
            let blocks: Bool
            if p.laneSpan == laneCount {
                blocks = true
            } else {
                blocks = blocking.contains(p.typeId)
            }
            if blocks {
                for lane in p.startLane..<(p.startLane + p.laneSpan) {
                    blocked.insert(lane)
                }
            }
        }
        return blocked
    }

    /// Returns true iff there is at least one lane that is not blocked.
    static func hasAtLeastOneViableLane(
        obstacles: [ObstaclePlacement],
        laneCount: Int,
        blockingTypeIds: Set<String>? = nil
    ) -> Bool {
        let blocked = blockedLanes(obstacles: obstacles, laneCount: laneCount, blockingTypeIds: blockingTypeIds)
        return blocked.count < laneCount
    }

    /// Canonical order for obstacles (deterministic): timeOffset, then startLane, then laneSpan.
    private static func isBlocking(_ p: ObstaclePlacement, laneCount: Int, blockingTypeIds: Set<String>) -> Bool {
        if p.laneSpan == laneCount { return true }
        return blockingTypeIds.contains(p.typeId)
    }

    /// Returns a (possibly modified) list of placements such that ≥1 lane remains viable.
    /// If all lanes are blocked, deterministically removes blocking obstacles one at a time
    /// (first by canonical order: timeOffset, startLane, laneSpan) until at least one lane is free.
    /// Same input → same output (no RNG).
    static func ensurePathGuarantee(
        obstacles: [ObstaclePlacement],
        laneCount: Int,
        blockingTypeIds: Set<String>? = nil
    ) -> [ObstaclePlacement] {
        let blocking = blockingTypeIds ?? defaultBlockingTypeIds
        var placements = obstacles
        while !hasAtLeastOneViableLane(obstacles: placements, laneCount: laneCount, blockingTypeIds: blocking) {
            let canonicalOrder: (ObstaclePlacement) -> (TimeInterval, Int, Int) = { p in (p.timeOffset, p.startLane, p.laneSpan) }
            let blockingIndices = placements.enumerated().filter { isBlocking($0.element, laneCount: laneCount, blockingTypeIds: blocking) }
            guard let first = blockingIndices.min(by: { canonicalOrder($0.element) < canonicalOrder($1.element) }) else { break }
            placements.remove(at: first.offset)
        }
        return placements
    }
}
