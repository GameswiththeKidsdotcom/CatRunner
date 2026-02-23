# Master-Plan — CatRunner

## Next hand off (cut & paste) — Lane A

P002 Blaster pipeline complete (Steps 1–5; chunks V1–V4 validated; see [P002-vertical-runner-viewport.plan.md](.cursor/Plans/subplans/P002/P002-vertical-runner-viewport.plan.md)). **Commit** plan updates (`.cursor/Plans/` — P002 chunk sub-plans and Master-Plan) to repo. Then: **next Lane A priority** — run P001-E2E-Journeys investigations and/or invoke ui-test (Admin) and logic-test per [e2e-spec-journeys.plan.md](.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md), or pick next plan from Plan Matrix. Lane A may edit ios/ only. Reference: [Agents/planner.md](Agents/planner.md), [Agents/ui-test.md](Agents/ui-test.md), [Agents/logic-test.md](Agents/logic-test.md).

## Next hand off (cut & paste) — Lane B

Lane B complete for current initiatives (Scroller 10s S1, Many-buildings BG1+BG2 done). No conflict-free Lane B task; next Lane B work TBD by Planner. Lane B may edit config/ and assets/ only.

---

## Concurrent agents (max 2)

- **Lane A** edits `ios/` only. **Lane B** edits `config/` and `assets/` only (and may invoke ui-designer for asset images). No file overlap; both may run in parallel.
- **Hand-offs:** Lane A = P002 Blaster complete; commit plan updates then P001-E2E or next priority. Lane B = complete (S1 + BG1+BG2); no current task. No file overlap.
- When both lanes touch the same area (e.g. C3 and C7 both touch Engine), run sequentially.
- **Asset path and image spec:** Only [sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md) defines the asset inventory and `assets.json` path map; C2 creates the file, C9/admin consume it.

---

## Plan Matrix

