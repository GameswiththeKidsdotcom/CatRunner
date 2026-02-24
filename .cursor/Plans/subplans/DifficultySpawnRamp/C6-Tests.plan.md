---
name: C6 — Tests (spawn rate, target count, regression)
plan_id: DifficultySpawnRamp
chunk_id: C6
overview: DifficultyScalerTests (spawnRate), ObstacleGenerator/SegmentGenerator tests (target count, rate×duration), regression (existing tests pass with targetObstacleCount nil).
---

# C6 — Tests and validation

**Parent plan:** [difficulty-spawn-rate-ramp.plan.md](../../difficulty-spawn-rate-ramp.plan.md)

## Scope

- **Goal:** Unit and regression coverage for spawn rate formula, target count behavior, and elapsed-time/checkpoint state.
- **In scope:** DifficultyScalerTests (spawnRate 0.2 at 0s, 0.3 at 5s, 0.4 at 10s; monotonicity); ObstaclePlacementTests or new (targetObstacleCount honored, count ≤ target when path guarantee applies); SegmentGenerator test (elapsedTimeAtSegmentStart + config → count scales); regression (ObstaclePlacementTests, PathGuaranteeTests pass unchanged).
- **Out of scope:** E2E ramp (E4) and journey extensions (see ui-test plan); can be added in same or follow-up.

## Steps

1. **DifficultyScalerTests:** Add tests for spawnRate(elapsedSeconds:) with config (5, 0.1): 0→0.2, 5→0.3, 10→0.4; rate ≥ 0; optional different config. **Done (Lane A):** testSpawnRate_defaultConfig_exactValues, testSpawnRate_monotonicAndNonNegative, testSpawnRate_alternativeConfig.
2. **ObstacleGenerator:** Test generate(..., targetObstacleCount: 3) gives count ≤ 3 (same seed deterministic); test targetObstacleCount nil preserves existing behavior.
3. **SegmentGenerator:** Test with elapsedTimeAtSegmentStart and spawn-rate config: obstacle count in expected range (rate×duration ± rounding); test nil elapsed fallback.
4. **Regression:** Run full suite (npm run test:full if applicable, iOS 65 tests); ObstaclePlacementTests and PathGuaranteeTests pass.
5. **Reference:** Logic-test plan [docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md); E2E/UX in [difficulty-spawn-rate-ramp-test-plan.md](../../difficulty-spawn-rate-ramp-test-plan.md).

## C6 hand-off — Logic-Test (delegation)

**Lane A completed:** C1–C5 (config, engine types, ObstacleGenerator targetObstacleCount, SegmentGenerator elapsedTimeAtSegmentStart, GameScene totalElapsedTime/checkpoint). C6 spawnRate unit tests added in DifficultyScalerTests.

**Delegated to Logic-Test** per [docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md): implement remaining items 4–9 (ObstacleGenerator targetObstacleCount tests, SegmentGenerator elapsedTimeAtSegmentStart tests, GameScene revive/advance/restart state tests). Run regression (ObstaclePlacementTests, PathGuaranteeTests, full iOS suite).

## Rollback

Revert or remove added tests only; no code revert in this chunk.

## Confidence (per-chunk fidelity)

| Metric | Value | Note |
|--------|--------|------|
| Confidence (root cause) | N/A | Test chunk. |
| Confidence (solution path) | 91% | Logic-test and ui-test plans referenced; path guarantee assertion called out. |
