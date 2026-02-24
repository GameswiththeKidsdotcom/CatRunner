---
name: C4 — SegmentGenerator elapsed time and spawn count
plan_id: DifficultySpawnRamp
chunk_id: C4
overview: generateSegment accepts optional elapsedTimeAtSegmentStart; when difficulty has spawn-rate config, compute rate from DifficultyScaler and target count = rate * duration, then call ObstacleGenerator with targetObstacleCount.
---

# C4 — SegmentGenerator: compute count from rate and elapsed time

**Parent plan:** [difficulty-spawn-rate-ramp.plan.md](../../difficulty-spawn-rate-ramp.plan.md)

## Scope

- **Goal:** Segment obstacle count is derived from spawn rate (elapsed time) × segment duration when config present.
- **In scope:** SegmentGenerator.generateSegment(seed:segmentIndex:elapsedTimeAtSegmentStart:); elapsed fallback (segmentIndex × avg duration); rate = scaler.spawnRate(elapsed); count = rate * duration (round/clamp); call obstacleGenerator.generate(..., targetObstacleCount: count).
- **Out of scope:** GameScene passing elapsed time (C5); config/engine types (C1, C2). Depends on C2 (DifficultyScaler.spawnRate) and C3 (targetObstacleCount).

## Steps

1. **generateSegment** [SegmentGenerator.swift](ios/CatRunner/Engine/SegmentGenerator.swift): Add `elapsedTimeAtSegmentStart: TimeInterval? = nil`.
2. Compute `elapsed = elapsedTimeAtSegmentStart ?? Double(segmentIndex) * (durationConfig.minDurationSeconds + durationConfig.maxDurationSeconds) / 2`.
3. If difficultyScaler is present and config has spawn-rate params (initialSpawnIntervalSeconds / spawnRateIncrementPerFiveSeconds): `rate = difficultyScaler.spawnRate(elapsedSeconds: elapsed)`, `expectedCount = rate * duration`, round to Int (e.g. floor or round), clamp to [0, maxPerSegment]. Call `obstacleGenerator.generate(..., targetObstacleCount: expectedCount)`. Otherwise call without targetObstacleCount (current behavior).
4. **Validation:** With elapsedTimeAtSegmentStart and spawn-rate config, generate several segments with increasing elapsed; obstacle counts should trend up. Path guarantee and rest of segment unchanged.

## Rollback

Remove elapsedTimeAtSegmentStart; remove spawn-rate count logic and targetObstacleCount argument.

## Confidence (per-chunk fidelity)

| Metric | Value | Note |
|--------|--------|------|
| Confidence (root cause) | N/A | Build chunk. |
| Confidence (solution path) | 92% | Elapsed fallback and rate×duration clear; rounding to be fixed in impl. |
