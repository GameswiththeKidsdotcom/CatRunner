# P001 — CatRunner iOS Game (Main Plan)

**Next hand off:** Same as Master-Plan Lane A — P001 C1–C12 complete. To finish: (1) Run full test suite and confirm baseline. (2) Commit and push to GitHub per commit checkpoint; update Master-Plan with push date. (3) Invoke planner after push to refresh next hand off.

---

## Scope

CatRunner: 5-lane endless runner; cat vs dogs; VariantConfig-driven; App Store-ready. Scaffolded items: see Master-Plan § Scaffolded items (by location) and (by chunk).

## Feature → Object Map

| Feature | Objects |
|---------|---------|
| Core game loop | GameScene, LaneManager, PlayerNode |
| Procedural generation | SegmentGenerator, ObstacleGenerator, PowerUpSpawner |
| Config-driven engine | VariantConfig, ConfigLoader |
| Mechanics | Jump/SlideController, CollisionSystem |
| Admin | ConfigEditor, AssetUpload (Next.js) |
| Delivery | CI/CD workflows, XCTest targets |

## Design / supporting plans

- [Sprites & UI assets](sprites-ui-assets.plan.md) — Asset inventory, image specs, ui-designer workflow for character, obstacles, power-ups, UI, app icon.

## Phases / Chunks (ordered)

1. [C1 — Bootstrap](C1-bootstrap.plan.md)
2. [C2 — VariantConfig](C2-config.plan.md)
3. [C3 — SegmentGenerator](C3-segment-generator.plan.md)
4. [C4 — Obstacle types](C4-obstacle-types.plan.md)
5. [C5 — Path guarantee](C5-path-guarantee.plan.md)
6. [C6 — Power-up spawner](C6-powerup-spawner.plan.md)
7. [C7 — Mechanics & collision](C7-mechanics-collision.plan.md)
8. [C8 — Difficulty & scoring](C8-difficulty-scoring.plan.md)
9. [C9 — Admin panel](C9-admin-panel.plan.md)
10. [C10 — CI/CD](C10-cicd.plan.md)
11. [C11 — Tests](C11-tests.plan.md)
12. [C12 — Agents & spec](C12-agents-spec.plan.md)

## Risks

- Determinism: lock RNG; regression tests.
- Path guarantee: unit tests per segment; fallback to spread-only.
