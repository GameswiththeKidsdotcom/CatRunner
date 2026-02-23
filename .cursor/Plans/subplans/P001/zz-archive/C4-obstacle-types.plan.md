# C4 — Obstacle Types & Cluster Config

**Next hand off:** Implement C4 after C3.

---

## Goal

Three obstacle types (Passable, Instant-Fail, Slowdown); 1–3 lane spans; optional cluster config (2–3 grouped, linear or wide).

## Steps

1. Define obstacle types from config: passable, instantFail, slowdown; laneSpan [min, max].
2. Implement obstacle placement: spread (default) and optional cluster (clusterConfig.enabled, minGroupSize, maxGroupSize, layout).
3. Obstacles span 1–3 lanes per config; validate span ≤ 5 lanes.
4. Add placeholder assets under `assets/obstacles/` if not in C1.
5. Wire ObstacleGenerator to SegmentGenerator; each segment gets obstacles per config probabilities.

## Validation

- Unit tests: lane valid (0–4), span ≤ lanes, probabilities sum correctly.
- Clusters only when enabled; group size within config.

## Rollback

- Disable cluster config; spread-only.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
