# C11 — Automated Tests

**Next hand off:** C11 complete. Next: implement C12 (Agent updates, SPECIFICATION.md). Plan file: [.cursor/Plans/subplans/P001/C12-agents-spec.plan.md](C12-agents-spec.plan.md). Use builder or appropriate agent; update Master-Plan hand off after completion.

---

## Goal

Unit tests (obstacle lanes, spans, probabilities); gameplay simulation (jump/slide, clusters, power-ups); regression (deterministic runs); performance (FPS ≥60, memory ≤300MB); rules-to-win (viable lane, power-ups reachable).

## Steps

1. Unit tests: SegmentGenerator, LaneManager, ObstacleGenerator — lane validity (0–4), span ≤ lanes, prob sums.
2. Simulation tests: jump/slide execution; cluster placement; power-up in free lane only; no overlap.
3. Regression tests: same seed → same segment layout (assert equality of segment data).
4. Performance tests: run game loop or scene for N seconds; assert FPS ≥60, memory ≤300MB (or document thresholds).
5. Rules-to-win tests: every segment has ≥1 viable lane; power-ups spawn in free lanes only.

## Performance thresholds (documented)

- **FPS:** Target ≥60. Not asserted in CI (environment varies); use local/profile runs to verify.
- **Memory:** Target ≤300MB during normal gameplay. Not asserted in CI; use Instruments or local runs to verify.
- A performance test may run the game loop for N seconds and log FPS/memory for inspection; it does not fail the suite on threshold breach.

## Rollback

- Disable failing test target; fix and re-enable.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
