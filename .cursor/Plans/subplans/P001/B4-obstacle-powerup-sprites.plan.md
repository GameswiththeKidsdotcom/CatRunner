# B4 — Obstacle and power-up sprites in scene

**Next hand off (cut & paste) — Lane A:** B4 verified (iOS 58/58 pass; manual: confirm obstacle and power-up sprites visible in simulator). Optionally proceed to B5 (backgrounds) per [asset-integration.plan.md](asset-integration.plan.md) and [B5-backgrounds.plan.md](B5-backgrounds.plan.md). Lane A may edit ios/ only.

---

## Goal

For the current segment, obstacle and power-up placements are visible as SKSpriteNodes using the textures from assets.json (obstacles.passable, .instantFail, .slowdown, powerups.speedBoost, .shield). B2 must be complete so the asset loader is available.

## Steps

1. Add a layer or node (e.g. "segment strip") that creates/updates sprite nodes for `currentSegment.obstacles` and `currentSegment.powerUp` based on segment time and lane positions. Position sprites so they align with lanes using existing `laneXPosition(for:)`, laneY, and time-based x or scroll (match game’s segment-time progression).
2. Map `ObstaclePlacement.typeId` and `PowerUpPlacement.typeId` to asset keys (passable, instantFail, slowdown, speedBoost, shield) and get textures from the B2 loader.
3. Create/remove or recycle SKSpriteNodes as segment advances: when advancing to next segment, clear old sprites; when in segment, show only obstacles/power-up in the visible time window. Keep z-order below player.
4. If a texture is missing, use a simple placeholder (e.g. colored rect) so logic is unchanged.

## Paths

- **Edited:** [ios/CatRunner/Game/GameScene.swift](../../../ios/CatRunner/Game/GameScene.swift) (and optionally a new node type under Game/ or Engine/ for the segment strip).

## Validation

- Run in simulator; see obstacle and power-up sprites in lanes; collision behavior unchanged. After B4: Tester confirms player and obstacle/power-up sprites visible, no new test failures.

## Rollback

- Remove obstacle/power-up sprite creation; keep collision logic as-is.

## Confidence

- **Confidence (root cause):** N/A.
- **Confidence (solution path):** High.
