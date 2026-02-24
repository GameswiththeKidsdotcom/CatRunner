---
name: T5-C9 — CollisionSystem in Engine (optional)
plan_id: T5-C9-CollisionSystemEngine
parent: Tier5-TechDebt-Consolidation.plan.md
overview: "Move CollisionSystem from Game to Engine: it depends only on Engine types (ObstaclePlacement, PowerUpPlacement from Segment) and DesignConstants; no Game-specific types. Pure refactor; no behavior change."
todos: []
isProject: false
---

# T5-C9 — CollisionSystem in Engine (optional)

**Status:** Implemented 2026-02-24 (Lane A).

## Goal

- Move `CollisionSystem.swift` from `ios/CatRunner/Game/` to `ios/CatRunner/Engine/` so collision logic lives with other segment/placement logic.
- No API or behavior change; callers (GameScene, C7MechanicsCollisionTests) unchanged.

## Rationale

- **Dependencies (read-only):** CollisionSystem uses only `DesignConstants`, `ObstaclePlacement`, `PowerUpPlacement` (Segment), and `Foundation`. All are available to Engine; no Game-only types (PlayerNode, GameScene, etc.).
- **Cohesion:** ObstacleGenerator, PowerUpSpawner, PathGuarantee, and Segment already live in Engine; collision operates on the same placement types.

## Implementation

1. **Move file:** `Game/CollisionSystem.swift` → `Engine/CollisionSystem.swift`. Optionally add a one-line header note: "T5-C9 — Moved to Engine."
2. **Xcode project:** In `project.pbxproj`, move the file reference for CollisionSystem from the Game group (`B2000004`) to the Engine group (`B2000005`). File reference `A2000015` and build file `A1000016` unchanged; only group membership changes so the file is resolved under `Engine/`.
3. **Code:** No signature or import changes. GameScene and C7MechanicsCollisionTests continue to call `CollisionSystem.check(...)`; they remain in the same target.

## Validation

- `npm run test:full` (Vitest) still passes.
- iOS: `xcodebuild test -scheme CatRunner -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'` — 75 unit + 8 UI tests, no new failures.
- Build: `xcodebuild build -scheme CatRunner -destination 'generic/platform=iOS Simulator'` succeeds.

## Rollback

- Revert the commit: move `Engine/CollisionSystem.swift` back to `Game/CollisionSystem.swift` and restore the file’s membership to the Game group in `project.pbxproj`.

## Confidence

- **Root cause / scope:** 95% — dependencies verified; only Engine and app-level types.
- **Solution:** 90% — file move + group change; no logic change.

## Risks

- Low. If the project uses folder-based visibility, path change could theoretically affect something; in this project all app and test code are in the same target and see the same module. No Swift package boundaries.
