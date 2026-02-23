//
//  PlayerNode.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. Player at lane 2 (center).
//  C7 — Jump/slide and collision: state (lane, isJumping, isSliding), jump/slide animations for config durations,
//       lane swap clamped 0..<laneCount. Revive flow is C8.
//

import SpriteKit

/// Player sprite; C1 places at center. C7: tracks lane, jump/slide state; jump/slide animations; lane swap clamped 0..<laneCount.
final class PlayerNode: SKSpriteNode {

    static let defaultSize = CGSize(width: 44, height: 44)

    /// Default durations when EngineVariantConfig is not loaded (C7 fallback).
    static let defaultJumpDuration: TimeInterval = 0.4
    static let defaultSlideDuration: TimeInterval = 0.5
    /// Default start lane (center for 5 lanes).
    static let defaultStartLane = 2

    // MARK: - C7 Player state (used by GameScene and CollisionSystem)

    /// Current lane index (0..<laneCount). Lane swap is clamped 0–4 when laneCount is 5.
    private(set) var currentLaneIndex: Int = defaultStartLane
    /// True while jump animation is running; player avoids low obstacles when true.
    private(set) var isJumping: Bool = false
    /// True while slide animation is running; player avoids high obstacles when true.
    private(set) var isSliding: Bool = false

    /// Vertical position at rest (lane Y); used to restore after jump.
    var restPositionY: CGFloat = 0

    init() {
        super.init(texture: nil, color: .systemTeal, size: PlayerNode.defaultSize)
        name = "player"
        zPosition = 10
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - C7 Lane

    /// Set initial lane (e.g. from EngineVariantConfig.playerStartLane). Call once at add.
    func setInitialLane(_ lane: Int, laneCount: Int) {
        currentLaneIndex = clampLane(lane, laneCount: laneCount)
    }

    /// Move to lane (0..<laneCount); clamps to valid range. Returns the lane index actually set.
    @discardableResult
    func moveToLane(_ lane: Int, laneCount: Int, xPosition: CGFloat) -> Int {
        let clamped = clampLane(lane, laneCount: laneCount)
        currentLaneIndex = clamped
        let move = SKAction.move(to: CGPoint(x: xPosition, y: position.y), duration: 0.15)
        run(move)
        return clamped
    }

    private func clampLane(_ lane: Int, laneCount: Int) -> Int {
        guard laneCount > 0 else { return 0 }
        return min(max(0, lane), laneCount - 1)
    }

    // MARK: - C7 Jump (avoids low obstacles; duration from config or default)

    /// Start jump if not already jumping or sliding. Runs upward motion for `duration` then clears isJumping.
    /// Uses restPositionY for return height.
    func startJump(duration: TimeInterval) {
        guard !isJumping, !isSliding else { return }
        isJumping = true
        let jumpHeight: CGFloat = 70
        let up = SKAction.moveBy(x: 0, y: jumpHeight, duration: duration / 2)
        let down = SKAction.moveBy(x: 0, y: -jumpHeight, duration: duration / 2)
        let clear = SKAction.run { [weak self] in self?.isJumping = false }
        run(SKAction.sequence([up, down, clear]))
    }

    // MARK: - C7 Slide (avoids high obstacles; duration from config or default)

    /// Start slide if not already jumping or sliding. Crouch/dive for `duration` then clears isSliding.
    func startSlide(duration: TimeInterval) {
        guard !isJumping, !isSliding else { return }
        isSliding = true
        let scaleDown = SKAction.scaleY(to: 0.5, duration: 0.08)
        let wait = SKAction.wait(forDuration: max(0, duration - 0.16))
        let scaleUp = SKAction.scaleY(to: 1.0, duration: 0.08)
        let clear = SKAction.run { [weak self] in self?.isSliding = false }
        run(SKAction.sequence([scaleDown, wait, scaleUp, clear]))
    }
}
