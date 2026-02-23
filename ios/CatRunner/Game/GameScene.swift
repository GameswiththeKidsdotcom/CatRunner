//
//  GameScene.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. 5 horizontal lanes (0–4), lane 2 = center; player at lane 2.
//  C7 — Jump/slide and collision per config; input (swipe up/down/left/right); game loop runs CollisionSystem;
//       instant-fail/power-up/slowdown via delegate for C8. Revive flow is C8.
//  B4 — Obstacle and power-up sprites from B2 asset loader; segment strip below player.
//  B5 — Background layer (sky + ground) with vertical tiling; zPosition < segment strip.
//  P002 — Vertical runner (Temple Run style): scroll axis = y; player in lower third; obstacles move top → bottom.
//

import SpriteKit
import GameplayKit

/// B4/P002 — Points per second for time-based vertical offset of obstacle/power-up/enemy sprites (move from top toward player).
private let SegmentScrollSpeed: CGFloat = 200

/// Scroller 10s — Max dimension (pt) for obstacle and enemy sprites; scale to avatar size, preserve aspect ratio.
private let SegmentSpriteMaxDimension: CGFloat = 44

/// Number of lanes (0–4); lane 2 is center. Used when EngineVariantConfig is not loaded.
let LaneCount = 5
/// Center lane index.
let CenterLaneIndex = 2

class GameScene: SKScene {

    /// Lane index (0–4) → x position. Lanes evenly spaced across scene width.
    private var laneXPositions: [CGFloat] = []
    /// P002 — Vertical runner: player and lane reference y (lower third); obstacles move from top toward this.
    private var laneY: CGFloat = 0

    /// C7 — Config from variant.json when available; nil → use LaneCount, CenterLaneIndex, default durations.
    private var engineConfig: EngineVariantConfig?
    /// B2 — Asset loader (assets.json → textures). Loaded once at startup; B3 uses for player texture.
    private(set) var assetConfig: AssetConfig?
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

    /// Scroller 10s — When true, segment end restarts same segment (same seed); no addSegmentCompleted. MVP: constant; config preferred later.
    private let scrollerLoop = true

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

    /// B5 — Background layer (sky + ground); zPosition below segment strip. Tiled vertically; positions updated from segment scroll.
    private let backgroundLayer = SKNode()
    /// B5 — Sky tile nodes for vertical tiling (scroll with segment).
    private var skyTileNodes: [SKSpriteNode] = []
    /// B5 — Ground tile nodes for vertical tiling (scroll with segment).
    private var groundTileNodes: [SKSpriteNode] = []
    /// B5 — Height of one sky tile (for tiling).
    private var skyTileHeight: CGFloat = 0
    /// B5 — Height of one ground tile (for tiling).
    private var groundTileHeight: CGFloat = 0

    /// B4 — Container for obstacle and power-up sprites; z-order below player. Cleared when segment advances.
    private let segmentStrip = SKNode()
    /// B4 — Sprites for current segment obstacles; positions updated each frame.
    private var obstacleSpriteNodes: [(ObstaclePlacement, SKSpriteNode)] = []
    /// B4 — Sprites for current segment power-up (if any); position updated each frame.
    private var powerUpSpriteNodes: [(PowerUpPlacement, SKSpriteNode)] = []
    /// P002 — Sprites for optional segment enemy (e.g. dog); position updated each frame.
    private var enemySpriteNodes: [(EnemyPlacement, SKSpriteNode)] = []

