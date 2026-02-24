---
name: C5 — Game loop elapsed time and checkpoint
plan_id: DifficultySpawnRamp
chunk_id: C5
overview: GameScene tracks totalElapsedTime and checkpointElapsedTime; passes elapsedTimeAtSegmentStart into generateSegment; advance adds segment duration, revive restores checkpointElapsedTime, restart leaves elapsed unchanged.
---

# C5 — Game loop: track and pass elapsed time

**Parent plan:** [difficulty-spawn-rate-ramp.plan.md](../../difficulty-spawn-rate-ramp.plan.md)

## Scope

- **Goal:** Elapsed game time drives spawn rate; revive preserves difficulty; new run and play-again reset elapsed.
- **In scope:** GameScene totalElapsedTime, checkpointElapsedTime; startSegment / advanceToNextSegment / resumeFromCheckpoint / restartCurrentSegment; pass elapsedTimeAtSegmentStart to generateSegment.
- **Out of scope:** SegmentGenerator implementation (C4). Depends on C4 (generateSegment signature).

## Steps

1. **GameScene** [GameScene.swift](ios/CatRunner/Game/GameScene.swift): Add `private var totalElapsedTime: TimeInterval = 0` and `private var checkpointElapsedTime: TimeInterval = 0`.
2. **New run / first segment:** Ensure totalElapsedTime = 0 when starting segment 0 (e.g. in startSegment when currentSegmentIndex == 0, or at game start).
3. **startSegment:** When setting checkpoint (checkpointSegmentIndex, checkpointSegmentSeed), set `checkpointElapsedTime = totalElapsedTime`. Call `generateSegment(seed:segmentIndex:elapsedTimeAtSegmentStart: totalElapsedTime)`.
4. **advanceToNextSegment:** Before incrementing index and calling startSegment, `totalElapsedTime += currentSegment?.durationSeconds ?? 0`.
5. **resumeFromCheckpoint:** Set `totalElapsedTime = checkpointElapsedTime` before regenerating segment.
6. **restartCurrentSegment:** Do not change totalElapsedTime.
7. **Validation:** Play run → advance several segments → obstacle density increases; revive → next segment still hard; play again → first segment easy. Unit or E2E per test plans.

## Rollback

Remove totalElapsedTime, checkpointElapsedTime, and elapsedTimeAtSegmentStart from all call sites; remove advance/revive/restart elapsed logic.

## Confidence (per-chunk fidelity)

| Metric | Value | Note |
|--------|--------|------|
| Confidence (root cause) | N/A | Build chunk. |
| Confidence (solution path) | 94% | All branches (advance, revive, restart, new run) covered; rollback listed. |
