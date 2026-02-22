//
//  GameScene.swift
//  CatRunner
//
//  C1 — Xcode Bootstrap. 5 horizontal lanes (0–4), lane 2 = center; player at lane 2.
//

import SpriteKit
import GameplayKit

/// Number of lanes (0–4); lane 2 is center.
let LaneCount = 5
/// Center lane index.
let CenterLaneIndex = 2

class GameScene: SKScene {

    /// Lane index (0–4) → x position. Lanes evenly spaced across scene width.
    private var laneXPositions: [CGFloat] = []
    /// Vertical center for player and lane lines.
    private var laneY: CGFloat = 0

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        layoutLanes()
        drawLaneLines()
        addPlayer()
    }

    /// Compute lane → x mapping (evenly spaced). Uses safe area inset if available.
    private func layoutLanes() {
        let w = size.width
        let margin: CGFloat = 40
        let usable = w - 2 * margin
        let step = usable / CGFloat(LaneCount - 1)
        laneXPositions = (0..<LaneCount).map { margin + CGFloat($0) * step }
        laneY = size.height * 0.5
    }

    /// Draw 5 vertical lane lines for visibility.
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

    /// Add PlayerNode at lane 2 (center).
    private func addPlayer() {
        let player = PlayerNode()
        let x = laneXPosition(for: CenterLaneIndex)
        player.position = CGPoint(x: x, y: laneY)
        addChild(player)
    }

    /// Lane index (0–4) → x position.
    func laneXPosition(for laneIndex: Int) -> CGFloat {
        guard laneIndex >= 0, laneIndex < laneXPositions.count else {
            return laneXPositions[CenterLaneIndex]
        }
        return laneXPositions[laneIndex]
    }
}
