# Logic-Test Checklist: Difficulty Spawn Rate Ramp

**Source:** [difficulty-spawn-rate-ramp-test-plan.md](difficulty-spawn-rate-ramp-test-plan.md)  
**Feature:** DifficultySpawnRamp (time-based spawn rate, revive/checkpoint restoring difficulty).

---

## Checklist status

| # | Area | Item | Target | Status |
|---|------|------|--------|--------|
| 1 | DifficultyScaler | `spawnRate(elapsedSeconds: 0)` → 0.2, 5 → 0.3, 10 → 0.4 (default config) | DifficultyScalerTests | ✅ Done |
| 2 | DifficultyScaler | Monotonicity and non-negative rate | DifficultyScalerTests | ✅ Done |
| 3 | DifficultyScaler | Formula with alternative config (e.g. 10, 0.05) | DifficultyScalerTests | ✅ Done |
| 4 | ObstacleGenerator | With `targetObstacleCount` set: count ≤ target, deterministic for same seed | ObstaclePlacementTests | ✅ Done |
| 5 | ObstacleGenerator | With `targetObstacleCount == nil`: unchanged behavior (regression) | ObstaclePlacementTests | ✅ Done |
| 6 | SegmentGenerator | With `elapsedTimeAtSegmentStart` and spawn-rate config: obstacle count ≈ rate×duration | SegmentGeneratorTests | ✅ Done |
| 7 | SegmentGenerator | With `elapsedTimeAtSegmentStart == nil`: generation succeeds, sane count | SegmentGeneratorTests | ✅ Done |
| 8 | GameScene / state | After revive, next segment uses checkpoint elapsed time (totalElapsedTime restored) | GameScene tests | ✅ Done |
| 9 | GameScene / state | New run: totalElapsedTime=0; advance: totalElapsedTime incremented; restart: unchanged | GameScene tests | ✅ Done |

---

## Test run baseline

- **npm run test:full:** 1 passed (Vitest).
- **iOS:** 75 unit (CatRunnerTests) + 8 UI (CatRunnerUITests, 2 skipped). All pass when checklist complete.

---

## Notes

- Items 1–5 were implemented in C6 (DifficultySpawnRamp). Items 6–9 completed per this checklist.
- GameScene tests use internal test hooks: `totalElapsedTimeForTesting`, `checkpointElapsedTimeForTesting`, `advanceToNextSegment()`, `restartCurrentSegment()`.
