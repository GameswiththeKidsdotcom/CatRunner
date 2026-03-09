# Master-Plan — CatRunner

## Where we are (assessment)

**As of 2026-03-09:** Tiers 1–6 are complete. **Tier 7 (App Store submission):** T7-C1, T7-C2, T7-C3 done. **SlideJumpCatAnimation** (C1–C4) done. **RightLaneTap** (lane boundary tap visual/collision desync) — C1+C2+C3 done; pushed. **CatTransparency** (idle/jump/slide transparent) — C1+C2 done. Plan work is **clear for App Store submit**. Baseline: `npm run test:full` (Vitest) and iOS (85 tests = 77 CatRunnerTests + 8 CatRunnerUITests, 2 skipped) passing.

### Pre–App Store submit: remaining plans (clear before submit)

**Remaining plan work before first App Store submit:** **None.** **Right-lane-tap visual/collision mismatch** fixed and pushed 2026-03-09: tap right (or left) when cat on rightmost (or leftmost) lane no longer desyncs visual from hitbox. Plan: [RightLaneTap-VisualBug.plan.md](.cursor/Plans/subplans/RightLaneTap/RightLaneTap-VisualBug.plan.md). Cat jump/slide assets have been polished (`cat_jump.png`, `cat_slide.png` in `assets/character/`) via **ui-designer** per [CAT-WORLD-VISION.md](assets/CAT-WORLD-VISION.md) and hero mockup (2026-03-02). Config and PlayerNode are already wired; plans remain clear for App Store submit. Plan: [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md). Agent: **ui-designer** or **generalPurpose** per [Agents/planner.md](Agents/planner.md).

---

## Next hand off (cut & paste) — Lane A

**Copy-paste this prompt for the next Lane A action:**

**Primary:** Execute **App Store submission** per docs/app-store-readiness.md; or **SeamlessBackground C2** (object integration) when C1 (background assets) done. Plan: [Tier7-AppStoreSubmission.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/Tier7-AppStoreSubmission.plan.md) or [C2-ObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/C2-ObjectIntegration.plan.md). Agent: **generalPurpose**.

---

## Next hand off (cut & paste) — Lane B

**Copy-paste this prompt for the next Lane B action:**

**Primary:** Execute **SeamlessBackground C1** — Generate seamless sky.png and ground.png (786×1800 px) per [C1-BackgroundAssets.plan.md](.cursor/Plans/subplans/SeamlessBackground/C1-BackgroundAssets.plan.md). Use **ui-designer** subagent. Save to assets/backgrounds/. No conflict with Lane A (assets/ only).

---

## Optional and deferred work (backlog)

When picking up the next larger task, consider these optional items so they are not lost. Complete at any time; order below is by lane and then by area.

**Lane B:** Lane B may pick up any deferred or optional item below that is **config/ or assets/ only**, when it **does not conflict with current Lane A focus** (no shared files, no dependency on in-progress Lane A work). When Lane A is focused on a given plan (e.g. P003 Chunk 2), Lane B can run in parallel on the Lane B rows in this backlog.

**Lane A (optional / deferred)**

| Item | Reference / plan | Note |
|------|------------------|------|
| 5-iPhone E2E matrix (CI job for SE, 14, 15, 16, 16 Pro Max) | [e2e-spec-journeys.plan.md](.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md) Investigation 4 | **Done (2026-02-24).** Job `test-ios-matrix` in test.yml; verified [optional-lane-a-verification.plan.md](.cursor/Plans/subplans/P001/optional-lane-a-verification.plan.md). |
| Lane accessibility IDs for E2E selectors | Same as above | **Done (2026-02-24).** LaneTapLeft/LaneTapRight, GameView, GameOverAlert; testJ2_LaneTapRegions; verified same plan. |
| "New high score!" celebration (in-game / game-over) | [P003-ScoreHUD-SafeArea.plan.md](.cursor/Plans/subplans/P003/P003-ScoreHUD-SafeArea.plan.md) Chunk 2 | **Done (2026-02-24).** |
| Spec/docs update (SPEC §1/§7, Master-Plan note) | P003 Chunk 3 | **Done (2026-02-24).** |
| App icon copy to AppIcon.appiconset | Pending work below | **Done (2026-02-24).** Copied to `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/AppIcon.png`. |
| Revive/play-again unit tests | Tier 1 optional | **Done (2026-02-24).** RevivePlayAgainTests.swift (hasRevivedThisRun, resumeFromCheckpoint, isReviveMonetizationConfigured). |
| Fastlane + deploy.yml enhancements; second simulator in CI | Tier 3 optional | **Done (2026-02-24).** F1–F4: documented current state; implemented `fastlane beta` (build_app + upload_to_testflight when API key set); deploy.yml runs `fastlane beta` when secrets present, else build + artifact; DEPLOY.md and ios/fastlane/README.md updated. Second simulator: test-ios-matrix already in test.yml. |
| Tier 2 completion doc in zz-archive | Path to archive table | **Done (2026-02-24).** [Tier2-defect-remediation-done.md](.cursor/Plans/subplans/P001/zz-archive/Tier2-defect-remediation-done.md) in zz-archive. |
| features-for-planner.md at .cursor/Plans/ | Features for planner § | **Done (2026-02-24).** [features-for-planner.md](.cursor/Plans/features-for-planner.md) created. |
| No thanks → menu (iPhone Plus) | [NoThanks-Menu-iPhonePlus.plan.md](.cursor/Plans/subplans/P001/NoThanks-Menu-iPhonePlus.plan.md) | **Done.** C1 + C2 implemented and validated. |
| T7-C3 (Submission checklist) | [T7-C3-SubmissionChecklist.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/T7-C3-SubmissionChecklist.plan.md) | **Done (2026-03-02).** First submission section in app-store-readiness; App Store Connect notes. |
| Seamless background + object integration | [SeamlessBackground-OptionsAndObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/SeamlessBackground-OptionsAndObjectIntegration.plan.md) | Option A (two layers) or B (single image); sprite grounding, shadows, lane overlay tuning. |
| **CatTransparency C2** | [C2-PlayerNodeClear.plan.md](.cursor/Plans/subplans/CatTransparency/C2-PlayerNodeClear.plan.md) | PlayerNode use `.clear` when runTexture present; removes tint on transparent areas. **Done (2026-03-09).** |

**Lane B (optional / deferred — when no conflict with current Lane A focus)**

| Item | Reference / plan | Note |
|------|------------------|------|
| Ensure app icon asset in assets/reference | **Done (2026-02-24);** [CatWorld-A7-appicon.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A7-appicon.plan.md) | Verified and resized to 1024×1024. Lane A or user copies to ios/ AppIcon.appiconset. |
| Asset-based overlays (game-over / revive) | Spec gaps §; assets/ui implementation-spec | **Done (2026-02-24).** gameOver.png, revivePanel.png, scorePanel.png at 9:16 and 9:1; spec/README updated. No ios/ change. |
| New variant or asset refresh | Master-Plan "Next hand off — Lane B" | When Planner defines config or asset work (e.g. new variant, asset refresh, doc under config or assets), Lane B picks it up; no conflict with Lane A if scope is config/ and assets/ only. |
| **ConfigVariantsDoc C1** | [C1-DocEasy.plan.md](.cursor/Plans/subplans/ConfigVariantsDoc/C1-DocEasy.plan.md) | **Done (2026-03-02).** easy.json documented in config/variants/README.md. Plan complete; both variants documented. |
| **Cat jump/slide asset polish (pre-submit)** | [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md) | **Done (2026-03-02).** Polished `cat_jump.png` and `cat_slide.png` generated via **ui-designer** per CAT-WORLD-VISION and saved to `assets/character/`. |
| Seamless background assets (sky.png, ground.png) | [SeamlessBackground-OptionsAndObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/SeamlessBackground-OptionsAndObjectIntegration.plan.md) | 786×1800 px, seamless top/bottom; runway band lower ~28%; cat-world style. |
| **CatTransparency C1** | [C1-ScriptExtend.plan.md](.cursor/Plans/subplans/CatTransparency/C1-ScriptExtend.plan.md) | Extend transparency script to cat_run.png, cat_jump.png, cat_slide.png; run on all 19 files. **Done (2026-03-09).** |

---

## History (completed hand-offs)

**(1) ui-test (Admin E2E) — done.** Playwright E2E for J6–J9 in `e2e/admin/journeys.spec.ts`; viewport projects desktop-1280 and desktop-1440; `npm run test:e2e` (20 passed, 2 skipped); CI job `admin-e2e` in [.github/workflows/test.yml](.github/workflows/test.yml). **(2) logic-test — done.** [logic-test-revive-playagain-2026-02-23.md](.cursor/Plans/subplans/P001/logic-test-revive-playagain-2026-02-23.md) updated; high confidence; CTA label alignment done. **(3) iOS E2E (J1–J5) — done. Pushed 2026-02-23.** XCUITest in `ios/CatRunnerUITests/JourneyTests.swift`; iPhone 16; 6 tests; CI runs with unit tests. **(4) CTA label alignment — done (2026-02-23).** iOS alert labels in `GameViewController.swift` and JourneyTests aligned to "Watch ad"/"No thanks"/"Play again" per [docs/SPECIFICATION.md](docs/SPECIFICATION.md) §1; spec and plan docs updated. No current mandatory Lane A task.

**(5) Tier 1 (Testing improvements) — done (2026-02-23).** (1) `npm run test:full` fixed: Vitest excludes `e2e/` ([vitest.config.ts](vitest.config.ts)); `test:full` runs unit only (1 test pass). (2) Baseline aligned: clean iOS run = 65 tests (58 CatRunnerTests + 7 CatRunnerUITests); [docs/SPECIFICATION.md](docs/SPECIFICATION.md) §7 and [Agents/tester.md](Agents/tester.md) updated to 65.