| Plan ID | Name | Priority | Description | Current state | Conf (root) | Conf (solution) |
|---------|------|----------|-------------|---------------|-------------|-----------------|
| P001 | CatRunner iOS Game | 1 | iOS endless runner, VariantConfig, admin, CI/CD. See [.cursor/Plans/subplans/P001/P001-CatRunner.plan.md](.cursor/Plans/subplans/P001/P001-CatRunner.plan.md). | Complete. **Pushed 2026-02-23.** | 92% | 93% |
| P001-Assets | Sprites & UI assets | 1 | Asset inventory, image specs, ui-designer workflow. Sub-plan of P001. See [.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md). | Validated | N/A | High |
| P001-UI-Mockups | UI mockups (Lane B) | 1 | In-game UI mockups: pixel art, Revive/Game over, store in assets/ui/. Sub-plan of P001. See [.cursor/Plans/subplans/P001/ui-mockups.plan.md](.cursor/Plans/subplans/P001/ui-mockups.plan.md). | Validated | N/A | High |
| P001-C9-NextJS | C9 Admin Next.js routes | 1 | Admin panel UI: config editor, asset upload, variant list, CI trigger. Sub-plan of P001. See [.cursor/Plans/subplans/P001/C9-admin-panel.plan.md](.cursor/Plans/subplans/P001/C9-admin-panel.plan.md). | **Complete.** Next.js routes built; paths from config/admin.json. | N/A | High |
| P001-CatWorld-Assets | Cat world asset replacement (Lane B) | 1 | Replace placeholder/pixel-art assets with cat-world art (soft cozy 2D, rooftops at night). Sub-plan of P001. See [.cursor/Plans/subplans/P001/CatWorld-assets.plan.md](.cursor/Plans/subplans/P001/CatWorld-assets.plan.md). Phases A1–A7: character, obstacles, enemies, backgrounds, power-ups, UI, app icon. | **Complete.** | N/A | High |
| P001-Asset-Integration | iOS asset bundle and visuals | 1 | Integrate config + assets into app bundle and render character/obstacles/power-ups from assets.json. Sub-plan of P001. See [.cursor/Plans/subplans/P001/asset-integration.plan.md](.cursor/Plans/subplans/P001/asset-integration.plan.md). Chunks B1–B4; optional B5. | B4 verified; iOS 58/58 pass. Optional B5. | N/A | High |
| P001-E2E-Journeys | E2E spec assessment and user-journey skeleton | 1 | Spec assessment, journey skeleton (J1–J5 iOS, J6–J9 Admin), investigation plans and question sets. Aligned with logic-test (§6.1), ui-test (§6.2), Blaster (§7). See [.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md](.cursor/Plans/subplans/P001/e2e-spec-journeys.plan.md). | Validated | N/A | High |
| P002 | Lane A Vertical Runner & Viewport | 1 | Vertical Temple Run-style runner (swipe left/right lanes), avatar/enemy visibility, viewport scaling for last 5 iPhones; Blaster complete (V1–V4). See [.cursor/Plans/subplans/P002/P002-vertical-runner-viewport.plan.md](.cursor/Plans/subplans/P002/P002-vertical-runner-viewport.plan.md). Viewport ui-test: [ios/P002-viewport-validation-2026-02-23.md](ios/P002-viewport-validation-2026-02-23.md). | **Blaster complete.** | 95% | 95% |
| Scroller-10s | Scroller 10s loop and avatar sizing | 1 | 10s segment, seamless loop (same segment repeats), dog/boxes as obstacles, 44pt sprite scaling. Blaster complete; chunks S1–S4. See [.cursor/Plans/subplans/Scroller-10s-loop-and-sizing.plan.md](.cursor/Plans/subplans/Scroller-10s-loop-and-sizing.plan.md). | Complete (S1–S4; S1 config done, S2–S4 pushed 2026-02-23). | 92% | 92% |
| Many-buildings-bg | Many-buildings scrolling background and sprite integration | 1 | Scrolling rooftop background (many buildings, tileable), dog/boxes integrate on runway; ui-designer + canva-ui-design; B5 (background layer + tiling). See [.cursor/Plans/subplans/Many-buildings-bg/Many-buildings-bg.plan.md](.cursor/Plans/subplans/Many-buildings-bg/Many-buildings-bg.plan.md). | Complete (BG1–BG4; BG1+BG2 assets done, BG3+BG4 pushed 2026-02-23). | N/A | High |

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
| A1 | Character: cat_run.png | Done | [CatWorld-A1-character.plan.md](.cursor/Plans/subplans/P001/CatWorld-A1-character.plan.md) |
| A2 | Obstacles: passable, instantFail, slowdown | Done | [CatWorld-A2-obstacles.plan.md](.cursor/Plans/subplans/P001/CatWorld-A2-obstacles.plan.md) |
| A3 | Enemies: dog.png | Done | [CatWorld-A3-enemies.plan.md](.cursor/Plans/subplans/P001/CatWorld-A3-enemies.plan.md) |
| A4 | Backgrounds: sky.png, ground.png | Done | [CatWorld-A4-backgrounds.plan.md](.cursor/Plans/subplans/P001/CatWorld-A4-backgrounds.plan.md) |
| A5 | Power-ups: speedBoost, shield | Done | [CatWorld-A5-powerups.plan.md](.cursor/Plans/subplans/P001/CatWorld-A5-powerups.plan.md) |
| A6 | UI: scorePanel, gameOver, revivePanel | Done | [CatWorld-A6-ui.plan.md](.cursor/Plans/subplans/P001/CatWorld-A6-ui.plan.md) |
| A7 | App icon 1024×1024 (save to assets/reference; copy to ios/ by user or Lane A) | Done | [CatWorld-A7-appicon.plan.md](.cursor/Plans/subplans/P001/CatWorld-A7-appicon.plan.md) |

**P001-Asset-Integration chunks (Lane A):**

