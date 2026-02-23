# C6 — Power-up Spawner (Max 1, Free Lane Only)

**Next hand off:** Implement C6 after C5.

---

## Goal

Power-ups: max 1 active; types Speed Boost, Shield; spawn only in lanes with no obstacles; never overlap obstacles.

## Steps

1. Add `PowerUpSpawner` in `ios/CatRunner/Engine/`.
2. Read config: types (speedBoost, shield), maxActive: 1, spawnProbability, placementRule: freeLaneOnly.
3. Per segment: if no active power-up and roll < spawnProbability, choose a free lane (from path guarantee); spawn one power-up there.
4. Ensure power-up node does not overlap any obstacle in that segment.
5. Track active power-up; clear when collected or expired.

## Validation

- Unit/simulation: power-up only in free lane; max 1 active; never overlaps obstacle.
- Rules-to-win: power-ups reachable.

## Rollback

- Disable power-up spawn (probability 0).

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** N/A
