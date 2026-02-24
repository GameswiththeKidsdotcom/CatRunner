---
name: Spec gaps — First-revive-only implementation
overview: Implement SPECIFICATION.md §1 "after that, game over is final": one revive per run via hasRevivedThisRun state, VC branch, and reset on new run. Lane A (ios/) only.
---

**Next hand off (cut & paste):** **Complete (2026-02-24).** Code + E2E J4c + 65 tests done. Invoke **Logic-Test** per [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.1; then see [P001-SpecGaps-ideation-to-impl.plan.md](P001-SpecGaps-ideation-to-impl.plan.md) and Master-Plan for Tier 4.

---

# First-revive-only — Build and validation

## Confidence

| Item | Confidence (root cause) | Confidence (solution path) |
|------|-------------------------|----------------------------|
| Spec violation | High (95%): no hasRevived state; "Watch ad" always offered when monetization set | High (95%): single flag on GameScene, branch in VC, reset on new run |

## Steps (one verifiable outcome each)

1. **Add `hasRevivedThisRun` to GameScene**  
   - **File:** `ios/CatRunner/Game/GameScene.swift`  
   - **Action:** Add `private(set) var hasRevivedThisRun = false`.  
   - **Verification:** Build succeeds; property readable from GameViewController (expose via delegate or property if needed).

2. **Set `hasRevivedThisRun = true` when user taps "Watch ad"**  
   - **File:** `ios/CatRunner/GameViewController.swift`  
   - **Action:** In the "Watch ad" action closure, before calling `scene?.resumeFromCheckpoint()`, set `scene?.hasRevivedThisRun = true` (or have GameScene set it inside `resumeFromCheckpoint()` before clearing `gameOverRequested`). Prefer GameScene setting it inside `resumeFromCheckpoint()` so all resume paths are consistent.  
   - **Verification:** After one revive, a second game over does not show "Watch ad" (manual or step 5).

3. **Gate "Watch ad" in alert when `hasRevivedThisRun` is true**  
   - **File:** `ios/CatRunner/GameViewController.swift`  
   - **Action:** In `showReviveOrGameOver`, add "Watch ad" only when `scene.isReviveMonetizationConfigured && !scene.hasRevivedThisRun`.  
   - **Verification:** With monetization configured, first game over shows Watch ad / Play again / No thanks; second game over (after one revive) shows only Play again / No thanks.

4. **Reset `hasRevivedThisRun` when starting a new run**  
   - **File:** `ios/CatRunner/Game/GameScene.swift` (and/or GameViewController).  
   - **Action:** When a new GameScene is created (e.g. `startNewGame()`), the new scene gets default `hasRevivedThisRun = false`. If GameScene is ever reused instead of recreated, reset the flag in the same code path that starts a new run.  
   - **Verification:** Play again → new run → hit instant-fail → "Watch ad" is shown again (when monetization configured).

5. **Run full test suite**  
   - **Action:** From `ios/`: `xcodebuild test -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -configuration Debug`.  
   - **Verification:** 64 tests pass (58 CatRunnerTests + 6 CatRunnerUITests).

6. **Update E2E J4 for second game-over path**  
   - **File:** `ios/CatRunnerUITests/JourneyTests.swift` (or equivalent).  
   - **Action:** Add or extend J4: after "Watch ad" → resume → trigger second game over (e.g. ForceGameOver or collide again), assert alert has no "Watch ad" button and has "Play again" and "No thanks".  
   - **Verification:** E2E run includes second-game-over path and passes.

7. **Invoke Logic-Test**  
   - **Action:** Hand off to **Logic-Test** agent: validate revive/game-over state machine per [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.1 (allowed moves, no unreachable states, state consistency after revive and play again).  
   - **Verification:** Logic-test confirms or updates test plan; no open defects.

## Validation

- **Unit/regression:** 64 tests pass.  
- **E2E:** J4 covers first game over (Watch ad / No thanks / Play again) and second game over (Play again / No thanks only).  
- **Logic-test:** State-machine validation per §6.1.

## Rollback

- If regressions or E2E failures: revert changes to `GameScene.swift` and `GameViewController.swift`; restore "Watch ad" whenever `isReviveMonetizationConfigured` (current behavior). Re-run tests; defer first-revive-only until E2E and logic-test are updated.

## References

- [docs/SPECIFICATION.md](../../../docs/SPECIFICATION.md) §1
- [ios/CatRunner/GameViewController.swift](../../../ios/CatRunner/GameViewController.swift) — showReviveOrGameOver
- [ios/CatRunner/Game/GameScene.swift](../../../ios/CatRunner/Game/GameScene.swift) — resumeFromCheckpoint, isReviveMonetizationConfigured
- [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.1, J4
