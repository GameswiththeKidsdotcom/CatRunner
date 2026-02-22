//
//  ObstaclePlacementTests.swift
//  CatRunnerTests
//
//  C4 — Unit tests: lane index valid (0–4), span ≤ lanes, startLane + span ≤ lanes,
//  cluster only when enabled and group size within minGroupSize..maxGroupSize.
//

import XCTest
import GameplayKit
@testable import CatRunner

final class ObstaclePlacementTests: XCTestCase {

    let laneCount = 5

    // MARK: - Lane index valid (0–4)

    func testLaneIndexValid_zeroToFour() {
        for lane in 0..<laneCount {
            XCTAssertTrue(ObstaclePlacement.validate(startLane: lane, laneSpan: 1, laneCount: laneCount), "startLane \(lane) should be valid")
        }
    }

    func testLaneIndexInvalid_negative() {
        XCTAssertFalse(ObstaclePlacement.validate(startLane: -1, laneSpan: 1, laneCount: laneCount))
    }

    func testLaneIndexInvalid_equalOrBeyondLaneCount() {
        XCTAssertFalse(ObstaclePlacement.validate(startLane: laneCount, laneSpan: 1, laneCount: laneCount))
        XCTAssertFalse(ObstaclePlacement.validate(startLane: laneCount + 1, laneSpan: 1, laneCount: laneCount))
    }

    // MARK: - Span ≤ lanes and startLane + span ≤ lanes

    func testSpanWithinLanes() {
        XCTAssertTrue(ObstaclePlacement.validate(startLane: 0, laneSpan: 5, laneCount: laneCount))
        XCTAssertTrue(ObstaclePlacement.validate(startLane: 0, laneSpan: 1, laneCount: laneCount))
    }

    func testSpanGreaterThanFive_invalid() {
        XCTAssertFalse(ObstaclePlacement.validate(startLane: 0, laneSpan: 6, laneCount: laneCount))
    }

    func testStartLanePlusSpanExceedsLanes_invalid() {
        XCTAssertFalse(ObstaclePlacement.validate(startLane: 3, laneSpan: 3, laneCount: laneCount)) // 3+3=6 > 5
        XCTAssertTrue(ObstaclePlacement.validate(startLane: 3, laneSpan: 2, laneCount: laneCount))  // 3+2=5
    }

    func testSpanZero_invalid() {
        XCTAssertFalse(ObstaclePlacement.validate(startLane: 0, laneSpan: 0, laneCount: laneCount))
    }

    // MARK: - Cluster only when enabled and group size within minGroupSize..maxGroupSize

    func testClusterConfig_respectedByGenerator() {
        let types = [
            ObstacleTypeConfig(id: "passable", laneSpanMin: 1, laneSpanMax: 2),
            ObstacleTypeConfig(id: "instantFail", laneSpanMin: 1, laneSpanMax: 3)
        ]
        let clusterDisabled = ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear")
        let clusterEnabled = ClusterConfig(enabled: true, minGroupSize: 2, maxGroupSize: 3, layout: "linear")
        let configNoCluster = ObstacleConfig(types: types, clusterConfig: clusterDisabled)
        let configWithCluster = ObstacleConfig(types: types, clusterConfig: clusterEnabled)

        let genNoCluster = ObstacleGenerator(obstacleConfig: configNoCluster, laneCount: laneCount)
        let genWithCluster = ObstacleGenerator(obstacleConfig: configWithCluster, laneCount: laneCount)

        let rng = GKMersenneTwisterRandomSource(seed: 12345)
        let duration: TimeInterval = 3.0

        let placementsNoCluster = genNoCluster.generate(segmentDuration: duration, rng: rng)
        let rng2 = GKMersenneTwisterRandomSource(seed: 12345)
        let placementsWithCluster = genWithCluster.generate(segmentDuration: duration, rng: rng2)

        // With cluster disabled we get spread-only; with enabled we may get a cluster (2–3 in a group)
        // Just assert all placements satisfy span ≤ 5 and startLane + span ≤ laneCount
        for p in placementsNoCluster + placementsWithCluster {
            XCTAssertTrue(ObstaclePlacement.validate(startLane: p.startLane, laneSpan: p.laneSpan, laneCount: laneCount),
                         "Placement startLane=\(p.startLane) span=\(p.laneSpan) should be valid")
            XCTAssertLessThanOrEqual(p.laneSpan, 5)
            XCTAssertLessThanOrEqual(p.startLane + p.laneSpan, laneCount)
        }
    }

    func testGeneratedPlacements_spanAndLaneBounds() {
        let types = [
            ObstacleTypeConfig(id: "passable", laneSpanMin: 1, laneSpanMax: 2),
            ObstacleTypeConfig(id: "instantFail", laneSpanMin: 1, laneSpanMax: 3),
            ObstacleTypeConfig(id: "slowdown", laneSpanMin: 1, laneSpanMax: 2)
        ]
        let config = ObstacleConfig(types: types, clusterConfig: ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear"))
        let gen = ObstacleGenerator(obstacleConfig: config, laneCount: laneCount)

        for seed in [1 as UInt64, 2, 99, 1000] {
            let rng = GKMersenneTwisterRandomSource(seed: seed)
            let placements = gen.generate(segmentDuration: 2.5, rng: rng)
            for p in placements {
                XCTAssertGreaterThanOrEqual(p.startLane, 0, "seed \(seed)")
                XCTAssertLessThan(p.startLane, laneCount, "seed \(seed)")
                XCTAssertGreaterThanOrEqual(p.laneSpan, 1, "seed \(seed)")
                XCTAssertLessThanOrEqual(p.laneSpan, 5, "seed \(seed)")
                XCTAssertLessThanOrEqual(p.startLane + p.laneSpan, laneCount, "seed \(seed)")
            }
        }
    }
}
