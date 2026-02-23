# Scroller 10s Loop — Logic Test Plan (Blaster Step 2)

**Scope:** 1 player, 5 lanes, procedural segments (SegmentGenerator). Segment duration ≥10s, loop mode restarts same segment (same seed), no `addSegmentCompleted` on restart, sprite scaling 44pt (out of scope for logic tests).

---

## 1. Segment duration ≥10s

- **Source of truth:** Config from `EngineVariantConfig.segmentDurationConfig` (min/max); fallback in `GameScene.startSegment()` when `engineConfig == nil` (hardcoded segment).
- **Assertions:**
  - **Config path:** Unit test that builds `SegmentDurationConfig(minDurationSeconds: 10, maxDurationSeconds: 12)` and a `SegmentGenerator(engineConfig:)` (or legacy init with that config); generate multiple segments and assert each `segment.durationSeconds >= 10` (and ≤ 12). Optionally assert fallback: when creating a segment without config (e.g. in a test that injects nil config and checks the segment used), duration is 10s (after fallback is changed from 3s to 10s).
  - **Reference:** Same pattern as `PathGuaranteeTests` / `PowerUpSpawnerTests` — construct `SegmentDurationConfig` and `SegmentGenerator(config:obstacleConfig:laneCount:)` and assert on generated segment properties (e.g. `PathGuaranteeTests.testSegmentGenerator_sameSeed_sameSegment` asserts `durationSeconds` equality).
- **Config decode:** If variant.json gains min/max ≥10, add or extend test that decodes JSON (e.g. `EngineVariantConfig.decode(from:)` as in `PowerUpSpawnerTests.testEngineVariantConfig_decodesPowerUps`) and assert `segmentDurationConfig.minDurationSeconds >= 10`.

---

## 2. Loop behavior: same seed → same segment; advance in loop mode

- **Determinism (already covered):** `PathGuaranteeTests.testSegmentGenerator_sameSeed_sameSegment` already asserts that the same seed yields identical `durationSeconds`, `seed`, and `obstacles`. No change needed for SegmentGenerator determinism.
- **Loop mode “advance” behavior (new):**
  - When loop mode is on and segment ends, the game should **restart the same segment** (same seed), **not** increment segment index. So: (1) segment index unchanged, (2) same segment content (same seed → same segment from generator).
  - **Unit test options:**
    - **Option A — GameScene with injected dependencies:** If GameScene can be tested with a mock SegmentGenerator and ScoreKeeper, simulate “segment end” (e.g. call the method that runs when `segmentTime >= segment.durationSeconds`), then assert: `currentSegmentIndex` unchanged, `currentSegment?.seed` unchanged, and that the “next” segment is the same (e.g. same seed and duration) as before. Requires exposing or invoking the segment-end path (e.g. `advanceToNextSegment()` vs new “restartSegment()”) and reading segment index/seed.
    - **Option B — Segment state contract:** Add a small test that documents the contract: “given loop flag true, on segment end we call restart with same seed and do not increment index.” Test the **helper** that chooses “restart same” vs “advance”: e.g. a function that returns (segmentIndex, seed) for next segment given (currentIndex, currentSeed, loopMode). Assert: when loopMode true, next segment index and seed equal current; when false, index is current+1 and seed is derived from new index (e.g. as in current `startSegment()`).
  - **Reference:** `PathGuaranteeTests.testSegmentGenerator_sameSeed_sameSegment` for “same seed → same segment”; new test(s) for “on advance in loop mode, index unchanged and same segment restarts.”

---

## 3. Scoring: addSegmentCompleted not called on loop restart

- **Requirement:** On loop restart, `scoreKeeper.addSegmentCompleted()` must not be called; on real advance it must be called.
- **Verification:**
  - **Mock ScoreKeeper:** Introduce a test double (e.g. `MockScoreKeeper` or protocol-based `ScoreKeeperProtocol`) that records call count for `addSegmentCompleted()`. When exercising “segment end in loop mode” once, assert call count 0; when exercising “segment end in advance mode” once, assert call count 1. Pattern similar to `ScoreKeeperTests.testAddSegmentCompletedIncrementsScore` but in a scene/flow test with a mock.
  - **Call-count assertion:** If GameScene takes a closure or delegate for “on segment completed” that is only invoked on advance (not on loop restart), test can assert that the closure is not called when loop-restarting. Alternatively, assert on the mock’s `addSegmentCompleted` call count as above.
- **Reference:** `ScoreKeeperTests` already test `addSegmentCompleted` behavior; new tests verify **when** it is called (advance vs loop).

---

## 4. Collision / segment time: loop vs advance

- **CollisionSystem:** Uses `segmentTime` and current segment’s obstacles/power-up; it is stateless per frame. On loop restart, `segmentTime` is reset to 0 and the same segment (same obstacles/power-up) is used, so collision logic is unchanged; only the moment in time resets. No change to `CollisionSystem.check` contract.
- **Assertions (optional but useful):**
  - After a “loop restart” in tests, `segmentTime` should be 0 and segment content (obstacles, power-up) identical to the segment that just ended — already implied by “same seed, same segment” and reset of `segmentTime` in `startSegment()`.
  - If a test runs the update loop until segment end in loop mode, then runs one more frame, assert that collision check still receives the same segment and `segmentTime` in [0, delta] (reset).
- **Reference:** `C7MechanicsCollisionTests` cover collision outcomes; no change to CollisionSystem API. Logic tests only need to ensure segment time and segment identity after restart are correct (state consistency).

---

## 5. Output summary (bullet list)

- **Segment duration:** Assert `segment.durationSeconds >= 10` for segments generated with config (min/max ≥10); assert fallback segment duration 10s when config nil. Reuse patterns from `PathGuaranteeTests` / `PowerUpSpawnerTests`; optionally assert decoded `EngineVariantConfig.segmentDurationConfig.minDurationSeconds >= 10`.
- **Loop / determinism:** Rely on `PathGuaranteeTests.testSegmentGenerator_sameSeed_sameSegment` for same-seed → same-segment. Add test(s) that when “advance” is performed in loop mode: segment index unchanged, same segment (same seed) restarts; optionally test a small “next segment (index, seed)” helper for loop vs advance.
- **Scoring:** Use mock ScoreKeeper (or call-count spy) and assert `addSegmentCompleted` is **not** called on loop restart and **is** called on real advance; reference `ScoreKeeperTests` for scoring behavior.
- **Collision/state:** No change to CollisionSystem API; assert after loop restart that `segmentTime` is reset and segment content unchanged (same seed). Optional: one integration-style check that after segment end in loop mode, next frame has segment time in [0, delta] and same segment.
- **Existing tests:** `PathGuaranteeTests` (determinism, segment generation), `PowerUpSpawnerTests` (config decode, determinism), `ScoreKeeperTests` (addSegmentCompleted), `C7MechanicsCollisionTests` (collision outcomes). New tests: duration ≥10 (config + fallback), loop-mode branch (index + seed + no addSegmentCompleted), optionally segment-time reset.
