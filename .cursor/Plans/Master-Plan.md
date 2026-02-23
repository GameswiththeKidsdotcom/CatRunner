# Master-Plan — CatRunner

## Next hand off (cut & paste) — Lane A

C9 Next.js admin routes are complete. For the next Lane A task: invoke [Agents/planner.md](Agents/planner.md) and ask for the next task.

## Next hand off (cut & paste) — Lane B

No Lane B task in current scope (C9 config/assets and P001-Assets sprite art are done). To get a Lane B task: invoke [Agents/planner.md](Agents/planner.md) and ask for the next config- or assets-only work. **Lane B may edit `config/` and `assets/` only** (and may use ui-designer for images); no `ios/` or `src/` changes.

---

## Concurrent agents (max 2)

- **Lane A** edits `ios/` only. **Lane B** edits `config/` and `assets/` only (and may invoke ui-designer for asset images). No file overlap; both may run in parallel.
- When both lanes touch the same area (e.g. C3 and C7 both touch Engine), run sequentially.
- **Asset path and image spec:** Only [sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md) defines the asset inventory and `assets.json` path map; C2 creates the file, C9/admin consume it.

---

## Plan Matrix

| Plan ID | Name | Priority | Description | Current state | Conf (root) | Conf (solution) |
|---------|------|----------|-------------|---------------|-------------|-----------------|
| P001 | CatRunner iOS Game | 1 | iOS endless runner, VariantConfig, admin, CI/CD. See [.cursor/Plans/subplans/P001/P001-CatRunner.plan.md](.cursor/Plans/subplans/P001/P001-CatRunner.plan.md). | Complete. **Pushed 2026-02-23.** | 92% | 88% |
| P001-Assets | Sprites & UI assets | 1 | Asset inventory, image specs, ui-designer workflow. Sub-plan of P001. See [.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md). | Validated | N/A | High |
| P001-UI-Mockups | UI mockups (Lane B) | 1 | In-game UI mockups: pixel art, Revive/Game over, store in assets/ui/. Sub-plan of P001. See [.cursor/Plans/subplans/P001/ui-mockups.plan.md](.cursor/Plans/subplans/P001/ui-mockups.plan.md). | Validated | N/A | High |
| P001-C9-NextJS | C9 Admin Next.js routes | 1 | Admin panel UI: config editor, asset upload, variant list, CI trigger. Sub-plan of P001. See [.cursor/Plans/subplans/P001/C9-admin-panel.plan.md](.cursor/Plans/subplans/P001/C9-admin-panel.plan.md). | **Complete.** Next.js routes built; paths from config/admin.json. | N/A | High |

---

## Pending / missed work (audit)

- None. C9 Next.js admin routes are implemented (`src/app/admin/`).

---

## P001 Build Chunk Progress

| Chunk | Description | State | Conf (root) | Conf (solution) | Note |
|-------|-------------|-------|-------------|-----------------|------|
| C1 | Xcode scaffold, 5 lanes, player at lane 2 | Done | 95% | 95% | Builds and runs on simulator |
| C2 | VariantConfig loader, JSON parsing | Done | N/A | N/A | Schema + variant.json in place; no loader yet |
| C3 | SegmentGenerator (seeded, deterministic) | Done | N/A | N/A | Segment + SegmentGenerator; config loadable from JSON |
| C4 | Obstacle types, cluster config | Done | N/A | N/A | ObstacleGenerator wired to SegmentGenerator; span ≤ 5 |
| C5 | Path guarantee (≥1 viable lane/segment) | Done | N/A | N/A | PathGuarantee post-pass; ≥1 viable lane per segment |
| C6 | Power-up spawner (max 1, free lane only) | Done | N/A | N/A | PowerUpSpawner; max 1, free lane only, no overlap |
| C7 | Jump/slide, collision detection | Done | N/A | N/A | Jump/slide, lane swap, CollisionSystem; game-over delegate for C8 |
| C8 | Difficulty scaling, scoring, revive | Code built | N/A | N/A | DifficultyScaler, ScoreKeeper, revive stub; unit tests in CatRunnerTests (add test target to run) |
| C9 | Admin panel scaffold | Done | N/A | N/A | config/admin.json, config/variants/, assets/; Next.js admin routes (config editor, asset upload, variant list, CI trigger) built. |
| C10 | CI/CD workflows | Code built | N/A | N/A | build.yml, test.yml, deploy.yml; shared scheme; deploy manual TestFlight; C11 adds test target |
| C11 | Automated tests | Testing complete | N/A | N/A | CatRunnerTests target added; 55 tests pass; CI runs xcodebuild test |
| C12 | Agent updates, SPECIFICATION.md | Code built | N/A | N/A | Blaster/Tester CatRunner scope; docs/SPECIFICATION.md created |

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
| UI | `assets/ui/` | C1 or C8 | HUD, revive, game over; pixel-art mockups done. Sprite art (character, obstacles, dogs, backgrounds, powerups) done per [sprites-ui-assets.plan.md](.cursor/Plans/subplans/P001/sprites-ui-assets.plan.md). |

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

## Features for planner

Features are maintained in this section. An optional `features-for-planner.md` at `.cursor/Plans/` may be used if a separate doc is needed (planner owns both).

- **CatRunner**: 1-player endless runner; 5 lanes; procedural segments; single avatar.
- **Scope**: iOS (Swift + SpriteKit), in-repo VariantConfig, Next.js admin scaffold, GitHub Actions CI/CD.
