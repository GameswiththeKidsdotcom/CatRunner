//
//  GameSceneDelegate.swift
//  CatRunner
//
//  C7 — Delegate for game events: instant-fail (game-over/revive), power-up collected, slowdown.
//  Revive flow is implemented in C8; C7 only triggers the delegate or flag.
//

import Foundation

/// C7 — Notifies game-over/revive (C8), power-up collection, and slowdown. Revive flow is C8.
protocol GameSceneDelegate: AnyObject {
    /// Player hit an instant-fail obstacle. C8 implements game-over or revive.
    func gameSceneDidRequestGameOver(_ scene: GameScene)
    /// Player collected a power-up (typeId). C8 may apply effect (e.g. speedBoost, shield).
    func gameScene(_ scene: GameScene, didCollectPowerUp typeId: String)
    /// Player hit a slowdown obstacle. C8 may apply slowdown effect.
    func gameSceneDidTriggerSlowdown(_ scene: GameScene)
}
