# B5 — Backgrounds (sky, ground) in scene

**Next hand off (cut & paste) — Lane A:** After B5: Tester confirms simulator — sky and ground visible behind gameplay; no new test failures. Optionally proceed to B6 (UI panels) per [asset-integration.plan.md](asset-integration.plan.md). Lane A may edit ios/ only.

---

## Goal

Render sky and ground from assets.json (`backgrounds.sky`, `backgrounds.ground`) as a background layer behind lanes and segment strip. B2 must be complete; AssetConfig already exposes `texture(forKey: "backgrounds.sky")` and `"backgrounds.ground"`.

## Steps

1. In GameScene, add a background container node (e.g. `backgroundLayer`) with zPosition below lane lines and segment strip (e.g. zPosition = 0 or 1; segment strip is 5, player above that).
2. After loading `assetConfig`, create SKSpriteNodes for `backgrounds.sky` and `backgrounds.ground` using `assetConfig.texture(forKey:)`. If a texture is nil, skip that layer or keep current `backgroundColor` as fallback.
3. Size and position: sky typically full-screen or top portion; ground as bottom portion or tiled. Use scene `size`; aspect of textures may require scaling (e.g. aspectFill) or tiling. Prefer simple full-rect placement first (one sky, one ground rect).
4. Add sky node first, then ground, so ground draws on top of sky if they overlap. Insert `backgroundLayer` in `didMove(to:)` before `segmentStrip` so it renders behind.

## Paths

- **Edited:** [ios/CatRunner/Game/GameScene.swift](../../../ios/CatRunner/Game/GameScene.swift).
- **Config:** [config/default/assets.json](../../../config/default/assets.json) already has `backgrounds.sky` and `backgrounds.ground`; no change required unless paths differ.

## Validation

- Run in simulator: sky and ground visible behind player/lanes/obstacles; collision and gameplay unchanged.
- Run iOS test suite: no new failures (baseline 58 tests).

## Rollback

- Remove background layer and node creation; restore or keep existing `backgroundColor` only.

## Confidence

- **Confidence (root cause):** N/A.
- **Confidence (solution path):** High.
