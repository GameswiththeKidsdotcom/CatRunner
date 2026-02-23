# C7 — Jump/Slide & Collision Detection

**Next hand off:** C7 done. Implement C8 (Difficulty scaling, scoring, revive) per [C8-difficulty-scoring.plan.md](C8-difficulty-scoring.plan.md). Then invoke [Agents/planner.md](../../../Agents/planner.md) to ensure Lane B is still the proper hand off.

---

## Goal

Jump (upward) and slide (crouch/dive) mechanics; lane swap (left/right); collision detection for Passable, Instant-Fail, Slowdown and power-up collection.

## Steps

1. Add jump/slide durations from VariantConfig (e.g. 0.4s jump, 0.5s slide).
2. Implement jump: upward motion; avoids low obstacles.
3. Implement slide: crouch/dive; avoids high obstacles.
4. Lane swap: swipe or tap left/right; clamp lane 0–4.
5. CollisionSystem: detect player vs obstacle (by type → passable vs instant-fail vs slowdown); player vs power-up (collect, apply effect).
6. Instant-fail: trigger game-over or revive flow (revive mechanics in C8).

## Validation

- Simulation tests: jump/slide execute; collision triggers correct behavior.
- Logic-test: no unreachable valid moves; state consistent.

## Rollback

- Disable jump/slide; lane-only movement.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
