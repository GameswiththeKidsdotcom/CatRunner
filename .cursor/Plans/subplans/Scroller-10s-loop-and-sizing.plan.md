# Scroller 10s Loop and Avatar-Proportional Sizing

**Next hand off (cut & paste) — Lane A:** S4 validation complete (2026-02-23): code has 10s fallback, scrollerLoop restart, 44pt scaling; iOS 58/58 pass. Simulator check: segment ≥10s, same segment on wrap, sprites ≤44pt. Next: commit S4 or proceed per Master-Plan.

**Next hand off (cut & paste) — Lane B:** Execute S1 per this plan. In config/default/variant.json set engine.segmentDurationSeconds to "min": 10, "max": 12; optionally add engine.scrollerLoop. Lane B may edit config/ and assets/ only. Reference: [Agents/planner.md](../../Agents/planner.md).

**Blaster pipeline:** Complete. All chunks ≥90%; ready for build.

---

## Goal

- **Duration:** Scroller lasts at least 10 seconds per cycle.
- **Wrap:** The same cycle repeats seamlessly (same segment content when the segment ends).
- **Content:** Dog (enemy) and obstacle "boxes" (passable, instantFail, slowdown) are the obstacles; already used in [GameScene](ios/CatRunner/Game/GameScene.swift) and [SegmentGenerator](ios/CatRunner/Engine/SegmentGenerator.swift).
- **Sizing (ui-designer):** All obstacle and dog sprites are sized relative to the avatar (44×44 pt) so scale and visual hierarchy are consistent (Canva: focal point = avatar; secondary = obstacles/enemy).

## 1. Segment duration >= 10 seconds

- **Config (Lane B or shared):** In [config/default/variant.json](config/default/variant.json), set `engine.segmentDurationSeconds` so each segment is at least 10s, e.g. `"min": 10, "max": 12` (or `10` and `10` for a fixed 10s loop).
- **Fallback (ios/):** When variant is not loaded, the fallback in [GameScene.startSegment()](ios/CatRunner/Game/GameScene.swift) uses a hardcoded 3s segment; change that to 10s so the "no config" case also has a 10s scroller.

## 2. Scroller "wraps perfectly" (seamless loop)

- **Idea:** When the current segment ends, restart the **same** segment (same seed and duration) instead of advancing to a new one.
- **Implementation (ios/):** In [GameScene](ios/CatRunner/Game/GameScene.swift): introduce scroller loop flag (config preferred, or constant for MVP). When true, on segment end call restart with same seed; do **not** call `scoreKeeper.addSegmentCompleted()` on restart. When false, current behavior (advance to next segment, add score).
- **Files:** GameScene — `advanceToNextSegment()`, optional `startSegment(useSeed: UInt64?)` or branch in update.

## 3. Dog and boxes as obstacles; sizing to avatar

- **Content:** Dog and boxes already used; no new asset keys.
- **Sizing:** In [GameScene.refreshSegmentSprites()](ios/CatRunner/Game/GameScene.swift): scale obstacle and enemy sprites so max dimension = 44pt, preserve aspect ratio (see Detailed Design). Placeholder stays 40×40.

## 4. Validation

- Run app: segment ≥10s, then same segment restarts; sprites avatar-sized; unit tests still pass (loop flag or test path so advance tests unchanged).

## 5. Scope and risks

- **Lane A (ios/):** Loop logic, 10s fallback, sizing. **Lane B (config/):** variant.json segment duration and optional scrollerLoop.
- **Scoring decision:** On loop restart, **do not** call `scoreKeeper.addSegmentCompleted()`.

## Rollback (split by area)

- **Config:** Revert variant.json (segment duration and scroller loop flag).
- **Fallback:** Revert GameScene fallback segment duration to 3s.
- **Loop:** Revert GameScene loop branch; restore advance-only.
- **Sizing:** Revert refreshSegmentSprites() to texture.size() and 40×40 placeholder.
- **Verify:** Re-run iOS test suite and simulator.

## Detailed Design

- **Scroller loop flag:** Config (e.g. `engine.scrollerLoop` in variant.json) preferred; default false. MVP: constant in GameScene.
- **Scale formula:** Constant 44pt. `scale = min(44 / max(w, h), 1.0)`; `node.size = CGSize(width: w*scale, height: h*scale)`. Cap 1.0 to never upscale.

## Best Routes