**(5) Tier 2 (Defect remediation) — done (2026-02-23).** (1) Revive vs monetization: doc in SPECIFICATION.md §1 and §9; minimal branch in iOS — `GameScene.isReviveMonetizationConfigured`, "Watch ad" only when variant has IAP or rewarded ad ID. (2) Admin config save: SPECIFICATION.md §5 subsection + [docs/admin-config-save.md](docs/admin-config-save.md). (3) Score in alert only: documented in SPECIFICATION.md §1 (no in-game HUD; Tier 4 optional). Plan: [tier2-defect-remediation-2026-02-23.md](.cursor/Plans/subplans/P001/tier2-defect-remediation-2026-02-23.md).

**(6) Tier 3 (Scalability for App Store) — done (2026-02-23).** (1) A7 app icon: copied `assets/reference/appIcon_catworld_1024.png` to `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/AppIcon.png`; updated Contents.json. (2) Fastlane: already in `ios/fastlane/`; deploy.yml runs tests (not just build). (3) App Store readiness: [docs/app-store-readiness.md](docs/app-store-readiness.md). (4) Second simulator: job `test-ios-se` (iPhone SE 3rd gen) in [.github/workflows/test.yml](.github/workflows/test.yml). Plan: [tier3-app-store-scalability-2026-02-23.md](.cursor/Plans/subplans/P001/tier3-app-store-scalability-2026-02-23.md).

**(7) P001-SpecGaps (first-revive-only) — done (2026-02-24). Pushed 2026-02-24.** GameScene.hasRevivedThisRun; VC gates "Watch ad" when true; set on revive, reset on new run. E2E J4c (second game-over path); 65 tests pass (58 unit + 7 UI). Logic-Test handoff per e2e-spec-journeys §6.1. Plans: [P001-SpecGaps-ideation-to-impl.plan.md](.cursor/Plans/subplans/P001/P001-SpecGaps-ideation-to-impl.plan.md), [spec-gaps-first-revive-only.plan.md](.cursor/Plans/subplans/P001/spec-gaps-first-revive-only.plan.md).

**(8) Tier 4 (New feature build-out) — done (2026-02-24). Pushed 2026-02-24.** Monetization stub (C8): confirmed (SPEC §9; "Watch ad" resumes from checkpoint); C8 Build Chunk Progress set to Done. In-game score HUD: added in GameScene (scoreHUDLabel at top, "Score: X | High: Y", updated each frame). Logic-Test §6.1 first-revive-only re-validation: completed and documented in logic-test-revive-playagain doc. Optional B5: [asset-integration.plan.md](.cursor/Plans/subplans/P001/zz-archive/asset-integration.plan.md) moved to zz-archive (B5 satisfied by BG3). Deferred: 5-iPhone E2E, lane accessibility IDs.

**(9) P003 Chunk 1 (Score HUD Safe Area) — done (2026-02-24).** GameViewController.viewDidLayoutSubviews computes topMarginScene (view→scene for aspectFit), calls gameScene?.setTopSafeAreaMargin(topMarginScene). GameScene: topSafeAreaMargin, setTopSafeAreaMargin(_:), applyScoreHUDPosition(); setupScoreHUD() uses margin. GameSceneSafeAreaTests added. 59 unit + 8 UI tests (2 skipped) pass; npm run test:full pass. Manual validation done (user confirmed looks good on iPhone 16 Plus and iPhone SE).

**(10) P003 Chunk 3 (Spec/docs update) — done (2026-02-24).** SPECIFICATION.md §1 (score display) and §7 (testing/baseline) updated to note that the in-game score HUD respects the safe area on notched/Dynamic Island devices. Master-Plan Next hand off and P003 row updated; Score HUD safe area (Chunk 1) noted done in History and Plan Matrix.

**(11) P003 Chunk 2 ("New high score!" celebration) — done (2026-02-24).** ScoreKeeper.didBeatHighScoreThisRun set when currentScore exceeds highScore, cleared on resetCurrentRun. GameScene: one-time in-game "New high score!" label (below score HUD, 2.5s then fade out); didBeatHighScoreThisRun exposed for VC. GameViewController: game-over alert title "New record!" when scene.didBeatHighScoreThisRun. ScoreKeeperTests: testDidBeatHighScoreThisRunSetWhenCurrentExceedsHigh, testDidBeatHighScoreThisRunNotSetWhenNotExceedingHigh. SPEC §1 updated. 61 unit + 8 UI (2 skipped) pass; npm run test:full pass.

**(12) Lane B — App icon source asset (2026-02-24).** Verified `assets/reference/appIcon_catworld_1024.png`; was 1376×768, resized to 1024×1024 with `sips -z 1024 1024`. Source exists for Lane A or user to copy to `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/AppIcon.png`. Reference: [CatWorld-A7-appicon.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A7-appicon.plan.md).

**(13) Optional Lane A — 5-iPhone E2E matrix + lane accessibility IDs (2026-02-24).** Read-only verification: job `test-ios-matrix` in [.github/workflows/test.yml](.github/workflows/test.yml) runs unit + UI on iPhone SE (3rd gen), 14, 15, 16, 16 Pro Max (fail-fast: false). LaneTapLeft/LaneTapRight, GameView, GameOverAlert in GameViewController; testJ2_LaneTapRegions_ExistAndTappable in JourneyTests. No code changes; plan [optional-lane-a-verification.plan.md](.cursor/Plans/subplans/P001/optional-lane-a-verification.plan.md).

**(14) Planner — Tier 5 (Tech debt and consolidation) plan created (2026-02-24).** Defined and registered Tier 5 plan focusing on code consolidation and cleanup in CatRunner iOS engine and tests. Parent plan: [Tier5-TechDebt-Consolidation.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/Tier5-TechDebt-Consolidation.plan.md). First chunk: T5-C1 (Single source for design size) — [T5-C1-DesignSize.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/T5-C1-DesignSize.plan.md). Build chunks T5-C1→T5-C8 (T5-C9 optional). Next hand off — Lane A updated to point at T5-C1.

**(15) Tier 5 (Tech debt) — complete (2026-02-24).** T5-C1 through T5-C9 done. **Committed and pushed 2026-02-24.** Next hand off updated; planner invoked.

**(16) Planner — Next priority after Tier 5 (2026-02-24).** No Tier 6 or next roadmap item defined. Plan: [Next-Priority-After-Tier5.plan.md](.cursor/Plans/Next-Priority-After-Tier5.plan.md). Mandatory Lane A: none. Optional Lane A: Fastlane + deploy.yml enhancements (F1–F4). Lane A (generalPurpose) to execute optional chunk.

**(17) Planner assessment — hand offs aligned (2026-02-28).** Assessed current state: Tiers 1–5 and optional F1–F4 done; no Tier 6 defined. Updated Master-Plan: added "Where we are" assessment; replaced Lane A and Lane B blocks with single **cut-and-paste prompts** per Agents/planner.md. Lane A prompt = invoke planner to define next priority; Lane B prompt = invoke planner when config/assets work defined. Same Lane A prompt added to top of Next-Priority-After-Tier5.plan.md. Concurrent agents and prioritized roadmap lines updated.

**(18) Planner — Tier 6 defined (2026-02-28).** Next priority for Lane A set to **Tier 6 (Ship readiness and baseline alignment)**. Plan: [Tier6-ShipReadiness.plan.md](.cursor/Plans/subplans/Tier6-ShipReadiness/Tier6-ShipReadiness.plan.md). First chunk: **T6-C1 (Baseline alignment)** — align docs/SPECIFICATION.md §7, Agents/tester.md, docs/app-store-readiness.md to one iOS test baseline; agent **generalPurpose**. Second chunk: T6-C2 (Ship-readiness doc). Master-Plan roadmap and Plan Matrix updated; Next hand off — Lane A set to T6-C1.

**(19) T6-C1 (Baseline alignment) — done (2026-02-28).** Ran iOS test suite from `ios/`: **83 tests** (75 CatRunnerTests + 8 CatRunnerUITests), 2 skipped (J4a, J4c when monetization not configured). Updated docs/SPECIFICATION.md §6–§7, Agents/tester.md, and docs/app-store-readiness.md to this baseline. Master-Plan "Where we are" updated. Next hand off — Lane A set to **T6-C2 (Ship-readiness doc)**.

**(20) T6-C2 (Ship-readiness doc) — done (2026-02-28).** Updated docs/app-store-readiness.md: added Ship readiness (Tier 6) note and optional "Ship it" checklist (summary: baseline green → build/archive → TestFlight → store metadata). Updated Master-Plan Path to archive for Tier 6; Tier 6 row and build chunk progress set to complete. Lane A next hand off: invoke planner to define next priority.

**(21) Planner — Tier 7 defined (2026-02-28).** Next priority for Lane A set to **Tier 7 (App Store submission and first release)**. Plan: [Tier7-AppStoreSubmission.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/Tier7-AppStoreSubmission.plan.md). First chunk: **T7-C1 (Store metadata and listing)** — create docs/app-store-listing.md with app name, subtitle, description, keywords, privacy, age rating; agent **generalPurpose**. Then T7-C2 (screenshots checklist), T7-C3 (submission checklist). Master-Plan roadmap and Plan Matrix updated; Next hand off — Lane A set to T7-C1.

**(22) T7-C1 (Store metadata and listing) — done (2026-02-28).** Created docs/app-store-listing.md with app name (CatRunner), subtitle (30 chars), description (under 4000 chars), keywords (99 chars, comma-separated), privacy note (no data collection in default; note for monetization), and age rating (4+). Master-Plan Tier 7 chunk progress and Next hand off updated to T7-C2.

