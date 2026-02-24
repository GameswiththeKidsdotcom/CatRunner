---
name: T5-C1 — Single source for design size
plan_id: Tier5-TechDebt
chunk_id: T5-C1
overview: Introduce a single source for the design size (393×852) used by GameViewController and by GameScene-related tests; VC and tests reference it (tests may use a shared test helper that returns the same size).
---

**Next hand off (cut & paste) — Lane A:** Implement **Tier 5 T5-C1 (Single source for design size)**. Plan file: this file ([T5-C1-DesignSize.plan.md](.cursor/Plans/subplans/Tier5-TechDebt/T5-C1-DesignSize.plan.md)). Add a shared constant for design size (393×852). GameViewController and all tests that create a GameScene with this size must use that constant (or a test helper that returns it). Then continue T5-C2→T5-C8 per [Tier5-TechDebt-Consolidation.plan.md](Tier5-TechDebt-Consolidation.plan.md).

---

# T5-C1 — Single source for design size

**Parent plan:** [Tier5-TechDebt-Consolidation.plan.md](Tier5-TechDebt-Consolidation.plan.md)

## Scope

- **Goal:** One place defines the design size (393×852). No duplicated literal across VC and tests.
- **In scope:** `ios/CatRunner/` (where design size is used), `ios/CatRunnerTests/` (tests that create GameScene with 393×852).
- **Out of scope:** Changing the numeric value; other constants (lane count, time epsilon, etc.) are T5-C3/T5-C2.

## Evidence (current state)

- **GameViewController.swift:15** — `private let DesignSize = CGSize(width: 393, height: 852)`; used at lines 42, 54–55, 153.
- **DifficultySpawnRampGameSceneTests.swift** — `let size = CGSize(width: 393, height: 852)` at lines 17, 31, 40, 51.
- **GameSceneSafeAreaTests.swift** — `let size = CGSize(width: 393, height: 852)` at line 16.
- **RevivePlayAgainTests.swift** — `let size = CGSize(width: 393, height: 852)` at lines 16, 25, 36.

## Steps

1. **Introduce shared constant.** Options (choose one):
   - **Option A:** New file `ios/CatRunner/DesignConstants.swift` (or similar) with `enum DesignConstants { static let designSize = CGSize(width: 393, height: 852) }`. Make it visible to both app and test targets (add CatRunnerTests to "Compile Sources" for this file, or use a shared module).
   - **Option B:** Keep constant in app target only; in tests, add a test helper (e.g. in a test support file) that returns `CGSize(width: 393, height: 852)` and document that it must match `GameViewController`'s design size (or import app module and reference if possible).
   - **Option C:** If the app exposes the design size via a public API (e.g. on GameViewController or a config), tests could use that. Prefer Option A if tests can compile the same Swift file; otherwise Option B with a single test helper and a comment linking to GameViewController.

2. **GameViewController:** Replace `private let DesignSize` with a reference to the shared constant (e.g. `DesignConstants.designSize`). Ensure scene creation and layout still use this size.

3. **Tests:** Replace every `CGSize(width: 393, height: 852)` and any local `size` literal in DifficultySpawnRampGameSceneTests, GameSceneSafeAreaTests, and RevivePlayAgainTests with the shared constant or the test helper that returns it.

4. **Validation:** Build and run the full iOS test suite (unit + UI). No new failures. Visually confirm the game still uses the same design size (no layout change).

## Rollback

- Revert the commit: restore `private let DesignSize = CGSize(width: 393, height: 852)` in GameViewController; restore `let size = CGSize(width: 393, height: 852)` in the three test files; remove the new DesignConstants file or test helper.
- Re-run tests to confirm baseline.

## Confidence

| Metric | Value | Note |
|--------|--------|------|
| Confidence (root cause) | N/A | Consolidation only. |
| Confidence (solution path) | 92% | Straightforward; only decision is where to put the constant (app-only vs shared with tests). |
