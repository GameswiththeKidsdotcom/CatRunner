//
//  EngineVariantConfig.swift
//  CatRunner
//
//  C4 — Load variant.json once; provides segment duration, obstacle config, and lane count.
//

import Foundation

/// Power-up config from variant.json powerUps branch (C6).
struct PowerUpConfig: Equatable {
    let types: [String]
    let maxActive: Int
    let spawnProbability: Double
    let placementRule: String

    init(types: [String], maxActive: Int, spawnProbability: Double, placementRule: String) {
        self.types = types
        self.maxActive = maxActive
        self.spawnProbability = spawnProbability
        self.placementRule = placementRule
    }
}

/// C8 — Difficulty scaling config from variant.json difficultyScaling.
struct DifficultyScalingConfig: Equatable {
    let speedIncrementPerSegment: Double
    let multiLaneProbabilityIncrement: Double
    let instantFailProbabilityIncrement: Double
    let segmentsPerStep: Int
}

/// C8 — Monetization config (revive IAP / rewarded ad); optional for stub.
struct MonetizationConfig: Equatable {
    let reviveIAPProductId: String?
    let rewardedAdPlacementId: String?
}

/// Full engine config from one variant.json load: duration range, obstacle config, lane count, power-up config (C6).
/// C7: jump/slide durations and player start lane for jump/slide and collision mechanics.
/// C8: difficultyScaling and monetization for revive.
struct EngineVariantConfig {
    let segmentDurationConfig: SegmentDurationConfig
    let obstacleConfig: ObstacleConfig
    let laneCount: Int
    let powerUpConfig: PowerUpConfig?
    /// C7 — Jump duration in seconds (e.g. 0.4). Used for jump animation and collision (high obstacles).
    let jumpDurationSeconds: TimeInterval
    /// C7 — Slide duration in seconds (e.g. 0.5). Used for slide animation and collision (low obstacles).
    let slideDurationSeconds: TimeInterval
    /// C7 — Lane index (0..<laneCount) where player starts; e.g. 2 for center.
    let playerStartLane: Int
    /// C8 — Difficulty scaling; nil = no scaling.
    let difficultyScaling: DifficultyScalingConfig?
    /// C8 — Monetization (revive IAP / ad); nil = use stub.
    let monetization: MonetizationConfig?

    init(
        segmentDurationConfig: SegmentDurationConfig,
        obstacleConfig: ObstacleConfig,
        laneCount: Int,
        powerUpConfig: PowerUpConfig? = nil,
        jumpDurationSeconds: TimeInterval = 0.4,
        slideDurationSeconds: TimeInterval = 0.5,
        playerStartLane: Int = 2,
        difficultyScaling: DifficultyScalingConfig? = nil,
        monetization: MonetizationConfig? = nil
    ) {
        self.segmentDurationConfig = segmentDurationConfig
        self.obstacleConfig = obstacleConfig
        self.laneCount = laneCount
        self.powerUpConfig = powerUpConfig
        self.jumpDurationSeconds = jumpDurationSeconds
        self.slideDurationSeconds = slideDurationSeconds
        self.playerStartLane = min(max(0, playerStartLane), max(0, laneCount - 1))
        self.difficultyScaling = difficultyScaling
        self.monetization = monetization
    }

    /// Load from bundle; parses variant.json once and fills duration, obstacles, and engine.lanes.
    static func load(fromBundle bundle: Bundle = .main, filename: String = "variant") throws -> EngineVariantConfig {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            throw SegmentConfigError.missingFile
        }
        let data = try Data(contentsOf: url)
        return try decode(from: data)
    }

    static func decode(from data: Data) throws -> EngineVariantConfig {
        let root = try JSONDecoder().decode(FullVariantConfigRoot.self, from: data)
        let durationConfig = SegmentDurationConfig(
            minDurationSeconds: root.engine.segmentDurationSeconds.min,
            maxDurationSeconds: root.engine.segmentDurationSeconds.max
        )
        let obstacleConfig = root.obstacles.toObstacleConfig()
        let laneCount = root.engine.lanes
        let powerUpConfig = root.powerUps.map { PowerUpConfig(types: $0.types, maxActive: $0.maxActive, spawnProbability: $0.spawnProbability, placementRule: $0.placementRule) }
        let difficultyScaling = root.difficultyScaling.map {
            DifficultyScalingConfig(
                speedIncrementPerSegment: $0.speedIncrementPerSegment,
                multiLaneProbabilityIncrement: $0.multiLaneProbabilityIncrement,
                instantFailProbabilityIncrement: $0.instantFailProbabilityIncrement,
                segmentsPerStep: max(1, $0.segmentsPerStep)
            )
        }
        let monetization = root.monetization.map {
            MonetizationConfig(
                reviveIAPProductId: $0.reviveIAPProductId,
                rewardedAdPlacementId: $0.rewardedAdPlacementId
            )
        }
        return EngineVariantConfig(
            segmentDurationConfig: durationConfig,
            obstacleConfig: obstacleConfig,
            laneCount: laneCount,
            powerUpConfig: powerUpConfig,
            jumpDurationSeconds: root.engine.jumpDurationSeconds ?? 0.4,
            slideDurationSeconds: root.engine.slideDurationSeconds ?? 0.5,
            playerStartLane: root.engine.playerStartLane ?? 2,
            difficultyScaling: difficultyScaling,
            monetization: monetization
        )
    }
}