1. Config: segment duration min/max ≥ 10; optional scrollerLoop.
2. GameScene: 10s fallback; loop branch (restart same seed, no addSegmentCompleted on restart).
3. refreshSegmentSprites(): scale obstacle/enemy to 44pt max, preserve aspect ratio.
4. Validation: manual 10s + loop + sizing; unit tests unchanged.

## Confidence (Blaster)

| Section | Conf (root) | Conf (solution) | Note |
|---------|-------------|-----------------|------|
| Goal | 92% | 92% | Decisions and formula documented. |
| §1 Duration | 95% | 92% | Config + fallback explicit. |
| §2 Loop | 93% | 92% | Same-seed restart; no score on restart. |
| §3 Sizing | 94% | 92% | 44pt formula in Detailed Design. |
| §4 Validation | 90% | 90% | Manual + tests; rollback documented. |
| §5 Scope | 92% | 92% | Rollback split; scoring decision explicit. |

## Summary

| Item | Where | Action |
|------|--------|--------|
| Duration ≥10s | config + GameScene fallback | variant.json min/max 10–12; fallback 10s |
| Wrap (loop) | GameScene | Restart same segment (same seed); no score on restart |
| Dog + boxes | Already present | No change |
| Sizing | refreshSegmentSprites | Scale to 44pt max, preserve aspect ratio |

## Test plans (from Step 2)

- **UI test plan:** [Scroller-10s-loop-UI-test-plan.md](Scroller-10s-loop-UI-test-plan.md)
- **Logic test plan:** [Scroller-10s-loop-logic-test-plan.md](Scroller-10s-loop-logic-test-plan.md)
- **Infrastructure:** No changes required.

**UI (2–3 items):** Segment runs ≥10s before wrap; seamless loop (same segment repeats, no score increment on restart); obstacle/dog sprites scaled to 44pt max, aspect ratio preserved; 5-iPhone viewport matrix (design 393×852; Small/Standard/Standard-alt/Large/Max) with 10s loop and 44pt scaling verified on each.

**Logic (2–3 items):** Duration ≥10s from config and fallback (assert `segment.durationSeconds >= 10`, fallback 10s when config nil); loop mode restarts same segment (same seed), segment index unchanged, no `addSegmentCompleted` on restart; mock ScoreKeeper (or call-count spy) to assert addSegmentCompleted not called on loop restart, called on real advance.

---

## Chunks (Blaster Step 4 — build order)

| Chunk | Description | Files | Lane |
|-------|-------------|-------|------|
| S1 | Config: segment duration ≥10s, optional scrollerLoop | config/default/variant.json (and schema if scrollerLoop added) | B |
| S2 | GameScene: 10s fallback + loop branch (restart same seed, no addSegmentCompleted on restart) | ios/CatRunner/Game/GameScene.swift | A |
| S3 | refreshSegmentSprites: 44pt max scaling, aspect ratio preserved | ios/CatRunner/Game/GameScene.swift | A |
| S4 | Validation: manual 10s + loop + sizing; unit tests; rollback check | — | — |

## Per-chunk confidence (Blaster Step 5)

Chunk mapping: **S1** = config duration + scrollerLoop, **S2** = GameScene fallback + loop branch, **S3** = 44pt scaling in refreshSegmentSprites, **S4** = validation. Evaluated on: clarity of outcome, steps, validation, rollback, CatRunner scope (1 player, 5 lanes).

| Chunk | Conf (root) | Conf (solution) | Note |
|-------|-------------|-----------------|------|
| S1 | 95% | 92% | Config path explicit (variant.json, EngineVariantConfig). Adding scrollerLoop may require schema engine.properties + decode; duration min/max ≥10 is a direct edit. Rollback: revert variant (and schema if changed). |
| S2 | 93% | 92% | Fallback is one-line (3→10s). Loop branch: read scrollerLoop (config or constant), in update on segment end branch restart same seed (no index increment, no addSegmentCompleted) vs advance. Call sites and contract are specified. |
| S3 | 94% | 92% | Single method, three loops (obstacles, power-up, enemy). Formula in Detailed Design; placeholder 40×40 unchanged. Low coupling; rollback reverts node size logic only. |
| S4 | 90% | 90% | Manual (10s, loop, 44pt) and logic test plan (duration, loop index/seed, mock ScoreKeeper) are defined. Existing advance-only tests may need loop flag or test path to stay unchanged. |

**Gate check:** All chunks meet the Blaster gate (target ≥90%). **Ready for build.**
