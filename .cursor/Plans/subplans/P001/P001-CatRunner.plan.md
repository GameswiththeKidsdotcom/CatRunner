# P001 — CatRunner iOS Game (Main Plan)

**Next hand off:** Same as Master-Plan Lane A — Next priority: **Tier 3 (Scalability for App Store)** per [Master-Plan.md](../../Master-Plan.md). E2E scope: [e2e-spec-journeys.plan.md](e2e-spec-journeys.plan.md). Lane A may edit ios/ only. Path to archive for each sub-plan: see Master-Plan § Path to archive (per plan).

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

- [Sprites & UI assets](zz-archive/sprites-ui-assets.plan.md) — Asset inventory, image specs, ui-designer workflow for character, obstacles, power-ups, UI, app icon.
- [UI mockups (Lane B)](zz-archive/ui-mockups.plan.md) — In-game UI mockups: pixel art, Revive/Game over, store in assets/ui/.

## Phases / Chunks (ordered)

1. [C1 — Bootstrap - Perfected](zz-archive/C1-bootstrap.plan.md)
2. [C2 — VariantConfig - Perfected](zz-archive/C2-config.plan.md)
3. [C3 — SegmentGenerator](zz-archive/C3-segment-generator.plan.md)
4. [C4 — Obstacle types](zz-archive/C4-obstacle-types.plan.md)
5. [C5 — Path guarantee](zz-archive/C5-path-guarantee.plan.md)
6. [C6 — Power-up spawner](zz-archive/C6-powerup-spawner.plan.md)
7. [C7 — Mechanics & collision](zz-archive/C7-mechanics-collision.plan.md)
8. [C8 — Difficulty & scoring](zz-archive/C8-difficulty-scoring.plan.md)
9. [C9 — Admin panel](zz-archive/C9-admin-panel.plan.md)
10. [C10 — CI/CD](zz-archive/C10-cicd.plan.md)
11. [C11 — Tests](zz-archive/C11-tests.plan.md)
12. [C12 — Agents & spec](zz-archive/C12-agents-spec.plan.md)

## Risks

- Determinism: lock RNG; regression tests.
- Path guarantee: unit tests per segment; fallback to spread-only.

## Confidence

- **Conf (root cause):** 92% — Scope and problem (5-lane endless runner, VariantConfig, App Store-ready) are well understood and bounded.
- **Conf (solution path):** 93% — All 12 build chunks (C1–C12) implemented or in progress; C10 CI/CD and C11 tests validate; Blaster review done; risks and rollback documented; C1 and C2 perfected with Notes.

**Per-section (Investigator-validated):**

| Section | Confidence | Rationale |
|--------|------------|-----------|
| Scope | 95% | Clear and bounded (5-lane endless runner, VariantConfig, App Store-ready); minor dependency on Master-Plan for scaffolded items. |
| Feature → Object Map | 93% | Features mapped to objects and to chunks that implement them; traceability good, no major gaps. |
| Design / supporting plans | 90% | Sprites-ui-assets and ui-mockups linked and validated; design-level only. |
| Phases / Chunks | 92% | C1–C2 perfected with Notes; C3–C12 done or in progress but confidence not yet evaluated per chunk (conservative until C3–C12 have confidence/Notes). |
| Risks | 90% | Determinism and path-guarantee have stated mitigations (RNG lock, regression tests, path unit tests, spread-only fallback). |
| Rollback | 91% | Per-chunk and full revert described; top-level Rollback section in plan; relies on known-good commit and clear chunk boundaries. |

**Why solution path >90%:** All six plan sections (Scope, Feature→Object Map, Design, Phases, Risks, Rollback) have Investigator-validated confidence ≥90%. C1 and C2 are perfected with Notes; C10 (CI) and C11 (tests) provide ongoing validation; rollback is explicit at plan and chunk level. Investigator bar (93%+) is met.

**Caveat:** C3–C12 do not yet have evaluated Confidence (root/solution) and Note in sub-plans or Master-Plan Build Chunk Progress; filling these per Blaster would support raising solution-path toward 95%. Until then, 93% remains justified by C1–C2 perfected state and documented risks and rollback.

**Investigator validation (Blaster Lane B, 2026-02-23):** Solution path 93% and per-section confidence table validated; plan meets Investigator 93%+ solution-path bar and is ready for execution.

## Rollback

Revert by chunk where possible (e.g. remove or revert only the changed config/ or ios/ subtree for that chunk). Full rollback: revert `ios/`, `config/`, and `assets/` to last known-good commit; re-run build and tests.
