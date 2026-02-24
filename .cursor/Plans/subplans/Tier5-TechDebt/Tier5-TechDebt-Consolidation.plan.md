---
name: Tier 5 — Tech debt and consolidation
plan_id: Tier5-TechDebt
overview: "Code consolidation and cleanup in the CatRunner iOS engine and tests: single source for constants (design size, time epsilon, lane defaults), extract duplicated logic (fallback segment, segment-time margin), test helpers and README, optional naming convention. Smallest manageable chunks; no behavior change beyond removing duplication."
todos: []
isProject: false
---

# Tier 5 — Tech debt and consolidation

**Next hand off (cut & paste) — Lane A:** Tier 5 T5-C1 through **T5-C9** are done. Plan complete.

**Done (2026-02-24):** T5-C1 (design size), T5-C2 (time epsilon), T5-C3 (lane constants), **T5-C4 (fallback segment)**, **T5-C5 (segment-time margin)**, **T5-C6 (GameScene test helper)**, **T5-C7 (CatRunnerTests README)**, **T5-C8 (test file naming)**, **T5-C9 (CollisionSystem in Engine)**.

---

## Goal

- Reduce duplication and magic numbers in the iOS engine and tests.
- Single source for design size (393×852), time epsilon (0.2), default lane count/center, segment-time margin rule, and fallback segment construction.
- Shared GameScene test setup and test-docs coverage.
- Optional: test file naming convention; optional: CollisionSystem location (Engine vs Game).

## Scope

- **In scope:** `ios/CatRunner/` (Engine + Game), `ios/CatRunnerTests/`. No config/ or assets/ changes (Lane A only).
- **Out of scope:** New features; changes to game behavior beyond removing duplication.

## Build chunks

Chunks live in this folder. Execute in order T5-C1 → T5-C8. T5-C9 is optional.

| Chunk | Name | Description | Conf (root) | Conf (solution) |
|-------|------|--------------|-------------|-----------------|
| T5-C1 | [T5-C1-DesignSize.plan.md](T5-C1-DesignSize.plan.md) | Single source for design size (393×852); VC + tests use it or test helper | N/A | 92% |
| T5-C2 | T5-C2-TimeEpsilon.plan.md | Unify time-epsilon constant (0.2) for CollisionSystem and PowerUpSpawner | N/A | 93% |
| T5-C3 | T5-C3-LaneConstants.plan.md | Centralize default lane count (5) and center lane (2) | N/A | 92% |
| T5-C4 | T5-C4-FallbackSegment.plan.md | Extract fallback segment factory; use in startSegment and restartCurrentSegment | N/A | 91% |
| T5-C5 | T5-C5-SegmentTimeMargin.plan.md | Shared segment-time margin (duration × 0.1) for ObstacleGenerator and PowerUpSpawner | N/A | 92% |
| T5-C6 | T5-C6-GameSceneTestHelper.plan.md | GameScene test helper (scene + SKView + didMove); use in three test files | N/A | 93% |
| T5-C7 | T5-C7-TestREADME.plan.md | Update CatRunnerTests README to list all test files and coverage | N/A | 95% |
| T5-C8 | T5-C8-TestNaming.plan.md | Test file naming convention; rename for consistency | N/A | 88% |
| T5-C9 | [T5-C9-CollisionSystemEngine.plan.md](T5-C9-CollisionSystemEngine.plan.md) | CollisionSystem moved to Engine (optional, done 2026-02-24) | N/A | 85% |

## Validation strategy

- After each chunk: run full iOS test suite (unit + UI); baseline per Master-Plan (e.g. 75 unit + 8 UI, or current count). No new failures.
- `npm run test:full` (Vitest) must still pass.
- No change to game behavior except consolidation (same constants, same logic in one place).

## Risks and rollback

- **Risk:** Refactors could introduce subtle behavior change. Mitigation: one chunk at a time; run tests after each chunk; rollback = revert that chunk’s commit.
- **Rollback (per chunk):** Revert the commit for that chunk; re-run test suite. If regressions persist, escalate and document.

## Confidence (plan-level)

- **High** that the listed chunks are the right consolidation targets (from read-only exploration).
- **Medium-high** on test naming (T5-C8) and CollisionSystem move (T5-C9) being worth doing; both are optional and can be skipped or deferred.

## Reference (exploration)

Consolidation items and evidence were identified in read-only exploration of `ios/CatRunner` and `ios/CatRunnerTests`. Key files: `GameViewController.swift` (DesignSize), `GameScene.swift` (LaneCount, CenterLaneIndex, fallback segment blocks at ~347 and ~374), `CollisionSystem.swift` (timeEpsilon), `PowerUpSpawner.swift` (obstacleTimeEpsilon), `ObstacleGenerator.swift` (margin = duration * 0.1), `PlayerNode.swift` (defaultStartLane), and test files `DifficultySpawnRampGameSceneTests`, `GameSceneSafeAreaTests`, `RevivePlayAgainTests` (repeated 393×852 and scene setup).
