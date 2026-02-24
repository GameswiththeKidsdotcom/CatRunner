//
//  SegmentGeneratorTests.swift
//  CatRunnerTests
//
//  DifficultySpawnRamp — Logic-test items 6–7: elapsedTimeAtSegmentStart + spawn-rate config;
//  nil fallback generation succeeds.
//

import XCTest
@testable import CatRunner

final class SegmentGeneratorTests: XCTestCase {

    let laneCount = 5

    /// Logic-test item 6: With elapsedTimeAtSegmentStart and spawn-rate config, obstacle count
    /// scales with rate×duration (later elapsed → higher rate → more or equal obstacles for same seed/duration).
    func testElapsedTimeAtSegmentStart_scalesObstacleCountWithRate() {
        let types = [
            ObstacleTypeConfig(id: "passable", laneSpanMin: 1, laneSpanMax: 2),
            ObstacleTypeConfig(id: "instantFail", laneSpanMin: 1, laneSpanMax: 2)
        ]
        let config = ObstacleConfig(
            types: types,
            clusterConfig: ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear")
        )
        let durationConfig = SegmentDurationConfig(minDurationSeconds: 3.0, maxDurationSeconds: 3.0)
        let difficultyScaling = DifficultyScalingConfig(
            speedIncrementPerSegment: 0,
            multiLaneProbabilityIncrement: 0,
            instantFailProbabilityIncrement: 0,
            segmentsPerStep: 1,
            initialSpawnIntervalSeconds: 5,
            spawnRateIncrementPerFiveSeconds: 0.1
        )
        let generator = SegmentGenerator(
            config: durationConfig,
            obstacleConfig: config,
            laneCount: laneCount,
            difficultyScaling: difficultyScaling
        )

        let seed: UInt64 = 100
        let segmentAt0 = generator.generateSegment(seed: seed, segmentIndex: 0, elapsedTimeAtSegmentStart: 0)
        let segmentAt10 = generator.generateSegment(seed: seed, segmentIndex: 0, elapsedTimeAtSegmentStart: 10)

        // Rate at 0s = 0.2, at 10s = 0.4; duration 3s → target count 0.6 vs 1.2 (rounded). Path guarantee can reduce; count should not decrease for later elapsed.
        XCTAssertGreaterThanOrEqual(
            segmentAt10.obstacles.count,
            segmentAt0.obstacles.count,
            "Later elapsed time should produce at least as many obstacles (higher spawn rate)"
        )
        XCTAssertLessThanOrEqual(segmentAt0.obstacles.count, 2)
        XCTAssertLessThanOrEqual(segmentAt10.obstacles.count, 2)
    }

    /// Logic-test item 7: With elapsedTimeAtSegmentStart == nil, generation succeeds and count is in sane range.
    func testElapsedTimeAtSegmentStart_nil_generationSucceedsSaneCount() {
        let types = [
            ObstacleTypeConfig(id: "passable", laneSpanMin: 1, laneSpanMax: 2),
            ObstacleTypeConfig(id: "instantFail", laneSpanMin: 1, laneSpanMax: 2)
        ]
        let config = ObstacleConfig(
            types: types,
            clusterConfig: ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear")
        )
        let durationConfig = SegmentDurationConfig(minDurationSeconds: 2.0, maxDurationSeconds: 4.0)
        let difficultyScaling = DifficultyScalingConfig(
            speedIncrementPerSegment: 0,
            multiLaneProbabilityIncrement: 0,
            instantFailProbabilityIncrement: 0,
            segmentsPerStep: 1,
            initialSpawnIntervalSeconds: 5,
            spawnRateIncrementPerFiveSeconds: 0.1
        )
        let generator = SegmentGenerator(
            config: durationConfig,
            obstacleConfig: config,
            laneCount: laneCount,
            difficultyScaling: difficultyScaling
        )

        for segmentIndex in [0, 1, 5] {
            let segment = generator.generateSegment(seed: UInt64(segmentIndex + 100), segmentIndex: segmentIndex, elapsedTimeAtSegmentStart: nil)
            XCTAssertFalse(segment.obstacles.contains { $0.startLane < 0 || $0.startLane + $0.laneSpan > laneCount })
            XCTAssertLessThanOrEqual(segment.obstacles.count, Int(segment.durationSeconds * 2) + 2)
        }
    }
}