**(23) T7-C2 (Screenshots and previews) — done (2026-02-28).** Created docs/app-store-screenshots.md with checklist, required iPhone/iPad screenshot sizes (Apple specs), capture method (simulator recommended, manual optional), and optional app preview specs. Updated docs/app-store-readiness.md (screenshot bullet) and docs/app-store-listing.md (Screenshots and previews section + reference). Master-Plan Tier 7 chunk progress and Next hand off updated to T7-C3.

**(24) Planner — No-Thanks Menu breakdown and Lane prompts (2026-02-28).** Broke down P001-NoThanksMenu into planner-style decomposition (feature → objects, ordered steps C1→C2). Updated **Next hand off — Lane A** to list primary (T7-C3 Submission checklist) and optional (P001-NoThanksMenu C1 then C2). Updated **Next hand off — Lane B** to state conflict rules (config/assets only, no shared files with Lane A) and to invoke planner when config/assets work is defined. Added cut-and-paste prompt to [NoThanks-Menu-iPhonePlus.plan.md](.cursor/Plans/subplans/P001/NoThanks-Menu-iPhonePlus.plan.md) and [C1-NoThanks-SecondAlert.plan.md](.cursor/Plans/subplans/P001/NoThanksMenu/C1-NoThanks-SecondAlert.plan.md) so next action is consistent from Master-Plan or sub-plan.

**(25) Blaster + Planner — Simulator always current build (2026-02-28).** Ran Blaster pipeline on simulator plan: root cause and solution path validated (>90% confidence); test/infra noted (no new E2E; local script only). Created plan **SimulatorCurrentBuild** with chunks C1 (doc: "Manual simulator testing" in app-store-readiness + optional tester.md), C2 (optional ios/run-simulator.sh + npm script). Registered in Master-Plan matrix and **Next hand off — Lane A** as optional task; added SimulatorCurrentBuild Build Chunk Progress table. Plan files: [SimulatorCurrentBuild.plan.md](.cursor/Plans/subplans/SimulatorCurrentBuild/SimulatorCurrentBuild.plan.md), [C1-Doc.plan.md](.cursor/Plans/subplans/SimulatorCurrentBuild/C1-Doc.plan.md), [C2-Script.plan.md](.cursor/Plans/subplans/SimulatorCurrentBuild/C2-Script.plan.md). **C1+C2 done; pushed 2026-02-28.**

**(26) Planner — SlideJumpCatAnimation added to Master-Plan (2026-03-01).** Registered plan **SlideJumpCatAnimation** (slide/jump = 2 obstacle lengths + cat as multi-frame animation per ui-designer). Created [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md) with chunks C1 (duration 1.1 s), C2 (config + assets jump/slide), C3 (PlayerNode animation state), C4 (easing + run cycle). Added to Plan Matrix, Build Chunk Progress, prioritized roadmap (After 7 optional), Path to archive, and Optional and deferred work. Lane A primary remains T7-C3; SlideJumpCatAnimation is next optional after Tier 7.

**(27) Planner — SlideJumpCatAnimation prioritized above T7-C3 (2026-03-01).** Submission checklist (T7-C3) moved below SlideJumpCatAnimation. Lane A primary = **SlideJumpCatAnimation** (C1–C4) first; then T7-C3. Lane B = SlideJumpCatAnimation C2 (config + assets). Next hand off, Plan Matrix, Build Chunk Progress, roadmap, and Concurrent agents updated.

**(28) SlideJumpCatAnimation C1–C4 + T7-C3 (2026-03-02).** C1: variant.json jumpDurationSeconds/slideDurationSeconds=1.1; C7MechanicsCollisionTests updated. C2: assets.json character.jump, character.slide; AssetConfig extended. C3: PlayerNode state-based textures (run/jump/slide); no procedural scale. C4: jump easing (easeInEaseOut); run cycle support (runFrameTextures). T7-C3: docs/app-store-readiness.md "First submission" section; App Store Connect notes. Master-Plan updated: plans clear for App Store submit.

**(29) Planner — Next priority after Tier 7 (2026-03-02).** SlideJumpCatAnimation (C1–C4) and T7-C3 done; plans clear for App Store submit. Next priority: **Execute App Store submission** (user action) per docs/app-store-readiness.md; or invoke planner for optional/post-release work. Plan: [Next-Priority-After-Tier7.plan.md](.cursor/Plans/Next-Priority-After-Tier7.plan.md). Lane A primary = user submission; Lane B = invoke planner when config/assets work defined.

**(30) Master-Plan — Cat jump/slide asset polish before submit (2026-03-02).** Added pre–App Store submit step: replace placeholder `cat_jump.png` and `cat_slide.png` with polished art via ui-designer per CAT-WORLD-VISION. Updated Pre–App Store submit section, Next hand off (Lane A + Lane B), Concurrent agents, and Lane B optional table. References [Agents/planner.md](Agents/planner.md).

**(31) Planner — Lane B ConfigVariantsDoc defined (2026-03-02).** Invoked planner per Agents/planner.md. Cat jump/slide asset polish complete. Defined Lane B work: **ConfigVariantsDoc C1** — document easy.json in config/variants/README.md. Plan: [ConfigVariantsDoc.plan.md](.cursor/Plans/subplans/ConfigVariantsDoc/ConfigVariantsDoc.plan.md), [C1-DocEasy.plan.md](.cursor/Plans/subplans/ConfigVariantsDoc/C1-DocEasy.plan.md). No conflict with Lane A (App Store submission — user action). Updated Master-Plan Next hand off — Lane B, Concurrent agents, Optional and deferred work.

**(32) ConfigVariantsDoc C1 — done (2026-03-02).** Documented easy.json in [config/variants/README.md](config/variants/README.md): obstacles (passable + slowdown only, no instantFail), clusterConfig disabled, engine (jumpDurationSeconds 0.5, slideDurationSeconds 0.6, baseSpeed 0.8, segmentDurationSeconds 2.5–4 s), gentler difficulty scaling. Lane B hand off updated to invoke planner for next config/assets work.

**(33) Planner — Lane B ConfigVariantsDoc complete; no further work defined (2026-03-02).** Invoked planner per Agents/planner.md. ConfigVariantsDoc C1 done; both easy.json and difficulty-spawn-ramp.json documented in config/variants/README.md. No further ConfigVariantsDoc chunks defined; no other config/assets work in backlog. Lane B idle. Next hand off — Lane B set to **None.**

**(34) Blaster — SeamlessBackground full pipeline (2026-03-02).** Ran full plan-validation pipeline per Agents/blaster.md: Step 1 Investigator (>90% per section); Step 2 ui-test, logic-test, infrastructure (test plans in [SeamlessBackground-TestPlans.plan.md](.cursor/Plans/subplans/SeamlessBackground/SeamlessBackground-TestPlans.plan.md)); Step 3 reconcile; Step 4 Planner (chunks C1, C2); Step 5 per-chunk fidelity. Plan: [SeamlessBackground-OptionsAndObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/SeamlessBackground-OptionsAndObjectIntegration.plan.md). Chunks: [C1-BackgroundAssets.plan.md](.cursor/Plans/subplans/SeamlessBackground/C1-BackgroundAssets.plan.md) (Lane B, ui-designer), [C2-ObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/C2-ObjectIntegration.plan.md) (Lane A). Added to Plan Matrix, Build Chunk Progress, prioritized roadmap (After 7 optional), Path to archive, and Optional and deferred work.

**(35) RightLaneTap — Lane boundary tap visual/collision desync (2026-03-09).** Defect: tap right (or left) when cat on rightmost (or leftmost) lane moved visual to center while hitbox stayed at boundary. Root cause: out-of-bounds lane index passed to `laneXPosition(for:)` returned center X. Fix: clamp before `moveToLane`, early return at boundary. C1 (GameScene.triggerLaneLeft/Right) and C2 (LaneBoundaryTapTests, playerContainerPositionForTesting) done. C3 (commit and push) pending. Plan: [RightLaneTap-VisualBug.plan.md](.cursor/Plans/subplans/RightLaneTap/RightLaneTap-VisualBug.plan.md). Added to Plan Matrix, Build Chunk Progress, Next hand off.

**(36) Planner — CatTransparency on path (2026-03-09).** Cat transparency and background fix (idle/jump/slide opaque box) added to Master-Plan path. Blaster pipeline complete. C1 (extend transparency script to cat_run.png, cat_jump.png, cat_slide.png) — Lane B. C2 (PlayerNode use .clear when runTexture present) — Lane A. Added to Plan Matrix, Build Chunk Progress, Prioritized roadmap (After 7 optional), Optional and deferred work, Path to archive, Next hand off (Lane A + Lane B), and Concurrent agents. Plan: [CatTransparency-TransparencyAndBackgroundFix.plan.md](.cursor/Plans/subplans/CatTransparency/CatTransparency-TransparencyAndBackgroundFix.plan.md).

**(37) RightLaneTap C3 — committed and pushed (2026-03-09).** fix(lane): boundary tap no-op to prevent visual/collision desync (RightLaneTap). Staged GameScene.swift, LaneBoundaryTapTests.swift, project.pbxproj; pushed to origin/main. Plan: [RightLaneTap-VisualBug.plan.md](.cursor/Plans/subplans/RightLaneTap/RightLaneTap-VisualBug.plan.md).

**(38) CatTransparency C2 — done (2026-03-09).** PlayerNode use `.clear` when runTexture present; `.systemTeal` when nil (tests). Edit [PlayerNode.swift](ios/CatRunner/Game/PlayerNode.swift) line 84. 77 CatRunnerTests pass. Plan: [C2-PlayerNodeClear.plan.md](.cursor/Plans/subplans/CatTransparency/C2-PlayerNodeClear.plan.md).

