---
name: C3 — ObstacleGenerator target count
plan_id: DifficultySpawnRamp
chunk_id: C3
overview: ObstacleGenerator.generate accepts optional targetObstacleCount; when set, use it as totalCount (clamped); when nil, keep current numberOfObstacles behavior.
---

# C3 — ObstacleGenerator: target count from outside

**Parent plan:** [difficulty-spawn-rate-ramp.plan.md](../../difficulty-spawn-rate-ramp.plan.md)

## Scope

- **Goal:** Caller can supply a target obstacle count per segment instead of random count.
- **In scope:** ObstacleGenerator.generate(segmentDuration:rng:difficultyOverrides:targetObstacleCount:); clamp target to safe range (e.g. 0…Int(segmentDuration*2)).
- **Out of scope:** Who computes target (SegmentGenerator, C4); path guarantee unchanged (may reduce count).

## Steps

1. **ObstacleGenerator** [ObstacleGenerator.swift](ios/CatRunner/Engine/ObstacleGenerator.swift): Add optional parameter `targetObstacleCount: Int? = nil` to `generate(...)`.
2. When `targetObstacleCount != nil`: set `totalCount = min(max(0, targetObstacleCount!), max(0, Int(segmentDuration * 2)))` (or similar clamp). When `nil`, keep existing `numberOfObstacles(segmentDuration:rng:)` for count.
3. **Validation:** Unit test with targetObstacleCount = 3 and fixed seed: generated count ≤ 3 (path guarantee may remove). With targetObstacleCount = nil, existing behavior (regression). PathGuaranteeTests and ObstaclePlacementTests still pass.

## Rollback

Remove targetObstacleCount parameter; restore count from numberOfObstacles only.

## Confidence (per-chunk fidelity)

| Metric | Value | Note |
|--------|--------|------|
| Confidence (root cause) | N/A | Build chunk. |
| Confidence (solution path) | 93% | Clamp and path guarantee (count ≤ target) noted; regression test required. |
