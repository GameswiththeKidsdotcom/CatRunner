//
//  AssetConfig.swift
//  CatRunner
//
//  B2 — Load assets.json from bundle; resolve path keys (e.g. character.run) to SKTexture.
//

import Foundation
import SpriteKit
import UIKit

/// B2 — Asset path map decoded from config/default/assets.json. Load once; resolve paths to SKTexture.
struct AssetConfig {

    private let root: AssetConfigRoot
    private let bundle: Bundle

    /// Flattened key → path for lookup (e.g. "character.run" → "assets/character/cat_run.png").
    private var pathByKey: [String: String] {
        var out: [String: String] = [:]
        if let run = root.character?.run { out["character.run"] = run }
        if let p = root.obstacles?.passable { out["obstacles.passable"] = p }
        if let i = root.obstacles?.instantFail { out["obstacles.instantFail"] = i }
        if let s = root.obstacles?.slowdown { out["obstacles.slowdown"] = s }
        if let d = root.enemies?.dog { out["enemies.dog"] = d }
        if let sky = root.backgrounds?.sky { out["backgrounds.sky"] = sky }
        if let ground = root.backgrounds?.ground { out["backgrounds.ground"] = ground }
        if let sb = root.powerups?.speedBoost { out["powerups.speedBoost"] = sb }
        if let sh = root.powerups?.shield { out["powerups.shield"] = sh }
        if let r = root.ui?.revivePanel { out["ui.revivePanel"] = r }
        if let g = root.ui?.gameOver { out["ui.gameOver"] = g }
        if let sc = root.ui?.scorePanel { out["ui.scorePanel"] = sc }
        return out
    }

    /// Load assets.json from bundle (subdirectory config/default per B1). Returns nil if file missing or decode fails.
    static func load(fromBundle bundle: Bundle = .main, subdirectory: String = "config/default") -> AssetConfig? {
        guard let url = bundle.url(forResource: "assets", withExtension: "json", subdirectory: subdirectory) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url),
              let root = try? JSONDecoder().decode(AssetConfigRoot.self, from: data) else {
            return nil
        }
        return AssetConfig(root: root, bundle: bundle)
    }

    /// Resolve logical key (e.g. "character.run") to SKTexture. Returns nil if key unknown or file missing.
    func texture(forKey key: String) -> SKTexture? {
        guard let path = pathByKey[key] else { return nil }
        return texture(for: path)
    }

    /// Resolve bundle-relative path (e.g. "assets/character/cat_run.png") to SKTexture. Returns nil if file missing.
    func texture(for path: String) -> SKTexture? {
        let pathExt = (path as NSString).pathExtension
        let ext = pathExt.isEmpty ? nil : pathExt
        let withoutExt = (path as NSString).deletingPathExtension
        let filename = (withoutExt as NSString).lastPathComponent
        let subdir = (path as NSString).deletingLastPathComponent
        let directory = (subdir as NSString).length > 0 ? subdir : nil

        guard let url = bundle.url(forResource: filename, withExtension: ext, subdirectory: directory),
              let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        return SKTexture(image: image)
    }

    private init(root: AssetConfigRoot, bundle: Bundle) {
        self.root = root
        self.bundle = bundle
    }
}

// MARK: - Codable (mirrors config/default/assets.json)

private struct AssetConfigRoot: Decodable {
    let character: CharacterBranch?
    let obstacles: ObstaclesBranch?
    let enemies: EnemiesBranch?
    let backgrounds: BackgroundsBranch?
    let powerups: PowerupsBranch?
    let ui: UIBranch?
    let appIcon: String?
}

private struct CharacterBranch: Decodable {
    let run: String?
}

private struct ObstaclesBranch: Decodable {
    let passable: String?
    let instantFail: String?
    let slowdown: String?
}

private struct EnemiesBranch: Decodable {
    let dog: String?
}

private struct BackgroundsBranch: Decodable {
    let sky: String?
    let ground: String?
}

private struct PowerupsBranch: Decodable {
    let speedBoost: String?
    let shield: String?
}

private struct UIBranch: Decodable {
    let revivePanel: String?
    let gameOver: String?
    let scorePanel: String?
}
