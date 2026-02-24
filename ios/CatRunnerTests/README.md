# CatRunnerTests

Unit tests for the CatRunner iOS app. Run via Xcode (Product → Test) or:

```bash
xcodebuild test -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing:CatRunnerTests
```

**Baseline (2026-02-24):** 75 unit tests. No new failures after Tier 5 consolidation chunks.

## Test files and coverage

| File | Coverage |
|------|----------|
| **B2AssetLoaderTests.swift** | B2 asset loader: load assets.json from bundle, resolve texture keys. |
| **C7MechanicsCollisionTests.swift** | C7 jump/slide and collision: passable, slowdown, instant-fail; lane and time-epsilon behavior. |
| **DifficultyScalerTests.swift** | DifficultySpawnRamp: DifficultyScaler.spawnRate(elapsedSeconds), config decode, ramp formula. |
| **DifficultySpawnRampGameSceneTests.swift** | Logic-test items 8–9: totalElapsedTime after revive, new run, advance, restart; uses GameSceneTestHelper. |
| **GameSceneSafeAreaTests.swift** | P003 Chunk 1: setTopSafeAreaMargin updates score HUD position; fallback margin when VC has not set margin. |
| **GameSceneTestHelper.swift** | T5-C6: Shared helper `makeSceneWithDidMove()` — scene + SKView + didMove(to:); used by DifficultySpawnRampGameSceneTests, GameSceneSafeAreaTests, RevivePlayAgainTests. |
| **ObstaclePlacementTests.swift** | C4 obstacle placement: lane/span validation, targetObstacleCount clamp; path guarantee helpers. |
| **PathGuaranteeTests.swift** | C5 path guarantee: blocked lanes, ≥1 viable lane per segment, determinism, SegmentGenerator seeds. |
| **PowerUpSpawnerTests.swift** | C6 power-up spawner: max one per segment, free-lane-only, no overlap with obstacles; config decode; determinism; time epsilon. |
| **RevivePlayAgainTests.swift** | Tier 1 optional: hasRevivedThisRun, resumeFromCheckpoint, isReviveMonetizationConfigured; uses GameSceneTestHelper. |
| **ScoreKeeperTests.swift** | Score and high score: addTimeScore, addSegmentCompleted, multiplier, didBeatHighScoreThisRun, resetCurrentRun. |
| **SegmentGeneratorTests.swift** | SegmentGenerator: elapsedTimeAtSegmentStart and spawn-rate scaling; nil elapsed fallback and sane count. |

## Legacy note

Original README described C4/C5 only. Full suite now includes C6 (power-ups), C7 (collision), C8 (revive/checkpoint), B2 (assets), P003 (safe area), DifficultySpawnRamp, and Tier 5 test helper.
