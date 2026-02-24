# Master-Plan — CatRunner

## Next hand off (cut & paste) — Lane A

**Top 10 plan executed (2026-02-24):** App icon copied; DifficultySpawnRamp C1–C6 done; Revive/play-again unit tests; Tier 2 doc in zz-archive; features-for-planner.md created.

**Lane A status (2026-02-24):** DifficultySpawnRamp C1–C6 + Logic-Test complete; 75 unit + 8 UI tests pass; checklist at [difficulty-spawn-rate-ramp-logic-test-checklist.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-logic-test-checklist.md). Baseline: 75 unit + 8 UI (2 skipped); all pass. DifficultySpawnRamp work is pushed to `origin/main`.

**Next priority — Lane A:** Run `npm run test:full` and the iOS test suite to confirm the DifficultySpawnRamp baseline (75 unit + 8 UI, 2 skipped). If tests pass with no new regressions, invoke the **planner** to assign the next prioritized plan from the roadmap or `features-for-planner.md` (e.g. new feature or Tier 5 / next tier) and update this hand off accordingly. Agent: **shell** or **generalPurpose** for tests; **planner** for next assignment.

## Next hand off (cut & paste) — Lane B

**App icon asset — done (2026-02-24).** Verified and corrected `assets/reference/appIcon_catworld_1024.png` to 1024×1024. Source ready for Lane A or user to copy to `ios/CatRunner/Assets.xcassets/AppIcon.appiconset/AppIcon.png`.

**Asset-based overlays — done (2026-02-24).** `assets/ui/gameOver.png`, `revivePanel.png`, `scorePanel.png` verified and resized per implementation-spec. No ios/ change.

**Next priority — Lane B:** Add a **variant override** in `config/variants/` that documents the difficulty-spawn-ramp defaults for testing/reference. Create `config/variants/difficulty-spawn-ramp.json` (or a short name of your choice) with optional fields `initialSpawnIntervalSeconds` and `spawnRateIncrementPerFiveSeconds` matching the schema in `config/schema.json` and the defaults used in DifficultySpawnRamp. Ensure `config/default/variant.json` and schema remain the source of truth; this file is an explicit override example. No edits to `ios/` or shared code. Agent: **generalPurpose**. Plan reference: [DifficultySpawnRamp C1-Config](.cursor/Plans/subplans/DifficultySpawnRamp/C1-Config.plan.md). If no config work is desired, leave Lane B empty and invoke **planner** when new config/asset work is added.

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
| Fastlane + deploy.yml enhancements; second simulator in CI | Tier 3 optional | Already present per History; enhancements optional. |
| Tier 2 completion doc in zz-archive | Path to archive table | **Done (2026-02-24).** [Tier2-defect-remediation-done.md](.cursor/Plans/subplans/P001/zz-archive/Tier2-defect-remediation-done.md) in zz-archive. |
| features-for-planner.md at .cursor/Plans/ | Features for planner § | **Done (2026-02-24).** [features-for-planner.md](.cursor/Plans/features-for-planner.md) created. |

**Lane B (optional / deferred — when no conflict with current Lane A focus)**

| Item | Reference / plan | Note |
|------|------------------|------|
| Ensure app icon asset in assets/reference | **Done (2026-02-24);** [CatWorld-A7-appicon.plan.md](.cursor/Plans/subplans/P001/zz-archive/CatWorld-A7-appicon.plan.md) | Verified and resized to 1024×1024. Lane A or user copies to ios/ AppIcon.appiconset. |
| Asset-based overlays (game-over / revive) | Spec gaps §; assets/ui implementation-spec | **Done (2026-02-24).** gameOver.png, revivePanel.png, scorePanel.png at 9:16 and 9:1; spec/README updated. No ios/ change. |
| New variant or asset refresh | Master-Plan "Next hand off — Lane B" | When Planner defines config or asset work (e.g. new variant, asset refresh, doc under config or assets), Lane B picks it up; no conflict with Lane A if scope is config/ and assets/ only. |

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

Completed items are listed here; update Next hand off above when a tier or task is done.

---

## Concurrent agents (max 2)

- **Lane A** edits `ios/` only. **Lane B** edits `config/` and `assets/` only (and may invoke ui-designer for asset images). No file overlap; both may run in parallel.
- **Hand-offs:** Lane A = P001-E2E ui-test + logic-test + iOS E2E (J1–J5) done; E2E in CI. Lane B = complete (S1 + BG1+BG2); no current task. No file overlap.
- When both lanes touch the same area (e.g. C3 and C7 both touch Engine), run sequentially.
- **Asset path and image spec:** Only [sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/zz-archive/sprites-ui-assets.plan.md) defines the asset inventory and `assets.json` path map; C2 creates the file, C9/admin consume it.

---

## Prioritized roadmap (controls our fate)

Work is ordered in four tiers. Complete each tier before advancing; the **Next hand off — Lane A** above points at the current tier.

| Tier | Name | Goal | Key deliverables |
|------|------|------|-------------------|
| **1** | Testing improvements | Stabilize test runs, align baselines | Fix `test:full` (Vitest exclude e2e/); SPECIFICATION.md §7 baseline count = actual CI run; optional: revive/play-again unit tests |
| **2** | Defect remediation | Close spec/impl gaps | Revive vs monetization (doc or minimal branch); document admin config save semantics; score in alert only vs in-game HUD (doc or implement) |
| **3** | Scalability for App Store | TestFlight / store readiness | A7 app icon in AppIcon.appiconset; optional: fastlane + deploy.yml; App Store readiness checklist (doc); optional: second simulator in CI |
| **4** | New feature build-out | New functionality after 1–3 | Monetization stub (C8); in-game score HUD if not in Tier 2; optional: 5-iPhone E2E, lane accessibility IDs |

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
| P003 | Score HUD Safe Area and High-Score Paradigm | 1 | Fix score HUD covered by Dynamic Island/notch (iPhone 15 Plus etc.); safe-area-aware HUD position. Details in [P003-ScoreHUD-SafeArea.plan.md](.cursor/Plans/subplans/P003/P003-ScoreHUD-SafeArea.plan.md); Chunk 1: [Chunk1-SafeArea-Fix.plan.md](.cursor/Plans/subplans/P003/Chunk1-SafeArea-Fix.plan.md). | Chunks 1, 2, 3 done (2026-02-24). **Next:** optional backlog (5-iPhone E2E, lane IDs, etc.). | 95% | 93% |
| DifficultySpawnRamp | Difficulty spawn rate ramp (1 per 5s, +0.1 every 5s) | 1 | Time-based obstacle spawn rate; config + Engine + GameScene + tests. Main plan: [difficulty-spawn-rate-ramp.plan.md](.cursor/Plans/difficulty-spawn-rate-ramp.plan.md). Details and chunks C1–C6 in sub-plans under `.cursor/Plans/subplans/DifficultySpawnRamp/`. | **C1–C6 + Logic-Test done (2026-02-24). Pushed 2026-02-24.** 75 unit + 8 UI tests pass. Checklist: [difficulty-spawn-rate-ramp-logic-test-checklist.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-logic-test-checklist.md). | 95% | 95% |

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
- **Scope**: iOS (Swift + SpriteKit), in-repo VariantConfig, Next.js admin scaffold, GitHub Actions CI/CD.
