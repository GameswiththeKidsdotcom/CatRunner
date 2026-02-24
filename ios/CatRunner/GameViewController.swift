//
//  GameViewController.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. C8 — GameSceneDelegate: revive offer and resume.
//  P002 — Design size and aspectFit so full gameplay area (avatar, lanes) is visible on all phones.
//  E2E — Lane tap regions with accessibilityIdentifier for JourneyTests (e2e-spec-journeys Investigation 4).
//

import UIKit
import SpriteKit
import GameplayKit

/// Width of left/right lane-tap overlay (pt). Narrow so swipes still hit the scene.
private let LaneTapOverlayWidth: CGFloat = 56

class GameViewController: UIViewController {

    private weak var gameScene: GameScene?
    private var skView: SKView!
    private var laneTapLeft: UIView?
    private var laneTapRight: UIView?

    override func loadView() {
        let container = UIView()
        let sk = SKView()
        skView = sk
        container.addSubview(sk)
        view = container
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        skView.accessibilityIdentifier = "GameView"
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        let scene = GameScene(size: DesignConstants.designSize)
        scene.scaleMode = .aspectFit
        scene.gameDelegate = self
        gameScene = scene
        skView.presentScene(scene)
        addLaneTapOverlays(to: view!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        skView?.frame = view.bounds
        // P003 Chunk 1 — Top safe area in scene coords (aspectFit) so score HUD sits below notch/Dynamic Island.
        let designW = DesignConstants.designSize.width
        let designH = DesignConstants.designSize.height
        let scale = min(view.bounds.width / designW, view.bounds.height / designH)
        let viewTop = (view.bounds.height - designH * scale) / 2
        let overlap = max(0, view.safeAreaInsets.top - viewTop)
        let topMarginScene = scale > 0 ? overlap / scale : 0
        gameScene?.setTopSafeAreaMargin(topMarginScene)
        layoutLaneTapOverlays()
    }

    /// E2E: overlay buttons as siblings of SKView for accessibility (e2e-spec-journeys Investigation 4).
    private func addLaneTapOverlays(to container: UIView) {
        let left = UIButton(type: .custom)
        left.isUserInteractionEnabled = true
        left.accessibilityIdentifier = "LaneTapLeft"
        left.accessibilityLabel = "Move lane left"
        left.backgroundColor = .clear
        left.translatesAutoresizingMaskIntoConstraints = false
        left.addTarget(self, action: #selector(handleLaneTapLeft), for: .touchUpInside)
        container.addSubview(left)
        laneTapLeft = left

        let right = UIButton(type: .custom)
        right.isUserInteractionEnabled = true
        right.accessibilityIdentifier = "LaneTapRight"
        right.accessibilityLabel = "Move lane right"
        right.backgroundColor = .clear
        right.translatesAutoresizingMaskIntoConstraints = false
        right.addTarget(self, action: #selector(handleLaneTapRight), for: .touchUpInside)
        container.addSubview(right)
        laneTapRight = right
        layoutLaneTapOverlays()
    }

    private func layoutLaneTapOverlays() {
        guard let left = laneTapLeft, let right = laneTapRight, let container = left.superview else { return }
        let w = container.bounds.width
        let h = container.bounds.height
        left.frame = CGRect(x: 0, y: 0, width: LaneTapOverlayWidth, height: max(h, 1))
        right.frame = CGRect(x: max(0, w - LaneTapOverlayWidth), y: 0, width: LaneTapOverlayWidth, height: max(h, 1))
    }

    @objc private func handleLaneTapLeft() {
        gameScene?.moveLaneLeft()
    }

    @objc private func handleLaneTapRight() {
        gameScene?.moveLaneRight()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - GameSceneDelegate (C8: game over → revive offer → resume or dismiss)

extension GameViewController: GameSceneDelegate {

    func gameSceneDidRequestGameOver(_ scene: GameScene) {
        showReviveOrGameOver(scene: scene)
    }

    func gameScene(_ scene: GameScene, didCollectPowerUp typeId: String) {
        // C8: multiplier applied in GameScene for speedBoost
    }

    func gameSceneDidTriggerSlowdown(_ scene: GameScene) {
        // Optional: apply slowdown effect
    }

    private func showReviveOrGameOver(scene: GameScene) {
        let title = scene.didBeatHighScoreThisRun ? "New record!" : "Game Over"
        let alert = UIAlertController(
            title: title,
            message: "Score: \(scene.currentScore) | High: \(scene.highScore)",
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "GameOverAlert"
        // Tier 2: Show "Watch ad" only when variant has revive IAP/ad. First-revive-only (SPEC §1): only once per run.
        if scene.isReviveMonetizationConfigured && !scene.hasRevivedThisRun {
            alert.addAction(UIAlertAction(title: "Watch ad", style: .default) { [weak scene] _ in
                scene?.resumeFromCheckpoint()
            })
        }
        alert.addAction(UIAlertAction(title: "Play again", style: .default) { [weak self] _ in
            self?.startNewGame()
        })
        alert.addAction(UIAlertAction(title: "No thanks", style: .cancel) { _ in })
        present(alert, animated: true)
    }

    /// Starts a new run (fresh GameScene). High score persists via ScoreKeeper UserDefaults.
    private func startNewGame() {
        guard let sk = skView else { return }
        let scene = GameScene(size: DesignConstants.designSize)
        scene.scaleMode = .aspectFit
        scene.gameDelegate = self
        gameScene = scene
        sk.presentScene(scene)
    }
}
