# Logic-test plan: Difficulty spawn rate ramp

**Scope:** CatRunner (1 player, 5 lanes, procedural segments).  
**Feature:** Time-based spawn rate ramp and revive/checkpoint restoring difficulty.  
**Do not implement tests here; this is the test plan only.**

Reference: [difficulty-spawn-rate-ramp.plan.md](../../../.cursor/Plans/difficulty-spawn-rate-ramp.plan.md).

---

## 1. Game logic: spawn rate formula

**Formula (per plan):** `spawn rate = 0.2 + 0.02 * elapsedSeconds` (with default config: `initialSpawnIntervalSeconds = 5`, `spawnRateIncrementPerFiveSeconds = 0.1`).

### 1.1 Unit tests — `DifficultyScaler.spawnRate(elapsedSeconds:)`

- **Config dependency:** `DifficultyScalingConfig` must expose (or decode) `initialSpawnIntervalSeconds` and `spawnRateIncrementPerFiveSeconds`; tests use a config with known values (e.g. 5 and 0.1).
- **Exact values (default config):**
  - `spawnRate(elapsedSeconds: 0)` → **0.2**
  - `spawnRate(elapsedSeconds: 5)` → **0.3**
  - `spawnRate(elapsedSeconds: 10)` → **0.4**
- **Monotonicity:** For a fixed config, `spawnRate(elapsedSeconds: t)` is non-decreasing in `t` (and strictly increasing when increment > 0).
- **Lower bound:** Rate is never negative (e.g. with increment 0 and any initial interval, or edge config).
- **Alternative config:** One test with different `initialSpawnIntervalSeconds` / `spawnRateIncrementPerFiveSeconds` to assert formula `(1/initialSpawnIntervalSeconds) + (elapsedSeconds/5) * spawnRateIncrementPerFiveSeconds` (e.g. 10 and 0.05 → 0.1 at 0, 0.15 at 5).

**Target:** `DifficultyScalerTests` (extend existing test target).

---

## 2. Game logic: obstacle count vs elapsed time

**Design:** Per-segment obstacle count = `rate(elapsedTimeAtSegmentStart) * segmentDuration`, then integer rounding and clamping; path guarantee may reduce count (never increase).

### 2.1 Unit tests — `ObstacleGenerator` with `targetObstacleCount`

- **Parameter:** `generate(..., targetObstacleCount: Int? = nil)`. When non-nil, use as target count (subject to internal clamp and path guarantee).
- **When `targetObstacleCount` is provided:**
  - Generated obstacle count is **≤** target (path guarantee can remove obstacles; never add).
  - Count is in a valid range (e.g. 0 to a reasonable per-segment max).
  - With a fixed seed and `targetObstacleCount`, result is deterministic (same count and placements for same RNG seed).
- **When `targetObstacleCount` is nil:** Existing behavior unchanged (count from `numberOfObstacles(segmentDuration:rng:)`); no regression.
- **Clamp:** If implementation clamps target (e.g. to `max(0, Int(segmentDuration * 2))`), test that passing a very large target yields clamped count, not crash.

**Target:** New or existing `ObstaclePlacementTests` / `ObstacleGeneratorTests` in CatRunnerTests.

### 2.2 Unit tests — `SegmentGenerator` with `elapsedTimeAtSegmentStart`

- **Parameter:** `generateSegment(seed:segmentIndex:elapsedTimeAtSegmentStart: TimeInterval? = nil)`.
- **When spawn-rate config is present and `elapsedTimeAtSegmentStart` is provided:**
  - Obstacle count scales with `rate(elapsed) * duration`: e.g. later segments (larger elapsed) produce more obstacles for same duration, or same elapsed with longer duration produces more.
  - Use fixed seed and known duration (or mocked duration) to assert approximate or exact expected count (depending on rounding: e.g. floor(rate * duration) or round).
- **Fallback when `elapsedTimeAtSegmentStart` is nil:** Implementation may use `segmentIndex * averageSegmentDuration`; test that generation still succeeds and count is in a sane range (no crash, no negative count).
- **Interaction with path guarantee:** Final segment obstacle count ≤ target count from rate×duration; path guarantee behavior (at least one viable lane) still holds.

**Target:** New tests in CatRunnerTests (e.g. `SegmentGeneratorTests` or existing segment/obstacle test file).

---

## 3. State: revive / checkpoint restoring difficulty