**(39) CatTransparency C1 — done (2026-03-09).** Script already extended to cat_run.png, cat_jump.png, cat_slide.png; ran `python3 scripts/add-transparency-to-cat-frames.py`; verified `sips -g hasAlpha` returns yes for all three. Plan: [C1-ScriptExtend.plan.md](.cursor/Plans/subplans/CatTransparency/C1-ScriptExtend.plan.md). Lane B hand off updated to SeamlessBackground C1.

**(40) CatTransparency C1+C2 — committed and pushed (2026-03-09).** fix(cat): transparency script + PlayerNode .clear (CatTransparency C1+C2). Staged script, cat_run.png, cat_jump.png, cat_slide.png, cat_jump_*.png, cat_slide_*.png, CatTransparency plan files; C2 (PlayerNode .clear) already in 97afbc9. Pushed fc507e5 to origin/main. npm run test:full and iOS tests (77 unit + 8 UI, 2 skipped) passed. Plan: [CatTransparency-TransparencyAndBackgroundFix.plan.md](.cursor/Plans/subplans/CatTransparency/CatTransparency-TransparencyAndBackgroundFix.plan.md). Next hand off — Lane A: App Store submission or SeamlessBackground C2 (when C1 done).

Completed items are listed here; update Next hand off above when a tier or task is done.

---

## Concurrent agents (max 2)

- **Lane A** edits `ios/` only. **Lane B** edits `config/` and `assets/` only (and may invoke ui-designer for asset images). No file overlap; both may run in parallel.
- **Hand-offs:** Lane A = **App Store submission** or **SeamlessBackground C2** (when C1 done). Lane B = **SeamlessBackground C1** (background assets sky.png, ground.png). CatTransparency C1+C2 pushed 2026-03-09. See "Next hand off (cut & paste)" at top of Master-Plan. iOS baseline: 85 tests (77 CatRunnerTests + 8 CatRunnerUITests, 2 skipped).
- When both lanes touch the same area (e.g. C3 and C7 both touch Engine), run sequentially.
- **Asset path and image spec:** Only [sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/zz-archive/sprites-ui-assets.plan.md) defines the asset inventory and `assets.json` path map; C2 creates the file, C9/admin consume it.

---

## Prioritized roadmap (controls our fate)

Work is ordered in seven tiers (plus optional post–Tier 7 work). Complete each tier before advancing; the **Next hand off — Lane A** above points at the current tier.

| Tier | Name | Goal | Key deliverables |
|------|------|------|-------------------|
| **1** | Testing improvements | Stabilize test runs, align baselines | Fix `test:full` (Vitest exclude e2e/); SPECIFICATION.md §7 baseline count = actual CI run; optional: revive/play-again unit tests |
| **2** | Defect remediation | Close spec/impl gaps | Revive vs monetization (doc or minimal branch); document admin config save semantics; score in alert only vs in-game HUD (doc or implement) |
| **3** | Scalability for App Store | TestFlight / store readiness | A7 app icon in AppIcon.appiconset; optional: fastlane + deploy.yml; App Store readiness checklist (doc); optional: second simulator in CI |
| **4** | New feature build-out | New functionality after 1–3 | Monetization stub (C8); in-game score HUD if not in Tier 2; optional: 5-iPhone E2E, lane accessibility IDs |
| **5** | Tech debt and consolidation | Code consolidation and cleanup in iOS engine and tests | Single source for constants (design size, time epsilon, lane defaults); extract fallback segment and segment-time margin; test helpers and README; optional naming. See [Tier5-TechDebt-Consolidation.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/Tier5-TechDebt-Consolidation.plan.md). |
| **6** | Ship readiness and baseline alignment | Align docs and baseline; ship-readiness checklist | Single baseline for iOS tests (SPEC §7, tester.md, app-store-readiness); ship-readiness doc and Master-Plan path. See [Tier6-ShipReadiness.plan.md](.cursor/Plans/subplans/Tier6-ShipReadiness/Tier6-ShipReadiness.plan.md). |
| **7** | App Store submission and first release | Store metadata, screenshots, submission checklist | Store listing doc (name, description, keywords, privacy, age); screenshot/preview checklist; submission checklist tied to app-store-readiness. See [Tier7-AppStoreSubmission.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/Tier7-AppStoreSubmission.plan.md). **Complete:** T7-C1, T7-C2, T7-C3 done 2026-03-02. |
| **After 7 (optional)** | Slide/jump duration + animated cat | Easier gameplay + cat as animation | Jump/slide = 2 obstacle lengths (1.1 s); cat = multi-frame run, jump, slide (no squash-and-stretch). **Complete (2026-03-02).** See [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md). |
| **After 7 (defect)** | Right-lane-tap visual/collision desync | Lane boundary tap no-op | Tap right/left at boundary no longer desyncs visual from hitbox. **Complete (2026-03-09).** See [RightLaneTap-VisualBug.plan.md](.cursor/Plans/subplans/RightLaneTap/RightLaneTap-VisualBug.plan.md). |
| **After 7 (optional)** | Cat transparency and background fix | Idle/jump/slide transparent; no box flash | Extend transparency script to cat_run.png, cat_jump.png, cat_slide.png; PlayerNode use .clear. **Complete (2026-03-09).** See [CatTransparency-TransparencyAndBackgroundFix.plan.md](.cursor/Plans/subplans/CatTransparency/CatTransparency-TransparencyAndBackgroundFix.plan.md). |
| **After 7 (optional)** | Seamless background + object integration | Seamless tiles, sprite grounding | 2× height sky/ground (786×1800 px); anchor (0.5,0), shadows, lane overlay. **Test plan ready.** See [SeamlessBackground-OptionsAndObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/SeamlessBackground-OptionsAndObjectIntegration.plan.md). |

Tier 5 complete and pushed 2026-02-24. **Tier 6** complete 2026-02-28 (T6-C1 baseline alignment, T6-C2 ship-readiness doc). **Tier 7** complete 2026-03-02 (T7-C1, T7-C2, T7-C3). **SlideJumpCatAnimation** (C1–C4) complete 2026-03-02. **RightLaneTap** (lane boundary tap desync) — complete 2026-03-09; pushed. **CatTransparency** — Complete (2026-03-09); C1+C2 done. **SeamlessBackground** — Blaster pipeline complete; C1 (assets) and C2 (object integration) pending.

**Spec gaps (ideation through implementation):** Gap analysis (spec vs app) and ideation review ([Agents/ideation.md](Agents/ideation.md) — Quick MVP / Scalable / Innovative) identified one remaining spec violation: **first-revive-only** (SPECIFICATION.md §1: "after that, game over is final"). Tier 2 closed doc and monetization branch; first-revive-only is implemented in **P001-SpecGaps** before Tier 4. Plan: [P001-SpecGaps-ideation-to-impl.plan.md](.cursor/Plans/subplans/P001/P001-SpecGaps-ideation-to-impl.plan.md) (ideation phase done; build chunk [spec-gaps-first-revive-only.plan.md](.cursor/Plans/subplans/P001/spec-gaps-first-revive-only.plan.md)). Test checkpoint: Logic-Test + E2E J4 second-game-over path. Deferred to Tier 4: in-game score HUD, asset-based overlays (implementation-spec).

Archived plans live under `.cursor/Plans/zz-archives/` (folder names start with `zz` so they are not pulled into messaging). See Plan Matrix and Pending / missed work below for per-plan state.

**Plan validation (zz prefix):** Completed or no-longer-active plans use the `zz` prefix so they are not accidentally pulled into messaging. **Whole plans** (completed, work pushed): in [zz-archives/zz-P002/](zz-archives/zz-P002/), [zz-archives/zz-Scroller-10s/](zz-archives/zz-Scroller-10s/), [zz-archives/zz-Many-buildings-bg/](zz-archives/zz-Many-buildings-bg/). **Reviews:** [zz-archives/zz-Reviews/](zz-archives/zz-Reviews/) (Blaster-Plan-Review). **P001 completed chunks:** in [subplans/P001/zz-archive/](subplans/P001/zz-archive/) (C1–C12, B1–B5, CatWorld A1–A7, ui-mockups, sprites-ui-assets, C9-admin-panel, admin-e2e-ui-test-plan, logic-test-revive-playagain). **Active P001:** P001-CatRunner.plan.md, P001-SpecGaps-ideation-to-impl.plan.md, spec-gaps-first-revive-only.plan.md, e2e-spec-journeys.plan.md, e2e-investigation-findings remain in subplans/P001 for reference. asset-integration.plan.md archived to zz-archive (2026-02-24).

---

## Plan Matrix

