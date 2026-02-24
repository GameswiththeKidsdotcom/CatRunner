//
//  C7MechanicsCollisionTests.swift
//  CatRunnerTests
//
//  C7 — Jump/slide and collision: (a) jump and slide execute and clear after duration,
//  (b) lane swap clamps 0–4, (c) collision triggers correct behavior (instant-fail flag,
//  power-up collected, passable/slowdown no death).
//

import XCTest
@testable import CatRunner

final class C7MechanicsCollisionTests: XCTestCase {

    let laneCount = DesignConstants.defaultLaneCount

    // MARK: - Lane swap clamps 0–4

    func testLaneSwap_clampsToZero() {
        let player = PlayerNode()
        player.setInitialLane(DesignConstants.defaultCenterLaneIndex, laneCount: laneCount)
        let result = player.moveToLane(-1, laneCount: laneCount, xPosition: 0)
        XCTAssertEqual(result, 0)
        XCTAssertEqual(player.currentLaneIndex, 0)
    }

    func testLaneSwap_clampsToFour() {
        let player = PlayerNode()
        player.setInitialLane(DesignConstants.defaultCenterLaneIndex, laneCount: laneCount)
        let result = player.moveToLane(10, laneCount: laneCount, xPosition: 0)
        XCTAssertEqual(result, 4)
        XCTAssertEqual(player.currentLaneIndex, 4)
    }

    func testLaneSwap_validLanes() {
        let player = PlayerNode()
        for lane in 0..<laneCount {
            let result = player.moveToLane(lane, laneCount: laneCount, xPosition: CGFloat(lane))
            XCTAssertEqual(result, lane)
            XCTAssertEqual(player.currentLaneIndex, lane)
        }
    }

    // MARK: - Jump and slide state

    func testJump_setsIsJumpingTrue() {
        let player = PlayerNode()
        XCTAssertFalse(player.isJumping)
        player.startJump(duration: 0.5)
        XCTAssertTrue(player.isJumping)
    }

    func testSlide_setsIsSlidingTrue() {
        let player = PlayerNode()
        XCTAssertFalse(player.isSliding)
        player.startSlide(duration: 0.5)
        XCTAssertTrue(player.isSliding)
    }

    func testJump_blockedWhileSliding() {
        let player = PlayerNode()
        player.startSlide(duration: 1.0)
        XCTAssertTrue(player.isSliding)
        player.startJump(duration: 0.4)
        XCTAssertTrue(player.isSliding)
        XCTAssertFalse(player.isJumping)
    }

    func testSlide_blockedWhileJumping() {
        let player = PlayerNode()
        player.startJump(duration: 1.0)
        XCTAssertTrue(player.isJumping)
        player.startSlide(duration: 0.5)
        XCTAssertTrue(player.isJumping)
        XCTAssertFalse(player.isSliding)
    }

    // MARK: - Collision: instant-fail (high, must slide)

    func testCollision_instantFail_notSliding_hits() {
        let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "instantFail", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: false,
            segmentTime: 1.0,
            obstacles: [obs],
            powerUp: nil,
            laneCount: laneCount
        )
        XCTAssertEqual(result.obstacleHit, .hitInstantFail)
    }

    func testCollision_instantFail_sliding_misses() {
        let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "instantFail", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: true,
            segmentTime: 1.0,
            obstacles: [obs],
            powerUp: nil,
            laneCount: laneCount
        )
        XCTAssertEqual(result.obstacleHit, .miss)
    }

    // MARK: - Collision: passable/slowdown (low, must jump)

    func testCollision_passable_notJumping_hitsPassable() {
        let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "passable", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: false,
            segmentTime: 1.0,
            obstacles: [obs],
            powerUp: nil,
            laneCount: laneCount
        )
        XCTAssertEqual(result.obstacleHit, .hitPassable)
    }

    func testCollision_passable_jumping_misses() {
        let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "passable", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: true,
            isSliding: false,
            segmentTime: 1.0,
            obstacles: [obs],
            powerUp: nil,
            laneCount: laneCount
        )
        XCTAssertEqual(result.obstacleHit, .miss)
    }

    func testCollision_slowdown_notJumping_hitsSlowdown() {
        let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "slowdown", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: false,
            segmentTime: 1.0,
            obstacles: [obs],
            powerUp: nil,
            laneCount: laneCount
        )
        XCTAssertEqual(result.obstacleHit, .hitSlowdown)
    }

    func testCollision_slowdown_jumping_misses() {
        let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "slowdown", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: true,
            isSliding: false,
            segmentTime: 1.0,
            obstacles: [obs],
            powerUp: nil,
            laneCount: laneCount
        )
        XCTAssertEqual(result.obstacleHit, .miss)
    }

    // MARK: - Collision: power-up collected

    func testCollision_powerUp_sameLaneAndTime_collected() {
        let pu = PowerUpPlacement(laneIndex: 2, typeId: "speedBoost", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: false,
            segmentTime: 1.05,
            obstacles: [],
            powerUp: pu,
            laneCount: laneCount
        )
        XCTAssertEqual(result.powerUpCollected?.typeId, "speedBoost")
        XCTAssertEqual(result.obstacleHit, .miss)
    }

    func testCollision_powerUp_wrongLane_notCollected() {
        let pu = PowerUpPlacement(laneIndex: 0, typeId: "shield", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: false,
            segmentTime: 1.0,
            obstacles: [],
            powerUp: pu,
            laneCount: laneCount
        )
        XCTAssertNil(result.powerUpCollected)
    }

    func testCollision_powerUp_timeOutsideEpsilon_notCollected() {
        let pu = PowerUpPlacement(laneIndex: 2, typeId: "speedBoost", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: false,
            segmentTime: 1.5,
            obstacles: [],
            powerUp: pu,
            laneCount: laneCount
        )
        XCTAssertNil(result.powerUpCollected)
    }

    // MARK: - Obstacle lane coverage

    func testCollision_obstacleDifferentLane_miss() {
        let obs = ObstaclePlacement(startLane: 0, laneSpan: 1, typeId: "instantFail", timeOffset: 1.0)
        let result = CollisionSystem.check(
            playerLane: 2,
            isJumping: false,
            isSliding: false,
            segmentTime: 1.0,
            obstacles: [obs],
            powerUp: nil,
            laneCount: laneCount
        )
        XCTAssertEqual(result.obstacleHit, .miss)
    }
}