    /// C7 — Swipe detection.
    private var touchStartPosition: CGPoint?
    private let swipeMinDistance: CGFloat = 30

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        loadEngineConfig()
        assetConfig = AssetConfig.load(fromBundle: .main, subdirectory: "config/default")
        layoutLanes()
        setupBackgroundLayer()
        drawLaneLines()
        segmentStrip.name = "segmentStrip"
        segmentStrip.zPosition = 5
        addChild(segmentStrip)
        addPlayer()
        startSegment()
        triggerGameOverForE2EIfRequested()
    }

    /// E2E only: when launched with -ForceGameOver, trigger game over after a short delay so J3/J4/J5 are deterministic.
    private func triggerGameOverForE2EIfRequested() {
        guard ProcessInfo.processInfo.arguments.contains("ForceGameOver") else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self, !self.gameOverRequested else { return }
            self.gameOverRequested = true
            self.gameDelegate?.gameSceneDidRequestGameOver(self)
        }
    }

    /// B5 — Create background layer (zPosition < 5) with sky and ground from assetConfig; vertical tiling for scroll.
    private func setupBackgroundLayer() {
        backgroundLayer.name = "backgroundLayer"
        backgroundLayer.zPosition = 0
        addChild(backgroundLayer)

        let sceneW = size.width
        let sceneH = size.height
        let scrollRange = CGFloat(segmentDurationForTiling) * SegmentScrollSpeed
        let totalHeight = sceneH + scrollRange

        if let skyTex = assetConfig?.texture(forKey: "backgrounds.sky"), skyTex.size().height > 0 {
            let texSize = skyTex.size()
            skyTileHeight = texSize.height
            let tileW = max(texSize.width, sceneW)
            let tileH = texSize.height
            let nTiles = Int(ceil(totalHeight / tileH)) + 2
            for i in 0..<nTiles {
                let node = SKSpriteNode(texture: skyTex, color: .clear, size: CGSize(width: tileW, height: tileH))
                node.anchorPoint = CGPoint(x: 0.5, y: 0)
                node.name = "sky_\(i)"
                node.zPosition = 0
                node.position = CGPoint(x: size.width / 2, y: CGFloat(i) * tileH)
                backgroundLayer.addChild(node)
                skyTileNodes.append(node)
            }
        }

        if let groundTex = assetConfig?.texture(forKey: "backgrounds.ground"), groundTex.size().height > 0 {
            let texSize = groundTex.size()
            groundTileHeight = texSize.height
            let tileW = max(texSize.width, sceneW)
            let tileH = texSize.height
            let nTiles = Int(ceil(totalHeight / tileH)) + 2
            for i in 0..<nTiles {
                let node = SKSpriteNode(texture: groundTex, color: .clear, size: CGSize(width: tileW, height: tileH))
                node.anchorPoint = CGPoint(x: 0.5, y: 0)
                node.name = "ground_\(i)"
                node.zPosition = 1
                node.position = CGPoint(x: size.width / 2, y: CGFloat(i) * tileH)
                backgroundLayer.addChild(node)
                groundTileNodes.append(node)
            }
        }
    }

    /// B5 — Update background tile positions for vertical scroll (same speed as segment strip). Tiles placed in world Y; scroll offset moves them down.
    private func updateBackgroundPositions() {
        let scrollOffset = CGFloat(segmentTime) * SegmentScrollSpeed
        let centerX = size.width / 2

        for (i, node) in skyTileNodes.enumerated() where skyTileHeight > 0 {
            let worldY = CGFloat(i) * skyTileHeight - scrollOffset
            node.position = CGPoint(x: centerX, y: worldY)
        }

        for (i, node) in groundTileNodes.enumerated() where groundTileHeight > 0 {
            let worldY = CGFloat(i) * groundTileHeight - scrollOffset
            node.position = CGPoint(x: centerX, y: worldY)
        }
    }

    /// B5 — Segment duration (seconds) used to size tiling (e.g. 10–12 s). Fallback when no config.
    private var segmentDurationForTiling: TimeInterval {
        engineConfig?.segmentDurationConfig.maxDurationSeconds ?? 12
    }

    /// Load variant.json into engineConfig when available.
    private func loadEngineConfig() {
        engineConfig = try? EngineVariantConfig.load(fromBundle: .main, filename: "variant")
    }

    /// Compute lane → x mapping (evenly spaced). P002: player in lower third for vertical runner.
    private func layoutLanes() {
        let w = size.width
        let margin: CGFloat = 40
        let usable = w - 2 * margin
        let count = max(1, laneCount)
        let step = (count > 1) ? usable / CGFloat(count - 1) : 0
        laneXPositions = (0..<count).map { margin + CGFloat($0) * step }
        laneY = size.height * 0.28
    }

    /// Draw vertical lane lines for visibility. P002: from player upward to top of screen.
    private func drawLaneLines() {
        let top = size.height
        let bottom = laneY
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

    /// Add PlayerNode at playerStartLane (center when 5 lanes). C7: state and config-driven. B3: character.run texture when available.
    private func addPlayer() {
        let runTexture = assetConfig?.texture(forKey: "character.run")
        let player = PlayerNode(texture: runTexture)
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
            let enemy = EnemyPlacement(laneIndex: 0, typeId: "dog", timeOffset: 1.5)
            currentSegment = Segment(durationSeconds: 10.0, seed: 0, obstacles: [obs], powerUp: nil, enemy: enemy)
        }
        segmentTime = 0
        refreshSegmentSprites()
    }

    /// C8 — Advance to next segment (called when segment time exceeds duration).
    private func advanceToNextSegment() {
        scoreKeeper.addSegmentCompleted()
        currentSegmentIndex += 1
        startSegment()
    }

    /// Scroller 10s — Restart same segment (same seed); do not call addSegmentCompleted or increment segment index.
    private func restartCurrentSegment() {
        guard let segment = currentSegment else { return }
        powerUpCollectedInSegment = false
        let seed = segment.seed
        let idx = currentSegmentIndex
        if let config = engineConfig {
            let generator = SegmentGenerator(engineConfig: config)
            currentSegment = generator.generateSegment(seed: seed, segmentIndex: idx)
        } else {
            let obs = ObstaclePlacement(startLane: 2, laneSpan: 1, typeId: "passable", timeOffset: 1.0)
            let enemy = EnemyPlacement(laneIndex: 0, typeId: "dog", timeOffset: 1.5)
            currentSegment = Segment(durationSeconds: 10.0, seed: seed, obstacles: [obs], powerUp: nil, enemy: enemy)
        }
        checkpointSegmentIndex = idx
        checkpointSegmentSeed = seed
        segmentTime = 0
        refreshSegmentSprites()
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
        refreshSegmentSprites()
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

    // MARK: - B4 Obstacle and power-up sprites

    /// B4 — Map ObstaclePlacement.typeId to asset key (e.g. passable → obstacles.passable).
    private static func assetKeyForObstacle(typeId: String) -> String {
        "obstacles.\(typeId)"
    }

    /// B4 — Map PowerUpPlacement.typeId to asset key (e.g. speedBoost → powerups.speedBoost).
    private static func assetKeyForPowerUp(typeId: String) -> String {
        "powerups.\(typeId)"
    }

    /// B4 — Map EnemyPlacement.typeId to asset key (e.g. dog → enemies.dog). P002.
    private static func assetKeyForEnemy(typeId: String) -> String {
        "enemies.\(typeId)"
    }

    /// Scroller 10s — Scale size so max dimension ≤ SegmentSpriteMaxDimension; cap scale at 1.0 to never upscale.
    private static func scaledSpriteSize(textureSize: CGSize, maxDimension: CGFloat = SegmentSpriteMaxDimension) -> CGSize {
        let w = textureSize.width
        let h = textureSize.height
        let m = max(w, h)
        guard m > 0 else { return textureSize }
        let scale = min(maxDimension / m, 1.0)
        return CGSize(width: w * scale, height: h * scale)
    }

    /// B4 — Clear segment strip and create sprites for current segment obstacles, power-up, and optional enemy. Uses B2 loader; placeholder if texture nil.
    private func refreshSegmentSprites() {
        segmentStrip.removeAllChildren()
        obstacleSpriteNodes.removeAll()
        powerUpSpriteNodes.removeAll()
        enemySpriteNodes.removeAll()
        guard let segment = currentSegment else { return }

        let placeholderSize = CGSize(width: 40, height: 40)
        for obs in segment.obstacles {
            let key = Self.assetKeyForObstacle(typeId: obs.typeId)
            let texture = assetConfig?.texture(forKey: key)
            let node: SKSpriteNode
            if let texture = texture {
                let sz = Self.scaledSpriteSize(textureSize: texture.size())
                node = SKSpriteNode(texture: texture, color: .clear, size: sz)
            } else {
                node = SKSpriteNode(color: .orange, size: placeholderSize)
            }
            node.name = "obstacle_\(obs.typeId)"
            node.zPosition = 1
            segmentStrip.addChild(node)
            obstacleSpriteNodes.append((obs, node))
        }
        if let pu = segment.powerUp {
            let key = Self.assetKeyForPowerUp(typeId: pu.typeId)
            let texture = assetConfig?.texture(forKey: key)
            let node: SKSpriteNode
            if let texture = texture {
                node = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
            } else {
                node = SKSpriteNode(color: .systemGreen, size: placeholderSize)
            }
            node.name = "powerup_\(pu.typeId)"
            node.zPosition = 1
            segmentStrip.addChild(node)
            powerUpSpriteNodes.append((pu, node))
        }
        if let enemy = segment.enemy {
            let key = Self.assetKeyForEnemy(typeId: enemy.typeId)
            let texture = assetConfig?.texture(forKey: key)
            let node: SKSpriteNode
            if let texture = texture {
                let sz = Self.scaledSpriteSize(textureSize: texture.size())
                node = SKSpriteNode(texture: texture, color: .clear, size: sz)
            } else {
                node = SKSpriteNode(color: .purple, size: placeholderSize)
            }
            node.name = "enemy_\(enemy.typeId)"
            node.zPosition = 1
            segmentStrip.addChild(node)
            enemySpriteNodes.append((enemy, node))
        }
    }

    /// B4/P002 — Update sprite positions from segment time and lane layout (vertical time-based scroll: top → player).
    private func updateSegmentSpritePositions() {
        for (obs, node) in obstacleSpriteNodes {
            let centerX = (laneXPosition(for: obs.startLane) + laneXPosition(for: obs.startLane + obs.laneSpan - 1)) / 2
            let yOffset = CGFloat(obs.timeOffset - segmentTime) * SegmentScrollSpeed
            node.position = CGPoint(x: centerX, y: laneY + yOffset)
        }
        for (pu, node) in powerUpSpriteNodes {
            let centerX = laneXPosition(for: pu.laneIndex)
            let yOffset = CGFloat(pu.timeOffset - segmentTime) * SegmentScrollSpeed
            node.position = CGPoint(x: centerX, y: laneY + yOffset)
        }
        for (enemy, node) in enemySpriteNodes {
            let centerX = laneXPosition(for: enemy.laneIndex)
            let yOffset = CGFloat(enemy.timeOffset - segmentTime) * SegmentScrollSpeed
            node.position = CGPoint(x: centerX, y: laneY + yOffset)
        }
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
            if scrollerLoop {
                restartCurrentSegment()
            } else {
                advanceToNextSegment()
            }
            return
        }

        updateBackgroundPositions()
        updateSegmentSpritePositions()

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
