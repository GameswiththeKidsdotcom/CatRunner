//
//  SegmentDurationConfig.swift
//  CatRunner
//
//  C3 — Load segment duration range from variant.json (engine.segmentDurationSeconds).
//

import Foundation

/// Segment duration range from VariantConfig. Load from variant.json for deterministic segment length.
struct SegmentDurationConfig {
    let minDurationSeconds: TimeInterval
    let maxDurationSeconds: TimeInterval

    init(minDurationSeconds: TimeInterval, maxDurationSeconds: TimeInterval) {
        self.minDurationSeconds = minDurationSeconds
        self.maxDurationSeconds = maxDurationSeconds
    }

    /// Decode from variant.json structure: { "engine": { "segmentDurationSeconds": { "min": 2, "max": 3 } } }
    static func decode(from data: Data) throws -> SegmentDurationConfig {
        let root = try JSONDecoder().decode(VariantConfigRoot.self, from: data)
        return SegmentDurationConfig(
            minDurationSeconds: root.engine.segmentDurationSeconds.min,
            maxDurationSeconds: root.engine.segmentDurationSeconds.max
        )
    }

    /// Load from bundle (e.g. variant.json copied into app bundle).
    static func load(fromBundle bundle: Bundle = .main, filename: String = "variant") throws -> SegmentDurationConfig {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            throw SegmentConfigError.missingFile
        }
        let data = try Data(contentsOf: url)
        return try decode(from: data)
    }
}

private struct VariantConfigRoot: Decodable {
    let engine: EngineConfig
}

private struct EngineConfig: Decodable {
    let segmentDurationSeconds: SegmentDurationSeconds
}

private struct SegmentDurationSeconds: Decodable {
    let min: TimeInterval
    let max: TimeInterval
}

enum SegmentConfigError: Error {
    case missingFile
}
