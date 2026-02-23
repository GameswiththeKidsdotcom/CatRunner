# CatRunner — Software Specification

This document is the **single source of truth** for the CatRunner game. It is linked from the [Master-Plan](.cursor/Plans/Master-Plan.md) (§ Docs & agents).

---

## 1. Game concept and rules

- **Format:** 1-player endless runner; single avatar.
- **Lanes:** 5 lanes; player starts at lane 2 (middle).
- **Movement:** Jump and slide; lane changes as defined by config (jump/slide duration).
- **Collision:**
  - **instantFail:** Game over on hit (no revive used).
  - **passable:** No game over; may affect scoring or visuals as defined.
  - **slowdown:** Slows the player; no instant game over.
  - **Power-ups:** speedBoost, shield; effects apply to the single player only.
- **Revive:** On first game-over, player may revive (IAP or rewarded ad per monetization config); after that, game over is final.
- **Scoring:** Score increases over time/distance; difficulty scaling applies (speed, obstacle probabilities).
- **Difficulty scaling:** Config-driven (speed increment per segment, multi-lane and instantFail probability increments, segments per step).

---

## 2. VariantConfig schema

The game is driven by **VariantConfig** JSON. Full schema: **`config/schema.json`**.

Summary:

- **engine:** lanes (1–10, default 5), playerStartLane (0–4, default 2), segmentDurationSeconds (min/max), jumpDurationSeconds, slideDurationSeconds, baseSpeed, deterministicPhysics (boolean).
- **obstacles:** types (array of { id: passable | instantFail | slowdown, laneSpan: [min, max] }), segmentDurationSeconds, clusterConfig (enabled, minGroupSize, maxGroupSize, layout: linear | wide).
- **powerUps:** types (speedBoost, shield; unique), maxActive (0–5), spawnProbability (0–1), placementRule: **freeLaneOnly**.
- **difficultyScaling:** speedIncrementPerSegment, multiLaneProbabilityIncrement, instantFailProbabilityIncrement, segmentsPerStep.
- **monetization:** reviveIAPProductId (string | null), rewardedAdPlacementId (string | null).

Default variant: **`config/default/variant.json`**.

---

## 3. Engine architecture

- **SegmentGenerator:** Produces segments using seeded RNG; deterministic for same seed + config.
- **ObstacleGenerator:** Places obstacles per config (types, clusterConfig, spans).
- **PathGuarantee:** Post-pass guarantee that every segment has ≥1 viable lane.
- **PowerUpSpawner:** Spawns at most 1 power-up per segment; placementRule: free lane only; no overlap with obstacles.
- **DifficultyScaler:** Applies speed and probability increments over segments.
- **ScoreKeeper:** Tracks score and exposes it to the scene.
- **GameScene:** Coordinates rendering, input, and game loop.
- **PlayerNode:** Single avatar; jump/slide and lane position.
- **CollisionSystem:** Resolves collisions (instantFail → game over, passable/slowdown/power-ups as defined).

---

## 4. Procedural generation rules

- **Determinism:** Same seed + same VariantConfig → same segment sequence.
- **Path guarantee:** After obstacle placement, a post-pass ensures ≥1 viable lane per segment.
- **Power-ups:** Max 1 per segment; placed in a free lane only; no overlap with obstacles.
- **Obstacles:** Lane spans and clustering follow config; cluster layout (linear/wide) and group sizes respected.

---

## 5. Admin capabilities

- **Config editor:** Edit `config/default/variant.json` with validation against `config/schema.json`.
- **Asset upload:** Upload assets into paths defined by `config/default/assets.json` (e.g. character, obstacles, dogs, backgrounds, powerups, ui).
- **Variant list:** List variants (e.g. `config/variants/`) and select/default variant.
- **CI trigger:** Link or trigger to GitHub Actions (e.g. workflow_dispatch or push). Admin manifest: **`config/admin.json`** (paths, schema, variants dir, CI trigger reference).

See Master-Plan § Admin panel and C9 sub-plan for scaffold details.

---

## 6. CI/CD steps

- **build.yml:** Build iOS app (xcodebuild); shared scheme **CatRunner**.
- **test.yml:** Run tests: `xcodebuild test -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -configuration Debug` (from `ios/`); CatRunnerTests target.
- **deploy.yml:** Deploy to TestFlight (manual trigger); same scheme.

All workflows under **`.github/workflows/`**.

---

## 7. Testing requirements

- **Target:** CatRunnerTests (XCTest); unit, simulation, regression (deterministic runs), and optional performance.
- **Baseline:** **55 tests** (pass count for CI and regression comparison).
- **FPS/memory:** Targets documented in C11 plan: FPS ≥60, memory ≤300MB during normal gameplay; **not asserted in CI** (environment varies); use local/profile runs or Instruments to verify.

---

## 8. Asset structure

- **Path map:** **`config/default/assets.json`** — maps logical keys to paths (character, obstacles, enemies/dogs, backgrounds, powerups, ui, appIcon).
- **Directories:** assets/ (character, obstacles, dogs, backgrounds, powerups, ui). See Master-Plan § Assets and sprites-ui-assets plan for inventory and image specs.

---

## 9. Monetization / Live Ops

- **reviveIAPProductId:** Optional IAP product ID for revive; nullable in schema.
- **rewardedAdPlacementId:** Optional rewarded ad placement ID for revive; nullable in schema.
- Placeholder for future IAP and rewarded ads; no implementation required in current spec beyond config and revive flow stub.

---

## 10. Rollback, risks, validation

- **Rollback:** Disable test target or revert workflow if CI fails; revert variant/config if a change breaks the build or determinism.
- **Risks:** Determinism break (e.g. RNG or segment logic change) — regression tests (same seed → same segment) mitigate.
- **Validation:** Run `xcodebuild test` (scheme CatRunner) for test validation; validate variant JSON against `config/schema.json` for config changes.

---

## 11. Confidence scores

| Section | Confidence (root cause) | Confidence (solution path) |
|--------|--------------------------|-----------------------------|
| 1. Game concept and rules | N/A | N/A |
| 2. VariantConfig schema | N/A | N/A |
| 3. Engine architecture | N/A | N/A |
| 4. Procedural generation rules | N/A | N/A |
| 5. Admin capabilities | N/A | N/A |
| 6. CI/CD steps | N/A | N/A |
| 7. Testing requirements | N/A | N/A |
| 8. Asset structure | N/A | N/A |
| 9. Monetization / Live Ops | N/A | N/A |
| 10. Rollback, risks, validation | N/A | N/A |
| 11. Confidence scores | N/A | N/A |

*(This is a doc-only specification; per-section confidence for root cause/solution path is N/A.)*
