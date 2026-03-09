//
//  LaneBoundaryTapTests.swift
//  CatRunnerTests
//
//  Right-lane-tap bug: When cat is on rightmost (or leftmost) lane and user taps
//  the corresponding overlay, the cat must not visually move. Fix: clamp before
//  moveToLane and early-return at boundary.
//

import XCTest
import SpriteKit
@testable import CatRunner

final class LaneBoundaryTapTests: XCTestCase {

    /// Right-lane-tap bug: tap right when on rightmost lane must not move container.
    func testMoveLaneRight_atRightmostBoundary_doesNotMoveContainer() {
        let size = DesignConstants.designSize
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)

        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.addSubview(skView)
        window.makeKeyAndVisible()

        runRunLoop(for: 0.05)

        scene.moveLaneRight()
        scene.moveLaneRight()
        runRunLoop(for: 0.25)

        guard let posBefore = scene.playerContainerPositionForTesting else {
            XCTFail("Player container should exist")
            return
        }

        scene.moveLaneRight()
        runRunLoop(for: 0.25)

        guard let posAfter = scene.playerContainerPositionForTesting else {
            XCTFail("Player container should exist")
            return
        }

        XCTAssertEqual(posBefore.x, posAfter.x, accuracy: 0.1,
                       "Tap right at rightmost lane must not move container (visual/collision desync bug)")
    }

    /// Symmetric: tap left when on leftmost lane must not move container.
    func testMoveLaneLeft_atLeftmostBoundary_doesNotMoveContainer() {
        let size = DesignConstants.designSize
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)

        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.addSubview(skView)
        window.makeKeyAndVisible()

        runRunLoop(for: 0.05)

        scene.moveLaneLeft()
        scene.moveLaneLeft()
        runRunLoop(for: 0.25)

        guard let posBefore = scene.playerContainerPositionForTesting else {
            XCTFail("Player container should exist")
            return
        }

        scene.moveLaneLeft()
        runRunLoop(for: 0.25)

        guard let posAfter = scene.playerContainerPositionForTesting else {
            XCTFail("Player container should exist")
            return
        }

        XCTAssertEqual(posBefore.x, posAfter.x, accuracy: 0.1,
                       "Tap left at leftmost lane must not move container (visual/collision desync bug)")
    }

    private func runRunLoop(for seconds: TimeInterval) {
        let expectation = XCTestExpectation(description: "run loop")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { expectation.fulfill() }
        wait(for: [expectation], timeout: seconds + 1)
    }
}
