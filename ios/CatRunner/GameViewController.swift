//
//  GameViewController.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. C8 — GameSceneDelegate: revive offer and resume.
//  P002 — Design size and aspectFit so full gameplay area (avatar, lanes) is visible on all phones.
//

import UIKit
import SpriteKit
import GameplayKit

/// P002 — Design size (portrait) for consistent layout; aspectFit scales to fit all iPhones.
private let DesignSize = CGSize(width: 393, height: 852)

class GameViewController: UIViewController {

    private weak var gameScene: GameScene?

    override func loadView() {
        view = SKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            view.accessibilityIdentifier = "GameView"
            let scene = GameScene(size: DesignSize)
            scene.scaleMode = .aspectFit
            scene.gameDelegate = self
            gameScene = scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
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
        let alert = UIAlertController(
            title: "Game Over",
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
        guard let view = view as? SKView else { return }
        let scene = GameScene(size: DesignSize)
        scene.scaleMode = .aspectFit
        scene.gameDelegate = self
        gameScene = scene
        view.presentScene(scene)
    }
}
