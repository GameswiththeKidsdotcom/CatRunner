# Tier 2 — Defect remediation (prioritized roadmap)

**Plan:** Prioritized roadmap (Testing → Defects → App Store → Features). **Lane:** Lane A (ios/ + docs). No Lane B conflict.

Deliverables (spec/impl gaps closed):

1. **Revive vs monetization** — doc + minimal branch  
2. **Admin config save semantics** — document  
3. **Score in alert only vs in-game HUD** — document  

---

## 1. Revive vs monetization

**Gap:** Spec says "revive (IAP or rewarded ad per monetization config)"; implementation always showed one alert with no branch on config.

**Confidence (root cause):** High — e2e-investigation-findings and code inspection.

**Done:**
- **Doc:** [docs/SPECIFICATION.md](../../../docs/SPECIFICATION.md) §1 (Revive) and §9 (Monetization) updated: when both `reviveIAPProductId` and `rewardedAdPlacementId` are null/empty, dialog shows only "Play again" and "No thanks"; when at least one is set, "Watch ad" is also shown.
- **Minimal branch (iOS):** `GameScene.isReviveMonetizationConfigured` added; `GameViewController.showReviveOrGameOver` adds "Watch ad" action only when `scene.isReviveMonetizationConfigured` is true.

**Validation:** Default variant has both IDs null → game over shows 2 actions (Play again, No thanks). Set one ID in variant.json, rebuild → 3 actions (Watch ad, Play again, No thanks). **E2E:** `JourneyTests` updated: J3 asserts only "Play again" and "No thanks"; J4a uses `XCTSkip` when "Watch ad" is not present (default config). 58 + 6 tests run; J4a skipped with default variant; 0 failures.

**Rollback:** Revert GameScene/GameViewController changes; restore SPECIFICATION.md §1/§9 sentences. No schema change.

---

## 2. Admin config save semantics

**Gap:** Investigation 3 noted "Need to confirm GET/POST behavior; document save semantics."

**Confidence (root cause):** High — API and admin-config read in full.

**Done:**
- **SPECIFICATION.md §5:** Short subsection "Admin config save semantics (Tier 2)" added: GET/PUT paths from admin.json, validation, file overwrite, no git commit, no auth, iOS bundle at build time.
- **Standalone doc:** [docs/admin-config-save.md](../../../docs/admin-config-save.md) — API, path resolution, GET/PUT behavior, semantics table, confidence and validation.

**Rollback:** Remove subsection from §5; delete admin-config-save.md if desired.

---

## 3. Score in alert only vs in-game HUD

**Gap:** Score was only in game-over alert; spec did not state "no in-game HUD."

**Confidence (root cause):** High — e2e-investigation-findings; ScoreKeeper in scene, no SKLabelNode for score.

**Done:**
- **Doc only:** [docs/SPECIFICATION.md](../../../docs/SPECIFICATION.md) §1 (Scoring): "**Score display (Tier 2):** Score and high score are shown **in the game-over alert only**; there is no in-game score HUD in the current implementation. Optional in-game HUD is Tier 4."

**Validation:** No code change; E2E already asserts game-over message content. Tier 4 may add in-game HUD per roadmap.

**Rollback:** Remove the Score display sentence from §1.

---

## Risks and validation strategy

- **Risks:** Revive branch could break E2E if tests expect exactly 3 buttons; default variant has no monetization → 2 buttons. Update E2E expectations if they assert on "Watch ad" always present.
- **Validation:** Run full test suite (`npm run test:full`; `xcodebuild test` from ios/) after changes; confirm 64 tests pass. Manual: game over with default config → 2 actions; with one monetization ID set → 3 actions.

---

## Master-Plan hand-off

Tier 2 complete. **Next priority:** Tier 3 (Scalability for App Store) per prioritized roadmap.