| Chunk | Description | State | Note |
|-------|-------------|-------|------|
| B1 | Config and assets in app bundle | Done | variant.json, assets.json, assets/* in bundle |
| B2 | Asset loader (assets.json → textures) | Done | assets.json loaded; character.run → SKTexture; GameScene holds assetConfig |
| B3 | Player texture from character.run | Done | B2 loader; GameScene → PlayerNode(texture:) |
| B4 | Obstacle and power-up sprites | Done | B2 loader; segment strip; obstacle/power-up textures in lanes |
| B5 | Backgrounds (sky, ground) | Done | B2 loader; backgroundLayer + vertical tiling in GameScene (BG3) |

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

- **Scroller-10s (Lane A + Lane B):** S1–S4 complete (Lane B S1 config done; S2–S4 pushed 2026-02-23). See [Scroller-10s-loop-and-sizing.plan.md](.cursor/Plans/subplans/Scroller-10s-loop-and-sizing.plan.md).
- **Many-buildings-bg (Lane A + Lane B):** BG1–BG4 complete (Lane B BG1+BG2 done; BG3+BG4 pushed 2026-02-23). See [Many-buildings-bg.plan.md](.cursor/Plans/subplans/Many-buildings-bg/Many-buildings-bg.plan.md).
- **P002 (Lane A):** Vertical runner, avatar/enemy visibility, viewport scaling (last 5 iPhones) done; viewport ui-test complete; **Blaster pipeline complete** (V1–V4). Next: commit plan updates, then next Lane A priority (e.g. P001-E2E-Journeys). See [P002-vertical-runner-viewport.plan.md](.cursor/Plans/subplans/P002/P002-vertical-runner-viewport.plan.md).
- **P001-CatWorld-Assets:** A1–A7 complete. Copy `assets/reference/appIcon_catworld_1024.png` to `ios/.../AppIcon.appiconset/` (Lane A or user) to finish app icon.
- **P001-Asset-Integration:** B1–B4 done (bundle, loader, player, obstacle/power-up sprites; iOS 58/58 pass). Optional B5 (backgrounds). Lane A. See [asset-integration.plan.md](.cursor/Plans/subplans/P001/asset-integration.plan.md).

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
| C8 | Difficulty scaling, scoring, revive | Code built | N/A | N/A | DifficultyScaler, ScoreKeeper, revive stub; unit tests in CatRunnerTests (add test target to run) |
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
| UI | `assets/ui/` | C1 or C8 | HUD, revive, game over; pixel-art mockups done. Cat-world replacement in progress per [CatWorld-assets.plan.md](.cursor/Plans/subplans/P001/CatWorld-assets.plan.md) (A1–A7). |

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

- **2026-02-23:** [Blaster-Plan-Review.md](Blaster-Plan-Review.md) — Review of all plans against Blaster standards (confidence gates, chunk Confidence + Note, Detailed Design/Best Routes, perfected marking). Gaps and recommended actions documented there.
- **E2E plan:** [e2e-spec-journeys.plan.md](subplans/P001/e2e-spec-journeys.plan.md) reviewed with planner and Blaster; added to Plan Matrix as P001-E2E-Journeys. Plan defines journey skeleton (J1–J9), four investigation question sets, logic-test validation targets (§6.1), ui-test scope and tooling (§6.2), and Blaster pipeline alignment for CatRunner scope (§7). Next: resolve investigations then invoke ui-test (Admin) and logic-test (state/rules) per plan.

---

## Features for planner

Features are maintained in this section. An optional `features-for-planner.md` at `.cursor/Plans/` may be used if a separate doc is needed (planner owns both).

- **CatRunner**: 1-player endless runner; 5 lanes; procedural segments; single avatar.
- **Scope**: iOS (Swift + SpriteKit), in-repo VariantConfig, Next.js admin scaffold, GitHub Actions CI/CD.
