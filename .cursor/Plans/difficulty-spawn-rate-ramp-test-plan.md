# Difficulty spawn rate ramp — Test plan

**Feature:** Time-based obstacle spawn rate (1 per 5s at start, +0.1 per 5s game time).  
**Scope:** CatRunner — 1 player, 5 lanes, procedural segments.  
**Reference:** [difficulty-spawn-rate-ramp.plan.md](difficulty-spawn-rate-ramp.plan.md).

This document lists test items for **E2E**, **UX**, **viewports**, and **user journeys**. No test implementation; plan only.

---

## 1. E2E

| ID | Item | Description |
|----|------|--------------|
| E1 | **Ramp formula (unit)** | Already in feature plan: DifficultyScalerTests — `spawnRate(elapsedSeconds:)` returns 0.2 at 0s, 0.3 at 5s, 0.4 at 10s with config (5, 0.1). |
| E2 | **Target count honored** | ObstacleGenerator: when `targetObstacleCount` is provided, generated count matches (or ≤ target when path guarantee removes obstacles). |
| E3 | **Segment count from rate** | SegmentGenerator (or integration): with `elapsedTimeAtSegmentStart` and spawn-rate config, obstacle count per segment is in expected range (rate × duration ± rounding); optional: deterministic seed + elapsed values, assert approximate counts. |
| E4 | **Ramp over time (play N segments)** | **Ramp assertion:** Run or simulate N segments with increasing `elapsedTimeAtSegmentStart` (e.g. 0, 11, 22, 33s); sample obstacle counts per segment; assert that **later segments have ≥ or higher average count** than earlier segments (monotonic or clearly increasing trend). Handles rounding by checking trend, not exact numbers. |
| E5 | **Elapsed time at checkpoint** | After revive (J4), next segment uses `checkpointElapsedTime` (not reset); E2E or integration: resume from checkpoint and assert next segment’s obstacle count is consistent with resumed elapsed time (not as if new run). |
| E6 | **New run resets elapsed** | On new run (J1 start or J5 Play again), first segment has low obstacle count (rate at 0s = 0.2); assert or sample segment 0 count in expected “early game” range. |

**Obstacles ramp over time — E2E coverage:** Yes. Use **E4** (play N segments / simulate elapsed time, assert increasing density trend) as the main E2E ramp check. Optionally combine with **E3** for deterministic seed runs to assert approximate rate×duration counts. **E5** and **E6** ensure elapsed time and reset behavior don’t break the ramp.

---

## 2. UX

| ID | Item | Description |
|----|------|--------------|
| U1 | **Perceived difficulty curve** | Subjective: early game (0–30s) feels manageable; mid game (≈1–2 min) noticeably harder; not a sudden spike. Manual or exploratory. |
| U2 | **Readability at higher density** | When obstacle count per segment is high, obstacles remain distinguishable and lanes readable; no overlapping or unfair “wall” in one segment. Manual check on one device. |
| U3 | **Fairness** | Path guarantee still leaves at least one clear path; player can avoid obstacles with valid moves. Optional: align with existing path-guarantee tests; UX sign-off that ramp doesn’t make segments unbeatable. |

**Obstacles ramp over time — UX coverage:** Yes. **U1** and **U2** cover “ramp feels right” and “still playable at high density”; **U3** ties to path guarantee. No automated UX tests required in this plan; manual or exploratory.

---

## 3. Viewports

| ID | Item | Description |
|----|------|--------------|
| V1 | **Ramp consistent across devices** | Same 5-iPhone matrix as [e2e-spec-journeys.plan.md](subplans/P001/e2e-spec-journeys.plan.md) (SE, 14, 15, 16, 16 Pro Max): run E2E ramp checks (e.g. E4, E6) on at least one device; optionally run on full matrix to ensure elapsed time and segment generation behave the same (no device-specific bugs). |
| V2 | **Layout at high density** | On smallest (e.g. iPhone SE) and largest (e.g. 16 Pro Max) viewport, when segment has many obstacles, layout remains correct (obstacles in lane band, no clip, aspect fit unchanged). Manual or existing viewport criteria from P002. |

Viewport matrix remains the existing 5-iPhone + Admin desktop; no new viewports. Ramp is logic-driven; viewport tests ensure no layout/visibility regressions when density increases.

---

## 4. User journeys

| ID | Item | Description |
|----|------|--------------|
| J2-ext | **J2 (Gameplay) — ramp during run** | Extend J2 or add a “long run” variant: play through several segments (e.g. 3–5); assert game continues and obstacle spawns occur; optional: assert segment obstacle counts increase (journey-level E4). |
| J4-ext | **J4 (Revive) — difficulty preserved** | After revive, next segment difficulty is consistent with resumed elapsed time (more obstacles than segment 0). Covered by E5; journey test can assert “resumed run remains harder” (e.g. next segment has more obstacles than first segment of a new run). |
| J5-ext | **J5 (Play again) — reset** | After “Play again”, new run starts with low density (segment 0). Covered by E6; journey test can assert first segment after play-again has “early game” density. |

No new journey IDs; extend existing J2, J4, J5 with ramp-related assertions or variants as above.

---

## 5. Summary

| Area | Items | Ramp-specific |
|------|--------|----------------|
| E2E | E1–E6 | E4 (ramp trend), E5 (checkpoint), E6 (new run reset) |
| UX | U1–U3 | Perceived curve, readability, fairness |
| Viewports | V1–V2 | Matrix consistency, layout at high density |
| Journeys | J2/J4/J5 extensions | Long run, revive preserves difficulty, play again resets |

**Obstacles ramp over time:** E2E coverage via **E4** (play N segments, assert increasing density) and optionally **E3** (deterministic rate×duration). UX coverage via **U1**, **U2**, **U3** (manual/exploratory). No new viewports; viewport tests ensure ramp behaves and displays correctly across the existing matrix.
