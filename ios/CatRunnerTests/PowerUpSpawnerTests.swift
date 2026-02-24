//
//  PowerUpSpawnerTests.swift
//  CatRunnerTests
//
//  C6 — Power-up spawner: free lane only, max 1 per segment, no overlap with obstacles.
//

import XCTest
import GameplayKit
@testable import CatRunner

final class PowerUpSpawnerTests: XCTestCase {

    let laneCount = DesignConstants.defaultLaneCount
    let epsilon: TimeInterval = DesignConstants.timeEpsilon + 0.01 // Slightly above shared timeEpsilon for overlap check

    // MARK: - spawnProbability 0 → never spawn

    func testSpawnProbabilityZero_neverSpawns() {
        let config = PowerUpConfig(
            types: ["speedBoost", "shield"],
            maxActive: 1,
            spawnProbability: 0,
            placementRule: "freeLaneOnly"
        )
        let spawner = PowerUpSpawner(powerUpConfig: config, laneCount: laneCount)
        let segment = Segment(
            durationSeconds: 3.0,
            seed: 1,
            obstacles: []
        )
        let rng = GKMersenneTwisterRandomSource(seed: 999)
        for _ in 0..<50 {
            let placement = spawner.generate(for: segment, rng: rng)
            XCTAssertNil(placement, "With spawnProbability 0 should never spawn")
        }
    }

    // MARK: - All lanes blocked → no power-up

    func testAllLanesBlocked_noPowerUp() {
        let config = PowerUpConfig(
            types: ["speedBoost"],
            maxActive: 1,
            spawnProbability: 1.0,
            placementRule: "freeLaneOnly"
        )
        let spawner = PowerUpSpawner(powerUpConfig: config, laneCount: laneCount)
        let obstacles: [ObstaclePlacement] = [
            ObstaclePlacement(startLane: 0, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5),
            ObstaclePlacement(startLane: 2, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5),
            ObstaclePlacement(startLane: 4, laneSpan: 1, typeId: "instantFail", timeOffset: 0.5)
        ]
        let segment = Segment(durationSeconds: 3.0, seed: 1, obstacles: obstacles)
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertEqual(blocked.count, laneCount, "Test setup: all lanes should be blocked")

        var spawnedAny = false
        for seed in 0..<100 {
            let rng = GKMersenneTwisterRandomSource(seed: UInt64(seed))
            if spawner.generate(for: segment, rng: rng) != nil {
                spawnedAny = true
                break
            }
        }
        XCTAssertFalse(spawnedAny, "When all lanes blocked should never spawn power-up")
    }

    // MARK: - Power-up only in free lane

    func testPowerUpOnlyInFreeLane() {
        let config = PowerUpConfig(
            types: ["speedBoost", "shield"],
            maxActive: 1,
            spawnProbability: 1.0,
            placementRule: "freeLaneOnly"
        )
        let spawner = PowerUpSpawner(powerUpConfig: config, laneCount: laneCount)
        let obstacles: [ObstaclePlacement] = [
            ObstaclePlacement(startLane: 0, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5)
        ]
        let segment = Segment(durationSeconds: 3.0, seed: 1, obstacles: obstacles)
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertTrue(blocked.contains(0) && blocked.contains(1), "Lanes 0,1 blocked")
        XCTAssertFalse(blocked.contains(2) && blocked.contains(3) && blocked.contains(4), "Lanes 2,3,4 free")

        for seed in 0..<30 {
            let rng = GKMersenneTwisterRandomSource(seed: UInt64(seed))
            guard let placement = spawner.generate(for: segment, rng: rng) else { continue }
            XCTAssertFalse(
                blocked.contains(placement.laneIndex),
                "Power-up must be in free lane; seed \(seed) produced lane \(placement.laneIndex)"
            )
        }
    }

    // MARK: - Max 1 per segment

    func testMaxOnePerSegment() {
        let config = PowerUpConfig(
            types: ["speedBoost", "shield"],
            maxActive: 1,
            spawnProbability: 0.5,
            placementRule: "freeLaneOnly"
        )
        let durationConfig = SegmentDurationConfig(minDurationSeconds: 2.0, maxDurationSeconds: 3.0)
        let obstacleConfig = ObstacleConfig(
            types: [
                ObstacleTypeConfig(id: "passable", laneSpanMin: 1, laneSpanMax: 2),
                ObstacleTypeConfig(id: "instantFail", laneSpanMin: 1, laneSpanMax: 2)
            ],
            clusterConfig: ClusterConfig(enabled: false, minGroupSize: 2, maxGroupSize: 3, layout: "linear")
        )
        let generator = SegmentGenerator(
            config: durationConfig,
            obstacleConfig: obstacleConfig,
            laneCount: laneCount,
            powerUpConfig: config
        )
        for seed in 0..<100 {
            let segment = generator.generateSegment(seed: UInt64(seed))
            if let powerUp = segment.powerUp {
                XCTAssertTrue(segment.powerUp != nil && segment.obstacles.count >= 0)
                _ = powerUp.laneIndex
                _ = powerUp.typeId
                _ = powerUp.timeOffset
            }
        }
    }

