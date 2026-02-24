---
name: Score HUD Safe Area and High-Score Paradigm
overview: Fix the in-game score HUD so it is not covered by the Dynamic Island (or notch) on iPhone 15 Plus and similar devices, and document the "growing score / beat your high score" paradigm with recommended user features (Quick MVP, Scalable, Innovative per ideation).
plan_id: P003
todos: []
isProject: false
---

# Score HUD Safe Area and High-Score Paradigm

**Next hand off:** Chunks 1, 2, 3 done (2026-02-24). Optional: 5-iPhone E2E matrix, lane accessibility IDs (e2e-spec-journeys.plan.md), or other backlog.

---

## 1. Problem: Score covered by Dynamic Island on iPhone 15 Plus

- **Current behavior:** In [ios/CatRunner/Game/GameScene.swift](ios/CatRunner/Game/GameScene.swift), the score HUD is positioned at a fixed offset from the scene top:
  - `scoreHUDLabel.position = CGPoint(x: size.width / 2, y: size.height - 24)` (line 144).
- The scene uses a fixed **design size** (393×852) in [ios/CatRunner/GameViewController.swift](ios/CatRunner/GameViewController.swift) with `scaleMode = .aspectFit`. The **SKView** is full-screen (`skView.frame = view.bounds`), so on devices with a notch or Dynamic Island the system UI overlaps the top of the visible scene. The score at `y = size.height - 24` therefore appears under the black oval (Dynamic Island) on iPhone 15 Plus and similar devices.
- **Root cause:** No safe-area awareness; the HUD is placed in scene coordinates without accounting for the view's `safeAreaInsets`.

### Confidence — §1

| Metric | Value | Note |
|--------|--------|------|
| **Confidence (root cause)** | 95% | Evidence: fixed offset in scene space, full-screen SKView, no safe-area handling; code paths and design size verified. |
| **Confidence (solution path)** | N/A | Section is problem statement only. |

---

## 2. Solution: Safe-area-aware score HUD position

- **Recommended approach:** Keep gameplay in fixed design size and aspectFit; only adjust **HUD placement** so it sits below the safe area in **scene coordinates**.
- **Flow:**
  - **GameViewController** knows `view.safeAreaInsets` and `view.bounds`. After layout (e.g. in `viewDidLayoutSubviews`), compute a **top safe margin in scene coordinates** and pass it to the scene.
  - **Conversion (view → scene):** With `scaleMode = .aspectFit`, scale is `s = min(view.bounds.width/393, view.bounds.height/852)`. The top of the visible scene in view coords is `viewTop = (view.bounds.height - 852*s) / 2`. The amount of safe area that overlaps the scene (in view coords) is `overlap = max(0, safeAreaInsets.top - viewTop)`. In scene coords that is `topMarginScene = overlap / s`. So the score should be at least `topMarginScene` points below the scene top.
  - **GameScene** exposes a method such as `setTopSafeAreaMargin(_ margin: CGFloat)` (or a property set by the VC). In `setupScoreHUD()` use a default margin (e.g. 24) so the scene works before the VC sets it; when the VC sets the margin, update `scoreHUDLabel.position.y = size.height - margin - 24` (or use a small padding constant).
- **Edge cases:** (1) When the VC has not yet set the margin (e.g. unit tests, or first frame), use a fallback (e.g. 24 or a conservative 59 for Dynamic Island). (2) On devices without a notch, `safeAreaInsets.top` may be 0 or small; the formula yields a small or zero margin, so the HUD stays near the top. (3) If the scene is not yet presented, defer the margin update until after `presentScene`; calling from `viewDidLayoutSubviews` after the scene is presented is sufficient.
- **Standardization:** Using the computed margin from actual `safeAreaInsets` automatically handles all iPhone variants (notch, Dynamic Island, SE without notch). No device-specific constants required.

**Key files:**

- [ios/CatRunner/GameViewController.swift](ios/CatRunner/GameViewController.swift): In `viewDidLayoutSubviews`, compute `topMarginScene` and call `gameScene?.setTopSafeAreaMargin(topMarginScene)`.
- [ios/CatRunner/Game/GameScene.swift](ios/CatRunner/Game/GameScene.swift): Add `setTopSafeAreaMargin(_:)`, store it, use it in `setupScoreHUD()` and when updating HUD position (e.g. if layout changes on rotation).

**Validation:** Run on iPhone 15 Plus (or simulator with Dynamic Island) and confirm the score text is fully visible below the island; run on iPhone SE (no notch) and confirm the score remains near the top with no excessive gap.

