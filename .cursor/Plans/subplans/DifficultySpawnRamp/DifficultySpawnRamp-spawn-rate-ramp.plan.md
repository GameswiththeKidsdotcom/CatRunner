---
name: Difficulty spawn rate ramp
plan_id: DifficultySpawnRamp
overview: "Implement a time-based obstacle spawn rate: one obstacle per lane (or in any lane) every 5 seconds at start, increasing by 0.1 (obstacles per second) every 5 seconds of game time so difficulty constantly ramps. This requires config additions, ObstacleGenerator/SegmentGenerator changes to use a computed target count from rate, and GameScene tracking elapsed time and passing it into segment generation."
todos: []
isProject: false
---

# Difficulty: Time-based obstacle spawn rate (1 per 5s, +0.1 every 5s)

**Next hand off (cut & paste) — Lane A:** Implement **DifficultySpawnRamp C1 (Config)**. Plan file: [C1-Config.plan.md](.cursor/Plans/subplans/DifficultySpawnRamp/C1-Config.plan.md). Add `initialSpawnIntervalSeconds` and `spawnRateIncrementPerFiveSeconds` to `difficultyScaling` in [config/schema.json](config/schema.json) and [config/default/variant.json](config/default/variant.json). Expected outcome: variant validates; existing load still works. Then continue C2→C6 per [Build chunks](#build-chunks-step-4--planner). At C6, delegate to Logic-Test per [docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md).

---

## Goal

- **Initial rate**: One obstacle (in some lane) every 5 seconds → spawn rate = 0.2 obstacles/second.
- **Ramp**: Every 5 seconds of game time, increase spawn rate by 0.1 (obstacles/second). So rate(t) = 0.2 + 0.1×(t/5) = 0.2 + 0.02×t, constantly getting faster.

Interpretation: "obstacle or enemy" is implemented as **obstacles** (existing obstacle types). Enemy spawn (e.g. dog) can stay as-is or be optionally tied to the same curve later.

## Current behavior (reference)

- [ObstacleGenerator.swift](ios/CatRunner/Engine/ObstacleGenerator.swift): `numberOfObstacles(segmentDuration:rng:)` returns a **random** count 0…min(5, segmentDuration×1.2) — not time-based or config-driven.
- [SegmentGenerator.swift](ios/CatRunner/Engine/SegmentGenerator.swift): Calls `obstacleGenerator.generate(segmentDuration:rng:difficultyOverrides:)`; only `segmentIndex` is used for difficulty (speed + probability overrides), not spawn rate.
- [GameScene.swift](ios/CatRunner/Game/GameScene.swift): Tracks `currentSegmentIndex` and segment time; does **not** track total elapsed game time.

## Design

- **Spawn rate formula**: `rate(seconds) = 1 / initialSpawnIntervalSeconds + (elapsedSeconds / 5) * spawnRateIncrementPerFiveSeconds`. With 5s and 0.1: rate = 0.2 + 0.02×elapsedSeconds.
- **Per-segment count**: For a segment of duration `D` starting at elapsed time `T`, use expected count = `rate(T) * D`, then round (e.g. round or floor + probabilistic) to get an integer; clamp to a sane max (e.g. per-segment cap).
- **Elapsed time**: Game loop accumulates elapsed time when advancing segments and passes it into `generateSegment` so rate is based on real game time. When elapsed time is not available (e.g. tests), fall back to approximating with `segmentIndex * averageSegmentDuration`.

## Implementation

### 1. Config (variant.json + schema)

- **difficultyScaling** (add two optional fields so existing configs remain valid):
  - `initialSpawnIntervalSeconds` (number, default 5): interval for one obstacle at start → rate = 1/this.
  - `spawnRateIncrementPerFiveSeconds` (number, default 0.1): add this many obstacles-per-second every 5 seconds of game time.
- **Schema** [config/schema.json](config/schema.json): Add these under `difficultyScaling` as optional (no `required` change); document min/defaults (e.g. initialSpawnIntervalSeconds ≥ 1, increment ≥ 0).
- **Default variant** [config/default/variant.json](config/default/variant.json): Set `"initialSpawnIntervalSeconds": 5`, `"spawnRateIncrementPerFiveSeconds": 0.1`.

### 2. Engine types and decoding

- **DifficultyScalingConfig** [EngineVariantConfig.swift](ios/CatRunner/Engine/EngineVariantConfig.swift): Add `initialSpawnIntervalSeconds: Double` and `spawnRateIncrementPerFiveSeconds: Double`; decode from variant (defaults 5 and 0.1 if missing).
- **DifficultyScaler** [DifficultyScaler.swift](ios/CatRunner/Engine/DifficultyScaler.swift): Add a function that takes **elapsed time** (and config) and returns current **spawn rate** (obstacles per second), e.g. `spawnRate(elapsedSeconds: TimeInterval) -> Double`. Use: `(1.0 / config.initialSpawnIntervalSeconds) + (elapsedSeconds / 5.0) * config.spawnRateIncrementPerFiveSeconds`, with a sensible lower bound (e.g. ≥ 0) and optional upper cap in config later if needed.

### 3. ObstacleGenerator: target count from outside

- **ObstacleGenerator** [ObstacleGenerator.swift](ios/CatRunner/Engine/ObstacleGenerator.swift): Support a **target count** when provided, instead of computing it internally.
  - Add overload or parameter: e.g. `generate(segmentDuration: TimeInterval, rng: GKRandom, difficultyOverrides: DifficultyOverrides? = nil, targetObstacleCount: Int? = nil) -> [ObstaclePlacement]`.
  - When `targetObstacleCount != nil`, use that as `totalCount` (clamped to a safe range, e.g. 0…max(0, Int(segmentDuration * 2)) or similar); when `nil`, keep current `numberOfObstacles(segmentDuration:rng:)` behavior for backward compatibility.
  - No change to spread/cluster logic beyond the count source.

### 4. SegmentGenerator: compute count from rate and elapsed time

- **SegmentGenerator** [SegmentGenerator.swift](ios/CatRunner/Engine/SegmentGenerator.swift):
  - Add optional parameter to `generateSegment`: `elapsedTimeAtSegmentStart: TimeInterval? = nil`.
  - Compute elapsed time: `let elapsed = elapsedTimeAtSegmentStart ?? Double(segmentIndex) * (durationConfig.minDurationSeconds + durationConfig.maxDurationSeconds) / 2`.
  - If difficulty scaling has spawn-rate params (initialSpawnIntervalSeconds / spawnRateIncrementPerFiveSeconds), compute rate = `difficultyScaler.spawnRate(elapsedSeconds: elapsed)`, then expected count = rate * duration (the segment duration **after** speed scaling). Round to integer (e.g. round or floor; consider one random rounding for variety: floor with probability frac). Clamp to [0, reasonable max per segment].
  - Call `obstacleGenerator.generate(..., targetObstacleCount: count)` when using time-based rate; otherwise (no scaling or no spawn-rate config) keep current behavior (no target count).
  - Ensure path guarantee and rest of segment generation unchanged.

### 5. Game loop: track and pass elapsed time

- **GameScene** [GameScene.swift](ios/CatRunner/Game/GameScene.swift):
  - Add `private var totalElapsedTime: TimeInterval = 0`.
  - On **new run** (when starting first segment or resetting game): set `totalElapsedTime = 0` before generating segment 0.
  - In **advanceToNextSegment**: before incrementing index and calling `startSegment()`, add `totalElapsedTime += currentSegment?.durationSeconds ?? 0`.
  - When calling `generateSegment(seed:segmentIndex:...)`, add argument `elapsedTimeAtSegmentStart: totalElapsedTime`. So at segment start we pass the elapsed time **before** this segment (correct for rate at segment start).
  - **Checkpoint (revive)**: When setting checkpoint (e.g. in `startSegment` or where checkpoint is updated), store `checkpointElapsedTime = totalElapsedTime`. On **resumeFromCheckpoint**, set `totalElapsedTime = checkpointElapsedTime` so revived run continues with correct difficulty.
  - **restartCurrentSegment** (scroller loop): do **not** add segment duration to `totalElapsedTime` (we're redoing the same segment); no change to totalElapsedTime there.

### 6. Tests and validation

- **DifficultyScalerTests**: Add test that `spawnRate(elapsedSeconds:)` returns 0.2 at 0, 0.3 at 5, 0.4 at 10 with config (5, 0.1).
- **ObstacleGenerator**: Add or extend test that when `targetObstacleCount` is provided, generated count matches (subject to path guarantee possibly adding one).
- **SegmentGenerator / integration**: Test that with elapsedTimeAtSegmentStart and spawn-rate config, obstacle count scales roughly with rate×duration; no need for exact match if using random rounding.
- **Regression**: Run full test suite; ensure existing ObstaclePlacementTests and PathGuaranteeTests still pass (backward compatibility when targetObstacleCount is nil).

**Test plans and infrastructure (Step 2 reconciled):**

- **E2E / UX / viewports / journeys:** [difficulty-spawn-rate-ramp-test-plan.md](../../difficulty-spawn-rate-ramp-test-plan.md) — E2E E1–E6 (ramp trend E4, checkpoint E5, new-run reset E6), UX U1–U3 (perceived curve, readability, fairness), viewports V1–V2 (5-iPhone matrix, layout at high density), journey extensions J2-ext, J4-ext, J5-ext.
- **Logic-test:** [docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md) — 9 items: DifficultyScaler.spawnRate (unit), ObstacleGenerator targetObstacleCount (count ≤ target, nil = regression), SegmentGenerator elapsedTimeAtSegmentStart and fallback, revive/checkpoint (totalElapsedTime restored), new run / advance / restart (totalElapsedTime state).
- **Infrastructure:** No impact. Code and config only; no new env vars, DB, or CI jobs. Optional schema update for admin config editor (optional fields in difficultyScaling).

### 7. Optional: Enemies

- Current enemy spawn is ~35% chance per segment in [SegmentGenerator](ios/CatRunner/Engine/SegmentGenerator.swift) (`randomEnemyPlacement`). Out of scope for this plan: optionally later tie enemy spawn rate to the same elapsed-time curve (e.g. one enemy per N seconds with same ramp). No code change in this plan.

## Files to touch (summary)

| Area   | File                                                                        | Change                                                                                                       |
| ------ | --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| Config | [config/default/variant.json](config/default/variant.json)                  | Add initialSpawnIntervalSeconds, spawnRateIncrementPerFiveSeconds under difficultyScaling.                   |
| Schema | [config/schema.json](config/schema.json)                                    | Add optional properties and descriptions.                                                                    |
| Engine | [EngineVariantConfig.swift](ios/CatRunner/Engine/EngineVariantConfig.swift) | Decode new fields; extend DifficultyScalingConfig and decoding struct.                                       |
| Engine | [DifficultyScaler.swift](ios/CatRunner/Engine/DifficultyScaler.swift)       | Add spawnRate(elapsedSeconds:).                                                                              |
| Engine | [ObstacleGenerator.swift](ios/CatRunner/Engine/ObstacleGenerator.swift)     | Optional targetObstacleCount in generate().                                                                  |
| Engine | [SegmentGenerator.swift](ios/CatRunner/Engine/SegmentGenerator.swift)       | elapsedTimeAtSegmentStart param; compute count from rate; pass targetObstacleCount.                          |
| Game   | [GameScene.swift](ios/CatRunner/Game/GameScene.swift)                       | totalElapsedTime; checkpointElapsedTime; pass elapsed into generateSegment; advance/revive/restart handling. |
| Tests  | DifficultyScalerTests, ObstaclePlacementTests or SegmentGenerator tests     | New/updated tests for spawn rate and target count.                                                           |

## Build chunks (Step 4 — Planner)

Chunks live in this folder. Execute in order C1 → C6.

| Chunk | Name | Description | Conf (root) | Conf (solution) |
|-------|------|--------------|-------------|-----------------|
| C1 | [C1-Config.plan.md](C1-Config.plan.md) | variant.json + schema: initialSpawnIntervalSeconds, spawnRateIncrementPerFiveSeconds | — | 95% |
| C2 | [C2-EngineTypes.plan.md](C2-EngineTypes.plan.md) | DifficultyScalingConfig decode + DifficultyScaler.spawnRate(elapsedSeconds:) | — | 95% |
| C3 | [C3-ObstacleGenerator.plan.md](C3-ObstacleGenerator.plan.md) | ObstacleGenerator.generate(..., targetObstacleCount:) | — | 93% |
| C4 | [C4-SegmentGenerator.plan.md](C4-SegmentGenerator.plan.md) | SegmentGenerator elapsedTimeAtSegmentStart, rate × duration, targetObstacleCount | — | 92% |
| C5 | [C5-GameLoop.plan.md](C5-GameLoop.plan.md) | GameScene totalElapsedTime, checkpointElapsedTime, pass to generateSegment | — | 94% |
| C6 | [C6-Tests.plan.md](C6-Tests.plan.md) | DifficultyScalerTests, ObstacleGenerator, SegmentGenerator, regression | — | 91% |

## Per-section confidence (Investigator Step 1)

| Section | Confidence (root cause) | Confidence (solution path) | Note |
|---------|-------------------------|----------------------------|------|
| Goal | 95% | 95% | User ask is clear: 1 per 5s, +0.1 every 5s; formula and scope (obstacles only) are unambiguous. |
| Design | 93% | 93% | Rate formula and elapsed-time source are correct; fallback (segmentIndex × avg duration) is documented. Small gap: rounding strategy not yet fixed (floor vs round). |
| Implementation 1 (Config) | 95% | 95% | Optional fields preserve existing configs; schema and variant.json changes are standard. |
| Implementation 2 (Engine types) | 95% | 95% | DifficultyScalingConfig + DifficultyScaler.spawnRate(elapsedSeconds:) are well-specified; decoding defaults are clear. |
| Implementation 3 (ObstacleGenerator) | 93% | 93% | targetObstacleCount optional param and clamp are specified; path guarantee may reduce count (never increase), so test expects count ≤ target. |
| Implementation 4 (SegmentGenerator) | 92% | 92% | elapsedTimeAtSegmentStart, rate × duration, and fallback are clear; exact rounding and cap still to be chosen (document in impl). |
| Implementation 5 (Game loop) | 94% | 94% | totalElapsedTime and checkpointElapsedTime flow are correct; advance vs restart vs revive are all covered. |
| Tests | 91% | 91% | DifficultyScaler, ObstacleGenerator, SegmentGenerator, and regression tests are listed; path guarantee behavior (count can be less than target) should be asserted in test. |
| Risks | 92% | — | Approximate elapsed time and rounding are called out; mitigation (GameScene passes elapsed, tests pass explicit) is stated. |
| Rollback | — | 93% | See step-by-step rollback below; verification steps are explicit. |

**Gate:** All sections meet >90% confidence. Proceed to Step 2.

---

## Risks and rollback

- **Risk**: Approximate elapsed time (segmentIndex × avg duration) when caller doesn't pass elapsed time can make spawn rate slightly off in tests or edge cases. Mitigation: GameScene always passes elapsed time; tests can pass explicit values.
- **Risk**: PathGuarantee can remove obstacles (never add); so final obstacle count may be less than targetObstacleCount. Tests should assert count ≤ target (or count in expected range when path guarantee is applied).

### Step-by-step rollback

If the build fails or regressions cannot be resolved:

1. **Revert code and config** (in dependency order so the project still builds):
   - [GameScene.swift](ios/CatRunner/Game/GameScene.swift): Remove `totalElapsedTime`, `checkpointElapsedTime`; remove `elapsedTimeAtSegmentStart` from all `generateSegment` calls; in `advanceToNextSegment` / `startSegment` / `resumeFromCheckpoint` remove elapsed-time logic.
   - [SegmentGenerator.swift](ios/CatRunner/Engine/SegmentGenerator.swift): Remove `elapsedTimeAtSegmentStart` parameter from `generateSegment`; remove spawn-rate count computation and `targetObstacleCount` argument to `obstacleGenerator.generate`.
   - [ObstacleGenerator.swift](ios/CatRunner/Engine/ObstacleGenerator.swift): Remove `targetObstacleCount` parameter from `generate`; restore using only `numberOfObstacles(segmentDuration:rng:)` for count.
   - [DifficultyScaler.swift](ios/CatRunner/Engine/DifficultyScaler.swift): Remove `spawnRate(elapsedSeconds:)` (and any callers).
   - [EngineVariantConfig.swift](ios/CatRunner/Engine/EngineVariantConfig.swift): Remove `initialSpawnIntervalSeconds` and `spawnRateIncrementPerFiveSeconds` from `DifficultyScalingConfig` and from `FullDifficultyScalingBranch` decoding (or decode and ignore).
   - [config/default/variant.json](config/default/variant.json): Remove `initialSpawnIntervalSeconds` and `spawnRateIncrementPerFiveSeconds` from `difficultyScaling`.
   - [config/schema.json](config/schema.json): Remove the two optional properties from `difficultyScaling`.
   - Tests: Remove or revert new tests in DifficultyScalerTests, ObstaclePlacementTests, and any SegmentGenerator tests added for spawn rate / target count.

2. **Verify rollback:**
   - Run full test suite: `npm run test:full` (if applicable) and iOS unit + UI tests (e.g. 65 tests per Master-Plan baseline). All must pass.
   - Run the game: confirm obstacle density is again the previous random behavior (no time-based ramp).
   - Optional: Load variant.json and confirm no references to the removed keys.

3. **If regressions persist:** Escalate: either expand rollback scope (e.g. revert entire feature branch) or document the regression and re-investigate before re-attempting the change.

## Confidence (plan-level)

- **High** that the formula (1 per 5s + 0.1 per 5s) matches the requested behavior.
- **High** that implementing rate via target count and elapsed time is the right place (SegmentGenerator + ObstacleGenerator + GameScene).
- **Medium** on exact rounding (floor vs round vs probabilistic) for count; document choice and keep it simple (e.g. floor(expectedCount) with min 0, or round).
