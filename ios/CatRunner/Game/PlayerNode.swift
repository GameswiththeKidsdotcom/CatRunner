//
//  PlayerNode.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. Player at lane 2 (center).
//  C7 — Jump/slide and collision: state (lane, isJumping, isSliding), jump/slide animations for config durations,
//       lane swap clamped 0..<laneCount. Revive flow is C8.
//  SlideJumpCatAnimation C3 — State-based textures: run/jump/slide; no procedural scale of run image.
//  C4 — Jump easing; optional run cycle when multi-frame run exists.
//

import SpriteKit

private let runCycleActionKey = "playerRunCycle"

/// Player sprite; C1 places at center. C7: tracks lane, jump/slide state; lane swap clamped 0..<laneCount.
final class PlayerNode: SKSpriteNode {

    static let defaultSize = CGSize(width: 44, height: 44)

    /// Default durations when EngineVariantConfig is not loaded (C7 fallback).
    static let defaultJumpDuration: TimeInterval = 0.4
    static let defaultSlideDuration: TimeInterval = 0.5
    /// Default start lane (center; must match DesignConstants.defaultCenterLaneIndex for default lane count). T5-C3.
    static var defaultStartLane: Int { DesignConstants.defaultCenterLaneIndex }

    // MARK: - C7 Player state (used by GameScene and CollisionSystem)

    /// Current lane index (0..<laneCount). Lane swap is clamped 0–4 when laneCount is 5.
    private(set) var currentLaneIndex: Int = DesignConstants.defaultCenterLaneIndex
    /// True while jump animation is running; player avoids low obstacles when true.
    private(set) var isJumping: Bool = false
    /// True while slide animation is running; player avoids high obstacles when true.
    private(set) var isSliding: Bool = false

    /// Vertical position at rest (lane Y); used to restore after jump.
    var restPositionY: CGFloat = 0

    /// C2 — When set, lane moves animate the container (keeps shadow on ground). GameScene sets after add.
    weak var containerNode: SKNode?

    /// SlideJumpCatAnimation C3 — Textures for state-based animation. Run = default; jump/slide used when available.
    private let runTexture: SKTexture?
    private let jumpTexture: SKTexture?
    private let slideTexture: SKTexture?
    /// C4 — Optional multi-frame run cycle. When set, loop when idle.
    private var runFrameTextures: [SKTexture]?
    /// Multi-frame jump animation. When set, plays during jump instead of single texture.
    private let jumpFrameTextures: [SKTexture]?
    /// Multi-frame slide animation. When set, plays during slide instead of single texture.
    private let slideFrameTextures: [SKTexture]?