**Risks:** If the VC calls the setter before the scene has added the HUD, the stored margin will still be applied when `setupScoreHUD()` runs (use the stored value in `setupScoreHUD()` so order doesn't matter). Rotation or safe-area changes: call the setter again from `viewDidLayoutSubviews` and update the HUD position so it stays correct.

**Rollback:** Revert the VC and GameScene changes; the HUD returns to fixed `y = size.height - 24` (covered on notched devices).

### Confidence — §2

| Metric | Value | Note |
|--------|--------|------|
| **Confidence (root cause)** | N/A | Section is solution only. |
| **Confidence (solution path)** | 93% | Formula and call sites specified; edge cases and rollback documented; portrait/aspectFit assumption noted for future landscape. |

---

## 3. Growing score / beat your high score paradigm

- The game **already implements** this: [ios/CatRunner/Game/ScoreKeeper.swift](ios/CatRunner/Game/ScoreKeeper.swift) keeps `currentScore` and `highScore`, persists high score in UserDefaults (`CatRunnerHighScore`), and the in-game HUD and game-over alert show "Score: X | High: Y" (SPEC §1).
- **Paradigm:** Score grows during a run (time + segments + multiplier); the player's goal is to beat their persisted high score. No change required to scoring logic; the work is (1) safe-area fix above, and (2) optional UX/features below.

### Confidence — §3

| Metric | Value | Note |
|--------|--------|------|
| **Confidence (root cause)** | 95% | Evidence: ScoreKeeper and SPEC §1 verified; no defect in paradigm. |
| **Confidence (solution path)** | N/A | Descriptive; no build steps in this section. |

---

## 4. Other user features for this paradigm (ideation-style)

Per [Agents/ideation.md](Agents/ideation.md), three approaches:

### Quick MVP

- **"New high score!" moment:** When `currentScore` exceeds the previous `highScore` during a run, show a short in-game cue (e.g. a small label or particle burst) and/or emphasize it in the game-over alert ("New record! X").
- **Game-over copy:** In the alert, if this run was a new high score, title or message could say "New record!" and show the new high score prominently.
- **Minimal scope:** One-time celebration (in-game and/or in alert); no new persistence or screens.

### Scalable

- **Local score history:** Persist last N runs (e.g. 5–10) with score and date; show "Last runs" or "Recent scores" on a simple stats/score screen or in the game-over flow.
- **Basic stats:** Total games played, average score, "best streak" (consecutive runs beating previous high). Stored in UserDefaults or a single JSON file.
- **Clear "High score" emphasis:** Main menu or pre-game screen showing current high score and optional "Beat your best: X" so the goal is visible before each run.
- **Schema/APIs:** If you later add a backend, a single "scores" or "player_stats" table and one or two endpoints would extend this without changing the core loop.

### Innovative / Alternative

- **Goals and milestones:** "Reach 500", "Reach 1000", "Beat 2000"; optional badges or unlock hints to increase motivation.
- **Daily or weekly challenge:** "Today's goal: 1500" (could be random or fixed); completion could unlock a visual or a future "challenge mode."
- **Lightweight leaderboard:** Local-only "best 5" with optional future sync to a global leaderboard (e.g. Game Center or Supabase).
- **Onboarding/tooltip:** First launch or first game over: short tip "Your goal each run is to beat your high score."

### Confidence — §4

| Metric | Value | Note |
|--------|--------|------|
| **Confidence (root cause)** | N/A | Ideation only. |
| **Confidence (solution path)** | 90% | Options are consistent with paradigm and SPEC; implementation deferred. |

---

## 5. Suggested components (for implementation later)

- **Safe-area fix (this plan):** GameViewController view-to-scene conversion and `setTopSafeAreaMargin`; GameScene property + HUD positioning.
- **New high score celebration (Quick MVP):** GameScene or ScoreKeeper detects when `currentScore` surpasses previous `highScore`; trigger a one-time visual (label/node) and/or a flag so GameViewController can show "New record!" in the alert.
- **Score history / stats (Scalable):** New small type or storage (e.g. `ScoreHistory` writing to UserDefaults); optional "Stats" or "Scores" screen in iOS (new view or presented from game-over).
- **Spec/docs:** Update [docs/SPECIFICATION.md](docs/SPECIFICATION.md) §1 or §7 to mention that the in-game score HUD respects the safe area on notched/Dynamic Island devices, and optionally document "beat your high score" as the intended player goal.

### Confidence — §5

| Metric | Value | Note |
|--------|--------|------|
| **Confidence (root cause)** | N/A | Component list. |
| **Confidence (solution path)** | 92% | Safe-area fix is specified; optional items scoped for later. |

---

## 6. Validation and risks

- **Validation:** (1) Manual check on iPhone 15 Plus (or simulator) that the score is fully visible. (2) Manual check on non-notched device that the score is not pushed down unnecessarily. (3) Existing unit tests for ScoreKeeper and any GameScene tests still pass; add or extend a test that sets a top margin and checks HUD position if desired.
- **Risks:** Safe-area computation assumes portrait and aspectFit; if the app later supports landscape or different scale modes, the conversion may need to be revisited.
- **Master plan:** After implementation, add a short note to [.cursor/Plans/Master-Plan.md](.cursor/Plans/Master-Plan.md) under history or next hand-off that "Score HUD safe area (iPhone 15 Plus / Dynamic Island)" is done and optional "high score paradigm" features are documented here.

### Confidence — §6

| Metric | Value | Note |
|--------|--------|------|
| **Confidence (root cause)** | N/A | Validation/risks section. |
| **Confidence (solution path)** | 92% | Validation strategy and risks documented; test plans added in §7–§9. |

---

## 7. Test plans (Step 2 — ui-test, logic-test, infrastructure)

### 7.1 ui-test plan

- **Scope:** E2E/viewport checks that the score HUD is visible and not covered by system UI (Dynamic Island or notch).
- **Devices/viewports:** (1) **iPhone 15 Plus** or simulator with Dynamic Island (e.g. iPhone 15 Pro, 15 Pro Max) — confirm score text is fully visible below the island. (2) **iPhone SE (3rd gen)** or simulator without notch — confirm score remains near the top with no excessive gap.
- **Journey:** Launch app → start or resume game → verify score HUD is visible and readable (no clipping by safe area). Optional: screenshot baseline for "score visible" frame.
- **Tooling:** iOS XCUITest (existing `ios/CatRunnerUITests/JourneyTests.swift`); add or extend a test that asserts score HUD visibility (e.g. element or screenshot) on the chosen simulators. Parameterize over destination if desired (e.g. iPhone 16 + iPhone 15 Pro Max + iPhone SE).
- **Priority:** At least one test on Dynamic Island simulator and one on non-notched simulator to cover the fix.

### 7.2 logic-test plan

- **Scope:** Margin application and HUD position logic (no game rules change).
- **Test cases:** (1) **setTopSafeAreaMargin:** When GameScene receives `setTopSafeAreaMargin(M)` (e.g. M = 59), the score HUD node's position.y equals `size.height - M - padding` (e.g. padding 24) after `setupScoreHUD()` or after the setter runs. (2) **Fallback:** When margin has not been set (e.g. in unit test with no VC), HUD uses default margin (e.g. 24) so position.y = size.height - 24 - 0 or equivalent. (3) **ScoreKeeper unchanged:** Existing ScoreKeeper unit tests (e.g. `ScoreKeeperTests`) still pass; no change to scoring logic.
- **Implementation:** Unit test in `ios/CatRunnerTests/` (e.g. new test file or extend existing GameScene/score test if any): create GameScene(size: DesignSize), call setTopSafeAreaMargin(59), then verify scoreHUDLabel.position.y. Use design size 393×852 for reproducibility.
- **Evidence:** Document in plan that margin flows from VC (view coordinates) to scene (scene coordinates); HUD position is deterministic given margin.

### 7.3 infrastructure outcome

- **Conclusion:** No new hosting, persistence, or CI required. The fix is local to the iOS app; uses existing UserDefaults and app bundle. Existing CI (e.g. `test.yml` with iOS simulator) can run the new unit tests and existing E2E; no new services or env vars.
- **Documentation:** This outcome is recorded here (§7.3) and in Chunk 1 sub-plan so the plan reflects zero-cost, offline-first alignment.

---

## 8. Reconcile (Step 3 — Investigator)

- **Test plans reflected:** §7.1–7.3 are incorporated; validation in §6 is satisfied by (1) manual checks, (2) ui-test plan (E2E/viewport), (3) logic-test plan (unit test for margin and HUD position), (4) existing ScoreKeeper tests.
- **Risks unchanged:** Portrait/aspectFit assumption and rollback remain as in §2 and §6.
- **Confidence:** All sections §1–§6 meet >90% where applicable; test plans and infra outcome close remaining gaps for Chunk 1.

---

## 9. Build chunks (Step 4 — Planner)

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| **Chunk 1** | Safe-area fix: VC computes topMarginScene, GameScene setTopSafeAreaMargin + HUD position | **Done (2026-02-24)** | 95% | 93% | Sub-plan: [Chunk1-SafeArea-Fix.plan.md](.cursor/Plans/subplans/P003/Chunk1-SafeArea-Fix.plan.md). |
| **Chunk 2** | "New high score!" celebration (in-game and/or game-over) | **Done (2026-02-24)** | N/A | 90% | ScoreKeeper.didBeatHighScoreThisRun; in-game label; VC "New record!" alert; SPEC §1. |
| **Chunk 3** | Spec/docs update (SPEC §1/§7, Master-Plan hand-off note) | **Done (2026-02-24)** | N/A | 92% | Lane A hand off; docs only. |

---

## 10. Per-chunk fidelity (Step 5 — Chunk 1 only)

- **ideation:** Safe-area fix scope confirmed: only HUD placement changes; gameplay area and design size unchanged. No implied UX change beyond score visibility.
- **Investigator:** Chunk 1 validated; Confidence (root cause) 95%, Confidence (solution path) 93%; persisted in Chunk 1 sub-plan and Master-Plan.
- **ui-test:** E2E/viewport coverage for "score visible on 15 Plus and SE" captured in §7.1; implement when building Chunk 1.
- **logic-test:** Unit test coverage for margin and HUD position captured in §7.2.
- **infrastructure:** "No new infra" confirmed in §7.3.
- **e2e-harness:** User journey "score visible after play" is covered by existing J1–J5 style flow (launch → play → game over); add assertion or screenshot for score HUD visibility on at least one Dynamic Island and one non-notched simulator in the journey suite (see §7.1).
