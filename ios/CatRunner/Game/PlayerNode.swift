//
//  PlayerNode.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. Player at lane 2 (center).
//

import SpriteKit

/// Player sprite; C1 places at lane 2.
final class PlayerNode: SKSpriteNode {

    static let defaultSize = CGSize(width: 44, height: 44)

    init() {
        // C1: no asset required; use color rect. Replace with texture in later chunks.
        super.init(texture: nil, color: .systemTeal, size: PlayerNode.defaultSize)
        name = "player"
        zPosition = 10
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
