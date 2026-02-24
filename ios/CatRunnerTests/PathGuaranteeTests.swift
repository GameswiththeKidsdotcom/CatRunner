//
//  PathGuaranteeTests.swift
//  CatRunnerTests
//
//  C5 — Path guarantee: ≥1 viable lane per segment; determinism regression.
//

import XCTest
@testable import CatRunner

final class PathGuaranteeTests: XCTestCase {

    let laneCount = DesignConstants.defaultLaneCount

    // MARK: - Blocked lanes and viable lane

    func testBlockedLanes_emptyObstacles_noneBlocked() {
        let obstacles: [ObstaclePlacement] = []
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertTrue(blocked.isEmpty)
        XCTAssertTrue(PathGuarantee.hasAtLeastOneViableLane(obstacles: obstacles, laneCount: laneCount))
    }

    func testBlockedLanes_passableObstacle_doesNotBlock() {
        let obstacles = [
            ObstaclePlacement(startLane: 0, laneSpan: 2, typeId: "passable", timeOffset: 0.5)
        ]
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertTrue(blocked.isEmpty)
        XCTAssertTrue(PathGuarantee.hasAtLeastOneViableLane(obstacles: obstacles, laneCount: laneCount))
    }

    func testBlockedLanes_instantFail_blocksThoseLanes() {
        let obstacles = [
            ObstaclePlacement(startLane: 0, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5)
        ]
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertEqual(blocked, [0, 1])
        XCTAssertTrue(PathGuarantee.hasAtLeastOneViableLane(obstacles: obstacles, laneCount: laneCount))
    }

    func testBlockedLanes_fullSpan_blocksAllLanes() {
        let obstacles = [
            ObstaclePlacement(startLane: 0, laneSpan: laneCount, typeId: "passable", timeOffset: 0.5)
        ]
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertEqual(blocked, Set(0..<laneCount))
        XCTAssertFalse(PathGuarantee.hasAtLeastOneViableLane(obstacles: obstacles, laneCount: laneCount))
    }

    func testBlockedLanes_multipleInstantFail_canBlockAll() {
        let obstacles = [
            ObstaclePlacement(startLane: 0, laneSpan: 2, typeId: "instantFail", timeOffset: 0.0),
            ObstaclePlacement(startLane: 2, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5),
            ObstaclePlacement(startLane: 4, laneSpan: 1, typeId: "instantFail", timeOffset: 1.0)
        ]
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertEqual(blocked, Set(0..<laneCount))
        XCTAssertFalse(PathGuarantee.hasAtLeastOneViableLane(obstacles: obstacles, laneCount: laneCount))
    }

    // MARK: - ensurePathGuarantee

    func testEnsurePathGuarantee_whenViable_unchanged() {
        let obstacles = [
            ObstaclePlacement(startLane: 0, laneSpan: 1, typeId: "instantFail", timeOffset: 0.5)
        ]
        let result = PathGuarantee.ensurePathGuarantee(obstacles: obstacles, laneCount: laneCount)
        XCTAssertEqual(result, obstacles)
    }

    func testEnsurePathGuarantee_whenAllBlocked_removesUntilViable() {
        let obstacles = [
            ObstaclePlacement(startLane: 0, laneSpan: 2, typeId: "instantFail", timeOffset: 0.0),
            ObstaclePlacement(startLane: 2, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5),
            ObstaclePlacement(startLane: 4, laneSpan: 1, typeId: "instantFail", timeOffset: 1.0)
        ]
        let result = PathGuarantee.ensurePathGuarantee(obstacles: obstacles, laneCount: laneCount)
        XCTAssertTrue(PathGuarantee.hasAtLeastOneViableLane(obstacles: result, laneCount: laneCount))
        XCTAssertLessThan(result.count, obstacles.count)
    }

    func testEnsurePathGuarantee_deterministic_sameInputSameOutput() {
        let obstacles = [
            ObstaclePlacement(startLane: 0, laneSpan: laneCount, typeId: "instantFail", timeOffset: 0.5)
        ]
        let a = PathGuarantee.ensurePathGuarantee(obstacles: obstacles, laneCount: laneCount)
        let b = PathGuarantee.ensurePathGuarantee(obstacles: obstacles, laneCount: laneCount)
        XCTAssertEqual(a, b)
    }

    // MARK: - SegmentGenerator: N seeds, every segment has ≥1 viable lane

    func testSegmentGenerator_manySeeds_everySegmentHasAtLeastOneViableLane() {
        let types = [
            ObstacleTypeConfig(id: "passable", laneSpanMin: 1, laneSpanMax: 2),
            ObstacleTypeConfig(id: "instantFail", laneSpanMin: 1, laneSpanMax: 4),
            ObstacleTypeConfig(id: "slowdown", laneSpanMin: 1, laneSpanMax: 2)
        ]
        let config = ObstacleConfig(
            types: types,
            clusterConfig: ClusterConfig(enabled: true, minGroupSize: 2, maxGroupSize: 3, layout: "linear")
        )
        let durationConfig = SegmentDurationConfig(minDurationSeconds: 2.0, maxDurationSeconds: 4.0)
        let generator = SegmentGenerator(config: durationConfig, obstacleConfig: config, laneCount: laneCount)

        let numSeeds = 200
        for seed in 0..<numSeeds {
            let segment = generator.generateSegment(seed: UInt64(seed))
            XCTAssertTrue(
                PathGuarantee.hasAtLeastOneViableLane(obstacles: segment.obstacles, laneCount: laneCount),
                "Seed \(seed) produced segment with no viable lane"
            )
        }
    }

    // MARK: - Regression: same seed → same segment

    func testSegmentGenerator_sameSeed_sameSegment() {
        let types = [
            ObstacleTypeConfig(id: "passable", laneSpanMin: 1, laneSpanMax: 2),
            ObstacleTypeConfig(id: "instantFail", laneSpanMin: 1, laneSpanMax: 3)
        ]
        let config = ObstacleConfig(
            types: types,
            clusterConfig: ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear")
        )
        let durationConfig = SegmentDurationConfig(minDurationSeconds: 2.0, maxDurationSeconds: 3.0)
        let generator = SegmentGenerator(config: durationConfig, obstacleConfig: config, laneCount: laneCount)

        let seed: UInt64 = 42
        let segment1 = generator.generateSegment(seed: seed)
        let segment2 = generator.generateSegment(seed: seed)

        XCTAssertEqual(segment1.durationSeconds, segment2.durationSeconds)
        XCTAssertEqual(segment1.seed, segment2.seed)
        XCTAssertEqual(segment1.obstacles, segment2.obstacles)
    }
}
