# P001 Logic-Test: Revive and Play-Again State (2026-02-23)

Per [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md) §6.1. Read-only validation of game logic, allowed moves, unreachable states, and state consistency. Lane A may implement "Play again" and re-run logic-test.

---

## Scope

- **Moves/phases:** Revive dialog (instant-fail → alert); Revive vs Done; Play again (new run).
- **Files:** `ios/CatRunner/GameViewController.swift`, `ios/CatRunner/Game/GameScene.swift`, `ios/CatRunner/Game/ScoreKeeper.swift`.
- **Rules (from spec/findings):** One alert on instant-fail; Revive → resume from checkpoint; Done → dismiss; Play again → full run reset, high score persisted.

---

## Findings / Evidence

| Check | Finding | Code path |
|-------|--------|-----------|
| **Allowed moves when rules permit** | Revive dialog is shown on every instant-fail (no monetization branch). Single UIAlertController with "Revive" and "Done". | `GameViewController.showReviveOrGameOver`; `gameSceneDidRequestGameOver` → that method. |
| **Revive → resume** | "Revive" calls `scene.resumeFromCheckpoint()`. Clears `gameOverRequested`, restores segment (index + seed), segmentTime = 0, player to start lane. | `GameScene.resumeFromCheckpoint()`; `ScoreKeeper` unchanged (currentScore/highScore not reset). |
| **Done → dismiss** | "Done" is `UIAlertAction(..., .cancel)` with empty handler. Alert dismisses; no transition to new run. | `GameViewController` line 71. |
| **Play again** | **Implemented.** GameViewController shows "Play again" in game-over alert; tap calls `startNewGame()`, which creates a new GameScene and presents it. Rule-valid outcome "new run" is **reachable**. | `GameViewController.showReviveOrGameOver` adds "Play again" action; `startNewGame()` presents new GameScene. |
| **State consistency after Revive** | After `resumeFromCheckpoint()`, segment, lane, and time are restored; gameplay continues. Score unchanged (correct per spec). | `GameScene` 281–293. |
| **State consistency after Play again** | **Re-validated.** `startNewGame()` creates a **new** `GameScene(size: DesignSize)`. Each GameScene has its own `ScoreKeeper()`; ScoreKeeper init reads highScore from UserDefaults. New scene therefore has currentScore = 0, highScore persisted. Full reset and high-score persistence match spec. | `GameViewController.startNewGame()`; `GameScene` private `scoreKeeper = ScoreKeeper()`; `ScoreKeeper.init` loads highScore from UserDefaults. |

---

## Issues (logic-test)

1. ~~**Unreachable valid state: new run.**~~ **Resolved.** "Play again" CTA is present; `startNewGame()` presents a new GameScene; new run is reachable.
2. **No dead-end from Revive.** Revive → resume is consistent; no unreachable or invalid state observed.
3. ~~**CTA labels vs spec.**~~ **Resolved (CTA label alignment).** iOS and spec aligned to "Watch ad" / "No thanks" / "Play again" per docs/SPECIFICATION.md §1; GameViewController and JourneyTests updated 2026-02-23.

---

## Confidence & Gaps

- **Revive flow:** High — allowed move, state after resume consistent.
- **Play-again flow:** High — re-validated. "Play again" only offered from game-over alert; after tap, state = new run (new GameScene → currentScore 0, highScore from UserDefaults).

---

## Plan (for builder / Lane A)

1. ~~**Add "Play again" CTA**~~ **Done.** Present in GameViewController.
2. ~~**New-run implementation**~~ **Done.** `startNewGame()` creates and presents a new `GameScene`; new scene's ScoreKeeper reads highScore from UserDefaults; currentScore = 0.
3. **Validation:** After "Play again", (1) gameplay is active, (2) current score is 0, (3) high score is unchanged from previous run, (4) segment/generator state is fresh. **Re-validation complete.**
4. ~~**Optional: accessibility identifiers**~~ **Done.** `GameView` (SKView), `GameOverAlert` (alert) per e2e-investigation-findings.

---

## Master-Plan

This is a **logic-test deliverable** for P001-E2E-Journeys. No new Plan ID; P001-E2E-Journeys row already calls out logic-test per §6.1. When "Play again" is implemented, update this doc or add "Logic-test re-validation: complete" and date.

---

## Completion handoff

When Lane A implements "Play again", **re-invoke logic-test** (or Investigator) to confirm: allowed moves, no unreachable states, state consistency after Play again. Consider this engagement **complete** after Play-again is implemented and re-validated.

**2026-02-23:** "Play again" CTA and `startNewGame()` already present in GameViewController; accessibility identifiers added (`GameView`, `GameOverAlert`). Logic-test re-validation: **complete.** Allowed moves: Revive, Play again, Done only from game-over state; no unreachable valid states; state after Play again = new GameScene (currentScore 0, highScore from UserDefaults). Investigator handoff: plan/doc updated; no new plan ID; P001-E2E-Journeys row in Master-Plan already references logic-test per §6.1.

**2026-02-23 (CTA alignment):** iOS and spec aligned to "Watch ad" / "No thanks" / "Play again". GameViewController and JourneyTests updated; SPECIFICATION.md §1 and Master-Plan updated. Logic-test accepts these labels; no re-run required for label change (behavior unchanged).