**Design:** GameScene holds `totalElapsedTime` and `checkpointElapsedTime`. On advance, `totalElapsedTime += currentSegment.durationSeconds`. On checkpoint save, `checkpointElapsedTime = totalElapsedTime`. On revive, `totalElapsedTime = checkpointElapsedTime` so the next generated segment uses the correct elapsed time for spawn rate.

### 3.1 Revive / checkpoint — restore `totalElapsedTime`

- **After revive:** When `resumeFromCheckpoint()` is called, `totalElapsedTime` must equal the stored checkpoint elapsed time (the value at the time the checkpoint was set), so that the next call to `generateSegment(..., elapsedTimeAtSegmentStart: totalElapsedTime)` uses the correct difficulty.
- **Assertion:** Either (a) test GameScene via a test double or scene API that exposes or allows asserting `totalElapsedTime` after `resumeFromCheckpoint()`, or (b) integration-style test: revive, then advance one segment and assert the generated segment’s obstacle count is consistent with `checkpointElapsedTime` (not with 0 or a wrong value).
- **Checkpoint save:** When checkpoint is set (e.g. in `startSegment`), `checkpointElapsedTime` is set to current `totalElapsedTime`; test can assert by reviving and then checking that next segment difficulty matches that elapsed time.

### 3.2 New run vs advance vs restart

- **New run:** `totalElapsedTime` starts at 0; first segment uses `elapsedTimeAtSegmentStart: 0` (rate = 0.2 with default config).
- **Advance:** Before advancing, `totalElapsedTime += currentSegment.durationSeconds`; then next segment uses updated `totalElapsedTime`.
- **Restart current segment:** `restartCurrentSegment()` does **not** add segment duration to `totalElapsedTime` (same segment retried); no change to `totalElapsedTime`.

**Target:** GameScene tests (unit or integration in CatRunnerTests). If GameScene does not expose `totalElapsedTime`/`checkpointElapsedTime`, tests may verify behavior indirectly (e.g. segment count after revive vs after new run at same segment index).

---

## 4. Summary: specific logic-test items

| # | Area | Item | Target file / test type |
|---|------|------|-------------------------|
| 1 | DifficultyScaler | `spawnRate(elapsedSeconds: 0)` → 0.2, 5 → 0.3, 10 → 0.4 (default config) | DifficultyScalerTests |
| 2 | DifficultyScaler | Monotonicity and non-negative rate | DifficultyScalerTests |
| 3 | DifficultyScaler | Formula with alternative config (e.g. 10, 0.05) | DifficultyScalerTests |
| 4 | ObstacleGenerator | With `targetObstacleCount` set: count ≤ target, deterministic for same seed | ObstaclePlacementTests / ObstacleGeneratorTests |
| 5 | ObstacleGenerator | With `targetObstacleCount == nil`: unchanged behavior (regression) | ObstaclePlacementTests / ObstacleGeneratorTests |
| 6 | SegmentGenerator | With `elapsedTimeAtSegmentStart` and spawn-rate config: obstacle count ≈ rate×duration | SegmentGeneratorTests (or equivalent) |
| 7 | SegmentGenerator | With `elapsedTimeAtSegmentStart == nil`: generation succeeds, sane count | SegmentGeneratorTests (or equivalent) |
| 8 | GameScene / state | After revive, next segment uses checkpoint elapsed time for difficulty (totalElapsedTime restored) | GameScene tests / integration |
| 9 | GameScene / state | New run: totalElapsedTime = 0; advance: totalElapsedTime incremented; restart: totalElapsedTime unchanged | GameScene tests / integration |

---

## 5. Out of scope (for this plan)

- Path guarantee internals (covered by existing PathGuaranteeTests).
- Enemy spawn rate (plan leaves enemy spawn as-is; not tied to elapsed-time ramp in this slice).
- E2E or UI tests (revive flow is covered by E2E journeys; this plan is logic/unit and state only).

---

## 6. Implementation order suggestion

1. Implement `DifficultyScaler.spawnRate(elapsedSeconds:)` and config fields; add tests (items 1–3).
2. Implement `ObstacleGenerator.generate(..., targetObstacleCount:)`; add tests (items 4–5).
3. Implement `SegmentGenerator.generateSegment(..., elapsedTimeAtSegmentStart:)` and rate×duration count; add tests (items 6–7).
4. Implement GameScene `totalElapsedTime` / `checkpointElapsedTime` and revive/advance/restart logic; add tests (items 8–9).
