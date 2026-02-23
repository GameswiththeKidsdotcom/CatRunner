# P002 — Chunk V2: Avatar and enemy visibility

**Parent:** [P002-vertical-runner-viewport.plan.md](P002-vertical-runner-viewport.plan.md)

## Goal

Avatar and (when enabled) enemy sprites fully visible on all phones; design size + aspectFit; optional enemy placement in segment strip.

## Changes

- **Avatar:** Design size 393×852 pt portrait and `scaleMode = .aspectFit` in GameViewController so the full gameplay area is visible. GameScene layout uses `size`; player and lanes stay in view.
- **Enemies:** Optional enemy placement on `Segment` (lane + timeOffset); GameScene creates sprite from `assetConfig?.texture(forKey: "enemies.dog")` and moves with same y-scroll as obstacles. Segment + SegmentGenerator extended; GameScene adds enemy sprite(s) to segment strip.

**Files:** ios/CatRunner/Game/GameViewController.swift (design size, aspectFit); GameScene (layout, enemy sprite create/update); ios/CatRunner/Engine/Segment.swift (optional enemy); SegmentGenerator if present.

## Validation

Simulator shows avatar and (when enabled) enemy sprites; no regression in existing tests.

## Rollback

Revert design size/aspectFit and enemy rendering; re-run test suite and simulator check.

## Confidence (per-chunk fidelity)

- **Confidence (root cause):** 95% — Root cause: avatar/enemy visibility needed consistent viewport; design size + aspectFit and optional enemy placement verified in code.
- **Confidence (solution path):** 95% — Solution path implemented (DesignSize, aspectFit, EnemyPlacement, enemySpriteNodes).
- **Note:** Implementation matches plan; validation and rollback clear. No UI mockup scope; layout/code only.