| Plan ID | Name | Priority | Description | Current state | Conf (root) | Conf (solution) |
|---------|------|----------|-------------|---------------|-------------|-----------------|
| P001 | CatRunner iOS Game | 1 | iOS endless runner, VariantConfig, admin, CI/CD. See [.cursor/Plans/subplans/P001/P001-CatRunner.plan.md](.cursor/Plans/subplans/P001/P001-CatRunner.plan.md). | Complete. **Pushed 2026-02-23.** | 92% | 93% |
| P001-Assets | Sprites & UI assets | 1 | Asset inventory, image specs, ui-designer workflow. Sub-plan of P001. See [.cursor/Plans/subplans/P001/zz-archive/sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/zz-archive/sprites-ui-assets.plan.md). | Validated | N/A | High |
| P001-UI-Mockups | UI mockups (Lane B) | 1 | In-game UI mockups: pixel art, Revive/Game over, store in assets/ui/. Sub-plan of P001. See [.cursor/Plans/subplans/P001/zz-archive/ui-mockups.plan.md](.cursor/Plans/subplans/P001/zz-archive/ui-mockups.plan.md). | Validated | N/A | High |
| P001-C9-NextJS | C9 Admin Next.js routes | 1 | Admin panel UI: config editor, asset upload, variant list, CI trigger. Sub-plan of P001. See [.cursor/Plans/subplans/P001/zz-archive/C9-admin-panel.plan.md](.cursor/Plans/subplans/P001/zz-archive/C9-admin-panel.plan.md). | **Complete.** Next.js routes built; paths from config/admin.json. | N/A | High |
| P001-CatWorld-Assets | Cat world asset replacement (Lane B) | 1 | Replace placeholder/pixel-art assets with cat-world art (soft cozy 2D, rooftops at night). Sub-plan of P001. See [.cursor/Plans/subplans/P001/zz-archive/CatWorld-assets.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-assets.plan.md). Phases A1–A7: character, obstacles, enemies, backgrounds, power-ups, UI, app icon. | **Complete.** | N/A | High |
| P001-Asset-Integration | iOS asset bundle and visuals | 1 | Integrate config + assets into app bundle and render character/obstacles/power-ups from assets.json. Sub-plan of P001. See [.cursor/Plans/subplans/P001/zz-archive/asset-integration.plan.md](.cursor/Plans/subplans/P001/zz-archive/asset-integration.plan.md). Chunks B1–B5; B5 satisfied by Many-buildings-bg BG3. | **Complete; archived 2026-02-24.** | N/A | High |
| P001-E2E-Journeys | E2E spec assessment and user-journey skeleton | 1 | Spec assessment, journey skeleton (J1–J5 iOS, J6–J9 Admin), investigation plans and question sets. Aligned with logic-test (§6.1), ui-test (§6.2), Blaster (§7). See [.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md](.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md). | **Complete.** Admin E2E (Playwright J6–J9) + iOS E2E (XCUITest J1–J5). **Pushed 2026-02-23.** | N/A | High |
| P002 | Lane A Vertical Runner & Viewport | 1 | Vertical Temple Run-style runner (swipe left/right lanes), avatar/enemy visibility, viewport scaling for last 5 iPhones; Blaster complete (V1–V4). See [.cursor/Plans/zz-archives/zz-P002/P002-vertical-runner-viewport.plan.md](.cursor/Plans/zz-archives/zz-P002/P002-vertical-runner-viewport.plan.md). Viewport ui-test: [P002-viewport-validation-2026-02-23.md](.cursor/Plans/zz-archives/zz-P002/P002-viewport-validation-2026-02-23.md). | **Blaster complete.** | 95% | 95% |
| Scroller-10s | Scroller 10s loop and avatar sizing | 1 | 10s segment, seamless loop (same segment repeats), dog/boxes as obstacles, 44pt sprite scaling. Blaster complete; chunks S1–S4. See [.cursor/Plans/zz-archives/zz-Scroller-10s/Scroller-10s-loop-and-sizing.plan.md](.cursor/Plans/zz-archives/zz-Scroller-10s/Scroller-10s-loop-and-sizing.plan.md). | Complete (S1–S4; S1 config done, S2–S4 pushed 2026-02-23). | 92% | 92% |
| Many-buildings-bg | Many-buildings scrolling background and sprite integration | 1 | Scrolling rooftop background (many buildings, tileable), dog/boxes integrate on runway; ui-designer + canva-ui-design; B5 (background layer + tiling). See [.cursor/Plans/zz-archives/zz-Many-buildings-bg/Many-buildings-bg.plan.md](.cursor/Plans/zz-archives/zz-Many-buildings-bg/Many-buildings-bg.plan.md). | Complete (BG1–BG4; BG1+BG2 assets done, BG3+BG4 pushed 2026-02-23). | N/A | High |
| P001-SpecGaps | Spec gaps — ideation through implementation | 1 | One remaining spec violation (first-revive-only per SPEC §1); detailed plan from ideation through implementation. See [P001-SpecGaps-ideation-to-impl.plan.md](.cursor/Plans/subplans/P001/P001-SpecGaps-ideation-to-impl.plan.md); build chunk: [spec-gaps-first-revive-only.plan.md](.cursor/Plans/subplans/P001/spec-gaps-first-revive-only.plan.md). | **Complete (2026-02-24). Pushed 2026-02-24.** Code + E2E J4c + 65 tests. Logic-Test handoff per §6.1. | 95% | 95% |
| P001-NoThanksMenu | No-Thanks Menu (iPhone Plus) — post–game-over menu | 1 | After "No thanks" on game-over alert, show second alert with "Play again" so user can start new game on all devices including iPhone Plus. See [NoThanks-Menu-iPhonePlus.plan.md](.cursor/Plans/subplans/P001/NoThanks-Menu-iPhonePlus.plan.md). Chunks C1 (VC second alert), C2 (J4b + Plus validation). | **Complete (2026-02-28).** C1 + C2 done; second alert + J4b + iPhone Plus validation. Blaster pipeline applied. | 95% | 92% |
| P003 | Score HUD Safe Area and High-Score Paradigm | 1 | Fix score HUD covered by Dynamic Island/notch (iPhone 15 Plus etc.); safe-area-aware HUD position. Details in [P003-ScoreHUD-SafeArea.plan.md](.cursor/Plans/subplans/P003/P003-ScoreHUD-SafeArea.plan.md); Chunk 1: [Chunk1-SafeArea-Fix.plan.md](.cursor/Plans/subplans/P003/Chunk1-SafeArea-Fix.plan.md). | Chunks 1, 2, 3 done (2026-02-24). **Next:** optional backlog (5-iPhone E2E, lane IDs, etc.). | 95% | 93% |
| DifficultySpawnRamp | Difficulty spawn rate ramp (1 per 5s, +0.1 every 5s) | 1 | Time-based obstacle spawn rate; config + Engine + GameScene + tests. Main plan: [difficulty-spawn-rate-ramp.plan.md](.cursor/Plans/difficulty-spawn-rate-ramp.plan.md). Details and chunks C1–C6 in sub-plans under `.cursor/Plans/subplans/DifficultySpawnRamp/`. | **C1–C6 + Logic-Test done (2026-02-24). Pushed 2026-02-24.** 75 unit + 8 UI tests pass. Checklist: [difficulty-spawn-rate-ramp-logic-test-checklist.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-logic-test-checklist.md). | 95% | 95% |
| Tier5-TechDebt | Tier 5 — Tech debt and consolidation | 1 | Code consolidation and cleanup in iOS engine and tests: single source for design size, time epsilon, lane constants; fallback segment factory; segment-time margin; GameScene test helper; test README; test naming; CollisionSystem in Engine. See [Tier5-TechDebt-Consolidation.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/Tier5-TechDebt-Consolidation.plan.md). | T5-C1 through T5-C9 done (2026-02-24). | N/A | 92% |
| Tier6-ShipReadiness | Tier 6 — Ship readiness and baseline alignment | 1 | Align SPEC §7, tester.md, app-store-readiness to one iOS test baseline; ship-readiness doc and Master-Plan path. See [Tier6-ShipReadiness.plan.md](.cursor/Plans/subplans/Tier6-ShipReadiness/Tier6-ShipReadiness.plan.md). | **Complete (2026-02-28).** T6-C1 + T6-C2 done. | High | High |
| Tier7-AppStoreSubmission | Tier 7 — App Store submission and first release | 1 | Store metadata, screenshots, submission checklist. See [Tier7-AppStoreSubmission.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/Tier7-AppStoreSubmission.plan.md). | **Complete (2026-03-02).** T7-C1, T7-C2, T7-C3 done. | High | High |
| SimulatorCurrentBuild | Simulator always current build | 1 | Ensure every simulator run uses latest build: doc (Manual simulator testing) + optional build-install-launch script. See [SimulatorCurrentBuild.plan.md](.cursor/Plans/subplans/SimulatorCurrentBuild/SimulatorCurrentBuild.plan.md). Chunks C1 (doc), C2 (optional script). Blaster pipeline applied. | **Complete. Pushed 2026-02-28.** | 95% | 95% |
| SlideJumpCatAnimation | Slide/jump 2 obstacle lengths + animated cat | 1 | Easier gameplay: jump/slide last 1.1 s (2 × obstacle length). Cat = multi-frame animation (run, jump, slide) per ui-designer—no squash-and-stretch. Details and chunks C1–C4 in [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md). Lane A (ios/ + variant); Lane B (assets/ + AssetConfig paths). | **Complete (2026-03-02).** C1–C4 done. | N/A | High |
| ConfigVariantsDoc | Config variants README documentation (Lane B) | 1 | Document variant overrides in config/variants/README.md. Config only; no ios/ or assets/ code. See [ConfigVariantsDoc.plan.md](.cursor/Plans/subplans/ConfigVariantsDoc/ConfigVariantsDoc.plan.md). Chunk C1: document easy.json. | **Complete (2026-03-02).** C1 done; both variants documented. | N/A | High |
| SeamlessBackground | Seamless background tiles + object integration | 2 | Option A (two layers) or B (single image); sprite grounding, shadows, lane overlay. Blaster pipeline applied. See [SeamlessBackground-OptionsAndObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/SeamlessBackground-OptionsAndObjectIntegration.plan.md). | **Test plan ready.** C1 (assets) → C2 (object integration). | 95% | 92% |
| RightLaneTap | Lane boundary tap visual/collision desync | 1 | Tap right (or left) when cat on rightmost (or leftmost) lane desyncs visual from hitbox. Fix: clamp before moveToLane, early return at boundary. See [RightLaneTap-VisualBug.plan.md](.cursor/Plans/subplans/RightLaneTap/RightLaneTap-VisualBug.plan.md). | **Complete (2026-03-09).** C1+C2+C3 done; pushed. | 95% | 95% |
| CatTransparency | Cat transparency and background fix | 1 | Fix idle/jump/slide opaque box: extend transparency script to cat_run.png, cat_jump.png, cat_slide.png; PlayerNode use .clear when textures present. See [CatTransparency-TransparencyAndBackgroundFix.plan.md](.cursor/Plans/subplans/CatTransparency/CatTransparency-TransparencyAndBackgroundFix.plan.md). | **Complete (2026-03-09).** C1+C2 done. | 95% | 95% |

