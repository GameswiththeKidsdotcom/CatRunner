---
name: C2 — Engine types and spawn rate
plan_id: DifficultySpawnRamp
chunk_id: C2
overview: DifficultyScalingConfig gains initialSpawnIntervalSeconds and spawnRateIncrementPerFiveSeconds; DifficultyScaler gains spawnRate(elapsedSeconds:). Decode from variant with defaults 5 and 0.1.
---

# C2 — Engine types and decoding + DifficultyScaler.spawnRate

**Parent plan:** [difficulty-spawn-rate-ramp.plan.md](../../difficulty-spawn-rate-ramp.plan.md)

## Scope

- **Goal:** Engine can read spawn-rate config and compute current spawn rate from elapsed time.
- **In scope:** EngineVariantConfig.swift (DifficultyScalingConfig, FullDifficultyScalingBranch decode), DifficultyScaler.swift (spawnRate(elapsedSeconds:)).
- **Out of scope:** Use of spawn rate in SegmentGenerator (C4); ObstacleGenerator (C3); GameScene (C5). C1 must be done so variant contains the keys (or defaults used when missing).

## Steps

1. **DifficultyScalingConfig** [EngineVariantConfig.swift](ios/CatRunner/Engine/EngineVariantConfig.swift): Add `initialSpawnIntervalSeconds: Double` and `spawnRateIncrementPerFiveSeconds: Double` to struct and init.
2. **FullDifficultyScalingBranch:** Add the two properties; decode with `decodeIfPresent` and use defaults 5.0 and 0.1 when missing. Pass into DifficultyScalingConfig in `decode(from:)`.
3. **DifficultyScaler** [DifficultyScaler.swift](ios/CatRunner/Engine/DifficultyScaler.swift): Add `func spawnRate(elapsedSeconds: TimeInterval) -> Double` returning `(1.0 / config.initialSpawnIntervalSeconds) + (elapsedSeconds / 5.0) * config.spawnRateIncrementPerFiveSeconds`, clamped to ≥ 0.
4. **Validation:** Unit test spawnRate(0)==0.2, spawnRate(5)==0.3, spawnRate(10)==0.4 with config (5, 0.1). Run existing DifficultyScalerTests and EngineVariantConfig load test.

## Rollback

Revert EngineVariantConfig and DifficultyScaler changes; remove new unit tests.

## Confidence (per-chunk fidelity)

| Metric | Value | Note |
|--------|--------|------|
| Confidence (root cause) | N/A | Build chunk; no defect root cause. |
| Confidence (solution path) | 95% | Decode defaults; spawnRate formula specified; validation test listed. |