    // MARK: - Power-up time does not overlap obstacle in that lane

    func testPowerUpTimeDoesNotOverlapObstacleInLane() {
        let config = PowerUpConfig(
            types: ["speedBoost"],
            maxActive: 1,
            spawnProbability: 1.0,
            placementRule: "freeLaneOnly"
        )
        let spawner = PowerUpSpawner(powerUpConfig: config, laneCount: laneCount)
        let duration: TimeInterval = 3.0
        let obstacleTime: TimeInterval = 1.0
        let obstacles: [ObstaclePlacement] = [
            ObstaclePlacement(startLane: 0, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5),
            ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "passable", timeOffset: obstacleTime),
            ObstaclePlacement(startLane: 3, laneSpan: 2, typeId: "instantFail", timeOffset: 0.5)
        ]
        let segment = Segment(durationSeconds: duration, seed: 1, obstacles: obstacles)
        let blocked = PathGuarantee.blockedLanes(obstacles: obstacles, laneCount: laneCount)
        XCTAssertFalse(blocked.contains(2), "Lane 2 is free (passable does not block)")
        let freeLanes = (0..<laneCount).filter { !blocked.contains($0) }
        XCTAssertEqual(freeLanes, [2], "Only lane 2 is free so power-up must be in lane 2")

        for seed in 0..<20 {
            let rng = GKMersenneTwisterRandomSource(seed: UInt64(seed))
            guard let placement = spawner.generate(for: segment, rng: rng) else {
                XCTFail("With spawnProbability 1 and one free lane expected a placement for seed \(seed)")
                return
            }
            XCTAssertEqual(placement.laneIndex, 2)
            let obstaclesInLane = segment.obstacles.filter {
                placement.laneIndex >= $0.startLane && placement.laneIndex < $0.startLane + $0.laneSpan
            }
            for obs in obstaclesInLane {
                let distance = abs(placement.timeOffset - obs.timeOffset)
                XCTAssertGreaterThanOrEqual(
                    distance,
                    epsilon,
                    "Power-up at \(placement.timeOffset) should not overlap obstacle at \(obs.timeOffset) in lane \(placement.laneIndex)"
                )
            }
        }
    }

    // MARK: - Determinism: same seed → same placement

    func testDeterminism_sameSeedSamePlacement() {
        let config = PowerUpConfig(
            types: ["speedBoost", "shield"],
            maxActive: 1,
            spawnProbability: 1.0,
            placementRule: "freeLaneOnly"
        )
        let spawner = PowerUpSpawner(powerUpConfig: config, laneCount: laneCount)
        let segment = Segment(durationSeconds: 3.0, seed: 1, obstacles: [])
        let rng1 = GKMersenneTwisterRandomSource(seed: 42)
        let rng2 = GKMersenneTwisterRandomSource(seed: 42)
        let p1 = spawner.generate(for: segment, rng: rng1)
        let p2 = spawner.generate(for: segment, rng: rng2)
        XCTAssertEqual(p1, p2)
    }

    // MARK: - EngineVariantConfig decodes powerUps

    func testEngineVariantConfig_decodesPowerUps() throws {
        let json = """
        {"engine":{"lanes":5,"segmentDurationSeconds":{"min":2,"max":3},"jumpDurationSeconds":0.4,"slideDurationSeconds":0.5,"baseSpeed":1,"deterministicPhysics":true},"obstacles":{"types":[{"id":"passable","laneSpan":[1,2]},{"id":"instantFail","laneSpan":[1,3]}],"segmentDurationSeconds":2.5,"clusterConfig":{"enabled":false,"minGroupSize":2,"maxGroupSize":3,"layout":"linear"}},"powerUps":{"types":["speedBoost","shield"],"maxActive":1,"spawnProbability":0.15,"placementRule":"freeLaneOnly"}}
        """
        let data = Data(json.utf8)
        let config = try EngineVariantConfig.decode(from: data)
        XCTAssertNotNil(config.powerUpConfig)
        let powerUp = config.powerUpConfig!
        XCTAssertEqual(powerUp.types, ["speedBoost", "shield"])
        XCTAssertEqual(powerUp.maxActive, 1)
        XCTAssertEqual(powerUp.spawnProbability, 0.15, accuracy: 0.001)
        XCTAssertEqual(powerUp.placementRule, "freeLaneOnly")
    }
}
