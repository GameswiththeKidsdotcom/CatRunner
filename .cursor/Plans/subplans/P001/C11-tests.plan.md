# C11 — Automated Tests

**Next hand off:** Implement C11 after C3–C8.

---

## Goal

Unit tests (obstacle lanes, spans, probabilities); gameplay simulation (jump/slide, clusters, power-ups); regression (deterministic runs); performance (FPS ≥60, memory ≤300MB); rules-to-win (viable lane, power-ups reachable).

## Steps

1. Unit tests: SegmentGenerator, LaneManager, ObstacleGenerator — lane validity (0–4), span ≤ lanes, prob sums.
2. Simulation tests: jump/slide execution; cluster placement; power-up in free lane only; no overlap.
3. Regression tests: same seed → same segment layout (assert equality of segment data).
4. Performance tests: run game loop or scene for N seconds; assert FPS ≥60, memory ≤300MB (or document thresholds).
5. Rules-to-win tests: every segment has ≥1 viable lane; power-ups spawn in free lanes only.

## Validation

- All tests pass in CI (`xcodebuild test`).
- Regression suite catches RNG or config change that breaks determinism.

## Rollback

- Disable failing test target; fix and re-enable.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
