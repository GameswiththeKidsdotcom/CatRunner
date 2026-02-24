//
//  GameSceneTestHelper.swift
//  CatRunnerTests
//
//  T5-C6 — Shared helper: create GameScene with design size, attach to SKView, call didMove(to:).
//

import XCTest
import SpriteKit
@testable import CatRunner

enum GameSceneTestHelper {

    /// Creates a GameScene with DesignConstants.designSize, an SKView of the same size, and calls didMove(to: view).
    /// Returns the scene (caller can ignore the view unless needed for reference).
    static func makeSceneWithDidMove() -> GameScene {
        let size = DesignConstants.designSize
        let scene = GameScene(size: size)
        let skView = SKView(frame: CGRect(origin: .zero, size: size))
        scene.didMove(to: skView)
        return scene
    }
}
