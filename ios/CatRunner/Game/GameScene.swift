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

/// Scroller 10s — Max dimension (pt) for obstacle and enemy sprites; scale to avatar size, preserve aspect ratio. Increased 25% (88 → 110) so obstacle art is clearly visible.
private let SegmentSpriteMaxDimension: CGFloat = 110

class GameScene: SKScene {

    /// Lane index (0–4) → x position. Lanes evenly spaced across scene width.
    private var laneXPositions: [CGFloat] = []
    /// P002 — Vertical runner: player and lane reference y (lower third); obstacles move from top toward this.
    private var laneY: CGFloat = 0

    /// C7 — Config from variant.json when available; nil → use DesignConstants.defaultLaneCount, defaultCenterLaneIndex, default durations.
    private var engineConfig: EngineVariantConfig?
    /// B2 — Asset loader (assets.json → textures). Loaded once at startup; B3 uses for player texture.
    private(set) var assetConfig: AssetConfig?
    /// C7 — Effective lane count (from config or default).
    private var laneCount: Int { engineConfig?.laneCount ?? DesignConstants.defaultLaneCount }
    /// C7 — Jump duration from config or default.
    private var jumpDuration: TimeInterval { engineConfig?.jumpDurationSeconds ?? PlayerNode.defaultJumpDuration }
    /// C7 — Slide duration from config or default.
    private var slideDuration: TimeInterval { engineConfig?.slideDurationSeconds ?? PlayerNode.defaultSlideDuration }
    /// C7 — Player start lane from config or default.
    private var playerStartLane: Int { engineConfig?.playerStartLane ?? DesignConstants.defaultCenterLaneIndex }

    /// C7 — Player node (set in addPlayer).
    private weak var playerNode: PlayerNode?
    /// C2 — Container for player + shadow; moves with lane; player jumps relative to this.
    private var playerContainerNode: SKNode?

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
    /// DifficultySpawnRamp — Total elapsed game time (seconds); drives spawn rate. Reset on new run; restored on revive.
    private var totalElapsedTime: TimeInterval = 0
    /// DifficultySpawnRamp — Elapsed time at checkpoint (for revive); restored to totalElapsedTime on resumeFromCheckpoint.
    private var checkpointElapsedTime: TimeInterval = 0

    /// Logic-test (DifficultySpawnRamp): Read-only access for tests to assert totalElapsedTime / checkpoint after revive, advance, restart.
    internal var totalElapsedTimeForTesting: TimeInterval { totalElapsedTime }
    internal var checkpointElapsedTimeForTesting: TimeInterval { checkpointElapsedTime }
    internal func advanceToNextSegmentForTesting() { advanceToNextSegment() }
    internal func restartCurrentSegmentForTesting() { restartCurrentSegment() }
    /// Right-lane-tap bug: expose container position for boundary no-op test.
    internal var playerContainerPositionForTesting: CGPoint? { playerContainerNode?.position }

    /// C8 — Score and high score; multiplier from power-up (e.g. speedBoost).
    private let scoreKeeper = ScoreKeeper()
    /// Expose current score and high score for UI.
    var currentScore: Int { scoreKeeper.currentScore }
    var highScore: Int { scoreKeeper.highScore }
    /// P003 Chunk 2 — True when this run beat the previous high score; used for game-over "New record!" alert.
    var didBeatHighScoreThisRun: Bool { scoreKeeper.didBeatHighScoreThisRun }

    /// First-revive-only (SPEC §1): true after user has used "Watch ad" this run; gates second "Watch ad" offer. Reset on new run (new GameScene).
    private(set) var hasRevivedThisRun: Bool = false

