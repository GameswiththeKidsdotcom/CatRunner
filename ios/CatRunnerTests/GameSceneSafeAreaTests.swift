//
//  GameSceneSafeAreaTests.swift
//  CatRunnerTests
//
//  P003 Chunk 1 — Safe-area-aware score HUD: setTopSafeAreaMargin updates HUD position.
//

import XCTest
import SpriteKit
@testable import CatRunner

final class GameSceneSafeAreaTests: XCTestCase {

    /// P003 Chunk 1 — setTopSafeAreaMargin(59) places score HUD at y = size.height - 59 - 24.
    func testSetTopSafeAreaMarginUpdatesHUDPosition() {
        let size = CGSize(width: 393, height: 852)
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)

        guard let hud = scene.childNode(withName: "scoreHUD") else {
            XCTFail("scoreHUD node should exist after didMove(to:)")
            return
        }

        let expectedYDefault = size.height - 24 - 24  // fallback margin 24, inset 24
        XCTAssertEqual(hud.position.y, expectedYDefault, accuracy: 0.01, "Initial HUD y uses fallback margin")

        scene.setTopSafeAreaMargin(59)
        let expectedYAfterMargin = size.height - 59 - 24
        XCTAssertEqual(hud.position.y, expectedYAfterMargin, accuracy: 0.01, "HUD y after setTopSafeAreaMargin(59)")
    }
}