**CatTransparency Build Chunk Progress (Lane A + Lane B):**

| Chunk | Description | State | Lane | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|------|-------------|-----------------|------|
| C1 | Extend transparency script to cat_run.png, cat_jump.png, cat_slide.png; run on all 19 files | **Done (2026-03-09)** | B | N/A | 95% | [C1-ScriptExtend.plan.md](.cursor/Plans/subplans/CatTransparency/C1-ScriptExtend.plan.md). |
| C2 | PlayerNode: use .clear when runTexture present | **Done (2026-03-09)** | A | 95% | 95% | [C2-PlayerNodeClear.plan.md](.cursor/Plans/subplans/CatTransparency/C2-PlayerNodeClear.plan.md). |

**RightLaneTap Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| C1 | Fix: GameScene.triggerLaneLeft/Right — clamp before moveToLane, early return at boundary | **Done (2026-03-09)** | 95% | 95% | [RightLaneTap-VisualBug.plan.md](.cursor/Plans/subplans/RightLaneTap/RightLaneTap-VisualBug.plan.md). |
| C2 | Unit tests: LaneBoundaryTapTests; playerContainerPositionForTesting | **Done (2026-03-09)** | 95% | 95% | 2 tests; right/left boundary no-op. |
| C3 | Commit and push to origin/main | **Done (2026-03-09)** | N/A | N/A | Pushed to origin/main. |

**SeamlessBackground Build Chunk Progress (Lane A + Lane B):**

| Chunk | Description | State | Lane | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|------|-------------|-----------------|------|
| C1 | Background assets: sky.png, ground.png 786×1800 px, seamless top/bottom; ui-designer | Pending | B | 95% | 92% | [C1-BackgroundAssets.plan.md](.cursor/Plans/subplans/SeamlessBackground/C1-BackgroundAssets.plan.md). |
| C2 | Object integration: anchor (0.5,0), shadows, lane overlay | Pending | A | 93% | 90% | [C2-ObjectIntegration.plan.md](.cursor/Plans/subplans/SeamlessBackground/C2-ObjectIntegration.plan.md). Depends on C1. |

**DifficultySpawnRamp Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| C1 | Config: variant.json + schema (initialSpawnIntervalSeconds, spawnRateIncrementPerFiveSeconds) | **Done (2026-02-24)** | N/A | 95% | Optional fields; rollback clear. |
| C2 | Engine types + DifficultyScaler.spawnRate(elapsedSeconds:) | **Done (2026-02-24)** | N/A | 95% | Decode defaults; formula specified. |
| C3 | ObstacleGenerator.generate(..., targetObstacleCount:) | **Done (2026-02-24)** | N/A | 93% | Clamp and path guarantee noted. |
| C4 | SegmentGenerator elapsedTimeAtSegmentStart, rate × duration | **Done (2026-02-24)** | N/A | 92% | Rounding to be fixed in impl. |
| C5 | GameScene totalElapsedTime, checkpointElapsedTime, advance/revive/restart | **Done (2026-02-24)** | N/A | 94% | All branches covered. |
| C6 | Tests: spawnRate, target count, regression | **Done (2026-02-24)** | N/A | 91% | DifficultyScalerTests spawnRate; ObstaclePlacementTests targetObstacleCount; 69 unit tests. |

**P003 Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| Chunk 1 | Safe-area fix: VC topMarginScene + GameScene setTopSafeAreaMargin + HUD position | **Done (2026-02-24)** | 95% | 93% | [Chunk1-SafeArea-Fix.plan.md](.cursor/Plans/subplans/P003/Chunk1-SafeArea-Fix.plan.md). Unit test + full suite pass. |
| Chunk 2 | "New high score!" celebration (in-game / game-over) | **Done (2026-02-24)** | N/A | 90% | ScoreKeeper.didBeatHighScoreThisRun; in-game label; VC "New record!" alert; SPEC §1. |
| Chunk 3 | Spec/docs update (SPEC §1/§7, Master-Plan note) | **Done (2026-02-24)** | N/A | 92% | SPEC §1/§7 + Master-Plan updated; Chunk 1 noted done. |

**P001-NoThanksMenu Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| C1 | No thanks → second alert (GameViewController) | **Done (2026-02-28)** | 95% | 92% | Done; second alert + J4b + Plus validation. [C1-NoThanks-SecondAlert.plan.md](.cursor/Plans/subplans/P001/NoThanksMenu/C1-NoThanks-SecondAlert.plan.md). |
| C2 | J4b update and iPhone Plus validation | **Done (2026-02-28)** | 95% | 92% | Done; second alert + J4b + Plus validation. [C2-J4b-ValidatePlus.plan.md](.cursor/Plans/subplans/P001/NoThanksMenu/C2-J4b-ValidatePlus.plan.md). |

**Tier 5 (Tech debt and consolidation) Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| T5-C1 | Single source for design size (393×852); VC + tests | **Done (2026-02-24)** | N/A | 92% | [T5-C1-DesignSize.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/T5-C1-DesignSize.plan.md). |
| T5-C2 | Unify time-epsilon constant (CollisionSystem, PowerUpSpawner) | **Done (2026-02-24)** | N/A | 93% | DesignConstants.timeEpsilon; VC + both systems + PowerUpSpawnerTests. |
| T5-C3 | Centralize default lane count and center lane | **Done (2026-02-24)** | N/A | 92% | DesignConstants.defaultLaneCount, defaultCenterLaneIndex; GameScene, PlayerNode, SegmentGenerator, EngineVariantConfig, tests. |
| T5-C4 | Extract fallback segment factory (GameScene) | **Done (2026-02-24)** | N/A | 91% | [T5-C4-FallbackSegment.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/T5-C4-FallbackSegment.plan.md). |
| T5-C5 | Shared segment-time margin (duration × 0.1) | **Done (2026-02-24)** | N/A | 92% | DesignConstants.segmentTimeMarginFraction; ObstacleGenerator, PowerUpSpawner. |
| T5-C6 | GameScene test helper (scene + SKView + didMove) | **Done (2026-02-24)** | N/A | 93% | GameSceneTestHelper.makeSceneWithDidMove(); used in 3 test files. |
| T5-C7 | Update CatRunnerTests README (all test files) | **Done (2026-02-24)** | N/A | 95% | ios/CatRunnerTests/README.md lists all files and coverage. |
| T5-C8 | Test file naming convention | **Done (2026-02-24)** | N/A | 88% | [T5-C8-TestNaming.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/T5-C8-TestNaming.plan.md). |
| T5-C9 | CollisionSystem in Engine | **Done (2026-02-24)** | N/A | 85% | [T5-C9-CollisionSystemEngine.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/T5-C9-CollisionSystemEngine.plan.md). |

**Tier 6 (Ship readiness and baseline alignment) Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| T6-C1 | Baseline alignment: SPEC §7, tester.md, app-store-readiness.md → same iOS test count | **Done (2026-02-28)** | High | High | [T6-C1-BaselineAlignment.plan.md](.cursor/Plans/subplans/Tier6-ShipReadiness/T6-C1-BaselineAlignment.plan.md). Baseline: 83 tests (75+8, 2 skipped). |
| T6-C2 | Ship-readiness doc: app-store-readiness + Master-Plan path; optional "ship it" checklist | **Done (2026-02-28)** | Medium | High | Ship-it checklist and Tier 6 path updated. |

**Tier 7 (App Store submission and first release) Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| T7-C1 | Store metadata and listing: docs/app-store-listing.md (name, subtitle, description, keywords, privacy, age) | **Done (2026-02-28)** | High | High | [T7-C1-StoreMetadata.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/T7-C1-StoreMetadata.plan.md). |
| T7-C2 | Screenshots and previews: checklist + required sizes; capture method | Done (2026-02-28) | High | High | docs/app-store-screenshots.md; app-store-readiness, app-store-listing updated. |
| T7-C3 | Submission checklist: link app-store-readiness to first submission; App Store Connect notes | **Done (2026-03-02)** | Medium | High | [T7-C3-SubmissionChecklist.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/T7-C3-SubmissionChecklist.plan.md). |

**SimulatorCurrentBuild Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| C1 | Doc: "Manual simulator testing" (app-store-readiness + optional tester.md) | **Done (2026-02-28)** | 95% | 95% | [C1-Doc.plan.md](.cursor/Plans/subplans/SimulatorCurrentBuild/C1-Doc.plan.md). |
| C2 | Optional: ios/run-simulator.sh + npm script ios:simulator | **Done (2026-02-28)** | 95% | 92% | [C2-Script.plan.md](.cursor/Plans/subplans/SimulatorCurrentBuild/C2-Script.plan.md). |

**SlideJumpCatAnimation Build Chunk Progress (Lane A + Lane B):**

| Chunk | Description | State | Lane | Conf (solution) | Note |
|-------|-------------|-------|------|-----------------|------|
| C1 | Duration = 2 obstacle lengths: variant.json jumpDurationSeconds 1.1, slideDurationSeconds 1.1; update tests if they assert 0.4/0.5 | **Done (2026-03-02)** | A | High | [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md). |
| C2 | Config + assets: assets.json + AssetConfig character.jump, character.slide; assets in assets/character/ (Lane B or ui-designer) | **Done (2026-03-02)** | B then A | High | Optional run frames later. |
| C3 | PlayerNode: switch to jump/slide texture or frames during action; restore run when done; no scale/squash of run image | **Done (2026-03-02)** | A | High | Collision unchanged. |
| C4 | Jump easing (easeIn/easeOut on motion); optional run cycle when idle if multi-frame run exists | **Done (2026-03-02)** | A | High | Visual polish. |

