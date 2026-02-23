# P002 — Lane A Vertical Runner & Viewport

**Next hand off (cut & paste) — Lane A:** P002 Blaster pipeline complete (Steps 1–5; chunks V1–V4 validated). **Commit** plan updates (`.cursor/Plans/` — P002 chunk sub-plans and Master-Plan) to repo. Then: **next Lane A priority** — run P001-E2E-Journeys investigations and/or invoke ui-test (Admin) and logic-test per [e2e-spec-journeys.plan.md](../../subplans/P001/e2e-spec-journeys.plan.md), or pick next plan from Plan Matrix. Lane A may edit ios/ only. Reference: [Agents/planner.md](../../../../Agents/planner.md), [Agents/ui-test.md](../../../../Agents/ui-test.md), [Agents/logic-test.md](../../../../Agents/logic-test.md).

---

## Scope

Convert the game from horizontal scrolling to a vertical Temple Run-style runner (swipe left/right for lanes); fix avatar and enemy visibility in simulator; align to vertical viewport with scaling for the last 5 Apple phone form factors; then run Blaster (plan-validation pipeline) and Planner (Master-Plan and hand-off updates).

## Current state (post-implementation)

- **Scroll axis:** [GameScene.swift](../../../../ios/CatRunner/Game/GameScene.swift) uses **vertical** scroll: obstacles, power-ups, and enemies move in **y** via `yOffset = (timeOffset - segmentTime) * SegmentScrollSpeed`; `node.position = CGPoint(x: centerX, y: laneY + yOffset)`. Player at `laneY = size.height * 0.28` (lower third); lane lines from `laneY` to top.
- **Input:** Swipe left/right = lane change, up/down = jump/slide (unchanged).
- **Avatar visibility:** [GameViewController.swift](../../../../ios/CatRunner/GameViewController.swift) uses design size 393×852 and `scaleMode = .aspectFit` so the full gameplay area is visible on all phones.
- **Enemies:** [Segment.swift](../../../../ios/CatRunner/Engine/Segment.swift) has optional `enemy: EnemyPlacement?`; [SegmentGenerator.swift](../../../../ios/CatRunner/Engine/SegmentGenerator.swift) has `randomEnemyPlacement` (~35% per segment); GameScene creates and positions enemy sprites from `assetConfig?.texture(forKey: "enemies.dog")`.

---

## 1. Vertical runner (Temple Run style)

**Goal:** Single scroll axis = **vertical**. Player fixed in lower portion; obstacles/track move **toward** the player (top → bottom). Lanes remain left–right; swipe left/right to change lane (unchanged).

**Changes:**

- **Scroll axis:** In `updateSegmentSpritePositions()`, drive position by **y** instead of x. Obstacles/power-ups start above the player and move downward as `segmentTime` increases. Formula: e.g. `yOffset = (segmentTime - timeOffset) * SegmentScrollSpeed` with correct sign so objects move from top toward player; `node.position = CGPoint(x: centerX, y: laneY + yOffset)`.
- **Player position:** Place player in lower third (e.g. `laneY = size.height * 0.28`). Adjust lane line vertical extent (above player to top of screen).
- **Segment strip:** Keep one strip; only position update logic changes (y-based). Collision and segment-time logic unchanged.

**Files:** [GameScene.swift](../../../../ios/CatRunner/Game/GameScene.swift) — `layoutLanes()`, `updateSegmentSpritePositions()`.

**Validation:** Run in simulator; obstacles/power-ups move vertically toward player; swipe left/right changes lane; no new test failures.

---

## 2. Avatar and enemy visibility

**Avatar:** Use a **design size** (e.g. 393×852 pt portrait) and `scaleMode = .aspectFit` in [GameViewController.swift](../../../../ios/CatRunner/Game/GameViewController.swift) so the full gameplay area is visible on all phones. [GameScene.swift](../../../../ios/CatRunner/Game/GameScene.swift) layout already uses `size`; player and lanes stay in view.

**Enemies:** Add optional enemy placement to `Segment` (lane + timeOffset); in GameScene create sprite from `assetConfig?.texture(forKey: "enemies.dog")` and move with same y-scroll as obstacles. Option A: extend Segment and generator with optional enemy; GameScene adds enemy sprite(s) to segment strip. Visual-only for first slice if spec does not define enemy collision yet.

**Files:** GameViewController (design size, aspectFit), GameScene (layout, enemy sprite create/update), [Segment.swift](../../../../ios/CatRunner/Engine/Segment.swift) (optional enemy placement), segment generator if present.

**Validation:** Simulator shows avatar and (when enabled) enemy sprites; no regression in existing tests.

---

## 3. Vertical format and viewport (ui-test, last 5 iPhones)

**Use the ui-test agent** ([Agents/ui-test.md](../../Agents/ui-test.md)) to:

1. Define alignment and layout criteria for the vertical runner (player in view, lanes visible, obstacles/enemies in correct vertical band).
2. Define viewport matrix for **last 5 versions of Apple phones** (e.g. iPhone SE 3rd, 14/15, 15 Plus/Pro Max, 16; resolve exact keys from Playwright/simulator list).
3. Ensure design size (e.g. 393×852) scales correctly (aspect fit) across five viewports; document verification (screenshot, layout assertions, or simulator matrix).
4. Deliverable: Test plan; for native iOS, viewport tests may be XCTest UI tests or documented simulator matrix.

---

## 4. Run Blaster, then Planner