    /// Tier 2 — True when variant has at least one revive monetization option (IAP or rewarded ad). When false, game-over dialog omits "Watch ad".
    var isReviveMonetizationConfigured: Bool {
        guard let mon = engineConfig?.monetization else { return false }
        return (mon.reviveIAPProductId != nil && !(mon.reviveIAPProductId?.isEmpty ?? true))
            || (mon.rewardedAdPlacementId != nil && !(mon.rewardedAdPlacementId?.isEmpty ?? true))
    }

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
    /// B4 — Containers (shadow + sprite) for current segment obstacles; positions updated each frame. C2: container holds shadow (z 0) and sprite (z 1).
    private var obstacleSpriteNodes: [(ObstaclePlacement, SKNode)] = []
    /// B4 — Containers for current segment power-up (if any); position updated each frame.
    private var powerUpSpriteNodes: [(PowerUpPlacement, SKNode)] = []
    /// P002 — Containers for optional segment enemy (e.g. dog); position updated each frame.
    private var enemySpriteNodes: [(EnemyPlacement, SKNode)] = []

    /// C7 — Swipe detection.
    private var touchStartPosition: CGPoint?
    private let swipeMinDistance: CGFloat = 30

    /// Tier 4 — In-game score HUD (read-only). Shown during gameplay; game-over alert also shows score.
    private let scoreHUDLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
    /// P003 Chunk 1 — Top safe area margin in scene coords (e.g. below Dynamic Island). Fallback until VC sets it.
    private var topSafeAreaMargin: CGFloat = 24
    /// P003 Chunk 2 — One-time in-game "New high score!" celebration; shown once per run when score beats previous high.
    private var hasShownNewHighScoreCelebration: Bool = false

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
        setupScoreHUD()
        startSegment()
        triggerGameOverForE2EIfRequested()
        // #region agent log
        CollisionSystem.collisionDebugLog = { [weak self] obs, hitResult, playerLane, isJumping, isSliding, segTime in
            let hitStr: String
            switch hitResult {
            case .miss: hitStr = "miss"
            case .hitPassable: hitStr = "hitPassable"
            case .hitSlowdown: hitStr = "hitSlowdown"
            case .hitInstantFail: hitStr = "hitInstantFail"
            }
            let hypothesisId: String
            if obs.typeId == "instantFail" && !isSliding { hypothesisId = "A" }
            else if (obs.typeId == "passable" || obs.typeId == "slowdown") && !isJumping { hypothesisId = "B" }
            else if hitResult == .miss { hypothesisId = "success" }
            else { hypothesisId = "other" }
            let payload: [String: Any] = [
                "sessionId": "ed5bd7",
                "location": "GameScene:collisionLog",
                "message": "collision overlap",
                "data": [
                    "typeId": obs.typeId,
                    "startLane": obs.startLane,
                    "laneSpan": obs.laneSpan,
                    "timeOffset": obs.timeOffset,
                    "playerLane": playerLane,
                    "isJumping": isJumping,
                    "isSliding": isSliding,
                    "segmentTime": segTime,
                    "hitResult": hitStr
                ],
                "timestamp": Int64(Date().timeIntervalSince1970 * 1000),
                "hypothesisId": hypothesisId
            ]
            guard let url = URL(string: "http://127.0.0.1:7781/ingest/228ee501-d47f-4f54-bb0d-c641d99d4416"),
                  let body = try? JSONSerialization.data(withJSONObject: payload) else { return }
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("ed5bd7", forHTTPHeaderField: "X-Debug-Session-Id")
            req.httpBody = body
            URLSession.shared.dataTask(with: req).resume()
        }
        // #endregion
    }

    /// P003 Chunk 1 — In-scene offset (pt) from safe-area bottom to HUD (label top).
    private static let scoreHUDInsetBelowMargin: CGFloat = 24

    /// Tier 4 — In-game score HUD at top of scene. P003: position uses topSafeAreaMargin. Updated each frame in update().
    private func setupScoreHUD() {
        scoreHUDLabel.name = "scoreHUD"
        scoreHUDLabel.fontSize = 20
        scoreHUDLabel.fontColor = .white
        scoreHUDLabel.horizontalAlignmentMode = .center
        scoreHUDLabel.verticalAlignmentMode = .top
        applyScoreHUDPosition()
        scoreHUDLabel.zPosition = 100
        addChild(scoreHUDLabel)
        updateScoreHUD()
    }

    /// P003 Chunk 1 — Set top safe area margin (scene coords) and update HUD position. Call from VC in viewDidLayoutSubviews.
    func setTopSafeAreaMargin(_ margin: CGFloat) {
        topSafeAreaMargin = margin
        if scoreHUDLabel.parent != nil {
            applyScoreHUDPosition()
        }
    }

    /// P003 Chunk 1 — HUD y = top of scene minus safe margin minus inset.
    private func applyScoreHUDPosition() {
        scoreHUDLabel.position = CGPoint(x: size.width / 2, y: size.height - topSafeAreaMargin - Self.scoreHUDInsetBelowMargin)
    }

    private func updateScoreHUD() {
        scoreHUDLabel.text = "Score: \(currentScore) | High: \(highScore)"
    }

    /// P003 Chunk 2 — Show one-time "New high score!" label below score HUD; fades out after 2.5s.
    private func showNewHighScoreCelebration() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.name = "newHighScoreCelebration"
        label.text = "New high score!"
        label.fontSize = 24
        label.fontColor = .yellow
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .top
        label.position = CGPoint(x: size.width / 2, y: scoreHUDLabel.position.y - 28)
        label.zPosition = 99
        addChild(label)
        let wait = SKAction.wait(forDuration: 2.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        label.run(SKAction.sequence([wait, fadeOut, remove]))
    }

    /// E2E only: when launched with -ForceGameOver, trigger game over after a short delay so J3/J4/J5 are deterministic. ForceSecondGameOver: also trigger again after 4s for J4 second-game-over path.
    private func triggerGameOverForE2EIfRequested() {
        let args = ProcessInfo.processInfo.arguments
        guard args.contains("ForceGameOver") else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self, !self.gameOverRequested else { return }
            self.gameOverRequested = true
            self.gameDelegate?.gameSceneDidRequestGameOver(self)
        }
        guard args.contains("ForceSecondGameOver") else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
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

    /// T5-C4 — Fallback segment when engineConfig is nil (no variant.json). Single source for 10s duration, one passable obstacle, one dog enemy.
    private static func makeFallbackSegment(seed: UInt64) -> Segment {
        let obs = ObstaclePlacement(startLane: DesignConstants.defaultCenterLaneIndex, laneSpan: 1, typeId: "passable", timeOffset: 1.0)
        let enemy = EnemyPlacement(laneIndex: 0, typeId: "dog", timeOffset: 1.5)
        return Segment(durationSeconds: 10.0, seed: seed, obstacles: [obs], powerUp: nil, enemy: enemy)
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

    /// Draw vertical lane lines for visibility. P002: from player upward to top of screen. Visual lanes: clearer lines and optional lane bands so obstacles clearly show which lane they're in.
    private func drawLaneLines() {
        let top = size.height
        let bottom = laneY
        let laneHeight = top - bottom
        // Subtle lane bands (alternating) so each lane is visually distinct
        for i in 0..<laneXPositions.count {
            let x = laneXPositions[i]
            let left = i > 0 ? (laneXPositions[i - 1] + x) / 2 : x - (laneXPositions.count > 1 ? (laneXPositions[1] - laneXPositions[0]) / 2 : 20)
            let right = i < laneXPositions.count - 1 ? (x + laneXPositions[i + 1]) / 2 : x + (laneXPositions.count > 1 ? (laneXPositions[laneXPositions.count - 1] - laneXPositions[laneXPositions.count - 2]) / 2 : 20)
            let bandPath = CGMutablePath()
            bandPath.move(to: CGPoint(x: left, y: bottom))
            bandPath.addLine(to: CGPoint(x: left, y: top))
            bandPath.addLine(to: CGPoint(x: right, y: top))
            bandPath.addLine(to: CGPoint(x: right, y: bottom))
            bandPath.closeSubpath()
            let band = SKShapeNode(path: bandPath)
            band.fillColor = (i % 2 == 0) ? SKColor.white.withAlphaComponent(0.03) : SKColor.white.withAlphaComponent(0.01)
            band.strokeColor = .clear
            band.name = "laneBand_\(i)"
            band.zPosition = 4.5
            addChild(band)
        }
        // Clear vertical lane dividers
        for (i, x) in laneXPositions.enumerated() {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: x, y: bottom))
            path.addLine(to: CGPoint(x: x, y: top))
            let line = SKShapeNode(path: path)
            line.strokeColor = SKColor.white.withAlphaComponent(0.5)
            line.lineWidth = 2.5
            line.name = "lane_\(i)"
            line.zPosition = 6
            addChild(line)
        }
    }

    /// Add PlayerNode at playerStartLane (center when 5 lanes). C7: state and config-driven. B3: character.run texture when available. C3: run/jump/slide textures. C2: anchor (0.5,0), shadow, container so shadow stays on ground during jump.
    private func addPlayer() {
        let runTexture = assetConfig?.texture(forKey: "character.run")
        let jumpTexture = assetConfig?.texture(forKey: "character.jump")
        let slideTexture = assetConfig?.texture(forKey: "character.slide")
        let runFrameTextures = assetConfig?.runFrameTextures()
        let jumpFrameTextures = assetConfig?.jumpFrameTextures()
        let slideFrameTextures = assetConfig?.slideFrameTextures()
        let player = PlayerNode(runTexture: runTexture, jumpTexture: jumpTexture, slideTexture: slideTexture, runFrameTextures: runFrameTextures, jumpFrameTextures: jumpFrameTextures, slideFrameTextures: slideFrameTextures)
        player.anchorPoint = CGPoint(x: 0.5, y: 0)
        let lane = playerStartLane
        let x = laneXPosition(for: lane)
        let container = SKNode()
        container.position = CGPoint(x: x, y: laneY)
        Self.addShadowUnderSprite(player, container: container)
        container.addChild(player)
        addChild(container)
        player.restPositionY = laneY
        player.setInitialLane(lane, laneCount: laneCount)
        player.name = "player"
        player.containerNode = container
        playerContainerNode = container
        player.startRunCycleIfNeeded()
        playerNode = player
    }

    /// Start or restart current segment. C8: uses segment index for difficulty; saves checkpoint for revive. DifficultySpawnRamp: passes totalElapsedTime for spawn rate.
    private func startSegment() {
        powerUpCollectedInSegment = false
        if currentSegmentIndex == 0 {
            totalElapsedTime = 0
        }
        checkpointElapsedTime = totalElapsedTime
        if let config = engineConfig {
            let generator = SegmentGenerator(engineConfig: config)
            let seed = UInt64(bitPattern: Int64(currentSegmentIndex))
            currentSegment = generator.generateSegment(seed: seed, segmentIndex: currentSegmentIndex, elapsedTimeAtSegmentStart: totalElapsedTime)
            checkpointSegmentIndex = currentSegmentIndex
            checkpointSegmentSeed = seed
        } else {
            currentSegment = Self.makeFallbackSegment(seed: UInt64(bitPattern: Int64(currentSegmentIndex)))
        }
        segmentTime = 0
        refreshSegmentSprites()
    }

    /// C8 — Advance to next segment (called when segment time exceeds duration). DifficultySpawnRamp: add current segment duration to totalElapsedTime before starting next.
    private func advanceToNextSegment() {
        totalElapsedTime += currentSegment?.durationSeconds ?? 0
        scoreKeeper.addSegmentCompleted()
        currentSegmentIndex += 1
        startSegment()
    }

    /// Scroller 10s — Restart same segment (same seed); do not call addSegmentCompleted or increment segment index. DifficultySpawnRamp: do not add segment duration to totalElapsedTime.
    private func restartCurrentSegment() {
        guard let segment = currentSegment else { return }
        powerUpCollectedInSegment = false
        let seed = segment.seed
        let idx = currentSegmentIndex
        if let config = engineConfig {
            let generator = SegmentGenerator(engineConfig: config)
            currentSegment = generator.generateSegment(seed: seed, segmentIndex: idx, elapsedTimeAtSegmentStart: totalElapsedTime)
        } else {
            currentSegment = Self.makeFallbackSegment(seed: seed)
        }
        checkpointSegmentIndex = idx
        checkpointSegmentSeed = seed
        segmentTime = 0
        refreshSegmentSprites()
    }

    /// C8 — Resume from last checkpoint after revive. Clears game over, restores segment and player. First-revive-only: marks hasRevivedThisRun. DifficultySpawnRamp: restore totalElapsedTime from checkpoint so spawn rate stays correct.
    func resumeFromCheckpoint() {
        hasRevivedThisRun = true
        gameOverRequested = false
        totalElapsedTime = checkpointElapsedTime
        currentSegmentIndex = checkpointSegmentIndex
        if let config = engineConfig {
            let generator = SegmentGenerator(engineConfig: config)
            currentSegment = generator.generateSegment(seed: checkpointSegmentSeed, segmentIndex: checkpointSegmentIndex, elapsedTimeAtSegmentStart: totalElapsedTime)
        }
        segmentTime = 0
        refreshSegmentSprites()
        playerNode?.moveToLane(playerStartLane, laneCount: laneCount, xPosition: laneXPosition(for: playerStartLane))
    }

    /// Lane index (0..<laneCount) → x position.
    func laneXPosition(for laneIndex: Int) -> CGFloat {
        guard laneIndex >= 0, laneIndex < laneXPositions.count else {
            let center = min(DesignConstants.defaultCenterLaneIndex, laneCount - 1)
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

    /// C2 — Add procedural shadow under a sprite. Shadow is a dark ellipse; add as sibling (z 0) so it renders behind sprite (z 1).
    private static func addShadowUnderSprite(_ sprite: SKSpriteNode, container: SKNode) {
        let w = sprite.size.width
        let h = sprite.size.height
        let shadowW = w * 1.2
        let shadowH: CGFloat = 10
        let shadow = SKSpriteNode(color: .black.withAlphaComponent(0.3), size: CGSize(width: shadowW, height: shadowH))
        shadow.name = "spriteShadow"
        shadow.zPosition = 0
        shadow.position = CGPoint(x: 0, y: -4)
        container.addChild(shadow)
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
            let sprite: SKSpriteNode
            if let texture = texture {
                let sz = Self.scaledSpriteSize(textureSize: texture.size())
                sprite = SKSpriteNode(texture: texture, color: .clear, size: sz)
            } else {
                sprite = SKSpriteNode(color: .orange, size: placeholderSize)
            }
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            sprite.name = "obstacle_\(obs.typeId)"
            sprite.zPosition = 1
            let container = SKNode()
            Self.addShadowUnderSprite(sprite, container: container)
            container.addChild(sprite)
            segmentStrip.addChild(container)
            let spriteH = sprite.size.height
            let helpLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
            helpLabel.name = "helpLabel"
            helpLabel.fontSize = 14
            helpLabel.fontColor = .white
            helpLabel.horizontalAlignmentMode = .center
            if obs.typeId == "instantFail" {
                helpLabel.text = "Slide"
                helpLabel.verticalAlignmentMode = .bottom
                helpLabel.position = CGPoint(x: 0, y: spriteH / 2 + 6)
            } else {
                helpLabel.text = "Jump"
                helpLabel.verticalAlignmentMode = .top
                helpLabel.position = CGPoint(x: 0, y: -spriteH / 2 - 6)
            }
            sprite.addChild(helpLabel)
            obstacleSpriteNodes.append((obs, container))
        }
        if let pu = segment.powerUp {
            let key = Self.assetKeyForPowerUp(typeId: pu.typeId)
            let texture = assetConfig?.texture(forKey: key)
            let sprite: SKSpriteNode
            if let texture = texture {
                sprite = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
            } else {
                sprite = SKSpriteNode(color: .systemGreen, size: placeholderSize)
            }
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            sprite.name = "powerup_\(pu.typeId)"
            sprite.zPosition = 1
            let container = SKNode()
            Self.addShadowUnderSprite(sprite, container: container)
            container.addChild(sprite)
            segmentStrip.addChild(container)
            powerUpSpriteNodes.append((pu, container))
        }
        if let enemy = segment.enemy {
            let key = Self.assetKeyForEnemy(typeId: enemy.typeId)
            let texture = assetConfig?.texture(forKey: key)
            let sprite: SKSpriteNode
            if let texture = texture {
                let sz = Self.scaledSpriteSize(textureSize: texture.size())
                sprite = SKSpriteNode(texture: texture, color: .clear, size: sz)
            } else {
                sprite = SKSpriteNode(color: .purple, size: placeholderSize)
            }
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            sprite.name = "enemy_\(enemy.typeId)"
            sprite.zPosition = 1
            let container = SKNode()
            Self.addShadowUnderSprite(sprite, container: container)
            container.addChild(sprite)
            segmentStrip.addChild(container)
            enemySpriteNodes.append((enemy, container))
        }
    }

    /// B4/P002 — Update sprite positions from segment time and lane layout (vertical time-based scroll: top → player). C2: positions are container nodes.
    private func updateSegmentSpritePositions() {
        for (obs, container) in obstacleSpriteNodes {
            let centerX = (laneXPosition(for: obs.startLane) + laneXPosition(for: obs.startLane + obs.laneSpan - 1)) / 2
            let yOffset = CGFloat(obs.timeOffset - segmentTime) * SegmentScrollSpeed
            container.position = CGPoint(x: centerX, y: laneY + yOffset)
        }
        for (pu, container) in powerUpSpriteNodes {
            let centerX = laneXPosition(for: pu.laneIndex)
            let yOffset = CGFloat(pu.timeOffset - segmentTime) * SegmentScrollSpeed
            container.position = CGPoint(x: centerX, y: laneY + yOffset)
        }
        for (enemy, container) in enemySpriteNodes {
            let centerX = laneXPosition(for: enemy.laneIndex)
            let yOffset = CGFloat(enemy.timeOffset - segmentTime) * SegmentScrollSpeed
            container.position = CGPoint(x: centerX, y: laneY + yOffset)
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
        let nextClamped = min(max(0, next), laneCount - 1)
        guard nextClamped != player.currentLaneIndex else { return }
        _ = player.moveToLane(nextClamped, laneCount: laneCount, xPosition: laneXPosition(for: nextClamped))
    }

    private func triggerLaneRight() {
        guard let player = playerNode else { return }
        let next = player.currentLaneIndex + 1
        let nextClamped = min(max(0, next), laneCount - 1)
        guard nextClamped != player.currentLaneIndex else { return }
        _ = player.moveToLane(nextClamped, laneCount: laneCount, xPosition: laneXPosition(for: nextClamped))
    }

    /// E2E / accessibility: tap-to-move lane left. Used by LaneTapLeft overlay in GameViewController.
    func moveLaneLeft() {
        triggerLaneLeft()
    }

    /// E2E / accessibility: tap-to-move lane right. Used by LaneTapRight overlay in GameViewController.
    func moveLaneRight() {
        triggerLaneRight()
    }

    // MARK: - C7 Game loop and collision

    override func update(_ currentTime: TimeInterval) {
        updateScoreHUD()
        if didBeatHighScoreThisRun, !hasShownNewHighScoreCelebration {
            hasShownNewHighScoreCelebration = true
            showNewHighScoreCelebration()
        }
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
