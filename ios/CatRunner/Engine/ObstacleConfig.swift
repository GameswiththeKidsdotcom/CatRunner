//
//  ObstacleConfig.swift
//  CatRunner
//
//  C4 — Obstacle types and cluster config decoded from variant.json.
//

import Foundation

/// One obstacle type from config: id (passable|instantFail|slowdown), laneSpan [min, max].
struct ObstacleTypeConfig: Equatable {
    let id: String
    let laneSpanMin: Int
    let laneSpanMax: Int

    init(id: String, laneSpanMin: Int, laneSpanMax: Int) {
        self.id = id
        self.laneSpanMin = laneSpanMin
        self.laneSpanMax = laneSpanMax
    }
}

/// Cluster placement config: enabled, group size range, layout (linear|wide).
struct ClusterConfig: Equatable {
    let enabled: Bool
    let minGroupSize: Int
    let maxGroupSize: Int
    let layout: String // "linear" | "wide"

    init(enabled: Bool, minGroupSize: Int, maxGroupSize: Int, layout: String) {
        self.enabled = enabled
        self.minGroupSize = minGroupSize
        self.maxGroupSize = maxGroupSize
        self.layout = layout
    }
}

/// Full obstacle config: types array and clusterConfig.
struct ObstacleConfig: Equatable {
    let types: [ObstacleTypeConfig]
    let clusterConfig: ClusterConfig

    init(types: [ObstacleTypeConfig], clusterConfig: ClusterConfig) {
        self.types = types
        self.clusterConfig = clusterConfig
    }

    /// Decode from variant.json structure: obstacles.types, obstacles.clusterConfig.
    static func decode(from data: Data) throws -> ObstacleConfig {
        let root = try JSONDecoder().decode(ObstacleVariantRoot.self, from: data)
        return root.obstacles.toObstacleConfig()
    }

    /// Load from bundle (same variant.json as segment config).
    static func load(fromBundle bundle: Bundle = .main, filename: String = "variant") throws -> ObstacleConfig {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            throw SegmentConfigError.missingFile
        }
        let data = try Data(contentsOf: url)
        return try decode(from: data)
    }
}

// MARK: - Decoding (variant.json obstacles branch)

private struct ObstacleVariantRoot: Decodable {
    let obstacles: ObstaclesBranch
}

private struct ObstaclesBranch: Decodable {
    let types: [ObstacleTypeBranch]
    let clusterConfig: ClusterConfigBranch
}

private struct ObstacleTypeBranch: Decodable {
    let id: String
    let laneSpan: [Int]
}

private struct ClusterConfigBranch: Decodable {
    let enabled: Bool
    let minGroupSize: Int
    let maxGroupSize: Int
    let layout: String
}

extension ObstaclesBranch {
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
