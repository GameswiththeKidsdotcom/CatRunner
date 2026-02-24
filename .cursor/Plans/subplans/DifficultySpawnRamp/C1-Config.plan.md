---
name: C1 — Config (variant + schema)
plan_id: DifficultySpawnRamp
chunk_id: C1
overview: Add initialSpawnIntervalSeconds and spawnRateIncrementPerFiveSeconds to difficultyScaling in variant.json and schema; optional so existing configs remain valid.
---

**Next hand off (cut & paste) — Lane A:** Implement **DifficultySpawnRamp C1 (Config)**. Plan file: this file ([C1-Config.plan.md](.cursor/Plans/subplans/DifficultySpawnRamp/C1-Config.plan.md)). Add `initialSpawnIntervalSeconds` and `spawnRateIncrementPerFiveSeconds` to `difficultyScaling` in [config/schema.json](config/schema.json) and [config/default/variant.json](config/default/variant.json). Expected outcome: variant validates; existing variant load still works. Then continue C2→C6 per [DifficultySpawnRamp-spawn-rate-ramp.plan.md](DifficultySpawnRamp-spawn-rate-ramp.plan.md). At C6, delegate to Logic-Test per [difficulty-spawn-rate-ramp-test-plan.md](docs/testing/logic-test/difficulty-spawn-rate-ramp-test-plan.md).

---

# C1 — Config (variant.json + schema)

**Parent plan:** [DifficultySpawnRamp-spawn-rate-ramp.plan.md](DifficultySpawnRamp-spawn-rate-ramp.plan.md)

## Scope

- **Goal:** Config supports time-based spawn rate: initial interval 5s (rate 0.2/s), increment 0.1 per 5s game time.
- **In scope:** config/default/variant.json, config/schema.json (difficultyScaling branch).
- **Out of scope:** Engine decoding (C2), generator or game loop (C3–C5).

## Steps

1. **Schema** [config/schema.json](config/schema.json): Under `difficultyScaling.properties` add optional `initialSpawnIntervalSeconds` (number, minimum 1, description) and `spawnRateIncrementPerFiveSeconds` (number, minimum 0, description). Do not add to `required`.
2. **Variant** [config/default/variant.json](config/default/variant.json): Under `difficultyScaling` add `"initialSpawnIntervalSeconds": 5` and `"spawnRateIncrementPerFiveSeconds": 0.1`.
3. **Validation:** Existing variant load (e.g. iOS app or unit test that loads variant) still succeeds; JSON validates against schema if validator is used.

## Rollback

Remove the two keys from variant.json and the two properties from schema.json.

## Confidence (per-chunk fidelity)

| Metric | Value | Note |
|--------|--------|------|
| Confidence (root cause) | N/A | Config only; no root-cause investigation. |
| Confidence (solution path) | 95% | Optional fields; rollback clear; validation step stated. |