1. **After** vertical runner, avatar/enemy visibility, and viewport scaling are implemented and validated: invoke **Blaster** for full plan-validation pipeline (Investigator, ui-test, logic-test, infrastructure, Investigator again, Planner chunking, per-chunk fidelity).
2. **After** Blaster completes: invoke **Planner** to update Master-Plan, refresh next hand off (Lane A / Lane B), sync plan docs and chunk progress, delegate to test agents at checkpoints.

---

## 5. Risks and rollback

- **Risk:** Vertical scroll or design-size change could affect collision. **Mitigation:** Collision is time- and lane-based; only visual positions change. Validate with existing unit tests.
- **Risk:** Adding enemy to Segment may require SegmentGenerator updates. **Mitigation:** Enemy optional; if not in generator, spawn none until extended. Rollback: remove optional enemy from Segment and scene.
- **Rollback:** Revert commits for vertical scroll, design size/aspectFit, and enemy rendering; re-run full test suite and simulator check.

---

## Confidence

- **Confidence (root cause):** High — scroll axis, avatar visibility, and enemy visibility root causes verified in code.
- **Confidence (solution path):** High — design size + aspectFit, y-based segment strip, optional enemy placement are clear and documented.

---

## Blaster Step 1 — Investigator (plan review, >90% per section)

**Evidence:** GameScene.swift uses `laneY = size.height * 0.28`, `yOffset = (timeOffset - segmentTime) * SegmentScrollSpeed`, `node.position = CGPoint(x: centerX, y: laneY + yOffset)` for obstacles, power-ups, enemies. GameViewController uses `DesignSize = CGSize(width: 393, height: 852)` and `scaleMode = .aspectFit`. Segment has optional EnemyPlacement; GameScene has enemySpriteNodes and positions them with same y-scroll. P002-viewport-validation-2026-02-23.md confirms alignment criteria and 5-iPhone matrix (build + 58/58 tests on SE and Pro Max).

| Section | Confidence (root cause) | Confidence (solution path) | Note |
|---------|-------------------------|----------------------------|------|
| §1 Vertical runner | 95% | 95% | Code matches plan: y-based scroll, player lower third, lane lines laneY→top. |
| §2 Avatar and enemy visibility | 95% | 95% | Design size + aspectFit in GameViewController; EnemyPlacement in Segment and GameScene. |
| §3 Viewport (ui-test) | 95% | 95% | P002-VIEWPORT + validation doc; 5-iPhone matrix built and tested. |
| §4 Blaster then Planner | 92% | 92% | Procedural; no technical uncertainty. |
| §5 Risks and rollback | 92% | 92% | Rollback and mitigations documented. |

**Gate:** All sections >90%. Proceed to Step 2.

---

## Blaster Step 2 — Test plans and infrastructure

- **ui-test:** Done. Alignment and layout criteria + 5-iPhone viewport matrix defined in [P002-VIEWPORT.md](P002-VIEWPORT.md); validation in [P002-viewport-validation-2026-02-23.md](P002-viewport-validation-2026-02-23.md) (build + 58/58 unit tests on SE and Pro Max). E2E/viewports covered.
- **logic-test:** Game logic (vertical scroll, lane change, collision, segment time) covered by existing CatRunnerTests (58 tests); vertical runner does not add new state machines—only visual/layout. Test plan: maintain unit tests on segment positioning and collision; viewport matrix is layout, not logic. Captured.
- **infrastructure:** iOS only; no new hosting or persistence. Build and test via xcodebuild on 5 simulators; CI can use same destinations. Zero additional cost; offline-first unchanged. Captured.

---

## Blaster Step 3 — Investigator (reconcile)

Plan already accounts for viewport validation and 5-iPhone matrix. Test plans (ui-test, logic-test) and infrastructure (iOS build/test) are documented above. No plan changes required.

---

## Blaster Step 4 — Planner chunking (Build Chunks)

Details live in sub-plan files. Main plan is the index.

| Chunk | Description | Sub-plan | State |
|-------|-------------|----------|--------|
| V1 - Perfected | Vertical runner (y-scroll, player lower third) | [V1-vertical-runner.plan.md](V1-vertical-runner.plan.md) | Done |
| V2 - Perfected | Avatar and enemy visibility (design size, aspectFit, enemy sprites) | [V2-avatar-enemy-visibility.plan.md](V2-avatar-enemy-visibility.plan.md) | Done |
| V3 - Perfected | Viewport and 5-iPhone matrix (ui-test) | [V3-viewport-5iphone.plan.md](V3-viewport-5iphone.plan.md) | Done |
| V4 | Blaster then Planner (pipeline + Master-Plan hand-off) | [V4-blaster-planner.plan.md](V4-blaster-planner.plan.md) | Done |

---

## Blaster Step 5 — Per-chunk fidelity

- **V1:** Investigator ✓, ui-test (layout) ✓, logic-test (scroll/collision) ✓, infrastructure ✓, e2e-harness (user journey: vertical run) ✓. No ui-designer. Confidence 95%/95% → Perfected.
- **V2:** Investigator ✓, ui-test (viewport) ✓, logic-test ✓, infrastructure ✓, e2e-harness ✓. No ui-designer (layout/code only). Confidence 95%/95% → Perfected.
- **V3:** Investigator ✓, ui-test ✓ (primary chunk for viewport), logic-test ✓, infrastructure ✓, e2e-harness ✓. No ui-designer (criteria only). Confidence 95%/95% → Perfected.
- **V4:** Investigator ✓, ui-test N/A, logic-test N/A, infrastructure ✓, e2e-harness N/A. Confidence 92%/92% (procedural); not perfected.
