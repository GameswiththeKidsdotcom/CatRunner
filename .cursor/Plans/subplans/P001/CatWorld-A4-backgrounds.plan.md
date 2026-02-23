# CatWorld A4 — Backgrounds (sky.png, ground.png)

**Next hand off:** Execute after A3. When done, Master-Plan Lane B points to A5.

## Goal

Replace placeholder backgrounds with rooftop night: sky layer (night gradient + neon skyline), ground layer (roof ledges/platforms). Tileable or 9:16 viewport-wide.

## Steps

1. **sky.png** — Prompt: night sky background, city rooftop view; deep blues/purples; distant skyline with neon signs (pink, amber, cyan); soft 2D; 9:16 portrait or tileable horizontal. Save to `assets/backgrounds/sky.png`.
2. **ground.png** — Prompt: rooftop ledges or platforms, same night palette; foreground for 5 lanes; soft 2D; tileable horizontally. Save to `assets/backgrounds/ground.png`.
3. Optionally update `assets/backgrounds/README.md` with cat-world style note.

## Paths

- `assets/backgrounds/sky.png`, `ground.png` — Config: `backgrounds.sky`, `backgrounds.ground` (no change).

## Validation

- Both files exist; sky reads as night city; ground reads as roof ledges; style consistent.

## Rollback

- `git checkout -- assets/backgrounds/*.png`

## Confidence

- **Confidence (root cause):** N/A
- **Confidence (solution path):** High
