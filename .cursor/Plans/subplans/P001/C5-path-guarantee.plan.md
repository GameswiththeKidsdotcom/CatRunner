# C5 — Path Guarantee (≥1 Viable Lane per Segment)

**Next hand off:** Implement C5 after C4.

---

## Goal

Ensure at least one viable lane per segment (unless forced hazard variant). Rules-to-win invariant.

## Steps

1. After placing obstacles for a segment, compute which lanes are blocked (e.g. by instant-fail or full-span obstacles).
2. If no lane is free, adjust placement: remove or shift one obstacle so at least one lane remains passable.
3. Unit test: for N seeds (e.g. 100), every segment has ≥1 viable lane.
4. Document "forced hazard" variant as optional override in VariantConfig (out of scope for default).

## Validation

- Exhaustive or sampled unit tests: every generated segment has ≥1 free lane.
- Regression: same seed still produces same segment after guarantee pass.

## Forced hazard (optional override, out of scope for default)

A future `VariantConfig` option (e.g. `engine.pathGuarantee: false` or `obstacles.forcedHazard: true`) could disable the path guarantee so segments may have zero viable lanes; out of scope for default config. See comment in `PathGuarantee.swift`.

## Rollback

- Fallback to spread-only; disable clusters.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
