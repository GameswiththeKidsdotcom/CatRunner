---
name: T5-C4 — Fallback segment factory
plan_id: T5-C4-FallbackSegment
overview: "Extract a single fallback segment factory used when engineConfig is nil; use it in startSegment and restartCurrentSegment to remove duplicated segment construction."
todos: []
isProject: false
parent: Tier5-TechDebt
---

# T5-C4 — Fallback segment factory

**Status:** Done (2026-02-24).

## Goal

- Single source for the fallback segment when `engineConfig == nil` (no variant.json).
- Used in both `startSegment()` and `restartCurrentSegment()` in GameScene.

## Implementation (done)

- **GameScene:** Added private static `makeFallbackSegment(seed: UInt64) -> Segment` that builds the same segment as before: duration 10s, one passable obstacle at center lane, one dog enemy at lane 0. Uses `DesignConstants.defaultCenterLaneIndex` for the obstacle lane.
- **startSegment:** When `engineConfig == nil`, call `currentSegment = Self.makeFallbackSegment(seed: UInt64(bitPattern: Int64(currentSegmentIndex)))` instead of inline Segment construction.
- **restartCurrentSegment:** When `engineConfig == nil`, call `currentSegment = Self.makeFallbackSegment(seed: seed)` instead of inline Segment construction.
- No behavior change; 75 unit tests pass.

## Validation

- Full iOS unit test suite (CatRunnerTests): 75 tests, 0 failures.
- `npm run test:full` (Vitest): pass.

## Rollback

- Revert the GameScene edits for T5-C4; restore the two inline `Segment(...)` blocks in the `else` branches of startSegment and restartCurrentSegment.

## Confidence

- **91%** that this is the correct consolidation (single factory, same behavior).
