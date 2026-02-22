# C2 — VariantConfig Schema & Default JSON

**Next hand off:** Same as Master-Plan Lane B.

---

## Goal

Add `config/default/variant.json` and `config/schema.json` so engine and admin can load/validate config.

## Steps

1. Create `config/default/` directory.
2. Add `variant.json` with full schema: engine (lanes, playerStartLane, segmentDurationSeconds, jump/slide durations, baseSpeed, deterministicPhysics), obstacles (types, segmentDurationSeconds, clusterConfig), powerUps (types, maxActive, spawnProbability, placementRule), difficultyScaling, monetization.
3. Add `config/schema.json` (JSON Schema) for variant.json validation.
4. Add `config/default/assets.json`. Path keys and paths are defined only in [sprites-ui-assets.plan.md](sprites-ui-assets.plan.md) §6; use that plan as the spec. Do not duplicate the path list here.

## Validation

- JSON parses; schema validates variant.json.
- Admin or future loader can read `config/default/variant.json`.

## Rollback

- Remove `config/`; no code depends on it yet.

## Confidence

- **Confidence (root cause):** 95%
- **Confidence (solution path):** 95%