// MARK: - Full variant decoding (engine + obstacles)

private struct FullVariantConfigRoot: Decodable {
    let engine: FullEngineBranch
    let obstacles: FullObstaclesBranch
    let powerUps: FullPowerUpsBranch?
    let difficultyScaling: FullDifficultyScalingBranch?
    let monetization: FullMonetizationBranch?
}

private struct FullDifficultyScalingBranch: Decodable {
    let speedIncrementPerSegment: Double
    let multiLaneProbabilityIncrement: Double
    let instantFailProbabilityIncrement: Double
    let segmentsPerStep: Int
}

private struct FullMonetizationBranch: Decodable {
    let reviveIAPProductId: String?
    let rewardedAdPlacementId: String?
}

private struct FullPowerUpsBranch: Decodable {
    let types: [String]
    let maxActive: Int
    let spawnProbability: Double
    let placementRule: String
}

private struct FullEngineBranch: Decodable {
    let lanes: Int
    let segmentDurationSeconds: SegmentDurationSeconds
    /// C7 — Optional for backwards compatibility; default 0.4 when missing.
    let jumpDurationSeconds: TimeInterval?
    /// C7 — Optional for backwards compatibility; default 0.5 when missing.
    let slideDurationSeconds: TimeInterval?
    /// C7 — Optional for backwards compatibility; default 2 (center) when missing.
    let playerStartLane: Int?

    enum CodingKeys: String, CodingKey {
        case lanes
        case segmentDurationSeconds
        case jumpDurationSeconds
        case slideDurationSeconds
        case playerStartLane
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        lanes = try c.decode(Int.self, forKey: .lanes)
        segmentDurationSeconds = try c.decode(SegmentDurationSeconds.self, forKey: .segmentDurationSeconds)
        jumpDurationSeconds = try c.decodeIfPresent(TimeInterval.self, forKey: .jumpDurationSeconds)
        slideDurationSeconds = try c.decodeIfPresent(TimeInterval.self, forKey: .slideDurationSeconds)
        playerStartLane = try c.decodeIfPresent(Int.self, forKey: .playerStartLane)
    }
}

private struct SegmentDurationSeconds: Decodable {
    let min: TimeInterval
    let max: TimeInterval
}

private struct FullObstaclesBranch: Decodable {
    let types: [FullObstacleTypeBranch]
    let clusterConfig: FullClusterConfigBranch
}

private struct FullObstacleTypeBranch: Decodable {
    let id: String
    let laneSpan: [Int]
}

private struct FullClusterConfigBranch: Decodable {
    let enabled: Bool
    let minGroupSize: Int
    let maxGroupSize: Int
    let layout: String
}

extension FullObstaclesBranch {
    func toObstacleConfig() -> ObstacleConfig {
        let typeConfigs = types.map { t in
            ObstacleTypeConfig(
                id: t.id,
                laneSpanMin: t.laneSpan[0],
                laneSpanMax: t.laneSpan[1]
            )
        }
        let cluster = ClusterConfig(
            enabled: clusterConfig.enabled,
            minGroupSize: clusterConfig.minGroupSize,
            maxGroupSize: clusterConfig.maxGroupSize,
            layout: clusterConfig.layout
        )
        return ObstacleConfig(types: typeConfigs, clusterConfig: cluster)
    }
}
