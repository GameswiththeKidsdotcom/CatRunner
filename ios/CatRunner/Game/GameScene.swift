//
//  GameScene.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. 5 horizontal lanes (0–4), lane 2 = center; player at lane 2.
//  C7 — Jump/slide and collision per config; input (swipe up/down/left/right); game loop runs CollisionSystem;
//       instant-fail/power-up/slowdown via delegate for C8. Revive flow is C8.
//

import SpriteKit
import GameplayKit

/// Number of lanes (0–4); lane 2 is center. Used when EngineVariantConfig is not loaded.
let LaneCount = 5
/// Center lane index.
let CenterLaneIndex = 2

class GameScene: SKScene {

    /// Lane index (0–4) → x position. Lanes evenly spaced across scene width.
    private var laneXPositions: [CGFloat] = []
    /// Vertical center for player and lane lines.
    private var laneY: CGFloat = 0

    /// C7 — Config from variant.json when available; nil → use LaneCount, CenterLaneIndex, default durations.
    private var engineConfig: EngineVariantConfig?
    /// C7 — Effective lane count (from config or global).
    private var laneCount: Int { engineConfig?.laneCount ?? LaneCount }
    /// C7 — Jump duration from config or default.
    private var jumpDuration: TimeInterval { engineConfig?.jumpDurationSeconds ?? PlayerNode.defaultJumpDuration }
    /// C7 — Slide duration from config or default.
    private var slideDuration: TimeInterval { engineConfig?.slideDurationSeconds ?? PlayerNode.defaultSlideDuration }
    /// C7 — Player start lane from config or default.
    private var playerStartLane: Int { engineConfig?.playerStartLane ?? PlayerNode.defaultStartLane }

    /// C7 — Player node (set in addPlayer).
    private weak var playerNode: PlayerNode?

    /// C7 — Delegate for game-over, power-up, slowdown (C8).
    weak var gameDelegate: GameSceneDelegate?

    /// C7 — Set when instant-fail triggers; C8 can check or use delegate.
    private(set) var gameOverRequested: Bool = false
    /// C7 — Last collected power-up type (for C8 effect).
    private(set) var lastCollectedPowerUpTypeId: String?
    /// C7 — True when slowdown obstacle was hit (C8 applies effect).
    private(set) var slowdownTriggered: Bool = false

    /// C7 — Current segment and time for collision.
    private var currentSegment: Segment?
    private var segmentTime: TimeInterval = 0
    private var lastUpdateTime: TimeInterval?

    /// C8 — Segment index for difficulty scaling and next segment generation; advances when segment completes.
    private var currentSegmentIndex: Int = 0

    /// C8 — Checkpoint for revive: segment index and seed to restore same segment.
    private var checkpointSegmentIndex: Int = 0
    private var checkpointSegmentSeed: UInt64 = 0

    /// C8 — Score and high score; multiplier from power-up (e.g. speedBoost).
    private let scoreKeeper = ScoreKeeper()
    /// Expose current score and high score for UI.
    var currentScore: Int { scoreKeeper.currentScore }
    var highScore: Int { scoreKeeper.highScore }

    /// C7 — Power-up already collected this segment (avoid double-collect).
    private var powerUpCollectedInSegment: Bool = false

