//
//  GameViewController.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. C8 — GameSceneDelegate: revive offer and resume.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private weak var gameScene: GameScene?

    override func loadView() {
        view = SKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
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
        alert.addAction(UIAlertAction(title: "Revive", style: .default) { [weak scene] _ in
            scene?.resumeFromCheckpoint()
        })
        alert.addAction(UIAlertAction(title: "Done", style: .cancel) { _ in })
        present(alert, animated: true)
    }
}
