//
//  DesignConstants.swift
//  CatRunner
//
//  T5-C1 — Single source for design size (393×852). Used by GameViewController and GameScene-related tests.
//  T5-C2 — Single source for time epsilon (0.2) used by CollisionSystem and PowerUpSpawner.
//  T5-C3 — Single source for default lane count (5) and center lane index (2).
//  T5-C5 — Segment-time margin fraction (0.1): keep obstacles/power-ups away from segment start/end.
//

import CoreGraphics
import Foundation

/// Design size (portrait) for consistent layout; aspectFit scales to fit all iPhones. P002.
enum DesignConstants {
    static let designSize = CGSize(width: 393, height: 852)

    /// Time window (seconds) for overlap: obstacle/power-up collision and power-up placement vs obstacles. T5-C2.
    static let timeEpsilon: TimeInterval = 0.2

    /// Default number of lanes (0-indexed: 0..<defaultLaneCount). T5-C3.
    static let defaultLaneCount = 5
    /// Default center lane index (for 5 lanes, center = 2). T5-C3.
    static let defaultCenterLaneIndex = 2

    /// Fraction of segment duration used as margin at start/end; valid placement range is [margin, duration - margin]. T5-C5.
    static let segmentTimeMarginFraction: Double = 0.1
}
