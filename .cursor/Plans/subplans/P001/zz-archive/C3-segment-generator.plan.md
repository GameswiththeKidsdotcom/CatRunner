# C3 — SegmentGenerator (Seeded, Deterministic)

**Next hand off:** Implement C3 after C2; plan file for C3.

---

## Goal

Procedural segment generator: 2–3 second segments from VariantConfig; seeded RNG for deterministic runs.

## Steps

1. Add `SegmentGenerator` in `ios/CatRunner/Engine/`.
2. Load segment duration range from config (e.g. 2.0–3.0 seconds).
3. Use seeded RNG (e.g. `GKMersenneTwisterRandomSource` or custom `RandomNumberGenerator` with seed).
4. Generate segment length from config range; same seed → same length.
5. Place obstacles in spread layout (even distribution across segment); cluster logic deferred to C4.
6. Expose API: `generateSegment(seed: UInt64) -> Segment` (or equivalent).

## Validation

- Same seed + same config → identical segment layout (unit test).
- Segment duration within [2, 3] seconds (or config range).

## Rollback

- Revert SegmentGenerator; fall back to no procedural gen.

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
