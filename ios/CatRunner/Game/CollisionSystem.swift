//
//  CollisionSystem.swift
//  CatRunner
//
//  C7 — Collision detection: player vs obstacle (by type: passable / instantFail / slowdown) and vs power-up.
//  High/low rule: instantFail = high (must slide under); passable/slowdown = low (must jump over).
//  Instant-fail triggers delegate/flag for C8 (revive flow not implemented in C7).
//

import Foundation

/// Result of checking one obstacle: hit or miss, and effect type if hit.
enum ObstacleHitResult: Equatable {
    case miss
    case hitPassable
    case hitSlowdown
    case hitInstantFail
}

/// Result of a collision check for one frame: obstacle hit (if any) and power-up collected (if any).
struct CollisionResult: Equatable {
    var obstacleHit: ObstacleHitResult = .miss
    var powerUpCollected: PowerUpPlacement? = nil
}

/// C7 — Collision system: given player state, segment-relative time, segment obstacles and power-up,
/// returns obstacle hit (passable / slowdown / instant-fail) and power-up collected.
/// Rule: obstacle covers player lane if player lane in [startLane, startLane+laneSpan).
/// Time overlap: |T - timeOffset| < epsilon. instantFail = high (slide to avoid); passable/slowdown = low (jump to avoid).
struct CollisionSystem {

    /// Time window (seconds) to consider player and obstacle/power-up overlapping.
    static let timeEpsilon: TimeInterval = 0.2

    /// Check collision for current frame. Returns obstacle hit type and power-up collected (if any).
    static func check(
        playerLane: Int,
        isJumping: Bool,
        isSliding: Bool,
        segmentTime: TimeInterval,
        obstacles: [ObstaclePlacement],
        powerUp: PowerUpPlacement?,
        laneCount: Int
    ) -> CollisionResult {
        var result = CollisionResult()
        for obs in obstacles {
            let hit = checkObstacle(
                obstacle: obs,
                playerLane: playerLane,
                isJumping: isJumping,
                isSliding: isSliding,
                segmentTime: segmentTime,
                laneCount: laneCount
            )
            switch hit {
            case .miss:
                break
            case .hitPassable:
                result.obstacleHit = .hitPassable
                return result
            case .hitSlowdown:
                result.obstacleHit = .hitSlowdown
                return result
            case .hitInstantFail:
                result.obstacleHit = .hitInstantFail
                return result
            }
        }
        if let pu = powerUp, checkPowerUp(powerUp: pu, playerLane: playerLane, segmentTime: segmentTime) {
            result.powerUpCollected = pu
        }
        return result
    }

    /// Obstacle covers player lane if playerLane in [startLane, startLane + laneSpan).
    private static func obstacleCoversLane(_ obs: ObstaclePlacement, playerLane: Int) -> Bool {
        guard playerLane >= obs.startLane else { return false }
        return playerLane < obs.startLane + obs.laneSpan
    }

    private static func timeOverlap(_ t: TimeInterval, offset: TimeInterval) -> Bool {
        abs(t - offset) < timeEpsilon
    }

    /// High obstacle (instantFail): must be sliding to avoid. Low (passable/slowdown): must be jumping to avoid.
    private static func checkObstacle(
        obstacle: ObstaclePlacement,
        playerLane: Int,
        isJumping: Bool,
        isSliding: Bool,
        segmentTime: TimeInterval,
        laneCount: Int
    ) -> ObstacleHitResult {
        guard obstacleCoversLane(obstacle, playerLane: playerLane),
              timeOverlap(segmentTime, offset: obstacle.timeOffset) else {
            return .miss
        }
        switch obstacle.typeId {
        case "instantFail":
            // High: hit if not sliding
            return isSliding ? .miss : .hitInstantFail
        case "passable":
            // Low: hit if not jumping (no death, just pass through)
            return isJumping ? .miss : .hitPassable
        case "slowdown":
            // Low: hit if not jumping → apply slowdown
            return isJumping ? .miss : .hitSlowdown
        default:
            // Unknown type: treat as low (jump to avoid)
            return isJumping ? .miss : .hitPassable
        }
    }

    private static func checkPowerUp(powerUp: PowerUpPlacement, playerLane: Int, segmentTime: TimeInterval) -> Bool {
        guard powerUp.laneIndex == playerLane else { return false }
        return timeOverlap(segmentTime, offset: powerUp.timeOffset)
    }
}
