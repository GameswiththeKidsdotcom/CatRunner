# CatWorld A5 — Power-ups (speedBoost.png, shield.png)

**Next hand off:** Execute after A4. When done, Master-Plan Lane B points to A6.

## Goal

Replace power-up sprites with cat-world style: speedBoost (e.g. coffee cup or lightning bolt), shield (e.g. bubble or umbrella); soft glow; ~44–60 pt at 1x.

## Steps

1. **speedBoost.png** — Prompt: speed boost power-up icon, coffee cup or lightning bolt; soft glow; soft cozy 2D; ~132px; transparent. Save to `assets/powerups/speedBoost.png`.
2. **shield.png** — Prompt: shield power-up icon, bubble or umbrella; soft glow; same style and size. Save to `assets/powerups/shield.png`.
3. Optionally update `assets/powerups/README.md` with cat-world style note.

## Paths

- `assets/powerups/speedBoost.png`, `shield.png` — Config: `powerups.speedBoost`, `powerups.shield` (no change).

## Validation

- Both files exist; icons readable at small size; consistent style.

## Rollback

- `git checkout -- assets/powerups/*.png`

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** High