**Scroller-10s chunks (Lane A = ios/, Lane B = config/):**

| Chunk | Description | State | Lane | Note |
|-------|-------------|-------|------|------|
| S1 | Config: segment duration ≥10s, optional scrollerLoop | Done | B | variant.json + schema |
| S2 | GameScene: 10s fallback + loop branch (no addSegmentCompleted on restart) | Done (pushed 2026-02-23) | A | GameScene.swift |
| S3 | refreshSegmentSprites: 44pt max scaling, aspect ratio preserved | Done (pushed 2026-02-23) | A | GameScene.swift |
| S4 | Validation: manual 10s + loop + sizing; unit tests | Done (pushed 2026-02-23) | A | Simulator + 58 tests |

**P001-CatWorld-Assets phases (Lane B, ui-designer):**

| Phase | Description | State | Sub-plan |
|-------|-------------|-------|----------|
| A1 | Character: cat_run.png | Done | [CatWorld-A1-character.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A1-character.plan.md) |
| A2 | Obstacles: passable, instantFail, slowdown | Done | [CatWorld-A2-obstacles.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A2-obstacles.plan.md) |
| A3 | Enemies: dog.png | Done | [CatWorld-A3-enemies.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A3-enemies.plan.md) |
| A4 | Backgrounds: sky.png, ground.png | Done | [CatWorld-A4-backgrounds.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A4-backgrounds.plan.md) |
| A5 | Power-ups: speedBoost, shield | Done | [CatWorld-A5-powerups.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A5-powerups.plan.md) |
| A6 | UI: scorePanel, gameOver, revivePanel | Done | [CatWorld-A6-ui.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A6-ui.plan.md) |
| A7 | App icon 1024×1024 (save to assets/reference; copy to ios/ by user or Lane A) | Done | [CatWorld-A7-appicon.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A7-appicon.plan.md) |

**P001-Asset-Integration chunks (Lane A):**

