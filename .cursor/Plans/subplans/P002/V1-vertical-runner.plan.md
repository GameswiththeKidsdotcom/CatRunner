# P002 — Chunk V1: Vertical runner (Temple Run style)

**Parent:** [P002-vertical-runner-viewport.plan.md](P002-vertical-runner-viewport.plan.md)

## Goal

Single scroll axis = **vertical**. Player fixed in lower portion; obstacles/track move **toward** the player (top → bottom). Lanes remain left–right; swipe left/right to change lane (unchanged).

## Changes

- **Scroll axis:** In `updateSegmentSpritePositions()`, drive position by **y**. Obstacles/power-ups start above the player and move downward as `segmentTime` increases. Formula: `yOffset = (timeOffset - segmentTime) * SegmentScrollSpeed`; `node.position = CGPoint(x: centerX, y: laneY + yOffset)`.
- **Player position:** Place player in lower third (`laneY = size.height * 0.28`). Lane line vertical extent from laneY to top of screen.
- **Segment strip:** One strip; only position update logic changes (y-based). Collision and segment-time logic unchanged.

**Files:** ios/CatRunner/Game/GameScene.swift — `layoutLanes()`, `updateSegmentSpritePositions()`.

## Validation

Run in simulator; obstacles/power-ups move vertically toward player; swipe left/right changes lane; no new test failures. Existing unit tests (58) pass.

## Rollback

Revert commits for vertical scroll; re-run full test suite and simulator check.

## Confidence (per-chunk fidelity)

- **Confidence (root cause):** 95% — Root cause: horizontal scroll needed to become vertical for Temple Run-style; verified in code (yOffset, laneY).
- **Confidence (solution path):** 95% — Solution path (y-based positions, laneY = size.height * 0.28) is implemented and validated.
- **Note:** Steps and validation clear; rollback documented in main plan. No ambiguity; build and tests confirm.
