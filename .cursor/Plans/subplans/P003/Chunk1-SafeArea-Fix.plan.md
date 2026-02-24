---
name: Chunk 1 — Safe-area-aware score HUD
plan_id: P003
chunk_id: Chunk1
overview: GameViewController computes top safe margin in scene coordinates and passes to GameScene; GameScene sets score HUD position below safe area. No gameplay area change.
---

# Chunk 1 — Safe-area-aware score HUD

**Next hand off (cut & paste):** ~~Implement safe-area-aware score HUD per this sub-plan.~~ **Done 2026-02-24.** Manual validation completed: looks good on iPhone 16 Plus and iPhone SE (P002-iPhone-SE-3). In GameViewController.viewDidLayoutSubviews compute topMarginScene (view→scene conversion for aspectFit), call gameScene?.setTopSafeAreaMargin(topMarginScene). In GameScene add setTopSafeAreaMargin(_:), store margin, use in setupScoreHUD() and when updating HUD position.

---

## Scope

- **Goal:** Score HUD is not covered by Dynamic Island (or notch) on iPhone 15 Plus and similar devices; remains correct on non-notched devices (e.g. iPhone SE).
- **In scope:** GameViewController (margin computation, call to scene); GameScene (setter, storage, HUD position).
- **Out of scope:** Gameplay area, design size, scale mode; new high score celebration; spec/docs update (Chunk 3).

## Steps (verifiable)

1. **GameScene:** Add property `private var topSafeAreaMargin: CGFloat = 24` (fallback). Add `func setTopSafeAreaMargin(_ margin: CGFloat)` that sets the property and updates `scoreHUDLabel.position.y = size.height - margin - 24` (if scoreHUDLabel is in the scene). In `setupScoreHUD()` set position using `topSafeAreaMargin` so order of setter vs setup doesn't matter.
2. **GameViewController:** In `viewDidLayoutSubviews`, after `skView?.frame = view.bounds`, compute: `let designW: CGFloat = 393`, `let designH: CGFloat = 852`, `let scale = min(view.bounds.width/designW, view.bounds.height/designH)`, `let viewTop = (view.bounds.height - designH*scale)/2`, `let overlap = max(0, view.safeAreaInsets.top - viewTop)`, `let topMarginScene = overlap / scale`. Call `gameScene?.setTopSafeAreaMargin(topMarginScene)`.
3. **Validation:** Run on simulator with Dynamic Island (e.g. iPhone 15 Pro Max) and confirm score is fully visible; run on iPhone SE and confirm no excessive gap. Run existing unit tests (ScoreKeeper, etc.) and iOS UI tests.
4. **Optional unit test:** In CatRunnerTests, add test that creates GameScene(size: CGSize(width: 393, height: 852)), calls setTopSafeAreaMargin(59), then asserts scoreHUDLabel.position.y == 852 - 59 - 24 (or equivalent). Gate on scoreHUDLabel being present after setup.

## Detailed design

- **View→scene conversion:** Design size is (393, 852). aspectFit scale `s = min(vw/393, vh/852)`. Scene top in view coords: `viewTop = (vh - 852*s)/2`. Safe area overlaps scene by `overlap = max(0, safeAreaInsets.top - viewTop)` in view coords. In scene coords: `topMarginScene = overlap / s`. VC uses this so the HUD sits exactly below the safe area.
- **When setter is called:** From viewDidLayoutSubviews after the scene is presented; may run before or after didMove(to:). GameScene uses stored `topSafeAreaMargin` in setupScoreHUD(), so if setter was already called, HUD gets correct position; if not, fallback 24 is used until next layout.
- **Rotation / safe-area change:** viewDidLayoutSubviews runs again; VC recomputes and calls setter; GameScene updates position. No extra handling if setter updates position immediately.

## Best route

1. Implement GameScene: add `topSafeAreaMargin`, `setTopSafeAreaMargin`, and use margin in setupScoreHUD() and in setter to update position.
2. Implement GameViewController: in viewDidLayoutSubviews compute topMarginScene and call setTopSafeAreaMargin.
3. Manual test on two simulators (Dynamic Island + SE).
4. Add or extend unit test for HUD position; run full suite.
5. Optionally add E2E assertion for score visibility (ui-test plan §7.1).

## Validation

- Manual: Score visible below Dynamic Island on iPhone 15 Plus (or 15 Pro Max sim); score near top on iPhone SE.
- Unit: Existing ScoreKeeper and GameScene-related tests pass; new test for setTopSafeAreaMargin and HUD position if added.
- E2E: Existing J1–J5 pass; optional new check for score HUD visibility on chosen simulators.

## Rollback

Revert GameViewController and GameScene changes; score HUD returns to fixed `y = size.height - 24`. No data or config changes.

## Risks

- Portrait and aspectFit only; landscape or other scale modes would need separate conversion (out of scope for this chunk).

---

## Confidence (per-chunk fidelity)

| Metric | Value | Note |
|--------|--------|------|
| **Confidence (root cause)** | 95% | Root cause is fixed HUD offset and no safe-area; evidence from code and design size. |
| **Confidence (solution path)** | 93% | Steps, formula, and integration points specified; rollback and tests documented. |