    /// B3 — Designated: optional texture (nil → color fill), color, size 44×44. Convenience inits delegate here.
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        self.runTexture = texture
        self.jumpTexture = nil
        self.slideTexture = nil
        self.runFrameTextures = nil
        self.jumpFrameTextures = nil
        self.slideFrameTextures = nil
        super.init(texture: texture, color: color, size: size)
        name = "player"
        zPosition = 10
    }

    convenience init() {
        self.init(texture: nil, color: .systemTeal, size: PlayerNode.defaultSize)
    }

    /// B3 — Create player with optional texture (e.g. character.run). Nil → teal placeholder; size 44×44.
    convenience init(texture: SKTexture?) {
        self.init(texture: texture, color: .systemTeal, size: PlayerNode.defaultSize)
    }

    /// SlideJumpCatAnimation C3 — Create player with run/jump/slide textures. Jump/slide optional; when nil, run texture shown (no procedural scale).
    /// Multi-frame jump/slide: when jumpFrameTextures/slideFrameTextures set, plays frame sequence during action.
    init(runTexture: SKTexture?, jumpTexture: SKTexture?, slideTexture: SKTexture?, runFrameTextures: [SKTexture]? = nil, jumpFrameTextures: [SKTexture]? = nil, slideFrameTextures: [SKTexture]? = nil) {
        self.runTexture = runTexture
        self.jumpTexture = jumpTexture
        self.slideTexture = slideTexture
        self.runFrameTextures = runFrameTextures
        self.jumpFrameTextures = jumpFrameTextures
        self.slideFrameTextures = slideFrameTextures
        super.init(texture: runTexture, color: runTexture != nil ? .clear : .systemTeal, size: PlayerNode.defaultSize)
        name = "player"
        zPosition = 10
    }

    required init?(coder aDecoder: NSCoder) {
        self.runTexture = nil
        self.jumpTexture = nil
        self.slideTexture = nil
        self.runFrameTextures = nil
        self.jumpFrameTextures = nil
        self.slideFrameTextures = nil
        super.init(coder: aDecoder)
    }

    // MARK: - C7 Lane

    /// Set initial lane (e.g. from EngineVariantConfig.playerStartLane). Call once at add.
    func setInitialLane(_ lane: Int, laneCount: Int) {
        currentLaneIndex = clampLane(lane, laneCount: laneCount)
    }

    /// Move to lane (0..<laneCount); clamps to valid range. Returns the lane index actually set. C2: when containerNode is set, moves container (shadow stays on ground).
    @discardableResult
    func moveToLane(_ lane: Int, laneCount: Int, xPosition: CGFloat) -> Int {
        let clamped = clampLane(lane, laneCount: laneCount)
        currentLaneIndex = clamped
        if let container = containerNode {
            let move = SKAction.move(to: CGPoint(x: xPosition, y: container.position.y), duration: 0.15)
            container.run(move)
        } else {
            let move = SKAction.move(to: CGPoint(x: xPosition, y: position.y), duration: 0.15)
            run(move)
        }
        return clamped
    }

    private func clampLane(_ lane: Int, laneCount: Int) -> Int {
        guard laneCount > 0 else { return 0 }
        return min(max(0, lane), laneCount - 1)
    }

    // MARK: - C7 Jump (avoids low obstacles; duration from config or default)

    /// Start jump if not already jumping or sliding. C3: shows jump texture or multi-frame animation when available; otherwise run. No squash of run image.
    func startJump(duration: TimeInterval) {
        guard !isJumping, !isSliding else { return }
        isJumping = true
        if let frames = jumpFrameTextures, !frames.isEmpty {
            let timePerFrame = duration / Double(frames.count)
            let animate = SKAction.animate(with: frames, timePerFrame: timePerFrame)
            let jumpHeight: CGFloat = 70
            let up = SKAction.moveBy(x: 0, y: jumpHeight, duration: duration / 2)
            up.timingMode = .easeInEaseOut
            let down = SKAction.moveBy(x: 0, y: -jumpHeight, duration: duration / 2)
            down.timingMode = .easeInEaseOut
            let clear = SKAction.run { [weak self] in
                self?.isJumping = false
                self?.restoreRunState()
            }
            stopRunCycle()
            run(SKAction.group([animate, SKAction.sequence([up, down, clear])]))
        } else {
            if let tex = jumpTexture { texture = tex }
            let jumpHeight: CGFloat = 70
            let up = SKAction.moveBy(x: 0, y: jumpHeight, duration: duration / 2)
            up.timingMode = .easeInEaseOut
            let down = SKAction.moveBy(x: 0, y: -jumpHeight, duration: duration / 2)
            down.timingMode = .easeInEaseOut
            let clear = SKAction.run { [weak self] in
                self?.isJumping = false
                self?.restoreRunState()
            }
            stopRunCycle()
            run(SKAction.sequence([up, down, clear]))
        }
    }

    // MARK: - C7 Slide (avoids high obstacles; duration from config or default)

    /// Start slide if not already jumping or sliding. C3: shows slide texture or multi-frame animation when available; no procedural scale of run image.
    func startSlide(duration: TimeInterval) {
        guard !isJumping, !isSliding else { return }
        isSliding = true
        if let frames = slideFrameTextures, !frames.isEmpty {
            let timePerFrame = duration / Double(frames.count)
            let animate = SKAction.animate(with: frames, timePerFrame: timePerFrame)
            let clear = SKAction.run { [weak self] in
                self?.isSliding = false
                self?.restoreRunState()
            }
            stopRunCycle()
            run(SKAction.sequence([animate, clear]))
        } else {
            if let tex = slideTexture { texture = tex }
            let wait = SKAction.wait(forDuration: max(0, duration))
            let clear = SKAction.run { [weak self] in
                self?.isSliding = false
                self?.restoreRunState()
            }
            stopRunCycle()
            run(SKAction.sequence([wait, clear]))
        }
    }

    // MARK: - C4 Run cycle

    /// C4 — Call after addChild to start run cycle when run frames exist. No-op if no frames.
    func startRunCycleIfNeeded() {
        if runFrameTextures != nil && !(runFrameTextures?.isEmpty ?? true) {
            startRunCycle()
        }
    }

    /// Restore run state after jump/slide: run cycle if frames exist, else static run texture.
    private func restoreRunState() {
        if let frames = runFrameTextures, !frames.isEmpty {
            startRunCycle()
        } else {
            texture = runTexture
        }
    }

    private func startRunCycle() {
        guard let frames = runFrameTextures, !frames.isEmpty else { return }
        let animate = SKAction.animate(with: frames, timePerFrame: 0.1)
        let loop = SKAction.repeatForever(animate)
        run(loop, withKey: runCycleActionKey)
    }

    private func stopRunCycle() {
        removeAction(forKey: runCycleActionKey)
    }
}