| Chunk | Description | State | Note |
|-------|-------------|-------|------|
| B1 | Config and assets in app bundle | Done | variant.json, assets.json, assets/* in bundle |
| B2 | Asset loader (assets.json → textures) | Done | assets.json loaded; character.run → SKTexture; GameScene holds assetConfig |
| B3 | Player texture from character.run | Done | B2 loader; GameScene → PlayerNode(texture:) |
| B4 | Obstacle and power-up sprites | Done | B2 loader; segment strip; obstacle/power-up textures in lanes |
| B5 | Backgrounds (sky, ground) | Done | B2 loader; backgroundLayer + vertical tiling in GameScene; satisfied by Many-buildings-bg BG3 |

**Many-buildings-bg chunks (Lane A = ios/, Lane B = assets/ + ui-designer):**

| Chunk | Description | State | Lane | Note |
|-------|-------------|-------|------|------|
| BG1 | Ui-designer: image prompt + Canva skill + GenerateImage; implementation spec | Done | B | ui-designer; assets/backgrounds/ |
| BG2 | Save sky.png, ground.png to assets/backgrounds/; update README/VISION if needed | Done | B | assets/ only |
| BG3 | B5: background layer + vertical tiling in GameScene; runway band aligns with lanes | Done (pushed 2026-02-23) | A | GameScene.swift |
| BG4 | Validation: 5-iPhone simulator, ui-test journey, screenshot baseline | Done (pushed 2026-02-23) | A + ui-test | See BG4-validation-2026-02-23.md |

**ConfigVariantsDoc Build Chunk Progress (Lane B):**

| Chunk | Description | State | Note |
|-------|-------------|-------|------|
| C1 | Document easy.json in config/variants/README.md | **Done (2026-03-02)** | [C1-DocEasy.plan.md](.cursor/Plans/subplans/ConfigVariantsDoc/C1-DocEasy.plan.md). Config-only. Both easy.json and difficulty-spawn-ramp.json now documented. |

**P002 Build Chunk Progress (Lane A):**

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| V1 - Perfected | Vertical runner (y-scroll, player lower third) | Done | 95% | 95% | Steps and validation clear; rollback in main plan. |
| V2 - Perfected | Avatar and enemy visibility (design size, aspectFit, enemy sprites) | Done | 95% | 95% | Implementation matches plan; no UI mockup scope. |
| V3 - Perfected | Viewport and 5-iPhone matrix (ui-test) | Done | 95% | 95% | ui-test deliverable complete; criteria and matrix documented. |
| V4 | Blaster then Planner (pipeline + Master-Plan hand-off) | Done | 92% | 92% | Procedural chunk; pipeline executed. |

---

## Pending / missed work (audit)

- **Scroller-10s (Lane A + Lane B):** S1–S4 complete (Lane B S1 config done; S2–S4 pushed 2026-02-23). See [Scroller-10s-loop-and-sizing.plan.md](.cursor/Plans/zz-archives/zz-Scroller-10s/Scroller-10s-loop-and-sizing.plan.md).
- **Many-buildings-bg (Lane A + Lane B):** BG1–BG4 complete (Lane B BG1+BG2 done; BG3+BG4 pushed 2026-02-23). See [Many-buildings-bg.plan.md](.cursor/Plans/zz-archives/zz-Many-buildings-bg/Many-buildings-bg.plan.md).
- **P002 (Lane A):** Vertical runner, avatar/enemy visibility, viewport scaling (last 5 iPhones) done; viewport ui-test complete; **Blaster pipeline complete** (V1–V4). See [P002-vertical-runner-viewport.plan.md](.cursor/Plans/zz-archives/zz-P002/P002-vertical-runner-viewport.plan.md).
- **P001-E2E-Journeys:** Admin E2E (J6–J9 Playwright) + iOS E2E (J1–J5 XCUITest) complete and pushed 2026-02-23. See [e2e-spec-journeys.plan.md](.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md).
- **P001-CatWorld-Assets:** A1–A7 complete. Lane B ensured `assets/reference/appIcon_catworld_1024.png` exists at 1024×1024 (2026-02-24). Copy to `ios/.../AppIcon.appiconset/` (Lane A or user) to finish app icon in Xcode.
- **P001-Asset-Integration:** B1–B5 done; plan moved to zz-archive 2026-02-24. See [asset-integration.plan.md](.cursor/Plans/subplans/P001/zz-archive/asset-integration.plan.md).

---

## Path to archive (per plan)

Every plan has a path to archive: either complete the remaining work then move to archive, or document as invalid/out-of-scope then archive.

| Plan / work stream | Path to archive |
|--------------------|-----------------|
| **Tier 2 (Defect remediation)** | Done 2026-02-23. Optional: add `subplans/P001/zz-archive/Tier2-defect-remediation-done.md` (or link [tier2-defect-remediation-2026-02-23.md](.cursor/Plans/subplans/P001/tier2-defect-remediation-2026-02-23.md)). Update Master-Plan when Tier 2 doc is archived. |
| **Tier 3 (Scalability for App Store)** | Complete deliverables (A7 app icon in AppIcon.appiconset; optional fastlane/deploy; App Store checklist; optional second simulator). Then update Master-Plan Tier 3 row and Next hand off to Tier 4; optionally add completion note in `subplans/P001/zz-archive/`. |
| **Tier 4 (New feature build-out)** | **Done 2026-02-24. Pushed 2026-02-24.** C8 Done; in-game score HUD added; Logic-Test §6.1 documented; optional B5 plan moved to zz-archive. |
| **P001-Asset-Integration** | **Done 2026-02-24.** Plan moved to [subplans/P001/zz-archive/asset-integration.plan.md](.cursor/Plans/subplans/P001/zz-archive/asset-integration.plan.md); matrix updated. |
| **P001-Assets / P001-UI-Mockups** | Already in zz-archive; path to archive: N/A (reference only). |
| **C8 (Difficulty scaling, scoring, revive)** | **Done 2026-02-24.** Build Chunk Progress set to Done; monetization stub confirmed; in-game score HUD (Tier 4) added. |
| **e2e-investigation-findings** | Supporting doc, not a plan. When Tier 2–4 no longer need it for reference, move [e2e-investigation-findings-2026-02-23.md](.cursor/Plans/subplans/P001/e2e-investigation-findings-2026-02-23.md) to `subplans/P001/zz-archive/`. |
| **P002, Scroller-10s, Many-buildings-bg** | Archived in zz-archives; path to archive: N/A. |
| **P001-SpecGaps** | When first-revive-only is complete (code + E2E J4 + Logic-Test): update matrix to Complete; move [P001-SpecGaps-ideation-to-impl.plan.md](.cursor/Plans/subplans/P001/P001-SpecGaps-ideation-to-impl.plan.md) and [spec-gaps-first-revive-only.plan.md](.cursor/Plans/subplans/P001/spec-gaps-first-revive-only.plan.md) to `subplans/P001/zz-archive/`; set Next hand off to Tier 4. |
| **Tier 5 (Tech debt and consolidation)** | **T5-C1–T5-C9 complete 2026-02-24.** Plan Matrix Tier5-TechDebt row updated. Next hand off set to: invoke planner to define next tier or roadmap item. Optionally move [Tier5-TechDebt-Consolidation.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/Tier5-TechDebt-Consolidation.plan.md) and chunk plans to `subplans/Tier5-TechDebt/zz-archive/` (or leave in place). |
| **Tier 6 (Ship readiness and baseline alignment)** | **T6-C1 and T6-C2 complete 2026-02-28.** Plan: [Tier6-ShipReadiness.plan.md](.cursor/Plans/subplans/Tier6-ShipReadiness/Tier6-ShipReadiness.plan.md). Master-Plan Tier 6 row and path-to-archive updated. Optionally move plan and T6-C1 to `subplans/Tier6-ShipReadiness/zz-archive/` (or leave in place). |
| **Tier 7 (App Store submission and first release)** | **T7-C1–T7-C3 done 2026-03-02.** Plan: [Tier7-AppStoreSubmission.plan.md](.cursor/Plans/subplans/Tier7-AppStoreSubmission/Tier7-AppStoreSubmission.plan.md). Optionally move plan to `subplans/Tier7-AppStoreSubmission/zz-archive/`. |
| **SlideJumpCatAnimation (slide/jump 2 lengths + animated cat)** | **C1–C4 done 2026-03-02.** Plan: [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md). Optionally move plan to `subplans/SlideJumpCatAnimation/zz-archive/`. |
| **ConfigVariantsDoc (Lane B)** | **C1 done 2026-03-02.** Both variants documented. Plan complete; optionally move to `subplans/ConfigVariantsDoc/zz-archive/`. |
| **SeamlessBackground (Lane A + Lane B)** | When C1+C2 done: update matrix to Complete; optionally move plan and chunks to `subplans/SeamlessBackground/zz-archive/`. |
| **RightLaneTap (Lane A)** | When C3 (commit) done: update matrix to Complete; add push date to History; optionally move plan to `subplans/RightLaneTap/zz-archive/`. |
| **CatTransparency (Lane A + Lane B)** | **C1+C2 done 2026-03-09.** Update matrix to Complete; optionally move plan and chunks to `subplans/CatTransparency/zz-archive/`. |

---

## P001 Build Chunk Progress

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| C1 - Perfected | Xcode scaffold, 5 lanes, player at lane 2 | Done | 95% | 95% | Steps and validation clear; rollback defined; build verified. |
| C2 - Perfected | VariantConfig loader, JSON parsing | Done | 95% | 95% | Steps and validation clear; rollback defined; build verified. |
| C3 | SegmentGenerator (seeded, deterministic) | Done | N/A | N/A | Segment + SegmentGenerator; config loadable from JSON |
| C4 | Obstacle types, cluster config | Done | N/A | N/A | ObstacleGenerator wired to SegmentGenerator; span ≤ 5 |
| C5 | Path guarantee (≥1 viable lane/segment) | Done | N/A | N/A | PathGuarantee post-pass; ≥1 viable lane per segment |
| C6 | Power-up spawner (max 1, free lane only) | Done | N/A | N/A | PowerUpSpawner; max 1, free lane only, no overlap |
| C7 | Jump/slide, collision detection | Done | N/A | N/A | Jump/slide, lane swap, CollisionSystem; game-over delegate for C8 |
| C8 | Difficulty scaling, scoring, revive | Done | N/A | N/A | DifficultyScaler, ScoreKeeper, revive stub (SPEC §9); in-game score HUD (Tier 4); unit tests in CatRunnerTests |
| C9 | Admin panel scaffold | Done | N/A | N/A | config/admin.json, config/variants/, assets/; Next.js admin routes (config editor, asset upload, variant list, CI trigger) built. |
| C10 | CI/CD workflows | Done | N/A | N/A | build.yml, test.yml, deploy.yml; shared scheme; deploy manual TestFlight; CI runs build + test on push/PR |
| C11 | Automated tests | Testing complete | N/A | N/A | CatRunnerTests target added; 55 tests pass; CI runs xcodebuild test |
| C12 | Agent updates, SPECIFICATION.md | Done | N/A | N/A | Blaster/Tester CatRunner scope; docs/SPECIFICATION.md created |

---

## Scaffolded items (by location)

Scaffolded deliverables are grouped by repo location and owning chunk.

### iOS app (`ios/`)

| Item | Path / scope | Chunk | Notes |
|------|----------------|-------|--------|
| Xcode project | `ios/CatRunner.xcodeproj` | C1 | Scheme: CatRunner |
| App entry | `ios/CatRunner/App/` | C1 | AppDelegate, SceneDelegate |
| Game scene | `ios/CatRunner/Game/` — GameScene, lane layout | C1 | 5 lanes, player at lane 2 |
| Engine folder | `ios/CatRunner/Engine/` | C1 | Placeholder until C3 |
| Asset catalog | `ios/CatRunner/Assets.xcassets/` | C1 | App icon, placeholders |
| Info.plist | `ios/CatRunner/Info.plist` | C1 | |
| Test target | `ios/CatRunnerTests/` | C11 | XCTest |
| Config + assets in bundle | Copied from repo config/default, assets/ | B1 | For asset loader and visuals (P001-Asset-Integration) |

### Config (`config/`)

| Item | Path / scope | Chunk | Notes |
|------|----------------|-------|--------|
| Default variant | `config/default/variant.json` | C2 | Full schema |
| JSON schema | `config/schema.json` | C2 | Validation |
| Asset mapping | `config/default/assets.json` | C2 | Paths for assets |
| Variants dir | `config/variants/` | C2 | Optional overrides; C9 Lane B scaffolded |
| Admin manifest | `config/admin.json` | C9 | Paths + CI trigger for admin panel |

### Assets (`assets/`)

| Item | Path / scope | Chunk | Notes |
|------|----------------|-------|--------|
| Character | `assets/character/` | C1 or C9 | Placeholder cat |
| Obstacles | `assets/obstacles/` | C4 | 3 types |
| Enemies | `assets/dogs/` | C1 or C4 | Placeholder |
| Backgrounds | `assets/backgrounds/` | C1 | Placeholder |
| Power-ups | `assets/powerups/` or `assets/ui/` | C6 | speedBoost, shield |
| UI | `assets/ui/` | C1 or C8 | HUD, revive, game over; pixel-art mockups done. Cat-world replacement in progress per [CatWorld-assets.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-assets.plan.md) (A1–A7). |

### Admin panel (Next.js)

| Item | Path / scope | Chunk | Notes |
|------|----------------|-------|--------|
| Admin routes | `src/app/admin/` | C9 | Config editor, asset upload, variant list, CI trigger (paths from config/admin.json) |
| Config editor | Page for `config/default/variant.json` | C9 | Validate with schema |
| Asset upload UI | Page to upload into `assets/*` | C9 | |
| Variant list | Page listing variants | C9 | |
| CI trigger | Link to GitHub Actions | C9 | |

### CI/CD (`.github/workflows/`)

| Item | Path / scope | Chunk | Notes |
|------|----------------|-------|--------|
| Build | `.github/workflows/build.yml` | C10 | xcodebuild |
| Test | `.github/workflows/test.yml` | C10 | xcodebuild test |
| Deploy | `.github/workflows/deploy.yml` | C10 | TestFlight |
| Build report | Artifact or summary | C10 | FPS, memory |

### Docs & agents

| Item | Path / scope | Chunk | Notes |
|------|----------------|-------|--------|
| Software spec | `docs/SPECIFICATION.md` | C12 | Full spec |
| Testing docs index | `docs/testing/README.md` | — | Index and links to test plans, agents, and test code |
| Blaster scope | `Agents/blaster.md` | C12 | CatRunner scope |
| Tester scope | `Agents/tester.md` | C12 | iOS test commands |

---

## Scaffolded items (by chunk)

| Chunk | Scaffolded items |
|-------|-------------------|
| C1 | `ios/` (project, App, Game, Engine dir, Assets.xcassets, Info.plist); optional `assets/` placeholders |
| C2 | `config/default/variant.json`, `config/schema.json`, `config/default/assets.json`, `config/variants/` |
| C3 | SegmentGenerator in `ios/CatRunner/Engine/` |
| C4 | Obstacle types in Engine; `assets/obstacles/` if not in C1 |
| C5 | Path-guarantee logic in Engine |
| C6 | PowerUpSpawner in Engine |
| C7 | Jump/slide/collision in Game + Engine |
| C8 | Difficulty/scoring/revive in Game |
| C9 | `src/app/admin/`, config editor, asset upload, variant list, CI trigger |
| C10 | `.github/workflows/build.yml`, `test.yml`, `deploy.yml` |
| C11 | `ios/CatRunnerTests/` — unit, simulation, regression, performance |
| C12 | `docs/SPECIFICATION.md`; updates to `Agents/blaster.md`, `Agents/tester.md` |

---

## Plan reviews (Blaster standards)

- **2026-02-23:** [Blaster-Plan-Review.md](zz-archives/zz-Reviews/Blaster-Plan-Review.md) — Review of all plans against Blaster standards (confidence gates, chunk Confidence + Note, Detailed Design/Best Routes, perfected marking). Gaps and recommended actions documented there.
- **E2E plan:** [e2e-spec-journeys.plan.md](subplans/P001/e2e-spec-journeys.plan.md) reviewed with planner and Blaster; added to Plan Matrix as P001-E2E-Journeys. Plan defines journey skeleton (J1–J9), four investigation question sets, logic-test validation targets (§6.1), ui-test scope and tooling (§6.2), and Blaster pipeline alignment for CatRunner scope (§7). Next: resolve investigations then invoke ui-test (Admin) and logic-test (state/rules) per plan.

---

## Features for planner

Features are maintained in this section. An optional `features-for-planner.md` at `.cursor/Plans/` may be used if a separate doc is needed (planner owns both).

- **CatRunner**: 1-player endless runner; 5 lanes; procedural segments; single avatar.
- **SlideJumpCatAnimation (optional after Tier 7):** Slide and jump last 2 obstacle lengths (1.1 s); cat is multi-frame animation (run, jump, slide) per ui-designer—no squash-and-stretch. Plan: [SlideJumpCatAnimation.plan.md](.cursor/Plans/subplans/SlideJumpCatAnimation/SlideJumpCatAnimation.plan.md).
- **Scope**: iOS (Swift + SpriteKit), in-repo VariantConfig, Next.js admin scaffold, GitHub Actions CI/CD.
