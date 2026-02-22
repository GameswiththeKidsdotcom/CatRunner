//
//  EngineVariantConfig.swift
//  CatRunner
//
//  C4 — Load variant.json once; provides segment duration, obstacle config, and lane count.
//

import Foundation

/// Full engine config from one variant.json load: duration range, obstacle config, lane count.
struct EngineVariantConfig {
    let segmentDurationConfig: SegmentDurationConfig
    let obstacleConfig: ObstacleConfig
    let laneCount: Int

    init(segmentDurationConfig: SegmentDurationConfig, obstacleConfig: ObstacleConfig, laneCount: Int) {
        self.segmentDurationConfig = segmentDurationConfig
        self.obstacleConfig = obstacleConfig
        self.laneCount = laneCount
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
        return EngineVariantConfig(
            segmentDurationConfig: durationConfig,
            obstacleConfig: obstacleConfig,
            laneCount: laneCount
        )
    }
}

// MARK: - Full variant decoding (engine + obstacles)

private struct FullVariantConfigRoot: Decodable {
    let engine: FullEngineBranch
    let obstacles: FullObstaclesBranch
}

private struct FullEngineBranch: Decodable {
    let lanes: Int
    let segmentDurationSeconds: SegmentDurationSeconds
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