    /// C7 — Swipe detection.
    private var touchStartPosition: CGPoint?
    private let swipeMinDistance: CGFloat = 30

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        loadEngineConfig()
        layoutLanes()
        drawLaneLines()
        addPlayer()
        startSegment()
    }

    /// Load variant.json into engineConfig when available.
    private func loadEngineConfig() {
        engineConfig = try? EngineVariantConfig.load(fromBundle: .main, filename: "variant")
    }

    /// Compute lane → x mapping (evenly spaced). Uses laneCount.
    private func layoutLanes() {
        let w = size.width
        let margin: CGFloat = 40
        let usable = w - 2 * margin
        let count = max(1, laneCount)
        let step = (count > 1) ? usable / CGFloat(count - 1) : 0
        laneXPositions = (0..<count).map { margin + CGFloat($0) * step }
        laneY = size.height * 0.5
    }

    /// Draw vertical lane lines for visibility.
    private func drawLaneLines() {
        let top = laneY + size.height * 0.4
        let bottom = laneY - size.height * 0.4
        for (i, x) in laneXPositions.enumerated() {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: x, y: bottom))
            path.addLine(to: CGPoint(x: x, y: top))
            let line = SKShapeNode(path: path)
            line.strokeColor = SKColor.white.withAlphaComponent(0.35)
            line.lineWidth = 2
            line.name = "lane_\(i)"
            addChild(line)
        }
    }

    /// Add PlayerNode at playerStartLane (center when 5 lanes). C7: state and config-driven.
    private func addPlayer() {
        let player = PlayerNode()
        let lane = playerStartLane
        let x = laneXPosition(for: lane)
        player.position = CGPoint(x: x, y: laneY)
        player.restPositionY = laneY
        player.setInitialLane(lane, laneCount: laneCount)
        player.name = "player"
        addChild(player)
        playerNode = player
    }

    /// Start or restart current segment. C8: uses segment index for difficulty; saves checkpoint for revive.
    private func startSegment() {
        powerUpCollectedInSegment = false
        if let config = engineConfig {
            let generator = SegmentGenerator(engineConfig: config)
            let seed = UInt64(bitPattern: Int64(currentSegmentIndex))
            currentSegment = generator.generateSegment(seed: seed, segmentIndex: currentSegmentIndex)
            checkpointSegmentIndex = currentSegmentIndex
            checkpointSegmentSeed = seed
        } else {
            let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "passable", timeOffset: 1.0)
            currentSegment = Segment(durationSeconds: 3.0, seed: 0, obstacles: [obs], powerUp: nil)
        }
        segmentTime = 0
    }

    /// C8 — Advance to next segment (called when segment time exceeds duration).
    private func advanceToNextSegment() {
        scoreKeeper.addSegmentCompleted()
        currentSegmentIndex += 1
        startSegment()
    }

    /// C8 — Resume from last checkpoint after revive. Clears game over, restores segment and player.
    func resumeFromCheckpoint() {
        gameOverRequested = false
        currentSegmentIndex = checkpointSegmentIndex
        if let config = engineConfig {
            let generator = SegmentGenerator(engineConfig: config)
            currentSegment = generator.generateSegment(seed: checkpointSegmentSeed, segmentIndex: checkpointSegmentIndex)
        }
        segmentTime = 0
        playerNode?.moveToLane(playerStartLane, laneCount: laneCount, xPosition: laneXPosition(for: playerStartLane))
        if let player = playerNode {
            player.position = CGPoint(x: laneXPosition(for: playerStartLane), y: laneY)
        }
    }

    /// Lane index (0..<laneCount) → x position.
    func laneXPosition(for laneIndex: Int) -> CGFloat {
        guard laneIndex >= 0, laneIndex < laneXPositions.count else {
            let center = min(CenterLaneIndex, laneCount - 1)
            return laneXPositions[max(0, center)]
        }
        return laneXPositions[laneIndex]
    }

    // MARK: - C7 Input (swipe up = jump, down = slide, left/right = lane)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchStartPosition = touches.first?.location(in: view)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let start = touchStartPosition, let end = touches.first?.location(in: view) else { return }
        touchStartPosition = nil
        let dx = end.x - start.x
        let dy = end.y - start.y
        if abs(dy) >= swipeMinDistance, abs(dy) >= abs(dx) {
            if dy < 0 { triggerJump() } else { triggerSlide() }
        } else if abs(dx) >= swipeMinDistance {
            if dx < 0 { triggerLaneLeft() } else { triggerLaneRight() }
        }
    }

    private func triggerJump() {
        playerNode?.startJump(duration: jumpDuration)
    }

    private func triggerSlide() {
        playerNode?.startSlide(duration: slideDuration)
    }

    private func triggerLaneLeft() {
        guard let player = playerNode else { return }
        let next = player.currentLaneIndex - 1
        _ = player.moveToLane(next, laneCount: laneCount, xPosition: laneXPosition(for: next))
    }

    private func triggerLaneRight() {
        guard let player = playerNode else { return }
        let next = player.currentLaneIndex + 1
        _ = player.moveToLane(next, laneCount: laneCount, xPosition: laneXPosition(for: next))
    }

    // MARK: - C7 Game loop and collision

    override func update(_ currentTime: TimeInterval) {
        let delta: TimeInterval
        if let last = lastUpdateTime {
            delta = currentTime - last
        } else {
            delta = 0
        }
        lastUpdateTime = currentTime

        guard !gameOverRequested, let segment = currentSegment else { return }

        scoreKeeper.addTimeScore(deltaTime: delta)

        segmentTime += delta
        if segmentTime >= segment.durationSeconds {
            advanceToNextSegment()
            return
        }

        guard let player = playerNode else { return }

        let result = CollisionSystem.check(
            playerLane: player.currentLaneIndex,
            isJumping: player.isJumping,
            isSliding: player.isSliding,
            segmentTime: segmentTime,
            obstacles: segment.obstacles,
            powerUp: segment.powerUp,
            laneCount: laneCount
        )

        switch result.obstacleHit {
        case .miss:
            break
        case .hitPassable:
            break
        case .hitSlowdown:
            slowdownTriggered = true
            gameDelegate?.gameSceneDidTriggerSlowdown(self)
        case .hitInstantFail:
            gameOverRequested = true
            gameDelegate?.gameSceneDidRequestGameOver(self)
        }

        if let pu = result.powerUpCollected, !powerUpCollectedInSegment {
            powerUpCollectedInSegment = true
            lastCollectedPowerUpTypeId = pu.typeId
            if pu.typeId == "speedBoost" {
                scoreKeeper.multiplier = 2.0
            }
            gameDelegate?.gameScene(self, didCollectPowerUp: pu.typeId)
        }
    }
}
