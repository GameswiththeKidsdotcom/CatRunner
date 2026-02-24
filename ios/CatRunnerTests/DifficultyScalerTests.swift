//
//  DifficultyScalerTests.swift
//  CatRunnerTests
//
//  C8 — Difficulty scaling: params increase over segment count.
//

import XCTest
@testable import CatRunner

final class DifficultyScalerTests: XCTestCase {

    let config = DifficultyScalingConfig(
        speedIncrementPerSegment: 0.02,
        multiLaneProbabilityIncrement: 0.01,
        instantFailProbabilityIncrement: 0.005,
        segmentsPerStep: 5,
        initialSpawnIntervalSeconds: 5,
        spawnRateIncrementPerFiveSeconds: 0.1
    )

    func testStepZeroForSegmentIndexBelowStep() {
        let scaler = DifficultyScaler(config: config)
        XCTAssertEqual(scaler.step(forSegmentIndex: 0), 0)
        XCTAssertEqual(scaler.step(forSegmentIndex: 4), 0)
    }

    func testStepIncreasesEverySegmentsPerStep() {
        let scaler = DifficultyScaler(config: config)
        XCTAssertEqual(scaler.step(forSegmentIndex: 5), 1)
        XCTAssertEqual(scaler.step(forSegmentIndex: 9), 1)
        XCTAssertEqual(scaler.step(forSegmentIndex: 10), 2)
        XCTAssertEqual(scaler.step(forSegmentIndex: 14), 2)
        XCTAssertEqual(scaler.step(forSegmentIndex: 15), 3)
    }

    func testSpeedMultiplierIncreasesWithSegmentIndex() {
        let scaler = DifficultyScaler(config: config)
        let speed0 = scaler.speedMultiplier(forSegmentIndex: 0)
        let speed5 = scaler.speedMultiplier(forSegmentIndex: 5)
        let speed10 = scaler.speedMultiplier(forSegmentIndex: 10)
        XCTAssertEqual(speed0, 1.0, accuracy: 0.0001)
        XCTAssertEqual(speed5, 1.02, accuracy: 0.0001)
        XCTAssertEqual(speed10, 1.04, accuracy: 0.0001)
        XCTAssertTrue(speed0 < speed5)
        XCTAssertTrue(speed5 < speed10)
    }

    func testMultiLaneProbabilityBonusIncreasesWithSegmentIndex() {
        let scaler = DifficultyScaler(config: config)
        let b0 = scaler.multiLaneProbabilityBonus(forSegmentIndex: 0)
        let b5 = scaler.multiLaneProbabilityBonus(forSegmentIndex: 5)
        let b10 = scaler.multiLaneProbabilityBonus(forSegmentIndex: 10)
        XCTAssertEqual(b0, 0, accuracy: 0.0001)
        XCTAssertEqual(b5, 0.01, accuracy: 0.0001)
        XCTAssertEqual(b10, 0.02, accuracy: 0.0001)
        XCTAssertTrue(b0 < b5)
        XCTAssertTrue(b5 < b10)
    }

    func testInstantFailProbabilityBonusIncreasesWithSegmentIndex() {
        let scaler = DifficultyScaler(config: config)
        let b0 = scaler.instantFailProbabilityBonus(forSegmentIndex: 0)
        let b5 = scaler.instantFailProbabilityBonus(forSegmentIndex: 5)
        let b10 = scaler.instantFailProbabilityBonus(forSegmentIndex: 10)
        XCTAssertEqual(b0, 0, accuracy: 0.0001)
        XCTAssertEqual(b5, 0.005, accuracy: 0.0001)
        XCTAssertEqual(b10, 0.01, accuracy: 0.0001)
        XCTAssertTrue(b0 < b5)
        XCTAssertTrue(b5 < b10)
    }

    func testScaledValuesReturnsTuple() {
        let scaler = DifficultyScaler(config: config)
        let (speed, multiLane, instantFail) = scaler.scaledValues(forSegmentIndex: 10)
        XCTAssertEqual(speed, 1.04, accuracy: 0.0001)
        XCTAssertEqual(multiLane, 0.02, accuracy: 0.0001)
        XCTAssertEqual(instantFail, 0.01, accuracy: 0.0001)
    }

    // MARK: - DifficultySpawnRamp: spawnRate(elapsedSeconds:)

    func testSpawnRate_defaultConfig_exactValues() {
        let scaler = DifficultyScaler(config: config)
        XCTAssertEqual(scaler.spawnRate(elapsedSeconds: 0), 0.2, accuracy: 0.0001)
        XCTAssertEqual(scaler.spawnRate(elapsedSeconds: 5), 0.3, accuracy: 0.0001)
        XCTAssertEqual(scaler.spawnRate(elapsedSeconds: 10), 0.4, accuracy: 0.0001)
    }

    func testSpawnRate_monotonicAndNonNegative() {
        let scaler = DifficultyScaler(config: config)
        var prev: Double = -1
        for t in [0.0, 1.0, 5.0, 10.0, 20.0, 100.0] {
            let rate = scaler.spawnRate(elapsedSeconds: t)
            XCTAssertGreaterThanOrEqual(rate, 0)
            XCTAssertGreaterThanOrEqual(rate, prev)
            prev = rate
        }
    }

    func testSpawnRate_alternativeConfig() {
        let alt = DifficultyScalingConfig(
            speedIncrementPerSegment: 0,
            multiLaneProbabilityIncrement: 0,
            instantFailProbabilityIncrement: 0,
            segmentsPerStep: 1,
            initialSpawnIntervalSeconds: 10,
            spawnRateIncrementPerFiveSeconds: 0.05
        )
        let scaler = DifficultyScaler(config: alt)
        XCTAssertEqual(scaler.spawnRate(elapsedSeconds: 0), 0.1, accuracy: 0.0001)
        XCTAssertEqual(scaler.spawnRate(elapsedSeconds: 5), 0.15, accuracy: 0.0001)
    }
}
